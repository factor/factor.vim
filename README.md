Vim support for Factor
======================

This directory contains various support files that make editing
Factor code more pleasant in Vim.

Requires Vim 8.2 or later.

## Installation

The file-layout exactly matches the Vim runtime structure, so
you can install them by copying the contents of this directory
into `~/.vim/` or the equivalent path on other platforms (open
Vim and type `:help 'runtimepath'` for details). Enable support with
`filetype plugin indent on` and `syntax enable` in your vimrc.

You can also install this repository as a native package under
`~/.vim/pack/plugins/start/factor.vim`. Run
`:helptags ALL` after installation, then see `:help factor`.

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

```vim
let g:FactorResourcePath = '~/factor/'
let g:FactorAdditionalVocabRoots = ['~/my-factor-vocabs']
let g:FactorNewVocabRoot = 'resource:work'
```

`g:FactorResourcePath` is the Factor installation directory. The
trailing separator is optional.

`g:FactorDefaultVocabRoots` defaults to `['resource:core',
'resource:basis', 'resource:extra', 'resource:work']`. `resource:`
paths are relative to the installation directory.

`g:FactorAdditionalVocabRoots` adds filesystem roots; if unset,
these are read from nonempty lines in `~/.factor-roots`. Use absolute
or `~/` paths, or `resource:` paths relative to `g:FactorResourcePath`. `g:FactorVocabRoots` overrides the complete root list.
Otherwise, it caches the combined list; unlet it after changing roots.

`g:FactorNewVocabRoot` chooses where new vocabularies are created
(default: `resource:work`). The root must already exist. Defining
`FactorNewVocabRoot()` before loading the plugin overrides this setting.
New vocabulary files are written when you save the buffer.

Default leader mappings apply only in Factor buffers and preserve
existing mappings. Set `g:FactorMappings = 0` to disable them; the
`<Plug>(FactorImpl)`, `<Plug>(FactorDocs)`, `<Plug>(FactorTests)`,
`<Plug>(FactorVocab)`, and `<Plug>(FactorNewVocab)` targets remain available.

Set `g:EnableFactorAutopairs = 1` to enable automatic pairing and
spacing. This also trims trailing spaces before saving Factor buffers.

See `:help factor-settings` and `:help factor-syntax` for details.

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
automatically generated to include the word names from selected common Factor vocabularies.

To regenerate it manually, run the following command line:

    factor syntax/factor/generated.factor > syntax/factor/generated.vim

## Development

Run the regression suite with `sh tests/run.sh`. It uses clean headless
Vim sessions and covers navigation, syntax loading, filetype cleanup,
and indentation with and without highlighting. Set `VIM` to select
another Vim executable.
