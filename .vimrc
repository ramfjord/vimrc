set shiftwidth=2  "width for << command
set softtabstop=2 "tabs appear size 2
set tabstop=2 "tabs actually are size 2
set dictionary=/usr/share/dict/cracklib-small
set foldmethod=marker
set incsearch
syntax enable
colorscheme slate

" Set a nicer foldtext function {{{
set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if comment_content != ''
	break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
	let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"
  let sub = sub . "                                                                                                                  "
  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
  return sub . info
endfunction "}}}

highlight Folded ctermbg=Black ctermfg=Yellow

set path=.,,** ",/usr/include

"set up indentation
if has("autocmd") "set up indentation
  filetype indent on
else
  set autoindent
endif

"default abbreviations and mappings
ab teh the
nmap ;f <Esc>:FuzzyFinderTextMate<CR>

filetype detect

"Latex mappings {{{
if &ft =~ "tex"
	inoremap ;tt \texttt{}<left>
  inoremap x1 x_1
  inoremap y1 y_1
  inoremap z1 z_1
  inoremap x2 x_2
  inoremap y2 y_2
  inoremap z2 z_2
  inoremap x3 x_3
  inoremap y3 y_3
  inoremap z3 z_3
	inoremap ,a \alpha
	inoremap ,b \beta
	inoremap ;f <Esc>:s/\([^ ]\+\)\/\([^ ]\+\)/\\frac{\1}{\2}/<CR>A
  inoremap <C-B> {}<left>
  inoremap ;<C-B> \{\}<left><left>
  inoremap ;d $$<left>
  inoremap ;en \begin{enumerate}<CR>\end{enumerate}<Up><End><CR>\item<Space> 
  inoremap ;im \begin{itemize}<CR>\end{itemize}<Up><End><CR>\item<Space> 
  inoremap ;it \item
  inoremap ;pr \begin{proof}<CR>\end{proof}<Up><End><CR>
  inoremap ;cl \begin{claim}<CR>\end{claim}<Up><End><CR>
  inoremap ;bf \textbf{}<left>
  inoremap ;al \begin{align*}<CR>\end{align*}<Up><End><CR>
  inoremap ;eq \begin{equation*}<CR>\end{equation*}<Up><End><CR>
  inoremap ;hd \hat{\delta}
  inoremap ;ind \textbf{Base Case:}<CR>\textbf{Inductive Hypothesis:}<CR>\textbf{Need to Show:}<Up><Up>
  inoremap ;ip \textbf{Integer Program:} \\ <CR>\noindent \textbf{Auxiliary Variables:}<CR>\begin{itemize}<CR>\item<CR>\end{itemize}<CR><CR>\noindent \textbf{Decision Variables:}<CR>\begin{itemize}<CR>\item<CR>\end{itemize}<CR><CR>\noindent \textbf{Objective Function:}<CR><CR>\noindent \textbf{Constraints:}<CR>\begin{itemize}<CR>\item<CR>\end{itemize}<CR><CR>\noindent \textbf{Argument: }<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Space>
  inoremap ;lp \textbf{Linear Program:} \\ <CR>\noindent \textbf{Auxiliary Variables:}<CR>\begin{itemize}<CR>\item<CR>\end{itemize}<CR><CR>\noindent \textbf{Decision Variables:}<CR>\begin{itemize}<CR>\item<CR>\end{itemize}<CR><CR>\noindent \textbf{Objective Function:}<CR><CR>\noindent \textbf{Constraints:}<CR>\begin{itemize}<CR>\item<CR>\end{itemize}<CR><CR>\noindent \textbf{Argument: }<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Space>
  inoremap ;sum \displaystyle\sum\limits_{i=1}^n<left><left><left><left><left><left><ESC>

endif "}}}

"java mappings
if &ft =~ "java"
  iab psvm public static void main(String args[]){
  iab syso System.out.println();<left><left>
  iab syser System.err.println();<left><left>
  iab nxl <left>nextLine();
endif

"c mappings
if &ft =~ "c"
  iab perrx if(err){ perror(errno); exit(0); }
  iab perrr if(err){ perror(errno); return 
  iab printerr fprintf(stderr,"");<left><left><left>
endif

"allow syntax hilighting with ssh
if &term =~ "xterm"
  "256 color --
  let &t_Co=256
  " restore screen after quitting
  set t_ti=ESC7ESC[rESC[?47h t_te=ESC[?47lESC8
  if has("terminfo")
    let &t_Sf="\ESC[3%p1%dm"
    let &t_Sb="\ESC[4%p1%dm"
  else
    let &t_Sf="\ESC[3%dm"
    let &t_Sb="\ESC[4%dm"
  endif
endif

