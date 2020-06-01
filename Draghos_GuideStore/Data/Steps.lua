Draghos_GuideStore.steps = {
    -- [-4] = { --
    --     id = -4,
    --     stepType = DraghosEnums.StepTypes.SetHearth,
    --     location = Draghos_GuideStore.locations.hearths[2],
    -- },
    -- [-3] = { --
    --     id = -3,
    --     stepType = DraghosEnums.StepTypes.SetHearth,
    --     location = Draghos_GuideStore.locations.hearths[1],
    -- },
    [-3] = { --
        id = -3,
        stepType = DraghosEnums.StepType.Note,
        message = {
            fr = "Ceci est une note avec un très long message qui ne devrait pas s'afficher entièrement dans l'interface mais un survol de souris devrait afficher le message en entier",
            enUS = "This is a note with a very long message that should not be displayed entirely on the UI but when mousing over it the tooltip should display the full message",
        },
        completedAfterCompletedStepIDs = {27},
        notes = {
            [1] = {noteType = DraghosFlags.NoteState.Normal, message = {enUS = "Even notes can have note lines"}},
            [3] = {
                noteType = DraghosFlags.NoteState.Trivial,
                message = {frFR = "Cette note est grisée", enUS = "This note is grayed out"},
            },
            [2] = {
                message = {
                    frFR = "Cette note devrait apparaître en seconde position",
                    enUS = "This note should appear in second position",
                },
            },
            [4] = {
                noteType = DraghosFlags.NoteState.Disabled,
                message = {frFR = "Cette note ne doit pas s'afficher", enUS = "This note should not be displayed"},
            },
        },
    },
    --[[[-2] = { --
        id = -2,
        stepType = DraghosEnums.StepTypes.UseHearthstone,
        location = Draghos_GuideStore.locations.hearths[2],
        completedAfterCompletedStepIDs = {27},
        notes = {
            [1] = {
                noteType = 0x2,
                message = {
                    fr = "Ceci est une note qui apparaît commme étant complétée",
                    enUS = "This is a note that appears as completed",
                },
            },
        },
    },
    -- [-1] = { --
    --     id = -1,
    --     stepType = DraghosEnums.StepTypes.UseHearthstone,
    --     location = Draghos_GuideStore.locations.hearths[1],
    --     completedAfterCompletedStepIDs = {27},
    -- },
    [-1] = { --
        id = -1,
        stepType = DraghosEnums.StepTypes.STEP_TYPE_NOTE,
        message = {fr = "Cette note apparaît en rouge !", enUS = "This note appears in red!"},
        noteType = DraghosFlags.NoteState.Important,
        requiredStepIDs = {-3},
    },
    [0] = { --
        id = 0,
        stepType = DraghosEnums.StepTypes.STEP_TYPE_GET_FLIGHT_PATH,
        taxiNode = Draghos_GuideStore.taxiNodes[402],
    },]]
    [1] = { -- Pick up The First Step
        id = 1,
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14449],
        npc = Draghos_GuideStore.npcs[2981],
        location = Draghos_GuideStore.locations.npcs[1],
        notes = {[1] = {noteType = 0x4, message = {enUS = "This note should not be displayed"}}},
    },
    [2] = { -- Hand in The First Step
        id = 2,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14449],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
        notes = {
            [1] = {
                noteType = 0x1,
                message = {
                    enUS = "This note is important! It should appear in red!",
                    es = "¡Esta nota es importante! ¡Debería aparecer en rojo!",
                },
            },
        },
    },
    [3] = { -- Pick up Rite of Strength
        id = 3,
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14452],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [4] = { -- Complete quest Rite of Strength
        id = 4,
        stepType = DraghosEnums.StepType.CompleteQuest,
        quest = Draghos_GuideStore.quests[14452],
    },
    [5] = { -- Hand in Rite of Strength
        id = 5,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14452],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [6] = { -- Pick up Our Tribe, Imprisoned
        id = 6,
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[24852],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [7] = { -- Complete quest Our Tribe, Imprisoned
        id = 7,
        stepType = DraghosEnums.StepType.CompleteQuest,
        quest = Draghos_GuideStore.quests[24852],
    },
    [8] = { -- Hand in Our Tribe, Imprisoned
        id = 8,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[24852],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [9] = { -- Pick up Go to Adana
        id = 9,
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14458],
        npc = Draghos_GuideStore.npcs[2980],
        location = Draghos_GuideStore.locations.npcs[2],
    },
    [10] = { -- Hand in Go to Adana
        id = 10,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14458],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [11] = {
        id = 11, -- Pick up Rite of Courage
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14456],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [12] = {
        id = 12, -- Pick up Stop the Thorncallers
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14455],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [13] = { -- Complete quest Rite of Courage
        id = 13,
        stepType = DraghosEnums.StepType.CompleteQuest,
        quest = Draghos_GuideStore.quests[14456],
    },
    [14] = { -- Complete quest Stop the Thorncallers
        id = 14,
        stepType = DraghosEnums.StepType.CompleteQuest,
        quest = Draghos_GuideStore.quests[14455],
    },
    [15] = { -- Hand in Rite of Courage
        id = 15,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14456],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [16] = { -- Hand in Stop the Thorncallers
        id = 16,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14455],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [17] = { -- Pick up The Battleboars
        id = 17,
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14459],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [18] = { -- Pick up Feed of Evil
        id = 18,
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14461],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [19] = { -- Complete Feed of Evil
        id = 19,
        stepType = DraghosEnums.StepType.CompleteQuest,
        quest = Draghos_GuideStore.quests[14461],
    },
    [20] = { -- Progress The Battleboars
        id = 20,
        stepType = DraghosEnums.StepType.ProgressQuestObjectives,
        quest = Draghos_GuideStore.quests[14459],
        questObjectivesIndexes = {1},
        completedAfterCompletedStepIDs = {19},
    },
    [21] = { -- Complete The Battleboars
        id = 21,
        stepType = DraghosEnums.StepType.CompleteQuest,
        quest = Draghos_GuideStore.quests[14459],
        requiredStepIDs = {20},
    },
    [22] = { -- Hand in The Battleboars
        id = 22,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14459],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [23] = { -- Hand in Feed of Evil
        id = 23,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14461],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [24] = { -- Pick up Rite of Honor
        id = 24,
        stepType = DraghosEnums.StepType.PickupQuest,
        quest = Draghos_GuideStore.quests[14460],
        npc = Draghos_GuideStore.npcs[36694],
        location = Draghos_GuideStore.locations.npcs[3],
    },
    [25] = { -- Complete Rite of Honor
        id = 25,
        stepType = DraghosEnums.StepType.CompleteQuest,
        quest = Draghos_GuideStore.quests[14460],
    },
    [26] = { -- Use Hearthstone to Camp Narache
        id = 26,
        stepType = DraghosEnums.StepType.UseHearthstone,
        location = Draghos_GuideStore.locations.hearths[1],
        requiredStepIDs = {27},
        completedAfterCompletedStepIDs = {27},
    },
    [27] = { -- Hand in Rite of Honor
        id = 27,
        stepType = DraghosEnums.StepType.HandinQuest,
        quest = Draghos_GuideStore.quests[14460],
        npc = Draghos_GuideStore.npcs[2981],
        location = Draghos_GuideStore.locations.npcs[1],
    },
};
