set tw=80

" Makes autocompletion for references nice
set iskeyword+=:

" .tex files always interpreted as latex and not plain tex
let g:tex_flavor='latex'

" don't try to force highlighting matching sections
let g:vimtex_motion_matchparen=0

" enable completion
let g:vimtex_complete_enable=1

" use mupdf as the viewer
let g:vimtex_view_method="mupdf"

set shiftwidth=2
set softtabstop=2
set expandtab

inoremap <Esc>( \left(
inoremap <Esc>) \right)
inoremap <Esc>[ \left[
inoremap <Esc>] \right]
inoremap <Esc>R \mathbb{R}
inoremap <Esc>C \mathbb{C}
inoremap <Esc>< \sqrt{
inoremap <Esc>^ ^{
inoremap <Esc>_ _{
inoremap <Esc>& \int
inoremap <Esc>% \dd{
inoremap <Esc>$ \pd{

inoremap <Esc>a \alpha
inoremap <Esc>b \beta
inoremap <Esc>g \gamma
inoremap <Esc>k \kappa
inoremap <Esc>l \lambda
inoremap <Esc>d \delta
inoremap <Esc>D \Delta
inoremap <Esc>e \epsilon
inoremap <Esc>E \varepsilon
