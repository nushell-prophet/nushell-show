# 004 - Setting $env.XDG_CONFIG_HOME

[Youtube](https://youtu.be/7y2ihkdFU50)

On macOS, the default location for Nushell configurations is `~/Library/Application Support/nushell`. The issue with this path is that it contains a space, which can lead to problems and inconveniences later.

In Linux, the `XDG_CONFIG_HOME` environment variable is part of the XDG Base Directory Specification, which defines standard locations for various types of configuration files. However, on macOS, the `XDG_CONFIG_HOME` variable is not set by default, as macOS uses its own conventions for handling configuration files.

In this video, we will manually set the `XDG_CONFIG_HOME` environment variable so that Nushell and other applications can use it to locate configuration files. [The Nushell Book](https://www.nushell.sh/book/configuration.html) has some details on setting `XDG_CONFIG_HOME` too.

```nu
# Start Nushell without using history so it won't interact with the data folder during our operations
# To avoid problems, do not launch or use another instance of Nushell during this session
> nu --no-history

# See that the current path contains space and might cause inconvenience and even problems
> $nu.default-config-dir

# Let's fix it

# Ensure that you have a `.config` directory in your home directory
> mkdir ~/.config

# Move Nushell's config files and history to the appropriate folder
> mv $nu.default-config-dir ~/.config

# Verify that the files have been moved correctly
> ls ~/.config/nushell

# Create a symlink from the new config location to the default location
> ln -s ~/.config/nushell $nu.default-config-dir

# Check that the symlink was created successfully
> ls $nu.default-config-dir

# Add the XDG_CONFIG_HOME variable to your .zshrc file
> (char nl) + 'export XDG_CONFIG_HOME="$HOME/.config"' + (char nl) | save --append ~/.zshrc

# Verify the current config path
> $nu.default-config-dir

# Log out, log back in, and verify the config path again
> $nu.default-config-dir

```
