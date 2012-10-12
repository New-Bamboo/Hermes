# Hermes

Hermes is an environment for Ruby and JavaScript developers in Darwin using [Tmux](http://tmux.sourceforge.net/), [Vim](http://www.vim.org/) and [iTerm 2](http://www.iterm2.com/) that focuses on speed and ease of use.

Hermes is opinionated where having an opinion is important, but does not prevent you from customizing your tools.

Hermes gives you a lot of things for free:

- Sensible defaults for developers.
- Integration of Vim into tmux and tmux into iTerm 2.
- Mouse and window integration, allowing selections within tmux panes, not across them.
- Vim packages that provide git integration, command- and block-completion, fuzzy file search and ease of testing.

## Installation

As first step, you should fork the project, as this will make it easier to customize your installation. After you're done, you can run:

    curl https://raw.github.com/<your username>/Hermes/master/go.bash | bash

This will perform the following actions:

- Check that you have all the needed Homebrew dependencies
- Backup any file or folder that would be overwritten by the installer process
- Install all dotfiles and plugins available in the `hermes` directory and symlink them to the right locations in your home folder

You may also want to add Hermes's repository as upstream, so you can pull in the changes done on the main trunk whenever you need.

## How it's built

The purpose of Hermes is to lay down a good structure where you can build upon, without adding extra configuration layers on top. For example, all of Vim's configuration is managed through the `~/.vimrc` file and the `~/.vim` folder, so that you don't have any surprises. The only big difference is that under the hood, those files are actually symlkins to your `hermes` folder.

To customise Hermes, it's important to understand how all of its pieces are tied together.

### Vim

A stock vim installation with a basic configuration can go a long way and can be really beneficial when it comes to editing files on a server.

There is however a very simple problem with the default Vim installation that OsX provides: it cannot access the system clipboard, so if you copy anything from outside the editor, it's not available inside Vim's registers. Worse than that, if you copy anything in Vim (using its internal commands) is not shared with the rest of the system.

To sort this out, Hermes installed Homebrew's version of Vim, which can be made available through MacVim.

    brew install macvim --override-system-vim

This has some additional benefits, like having support for Ruby in plugins.

Let's now go with some defaults for a basic `.vimrc` file:

    set nocompatible    "don't need Vi compatibility
    set nobackup        "don't create backup files
    set nowritebackup
    set notimeout
    set ttimeout
    set ttimeoutlen=10
    set noswapfile      "don't create swap files
    set history=50      "keep a small history
    set ruler           "always show position
    set showcmd
    set incsearch
    set laststatus=2    "full status bar
    set t_Co=256        "256 colors - requires a properly configured terminal emulator
    syntax on           "turn syntax highlight on

    filetype plugin indent on "let plugins manage indentation

    " Send more characters for redraws
    set ttyfast
    " Enable mouse use in all modes
    set mouse=a
    set ttymouse=xterm2

    " Fix backspace
    set backspace=indent,eol,start
    fixdel

    " Softtabs, 2 spaces
    set tabstop=2
    set shiftwidth=2
    set expandtab

    " Display extra whitespace at the end of the line
    set list listchars=tab:»·,trail:·
    " Clipboard fix for OsX
    set clipboard=unnamed

    " Numbers
    set number
    set numberwidth=2

    "Folding
    set foldmethod=indent
    set foldlevelstart=99

    " Autocompletion options
    set wildmode=list:longest,list:full
    set complete=.,w,b"

These settings will let you efficiently edit any file whose type is supported by default, and that already covers javascript and ruby.
