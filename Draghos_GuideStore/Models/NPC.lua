local Helpers = DraghosUtils.Helpers;
local Str = DraghosUtils.Str;

local M = LibStub("Moses");

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
    return npcNames and next(npcNames) ~= nil and M(Helpers:GetSupportedLocales()):keys():all(hasName):value();
end

function NPCMixin:IsValidNPC()
    return self.npcID and HasAllNPCNames(self.npcNames) and true or false;
end

DraghosMixins.NPC = NPCMixin;
