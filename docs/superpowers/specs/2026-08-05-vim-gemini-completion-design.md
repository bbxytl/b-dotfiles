# Vim Gemini 自动补全插件设计

- Creator: tianlong
- Date: 2026-08-05
- Repo: `b-dotfiles`（`~/mydotfiles/b-dotfiles`）
- 涉及目录：`b-vim/config/gemini-complete/`（新增）、`b-vim/config/vimrc.bundles_complex`（接入点）

## 背景与目标

GitHub Copilot 已被组织禁用。原有 `vimrc.bundles_complex` 中 Copilot 相关配置（`Plug 'github/copilot.vim'`、`SmartTab()` 里的 `copilot#Accept()` 调用、`<Leader>cp` 面板映射）已全部注释，`SmartTab` 的 Tab 键回退到普通输入，未产生运行时报错。

目标：用 Gemini API 实现一个功能对等的"打字时自动出现灰色建议、Tab 接受"的补全体验，且**不引入 Neovim**——调研确认社区目前没有成熟的纯 Vim（非 Neovim）版本的 Gemini/Claude ghost-text 补全插件，`minuet-ai.nvim` 等生态方案清一色要求 Neovim 0.10+ 的 Lua/虚拟文本 API。因此选择自行实现。

## 环境约束（已核实）

- Vim 9.2（Homebrew 编译），巨型版本，包含 `+job +channel +timers +popupwin +textprop +python3`——具备做 popup 悬浮渲染 + 异步网络请求所需的全部原生能力，不需要外部依赖（`python3` 特性存在但本设计不使用，纯 Vim9script + 外部 `curl` 进程实现）
- `curl` 已安装（`/opt/homebrew/bin/curl`）
- 环境变量 `GEMINI_API_KEY` 已配置，插件默认直接读取，无需用户额外设置
- 现有 `SmartTab()` 函数（`vimrc.bundles_complex`）维护 Tab 键的优先级路由链：UltiSnips 展开 > YCM 补全菜单 > （原 Copilot，现改为 Gemini 建议）> 普通 Tab，插件需接入这条链而非新增独立按键

## 架构决策：Ghost Text 渲染方式

评估过三种做法：

| 方案 | 做法 | 结论 |
|---|---|---|
| A（采用） | `popup_create()` 悬浮渲染灰色建议，不改动 buffer 真实内容，Tab 接受时才真正插入 | 与 `github/copilot.vim` 自身在 classic Vim 下的实现方式一致，有先例、无副作用 |
| B | 建议展示在独立预览窗口/命令行区，显式命令接受 | 实现简单但不是"边打字边出现"的体验，偏离需求，仅作为 A 方案不可行时的降级选项 |
| C | 每次都把候选文本真实插入 buffer 并高亮伪装成 ghost text，不接受则删除 | 会真实触发 `TextChangedI`，扰乱 YCM 补全弹窗与 UltiSnips 展开检测判断，且污染 undo 历史；不采用 |

**采用方案 A。**

## 目录结构

新增独立本地插件目录，走标准 Vim 插件包结构（`plugin/` + `autoload/`），通过 `rtp+=` 挂载，不经 vim-plug 管理（体量小、无编译产物、随 dotfiles 一起进 git，对齐仓库里"自己写的东西直接内嵌"而非"引入的重量级第三方件走 `$VIM_TMP_PATH/bundle/`"的既有区分）：

```
b-vim/config/gemini-complete/
├── plugin/
│   └── gemini_complete.vim     " 入口：命令注册、autocmd 挂载、默认配置兜底（一次性 source，非 autoload）
└── autoload/
    └── gemini_complete.vim     " Vim9script 主体：防抖计时器、job 控制、prompt 拼装、
                                 "   curl 请求（临时 config 文件传 key）、JSON 解析、
                                 "   popup 渲染、Accept()/Dismiss()
```

`vimrc.bundles_complex` 接入点（替换当前注释掉的 Copilot 区块位置）：

```vim
set rtp+=$VIM_CONFIG_PATH/gemini-complete
```

## 配置项（均可在 `~/.vimrc.local` 覆盖，不写死）

```vim
g:gemini_complete_enabled          " 默认 1，:GeminiToggle 命令可运行时切换
g:gemini_complete_api_key          " 默认取 $GEMINI_API_KEY
g:gemini_complete_model            " 默认 'gemini-2.5-flash-lite'（可配置，用户可换 'gemini-2.5-flash' 等）
g:gemini_complete_debounce_ms      " 默认 400
g:gemini_complete_context_before   " 默认 60（光标前取多少行作为 prompt 上文）
g:gemini_complete_context_after    " 默认 20（光标后取多少行，用于让模型理解后续代码结构）
g:gemini_complete_max_lines        " 默认 12（建议最多渲染多少行，避免 popup 过大）
g:gemini_complete_excluded_ft      " 默认 ['gitcommit', 'markdown', 'text']，纯文字场景不触发请求
```

## 请求流程

