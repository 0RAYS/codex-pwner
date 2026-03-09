# Targets, identifiers, and formats

Use this page when a tmux command is acting on the wrong object, when `-t` syntax matters, or when you need stable machine-friendly output.

### `target-session`
**When**
- A command takes `-t target-session`.
- You need exact session matching.
- You need to understand how tmux resolves a session name.

**Syntax**
```text
session
$session_id
=session_name
```

**Key options**
- Resolution order: session ID, exact name, name prefix, glob pattern.
- `=` prefix: exact match only.
- If omitted, tmux uses the current session if available, otherwise the most recently used one.

**Pitfalls**
- Prefix matching can select the wrong session when names are similar.
- Multiple matches are an error.

### `target-window`
**When**
- A command takes `-t target-window`.
- You need exact window addressing within a session.
- You need special tokens like last or next window.

**Syntax**
```text
session:window
@window_id
session:{last}
session:+2
```

**Key options**
- Resolution order for `window`: special token, index, window ID, exact name, name prefix, glob pattern.
- Exact-only matching also supports `=`.
- Special tokens: `{start}`/`^`, `{end}`/`$`, `{last}`/`!`, `{next}`/`+`, `{previous}`/`-`.
- `+` and `-` may include an offset.
- Empty window name may mean the next unused index for commands like `new-window`.

**Pitfalls**
- A bare window name may resolve by prefix, not exact match.
- Relative targets like `+` and `-` depend on current session state.

### `target-pane`
**When**
- A command takes `-t target-pane`.
- You need to address a specific pane inside a window.
- You need directional pane tokens.

**Syntax**
```text
session:window.pane
%pane_id
session:window.{right-of}
```

**Key options**
- A pane target may be a pane ID directly, such as `%7`.
- If the pane index is omitted, tmux uses the active pane in that window.
- Pane tokens: `{last}`/`!`, `{next}`/`+`, `{previous}`/`-`, `{top}`, `{bottom}`, `{left}`, `{right}`, `{top-left}`, `{top-right}`, `{bottom-left}`, `{bottom-right}`, `{up-of}`, `{down-of}`, `{left-of}`, `{right-of}`.

**Pitfalls**
- Omitting the pane index makes the command depend on current active-pane state.
- Directional tokens are resolved relative to the active pane.

### Stable IDs
**When**
- Names may change.
- You want a stable handle for later tmux commands.
- You are scripting tmux output and follow-up actions.

**Syntax**
```text
$session_id
@window_id
%pane_id
```

**Key options**
- Session IDs begin with `$`.
- Window IDs begin with `@`.
- Pane IDs begin with `%`.
- IDs stay stable for the lifetime of the tmux server.

**Pitfalls**
- IDs are stable only within the current tmux server lifetime.
- Recreating objects produces new IDs.

### `{mouse}` and `{marked}` special targets
**When**
- You are working in interactive or mouse-driven flows.
- A command should act on the marked pane or the location of the last mouse event.

**Syntax**
```text
{mouse}
=
{marked}
~
```

**Key options**
- `{mouse}` or `=`: the session, window, or pane from the most recent mouse event.
- `{marked}` or `~`: the marked pane.

**Pitfalls**
- These targets are stateful and depend on prior interaction.
- They are usually poor choices for deterministic automation.

### Formats and filtered listings
**When**
- You need machine-friendly output from tmux.
- You want only selected rows or selected fields.
- You want metadata such as IDs, names, commands, or paths.

**Syntax**
```text
list-sessions -F <format> -f <filter>
list-windows -F <format> -f <filter>
list-panes -F <format> -f <filter>
display-message -p '<format>'
```

**Key options**
- `-F`: output format string.
- `-f`: filter expression for commands that support it.
- `display-message -p`: print to stdout.
- `display-message -a`: list format variables and their current values.
- `display-message -v`: show verbose format parsing.

**Pitfalls**
- Default output is often human-friendly rather than parse-friendly.
- Format values depend on the chosen target pane, window, or session context.
