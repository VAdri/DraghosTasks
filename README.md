**Draghos Guide** is an addon for World of Warcraft that display instructions in game to the player to help him find the best possible route for leveling.

The guide currently support these kinds of steps:

- [x] Pick up a quest
- [x] Progress on some or all of the objectives of a quest
- [x] Complete some or all of the objectives of a quest
- [x] Complete a quest
- [x] Hand in a quest
- [ ] Abandon a quest
- [ ] Display a note
- [x] Grind until reaching a specific level (and potentially an amount of XP)
- [x] Use Hearthstone
- [x] Set hearth
- [ ] Go to a zone
- [x] Discover a flight path
- [ ] Fly somewhere
- [ ] Teleport
- [ ] Discover an area
- [ ] Train (for a specific spell or not, might be for professions too)
- [ ] Vendor/Repair
- [ ] Skip the continuation of a quest (temporarily or permanently)
- [ ] Buy an item
- [ ] Loot an item (from an object or an NPC)
- [ ] Craft something
- [ ] Make a bank deposit
- [ ] Make a bank withdrawal
- [ ] Keep an item
- [ ] Destoy an item
- [ ] Equip an item
- [ ] Use an item
- [ ] Use a spell
- [ ] Find a group
- [ ] Start a dungeon
- [ ] Complete a dungeon
- [ ] Die
- [ ] Spirit rez
- [ ] ...

Other features:

- [ ] Display steps:
  - [x] Steps displayed on the objective tracker
  - [ ] Associate elements to a step
    - [x] NPC
    - [x] Item
    - [x] Spell
    - [x] Location
    - [ ] Notes
    - [ ] Requirements
- [ ] Determine automatically if the step is available:
  - [x] Using one of the step logic (see above)
  - [x] When another step has been successfully completed
  - [ ] When the requirements are not met (level/race/class/reputation/money...)
  - [ ] Conditional steps (for instance: if the step `Use Hearthstone` is not available, display a `Go` step and/or a `Note`).
- [ ] Skip to the next step automatically when it is completed:
  - [x] Using one of the step logic (see above)
  - [x] When another step has been successfully
  - [ ] If the step is too low level/not worth it
- [ ] Skip a step manually
  - [ ] Warn the player that several steps will be missed
- [x] Display an arrow and a pin on the minimap for the current step coord (requires TomTom)
- [ ] Buttons attached to a step:
  - [x] Use quest item
  - [ ] Use item
  - [ ] Use spell
  - [x] Target NPC and show a mark above him
    - [ ] Glow when the NPC is in range
    - [ ] Display the model of the NPC in a side frame
