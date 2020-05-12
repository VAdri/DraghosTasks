Draghos_GuideStore = {};

Draghos_GuideStore.npcs = {
    [1] = { -- Chief Hawkwind
        npcID = 2981,
        names = {
            ["deDE"] = "Häuptling Falkenwind",
            ["enGB"] = "Chief Hawkwind",
            ["enUS"] = "Chief Hawkwind",
            ["esES"] = "Jefe Viento de Halcón",
            ["esMX"] = "Jefe Viento de Halcón",
            ["frFR"] = "Chef Vent-du-faucon",
            ["itIT"] = "Capo Vento Agile",
            ["koKR"] = "족장 호크윈드",
            ["ptBR"] = "Chefe Vento do Falcão",
            ["ruRU"] = "Вождь Соколиный Ветер",
            ["zhTW"] = "鹰风酋长",
            ["zhCN"] = "鹰风酋长",
        },
    },
    [2] = { -- Grull Hawkwind
        npcID = 2980,
        names = {
            ["deDE"] = "Grull Falkenwind",
            ["enGB"] = "Grull Hawkwind",
            ["enUS"] = "Grull Hawkwind",
            ["esES"] = "Grull Viento de Halcón",
            ["esMX"] = "Grull Viento de Halcón",
            ["frFR"] = "Grull Vent-du-faucon",
            ["itIT"] = "Grull Vento Agile",
            ["koKR"] = "그룰 호크윈드",
            ["ptBR"] = "Grull Vento do Falcão",
            ["ruRU"] = "Грулл Соколиный Ветер",
            ["zhTW"] = "格鲁尔·鹰风",
            ["zhCN"] = "格鲁尔·鹰风",
        },
    },
    [3] = { -- Adana Thunderhorn
        npcID = 36694,
        names = {
            ["deDE"] = "Adana Donnerhornd",
            ["enUS"] = "Adana Thunderhorn",
            ["enGB"] = "Adana Thunderhorn",
            ["esES"] = "Adana Tronacuerno",
            ["esMX"] = "Adana Tronacuerno",
            ["frFR"] = "Adana Corne-Tonnerre",
            ["itIT"] = "Adana Corno Tonante",
            ["koKR"] = "아다나 썬더혼",
            ["ptBR"] = "Adana Chifre Troante",
            ["ruRU"] = "Эдана Громовой Рог",
            ["zhTW"] = "阿达娜·雷角",
            ["zhCN"] = "阿达娜·雷角",
        },
    },
    [4] = {}, -- TODO
    [5] = {
        npcID = 36696, -- Armored Battleboar
        names = {
            ["deDE"] = "Gepanzerter Kampfeber",
            ["enUS"] = "Armored Battleboar",
            ["enGB"] = "Armored Battleboar",
            ["esES"] = "Jabaguerrero acorazado",
            ["esMX"] = "Jabaguerrero acorazado",
            ["frFR"] = "Sanglier de guerre cuirassé",
            ["itIT"] = "Cinghiale da Guerra Corazzato",
            ["koKR"] = "무장한 전투멧돼지",
            ["ptBR"] = "Javaliço Encouraçado",
            ["ruRU"] = "Бронированный боевой вепрь",
            ["zhTW"] = "重甲斗猪",
            ["zhCN"] = "重甲斗猪",
        },
    },
    [6] = {
        npcID = 36727, -- First Trough
        names = {
            ["deDE"] = "First Trough", -- ! Absent value
            ["enUS"] = "First Trough",
            ["enGB"] = "First Trough",
            ["esES"] = "First Trough", -- ! Absent value
            ["esMX"] = "First Trough", -- ! Absent value
            ["frFR"] = "First Trough", -- ! Absent value
            ["itIT"] = "Prima Mangiatoia",
            ["koKR"] = "첫 번째 여물통",
            ["ptBR"] = "Primeira Gamela",
            ["ruRU"] = "First Trough", -- ! Absent value
            ["zhTW"] = "第一斗猪",
            ["zhCN"] = "第一斗猪",
        },
    },
    [7] = {
        npcID = 37155,
        names = {
            ["deDE"] = "Second Trough", -- ! Absent value
            ["enUS"] = "Second Trough",
            ["enGB"] = "Second Trough",
            ["esES"] = "Second Trough", -- ! Absent value
            ["esMX"] = "Second Trough", -- ! Absent value
            ["frFR"] = "Second Trough", -- ! Absent value
            ["itIT"] = "Seconda Mangiatoia",
            ["koKR"] = "두 번째 여물통",
            ["ptBR"] = "Segunda Gamela",
            ["ruRU"] = "Second Trough", -- ! Absent value
            ["zhTW"] = "Second Trough", -- ! Absent value
            ["zhCN"] = "Second Trough", -- ! Absent value
        },
    },
    [8] = {
        npcID = 37156,
        names = {
            ["deDE"] = "Third Trough", -- ! Absent value
            ["enUS"] = "Third Trough",
            ["enGB"] = "Third Trough",
            ["esES"] = "Third Trough", -- ! Absent value
            ["esMX"] = "Third Trough", -- ! Absent value
            ["frFR"] = "Third Trough", -- ! Absent value
            ["itIT"] = "Terza Mangiatoia",
            ["koKR"] = "세 번째 여물통",
            ["ptBR"] = "Terceira Gamela",
            ["ruRU"] = "Third Trough", -- ! Absent value
            ["zhTW"] = "Third Trough", -- ! Absent value
            ["zhCN"] = "Third Trough", -- ! Absent value
        },
    },
}

