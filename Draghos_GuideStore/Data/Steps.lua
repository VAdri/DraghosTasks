STEP_TYPE_PICKUP_QUEST = 1;
STEP_TYPE_PROGRESS_QUEST_OBJECTIVE = 2;
STEP_TYPE_COMPLETE_QUEST_OBJECTIVE = 3;
STEP_TYPE_COMPLETE_QUEST = 4;
STEP_TYPE_HANDIN_QUEST = 5;
STEP_TYPE_GRIND = 6;
STEP_TYPE_USE_HEARTHSTONE = 7;

Draghos_GuideStore.steps = {
    [1] = { -- Pick up The First Step
        id = 1,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14449],
        npc = Draghos_GuideStore.npcs[2981],
        location = Draghos_GuideStore.locations.npcs[1],
    },
    [2] = { -- Hand in The First Step
        id = 2,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14449],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [3] = { -- Pick up Rite of Strength
        id = 3,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14452],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [4] = { -- Complete quest Rite of Strength
        id = 4,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[14452],
    },
    [5] = { -- Hand in Rite of Strength
        id = 5,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14452],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [6] = { -- Pick up Our Tribe, Imprisoned
        id = 6,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[24852],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [7] = { -- Complete quest Our Tribe, Imprisoned
        id = 7,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[24852],
    },
    [8] = { -- Hand in Our Tribe, Imprisoned
        id = 8,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[24852],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [9] = { -- Pick up Go to Adana
        id = 9,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14458],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [10] = { -- Hand in Go to Adana
        id = 10,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14458],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [11] = {
        id = 11, -- Pick up Rite of Courage
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14456],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [12] = {
        id = 12, -- Pick up Stop the Thorncallers
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14455],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [13] = { -- Complete quest Rite of Courage
        id = 13,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[14456],
    },
    [14] = { -- Complete quest Stop the Thorncallers
        id = 14,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[14455],
    },
    [15] = { -- Hand in Rite of Courage
        id = 15,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14456],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [16] = { -- Hand in Stop the Thorncallers
        id = 16,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14455],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [17] = { -- Pick up The Battleboars
        id = 17,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14459],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [18] = { -- Pick up Feed of Evil
        id = 18,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14461],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [19] = { -- Complete Feed of Evil
        id = 19,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[14461],
    },
    [20] = { -- Progress The Battleboars
        id = 20,
        stepType = STEP_TYPE_PROGRESS_QUEST_OBJECTIVE,
        quest = Draghos_GuideStore.quests[14459],
        questObjectivesIndexes = {1},
        completedAfterCompletedStepIDs = {19},
    },
    [21] = { -- Complete The Battleboars
        id = 21,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[14459],
        requiredStepIDs = {20},
    },
    [22] = { -- Hand in The Battleboars
        id = 22,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14459],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [23] = { -- Hand in Feed of Evil
        id = 23,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14461],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [24] = { -- Pick up Rite of Honor
        id = 24,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[14460],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [25] = { -- Complete Rite of Honor
        id = 25,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[14460],
    },
    [26] = { -- Use Hearthstone to Camp Narache
        id = 26,
        stepType = STEP_TYPE_USE_HEARTHSTONE,
        location = Draghos_GuideStore.locations.hearths[1],
        requiredStepIDs = {27},
        completedAfterCompletedStepIDs = {27},
    },
    [27] = { -- Hand in Rite of Honor
        id = 27,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[14460],
        npc = Draghos_GuideStore.npcs[2981],
        location = Draghos_GuideStore.locations.npcs[1],
    },
};
