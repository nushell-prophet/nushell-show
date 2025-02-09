# Let's emulate fresh installation of nushell
with-env {
    XDG_CONFIG_HOME: (pwd | path join demo_XDG_CONFIG_HOME)
} {
    nu
}

# Let's setup the history format to sqlite
$env.config.history.file_format = "Sqlite"

# Here is my current directory
pwd

# Let's navigate to the Nushell repo using standard functionality.

# Let's speed up this process by applying this setting.

# Note that it's almost always possible to select from the list of the current directory's files by typing `"` and hitting tab.

# Here is the keybinding `option-shift-r` for pasting previously visited directories.

# FZF is a popular way to paste paths from the current directory. Here is `ctrl-t` keybidning for setting it.

# However, it only lists files in the current directory.

# Here is how to set up a keybinding for using Broot as a file picker (which is capable of navigating to parent directories).
