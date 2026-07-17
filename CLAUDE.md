# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository (`nushell-show`) contains materials for random advanced videos on the nushell-prophet YouTube channel ([@nushell-prophet](https://www.youtube.com/@nushell-prophet)). It differs from the companion repository `nushell-prophet-manuals` which focuses on in-depth sequential manuals.

## Repository Structure

```
README.md              # Table of contents only — links to each show's README
shows/
├── 00-intro/          # Introduction video
├── 001-*/             # Each numbered directory contains materials for one video
├── ...
└── 007-*/
```

Each show directory contains:
- `README.md` - the chapter text for that video (moved out of the root README)
- `.nu` files - Nushell demo scripts showcasing specific features or tools
- Supporting materials related to the video content

The root README holds only the table of contents; new chapters go into their own `shows/NNN-slug/README.md` and get a link there. Shows whose content no longer works with current Nushell are marked `outdated!` in the table of contents.

## Current subjects

Videos cover advanced Nushell topics including:
- Configuration management and version control
- External tool integrations (FZF, Broot, Topiary)
- Custom commands and keybindings
- History analysis tools
- Path navigation techniques
- Code formatting with topiary-nushell

## Working with Nushell Code

When creating or modifying `.nu` files:
- Use 4-space indentation
- Follow Nushell syntax conventions (pipe-based data flow)
- Include usage examples as comments when demonstrating custom commands

## Related Repository

The companion repository `/Users/user/git/nushell-prophet-manuals` contains in-depth manuals for the same YouTube channel. Content decisions should consider which repository is more appropriate:
- `nushell-show` (this repo): Quick demonstrations, advanced features, tool integrations
- `nushell-prophet-manuals`: Comprehensive tutorials, step-by-step guides, foundational topics
