# Everyday tmux commands

Use this page for the most common session and window tasks.

## Session commands

### `has-session`
**When**
- Check whether a named session already exists.

**Syntax**
```bash
tmux has-session [-t target-session]
```

**Key options**
- `-t`: session to test.

**Pitfalls**
- It reports by exit status, not by friendly text.

### `new-session`
**When**
- Create a new session.
- Create-or-reuse with `-A`.

**Syntax**
```bash
tmux new-session [-AdDEPX] [-c start-directory] [-e environment] [-f flags] [-F format] [-n window-name] [-s session-name] [-t group-name] [-x width] [-y height] [shell-command [argument ...]]
```

**Key options**
- `-d`: detached creation.
- `-s`: session name.
- `-n`: initial window name.
- `-c`: working directory for new windows.
- `-A`: behave like `attach-session` if the session already exists.
- `-P`: print information after creation.
- `-F`: format used with `-P`.
- `-e VARIABLE=value`: set environment variables.
- `-x`, `-y`: explicit size.
- `-t`: session group target.

**Pitfalls**
- `-d` is usually better for automation.
- With `-A`, `-D` and `-X` follow `attach-session` semantics.
- `-n` and `shell-command` are invalid with `-t` session groups.

### `attach-session`
**When**
- Interactively attach to an existing session.
- Switch the current client to another session from inside tmux.

**Syntax**
```bash
tmux attach-session [-dErx] [-c working-directory] [-f flags] [-t target-session]
```

**Key options**
- `-t`: target session.
- `-d`: detach other clients from that session.
- `-x`: also send `SIGHUP` to their parent process.
- `-c`: update the session working directory.
- `-f`: set client flags.
- `-r`: shorthand for read-only and ignore-size.
- `-E`: skip `update-environment`.

**Pitfalls**
- Usually unnecessary for non-interactive automation.
- `-d` and `-x` affect other attached clients.

### `list-sessions`
**When**
- Discover existing sessions.
- Get machine-friendly session listings.

**Syntax**
```bash
tmux list-sessions [-F format] [-f filter]
```

**Key options**
- `-F`: output format.
- `-f`: filter expression.

**Pitfalls**
- Default output is human-readable, not always parse-friendly.

### `rename-session`
**When**
- Give a session a stable or clearer name.

**Syntax**
```bash
tmux rename-session [-t target-session] new-name
```

**Key options**
- `-t`: session to rename.

**Pitfalls**
- Name changes can break scripts that target by name instead of ID.

### `kill-session`
**When**
- Destroy one session.
- Destroy all sessions except one with `-a`.

**Syntax**
```bash
tmux kill-session [-aC] [-t target-session]
```

**Key options**
- `-t`: target session.
- `-a`: kill every other session.
- `-C`: clear alerts in linked windows.

**Pitfalls**
- `-a` has broad scope; use only when intentional.

### `switch-client`
**When**
- Move an attached client to another session.
- Change client key-table behavior.

**Syntax**
```bash
tmux switch-client [-ElnprZ] [-c target-client] [-t target-session] [-T key-table]
```

**Key options**
- `-c`: target client.
- `-t`: target session, or special pane target in some cases.
- `-l`, `-n`, `-p`: last, next, previous session.
- `-r`: toggle read-only and ignore-size.
- `-T`: set next key table.
- `-E`: skip `update-environment`.
- `-Z`: preserve zoom when targeting a pane.

**Pitfalls**
- This is client-focused, not just session-focused.

## Window commands

### `new-window`
**When**
- Create a new window.
- Reuse an existing named window with `-S`.

**Syntax**
```bash
tmux new-window [-abdkPS] [-c start-directory] [-e environment] [-F format] [-n window-name] [-t target-window] [shell-command [argument ...]]
```

**Key options**
- `-n`: window name.
- `-t`: insertion target or destination index.
- `-a`, `-b`: insert after or before target.
- `-d`: do not select the new window.
- `-k`: replace an existing target window.
- `-S`: select an existing window with the same name.
- `-c`: working directory.
- `-P`: print info.
- `-F`: output format for `-P`.
- `-e VARIABLE=value`: set environment variables.

**Pitfalls**
- `-S` avoids duplicate named windows.
- `-d` is often better for scripted flows.

### `list-windows`
**When**
- Discover windows in one session or across the server.

**Syntax**
```bash
tmux list-windows [-a] [-F format] [-f filter] [-t target-session]
```

**Key options**
- `-a`: list all windows.
- `-t`: target session.
- `-F`: output format.
- `-f`: filter expression.

**Pitfalls**
- Without `-a`, scope is per-session.

### `select-window`
**When**
- Change the active window.

**Syntax**
```bash
tmux select-window [-lnpT] [-t target-window]
```

**Key options**
- `-t`: target window.
- `-l`: last window.
- `-n`: next window.
- `-p`: previous window.
- `-T`: if already current, behave like `last-window`.

**Pitfalls**
- Relative selection like next/previous depends on current session state.
