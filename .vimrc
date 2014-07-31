"----------------------------------------------------------
"文字コード
if has('win32' || 'win64')
else
    set enc=utf-8
    set fenc=utf-8
    set fencs=utf-8,iso-2022-jp,euc-jp,cp932
endif
"----------------------------------------------------------
"フォント
if has('mac')
    set guifont=Ricty:h20
elseif has('win32' || 'win64')
else
    set guifont=Ricty\ 16
endif
"----------------------------------------------------------
"カラー
syntax on
hi clear
if exists("syntax_on")
    syntax reset
endif
set bg=dark
if has('gui_macvim')
    colorscheme macvim
else
    colorscheme black
endif
"---------------------------------------------------------
"ファイル
autocmd! BufRead,BufNewFile Gemfile,Podfile,*.podspec,*.yml set filetype=ruby
autocmd! BufRead,BufNewFile *.scala set filetype=scala
autocmd! BufRead,BufNewFile *.mm set filetype=objc
autocmd! BufRead,BufNewFile *.m set filetype=objc
autocmd! BufRead,BufNewFile *.h set filetype=objcpp
autocmd! BufRead,BufNewFile *.md set filetype=markdown
"---------------------------------------------------------
"ウィンドウ
if has('mac')
elseif has('win32' || 'win64')
else
    au GUIEnter * simalt ~x
endif
"---------------------------------------------------------
set hidden
set shortmess+=I       "起動時のメッセージをスキップ
set title              "タイトルをウインドウ枠に表示する
set history=100        "コマンド、検索パターンを100個まで履歴に残す
set showmatch          "括弧入力時の対応する括弧を表示
set matchtime=2        "対応する括弧の表示時間を2にする
set scrolloff=1000     "カーソル位置を画面の中心にする
set clipboard=unnamed  "ヤンクしたテキストをクリップボードに保存する
set ambiwidth=double   "ambiguous widthの文字がずれないようにする
"行
set number             "行番号を表示
set wrap               "折り返して次の行に表示する
set formatoptions+=mM  "テキスト挿入中の自動折り返しを日本語に対応させる
"インデント・空白
set smartindent        "自動インデント
set nolist             "タブや改行を表示しない(ex:$,^I)
set tabstop=4 softtabstop=4 shiftwidth=4    "タブ・インデント幅
set expandtab          "タブの代わりにスペースを使う
"保存時に行末の空白を除去する
fun! StripTrailingWhiteSpace()
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
autocmd bufwritepre * :call StripTrailingWhiteSpace()
"検索
set hlsearch           "検索結果文字列のハイライトを有効にする
set ignorecase         "検索の時に大文字小文字を区別しない
set smartcase          "検索の時に大文字が含まれている場合は区別して検索する
set noincsearch        "インクリメンタルサーチを使わない
set wrapscan           "検索時にファイルの最後まで行ったら最初に戻る
"コマンド・ステータスライン
set laststatus=2       "ステータスラインを常に表示
set statusline=%n\:%y%F\ \|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m%r%=<%l/%L:%p%%>  "ステータスラインに表示する情報の指定
set showcmd            "コマンドをステータス行に表示
set wildmenu           "コマンドライン補完を拡張モードにする
set textwidth=0        "入力されているテキストの最大
"カーソルライン
set cursorline
"シンタックスチェック
autocmd FileType ruby,eruby :map <C-n> <ESC>:!ruby -cW %<CR>
autocmd FileType javascript :map <C-n> <ESC>:!javascript -cW %<CR>
"最初のヤンクを連続でペースト
vnoremap <silent> <C-p> "0p<CR>
"サーチハイライトををESC二回で消す
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
"コメント文字列自動挿入やめる
augroup auto_comment_off
	autocmd!
	autocmd BufEnter * setlocal formatoptions-=ro
augroup END
"markdownに書かれているプログラミング言語をハイライト
let g:markdown_fenced_languages = [
\  'c',
\  'cpp',
\  'objc',
\  'objective-c=objc',
\  'coffee',
\  'css',
\  'erb=eruby',
\  'javascript',
\  'js=javascript',
\  'json=javascript',
\  'ruby',
\  'sass',
\  'xml',
\]
" :で始まるか、[で終わるか、]で終わるファイル名を作ってしまうのを防ぐ
autocmd BufWriteCmd :*,*[,*] call s:write_check_typo(expand('<afile>'))
function! s:write_check_typo(file)
    let prompt = "possible typo: really want to write to '" . a:file . "'?(y/n):"
    let input = input(prompt)
    if input =~? '^y\(es\)\=$'
        execute 'write'.(v:cmdbang ? '!' : '') a:file
    endif
endfunction

