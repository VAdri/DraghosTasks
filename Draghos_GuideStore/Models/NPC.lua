local Helpers = DraghosUtils.Helpers;
local Str = DraghosUtils.Str;
local FP = DraghosUtils.FP;
local next = next;

local NPCMixin = {};

function NPCMixin:NPCInit(npc)
    self.npcID = tonumber(npc.npcID);
    self.npcNames = npc.names;
end

function NPCMixin:GetNPCName()
    return self.npcNames and self.npcNames[GetLocale()];
end

local function HasAllNPCNames(npcNames)
    local function hasName(locale)
        return not Str:IsBlankString(npcNames[locale]);
    end
    return npcNames and next(npcNames) ~= nil and FP:All(FP:Keys(Helpers:GetSupportedLocales()), hasName);
end

function NPCMixin:IsValidNPC()
    return self.npcID and HasAllNPCNames(self.npcNames) and true or false;
end

DraghosMixins.NPC = NPCMixin;
