local Helpers = DraghosUtils.Helpers;
local Str = DraghosUtils.Str;

local M = LibStub("Moses");

local next = next;

local NPCMixin = {};

Mixin(NPCMixin, DraghosMixins.Cache);

function NPCMixin:InitBase(npc, cacheRequired)
    if (cacheRequired ~= false) then
        self:CacheInit();
    end

    self.npcID = tonumber(npc.npcID);
    self.npcNames = npc.names;
end

function NPCMixin:NPCInit(npc)
    self:InitBase(npc, false);
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
    if (not self.npcID) then
        return false;
    end

    if (not self:HasCache("IsValidNPC")) then
        self:SetCache("IsValidNPC", HasAllNPCNames(self.npcNames));
    end
    return self:GetCache("IsValidNPC");
end

DraghosMixins.NPC = NPCMixin;
