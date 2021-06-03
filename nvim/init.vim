" Case insensistive
set ignorecase

" Set the completion mode to match the longest common part and show a
" menu for all the alternatives. Only in command mode.
set wildmode=list:longest

" Ignore case when completing files and directories. Only in command mode.
set wildignorecase

" Sets the size of the indentations.
set shiftwidth=4

" Uses spaces instead of tabs.
set expandtab

" Custom digraphs.
digraph bn 8469  " ℕ
digraph l- 8866  " ⊢
digraph l= 8872  " ⊨

" Unicode abbreviations.
iabbrev _FA ∀
iabbrev _TE ∃
iabbrev _dP ∂
iabbrev _-> →
iabbrev _<- ←
iabbrev _<> ↔
iabbrev _AN ∧
iabbrev _OR ∨
iabbrev _NO ¬
iabbrev _+- ±
" iabbrev _-T ⊥
iabbrev _bn ℕ
iabbrev _OK ✓
iabbrev _XX ✗
iabbrev _:- ⊢
iabbrev _:= ⊨
iabbrev _y* η
" iabbrev _/0 ∅
iabbrev _RT √
iabbrev _00 ∞
iabbrev _?- ≃
iabbrev _?= ≅
" iabbrev _?2 ≈
iabbrev _=? ≌
iabbrev _<* ≪
iabbrev _*> ≫
iabbrev _0u ☺
iabbrev _0U ☻
" iabbrev _(U ∩
" iabbrev _)U ∪
" iabbrev _(C ⊂
" iabbrev _)C ⊃
" iabbrev _(_ ⊆
" iabbrev _)_ ⊇
iabbrev _(- ∈
iabbrev _-) ∋
" iabbrev _/0 ∅
" iabbrev _=3 ≡
iabbrev _!= ≠
iabbrev _=< ≤
iabbrev _>= ≥
iabbrev _i* ι
iabbrev _r* ρ
iabbrev _l* λ
iabbrev _a* α
iabbrev _b* β
iabbrev _t* τ
iabbrev _p* π
iabbrev _h* θ
iabbrev _d* δ
iabbrev _f* φ
iabbrev _s* σ
iabbrev _q* ψ
iabbrev _w* ω
" iabbrev _*X ×
iabbrev _Ob ∘
iabbrev _ae æ
iabbrev _lub ⊔

" Abbreviations
iabbrev _ae Andreas Edlund
iabbrev _mail andreas@myrstacken.net

" Set <leader>
let mapleader = " "

" Set up some useful keyboard mappings
nnoremap <F2> :e scratch<CR>
nnoremap <F4> :!snap<CR><CR>
nnoremap <F5> :w<CR>
nnoremap <F6> :Files<CR>
nnoremap <F7> :Tags<CR>
nnoremap <F8> :Ag<CR>
nnoremap <F9> :Lines<CR>

" Set the format of the status line.
set statusline=%<%f\ %h%m%y%r%=Byte:\ [%03b\ 0x%02B],\ Cursor:\ %-14.(%l,%c%V%)\ %P

" File used for QuickFix mode (the one where you can use :cn and :cp for
" :make). :cf to read the file.
set errorfile=/tmp/output.log

" Stronger versions than hjkl
noremap K {
noremap J }
noremap H ^
noremap L $

" Make Y behave as CD. I.e. yank to end of line
nnoremap Y y$

" Check and reload (after updatetime ms) all modified files after any cursor movement
au CursorHold * :checktime

" How long until writing swp files, or triggering CursorHold
set updatetime=1000

" Useful when moving over long wrapped lines
nnoremap k gk
nnoremap j gj

" Navigating the clist
nnoremap <leader>q :cf<CR>
nnoremap <leader>w :cc<CR>
nnoremap <leader>e :cprev<CR>
nnoremap <leader>r :cnext<CR>

" Tags
nnoremap <leader>a g<C-]>
nnoremap <leader>A :call fzf#vim#tags(expand("<cword>"))<CR>
nnoremap <leader>s <C-T>
nnoremap <leader>d <C-W>g}

" Make it easier to enter command mode
nnoremap <leader>b :

" Reopen the current file
nnoremap <leader>x :e!<CR>

" Switch between alternative files (e.g. .c <-> .h, .cpp <-> .hpp)
nnoremap <leader>v :edit %:p:s/\.hh$/.tmp/:s/\.cc$/.hh/:s/\.tmp/.cc/:s/\.h$/.tmp/:s/\.c$/.h/:s/\.tmp/.c/<CR>

" Remove all trailing whitespace
nnoremap <leader>z :%s/\s\+$//e<CR>

" Toggle case of the current word
nnoremap <leader>u bg~we

" Toggle cursor line/column
nnoremap <leader>h :set cursorcolumn!<CR>
nnoremap <leader>j :set cursorline!<CR>

" Toggle ability to see whitespace
nnoremap <leader>k :set list!<CR>

" (fzf.vim) Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Jump to declaration/definition using language server protocol
nnoremap <leader>f :LspDeclaration<CR>
nnoremap <leader>g :LspDefinition<CR>

" (vim-easymotion) Use birectional word search.
nmap <leader><leader>w <plug>(easymotion-bd-w)

" (vim-easymotion) Use birectional line search.
nmap <leader><leader>j <plug>(easymotion-bd-jk)

" (vim-easymotion) Use birectional highlight search.
nmap <leader><leader>n <plug>(easymotion-bd-n)

" Enable showing whitespace
set list

" Disable ctrl-j because of conflict with ultisnips
imap <c-j> <Nop>

" Toggle paste mode in insert mode (disables autoindentation)
set pastetoggle=<F3>

" More convenient way of running a macro
nnoremap Q @q

" Disable swap files
set noswapfile

" Yank to x windows cut register ('*'). This works with simple selection with
" mouse.
set clipboard=unnamed

" Set the default colorscheme
colorscheme mycolors

" (vim-lsp) Register clangd LSP service
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" (vim-lsp) Register pyls LSP service
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python']
        \ })
endif

" (vim-lsp) Disable auto insertion of #include
let g:lsp_insert_text_enabled = 0
let g:lsp_text_edit_enabled = 0

" (vim-lsp) Enable/disable error indication column
let g:lsp_diagnostics_signs_enabled = 0

" (vim-lsp) Enable/disable highlighting errors
let g:lsp_textprop_enabled = 1

" (vim-lsp) Show error message on status line when cursor is on error.
let g:lsp_diagnostics_echo_cursor = 1

" (vim-lsp) Show error messages inline in the text
let g:lsp_diagnostics_virtual_text_enabled = 0

" (vim-lsp) Log to file
let g:lsp_log_file = expand('~/.local/share/nvim/site/logs/vim-lsp.log')

" (vim-lsp) Enable 'A>' signs in the left-most column to indicate an avaiable
" edit action.
let g:lsp_document_code_action_signs_enabled = 0

" (asyncomplete) Enable/disable completion popup
" let g:asyncomplete_auto_popup = 1

" (vim-easymotion) List the allowed keys
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" Customizes the c indentation see tha vim manual for more.
set cinoptions+=g0

" Indent lambda expressions properly.
set cinoptions+=j1

" Do not indent continuation lines (handles 'template' on its own line, but
" breaks continuations of expressions)
set cinoptions+=+0
