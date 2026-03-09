# Advanced and less common tmux behavior

Use this page for client-oriented behavior, tmux-side orchestration, synchronization, and the less common flags that are easy to forget.

### `switch-client`
**When**
- Move an attached client to another session.
- Target a specific client instead of changing tmux objects globally.
- Switch the client's next key table.

**Syntax**
```bash
tmux switch-client [-ElnprZ] [-c target-client] [-t target-session] [-T key-table]
```

**Key options**
- `-c`: target client.
- `-t`: target session, or a pane target in special cases.
- `-l`, `-n`, `-p`: last, next, previous session.
- `-r`: toggle read-only and ignore-size.
- `-T`: set the next key table.
- `-E`: skip `update-environment`.
- `-Z`: preserve zoom when switching via a pane target.

**Pitfalls**
- This is client-focused, not just session-focused.
- `-T` affects how the next key is interpreted, not the whole tmux server.

### `attach-session` client flags
**When**
- Attach with non-default client behavior.
- Fine-tune how a client participates in size, output, or control-mode behavior.

**Syntax**
```bash
tmux attach-session [-dErx] [-c working-directory] [-f flags] [-t target-session]
```

**Key options**
- `-f active-pane`: client tracks its own active pane.
- `-f ignore-size`: client does not affect other client sizes.
- `-f no-detach-on-destroy`: avoid detaching if another session is available.
- `-f no-output`: suppress pane output in control mode.
- `-f pause-after=seconds`: pause output after backlog in control mode.
- `-f read-only`: client becomes read-only.
- `-f wait-exit`: wait for an empty line before exiting in control mode.
- `-r`: shorthand for read-only and ignore-size.

**Pitfalls**
- Most normal automation does not need these flags.
- These flags change client behavior, not pane or session semantics.

### `run-shell`
**When**
- Run a shell command from tmux without creating a window.
- Run a tmux command through tmux itself with `-C`.
- Schedule or background a tmux-side action.

**Syntax**
```bash
tmux run-shell [-bCE] [-c start-directory] [-d delay] [-t target-pane] [shell-command]
```

**Key options**
- `-b`: run in the background.
- `-C`: treat the argument as a tmux command, not a shell command.
- `-E`: redirect stderr to stdout.
- `-c`: start directory.
- `-d`: delay in seconds.
- `-t`: pane used when tmux displays command output.

**Pitfalls**
- Without `-C`, tmux runs the command via `/bin/sh`.
- Output handling differs from pane-bound commands because no new window is created.

### `wait-for`
**When**
- Synchronize tmux-driven flows.
- Block until another tmux action signals readiness.
- Use a lightweight lock or wakeup channel.

**Syntax**
```bash
tmux wait-for [-L | -S | -U] channel
```

**Key options**
- no option: wait until another tmux action signals the same channel.
- `-S`: signal the channel and wake waiters.
- `-L`: lock the channel.
- `-U`: unlock the channel.

**Pitfalls**
- Forgetting to signal or unlock can leave tmux flows waiting indefinitely.
- Channel names are just strings, so collisions are possible if naming is sloppy.

### `list-clients`
**When**
- Inspect attached tmux clients.
- Need client-level output instead of session/window/pane output.

**Syntax**
```bash
tmux list-clients [-F format] [-f filter] [-t target-session]
```

**Key options**
- `-F`: output format.
- `-f`: filter expression.
- `-t`: limit to clients connected to a session.

**Pitfalls**
- Client data is different from session data; do not confuse them when scripting.

### Command parsing model
**When**
- Build multi-command tmux invocations.
- A tmux command works in `.tmux.conf` but fails in a shell command string.
- You need to reason about where quoting or semicolon splitting happens.

**Syntax**
```text
shell -> shell parsing first -> tmux parsing second
.tmux.conf / command prompt / bind-key -> tmux parsing directly
```

**Key options**
- semicolon-separated tmux commands need correct shell escaping when called from the shell.
- quoted strings may be interpreted differently depending on whether the shell or tmux parses them first.

**Pitfalls**
- Many quoting bugs are shell-parsing bugs, not tmux bugs.
- A command sequence that is valid in tmux config may need escaping when run from a shell.
