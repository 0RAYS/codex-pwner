# Pane control and output

Use this page for splits, pane reuse, sending input, and collecting output.

## Pane discovery and selection

### `list-panes`
**When**
- Discover panes in a window, session, or entire server.

**Syntax**
```bash
tmux list-panes [-as] [-F format] [-f filter] [-t target]
```

**Key options**
- `-a`: list panes across the server.
- `-s`: treat `target` as a session.
- `-t`: target window or session.
- `-F`: output format.
- `-f`: filter expression.

**Pitfalls**
- Without `-a` or `-s`, `target` is a window.

### `select-pane`
**When**
- Move focus, jump directionally, mark a pane, or toggle zoom.

**Syntax**
```bash
tmux select-pane [-DdeLlMmRUZ] [-T title] [-t target-pane]
```

**Key options**
- `-t`: target pane.
- `-L`, `-R`, `-U`, `-D`: move selection by direction.
- `-l`: last active pane.
- `-e`: enable input to the pane.
- `-d`: disable input to the pane.
- `-Z`: keep the window zoomed if it was already zoomed.
- `-m`: mark pane.
- `-M`: clear marked pane.
- `-T`: set pane title.

**Pitfalls**
- This changes pane state or focus; it does not create panes.

## Pane creation and reuse

### `split-window`
**When**
- Create a new pane by splitting an existing one.
- Create an empty pane or control pane geometry.

**Syntax**
```bash
tmux split-window [-bdfhIvPZ] [-c start-directory] [-e environment] [-F format] [-l size] [-t target-pane] [shell-command [argument ...]]
```

**Key options**
- `-t`: pane to split.
- `-h`: horizontal split.
- `-v`: vertical split; default if neither is given.
- `-l size`: new pane size; `%` means percentage.
- `-b`: place new pane left of or above target.
- `-d`: do not select the new pane.
- `-f`: span full window width or height.
- `-Z`: zoom if the window is not zoomed, or keep it zoomed if it already is.
- `-c`: working directory.
- `-e VARIABLE=value`: set environment variables.
- `-P`: print info.
- `-F`: output format for `-P`.
- `-I`: with no shell command, create an empty pane and forward stdin into it.

**Pitfalls**
- `-f` changes geometry more than many users expect.
- Empty panes are useful, but only if you intend to feed them later.

### `respawn-pane`
**When**
- Restart a dead pane.
- Force-replace a running pane command with `-k`.

**Syntax**
```bash
tmux respawn-pane [-k] [-c start-directory] [-e environment] [-t target-pane] [shell-command [argument ...]]
```

**Key options**
- `-t`: target pane.
- `-k`: kill an existing command first.
- `-c`: new working directory.
- `-e VARIABLE=value`: set environment variables.

**Pitfalls**
- Without `-k`, the pane normally needs to be inactive first.

### `respawn-window`
**When**
- Restart a dead window.
- Force-replace a running window command with `-k`.

**Syntax**
```bash
tmux respawn-window [-k] [-c start-directory] [-e environment] [-t target-window] [shell-command [argument ...]]
```

**Key options**
- `-t`: target window.
- `-k`: kill an existing command first.
- `-c`: new working directory.
- `-e VARIABLE=value`: set environment variables.

**Pitfalls**
- Same semantics as `respawn-pane`, but at window scope.

## Input and output

### `send-keys`
**When**
- Send key events or literal text into a pane.
- Drive copy-mode commands with `-X`.

**Syntax**
```bash
tmux send-keys [-FHKlMRX] [-c target-client] [-N repeat-count] [-t target-pane] [key ...]
```

**Key options**
- `-t`: target pane.
- `-K`: send to a client key table instead of a pane.
- `-l`: literal UTF-8, not key-name lookup.
- `-H`: hexadecimal ASCII input.
- `-N`: repeat count.
- `-F`: expand formats in arguments.
- `-R`: reset terminal state.
- `-X`: send a copy-mode command.
- `-M`: pass through a mouse event.

**Pitfalls**
- Without `-l`, words like `Enter` or `Up` are treated as key names.

### `capture-pane`
**When**
- Read pane output for inspection or scripting.
- Capture scrollback or alternate-screen contents.

**Syntax**
```bash
tmux capture-pane [-aepPqCJMN] [-b buffer-name] [-E end-line] [-S start-line] [-t target-pane]
```

**Key options**
- `-p`: print to stdout.
- `-t`: target pane.
- `-S`, `-E`: start and end lines.
- `-a`: use alternate screen.
- `-M`: use mode screen.
- `-e`: keep escape sequences.
- `-C`: octal-escape non-printables.
- `-N`: preserve trailing spaces.
- `-J`: preserve spaces and join wrapped lines.
- `-T`: ignore empty trailing positions.
- `-q`: suppress alternate-screen errors.
- `-P`: capture only an incomplete escape sequence.
- `-b`: write to a tmux buffer.

**Pitfalls**
- `0` starts at the visible pane; negative line numbers refer to history.
- `-a` changes source data from history to alternate-screen contents.

### `display-message`
**When**
- Print format values.
- Inspect pane metadata.
- Send stdin into an empty pane.

**Syntax**
```bash
tmux display-message [-aCIlNpv] [-c target-client] [-d delay] [-t target-pane] [message]
```

**Key options**
- `-p`: print to stdout.
- `-t`: source pane for formats.
- `-c`: target client.
- `-d`: display duration; `0` waits for a key.
- `-N`: ignore key presses.
- `-C`: keep pane updates visible during display.
- `-l`: literal text, no format expansion.
- `-a`: list available format variables and values.
- `-v`: verbose format parsing.
- `-I`: forward stdin to an empty pane.

**Pitfalls**
- Without `-l`, tmux interprets the message as a format string.

### `pipe-pane`
**When**
- Stream pane output into a command.
- Feed command output back into a pane.
- Build a simple one-pane bridge.

**Syntax**
```bash
tmux pipe-pane [-IOo] [-t target-pane] [shell-command]
```

**Key options**
- `-t`: target pane.
- `-O`: connect pane output to command stdin.
- `-I`: connect command stdout to pane input.
- `-o`: only open a pipe if none exists.

**Pitfalls**
- If neither `-I` nor `-O` is given, tmux defaults to `-O`.
- Omitting the shell command closes the current pipe.
- A pane can only have one active pipe command.
