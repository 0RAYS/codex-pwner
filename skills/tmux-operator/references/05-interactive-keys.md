# Interactive key bindings

Use this page only when manual tmux interaction matters. This page reflects the local bindings in `configs/tmux.conf`, not upstream tmux defaults.

### Prefix key model
**When**
- Explain how tmux interaction works in this container.
- Interpret user instructions written as key chords.

**Syntax**
```text
C-a <key>
```

**Key options**
- `C-a`: local tmux prefix.
- `C-b`: unbound as the prefix in this config.
- After the prefix, tmux interprets the next key as a tmux command key.

**Pitfalls**
- Do not assume upstream default `C-b` in this environment.
- These bindings are local-config-aware, but users may still override them further.

### Window keys
**When**
- A user wants to create or switch windows manually.

**Syntax**
```text
C-a c | C-a Right | C-a Left | C-a w
```

**Key options**
- `C-a c`: create a new window in `#{pane_current_path}`.
- `C-a Right`: next window.
- `C-a Left`: previous window.
- `C-a w`: choose a window interactively.

**Pitfalls**
- `C-a n` and `C-a p` are unbound in this config.
- `C-a c` keeps the current pane path, which differs from a plain default `new-window`.

### Pane movement keys
**When**
- A user wants to move between panes manually.
- Home-row navigation is preferred over arrow navigation.

**Syntax**
```text
C-a h | C-a j | C-a k | C-a l | C-a o | C-a ; | C-a Arrow
```

**Key options**
- `C-a h`: select pane left.
- `C-a j`: select pane down.
- `C-a k`: select pane up.
- `C-a l`: select pane right.
- `C-a o`: next pane.
- `C-a ;`: previous active pane.
- `C-a` + arrow keys: move between panes using the default bindings.

**Pitfalls**
- `C-a l` no longer means previous window here; it is rebound to pane-right.
- Pane navigation remains stateful and depends on the active pane.

### Split keys
**When**
- A user wants to split panes manually while preserving the current working directory.

**Syntax**
```text
C-a v | C-a s
```

**Key options**
- `C-a v`: horizontal split with start directory `#{pane_current_path}`.
- `C-a s`: vertical split with start directory `#{pane_current_path}`.

**Pitfalls**
- `C-a s` no longer opens interactive session selection here; it is rebound to vertical split.
- Upstream `%` and `"` defaults are not the primary local split bindings to teach first.

### Inspection and utility keys
**When**
- A user wants to detach, inspect pane numbers, browse bindings, zoom, or kill a pane.

**Syntax**
```text
C-a d | C-a q | C-a [ | C-a ? | C-a t | C-a z | C-a x
```

**Key options**
- `C-a d`: detach the current client.
- `C-a q`: briefly show pane indexes.
- `C-a [`: enter copy mode.
- `C-a ?`: list key bindings.
- `C-a t`: show the time.
- `C-a z`: toggle pane zoom.
- `C-a x`: kill the current pane.

**Pitfalls**
- `C-a x` is destructive for the current pane.
- `C-a [` enters copy mode, which changes how later keys are interpreted.
- `C-a ?` shows the live binding table, which may differ from either upstream defaults or this repo config if changed again.

### Copy mode and input behavior
**When**
- A user is working inside copy mode.
- A user asks why navigation keys feel more Vim-like.

**Syntax**
```text
mode-keys vi
mouse on
base-index 1
pane-base-index 1
```

**Key options**
- `mode-keys vi`: copy mode uses vi-style key behavior.
- `mouse on`: mouse actions are enabled.
- `base-index 1`: window numbering starts at `1`.
- `pane-base-index 1`: pane numbering starts at `1`.

**Pitfalls**
- Tutorials that assume Emacs-style copy-mode keys may be misleading here.
- Users may expect window or pane numbering to start at `0`, but this config starts both at `1`.
