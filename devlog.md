# tangled-worlds.nvim - Development Log

Random tables for solo roleplaying. A Neovim plugin that generates procedural content for worldbuilding, character creation, quests, and more.

---

## Statistics

| Metric | Value |
|--------|-------|
| Total commits | 28 |
| Main categories | 7 |
| Subcategories | 50+ |
| Possible combinations | 600+ |
| Lua files | 2 |
| Dependencies | 0 |

---

## Architecture & Design Decisions

### Why Modular Tables?

The plugin uses a hierarchical table system where each category contains multiple sub-tables. This design:

- **Scalability**: Adding new content requires only new table entries, no code changes
- **Composability**: Elements can combine (2-3 levels) using the `-` separator
- **Discoverability**: Autocompletition guides users through available options

### The `print_random_elements` Function

A single generic function handles all generation:

```lua
print_random_elements(opts)
  └── Supports 1-3 levels of depth
  └── Combines elements with "-" separator
  └── Example: Purpose + Magic = "A crystal for Sealing dreams"
```

### Random Seed

```lua
math.randomseed(os.time() + vim.fn.getpid())
```

Uses time + process ID to ensure different sequences between sessions while maintaining reproducibility within a session.

### No External Dependencies

Pure Lua using only Neovim APIs (`vim.api.nvim_create_user_command`, `vim.fn`). Users can copy-paste content directly from output.

---

## October 2025

### Week 1: Foundation

| Date | Commit | Description |
|------|--------|-------------|
| 2025-10-15 | Initial commit | Project initialization |
| 2025-10-16 | Add main command and tables | Core structure: `TangledWorlds` command, World category with Name, Aspects, Inhabitants |

```lua
:TangledWorlds World Name
-- Example output: "Sylvale"

:TangledWorlds World Aspects
-- Example output: "DepthControlled"
```

### Week 2: Exploration & Creation

| Date | Commit | Description |
|------|--------|-------------|
| 2025-10-23 | Add world-aspects and world-inhabitants | Expanded World category |
| 2025-10-25 | Add ExplorationTerrain, ExplorationOrnament, ExplorationEvent, ExplorationFindings | New Exploration category |
| 2025-10-25 | Add CreationPurpose | Started Creation category |

**Exploration Category**

```lua
:TangledWorlds Exploration Terrain
-- Example output: "Jagged Valley"

:TangledWorlds Exploration Event
-- Example output: "Terrifying Spirit"
```

### Week 3: Creation Complete & Scene Begin

| Date | Commit | Description |
|------|--------|-------------|
| 2025-10-26 | Add CreationMagic, CreationTrait | Creation expansion |
| 2025-10-26 | Add CreationCorruption | Creation category completed |
| 2025-10-26 | Add Scene Challenge, Reaction | Started Scene category |
| 2025-10-26 | Refactor | Code restructuring |
| 2025-10-26 | Add Scene Senses, Activity | Scene expansion |
| 2025-10-29 | Add Scene Detail | Scene expansion |
| 2025-11-02 | Add Scene Development | Scene expansion |
| 2025-11-02 | Add Scene Advantage, Complication | Scene category completed |

**Creation Category**

```lua
:TangledWorlds Creation Purpose
-- Example output: "A crystal for Sealing dreams"

:TangledWorlds Creation Magic
-- Example output: "Transform-Poison"

:TangledWorlds Creation Trait
-- Example output: "Mirror-polished surface"
```

**Scene Category**

```lua
:TangledWorlds Scene Challenge
-- Example output: "HardBattle"

:TangledWorlds Scene Senses
-- Example output: "Spiced incense + Water drip"
```

### Week 4: Quest Begins

| Date | Commit | Description |
|------|--------|-------------|
| 2025-11-03 | Add Quest Mission | Started Quest category |
| 2025-11-03 | Add Quest Opposition | Quest expansion |

---

## November 2025

### Quest Expansion

| Date | Commit | Description |
|------|--------|-------------|
| 2025-11-08 | Add Quest Hindrance, Aid | Quest expansion |
| 2025-11-08 | Add Quest Escalation, Reward | Quest expansion |
| 2025-11-08 | Add Quest Twist | Quest expansion |
| 2025-11-08 | Refactor | Code restructuring |
| 2025-11-10 | Add Quest ProgressTension | Quest category completed |

**Quest Category**

```lua
:TangledWorlds Quest Mission
-- Example output: "SpyonCreature Xyrbane"

:TangledWorlds Quest Reward
-- Example output: "Blessing"

:TangledWorlds Quest Twist
-- Example output: "Hidden society"
```

### Location Category

| Date | Commit | Description |
|------|--------|-------------|
| 2025-11-10 | Add Location PastPresent, Descriptor, Trouble, Building | Started Location category |
| 2025-11-12 | Add Location Building, Trouble, Descriptor | Location expansion |
| 2025-11-27 | Add Location Influence | Location expansion |

**Location Category**

```lua
:TangledWorlds Location Mood
-- Example output: "Unsettling silence"

:TangledWorlds Location Building
-- Example output: "ResearchFuturistic"
```

---

## Content Summary by Category

### Creation (4 subcategories)
For creating magical/artificial objects.

- **Purpose**: 38 magical purposes (Sealing, Reflection, Amplification...)
- **Trait**: 38 physical traits (Sleek profile, Mirror-polished...)
- **Magic**: 78 combinations (Transform+Poison, Freeze+Dream...)
- **Corruption**: 38 corruption effects (Disintegration, Invisibility...)

### Exploration (4 subcategories)
For exploration adventures.

