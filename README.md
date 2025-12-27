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

## What is GNU Stow?

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

### 1. Install prerequisites

Before cloning this repository, make sure the following tools are available on your system.

#### Required

- **zsh**  
  This configuration is written for `zsh` only. If `zsh` is not your default shell, you should switch to it first.

#### Strongly recommended

- **git**  
  Used to clone, version, and update this repository.
- **GNU stow**  
  Manages symlinks from `$HOME` back into this repository. No files are copied.

#### Optional

- **kitty**  
  This repository includes configuration specific to the kitty terminal. If you don’t use kitty, those files will simply be ignored.

These should be installable via your system package manager. I currently verify this setup using Homebrew.

Once these tools are installed, clone the repository into the root of your `$HOME` directory:

```bash
cd ~
git clone <repo-url> dotfiles
```

At this stage, no files are modified and no configuration is active.

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

#### What happens when `.zshrc` is first sourced?

When you run:

```bash
source ~/.zshrc
```

the following happens automatically:

- Zinit (a zsh plugin manager) is installed if it is not already present
- Zinit installs all shell plugins and tools required by this configuration

This includes:

- `fzf`: fuzzy finder powering CTRL-T, CTRL-R, ALT-C
- `ripgrep`: fast file content search for CTRL-F
- `bat`: syntax-highlighted previews (optional but recommended)

You do not need to install any of these manually.
They are fully managed by Zinit and kept out of your system package manager.

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

## FAQ

### Stow reports existing files and suggests `stow --adopt`. What does that mean?

When GNU Stow finds a file in `$HOME` that conflicts with a file in this repository, it refuses to proceed and reports the conflict. In its output, Stow will often suggest re-running the command with:

```bash
stow --adopt .
```

The `--adopt` flag tells Stow to take ownership of the existing files instead of failing.

Specifically, Stow will:

- Move the existing file from `$HOME` into the corresponding location inside `~/`
- Replace the original file in `$HOME` with a symlink pointing back into the repository

After adoption, the filesystem ends up in the same state as if the file had always lived in ~/dotfiles:

```
~/.zshrc        → symlink
~/dotfiles/.zshrc   (real file, now under version control)
```

`--adopt` is useful when:

- You are migrating an existing setup into this repository
- You trust the current contents of the file in `$HOME`
- You want Stow to do the file move for you instead of doing it manually

When not to use `--adopt`

Avoid `--adopt` if

- You are unsure which version of a file you want to keep
- You want to inspect or clean up the file before committing it
- You are stowing multiple packages and don’t want accidental adoption

Because `--adopt` moves files automatically, it’s best treated as a migration tool rather than a default workflow.

If you prefer a more explicit approach, manually backing up files and running stow . without `--adopt` keeps every step under your control.
