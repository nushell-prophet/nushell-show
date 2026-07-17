# 007 - topiary-nushell

- [Topiary](https://github.com/tweag/topiary): tree-sitter based uniform formatter
- [Topiary-nushell](https://github.com/blindFS/topiary-nushell): configuration files that enable nushell code formatting

## Installation

This got much simpler. topiary now ships a prebuilt binary, so you no longer need `rust` and `cargo` to build it from source.

1. Install the `topiary` binary with any package manager:
```nu no-run
brew install topiary
```
2. Drop the two `topiary-nushell` config files into topiary's config dir. topiary reads `$env.XDG_CONFIG_HOME/topiary` — `languages.ncl` in the root, `queries/nu.scm` under `queries`:
```nu no-run
mkdir ($env.XDG_CONFIG_HOME | path join topiary queries)
http get https://raw.githubusercontent.com/blindFS/topiary-nushell/main/languages.ncl
    | save ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
http get https://raw.githubusercontent.com/blindFS/topiary-nushell/main/queries/nu.scm
    | save ($env.XDG_CONFIG_HOME | path join topiary queries nu.scm)
```

That's it — topiary fetches and compiles the tree-sitter-nu grammar on first run.

## 4 spaces indentations

topiary formats with 2-space indents by default. I use 4 spaces. Add `indent = "    "` to the `nu` field of your `languages.ncl`, like I did [here](https://github.com/maxim-uvarov/topiary-nushell/blob/c0be5971ef94e69d19ef1cc09c2fe77cfb3839dd/languages.ncl#L9).

## Demo for the nushell-show

```nu no-run
topiary format topiary-demo.nu
```

## Format oneliners

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