- **Terrain**: 76 combinations (Jagged Valley, Forsaken Prairie...)
- **Ornament**: 76 combinations (Weathered Rodents, Haunted Mist...)
- **Event**: 76 combinations (Terrifying Spirit, Roaming Elemental...)
- **Findings**: 76 combinations (Benevolent Potion, Natural Tracks...)

### World (3 subcategories)
For creating worlds/nations.

- **Name**: 76 combinations (Elirquill, Sylvale, Xyrbane...)
- **Aspects**: 76 combinations (DepthControlled, SeaOutdated...)
- **Inhabitants**: 76 combinations (ForsakenElementals, CorruptedScientists...)

### People (7 subcategories)
For generating characters/NPCs.

- **Name**: 116 combinations (fantasy name generator)
- **Disposition**: 78 combinations
- **Role**: 78 combinations
- **Descriptor**: 38 physical/psychological traits
- **Quirk**: 38 quirks (Exaggerated bow, Peculiar accent...)
- **Drive**: 76 combinations (motivation)
- **Secret**: 38 secrets (Blackmail victim, Stolen identity...)

### Scene (8 subcategories)
For describing narrative scenes.

- **Challenge**: 47 combinations (HardBattle, EasyInfiltration...)
- **Reaction**: 76 combinations
- **Senses**: 76 combinations
- **Activity**: 38 activities
- **Detail**: 38 narrative details
- **Development**: 38 narrative developments
- **Complication**: 6 complications
- **Advantage**: 6 advantages

### Quest (8 subcategories)
For generating missions.

- **Mission**: 78 combinations (DeliverSystem, SpyonCreature...)
- **Opposition**: 76 combinations
- **Hindrance**: 38 obstacles
- **Aid**: 38 helps
- **Escalation**: 38 escalations
- **Reward**: 38 rewards
- **Twist**: 38 plot twists
- **ProgressTension**: 76 combinations

### Location (8 subcategories)
For describing locations.

- **PastPresent**: 76 combinations
- **Descriptor**: 76 combinations
- **Trouble**: 38 problems
- **Building**: 76 combinations
- **Influence**: 38 influences
- **Mood**: 38 atmospheres
- **Rumor**: 38 rumors
- **SeeksOffers**: 76 combinations

---

## March 2026

### Clean Code Refactor

| Date | Change | Description |
|------|--------|-------------|
| 2026-03-22 | init.lua refactor | Eliminated `get_random_number`, replaced if/elseif with generic loop |
| 2026-03-22 | Error handling | Added validation for invalid categories/subcategories |
| 2026-03-22 | Variable names | Renamed to `category`/`subcategory` for clarity |
| 2026-03-22 | Typo fix | `dinamic_completer` → `dynamic_completer` |
| 2026-03-22 | Filename fix | `quest-oposition.lua` → `quest-opposition.lua` |
| 2026-03-22 | Filename fix | `location-seeks-&-offers.lua` → `location-seeks-and-offers.lua` |
| 2026-03-22 | Style | Standardized all `require()` to use single quotes |

**Code Changes:**

```lua
-- Before: get_random_number wrapper
local function get_random_number(top_number)
    local random_number = math.random(1, top_number)
    return random_number
end

-- After: Direct math.random
local function get_random_element(tbl)
    return tbl[math.random(#tbl)]
end

-- Before: Duplicated if/elseif
if #secondary_tbl == 2 then
    print(get_random_element(tertiary_tbl1) .. "-" .. ...)
elseif #secondary_tbl == 3 then
    print(get_random_element(tertiary_tbl1) .. "-" .. ...)
end

-- After: Generic loop
local parts = {}
for i = 1, #subcategory do
    parts[i] = get_random_element(subcategory[i])
end
print(table.concat(parts, '-'))

-- Before: Silent failure
local secondary_tbl = primary_tbl[opts.fargs[2]]

-- After: Error notification
if not category or not subcategory then
    vim.notify('Invalid category or subcategory', vim.log.levels.ERROR)
    return
end
```

---

## March 2026 (Continued)

### Floating Window Display

| Date | Change | Description |
|------|--------|-------------|
| 2026-03-22 | init.lua | Results now display in a floating window instead of print() |
| 2026-03-22 | Border | Using `border = 'single'` for clean appearance |
| 2026-03-22 | Title | Shows `Category -> Subcategory` in window header |
| 2026-03-22 | Hint | Added "Press q to close" hint |

**Visual Design:**

```
┌─────────────────────────────────────┐
│ Creation -> Purpose                 │
│ A crystal for Sealing dreams        │
│                                     │
│ Press q to close                     │
└─────────────────────────────────────┘
```

**Code Changes:**

```lua
-- Before: print to stdout
print(table.concat(parts, '-'))

-- After: floating window
local function show_floating_window(category, subcategory, content)
    local hint = 'Press q to close'
    local lines = {
        category .. ' -> ' .. subcategory,
        content,
        '',
        hint,
    }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bd!<cr>', { noremap = true })

    local width = math.max(
        #category + #subcategory + 5,
        #content,
        #hint
    ) + 4

    local opts = {
        relative = 'editor',
        width = width,
        height = 4,
        row = math.floor((vim.o.lines - 4) / 2) - 1,
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'single',
        noautocmd = true,
    }

    local win_id = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_set_current_win(win_id)
end
```

---

## Future Possibilities

- [ ] Custom user tables via configuration
- [ ] Save/generate to buffer
- [ ] Batch generation (multiple results)
- [ ] Export combinations to file
- [ ] Integration with telescope.nvim