Draghos_GuideStore.items = {
    [1] = {
        itemID = 49359, -- Adana's Torch
        spellID = 69228, -- Throw Torch
    },
};

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
    },
    [4] = {
        questID = 14458, -- Go to Adana
    },
    [5] = {
        questID = 14459, -- The Battleboars
        questObjectives = {
            [1] = {
                questObjective = {questID = 14459, index = 1},
                location = {}, -- TODO
                npc = Draghos_GuideStore.npcs[5],
            },
        },
    },
    [6] = {
        questID = 14461, -- Feed of Evil
        questObjectives = {
            [1] = {
                questObjective = {
                    questID = 14459,
                    index = 1,
                    overrideObjectiveType = CUSTOM_QUEST_OBJECTIVE_TYPE_USE_ITEM,
                },
                location = {}, -- TODO
                npc = Draghos_GuideStore.npcs[6],
                item = Draghos_GuideStore.items[1],
            },
            [2] = {
                questObjective = {
                    questID = 14459,
                    index = 1,
                    overrideObjectiveType = CUSTOM_QUEST_OBJECTIVE_TYPE_USE_ITEM,
                },
                location = {}, -- TODO
                npc = Draghos_GuideStore.npcs[7],
                item = Draghos_GuideStore.items[1],
            },
            [3] = {
                questObjective = {
                    questID = 14459,
                    index = 1,
                    overrideObjectiveType = CUSTOM_QUEST_OBJECTIVE_TYPE_USE_ITEM,
                },
                location = {}, -- TODO
                npc = Draghos_GuideStore.npcs[8],
                item = Draghos_GuideStore.items[1],
            },
        },
    },
}

-- self:RegisterEvent("QUEST_LOG_UPDATE");

