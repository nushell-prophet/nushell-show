# Nushell configs and their effect (part 1)

[Youtube](#) <!-- pending upload -->

Small Nushell settings, shown one at a time, with the visible difference each one makes. Every setting demoed here is tagged `#:nu-show-09` in my config, so you can jump straight to it in [`my-dotfiles/nushell/config.nu`](https://github.com/nushell-prophet/my-dotfiles/blob/main/nushell/config.nu) — search `#:nu-show-09`.

## History — store it in SQLite

```nu
$env.config.history.file_format = "Sqlite"
$env.config.history.isolation = true
$env.config.history.max_size = 5000000
```

SQLite history unlocks real queries (cwd, exit status, timestamps) instead of a flat text file. `isolation = true` keeps each session's up-arrow separate.

## Table look — footer and header line

```nu
$env.config.footer_mode = "Always"
$env.config.table.header_on_separator = true
```

Column headers repeat at the bottom of long tables, and the header sits on the border line.

## Abbreviations — expansions that land in history

```nu
$env.config.abbreviations = { cs: 'claude --dangerously-skip-permissions', gs: 'git status', lg: 'lazygit', ... }
```

Unlike aliases, the expanded command is written to history, so hints and history search see the real command.

## Keybinding — working-directories menu (Alt+Shift+R)

Browse recent directories from history and `cd` into one.

## Keybinding — variables menu (fzf)

Filter live variables by name and insert the chosen one.

## Keybinding — wrap command as a raw string (Ctrl+V)

Wrap the current command line in raw-string form for easy copying.

<!-- Draft: beats mirror the #:nu-show-09 tags in config.nu; prose and the Youtube link are filled after recording. -->
