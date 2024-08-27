# Start Nushell without using history so it won't interact with the data folder
nu --no-history

# See that the current path contains space and might cause inconvenience and even problems
$nu.default-config-dir

# These commands are only for demo. Don't use them
use ~/git/nu-cmd-stack/cmd-stack;
open ~/git/nushell-show/shows/004.nu | split row "\n\n" | cmd-stack init

# Ensure that you have a `.config` directory in your home directory
mkdir ~/.config

# Move Nushell's config files and history to the appropriate folder
mv $nu.default-config-dir ~/.config

# Verify that the files have been moved correctly
ls ~/.config/nushell

# Create a symlink from the new config location to the default location
ln -s ~/.config/nushell $nu.default-config-dir

# Check that the symlink was created successfully
ls $nu.default-config-dir

# Add the XDG_CONFIG_HOME variable to your .zshrc file
(char nl) + 'export XDG_CONFIG_HOME="$HOME/.config"' + (char nl) | save -a ~/.zshrc

# Verify the current config path
echo $nu.default-config-dir

# Log out, log back in, and verify the config path again
echo $nu.default-config-dir
