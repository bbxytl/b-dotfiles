#!/bin/bash
# ====================================================
#   Copyright (C)2018 All rights reserved.
#
#   Author        : bbxytl
#   Email         : bbxytl@gmail.com
#   File Name     : install-go-tools.sh
#   Last Modified : 2018-10-14 16:06
#   Describe      :
#
# ====================================================

# test - ipad

mkdir -p ~/go/src/golang.org/x
cd ~/go/src/golang.org/x/
git clone --depth 1 --recursive https://github.com/golang/tools
git clone --depth 1 --recursive https://github.com/golang/lint
git clone --depth 1 --recursive https://github.com/golang/net
git clone --depth 1 --recursive https://github.com/golang/time
git clone --depth 1 --recursive https://github.com/golang/sys
git clone --depth 1 --recursive https://github.com/golang/text
git clone --depth 1 --recursive https://github.com/golang/image
git clone --depth 1 --recursive https://github.com/golang/debug
git clone --depth 1 --recursive https://github.com/golang/crypto
git clone --depth 1 --recursive https://github.com/golang/sync
git clone --depth 1 --recursive https://github.com/golang/oauth2

# google.golang.org
# mkdir -p ~/go/src/google.golang.org
# cd ~/go/src/google.golang.org/
# git clone --depth 1 --recursive https://github.com/googleapis/google-api-go-client api

# github
mkdir -p ~/go/src/github.com; cd ~/go/src/github.com
git clone --depth 1 --recursive https://github.com/kisielk/errcheck ./kisielk/errcheck; go install ./kisielk/errcheck
git clone --depth 1 --recursive https://github.com/mdempsky/gocode ./mdempsky/gocode; go install ./mdempsky/gocode
git clone --depth 1 --recursive https://github.com/zmb3/gogetdoc ./zmb3/gogetdoc; go install ./zmb3/gogetdoc
git clone --depth 1 --recursive https://github.com/go-delve/delve/cmd/dlv ./go-delve/delve/cmd/dlv; go install ./go-delve/delve/cmd/dlv
git clone --depth 1 --recursive https://github.com/josharian/impl ./josharian/impl; go install ./josharian/impl
git clone --depth 1 --recursive https://github.com/golangci/golangci-lint/cmd/golangci-lint ./golangci/golangci-lint/cmd/golangci-lint; go install ./golangci/golangci-lint/cmd/golangci-lint
git clone --depth 1 --recursive https://github.com/jstemmer/gotags ./jstemmer/gotags; go install ./jstemmer/gotags
git clone --depth 1 --recursive https://github.com/fatih/gomodifytags ./fatih/gomodifytags; go install ./fatih/gomodifytags
git clone --depth 1 --recursive https://github.com/koron/iferr ./koron/iferr; go install ./koron/iferr
git clone --depth 1 --recursive https://github.com/klauspost/asmfmt/cmd/asmfmt ./klauspost/asmfmt/cmd/asmfmt; go install ./klauspost/asmfmt/cmd/asmfmt
git clone --depth 1 --recursive https://github.com/alecthomas/gometalinter ./alecthomas/gometalinter; go install ./alecthomas/gometalinter

# go install
cd ~/go/src/golang.org/x/lint/golint; go install ./
cd ~/go/src/golang.org/x/tools/cmd/gorename; go install ./
cd ~/go/src/golang.org/x/tools/cmd/goimports; go install ./
cd ~/go/src/golang.org/x/tools/cmd/guru; go install ./
cd ~/go/src/golang.org/x/tools/cmd/gopls; go install ./
cd ~/go/src/golang.org/x/tools/oauth2/google; go install ./

