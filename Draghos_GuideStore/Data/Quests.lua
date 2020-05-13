Draghos_GuideStore = Draghos_GuideStore or {};

QUEST_OBJECTIVE_TYPE_ITEM = "item";
QUEST_OBJECTIVE_TYPE_OBJECT = "object";
QUEST_OBJECTIVE_TYPE_MONSTER = "monster";
QUEST_OBJECTIVE_TYPE_REPUTATION = "reputation";
QUEST_OBJECTIVE_TYPE_LOG = "log";
QUEST_OBJECTIVE_TYPE_EVENT = "event";
QUEST_OBJECTIVE_TYPE_PLAYER = "player";
QUEST_OBJECTIVE_TYPE_PROGRESSBAR = "progressbar";
-- CUSTOM_QUEST_OBJECTIVE_TYPE_SET_FREE = "setfree";
CUSTOM_QUEST_OBJECTIVE_TYPE_USE_ITEM = "useitem";

Draghos_GuideStore.quests = {
    [1] = {
        questID = 14449, -- The First Step
    },
    [2] = {
        questID = 14452, -- Rite of Strength
        questObjectives = {
            [1] = {
                questObjective = {questID = 14452, index = 1},
                location = {}, -- TODO
            },
        },
        requiredQuestIDs = {14449},
    },
    [3] = {
        questID = 24852, -- Our Tribe, Imprisoned
        questObjectives = {
            [1] = {
                questObjective = {
                    questID = 24852,
                    index = 1,
                    -- overrideObjectiveType = CUSTOM_QUEST_OBJECTIVE_TYPE_SET_FREE,
                },
                location = {}, -- TODO
                object = {}, -- TODO
            },
        },
        requiredQuestIDs = {14452},
    },
    [4] = {
        questID = 14458, -- Go to Adana
        requiredQuestIDs = {24852},
    },
    [5] = {
        questID = 14456, -- Stop the Thorncallers
        requiredQuestIDs = {14458},
    },
    [6] = {
        questID = 14455, -- Rite of Courage
        requiredQuestIDs = {14458},
    },
    [7] = {
        questID = 14459, -- The Battleboars
        questObjectives = {
            [1] = {
                questObjective = {questID = 14459, index = 1},
                location = {}, -- TODO
                npc = Draghos_GuideStore.npcs[5],
            },
        },
        requiredQuestIDs = {14456, 14455},
    },
    [8] = {
        questID = 14461, -- Feed of Evil
        questObjectives = {
            [1] = {
                questObjective = {
                    questID = 14461,
                    index = 1,
                    overrideObjectiveType = CUSTOM_QUEST_OBJECTIVE_TYPE_USE_ITEM,
                },
                location = Draghos_GuideStore.locations[4],
                npc = Draghos_GuideStore.npcs[6],
                item = Draghos_GuideStore.items[1],
            },
            [2] = {
                questObjective = {
                    questID = 14461,
                    index = 2,
                    overrideObjectiveType = CUSTOM_QUEST_OBJECTIVE_TYPE_USE_ITEM,
                },
                location = Draghos_GuideStore.locations[5],
                npc = Draghos_GuideStore.npcs[7],
                item = Draghos_GuideStore.items[1],
            },
            [3] = {
                questObjective = {
                    questID = 14461,
                    index = 3,
                    overrideObjectiveType = CUSTOM_QUEST_OBJECTIVE_TYPE_USE_ITEM,
                },
                location = Draghos_GuideStore.locations[6],
                npc = Draghos_GuideStore.npcs[8],
                item = Draghos_GuideStore.items[1],
            },
        },
        requiredQuestIDs = {14456, 14455},
    },
    [9] = {
        questID = 14460, -- Rite of Honor
        questObjectives = {
            [1] = {
                questObjective = {questID = 14460, index = 1},
                location = Draghos_GuideStore.locations[7],
                npc = Draghos_GuideStore.npcs[9],
            },
        },
        requiredQuestIDs = {14459, 14461},
    },
}
