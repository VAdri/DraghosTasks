NPCMixin = {};

local next = next;

function NPCMixin:NPCInit(npc)
    self.npcID = tonumber(npc.npcID);
    self.npcNames = npc.names;
end

function NPCMixin:GetNPCName()
    return self.npcNames and self.npcNames[GetLocale()];
end

local function hasAllNPCNames(npcNames)
    local function hasName(locale)
        return not IsBlankString(npcNames[locale]);
    end
    return npcNames and next(npcNames) ~= nil and All(Keys(GetSupportedLocales()), hasName);
end

function NPCMixin:IsValidNPC()
    return self.npcID and hasAllNPCNames(self.npcNames) and true or false;
end
