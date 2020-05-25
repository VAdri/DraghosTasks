LOCATION_TYPE_COORDS = 1;
LOCATION_TYPE_PATH = 2;
LOCATION_TYPE_AREA = 3;

Draghos_GuideStore.locations = {
    hearths = {
        [1] = { -- Camp Narache Hearth location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 462, -- Camp Narache
            areaID = 221, -- Camp Narache
            coords = {27.77, 28.76},
            -- No innkeeper here as it is a starting zone
        },
        [2] = { -- Innkeeper Kauth's Bloodhoof Village Hearth location in Mulgore
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 7, -- Mulgore
            areaID = 222, -- Bloodhoof Village
            coords = {46.8, 60.4},
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
    flightMasters = {
        [1] = { -- Tak's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 7, -- Mulgore
            areaID = 222, -- Bloodhoof Village
            coords = {47.4, 58.7},
        },
        [2] = { -- Tal's location
            locationType = LOCATION_TYPE_COORDS,
            uiMapID = 88, -- Thunder Bluff
            areaID = 1638, -- or 470 or 5345, -- Thunder Bluff
            coords = {46.66, 49.9}, -- 29.7 1197.2
        },
    },
};
