# my nushell history starts on
history | first | get start_timestamp | into datetime

# the number of entries in my nushell history
history | length

# days I typed something into nushell
let days_with_use = history | get start_timestamp | each {try {into datetime}} | format date '%F' | uniq | length; $days_with_use

# days since the first date
let days_total = history | first | get start_timestamp | into datetime | (date now) - $in | into record | $in.week * 7 + $in.day; $days_total

# percentage
$days_with_use / $days_total * 100 | into int | $'($in)%'

# helper command by @NotTheDr01ds (Thanks!)
def "append results" [
  colname: string
  calc: closure
]: table -> table {
  let table = $in
  let result = ($table | do $calc)
  $table | enumerate | flatten
  | append ($result | insert index '' | insert module '=======   total')
}

# quick stats based on code of my nushell modules
cd ~/git/; kv get my-nu-modules | wrap module | insert code {|i| glob $'($i.module)/**/*.nu' | each {open} | to text} | each {|i| $i | merge ($i.code | str stats)} | reject code | select module lines words chars | append results "" {math sum} | update 8 {items {|k v| {$k : $"(ansi yellow)($v)(ansi reset)"}} | into record} | print; cd -
