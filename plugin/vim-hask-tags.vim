set tags=.tags,.tags.deps
set cscopeprg=hscope

" extend keyword notion by adding Haskell's special symbols
" except '.'
set iskeyword+=33,35-38,42,43,45,47,60-64,28,124,126

" do not depend on the vim keyword definition and simply yank a word you need
" go to definition
noremap gd "ayiw:let @a = escape(@a, "\|")<CR>:tag <C-R>a<CR>
" list definitions
noremap g] "ayiw:let @a = escape(@a, "\|")<CR>:tselect <C-R>a<CR>
" list callers
noremap gc "ayiw:let @a = escape(@a, "\|")<CR>:cscope find c <C-R>a<CR>

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! HSTags()
  let s:tags_sh = '' . s:path . '/hstags.sh'
  echo s:tags_sh
  execute '!' . s:tags_sh
endfunction

function! HSDeps()
  let s:deps_sh = '' . s:path . '/hsdeps.sh'
  echo s:deps_sh
  execute '!' . s:deps_sh
endfunction

" generate/update ctags and cscope files for current project
noremap <leader>gt :call HSTags()<CR>
" generate ctags for all the dependencies of current project
noremap <leader>gd :call HSDeps()<CR>
