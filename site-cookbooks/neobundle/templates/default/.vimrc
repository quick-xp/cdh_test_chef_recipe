scriptencoding utf-8
set nocompatible

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" NeoBUndleを更新するための設定
NeoBundle 'Shougo/neobundle.vim'

" vim 設定
set number

" plugin
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'


" ctagsの非同期生成
NeoBundle 'alpaca-tc/alpaca_tags'
" alpaca_tags 設定
augroup AlpacaTags
	autocmd!
	if exists(':Tags')
		autocmd BufWritePost Gemfile TagsBundle
		autocmd BufEnter * TagsSet
		" 毎回保存と同時更新する場合はコメントを外す
		autocmd BufWritePost * TagsUpdate
	endif
augroup END

" Powerline
NeoBundle 'alpaca-tc/alpaca_powertabline'
NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}


filetype plugin indent on

