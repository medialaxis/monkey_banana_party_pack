" Setup all my plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips', {'tag': '3.2'}
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-fugitive', {'tag': 'v3.7'}
Plug 'ton/vim-alternate'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'tag': 'v0.8.1'}
" Plug 'p00f/nvim-ts-rainbow'
Plug 'medialaxis/nvim-ts-rainbow'
Plug 'neovim/nvim-lspconfig', {'tag': 'v0.1.3'}
Plug 'phaazon/hop.nvim', {'tag': 'v2.0.3'}
Plug 'lukas-reineke/indent-blankline.nvim', {'tag': 'v2.20.2'}
Plug 'neovim/nvim-lspconfig', {'tag': '0.1.4'}
Plug 'hrsh7th/nvim-cmp'
call plug#end()

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
digraph ba 120120  " 𝔸
digraph bb 120121  " 𝔹
digraph bc 8450    " ℂ
digraph bd 120123  " 𝔻
digraph be 120124  " 𝔼
digraph bf 120125  " 𝔽
digraph bg 120126  " 𝔾
digraph bh 8461    " ℍ
digraph bi 120128  " 𝕀
digraph bj 120129  " 𝕁
digraph bk 120130  " 𝕂
digraph bl 120131  " 𝕃
digraph bm 120132  " 𝕄
digraph bn 8469    " ℕ
digraph bo 120134  " 𝕆
digraph bp 8473    " ℙ
digraph bq 8474    " ℚ
digraph br 8477    " ℝ
digraph bs 120138  " 𝕊
digraph bt 120139  " 𝕋
digraph bu 120140  " 𝕌
digraph bv 120141  " 𝕍
digraph bw 120142  " 𝕎
digraph bx 120143  " 𝕏
digraph by 120144  " 𝕐
digraph bz 8484    " ℤ
digraph bG 8510    " ℾ
digraph bP 8511    " ℿ
digraph l- 8866    " ⊢
digraph l= 8872    " ⊨

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
iabbrev _:: ∷
iabbrev _dT ⊤
iabbrev _uT ⊥

" Abbreviations
iabbrev _ae Andreas Edlund
iabbrev _mail andreas@myrstacken.net

" Set <leader>
let mapleader = " "

" Set up some useful keyboard mappings
nnoremap <F2> :e scratch<CR>
nnoremap <F4> :!snap<CR><CR>
nnoremap <F5> :wa<CR>
nnoremap <F6> :Files<CR>
nnoremap <F7> :Tags<CR>
nnoremap <F8> :Ag<CR>
nnoremap <F9> :BLines<CR>
nnoremap <F10> :FormatFile<CR>
nnoremap <F11> :History:<CR>

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

" Navigate windows
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

augroup terminal
    autocmd!

    " Exit terminal mode
    autocmd TermOpen * tnoremap <buffer> <esc><esc> <c-\><c-n>

    " Prevent the above from clobbering fzf
    autocmd FileType fzf tunmap <buffer> <esc><esc>
augroup END

" Navigating the clist
nnoremap <leader>q :cf<CR>
nnoremap <leader>w :cc<CR>
nnoremap <leader>e :cprev<CR>
nnoremap <leader>r :cnext<CR>

" Tags
nnoremap <leader>a :call fzf#vim#tags(expand("<cword>"))<CR>
nnoremap <leader>s <C-T>

" Make it easier to enter command mode
nnoremap <leader>b :

" (fzf.vim) Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Jump to declaration/definition using language server protocol
nnoremap <leader>f :LspDeclaration<CR>
nnoremap <leader>g :LspDefinition<CR>

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

" Customizes the c indentation see tha vim manual for more.
set cinoptions+=g0

" Indent lambda expressions properly.
set cinoptions+=j1

" Do not indent continuation lines (handles 'template' on its own line, but
" breaks continuations of expressions)
set cinoptions+=+0

" Enable mouse in all modes (=a) (hold shift to temporarily disable mouse
" support, useful when copy-pasting)
set mouse=a

" Set mouse scroll to be a single line only
noremap <scrollwheelup> <c-y>
noremap <scrollwheeldown> <c-e>

" Open current cursor position using gx (e.g. xdg-open)
noremap <rightmouse> :normal gx<cr>

" Set mouse model (this mostly controls what happens on right clicks)
set mousemodel=popup

