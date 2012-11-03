# Hermes

Hermes is an environment for Ruby and JavaScript developers in Darwin using
[Tmux](http://tmux.sourceforge.net/), [Vim](http://www.vim.org/) and [iTerm
2](http://www.iterm2.com/) that focuses on speed and ease of use.

Hermes is opinionated where having an opinion is important, but does not
prevent you from customizing your tools.

Hermes gives you a lot of things for free:

- Sensible defaults for developers.
- Integration of Vim into tmux and tmux into iTerm 2.
- Mouse and window integration, allowing selections within tmux and Vim panes,
  not across them.
- Vim packages that provide git integration, command- and block-completion,
  fuzzy file search and ease of testing.

We feel that good documentation is a key part of using any new technology with
lots of moving parts, so we will be improving Hermes' documentation in the days
and weeks to come.


## Preliminary Thanks

Hermes combines plugins, settings, snippets, gists, and ideas from countless
developers around the world. We would like to thank:

- The [Vim](http://www.vim.org/) team.
- The [Tmux](http://tmux.sourceforge.net/) team.
- The [GNU Bash](http://www.gnu.org/software/bash/bash.html) and [Fish](http://ridiculousfish.com/shell/) teams
- The [Homebrew](http://mxcl.github.com/homebrew/) team.
- [Tim Pope](http://tpo.pe/). Seriously, you're awesome.
- [Thoughtbot](http://thoughtbot.com/) for their dotfiles, essential in getting
  the Tmux configuration right.
- [Vimcasts](http://vimcasts.org/), for showing the world just how powerful Vim can be.


## Installation

**Warning!** Hermes is still early in development, so just to be
careful, we strongly encourage you to install it in a separate
user account, not your main one. That said, we *have* tested it on
our own user accounts, where it worked just fine.


### Prerequisites

Hermes relies on Homebrew and RVM to work properly. While Homebrew is a de
facto standard developers using OS X, there are a good number of people that
use RBenv, so support for that is in the pipeline. We are happy to look at any
pull requests.

If these two tools are not available, the installer script will halt. Please
refer to these tools' excellent documentation for installation instructions.


### Fork first!

As the very first step, you should fork the Hermes on Github since this will
make it easier for you to customize your installation. After you're done, you
can run:

    mkdir -p ~/.hermes
    git clone https://github.com/<your_github_username>/Hermes.git ~/.hermes
    cd ~/.hermes
    ./install.bash

This will perform the following actions:

- Check that you have all the needed Homebrew dependencies
- Back up any file or folder that would be overwritten by the installer process
- Install all dotfiles and plugins available in the `hermes` directory and
  symlink them to the right locations in your home folder

You may also want to add Hermes's repository as an upstream repository, so you
can pull in the changes done on the main trunk whenever you need to.


### What's included in the installer

The installer will:

- check for dependencies
- backup any existing dotfile that would be overwritten in a timestamped tar
  file that you can use to restore your previous configuration
- install a number of required Homebrew packages
- create a `~/hermes` directory and symlink its content to your home folder
  where every piece of software expects to find its main configuration file(s)

Hermes includes:

- configuration and plugins for Vim
- configuration for Tmux
- configuration for git
- configuration and additional functionality for two shells: Bash and Fish.
- settings for `gem`, `ack`, `pow`, `pry` and `irb`

In addition, Hermes glues all components together so they play nicely with each
other and the OS. Two examples of this integration are are Hermes' support for
the system clipboard in OS X and window/pane aware mouse integration.


### Updates

Being a git-based project, you can update Hermes by simply pulling from the
remote. If you forked the project, please remember to add the original repo as
an upstream repository to make getting new project updates easier.


## How it's built

Hermes goal is to provide a solid structure for you to build on top of without
having to deal with any intermediate configuration layers.  For example, Vim's
entire configuration is managed canonically through the `~/.vimrc` file and the
`~/.vim` folder. The only significant difference is that under the hood, those
files are actually symlinks to your `hermes` folder.

Knowing how Hermes ties everything together is useful when it comes time to
configure it.


### Vim

A stock vim installation with a basic configuration can go a long way and can
be really beneficial when it comes to editing files on a server.

There is however a very simple problem with the default Vim installation that
OS X provides: it cannot access the system clipboard. That means if you copy
anything from outside the editor, it's not available in any of Vim's registers.
Worse yet, if you copy anything in Vim using its internal commands, it won't be
available to the rest of the system

To sort this out, Hermes installed Homebrew's version of Vim, which can be made
available through MacVim.

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

These settings will allow you to efficiently edit any file whose type is
supported by default, so Javascript and Ruby are already covered. The settings
enable standard features like line numbering and syntax highlighting and also
turn on features like mouse support and clipboard sharing that are useful in
integrating Vim into iTerm and OS X.


#### Plugins

Plugins are a powerful way to extend Vim's capabilities. The implementation may
change, but we feel you should be able to expect the following from a modern
text editor:

- Support for fuzzy search inside a directory tree. You should be able to
  easily open a file by name without navigating the tree.
- Full text search inside a directory tree.
- Snippet support with expansion, tab stops and completion. Like Textmate.
- Integration with testing frameworks. You should be able to run tests without
  leaving the editor.
- Tabs and split windows. You should be able to see tests and the corresponding
  code at the same time and be able to easily switch from one to the other.
- Language specific features, like syntax-aware indentation and navigation.

Needless to say, a number of other text editors support these features. Vim,
however, combines this with its extremely efficient modal editing approach.

Hermes provides a good number of plugins, aiming to strike a balance between
features and speed. You can see the complete list under `hermes/vim/bundle`,
but here are some highlights:

- [Ctrlp](https://github.com/kien/ctrlp.vim): a tool for fuzzy searching by
  file and tag.
- [Snipmate](https://github.com/msanders/snipmate.vim): unashamedly borrowing
  from Textmate, Snipmate provides tab completion based on snippet files.
- [The silver searcher](https://github.com/epmatsw/ag.vim): `ag` is a faster
  alternative to Ack.
- [TComment](https://github.com/vim-scripts/tComment): toggles comments in
  nearly any language.
- [Rails.vim](https://github.com/tpope/vim-rails): provides shortcuts,
  generators and settings for working with Ruby on Rails projects.  Absolutely
  killer.
- [Vimux](https://github.com/benmills/vimux): forms a bridge with Tmux to send
  text and commands to a Tmux pane. Vimux is essential for Hermes' testing
  support.

However, we encourage you to be wary of plugins for several reasons:

- Vim has many conventional ways to accomplish certain tasks, and while it's
  possible to do things in many ways, it's important to try to understand the
  Vim way of doing things and play to its strengths.
- One of Vim's benefits is speed and low memory footprint, making it responsive
  even when opening huge files. Increasing Vim's footprint through exxcessive
  numbers of plugins can eliminate this benefit.
- Sometimes a plugin is not necessary. Similar or identical effects can often
  be achieved with smaller, well thought-out changes in your .vimrc.
- Although powerful, Vim is a text editor and should do just this one job well.

Vim's approach to plugin management is a little counterintuitive: by default, Vim looks into `~/.vim` for additional scripts to load, divided into subfolders according to the circumstances when they need to be activated. For example, a script can be split into the `plugin` and the `autoload` directory, the former for the bulk, load-once functionality while the latter for anything that requires constant recalculation. This means that a manual installation affects multiple directories, becoming cumbersome to manage and update.

Enter [Pathogen](https://github.com/tpope/vim-pathogen), a package manager that makes this process painless and that reverses the perspective, as it lets you organize plugins by name. With Pathogen, you can simply clone a repository in your `~/.vim` folder and you're done. This is the first stepping stone to a proper dotfiles management through Github, where you can add every plugin as a git submodule and update them all with a single command.

Hermes uses the git submodule pattern: because every plugin can be kept in a single folder thanks to Pathogen, it's possible to add it as a submodule in the `hermes/vim/bundle` folder. This makes it dead easy to add other plugins when needed:

    cd ~/.hermes
    git submodule add <github-url> hermes/vim/bundle/<plugin-name>

And you're done! In a similar fashion, updating plugins is also straightforward

    cd ~/.hermes
    git submodule foreach git pull origin master

As in every other github based project, it's advisable to fork a plugin if you need to make changes that go beyond simple configuration (which we usually add to `~/.hermes/vim/plugins.vim`). In that case, you need to remove the original submodule and add it back again using your fork as a url.

Pathogen loads the content of `~/.vim/bundle` by default. including itself. This is controlled by the first two lines in the `~/.vimrc` file:

    " loading pathogen at runtime as it's bundled
    runtime bundle/vim-pathogen/autoload/pathogen.vim
    call pathogen#infect()

#### Managing configuration

If you keep extending your `.vimrc`, it comes to a point where it's simply too long, so it makes sense to split it into separate chunks that are somewhat related: here's a sample from the bottom of my `.vimrc`:

    source $HOME/.vim/autocommands.vim
    source $HOME/.vim/plugins.vim
    source $HOME/.vim/shortcuts.vim

As a bonus, pressing `gf` in normal mode will open the file under the cursor.

In addition, always take care of reading the documentation for the plugins you use, as they're usually extremely configurable (an example is the `plugins.vim`) file.

Documentation is usually available by typing `:help <term-to-search>`, however Hermes has a custom shortcut you can use: by pressing `<leader>h` with the cursor on a word, it will search the help docs for the word itself.

Plugin configuration is vital in the long run, as the purpose of plugins should be to help you, not getting in your way.

As an example, let's look at the configuration Hermes supplies for Ctrl-p (in `~/.hermes/hermes/vim/plugins.vim`):

    set wildignore+=*/.hg/*,*/.svn/*,*/vendor/cache/*,*/public/system/*,*/tmp/*,*/log/*,*/.git/*,*/.jhw-cache/*,*/solr/data/*,*/node_modules/*,*/.DS_Store

The `wildignore` flag is not Ctrl-p specific, as it's used by Vim for a lot autocompletion and expansion functions: the more we remove paths and files it's unlikely we want to parse, the better Vim will perform. And as Ctrl-p uses this pattern to determine a baseline for excluding files to create its index, by setting it right we keep it snappy.

#### Daily use cases

Here are a few examples of what you can do with Vim, bearing in mind that this is not meant to be an exhaustive guide. Instead, we will focus on recurring tasks that usually pop up during a normal workday.

##### Shelling out

Having the shell at your disposal can speed up your workflow tenfold, but to really take advantage of this it's important to learn how to alternate between Vim and the command line.

Sometimes you just need to run a simple shell command, like creating a directory or touching a file. In that situation, press `:` in normal mode to enter the command mode. Then type `!` to tell Vim to shell out and perform the command in the shell. So, if you want to create a `sample` directory, you can type:

    :!mkdir sample

The command will be performed in the current working directory, you can verify that with `:pwd`.

When you need to step out the file you're editing, perform a few tasks and then go back, your best option is to suspend Vim with `ctrl-z` and then resume it with `fg` when you're done. This is a very straightforward approach, widely used in the Unix world. It works out of the box and has no other requirements.

Alternatively, you can use a different window or pane with Tmux, as we're detailing in chapter XXX.

As always, you can associate a shortcut for a shell command you want to run: a good example is creating a leader command to run the current file as a spec.

    noremap <leader>s :!bundle exec rspec %<cr>

We use `noremap` to tell vim to create a key map for normal mode, assign it to `<leader>s` and then specify the command, a simple `bundle exec rspec` where we press the current file as an argument and then press enter (carriage return).


