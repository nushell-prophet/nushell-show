# 003 - Version Control for Nushell Configs: Setting Up a Git Repository

[Youtube](https://youtu.be/vZh5XZsEjtE?si=OJYfDOVNb6kTqgJ8)

```nu no-run
# Change directory to the path stored in the environment variable '$nu.default-config-dir'
> cd $nu.default-config-dir

# Initialize a new Git repository in the current directory
> git init

# Stage the files 'config.nu', 'env.nu', and 'history.txt' for commit
> git add config.nu env.nu history.txt

# Commit the staged files with the message 'initial commit'
> git commit -m 'initial commit'

# open config.nu file in the default editor
> config nu

# Show the status of the repository (which files are staged, modified, or untracked)
> git status

# Stage the file 'config.nu' for commit (potentially after making changes to it)
> git add config.nu

# Commit the staged file with the message 'update'
> git commit -m 'update'

```
