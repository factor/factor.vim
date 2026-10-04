" Location:     plugin/factor.vim

if exists('g:loaded_factor')
    finish
endif
let g:loaded_factor = 1

if !exists('g:FactorResourcePath')
    let g:FactorResourcePath = '~/factor/'
endif

if !exists('g:FactorDefaultVocabRoots')
    let g:FactorDefaultVocabRoots = ['resource:core', 'resource:basis', 'resource:extra', 'resource:work']
endif
" let g:FactorAdditionalVocabRoots = ... " see autoload/factor.vim

if !exists('*FactorNewVocabRoot')
    function! FactorNewVocabRoot() abort
        return get(g:, 'FactorNewVocabRoot', 'resource:work')
    endfunction
endif

command! -bar -bang -range=1 -nargs=1 -complete=customlist,factor#complete_vocab_glob FactorVocab
            \ execute factor#go_to_vocab_command(<count>,"edit<bang>",<q-args>)
command! -bar -bang -range=1 -nargs=1 -complete=customlist,factor#complete_vocab_glob NewFactorVocab
            \ execute factor#make_vocab_command(<count>,"edit<bang>",<q-args>)
command! -bar FactorVocabImpl :call GoToFactorVocabImpl()
command! -bar FactorVocabDocs :call GoToFactorVocabDocs()
command! -bar FactorVocabTests :call GoToFactorVocabTests()

function! FactorFileBase()
    let filename = expand('%:r')
    let filename = substitute(filename, '-\(docs\|tests\)$', '', '')
    return filename
endfunction

function! GoToFactorVocabImpl()
    exe 'edit ' fnameescape(FactorFileBase() . '.factor')
endfunction

function! GoToFactorVocabDocs()
    exe 'edit ' fnameescape(FactorFileBase() . '-docs.factor')
endfunction

function! GoToFactorVocabTests()
    exe 'edit ' fnameescape(FactorFileBase() . '-tests.factor')
endfunction

" vim:sw=4:et:
