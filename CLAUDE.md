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
- `.nu` files (some shows only) - Nushell demo scripts showcasing specific features or tools. Not every show has them — several are README-only.
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
- The cozy terminal environment for AI agents running under `sbx` sandboxes (007; includes the `## Installation` section that points to the install manual)

## Working with Nushell Code

When creating or modifying `.nu` files:
- Use 4-space indentation
- Follow Nushell syntax conventions (pipe-based data flow)
- Include usage examples as comments when demonstrating custom commands

## Related repositories

Sibling repos in the same workspace (checked out side by side):
- `../nushell-prophet-manuals` — in-depth sequential manuals for the same channel. When placing content, decide which repo fits: this repo is quick demonstrations, advanced features, and tool integrations; manuals are comprehensive step-by-step guides and foundational topics.
- `../nushell-show-scratchpad` — the production scratchpad for these episodes: transcripts, drafts, cover renders, and per-episode `status.nuon`. Working files that aren't released live there, not here.
- `../nushell-show-module` — `npshow`, which renders the terminal cover screens for these episodes.
