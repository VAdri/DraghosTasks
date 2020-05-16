LOCATION_TYPE_COORDS = 1;
LOCATION_TYPE_PATH = 2;
LOCATION_TYPE_AREA = 3;

Draghos_GuideStore.locations = {
    hearths = {
        [1] = { -- Camp Narache Hearth location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {27.77, 28.76},
            hearthNames = {
                ["deDE"] = "Camp Narache",
                ["enUS"] = "Camp Narache",
                ["enGB"] = "Camp Narache",
                ["esES"] = "Campamento Narache",
                ["esMX"] = "Campamento Narache",
                ["frFR"] = "Camp Narache",
                ["itIT"] = "Campo Narache",
                ["koKR"] = "나라체 야영지",
                ["ptBR"] = "Aldeia Narache",
                ["ruRU"] = "Лагерь Нараче",
                ["zhTW"] = "纳拉其营地",
                ["zhCN"] = "纳拉其营地",
            },
        },
        [2] = { -- Innkeeper Kauth's Bloodhoof Village Hearth location in Mulgore
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 1306, -- Mulgore
            coords = {46.8, 60.4},
            hearthNames = {
                ["deDE"] = "",
                ["enUS"] = "Bloodhoof Village",
                ["enGB"] = "Bloodhoof Village",
                ["esES"] = "",
                ["esMX"] = "",
                ["frFR"] = "Sabot-de-Sang",
                ["itIT"] = "",
                ["koKR"] = "",
                ["ptBR"] = "",
                ["ruRU"] = "",
                ["zhTW"] = "",
                ["zhCN"] = "",
            },
            innkeeper = Draghos_GuideStore.npcs[6747], -- Innkeeper Kauth
        },
    },
    npcs = {
        [1] = { -- Chief Hawkwind's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {27.7, 28.3},
        },
        [2] = { -- Grull Hawkwind's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {39.4, 37},
        },
        [3] = { -- Adana Thunderhorn's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {31, 50.6},
        },
    },
    mobs = {
        [1] = { -- Chief Squealer Thornmantle's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {15.8, 46.8},
        },
    },
    questObjectives = {
        [1] = { -- First Trough's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {28.2, 70.4},
        },
        [2] = { -- Second Trough's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {25.1, 69.2},
        },
        [3] = { -- Third Trough's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            coords = {26.4, 66.3},
        },
    },
};
