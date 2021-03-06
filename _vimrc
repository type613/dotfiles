" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
" Last Change: 20-Feb-2009.
" Maintainer:  MURAOKA Taro <koron@tka.att.ne.jp>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 0 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
"source $VIMRUNTIME/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
"
" ハイライトで検索
set hlsearch
nohlsearch

" インクリメンタル検索
set incsearch

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=8
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 日本語整形スクリプト(by. 西岡拓洋さん)用の設定
let format_allow_over_tw = 1	" ぶら下り可能幅

" 高度なインデント
set smartindent

" 空白文字をいいかんじで挿入する
set smarttab

" Vim を終了しても undo の記録を残す
set undofile undodir=~/.vimundo
" }}}

" 不可侵文字を可視化
set list
set listchars=tab:>\ "

" 行番号を表示 (相対)
"set number relativenumber

" 最低でも上下に表示する行数
set scrolloff=5

" 入力したコマンドを画面下に表示
set showcmd

" タブページのラベルを常に表示
set showtabline=2

" 長い行を @ にさせない
set display=lastline

" 埋める文字
set fillchars=stl:\ ,stlnc:\ ,vert:\|,fold:-,diff:-

" vim の継続行(\)のインデント量を 0 にする
let g:vim_indent_cont = 0


"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set nonumber
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup


"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let uname = system('uname')
  if uname =~? "linux"
    set term=builtin_linux
  elseif uname =~? "freebsd"
    set term=builtin_cons25
  elseif uname =~? "Darwin"
"    set term=beos-ansi
"  else
    set term=builtin_xterm
  endif
  unlet uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

" Copyright (C) 2007 KaoriYa/MURAOKA Taro

so $VIMRUNTIME/mswin.vim

"Custom Settting
set sw=8
if &t_Co > 1
  syntax on
endif
set showcmd
set showmatch
set matchtime=2
set wildmenu
set textwidth=0
set wrap
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/


set vb t_vb=


se backupext=.bak
"se nohls

nmap <C-p> :bp<CR>
nmap <C-n> :bn<CR>



" ### dein ### {{{
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

"dein
call dein#add('Shougo/dein.vim')

"ag.vim
"先にbrew install agしておく
"call dein#add('rking/ag.vim')

"previm
"MarkDownファイルを開いて、:PrevimOpenするとブラウザで開く
"call dein#add('kannokanno/previm')
"open-browser.vim
"call dein#add('tyru/open-browser.vim')

"Unite
call dein#add('Shougo/unite.vim')
" 入力モードで開始する
 let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')

"ヘルプの日本語化プラグイン
call dein#add('vim-jp/vimdoc-ja')
set helplang=ja,en

"カラースキーム
call dein#add('junegunn/seoul256.vim')

"vim-markdown
call dein#add('tpope/vim-markdown')
au BufRead,BufNewFile *.md set filetype=markdown

"NERDTree
call dein#add('scrooloose/nerdtree')
"\eでファイルブラウザを開く
map <silent> <leader>e :NERDTreeToggle<cr>

"taglist
"call dein#add('vim-scripts/taglist.vim')
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
map <silent> <leader>E :TlistToggle<cr>

"tagbar
"call dein#add('majutsushi/tagbar')

""caw
"\cでコメントアウト/インを切り替える。
call dein#add("tyru/caw.vim")
nmap <Leader>c <Plug>(caw:i:toggle)
vmap <Leader>c <Plug>(caw:i:toggle)

"vim-fugitive
call dein#add('tpope/vim-fugitive')

"vcscommand
call dein#add('vcscommand.vim')

"diffchar
call dein#add('rickhowe/diffchar.vim')
"vimdiffを起動した際自動的に単語単位の差分を有効にする
if &diff
  augroup enable_diffchar
    autocmd!
    autocmd VimEnter * execute "%SDChar"
  augroup END
endif
let g:DiffUnit = "Word1"
let g:DiffUpdate = 1

call dein#end()

"プラグインがインストールされているかチェック
if dein#check_install()
  call dein#install()
endif


" ステータスラインに表示する情報の指定
set statusline=%n\:%f\ \[%{(&fenc!=''?&fenc:&enc).'\]\['.&ff.'\]'}%y%{fugitive#statusline()}%m%r%=<%l/%L:%p%%>
" ステータスラインの色
highlight StatusLine   term=NONE cterm=NONE ctermfg=black ctermbg=white

"vimdiff設定
"diffupdateをdpで実施
map du :diffupdate<CR>


filetype plugin indent on


" }}}

colorscheme default

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_color_change_perdent = 10
let g:indent_guides_guide_size = 1
"let g:indent_guide_auto_colors = 0
hi IndentGuideOdd ctermbg=black
hi IndentGuideEven ctermbg=darkgrey
"autocmd VimEnter,Colorscheme * : hi IndentGuideOdd guibg=red ctermbg=3
"autocmd VimEnter,Colorscheme * : hi IndentGuideEven guibg=green ctermbg=4

if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	\ | wincmd p | diffthis
endif

"バッファリストは:lsか:buffersで確認
" ノーマルモードでbpでバッファリストのひとつ前のバッファを開く
"nnoremap <silent>bp :bprevious<CR>
" ノーマルモードでbnでバッファリストの次のバッファを開く
"nnoremap <silent>bn :bnext<CR>
" ノーマルモードでbbで直前のバッファを開く
"nnoremap <silent>bb :b#<CR>

"Java用ハイライト追加
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1



