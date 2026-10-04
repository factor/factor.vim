let s:root = fnamemodify(expand('<sfile>'), ':h:h')
execute 'set rtp^='.fnameescape(s:root)
let g:FactorVocabRoots = ['custom-root']
runtime plugin/factor.vim
call assert_equal(['custom-root'], factor#get_vocab_roots())
call assert_match('^echoerr ', factor#go_to_vocab_command(1, 'edit', 'missing'))
let g:FactorNewVocabRoot = '/does-not-exist/factor-review'
call assert_match('^echoerr ', factor#make_vocab_command(1, 'edit', 'missing'))
let s:temp = tempname()
let g:FactorResourcePath = s:temp
let g:FactorVocabRoots = ['resource:work']
let g:FactorNewVocabRoot = 'resource:work'
call mkdir(s:temp.'/work/foo', 'p')
call writefile(['IN: foo'], s:temp.'/work/foo/foo.factor')
call assert_equal('edit '.fnameescape(s:temp.'/work/foo/foo.factor'), factor#go_to_vocab_command(1, 'edit', 'foo'))
call assert_equal(['foo'], factor#complete_vocab_glob('fo', '', 0))
call assert_equal('edit '.fnameescape(s:temp.'/work/bar/baz/baz.factor'), factor#make_vocab_command(1, 'edit', 'bar.baz'))
call assert_true(isdirectory(s:temp.'/work/bar/baz'))
edit /tmp/path-docs-part/foo-tests.factor
call assert_equal('/tmp/path-docs-part/foo', FactorFileBase())
call delete(s:temp, 'rf')
if !empty(v:errors)
  call writefile(v:errors, '/dev/stderr')
  cquit
endif
qa!
