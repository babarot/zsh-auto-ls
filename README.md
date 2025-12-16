# zsh-auto-ls

Automatically run `ls` after changing directories and `git status` when there are uncommitted changes — just press Enter on an empty command line.

## Features

- **Auto `ls` on directory change**: Press Enter on an empty line after `cd` to see directory contents
- **Auto `git status`**: In a git repository, press Enter to see uncommitted changes
- **Customizable**: Configure the `ls` command and enable/disable git status
- **Non-intrusive**: Only triggers on empty command line; normal commands work as expected

## Installation

### [afx](https://github.com/babarot/afx)

Add to your `~/.config/afx/github.yaml`:

```yaml
github:
  - name: babarot/zsh-auto-ls
    description: Auto ls on directory change, git status on empty Enter
    owner: babarot
    repo: zsh-auto-ls
    plugin:
      sources:
        - auto-ls.zsh
```

### [zplug](https://github.com/zplug/zplug)

```zsh
zplug "babarot/zsh-auto-ls"
```
### Manual

Clone the repository and source the plugin:

```bash
git clone https://github.com/babarot/zsh-auto-ls ~/.zsh/zsh-auto-ls
echo 'source ~/.zsh/zsh-auto-ls/auto-ls.zsh' >> ~/.zshrc
```

## Configuration

Configuration variables should be set **before** sourcing the plugin.

### `AUTO_LS_COMMAND`

The command to run for listing directory contents. Defaults to your `ls` alias if defined, otherwise `ls`.

```zsh
# Use exa instead of ls
AUTO_LS_COMMAND="exa --icons"

# Use lsd
AUTO_LS_COMMAND="lsd -la"
```

### `AUTO_LS_GIT_STATUS`

Enable or disable automatic `git status` when pressing Enter in a git repository with uncommitted changes. Defaults to `true`.

```zsh
# Disable auto git status
AUTO_LS_GIT_STATUS=false
```

## Behavior

When you press Enter on an **empty command line**, the following actions are triggered:

| Condition | Action |
|-----------|--------|
| Changed to a new directory | Run `ls` |
| Same directory, inside git repo, uncommitted changes exist | Run `git status` |
| Same directory, inside git repo, no changes | Nothing |
| Same directory, outside git repo | Nothing |

**Note**: If you type any command and press Enter, it executes normally. This plugin only activates on empty input.

## How It Works

1. The plugin binds a custom widget to the Enter key (`^m`)
2. When you press Enter on an empty command line, it sets a flag
3. A `precmd` hook checks the flag and runs the appropriate command based on context

Normal command execution is unaffected.

## License

MIT

## Author

[@babarot](https://github.com/babarot)
