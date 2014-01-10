# ghcimportedfrom-vim

Vim plugin for [https://github.com/carlohamalainen/ghc-imported-from](ghc-imported-from).

Based heavily on [https://github.com/eagletmt/ghcmod-vim](ghcmod-vim).

## Installation

Prerequisites are Pathogen, vimproc, and ghc-imported-from.

### Pathogen

Install Pathogen:

    mkdir -p ~/.vim/autoload ~/.vim/bundle;
    curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

Add these lines to ```~/.vimrc```:

    execute pathogen#infect()
    syntax on
    filetype plugin indent on

### vimproc

    git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim
    cd ~/.vim/bundle/vimproc.vim
    make
    cd

### ghc-imported-from

Install into user's cabal directory:

    git clone https://github.com/carlohamalainen/ghc-imported-from
    cd ghc-imported-from
    cabal install
    cd -

Alternatively, see the script ```build_in_sandbox.sh``` for building
in a cabal sandbox (requires a fairly recent version of Cabal).

Make sure that the ```ghc-imported-from``` binary is on the path, for example:

    $ which ghc-imported-from
    /home/user/.cabal/bin/ghc-imported-from

### ghcimportedfrom-vim

Install ghcimportedfrom-vim:

    git clone https://github.com/carlohamalainen/ghcimportedfrom-vim ~/.vim/bundle/ghcimportedfrom-vim

If you use literate Haskell (lhs files):

    ln -s ~/.vim/bundle/ghcimportedfrom-vim/after/ftplugin/haskell ~/.vim/bundle/ghcimportedfrom-vim/after/ftplugin/lhaskell

Add these lines to ```~/.vimrc```:

    au FileType haskell  nnoremap <buffer> <F4> :GhcImportedFromOpenHaddock<CR>
    au FileType lhaskell nnoremap <buffer> <F4> :GhcImportedFromOpenHaddock<CR>

    au FileType haskell  nnoremap <buffer> <F5> :GhcImportedFromEchoUrl<CR>
    au FileType lhaskell nnoremap <buffer> <F5> :GhcImportedFromEchoUrl<CR>

## Using

In Vim, put the cursor over a symbol, and hit F4 to open the relevant
Haddock documentation page in the system's default browser, or F5 to
echo the Haddock URL in the Vim window.

The [http://www.youtube.com/watch?v=VVc8uupYJGs](screencast) shows
some examples. Make sure that the video plays in 720p HD fullscreen.
