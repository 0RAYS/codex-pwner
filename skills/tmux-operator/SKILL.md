---
name: tmux-operator
description: Operate tmux from Codex to manage persistent shell state, sessions, windows, and panes. Use when a task benefits from tmux automation, long-running commands, session reuse, layout control, or pane output capture.
---

# Tmux Operator Skill

This skill is a compact operating guide for `tmux`, derived from the local `tmux.txt` manpage. Its purpose is not to restate the full manual, but to help an agent quickly choose the right tmux command family and load only the reference page it needs.

## When to use this skill
- The user explicitly asks for `tmux`.
- The task benefits from persistent shell state instead of one-off shell commands.
- You need to keep programs running in the background while continuing other work.
- You need multiple terminal contexts, such as separate windows or panes.
- You need to inspect pane output, send keys, switch sessions, or script tmux behavior.

## How to read this skill
Load the smallest relevant reference page.

1. Start with `references/01-everyday-commands.md` for normal session and window work.
2. Read `references/02-pane-control-and-output.md` when you need panes, output capture, sending keys, or pane-to-command plumbing.
3. Read `references/03-targets-and-identifiers.md` when precise `-t` targeting matters.
4. Read `references/04-advanced-and-less-common.md` for client switching, synchronization, special flags, or tmux-side orchestration.
5. Read `references/05-interactive-keys.md` only when the user wants manual tmux interaction or shortcut explanations.

## Quick command lookup
If you already know the tmux command name and only need its syntax or option list, use this lookup order.

1. Check whether the command family is already covered by one of the reference pages above.
2. If you need a fast syntax summary, query tmux directly with `tmux list-commands <command>`.
3. If you need the full local manpage entry, use `man tmux > tmux.txt` to generate a static manual, then search command in it, typically with a pattern like `^     <command>\b`.
4. If the command behavior depends on targeting, IDs, or format strings, also read `references/03-targets-and-identifiers.md`.
5. If the command is clearly not a common session/window/pane task, check `references/04-advanced-and-less-common.md` before reading raw manpage text.

## Navigation index
Use this section as a router from task intent to command families and reference pages.

- Need to create, attach, reuse, rename, or inspect sessions
  - Commands: `new-session`, `attach-session`, `has-session`, `list-sessions`, `rename-session`, `kill-session`, `switch-client`
  - Read: `references/01-everyday-commands.md`

- Need to create a new window, move between windows, or list windows
  - Commands: `new-window`, `list-windows`, `select-window`
  - Read: `references/01-everyday-commands.md`

- Need to split panes, select panes, reuse dead panes, or rebuild a layout
  - Commands: `split-window`, `select-pane`, `list-panes`, `respawn-pane`, `respawn-window`
  - Read: `references/02-pane-control-and-output.md`

- Need to send input into a running pane or collect pane output programmatically
  - Commands: `send-keys`, `capture-pane`, `display-message`, `pipe-pane`
  - Read: `references/02-pane-control-and-output.md`

- Need to target a specific session, window, pane, or stable ID
  - Concepts: `target-session`, `target-window`, `target-pane`, session/window/pane IDs
  - Read: `references/03-targets-and-identifiers.md`

- Need exact formatted output or filtered listing for automation
  - Commands: `list-sessions`, `list-windows`, `list-panes`, `display-message`
  - Read: `references/03-targets-and-identifiers.md`

- Need client switching, background orchestration, or synchronization between tmux commands
  - Commands: `switch-client`, `run-shell`, `wait-for`, `attach-session`
  - Read: `references/04-advanced-and-less-common.md`

- Need default key bindings or user-facing interactive help
  - Concepts: prefix key, default bindings, manual navigation
  - Read: `references/05-interactive-keys.md`

## Working principles
- Prefer direct `tmux` commands over manual attachment when automation is enough.
- Use explicit targets when precision matters; avoid relying on whatever tmux considers current unless that is intentional.
- Before sending input to an existing pane, inspect its current command, path, or recent output.
- Prefer loading one focused reference page instead of many.
- If an option materially changes behavior, consult the relevant reference page before using it.

## Reference pages
- Everyday tmux tasks: `references/01-everyday-commands.md`
- Pane control and pane output: `references/02-pane-control-and-output.md`
- Targets, IDs, and formats: `references/03-targets-and-identifiers.md`
- Less common and advanced behavior: `references/04-advanced-and-less-common.md`
- Interactive key bindings: `references/05-interactive-keys.md`
