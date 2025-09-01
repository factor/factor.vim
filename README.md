Vim support for Factor
======================

This directory contains various support files that make editing
Factor code more pleasant in Vim.

## Installation

The file-layout exactly matches the Vim runtime structure, so
you can install them by copying the contents of this directory
into `~/.vim/` or the equivalent path on other platforms (open
Vim and type `:help 'runtimepath'` for details).

## File organization

The current set of files is as follows:

* ftdetect/factor.vim - Teach Vim when to load Factor support
  files.
* ftplugin/factor.vim - Teach Vim to follow the Factor Coding
  Style guidelines. Contains an optional autopairs plugin for
  Factor. See configuration below.
* ftplugin/factor-docs.vim - Teach Vim about documentation style
  differences.
* plugin/factor.vim - Teach Vim some commands for navigating
  Factor source code. See configuration below.
* syntax/factor.vim - Teach Vim about highlighting Factor source
  code syntax.
  * syntax/factor/generated.vim - Syntax highlighting lessons
    generated from a Factor VM.
* indent/factor.vim - Teach Vim to automatically indent Factor
  source code.

## Commands

The `plugin/factor.vim` file implements the following commands
for navigating Factor source.

### :FactorVocab factor.vocab.name

Opens the source file implementing the `factor.vocab.name`
vocabulary.

### :NewFactorVocab factor.vocab.name

Creates a new factor vocabulary under the working vocabulary
root.

### :FactorVocabImpl

Opens the main implementation file for the current vocabulary
(name.factor). The keyboard shortcut `<Leader>fi` is bound to
this command.

### :FactorVocabDocs

Opens the documentation file for the current vocabulary
(name-docs.factor). The keyboard shortcut `<Leader>fd` is bound
to this command.

### :FactorVocabTests

Opens the unit test file for the current vocabulary
(name-tests.factor). The keyboard shortcut `<Leader>ft` is bound
to this command.

## Configuration

In order for the `:FactorVocab` command to work, you'll need to
set some variables in your vimrc file.

### g:FactorResourcePath

This variable should be set to the root of your Factor
installation. The default value is `~/factor/`.

### g:FactorAdditionalVocabRoots

This variable should be set to a list of Factor vocabulary
roots other than the default ones (`core`, `basis`, `extra` and
`work`). The paths may be absolute paths or use the
`resource:` prefix to be relative to `g:FactorResourcePath`. If
not set the `~/.factor-roots` configuration file will be parsed
for additional vocablary roots.

### FactorNewVocabRoot()

This function should be defined to return the vocabulary root in
which vocabularies created with NewFactorVocab should be
created. The default implementation returns `resource:work`.

### g:EnableFactorAutopairs

This variable should be set to 1 if you want to enable the
autopairs functionality.

### Example

A simple configuration like this could be inserted into
`.vimrc`:

```vimscript
let g:FactorResourcePath='~/factor/'
let g:FactorAdditionalVocabRoots=[
    \'~/projects/',
    \'~/random/',
    \]
function! FactorNewVocabRoot() abort
    return '/home/username/projects/'
endfunction
let g:EnableFactorAutopairs=1
```

## Note

The `syntax/factor/generated.vim` syntax highlighting file is
automatically generated to include the names of all the
vocabularies Factor knows about.

To regenerate it manually, run the following command line:

    factor syntax/factor/generated.factor > syntax/factor/generated.vim
