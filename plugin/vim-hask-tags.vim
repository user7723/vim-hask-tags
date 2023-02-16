set tags=.tags,.tags.deps
set cscopeprg=hscope

" do not depend on the vim keyword definition and simply yank a word you need
" go to definition
noremap gd "ayiw:let @a = escape(@a, "\|")<CR>:tag <C-R>a<CR>
" list definitions
noremap g] "ayiw:let @a = escape(@a, "\|")<CR>:tselect <C-R>a<CR>
" list callers
noremap gc "ayiw:let @a = escape(@a, "\|")<CR>:cscope find c <C-R>a<CR>

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

let s:tags_sh = s:path . '/hstags.sh'
let s:deps_sh = s:path . '/hsdeps.sh'

if !exists('g:genProjectTagsAfterBufWrite')
  let g:genProjectTagsAfterBufWrite = 0
endif

if g:genProjectTagsAfterBufWrite == 1
  autocmd BufWritePost,FileWritePost *.hs call system(s:tags_sh)
endif

function! HSTags()
  let l:x = system(s:tags_sh)
  echo l:x
endfunction

function! HSDeps()
  execute '!' . s:deps_sh
endfunction

" generate/update ctags and cscope files for current project
noremap <silent> <leader>gt :call HSTags()<CR>
" generate ctags for all the dependencies of current project
noremap <silent> <leader>gd :call HSDeps()<CR>
