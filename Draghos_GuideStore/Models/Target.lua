local M = LibStub("Moses");

local TargetMixin = {};

local function CreateNPC(npc)
    return Draghos_GuideStore:CreateBaseItem(DraghosMixins.NPC, npc);
end

function TargetMixin:TargetInit(targets)
    self.targets = M(targets or {}):map(CreateNPC):value();
end

local isNotCompleted = M.complement(M.partial(M.result, "_", "IsCompleted"));
function TargetMixin:GetTargetNPCs()
    if (not self:HasCache("GetTargetNPCs")) then
        self:SetCache(
            "GetTargetNPCs", M(self:GetStepLines()):filter(isNotCompleted):map(M.property("targets")):flatten(true)
                :append(self.targets):value()
        );
    end
    return self:GetCache("GetTargetNPCs");
end

function TargetMixin:HasTargets()
    return #self:GetTargetNPCs() > 0;
end

local isNotValidNPC = M.complement(M.partial(M.result, "_", "IsValidNPC"));
function TargetMixin:HasInvalidTargets()
    if (not self:HasTargets()) then
        return false;
    end

    if (not self:HasCache("HasInvalidTargets")) then
        self:SetCache("HasInvalidTargets", M(self:GetTargetNPCs()):any(isNotValidNPC):value());
    end
    return self:GetCache("HasInvalidTargets");
end

local getNPCName = M.partial(M.result, "_", "GetNPCName");
function TargetMixin:GetTargetNames()
    if (not self:HasCache("GetTargetNames")) then
        self:SetCache("GetTargetNames", M(self:GetTargetNPCs()):map(getNPCName):value());
    end
    return self:GetCache("GetTargetNames");
end

function TargetMixin:GetTargetIDs()
    if (not self:HasCache("GetTargetIDs")) then
        self:SetCache("GetTargetIDs", M(self:GetTargetNPCs()):map(M.property("npcID")):value());
    end
    return self:GetCache("GetTargetIDs");
end

DraghosMixins.Target = TargetMixin;
