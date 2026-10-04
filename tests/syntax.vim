execute 'set rtp^='.fnameescape(fnamemodify(expand('<sfile>'), ':h:h'))
for s:no_init in [0, 1]
  enew!
  if s:no_init
    let g:factor_syn_no_init = 1
  endif
  runtime syntax/factor.vim
  call setline(1, 'dup')
  call assert_equal('factorWord_kernel', synIDattr(synID(1, 1, 1), 'name'))
  call assert_equal(0, exists(':HiLink'))
  call assert_equal(0, exists(':SynKeywordFactorWord'))
endfor
enew!
let b:factor_syn_no_generated = 1
runtime syntax/factor.vim
call setline(1, 'dup')
call assert_notequal('factorWord_kernel', synIDattr(synID(1, 1, 1), 'name'))
if !empty(v:errors)
  for s:error in v:errors
    echomsg s:error
  endfor
  cquit
endif
qa!
