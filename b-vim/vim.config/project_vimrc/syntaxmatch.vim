
" saving syntax to a file named by predefined name
function! syntaxmatch#saveSyntax()
  let l:syntax = s:getSyntaxCommands()
  let l:syntaxfile = s:getSyntaxFile()
  
  " echo 'Syntax file is: ' . l:syntaxfile
  if filewritable(s:getSyntaxDir()) != 2
    echoe '[syntaxmatch] Cannot write syntax file ' . l:syntaxfile . ' to directory ' . s:getSyntaxDir() . ' as not writable'
    return
  endif

  if empty(l:syntax)
    " echo '[syntaxmatch] No syntax that could be saved for file ' . s:getCurFile()
    return
  endif

  " echo 'Syntax file is: ' . l:syntaxfile . ' and syntax is ' . join(l:syntax, '|')
  execute 'redir! >' . l:syntaxfile
  silent! echo join(l:syntax, "\n")
  execute 'redir END'
endfunction

" returning output of command 'syntax' as a string
function! syntaxmatch#getSyntax()
  execute 'redir => l:cursyntax'
  silent! execute 'syntax'
  execute 'redir END'
  return l:cursyntax
endfunction

" loading content of a file and executing each line as command
function! syntaxmatch#syntaxFileExecute()
  let l:filePath = s:getSyntaxFile()
  " if syntax file does not exist we do nothing
  if !s:isFileExists(l:filePath)
    return
  endif

  echo l:filePath
  let l:filecontent = readfile(l:filePath)
  for l:line in l:filecontent
    let l:line_stripped = s:strip(l:line)
    if l:line_stripped =~ '^syntax match'
      execute l:line
    elseif empty(l:line_stripped)
      " skip empty lines
      continue
    else
      echoe '[syntaxmatch] Cannot execute line "' . l:line . '" as it is not a syntax match command'
    endif
  endfor
endfunction



"
" ==================================
" ===== Script local functions =====
" ==================================
"

"
" converts syntax processed to dictionary to list of commands
function! s:getSyntaxCommands()
  let l:syntax_dict = s:getSyntaxAsDict()
  let l:syntax = []
  for [l:color, l:patterns] in items(l:syntax_dict)
    for l:pattern in l:patterns
      let syntax += ['syntax match ' . l:color . ' ' . l:pattern]
    endfor
  endfor
  " echo l:syntax
  return l:syntax
endfunction

"
" taken output of 'syntax' command and convert it to dictionary
" {color: [pattern1, pattern2, ...], color2: [...]}
function! s:getSyntaxAsDict()
  let l:syntax = syntaxmatch#getSyntax()
  " what are strings which are output of 'syntax' command
  " that will be skipped from processing
  let l:skip_patterns = ['---']

  " storing matches in way of {color_name:[pattern1, pattern2, ...]}
  let l:match_jar = {}

  " going through output of 'syntax' command - split by end of line
  for l:syntax_line in split(l:syntax, '\n')
    if s:isMatch(syntax_line, skip_patterns)
      continue
    endif

    "" going throug file and taking info about 'match' commands
    " line starts with non-whitespace character - defines a color
    if l:syntax_line =~ '^\S\+'
      let l:match_color = matchstr(l:syntax_line, '^\S\+')
    endif
    " if line contains word 'match' in expected context then process further
    if l:syntax_line =~ '  match \|x match '
      " pattern \zs means that matchstr will return the match after this \zs
      "  meaning that word 'match' won't be in returned string content
      let l:match_pattern = matchstr(l:syntax_line, 'match \zs.*')
      let l:match_pattern = s:strip(l:match_pattern)

      if !exists('l:match_color')
        echoe '[syntaxmatch] Syntax line "' . l:syntax_line . '" cannot be processed as matched color does not exist'
        continue
      endif

      " echo "color: " . l:match_color . ", pattern: " . l:match_pattern
      if !has_key(l:match_jar, l:match_color)
        let l:match_jar[l:match_color] = [l:match_pattern]
      else
        " item is added to to the list only if does not exist already
        if index(l:match_jar[l:match_color], l:match_pattern) == -1
          let l:match_jar[l:match_color] += [l:match_pattern]
        endif
      endif
    endif
  endfor
  return l:match_jar
endfunction

"
" says if string is in a list
function! s:isMatch(string, list)
  for l:stringItem in a:list
    if a:string =~ stringItem
      return 1
    endif
  endfor
  return 0
endfunction

"
" strip spaces from string (trimming)
function! s:strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

"
" getting path to current file and adding prefix and sufix
function! s:getSyntaxFile()
  let l:curdir = s:getSyntaxDir()
  let l:curfile = s:getCurFile()
  let l:syntaxfile = l:curdir . '/' . '.' . l:curfile . '.syntax' 
  return l:syntaxfile
endfunction

" return name of the current file
function! s:getCurFile()
  return expand("%:t")
endfunction

" getting path to current file and return its directory
function! s:getSyntaxDir()
  return expand("%:p:h")
endfunction

" says if file exists and we can read from it
function! s:isFileExists(filename)
  if filereadable(a:filename)
    return 1
  endif
  return 0
endfunction