1. `TextChangedI` 触发 → 取消上一个未到期的 debounce 定时器（`timer_stop`）+ 取消上一个还未返回的 curl job（`job_stop`），避免旧建议在新输入后才姗姗来迟地渲染出来
2. 静默等待 `g:gemini_complete_debounce_ms` 无新输入后，真正调度请求；调度前二次检查：`g:gemini_complete_enabled` 为真、当前 filetype 不在排除列表、仍处于 insert 模式
3. 取光标前 `context_before` 行 + 光标后 `context_after` 行 + 当前 filetype，拼成请求 prompt（明确要求模型只续写代码、不要解释性文字）
4. 写入一个权限 `0600` 的临时 curl config 文件（`curl -K <tmpfile>`），内容包含 `header = "x-goog-api-key: ..."`、`url = "..."`、请求体；**不把 key 拼进命令行参数**（避免短暂出现在 `ps aux` 中被同机其他进程看到）；`job_start` 异步执行，`exit_cb` 里读完 stdout 后立即删除临时文件
5. `exit_cb` 中用内置 `json_decode()` 解析响应，取 `candidates[0].content.parts[0].text`；剥离常见的 ` ```lang ... ``` ` 代码围栏；按行截断到 `max_lines`；存入 buffer-local `b:gemini_suggestion`（行列表）与起始位置
6. 调用渲染函数，用 `popup_create()` 在光标处画出多行灰色（链接 `Comment` 高亮组）浮层

## 接入 SmartTab

```vim
function! s:SmartTab()
    call UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return ""
    endif
    if pumvisible()
        return "\<C-n>"
    endif
    let l:sug = gemini_complete#Accept()
    if !empty(l:sug)
        return l:sug
    endif
    return "\<Tab>"
endfunction
```

`gemini_complete#Accept()`：若有 pending 建议，关闭 popup、把首行插入光标处、其余行用 `append()` 插入到下方并将光标移动到插入内容末尾，返回空字符串（占位，避免 `SmartTab` 的 `<expr>` 映射再额外发送一个真实 Tab）；若无 pending 建议，返回空字符串，`SmartTab` 走到 `return "\<Tab>"` 分支，行为与当前完全一致。

优先级链：snippet 展开 > YCM 补全菜单 > Gemini 建议接受 > 普通 Tab——与当年 Copilot 所处位置完全对应，肌肉记忆不变。

## Dismiss（建议消失）

以下任一事件触发时关闭 popup 并清空 `b:gemini_suggestion`：

- `InsertLeave`
- `CursorMovedI`（且不是 Accept 自身插入文本导致的光标移动——用一个内部标志位区分）
- 新一轮 debounce 定时器即将调度前（自然覆盖旧 popup，无需额外判断）

## 失败处理（fail-soft，绝不打断输入）

- 网络失败 / 非 200 / JSON 解析失败 → 静默清空 pending 状态，不弹错误框、不阻塞编辑
- 连续失败时最多做节流的一条 `echom` 提示（例如每 60 秒最多提示一次），避免刷屏
- curl job 异常退出（非 0 exit code）同样静默处理，仅记录到一个可选的 debug 日志变量（`g:gemini_complete_debug` 默认关闭）

## v1 明确不做（YAGNI，跑通主路径再迭代）

- 不支持建议轮换（Copilot 的上一条/下一条），只展示模型返回的第一条
- 不做流式渲染，等 Gemini 完整返回后一次性展示
- 不做多模型并行或自动降级，只按配置调用一个模型
- 不做跨 buffer / 跨 session 的建议缓存

## 测试计划

**可自动化部分**：prompt 拼装、JSON 解析与代码围栏剥离、建议行数截断——这几个是纯逻辑函数（输入输出可预测，不依赖真实网络/UI），会写成独立的 autoload 函数，用 `vim -Nu NONE` 无头模式跑断言脚本验证。

**无法自动化、需要手动验证的部分**（如实说明限制，不假装能脚本化模拟真实按键时序与浮层渲染）：

- [ ] 在真实 insert 模式下停止打字约 400ms 后，popup 是否正确出现在光标附近
- [ ] Tab 键在有建议时是否正确插入建议内容（含多行场景的缩进是否正确）
- [ ] Tab 键在无建议时是否仍退化为普通 Tab（不影响原有行为）
- [ ] 继续打字或按 Esc 离开 insert 模式时，popup 是否正确消失、不留残影
- [ ] 与 YCM 补全菜单同时触发时，`pumvisible()` 分支是否仍优先生效，不产生冲突
- [ ] 与 UltiSnips 的 snippet 展开（`<c-j>`/`<c-k>` 跳转）是否互不干扰
- [ ] `gitcommit`/`markdown`/`text` 等排除的 filetype 下确认不发起请求（可配合 `g:gemini_complete_debug` 查看是否有 job 被调度）
- [ ] `:GeminiToggle` 命令能否正确开关整个功能
- [ ] 断网或 API key 失效时，是否只是安静地没有建议，不产生弹窗打断或频繁报错刷屏

以上手动项由用户（tianlong）在真实 Vim 会话中试用确认；我会在实现完成后给出具体操作步骤清单，配合上述 checklist 逐条过一遍。
