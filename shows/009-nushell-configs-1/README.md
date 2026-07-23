# Nushell configs and their effect (part 1)

[Youtube](https://youtu.be/WTgFInlYFpI)

Small Nushell settings, shown one at a time, with the visible difference each one makes. Every setting demoed here is tagged `#:nu-show-09` in my config, so you can jump straight to it in [`my-dotfiles/nushell/config.nu`](https://github.com/nushell-prophet/my-dotfiles/blob/main/nushell/config.nu) — search `#:nu-show-09`.

## History — store it in SQLite

[▶ 0:48](https://youtu.be/WTgFInlYFpI?t=48)

```nu
$env.config.history.file_format = "Sqlite"
$env.config.history.isolation = true
$env.config.history.max_size = 5000000
```

With `Sqlite`, history is a real database instead of a flat text file. Now every command carries its directory, exit code, and timestamp — so you can query it (`open $nu.history-path | query db "..."`). The working-directories menu below relies on exactly this.

`isolation = true` means a session's up-arrow only recalls commands from that same session, even though all sessions still write into the one shared database. `max_size = 5000000` keeps that database from dropping old rows, so the full record stays searchable.

## Table look — footer and header line

[▶ 2:28](https://youtu.be/WTgFInlYFpI?t=148)

```nu
$env.config.footer_mode = "Always"
$env.config.table.header_on_separator = true
```

`footer_mode = "Always"` repeats the column headers at the bottom of every table — handy when a table is tall and the top headers have scrolled away. `header_on_separator = true` moves the header text onto the top border line instead of its own row, so each table is one line shorter.

## Abbreviations — expansions that land in history

[▶ 3:03](https://youtu.be/WTgFInlYFpI?t=183)

```nu
$env.config.abbreviations = {
    cs: 'claude --dangerously-skip-permissions'
    cn: 'claude-nu'
    gd: 'git diff'
    gp: 'git pull'
    gs: 'git status'
    gl: 'git log'
    gco: 'git checkout'
    gb: 'git branch'
    grv: 'git remote -v'
    ut: 'use toolkit.nu'
    lg: 'lazygit'
}
```

An abbreviation expands as you type — write `gs`, press space, and it becomes `git status` right on the command line. It fires anywhere in the line, not only in command position.

The point is what an alias can't do: the *expanded* command is what runs and what gets written to history. So history search, the fish-style hints, and any query over your history all see the real `git status`, never a private shortcut. (These keys were checked against 7.8k history entries and `PATH` first, so none collides with a command or argument you already type.)

## Working-directories menu — Alt+Shift+R

[▶ 3:29](https://youtu.be/WTgFInlYFpI?t=209)

```nu
$env.config.keybindings ++= [
    {
        name: working_dirs_cd_menu
        modifier: alt_shift
        keycode: char_r
        mode: emacs
        event: {send: menu name: working_dirs_cd_menu}
    }
]
```

Press `Alt+Shift+R` to open a list of the directories you have visited, most-recently-used first. Type to filter, press Enter to `cd` there. The list comes straight from the SQLite history (`SELECT cwd FROM history GROUP BY cwd ORDER BY MAX(start_timestamp) DESC`) — the first setting in this episode is what makes that query possible.

## Variables menu — Alt+O

[▶ 5:14](https://youtu.be/WTgFInlYFpI?t=314)

```nu
$env.config.keybindings ++= [
    {
        name: vars_menu
        modifier: alt
        keycode: char_o
        mode: [emacs]
        event: {
            send: executehostcommand
            cmd: (vars-menu-source)
        }
    }
]
```

Press `Alt+O`, type part of a variable name to filter with fzf, press Enter to insert it into the command line.

It is built with `executehostcommand` + fzf instead of a native Nushell menu on purpose: since ~0.101, `scope variables` inside a menu's source closure only sees the closure's own scope ([nushell#14071](https://github.com/nushell/nushell/issues/14071)), so a native menu can't list your real variables. Running the command in REPL scope sidesteps that and sees them all.

## Raw-string toggle — Ctrl+V

[▶ 6:16](https://youtu.be/WTgFInlYFpI?t=376)

```nu
$env.config.keybindings ++= [
    {
        name: prompt_to_raw_string
        modifier: control
        keycode: char_v
        mode: [emacs vi_normal vi_insert]
        event: {
            send: executehostcommand
            cmd: (prompt_to_raw_source)
        }
    }
]
```

`Ctrl+V` wraps the current command line in a raw string — `r#'...'#` — picking enough `#` marks that nothing inside can close it early. Press it again and it unwraps back to the plain command. This makes it easy to copy a command that is full of quotes without fighting the escaping.
