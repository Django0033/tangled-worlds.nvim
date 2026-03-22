# tangled-worlds.nvim

Random tables for solo roleplaying. A Neovim plugin that generates procedural content for worldbuilding, characters, quests, and more.

![Requires Neovim 0.10+](https://img.shields.io/badge/Neovim-0.10+-blueviolet)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

---

## Features

- **7 Categories** with 50+ subcategories
- **600+ combinations** of content
- **Procedural name generator** with fantasy-style syllables
- **Dynamic autocompletion** for easy exploration
- **Pure Lua** with zero external dependencies
- **Copy-paste ready** output

---

## Installation

### lazy.nvim

```lua
{
  "Eleazar Pequeno/tangled-worlds.nvim",
  lazy = true,
  cmd = "TangledWorlds",
}
```

### packer.nvim

```lua
use "Eleazar Pequeno/tangled-worlds.nvim"
```

---

## Usage

```
:TangledWorlds <category> [subcategory]
```

Press `<Tab>` for dynamic autocompletion of categories and subcategories.

### Categories Overview

| Category | Description |
|----------|-------------|
| **Creation** | Magical/artificial objects (Purpose, Trait, Magic, Corruption) |
| **Exploration** | Adventure environments (Terrain, Ornament, Event, Findings) |
| **World** | Worlds/nations (Name, Aspects, Inhabitants) |
| **People** | Characters/NPCs (Name, Disposition, Role, Descriptor, Quirk, Drive, Secret) |
| **Scene** | Narrative scenes (Challenge, Reaction, Senses, Activity, Detail, Development, Complication, Advantage) |
| **Quest** | Missions (Mission, Opposition, Hindrance, Aid, Escalation, Reward, Twist, ProgressTension) |
| **Location** | Locations (PastPresent, Descriptor, Trouble, Building, Influence, Mood, Rumor, SeeksOffers) |

---

## Examples

### Generate a Magical Object

```vim
:TangledWorlds Creation Purpose
" A crystal for Sealing dreams"

:TangledWorlds Creation Magic
" Transform-Poison"

:TangledWorlds Creation Trait
" Mirror-polished surface"
```

### Create a Character

```vim
:TangledWorlds People Name
" Elirquill"

:TangledWorlds People Role
" LoyalHealer"

:TangledWorlds People Quirk
" Peculiar accent"
```

### Build a World

```vim
:TangledWorlds World Name
" Sylvale"

:TangledWorlds World Aspects
" DepthControlled"

:TangledWorlds World Inhabitants
" ForsakenElementals"
```

### Generate a Quest

```vim
:TangledWorlds Quest Mission
" SpyonCreature Xyrbane"

:TangledWorlds Quest Twist
" Hidden society"

:TangledWorlds Quest Reward
" Blessing"
```

### Describe a Location

```vim
:TangledWorlds Location Mood
" Unsettling silence"

:TangledWorlds Location Building
" ResearchFuturistic"
```

### Craft a Scene

```vim
:TangledWorlds Scene Senses
" Spiced incense + Water drip"

:TangledWorlds Scene Challenge
" HardBattle"
```

---

## Content Summary

| Category | Subcategories | Content Types |
|----------|---------------|---------------|
| Creation | 4 | 38 purposes, 38 traits, 78 magics, 38 corruptions |
| Exploration | 4 | 76 terrains, 76 ornaments, 76 events, 76 findings |
| World | 3 | 76 names, 76 aspects, 76 inhabitants |
| People | 7 | 116 names, 78 dispositions, 78 roles, 38 descriptors, 38 quirks, 76 drives, 38 secrets |
| Scene | 8 | 47 challenges, 76 reactions, 76 senses, 38 activities, 38 details, 38 developments, 6 complications, 6 advantages |
| Quest | 8 | 78 missions, 76 oppositions, 38 hindrances, 38 aids, 38 escalations, 38 rewards, 38 twists, 76 tensions |
| Location | 8 | 76 past/present, 76 descriptors, 38 troubles, 76 buildings, 38 influences, 38 moods, 38 rumors, 76 seeks/offers |

---

## Requirements

- Neovim 0.10+

## License

MIT
