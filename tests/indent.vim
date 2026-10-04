execute 'set rtp^='.fnameescape(fnamemodify(expand('<sfile>'), ':h:h'))
function! Check(lines, expected) abort
  enew!
  runtime ftplugin/factor.vim
  runtime indent/factor.vim
  if get(g:, 'use_syntax', 0)
    runtime syntax/factor.vim
  endif
  call setline(1, a:lines)
  normal! gg=G
  call assert_equal(a:expected, map(range(1, len(a:lines)), 'indent(v:val)'), string(a:lines))
endfunction
for g:use_syntax in [0, 1]
  call Check([': foo ( -- )', '[', '1', '', '2', ']', ';', ': bar ( -- ) 1 ;'], [0, 4, 8, 0, 8, 4, 0, 0])
  call Check(['USING: kernel', 'sequences ;', 'IN: foo', ': foo ( -- )', '[ [', '1', '] ]', ';'], [0, 4, 0, 0, 4, 12, 4, 0])
  call Check([': foo ( -- )', '"[" ! [', '1', ';'], [0, 4, 4, 0])
  call Check([': foo ( -- ) 1 ;', ': bar ( -- )', '1 ;', '', 'IN: baz'], [0, 0, 4, 0, 0])
endfor
if !empty(v:errors)
  for s:error in v:errors
    echomsg s:error
  endfor
  cquit
endif
qa!
