# 006 - Navigating file paths in Nushell using internal functionality, FZF, or Broot

[Youtube](https://www.youtube.com/watch?v=Bsa8jUtjvPU)

## Default command-line method

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

## FZF

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

## Broot

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
