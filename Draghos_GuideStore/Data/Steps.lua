Draghos_GuideStore = Draghos_GuideStore or {};

STEP_TYPE_PICKUP_QUEST = 1;
STEP_TYPE_PROGRESS_QUEST_OBJECTIVE = 2;
STEP_TYPE_COMPLETE_QUEST_OBJECTIVE = 3;
STEP_TYPE_COMPLETE_QUEST = 4;
STEP_TYPE_HANDIN_QUEST = 5;
STEP_TYPE_GRIND = 6;

Draghos_GuideStore.steps = {
    [1] = { -- Pick up The First Step
        id = 1,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[1],
        npc = Draghos_GuideStore.npcs[1],
        location = Draghos_GuideStore.locations[1],
    },
    [2] = { -- Hand in The First Step
        id = 2,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[1],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
    },
    [3] = { -- Pick up Rite of Strength
        id = 3,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[2],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
    },
    [4] = { -- Complete quest Rite of Strength
        id = 4,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[2],
    },
    [5] = { -- Hand in Rite of Strength
        id = 5,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[2],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
    },
    [6] = { -- Pick up Our Tribe, Imprisoned
        id = 6,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[3],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
    },
    [7] = { -- Complete quest Our Tribe, Imprisoned
        id = 7,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[3],
    },
    [8] = { -- Hand in Our Tribe, Imprisoned
        id = 8,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[3],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
    },
    [9] = { -- Pick up Go to Adana
        id = 9,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[4],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
    },
    [10] = { -- Hand in Go to Adana
        id = 10,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[4],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [11] = {
        id = 11, -- Pick up Rite of Courage
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[5],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [12] = {
        id = 12, -- Pick up Stop the Thorncallers
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[6],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [13] = { -- Complete quest Rite of Courage
        id = 13,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[5],
    },
    [14] = { -- Complete quest Stop the Thorncallers
        id = 14,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[6],
    },
    [15] = { -- Hand in Rite of Courage
        id = 15,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[5],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [16] = { -- Hand in Stop the Thorncallers
        id = 16,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[6],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [17] = { -- Pick up The Battleboars
        id = 17,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[7],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [18] = { -- Pick up Feed of Evil
        id = 18,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[8],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [19] = { -- Complete Feed of Evil
        id = 19,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[8],
    },
    [20] = { -- Progress The Battleboars
        id = 20,
        stepType = STEP_TYPE_PROGRESS_QUEST_OBJECTIVE,
        quest = Draghos_GuideStore.quests[7],
        questObjectivesIndexes = {1},
        completedAfterCompletedStepIDs = {19},
    },
    [21] = { -- Complete The Battleboars
        id = 21,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[7],
        requiredStepIDs = {20},
    },
    [22] = { -- Hand in The Battleboars
        id = 22,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[7],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [23] = { -- Hand in Feed of Evil
        id = 23,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[8],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [24] = { -- Pick up Rite of Honor
        id = 24,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[9],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [25] = { -- Complete Rite of Honor
        id = 25,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[9],
    },
    -- TODO: Use Hearthstone
    [26] = { -- Hand in Rite of Honor
        id = 26,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[9],
        npc = Draghos_GuideStore.npcs[1],
        location = Draghos_GuideStore.locations[1],
    },
};
