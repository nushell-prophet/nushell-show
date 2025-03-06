# nushell-show [youtube.com/@nushell-prophet](https://www.youtube.com/@nushell-prophet)

Random videos about Nushell and materials related to them.
All of the videos and materials are available for free reuse anywhere, including in other videos.
Let's popularize Nushell!

### Table of contents

- [001 - Keeping Nushell settings up to date with new releases (outdated after 0.100)](#001---keeping-nushell-settings-up-to-date-with-new-releases-outdated-after-0100)
- [002 - How to Install Nushell on macOS: A Step-by-Step Guide for Newbies](#002---how-to-install-nushell-on-macos-a-step-by-step-guide-for-newbies)
- [003 - Version Control for Nushell Configs: Setting Up a Git Repository](#003---version-control-for-nushell-configs-setting-up-a-git-repository)
- [004 - Setting $env.XDG\_CONFIG\_HOME](#004---setting-envxdg_config_home)
- [005 - nu-history-tools - benchmark your commands usage against of other users](#005---nu-history-tools---benchmark-your-commands-usage-against-of-other-users)
- [006 - Navigating file paths in Nushell using internal functionality, FZF, or Broot](#006---navigating-file-paths-in-nushell-using-internal-functionality-fzf-or-broot)

## 001 - Keeping Nushell settings up to date with new releases (outdated after 0.100)

[Youtube](https://youtu.be/OqJ4nFE46Eg).

We can use the VS Code diff function to conveniently find new and outdated lines of settings in Nushell.

To do so, we can use the following commands:
```
config nu --default | code --diff - $nu.config-path
config env --default | code --diff - $env.config-path
```

The next step after opening files should be `cmd + shift + P` and then `>Compare: swap left and Right Editor Side`

## 002 - How to Install Nushell on macOS: A Step-by-Step Guide for Newbies

[Youtube](https://youtu.be/tAJEIDUULdI)

## 003 - Version Control for Nushell Configs: Setting Up a Git Repository

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

## 004 - Setting $env.XDG_CONFIG_HOME

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

## 005 - nu-history-tools - benchmark your commands usage against of other users

[Youtube](https://youtu.be/dbRjBsaH_VY)

A Nushell module to analyze the command frequencies in Nushell history, generate cool graphs, benchmark statistics with other users, and generate a file with statistics to share with the community.

https://github.com/nushell-prophet/nu-history-tools

```nu no-run
# analyze your current commands history
> nu-history-tools analyze-history

# interactively select users to use for benchmarks in the analysis
> nu-history-tools analyze-history --pick_users

# parse submitted stats from a folder and aggregates them for benchmarking
> nu-history-tools aggregate-submissions

# parse .nu scripts
> glob **/*.nu --exclude ['**/themes/**/' '**/before_v0.60/**' '**/custom-completions/**'] | nu-history-tools analyze-nu-files

# list the history of Nushell commands with information about their crates and the Nushell versions (git tags) when they appeared.
> nu-history-tools list-all-commands
```

## 006 - Navigating file paths in Nushell using internal functionality, FZF, or Broot

[Youtube](https://www.youtube.com/watch?v=Bsa8jUtjvPU)

### Default command-line method

Nushell, by default, provides a powerful and convenient way to navigate through file paths that can be launched with the TAB key.

If a user needs to look for paths of files or folders in their current directory, they can simply type the quote character `"` and then hit `tab`.

Additionally, a user might find the following setting, which is inactive by default, useful:

```nu
$env.config.completions.algorithm = "Fuzzy"
```

Here is the keybinding that allows you to paste paths of recently visited directories.

```nu no-run
# make sure that you use sqlite nushell history
$env.config.history.file_format = "Sqlite"

$env.config.menus ++= [
    {
        # List all unique successful commands
        name: working_dirs_cd_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 23
        }
        style: {
            text: green
            selected_text: green_reverse
        }
        source: {|buffer, position|
            open $nu.history-path
            | query db "SELECT DISTINCT(cwd) FROM history ORDER BY id DESC"
            | get CWD
            | into string
            | where $it =~ $buffer
            | compact --empty
            | each {
                if ($in has ' ') { $'"($in)"' } else {}
                | {value: $in}
            }
        }
    }
]
$env.config.keybindings ++= [
    {
        name: "working_dirs_cd_menu"
        modifier: alt_shift
        keycode: char_r
        mode: emacs
        event: { send: menu name: working_dirs_cd_menu}
    }
]
```

### FZF

homepage: https://junegunn.github.io/fzf
github: https://github.com/junegunn/fzf

```nu
# I found the code below here: https://discord.com/channels/601130461678272522/615253963645911060/1209827461496569876
$env.config.keybindings ++= [
    {
        name: fzf_files
        modifier: control
        keycode: char_t
        mode: [emacs, vi_normal, vi_insert]
        event: [
          {
            send: executehostcommand
            cmd: "
              let fzf_ctrl_t_command = \"fd --type=file | fzf --preview 'bat --color=always --style=full --line-range=:500 {}'\";
              let result = nu -c $fzf_ctrl_t_command;
              commandline edit --append $result;
              commandline set-cursor --end
            "
          }
        ]
    }
]
```

### Broot

> Broot is a better way to navigate directories, find files, and launch commands.

homepage: https://dystroy.org/broot
github: https://github.com/Canop/broot

Save this configuration to enable Broot to output directory paths on `alt + enter`.
Later this config will be used in the keybindings.

```nu no-run
let $config_path = $env.XDG_CONFIG_HOME? | default '~/.config' | path join broot select.toml
mkdir ($config_path | path dirname) 

{
    verbs: [
        [invocation, key,       leave_broot, execution,     apply_to];
        [ok,         enter,     true,        ":print_path", file    ],
        [ok,         alt-enter, true,        ":print_path", any     ]
    ]
} | save -f $config_path
```

add the code below to your `config.nu`

```nu no-run
# I use the `broot-source` command to enable syntax highlighting in edit mode.
def broot-source [] {
    let $broot_closure = {
        let $cl = commandline
        let $pos = commandline get-cursor

        let $element = ast --flatten $cl
            | flatten
            | where start <= $pos and end >= $pos
            | get content.0 -i
            | default ''

        let $path_exp = $element
            | str trim -c '"'
            | str trim -c "'"
            | str trim -c '`'
            | if $in =~ '^~' { path expand } else {}
            | if ($in | path exists) {} else {'.'}

        let $config_path = $env.XDG_CONFIG_HOME? | default '~/.config' | path join broot select.toml

        let $broot_path = ^broot $path_exp --conf $config_path
            | if ' ' in $in { $"`($in)`" } else {}

        if $path_exp == '.' {
            commandline edit --insert $broot_path
        } else {
            $cl | str replace $element $broot_path | commandline edit -r $in
        }
    }

    view source $broot_closure | lines | skip | drop | to text
}
$env.config.keybindings ++= [
    {
         name: broot_path_completion
         modifier: control
         keycode: char_t
         mode: [emacs, vi_normal, vi_insert]
         event: [
            {
                send: ExecuteHostCommand
                cmd: (broot-source)
            }
        ]
    }
]
```

## 007 - topiary-nushell

### Installation

1. Install `rust` and `cargo` using the instructions found at <https://doc.rust-lang.org/cargo/getting-started/installation.html>.
2. Check the installation:
```nu no-run
# Restart Nushell
nu

# Make sure that .cargo/bin is in your $env.PATH
$env.PATH | find 'cargo'
```
3. Follow the installation instructions for `topiary-nushell` at <https://github.com/blindFS/topiary-nushell?tab=readme-ov-file#setup>.

### 4 spaces indentations

Just add `indent = "    "` to the `nu` field of your `languages.ncl`, like I did [here](https://github.com/maxim-uvarov/topiary-nushell/blob/c0be5971ef94e69d19ef1cc09c2fe77cfb3839dd/languages.ncl#L9).

### Format oneliners

As of now, topiary-nushell cares the most about indentations and adds new lines only if some of them are present in the original code. I wrote a simple custom command that uses the built-in `ast` command, finds pipe symbols and `let/mut` keywords, and inserts new lines before them, allowing topiary to take care of removing redundant new lines.

This command allows formatting one-liners that I write quite often. This is a copy of the command from my [nu-goodies](https://github.com/nushell-prophet/nu-goodies/blob/30335f830bc5203f401afcb3bb577c67a0469cc9/nu-goodies/commands.nu#L1633) module.

```nu no-run
# Insert new lines before the pipe symbol and let/mut
def 'insert-new-lines' [] {
    let $cmd = $in

    ast --flatten $cmd
    | filter {|it|
        $it.shape == shape_pipe or (
            $it.shape == 'shape_internalcall' and $it.content in [let mut]
        )
    }
    | insert new_lines {|i| if $i.shape == shape_pipe { "\n" } else { "\n\n" } }
    | update span { get start }
    | select span new_lines
    | reverse
    | reduce --fold (
        $cmd
        | split chars
    ) {|i| insert $i.span $i.new_lines }
    | str join
}

# Format piped in Nushell code or previous command from history using Topiary.
export def 'nu-format' [
    --no-new-lines (-n) # don't insert new lines
]: [nothing -> nothing string -> string] {
    let input = $in

    let cmd = if $input == null {
        history
        | last 2
        | first
        | get command
    } else { $input }

    $cmd
    | if $no_new_lines { } else {
        insert-new-lines
    }
    | topiary format --language nu
    | if $input == null {
        commandline edit -r $in
        return
    } else { }
}
```