" Load all default menus
source $VIMRUNTIME/menu.vim

" (vim-alternate) Setup the cycle of c++ sources and headers
let g:AlternateExtensionMappings=[{'.c' : '.h', '.h' : '.cc', '.cc' : '.hh', '.hh' : '.cpp', '.cpp' : '.hpp', '.hpp' : '.c'}]

" (hop.nvim) Setup hop
lua <<EOF
require'hop'.setup()
EOF

" (hop.nvim) Hop key bindings
nmap f :HopChar1<CR>
nmap s :HopChar2<CR>
nmap <leader><leader>j :HopVertical<CR>
nmap <leader><leader>w :HopWord<CR>
nmap <leader><leader>p :HopPattern<CR>

" Reload init.vim
command! ReloadInitVim source $MYVIMRC

" Highlight the cursor's column
command! ToggleCursorColumn set cursorcolumn!

" Highlight the cursor's line
command! ToggleCursorLine set cursorline!

" Show whitespace characters
command! ToggleWhitespaceCharacters set list!

" Reopen the current file
command! ReloadCurrentFile edit!

" Commands for folding
command! FoldMin normal zM
command! FoldMax normal zR
command! FoldUpdate normal zx
command! FoldDecrease normal zm
command! FoldIncrease normal zr

" Create file under cursor
command! CreateFile silent !touch <cfile>

" Toggle the quickfix window
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
command! ToggleQuickFix call ToggleQuickFix()

" Autoformat c/c++ code
function! FormatFile()
    let l:lines="all"
    pyf /usr/share/clang/clang-format.py
endfunction
command! FormatFile call FormatFile()

augroup json
    autocmd!

    " Enable syntax folding
    autocmd FileType json setlocal foldmethod=syntax

    " Open all folds by default
    autocmd BufRead *.json :normal zR
augroup END

augroup c_cpp
    autocmd!

    " Enable syntax folding
    autocmd FileType c,cpp setlocal foldmethod=syntax

    " Open all folds by default
    autocmd BufRead *.h,*.c,*.hh,*.cc,*.hpp,*.cpp :normal zR

    " Start lsp server manually
    " autocmd FileType c,cpp lua vim.lsp.start({name = 'clangd', cmd = {'clangd', '-background-index'} })

    " Enable LSP omnifunc
    " autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
augroup END

augroup python
    autocmd!

    " Enable syntax folding
    autocmd FileType python setlocal foldmethod=syntax

    " Open all folds by default
    autocmd BufRead *.py :normal zR
augroup END

" When using 'gx', open the file using openbg instead of xdg-open. This runs
" the command in the background.
"let g:netrw_browsex_viewer= "openbg"

" WORKAROUND: The netrw call above does not work with neovim 0.5 because of a
" bug. This is a temporary workaround for this
nmap gx :silent execute "!plumb " . shellescape("<cWORD>")<CR>

" Make gf open a file buffer even if the file does not exist
" nnoremap gf :e <cfile><CR>

" Persistent undo. Save the undo tree on save and load the undo tree on edit.
set undofile

" Allow modified buffers in the background
set hidden

" (nvim-treesitter) Configure nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "rust", "haskell", "python", "rust" },
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    rainbow = {
        enable = true,
    },
}
EOF

" (indent-blankline.nvim) Setup
lua <<EOF
require("indent_blankline").setup {
    use_treesitter = true,
    show_current_context = true,
    show_current_context_start = false,
}
EOF

" (nvim-ts-rainbow) Workaround: When the file is changed behind rainbow's
" back, it gets confused. This automatically reloads rainbow.
command! ResetRainbow :TSEnable rainbow | TSDisable rainbow | TSEnable rainbow
" autocmd CursorHold * ResetRainbow

" (nvim-lspconfig) Setup LSP servers
lua <<EOF
-- Debug LSP server.
-- Use 'vim.lsp.get_log_path()' to find location of log file.
-- Default log path: .local/state/nvim/lsp.log)
-- vim.lsp.set_log_level('debug')

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
--    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--    vim.keymap.set('n', '<space>wl', function()
--      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('lspconfig').clangd.setup {
    on_attach = on_attach
}

require('lspconfig').pylsp.setup {
    on_attach = on_attach
}

require('lspconfig').rust_analyzer.setup {
    on_attach = on_attach
}
EOF
