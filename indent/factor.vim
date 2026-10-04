" Vim indent file
" Language: Factor

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1
setlocal indentexpr=GetFactorIndent(v:lnum)
setlocal indentkeys=0],0},0;,o,O
let b:undo_indent = 'setlocal indentexpr< indentkeys<'

" Ignore strings and comments even when syntax highlighting is disabled.
function! s:Code(lnum) abort
  let text = getline(a:lnum)
  let code = substitute(text, '"\%(\\.\|[^"\\]\)*"', 'STRING', 'g')
  let code = substitute(code, '\(^\|\s\)!\%(\s.*\|$\)', '', '')
  if exists('*synstack') && exists('b:current_syntax')
    let code = ''
    for col in range(1, strlen(text))
      let groups = map(synstack(a:lnum, col), 'synIDattr(v:val, "name")')
      let code .= join(groups) =~? 'String\|Comment\|Regexp' ? ' ' : strpart(text, col - 1, 1)
    endfor
  endif
  return code
endfunction

function! s:LeadingClosers(code) abort
  return len(split(matchstr(a:code, '^\s*\%([\]}]\s*\)\+')))
endfunction

function! GetFactorIndent(lnum) abort
  let previous = prevnonblank(a:lnum - 1)
  if !previous
    return 0
  endif
  let code = s:Code(previous)
  let tokens = split(code)
  let delta = s:LeadingClosers(code)
  for token in tokens
    if token =~# '^\%([^"\[\]]*{\|\[\|\$\[\|''\[\|\[let\|\[|\)$'
      let delta += 1
    elseif token ==# ']' || token ==# '}'
      let delta -= 1
    endif
  endfor
  " Definition and import bodies continue until their standalone semicolon.
  let declaration = code =~# '^\S*:'
  let immediate = code =~# '^\%(ALIAS\|C\|CONSTANT\|DEFER\|EDITOR\|FORGET\|GENERIC#\?\|IN\|INSTANCE\|MAIN\|MATH\|MIXIN\|PRIMITIVE\|RENAME\|SINGLETON\|SLOT\|SYMBOL\|USE\|UNUSE\|QUALIFIED\(-WITH\)\?\|\(\(SHUTDOWN\|STARTUP\)-\)\?HOOK\):'
  if declaration && !immediate
    let delta += 1
  endif
  if index(tokens, ';') >= 0 && code !~# '^\s*;' && !immediate
    let delta -= 1
  endif
  let current = s:Code(a:lnum)
  let delta -= s:LeadingClosers(current)
  if current =~# '^\s*;'
    let delta -= 1
  endif
  return max([0, indent(previous) + delta * shiftwidth()])
endfunction
