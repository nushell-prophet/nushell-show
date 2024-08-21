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