"**********************************************************
"                        プラグイン
"**********************************************************
"---------- neobundle ----------
set nocompatible
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'https://github.com/Shougo/vimproc.git'
NeoBundle 'https://github.com/Shougo/neocomplcache.git'
NeoBundle 'https://github.com/Shougo/unite.vim.git'
NeoBundle 'https://github.com/tpope/vim-surround.git'
NeoBundle 'https://github.com/scrooloose/syntastic.git'
NeoBundle 'https://github.com/kannokanno/previm.git'
NeoBundle 'https://github.com/tyru/open-browser.vim.git'
NeoBundle 'https://github.com/tyru/urilib.vim.git'
NeoBundle 'https://github.com/kenzan8000/taglist.vim.git'
NeoBundle 'https://github.com/rickard/project.vim.git'
NeoBundle 'https://github.com/vim-scripts/smartchr.git'
NeoBundle 'https://github.com/tsaleh/vim-align.git'
NeoBundle 'https://github.com/vim-scripts/ref.vim.git'
NeoBundle 'https://github.com/Lokaltog/vim-powerline.git'
NeoBundle 'https://github.com/Lokaltog/vim-easymotion.git'
NeoBundle 'b4b4r07/autocdls.vim'
" C,C++,Objective-C
NeoBundleLazy 'https://github.com/tokorom/cocoa.vim.git', 'syntax-only', {'autoload': {'filetypes': ['objc']}}
NeoBundleLazy 'https://github.com/tokorom/ctrlp-docset.git', {'autoload': {'filetypes': ['objc']}}
NeoBundleLazy 'https://github.com/tokorom/clang_complete.git', 'for-ios', {'autoload': {'filetypes': ['c', 'cpp', 'objc']}}
NeoBundleLazy 'https://github.com/tokorom/clang_complete-getopts-ios.git', {'autoload': {'filetypes': ['objc']}}
" Swift
NeoBundle 'https://github.com/toyamarinyon/vim-swift.git'
" Ruby
NeoBundle 'https://github.com/rhysd/endwize.vim.git'
NeoBundle 'https://github.com/tpope/vim-haml'
NeoBundle 'https://github.com/kchmck/vim-coffee-script'
" HTML
NeoBundle 'https://github.com/mattn/zencoding-vim.git'
NeoBundle 'https://github.com/taichouchou2/html5.vim'
" CSS
NeoBundle 'https://github.com/hail2u/vim-css3-syntax'
" JavaScript
NeoBundle 'https://github.com/taichouchou2/vim-javascript'
" Markdown
NeoBundle 'https://github.com/tpope/vim-markdown'
filetype plugin indent on
NeoBundleCheck
"---------- neocomplcache ----------
let g:neocomplcache_enable_at_startup=1           "neocomplcacheを有効にする
let g:neocomplcache_enable_smart_case=1           "smartcaseを有効にする
let g:neocomplcache_enable_underbar_completion=1  "underbarを有効にする
let g:neocomplcache_min_keyword_length=3
let g:neocomplcache_min_syntax_length=3
setlocal omnifunc=syntaxcomplete#Complete
"辞書
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'    : '',
    \ 'cpp'        : $HOME . '/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME . '/.vim/dict/javascript.dict',
    \ 'objc'       : $HOME . '/.vim/dict/objc.dict',
    \ 'objcpp'     : $HOME . '/.vim/dict/objcpp.dict',
    \ }
"コードスニペット
let g:neocomplcache_snippets_dir=$HOME . '/.vim/snippets'
if has('mac')
    "neocomplcache + rsense
    let g:rsenseHome = '/usr/local/Cellar/rsense/0.3'
    let g:rsenseUseOmniFunc=1
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

    "neocomplcache + clang_complete
    if !exists('g:neocomplcache_force_omni_patterns')
        let g:neocomplcache_force_omni_patterns = {}
    endif
    let g:neocomplcache_force_overwrite_completefunc=1
    let g:neocomplcache_force_omni_patterns.c =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_force_omni_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplcache_force_omni_patterns.objc =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_force_omni_patterns.objcpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:clang_complete_auto=0
    let g:clang_auto_select=0
    let g:clang_use_library=0
endif
"キーマッピング
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
"---------- autocdls.vim ----------
nmap <Leader>ls <Plug>(autocdls-dols)
"---------- vim-swift ----------
"---------- endwize ----------
"neocomplcache, endwizeキーマッピング
autocmd FileType ruby imap <buffer> <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup()."\<CR>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd"
"---------- smartchr ----------
"---------- surround ----------
"---------- align ----------
vnoremap :al :Align
let g:Align_xstrlen=3
"---------- syntastic ----------
let g:syntastic_enable_signs=0
let g:syntastic_auto_loc_list=2
"---------- zencoding ----------
"codaのデフォルトと一緒にする
imap <C-E> <C-Y>,
let g:user_zen_leader_key = '<C-Y>'
"言語別に対応させる
let g:user_zen_settings = {
    \  'lang' : 'ja',
    \  'html' : {
    \    'filters' : 'html',
    \    'indentation' : '    '
    \  },
    \  'css' : {
    \    'filters' : 'fc',
    \  },
    \}
"---------- powerline ----------
"---------- vim-easymotion ----------
let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
let g:EasyMotion_leader_key="'"
let g:EasyMotion_grouping=1
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=blue
"---------- open-browser ----------
"カーソル下のURLをブラウザで開く
nmap <Leader>o <Plug>(openbrowser-open)
vmap <Leader>o <Plug>(openbrowser-open)
"ググる
nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>
"---------- urilib ----------
"---------- project ----------
"ファイルが選択されたら、ウィンドウを閉じる
let g:proj_flag="imstc"
"<Leader>p,<Leader>Pでトグルを開閉する
nmap <silent> <Leader>P <Plug>ToggleProject
nmap <silent> <Leader>p :Project<CR>
"---------- taglist ----------
set tags=tags
let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_Exit_OnlyWindow=1
map <silent> <leader>T :TlistToggle<CR>
"---------- ref ----------
nnoremap :ref :Ref
"---------- unite ----------
