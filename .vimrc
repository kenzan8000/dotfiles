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
"" スペルチェック
set spelllang=en,cjk
fun! s:SpellConf()
  redir! => syntax
  silent syntax
  redir END
  set spell
  if syntax =~? '/<comment\>'
    syntax spell default
    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent containedin=Comment contained
  else
    syntax spell toplevel
    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent
  endif
  syntax cluster Spell add=SpellNotAscii,SpellMaybeCode
endfunc
augroup spell_check
  autocmd!
  autocmd BufReadPost,BufNewFile,Syntax *.md call s:SpellConf()
augroup END
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
" 自動的にディレクトリを作成する
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}
