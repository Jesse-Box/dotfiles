# dotfiles
The goal of my dotfiles is to provide great search capabilities with minimal dependencies or configuration. I utilise `git` and GNU `stow` to modify repository files in safe way. Watch this [youtube video](https://www.youtube.com/watch?v=y6XCebnB9gs) to learn more.

## Dependances
Each dependency *should* be accessible from your package manager of choice. However, I can only verify this for `homebrew` right now.

| Name  | Required  | Role  |
|:---|:---|:---|
| [`zsh`](https://en.wikipedia.org/wiki/Z_shell)  | `true`  | Unfortunately, I only have a configuration file available for `zsh`  |
| [`fzf`](https://github.com/junegunn/fzf#setting-up-shell-integration)  | `true`  | Without `fzf`, you can't search and filter through lists of items, such as files or command history, in an interactive way  |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep/tree/master)  | `true`  | Without `ripgrep`, you can't search through files and directories for specific text patterns  |
| [`bat`](https://github.com/sharkdp/bat)  | `false`  | A drop-in replacement for the `cat` command. Without `bat`, the `fzf` preview won't have syntax highlighting.  |
| [`git`](https://git-scm.com/)  | `false`  | Without `git`, you won't be able to safely make changes to the files within this repository  |
| [`stow`](https://www.gnu.org/software/stow/)  | `false`  | Without `stow`, these repository files won't be symlinked to their expected locations relative to `$HOME` |
| [`kitty`](https://sw.kovidgoyal.net/kitty/)  | `false`  | This repository has configuration files specific to the kitty terminal emulator  |
