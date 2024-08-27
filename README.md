# nushell-show
Random videos about Nushell and materials related to them.

## Keeping Nushell settings up to date with new releases

`#nubietip 001`

We can use the VS Code diff function to conveniently find new and outdated lines of settings in Nushell.

To do so, we can use the following commands:
```
config nu --default | code --diff - $nu.config-path
config env --default | code --diff - $env.config-path
```

The next step after opening files should be `cmd + shift + P` and then `>Compare: swap left and Right Editor Side`

This [video](https://youtu.be/OqJ4nFE46Eg) is about that.

## 003 - Version Control for Nushell Configs: Setting Up a Git Repository

[Youtube](https://youtu.be/vZh5XZsEjtE?si=OJYfDOVNb6kTqgJ8)

```nu
# Change directory to the path stored in the environment variable 'nu.data-dir'
cd $nu.data-dir

# Initialize a new Git repository in the current directory
git init

# Stage the files 'config.nu', 'env.nu', and 'history.txt' for commit
git add config.nu env.nu history.txt

# Commit the staged files with the message 'initial commit'
git commit -m 'initial commit'

# open config.nu file in the default editor
config nu

# Show the status of the repository (which files are staged, modified, or untracked)
git status

# Stage the file 'config.nu' for commit (potentially after making changes to it)
git add config.nu

# Commit the staged file with the message 'update'
git commit -m 'update'

```