Draghos_GuideStore.locations = {
    [1] = { -- Chief Hawkwind's location
        locationType = LOCATION_TYPE_COORDS,
        uiMapID = 462, -- Camp Narache
        coords = {27.2, 28.4},
    },
    [2] = { -- Grull Hawkwind's location
        locationType = LOCATION_TYPE_COORDS,
        uiMapID = 462, -- Camp Narache
        coords = {39.4, 37},
    },
    [3] = { -- Adana Thunderhorn's location
        locationType = LOCATION_TYPE_COORDS,
        uiMapID = 462, -- Camp Narache
        coords = {46.2, 82.5},
    },
}

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
        requiredStepIDs = {1},
    },
    [3] = { -- Pick up Rite of Strength
        id = 3,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[2],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
        requiredStepIDs = {2},
    },
    [4] = { -- Complete quest Rite of Strength
        id = 4,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[2],
        requiredStepIDs = {3},
    },
    [5] = { -- Hand in Rite of Strength
        id = 5,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[2],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
        requiredStepIDs = {4},
    },
    [6] = { -- Pick up Our Tribe, Imprisoned
        id = 6,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[3],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
        requiredStepIDs = {5},
    },
    [7] = { -- Complete quest Our Tribe, Imprisoned
        id = 7,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[3],
        requiredStepIDs = {6},
    },
    [8] = { -- Hand in Our Tribe, Imprisoned
        id = 8,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[3],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
        requiredStepIDs = {7},
    },
    [9] = { -- Pick up Go to Adana
        id = 9,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[4],
        npc = Draghos_GuideStore.npcs[2],
        location = Draghos_GuideStore.locations[2],
        requiredStepIDs = {8},
    },
    [10] = { -- Hand in Go to Adana
        id = 10,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[4],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
        requiredStepIDs = {9},
    },
    [11] = { -- Pick up The Battleboars
        id = 11,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[5],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [12] = { -- Pick up Feed of Evil
        id = 12,
        stepType = STEP_TYPE_PICKUP_QUEST,
        quest = Draghos_GuideStore.quests[6],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
    },
    [13] = { -- Progress The Battleboars
        id = 13,
        stepType = STEP_TYPE_PROGRESS_QUEST_OBJECTIVE,
        quest = Draghos_GuideStore.quests[5],
        questObjectivesIndexes = {1},
        requiredStepIDs = {11},
        completedAfterCompletedStepIDs = {14, 15, 16},
    },
    [14] = { -- Complete objective 1 Feed of Evil
        id = 14,
        stepType = STEP_TYPE_COMPLETE_QUEST_OBJECTIVE,
        quest = Draghos_GuideStore.quests[6],
        requiredStepIDs = {12},
    },
    [15] = { -- Complete objective 2 Feed of Evil
        id = 15,
        stepType = STEP_TYPE_COMPLETE_QUEST_OBJECTIVE,
        quest = Draghos_GuideStore.quests[6],
        requiredStepIDs = {12},
    },
    [16] = { -- Complete objective 3 Feed of Evil
        id = 16,
        stepType = STEP_TYPE_COMPLETE_QUEST_OBJECTIVE,
        quest = Draghos_GuideStore.quests[6],
        requiredStepIDs = {12},
    },
    [17] = { -- Complete The Battleboars
        id = 17,
        stepType = STEP_TYPE_COMPLETE_QUEST,
        quest = Draghos_GuideStore.quests[5],
        requiredStepIDs = {11},
    },
    [18] = { -- Hand in The Battleboars
        id = 18,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[5],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
        requiredStepIDs = {17},
    },
    [19] = { -- Hand in Feed of Evil
        id = 19,
        stepType = STEP_TYPE_HANDIN_QUEST,
        quest = Draghos_GuideStore.quests[6],
        npc = Draghos_GuideStore.npcs[3],
        location = Draghos_GuideStore.locations[3],
        requiredStepIDs = {14, 15, 16},
    },
};

local function InitStep(step)
    if step.stepType == STEP_TYPE_PICKUP_QUEST then
        return CreateAndInitFromMixin(StepPickUpQuestMixin, step);
    elseif step.stepType == STEP_TYPE_PROGRESS_QUEST_OBJECTIVE then
        return CreateAndInitFromMixin(StepProgressQuestObjectivesMixin, step);
    elseif step.stepType == STEP_TYPE_COMPLETE_QUEST_OBJECTIVE then
        return CreateAndInitFromMixin(StepCompleteQuestObjectivesMixin, step);
    elseif step.stepType == STEP_TYPE_COMPLETE_QUEST then
        return CreateAndInitFromMixin(StepCompleteQuestMixin, step);
    elseif step.stepType == STEP_TYPE_HANDIN_QUEST then
        return CreateAndInitFromMixin(StepHandInQuestMixin, step);
    else
        -- ? return CreateAndInitFromMixin(StepUnknownMixin, step);
    end
end

local function IsStepRemaining(step)
    return step:IsValid() and not step:IsCompleted();
end

function Draghos_GuideStore:LoadSteps()
    self.steps = MapIndexed(self.steps, InitStep);
end

function Draghos_GuideStore:GetStepByID(stepID)
    return FindByProp(self.steps, "stepID", stepID);
end

function Draghos_GuideStore:GetRemainingSteps()
    return Filter(self.steps, IsStepRemaining);
end

function Draghos_GuideStore:GetQuestByID(questID)
    return FindByProp(self.quests, "questID", questID);
end

Draghos_GuideStore:LoadSteps();
