# dotfiles

The goal of my dotfiles is to provide great search capabilities with minimal dependencies or configuration. I utilise `git` and GNU `stow` to manage configuration files via symlinks, allowing changes to be versioned, reversible, and immediately reflected in `$HOME`.

## Features

A unified interface for:

### `CTRL-T`: File Search

Search for files under the current directory and insert the selected path at the cursor.

- Supports fuzzy matching
- Respects `.gitignore`
- Useful for quickly opening files in an editor or passing paths to commands

### `CTRL-R`: Command History

Search through your shell history using fuzzy matching.

- Filters results as you type
- Allows previewing and re-running previous commands
- Much faster than cycling through history linearly

### `ALT-C`: Directory Navigation

Interactively search for directories and cd into the selected result.

- Searches recursively from the current directory
- Ideal for navigating large projects or mono-repos
- Faster than typing or tab-completing deep paths

### `CTRL-F`: Search File Contents (Ripgrep + FZF + vi)

Search inside files using `ripgrep`, then interactively filter and preview results with `fzf`.

- Live search as you type
- Syntax-highlighted previews (via `bat`, if installed)
- Jumps directly to matching lines

## Dependencies

There are two categories of dependencies: those you install manually, and those that are handled automatically.

### Automatic (via Zinit)

When `.zshrc` is sourced for the first time, it will:

1. Install [Zinit](https://github.com/zdharma-continuum/zinit) (a zsh plugin manager)
2. Use Zinit to install all shell plugins and tools this configuration depends on

This includes `fzf`, `ripgrep`, and `bat` — which power almost all of the features listed above. You don't need to install any of these yourself.

### Manual (install these first)

These should be available from your package manager of choice. I can only verify `homebrew` at this time.

| Name                                           | Required | Role                                                                  |
| :--------------------------------------------- | :------- | :-------------------------------------------------------------------- |
| [`zsh`](https://en.wikipedia.org/wiki/Z_shell) | `true`   | This configuration is written for `zsh` only                          |
| [`git`](https://git-scm.com/)                  | `false`  | Needed to version and manage changes to this repository               |
| [`stow`](https://www.gnu.org/software/stow/)   | `false`  | Creates symlinks from `$HOME` into this repository                    |
| [`kitty`](https://sw.kovidgoyal.net/kitty/)    | `false`  | This repository includes configuration specific to the kitty terminal |

## GNU Stow

GNU Stow is a **symlink manager**, not a configuration tool. It does not copy files, but, creates symbolic links from your `$HOME` directory back into this repository.

### Requirements

Stow expects:

1. A directory structure that mirrors the final filesystem layout
2. No conflicting files already existing at the target locations
3. To be run from inside the directory that contains the packages to be linked

In this repository, `$HOME/dotfiles` is treated as the _source of truth_, and `$HOME` is the target.

### How it works

When you run:

```bash
stow .
```

Stow:

- Walks the directory tree inside `~/dotfiles`
- Creates symlinks in `$HOME` that point back to matching files in `~/dotfiles`
- Refuses to overwrite existing files that it does not manage

At no point are files copied, instead, edits always happen inside the repository.

## Repository Guide

### 1. Install

Clone this repository to the root of your `$HOME` directory and install the dependencies listed above. At this stage, no files are modified and no configuration is active.

### 2. Backup

Its very likely that you already have configuration files that match files in this repository.

Stow will refuse to create symlinks if a file already exists, so you **must** back them up first:

```bash
mv .zshrc .zshrc_bak
```

After backing up all conflicting files, your shell or editor may appear broken — this is expected and temporary.

### 3. Set up

Navigate into the `dotfiles` repository and run:

```bash
stow .
```

This creates symlinks in `$HOME` that point back to files in `~/dotfiles`.

For example:

```bash
~/.zshrc → ~/dotfiles/.zshrc
```

Your shell and application configurations are now “live” again, but are fully managed by this repository.

You can verify this by running:

```bash
source ~/.zshrc
```

> [!Important]
> Please read the "Dependency" section of this README to understand what is happening when `.zshrc` is first sourced.

### 4. Modify

Stow relies entirely on directory structure. **The path to a file inside `~/dotfiles` must exactly match the path where the symlink should appear relative to `$HOME`.**

Example layout:

```text
$HOME
├─ .zshrc        → symlink
└─ dotfiles/
   └─ .zshrc
```

Because of this:

- You always edit files inside `~/dotfiles`
- You never edit the symlinked files directly
- Running `stow .` again will only create new symlinks for new files — existing links do not need to be refreshed
