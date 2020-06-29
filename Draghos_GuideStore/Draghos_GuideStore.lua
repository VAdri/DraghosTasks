local CreateAndInitFromMixin = CreateAndInitFromMixin;

local Lambdas = DraghosUtils.Lambdas;
local Helpers = DraghosUtils.Helpers;
local Str = DraghosUtils.Str;

local Linq = LibStub("Linq");

--- @type Enumerable
local Enumerable = Linq.Enumerable;

-- *********************************************************************************************************************
-- ***** LOADING AND RETRIEVING OBJECTS FROM THE STORE
-- *********************************************************************************************************************

local function InitStep(step)
    if step.stepType == DraghosEnums.StepType.Note then
        return DraghosMixins.StepNote.New(step);
    elseif step.stepType == DraghosEnums.StepType.PickupQuest then
        return DraghosMixins.StepPickUpQuest.New(step);
    elseif step.stepType == DraghosEnums.StepType.ProgressQuestObjectives then
        return DraghosMixins.StepProgressQuestObjectives.New(step);
    elseif step.stepType == DraghosEnums.StepType.CompleteQuestObjectives then
        return DraghosMixins.StepCompleteQuestObjectives.New(step);
    elseif step.stepType == DraghosEnums.StepType.CompleteQuest then
        return DraghosMixins.StepCompleteQuest.New(step);
    elseif step.stepType == DraghosEnums.StepType.HandinQuest then
        return DraghosMixins.StepHandInQuest.New(step);
    elseif step.stepType == DraghosEnums.StepType.Grind then
        return DraghosMixins.StepGrind.New(step);
    elseif step.stepType == DraghosEnums.StepType.UseHearthstone then
        return DraghosMixins.StepUseHearthstone.New(step);
    elseif step.stepType == DraghosEnums.StepType.SetHearth then
        return DraghosMixins.StepSetHearth.New(step);
    elseif step.stepType == DraghosEnums.StepType.Go then
        -- TODO: DraghosMixins.StepGo.New(step);
    elseif step.stepType == DraghosEnums.StepType.GetFlightPath then
        return DraghosMixins.StepDiscoverTaxiNode.New(step);
    else
        -- ? return Draghos_GuideStore:CreateObject(StepUnknownMixin, step);
    end
end

function Draghos_GuideStore:LoadSteps()
    self.steps = Enumerable.From(self.steps):Select(InitStep):ToList();
end

function Draghos_GuideStore:GetStepByID(stepID)
    return self.steps:FirstOrDefault(Lambdas.PropsEqual({stepID = stepID}));
end

local function IsStepRemaining(step)
    return step:IsValid() and not step:IsCompleted();
end

function Draghos_GuideStore:GetRemainingSteps()
    return self.steps
        :Where(IsStepRemaining)
        :OrderBy(Lambdas.Property("stepID"))
        :GetEnumerator();
end

function Draghos_GuideStore:GetQuestByID(questID)
    return self.quests[questID];
end

function Draghos_GuideStore:GetHearthstoneItemByID(itemID)
    return self.items.hearth[itemID];
end

function Draghos_GuideStore:GetTaxiNodeByID(nodeID)
    return self.taxiNodes[nodeID];
end

-- *********************************************************************************************************************
-- ***** OBJECTS CREATION
-- *********************************************************************************************************************

function Draghos_GuideStore:CreateBaseItem(mixin, data)
    local object = {};
    Mixin(object, mixin);
    object:InitBase(data);
    return object;
end

-- *********************************************************************************************************************
-- ***** INITIALIZATION
-- *********************************************************************************************************************

local frame;

function GuideStoreFrame_OnLoad(self)
    frame = self;
    Draghos_GuideStore.notifiers = {};
    Draghos_GuideStore.handlers = {};

    Draghos_GuideStore:LoadSteps();

    Draghos_GuideStore.initialized = true;
end

-- *********************************************************************************************************************
-- ***** EVENTS (from store to UI)
-- *********************************************************************************************************************

Draghos_GuideStore.customEventsPrefix = "DRAGHOS";

local function GetStep(stepOrStepLine)
    if stepOrStepLine.step ~= nil then
        return stepOrStepLine.step;
    else
        return stepOrStepLine;
    end
end

function GuideStoreFrame_OnEvent(self, event, ...)
    local notifiers = Enumerable.From(Draghos_GuideStore.notifiers[event] or {});

    -- Clear cache on the step that has changed
    -- If the item that was change is a step line, clear its parent step's cache
    local stepsChanged = notifiers:Select(GetStep):Distinct();
    for _, step in stepsChanged:GetEnumerator() do
        step:ClearCache();
    end

    -- Notify watchers
    local handlers = notifiers:SelectMany(function(notifier) return notifier.watchers or {}; end):Distinct();
    for _, handler in handlers:GetEnumerator() do
        handler();
    end

    -- Collect garbage
    Helpers:StartGarbageCollection();
end

function Draghos_GuideStore:SendCustomEvent(event, ...)
    GuideStoreFrame_OnEvent(self, event, ...);
end

function Draghos_GuideStore:RegisterForNotifications(item, event)
    self.notifiers[event] = self.notifiers[event] or {};
    table.insert(self.notifiers[event], item);
    if Str:StartsWith(event, Draghos_GuideStore.customEventsPrefix) then
        -- This is not a real event we don't need to register it
    elseif not frame:IsEventRegistered(event) then
        frame:RegisterEvent(event);
    end
end

function Draghos_GuideStore:UnregisterForNotifications(item)
    self.notifiers = self.notifiers or {};
    self.notifiers[item] = nil;
end

-- *********************************************************************************************************************
-- ***** MESSAGES (from UI to store)
-- *********************************************************************************************************************

function Draghos_GuideStore:OnMessageReceived(messageType, handler)
    self.handlers[messageType] = self.handlers[messageType] or {};
    table.insert(self.handlers[messageType], handler);
end

function Draghos_GuideStore:SendMesage(messageType, ...)
    -- TODO: ClearMemo();
    local handlers = Enumerable.From(self.handlers[messageType] or {}):Distinct();
    for _, handler in handlers:GetEnumerator() do
        handler(...);
    end
    -- TODO: ClearMemo();
    -- ? Helpers:StartGarbageCollection();
end
