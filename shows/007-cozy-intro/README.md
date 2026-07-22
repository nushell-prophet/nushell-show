# Cozy - A convenient terminal environment for `sbx` AI sandboxes

<img src="https://github.com/user-attachments/assets/96b23749-53c4-48dd-a80c-6e0d5567257a" align="right" width="30%" alt="cozy logo">

This is the environment I use for spinning up `sbx` sandboxes to collaborate with agents.

I'm not a typical engineer: my only programming language is Nushell, though I'm a usability freak and just outrageously happy that I ended up in the terminal.

I learn things by trial and error, without external gurus and without much help from books or videos. This has its advantages and disadvantages, but I believe I have something interesting to share with the audience.

Traditionally, the terminal has been an environment for technical professionals. But I believe a broader audience could benefit from the current stack of terminal apps. In my videos I hope to show some examples of why non-terminal users might start their own learning journey.

You can find all the relevant modules and configs in the [vendor/](https://github.com/nushell-prophet/cozy/tree/master/vendor) folder of the cozy repo, so you don't have to install and use `sbx`.

There are quite a lot of things to talk about, so let me start with a few that come to mind. I'll be demonstrating them in my real-life environment with the relevant tasks and files. I hope this will make the examples better grounded.

## Copying commands and their output

[Youtube](https://youtu.be/AcDM7-U2e2A)

`sbx` is a CLI by Docker, designed to create and run Linux virtual machines as sandboxes, so users can work with agents in an isolated environment. It is available for macOS and Windows.

```sh
git clone https://github.com/nushell-prophet/cozy
cd cozy
sbx run shell --kit sbx-kit/ .
```

In this video I show cozy in action and return to the installation steps later. The topic here is copying commands and their output.

### `example`

[`example`](https://github.com/nushell-prophet/nu-goodies/blob/6fa9f2b9a283195880d3e430d465a684ac24608d/nu-goodies/commands.nu#L126) (from [nu-goodies](https://github.com/nushell-prophet/nu-goodies)) is appended to a pipeline. It copies the whole example to the clipboard: the command itself, wrapped in `nu -c '...'`, followed by its output commented with `# =>` — ready to paste into any application.

```nu
ls nu-goodies | first 3 | reject modified | example
```

It has flags too: `--no-copy`, `--no-comment`, `--bare` (raw command without the `nu -c` wrap), `--cwd` (prepend the current directory as a comment line).

### `copy-out`

[`copy-out`](https://github.com/nushell-prophet/nu-goodies/blob/6fa9f2b9a283195880d3e430d465a684ac24608d/nu-goodies/capture.nu#L295) (also from nu-goodies) copies commands together with their output from the Zellij pane scrollback to the clipboard. Its completions list the recent commands of the current session, so you can pick which ones to copy:

```nu
copy-out       # the last command with its output
copy-out 3     # from the 3rd-to-last command through the last
copy-out 3 1   # the 3rd-to-last and the last, separately
copy-out --cwd # prepend the current directory as a `# path` comment line
```

The copied text is ready to paste into any application — output lines are commented with `# =>`, in the style of [dotnu](https://github.com/nushell-prophet/dotnu) examples.

### `view source` and `metadata`

`view source copy-out` prints the source code of the command. Piping it into `metadata` reveals the file where the command is defined:

```nu
view source copy-out | metadata | get source
# => /home/agent/repos/nu-goodies/nu-goodies/capture.nu
```

That path can go straight into `hx` to open the definition in Helix.

### `pbcopy` inside a Linux sandbox

The source of `copy-out` shows it copies via `pbcopy`. `pbcopy` is a macOS application, and the sandbox is a Linux virtual machine — so cozy ships a small [`pbcopy` script](https://github.com/nushell-prophet/cozy/blob/cf2ca3f259ffa157ee70a4ea60e54caa6c23c060/docker-files/pbcopy) that outputs its input wrapped in an OSC 52 escape sequence, which the terminal turns into a clipboard write. The same clipboard path is used by Zellij, Helix, and lazygit inside cozy.

### Ctrl+Alt+C — copy the command line

A [Nushell keybinding](https://github.com/nushell-prophet/my-dotfiles/blob/00102e715c457137d76ee33b35533c71d441b96a/nushell/config.nu#L467) copies whatever is currently typed in the command line and appends a ` # copied` confirmation:

```nu
$env.config.keybindings ++= [
    {
        name: copy_command
        modifier: control_alt
        keycode: char_c
        mode: [emacs]
        event: {
            send: executehostcommand
            cmd: "commandline | pbcopy; commandline edit --append ' # copied'"
        }
    }
]
```

### Capture the pane into Helix

Two [Zellij keybindings](https://github.com/nushell-prophet/my-dotfiles/blob/00102e715c457137d76ee33b35533c71d441b96a/zellij/config.kdl#L50) open the pane content in Helix in a floating window, where it can be edited or partially copied:

- `Super Shift E` (`Cmd Shift E` on Mac) — captures the visible portion of the screen
- `Super Alt E` — captures the full scrollback

You will see me using these tools in the next videos.

## Installation

This video installs cozy from scratch: the three-command quick start, what the installer actually does step by step, and `cozy verify` to check it landed. The full write-up is a step-by-step manual: [Installing Cozy into an `sbx` Sandbox](https://github.com/nushell-prophet/nushell-prophet-manuals/blob/main/manuals/06-install-cozy/README.md).

