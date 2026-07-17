# 005 - nu-history-tools - benchmark your commands usage against of other users

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
