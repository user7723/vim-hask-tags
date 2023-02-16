# vim-hask-tags

### Description
`vim-hask-tags` introduces keyboard mappings to:
  - download the dependency code for you Haskell project
  - generate `ctags` file for that dependency code
  - generate/update `ctags` and `csope` files for your Haskell project

To enable tags generation on each save of a file you simply need to introduce the following binding in your `vimrc`:
```
let g:genProjectTagsAfterBufWrite = 1
```


### Dependencies
- `ghc-tags` - [ghc-tags tool](https://github.com/arybczak/ghc-tags) is used to generate or update `ctags` for current project
- `fast-tags` - [fast-tags tool](https://github.com/elaforge/fast-tags) is used to generate `ctags` for dependency code (dependency code will quite often use c-preprocessor directives which aren't taken into consideration by this tool -- it's more liberal than `ghc-tags`)
- `hscope` -  [hscope tool](https://github.com/bosu/hscope) is used to generate `cscope` file for the current project

### Installation
If you're using `vim-plug`, add the following line to your list of plugins:
```
Plug 'user7723/vim-hask-tags', { 'for': 'haskell' }
```
Otherwise do some research on `ftplugins` vim directory

### Key Mappings
  - `gd` - select word under the cursor and go to its definition (takes special chars into account, so you can jump to operators definitions)
  - `g]` - same logic applies, but shows you the list of possible tags to disambiguate the choice
  - `gc` - shows you the list of callers of the function under the cursor
  - `<leader>gt` - generates `ctags` and `cscope` for current project
  - `<leader>gd` - downloads source code for yours project dependencies and generates `ctags` file for it
