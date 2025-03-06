use std repeat
# normalize values in given columns
#
# > [[a b]; [1 2] [3 4] [a null]] | normalize a b
# ╭─a─┬─b─┬a_norm┬b_norm╮
# │ 1 │ 2 │ 0.33 │ 0.50 │
# │ 3 │ 4 │    1 │    1 │
# │ a │   │ a    │      │
# ╰───┴───┴──────┴──────╯
export def 'normalize' [
...column_names
--suffix = '_norm'
] {
mut $table = ($in)
let $allowed_types = ['int' 'float' 'filesize']
for column in $column_names {
let max_value = $table
| get $column
| where ($it | describe | $in in $allowed_types)
| math max
$table = $table
| upsert $'($column)($suffix)' {|i|
$i
| get $column
| if ($in | describe | $in in $allowed_types) {
$in / $max_value
} else { }
}
}
$table
}
# construct bars based of a given percentage from a given width (5 is default)
# https://github.com/nushell/nu_scripts/blob/bar/sourced/progress_bar/bar.nu
#
# > bar 0.2
# █
#
# > bar 0.71
# ███▌
export def 'bar' [
percentage: float
--background (-b): string = 'default'
--foreground (-f): string = 'default'
--progress (-p) # output the result using 'print -n'
--width (-w): int = 5
] {
let blocks = [null "▏" "▎" "▍" "▌" "▋" "▊" "▉" "█"]
let full_bar = ($blocks | last)
let whole_part = $full_bar | repeat ($percentage * $width // 1 | into int) | str join
let fraction = (
$blocks
| get (
($percentage * $width) mod 1
| $in * ($blocks | length | $in - 1)
| math round
)
)
let result = (
$"($whole_part)($fraction)"
| fill --character $' ' -w $width
| if ($foreground == 'default') and ($background == 'default') { } else {
$"(ansi -e {fg: ($foreground) bg: ($background)})($in)(ansi reset)"
}
)
if $progress {
print -n $"($result)\r"
} else {
$result
}
}
