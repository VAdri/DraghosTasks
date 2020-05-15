local FP = DraghosUtils.FP;

local TargetMixin = {};

local function CreateNPC(npc)
    local createdNPC = CreateFromMixins(DraghosMixins.NPC);
    createdNPC:NPCInit(npc);
    return createdNPC;
end

function TargetMixin:TargetInit(targets)
    self.targets = FP:Map(targets or {}, CreateNPC);
end

function TargetMixin:GetTargetNPCs()
    local incompleteStepLines = FP:Filter(self.stepLines or {}, FP:ReverseResult(FP:CallOnSelf("IsCompleted")));
    local stepLinesTargets = FP:Flatten(FP:MapProp(incompleteStepLines, "targets"));
    return FP:Concat(self.targets, stepLinesTargets);
end

function TargetMixin:HasTargets()
    return #self:GetTargetNPCs() > 0;
end

function TargetMixin:HasInvalidTargets()
    return not FP:All(self:GetTargetNPCs(), FP:CallOnSelf("IsValidNPC"));
end

function TargetMixin:GetTargetNames()
    return FP:Map(self:GetTargetNPCs(), FP:CallOnSelf("GetNPCName"));
end

function TargetMixin:GetTargetIDs()
    return FP:MapProp(self:GetTargetNPCs(), "npcID");
end

DraghosMixins.Target = TargetMixin;
