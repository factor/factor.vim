execute 'set rtp^='.fnameescape(fnamemodify(expand('<sfile>'), ':h:h'))
runtime plugin/factor.vim
filetype plugin indent on
let g:EnableFactorAutopairs = 1
nnoremap <Leader>fi :echo 'custom'<CR>
for s:index in [1, 2]
  enew!
  setfiletype factor
  call assert_equal(64, &l:textwidth)
  call assert_equal(1, maparg('[', 'i', 0, 1).buffer)
  call assert_equal(0, maparg('<Leader>fi', 'n', 0, 1).buffer)
  call assert_equal(1, maparg('<Leader>fd', 'n', 0, 1).buffer)
  call assert_equal(1, maparg('<Plug>(FactorDocs)', 'n', 0, 1).buffer)
  setfiletype text
  set ft=text
  call assert_equal(&g:textwidth, &l:textwidth)
  call assert_equal('', maparg('[', 'i'))
  call assert_equal('', maparg('<Leader>fd', 'n'))
  call assert_equal('', maparg('<Plug>(FactorDocs)', 'n'))
  call assert_false(exists('b:match_words'))
endfor
let g:FactorMappings = 0
enew!
set ft=factor.factor-docs
call assert_equal(0, &l:textwidth)
call assert_equal('', maparg('<Leader>fd', 'n'))
call assert_equal(1, maparg('<Plug>(FactorDocs)', 'n', 0, 1).buffer)
if !empty(v:errors)
  for s:error in v:errors
    echomsg s:error
  endfor
  cquit
endif
qa!
