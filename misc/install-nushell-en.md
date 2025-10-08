# Installing Nushell from Scratch on MacOS Tahoe

## Installing VS Code

For the tasks in this manual, we'll need a text editor. The manual's author uses `helix editor`, but for beginners (the target audience of this manual), VS Code will be simpler and more reliable at first. We'll install it now. Download the installer from:

https://code.visualstudio.com

## Installing Homebrew

Open https://brew.sh, copy the installation command.
Open Terminal, paste the command, press Enter.

After execution, copy the commands provided by Homebrew (adding to PATH), paste into terminal, execute.

```bash
# Verify installation correctness
brew doctor
```

## Installing Nushell

```bash
# View package information
brew info nushell

# Install nushell
brew install nushell

# Launch nushell
nu
```

## Preparing to Use XDG_CONFIG_HOME

Check the current configuration path:

```nushell
# Shows the path to the configuration directory
$nu.default-config-dir
```

If the path contains spaces, fix it:

```nushell
# Launch nu without saving history
nu --no-history

# Create .config directory
mkdir ~/.config

# Move configuration to new location
mv $nu.default-config-dir ~/.config/

# Verify that the folder appeared
ls ~/.config/nushell

# Create symbolic link
ln -s ~/.config/nushell ($nu.default-config-dir | path split | drop | path join)

# Verify that the symbolic link works
ls $nu.default-config-dir
```

Close the terminal tab, open a new tab with zsh.

## Configuring XDG_CONFIG_HOME

Add the environment variable to zsh configuration (will be set at each terminal launch):

```bash
# Open zsh configuration in VS Code
code ~/.zshrc
```

If the `code` command is not found: open VS Code, press `Cmd+Shift+P`, type `install path`, select the install command, press Enter. Then repeat `code ~/.zshrc` in the terminal.

In the opened file, add the line:

`export XDG_CONFIG_HOME="$HOME/.config"`

```bash
# Apply changes
source ~/.zshrc

# Verify that the variable is set
echo $XDG_CONFIG_HOME
```

```nushell
# Launch nushell again
nu

# Verify that the new path contains no spaces
$nu.default-config-dir
```

## Initializing Git Repository

```bash
# Navigate to configuration directory
cd ~/.config/

# Initialize git
git init

# Add files
git add nushell/config.nu nushell/env.nu

# Create first commit
git commit -m "Initial nushell configuration"

# Set username and email
git config --global user.name "Maxim Uvarov"
git config --global user.email "nushell-prophet-demo@users.noreply.github.com"

# Edit the author of the last commit
git commit --amend --reset-author
```

## Basic Settings

```nushell
# Open environment variables file
config env
```

If the `$env.EDITOR` variable is not set, add to the file:

`$env.EDITOR = "code"`

Save and restart nushell:

```nushell
nu

# Open main configuration file
config nu
```

Add history and banner settings:

```nushell
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 5_000_000
$env.config.show_banner = false
```

Save, restart nushell and commit changes:

```nushell
nu
cd ~/.config/

# See what changed
git status

# Add our changes
git add nushell/config.nu nushell/env.nu
git commit -m "first settings"

# Check again
git status
```

We see that history files remain. Create `.gitignore`:

```bash
# Open .gitignore in editor
code .gitignore
```

Add the line: `nushell/history*`

Save and commit:

```nushell
# Verify that history files are no longer shown
git status

# Add .gitignore
git add .gitignore
git commit -m "Add history files to gitignore"
```

