local CreateAndInitFromMixin = CreateAndInitFromMixin;

-- *********************************************************************************************************************
-- ***** LOADING AND RETRIEVING OBJECTS FROM THE STORE
-- *********************************************************************************************************************

local function InitStep(step)
    if step.stepType == STEP_TYPE_PICKUP_QUEST then
        return Draghos_GuideStore:CreateGuideItem(StepPickUpQuestMixin, step);
    elseif step.stepType == STEP_TYPE_PROGRESS_QUEST_OBJECTIVE then
        return Draghos_GuideStore:CreateGuideItem(StepProgressQuestObjectivesMixin, step);
    elseif step.stepType == STEP_TYPE_COMPLETE_QUEST_OBJECTIVE then
        return Draghos_GuideStore:CreateGuideItem(StepCompleteQuestObjectivesMixin, step);
    elseif step.stepType == STEP_TYPE_COMPLETE_QUEST then
        return Draghos_GuideStore:CreateGuideItem(StepCompleteQuestMixin, step);
    elseif step.stepType == STEP_TYPE_HANDIN_QUEST then
        return Draghos_GuideStore:CreateGuideItem(StepHandInQuestMixin, step);
    else
        -- ? return Draghos_GuideStore:CreateObject(StepUnknownMixin, step);
    end
end

function Draghos_GuideStore:LoadSteps()
    self.steps = MapIndexed(self.steps, InitStep);
end

function Draghos_GuideStore:GetStepByID(stepID)
    return FindByProp(self.steps, "stepID", stepID);
end

local function IsStepRemaining(step)
    return step:IsValid() and not step:IsCompleted();
end

local function CompareStepOrder(step1, step2)
    return step1.stepID < step2.stepID;
end

function Draghos_GuideStore:GetRemainingSteps()
    local steps = Filter(self.steps, IsStepRemaining);
    table.sort(steps, CompareStepOrder);
    return steps;
end

function Draghos_GuideStore:GetQuestByID(questID)
    return FindByProp(self.quests, "questID", questID);
end

-- *********************************************************************************************************************
-- ***** OBJECTS CREATION
-- *********************************************************************************************************************

local GuideItemMetatable = {};

-- Trick from this conversation: http://lua-users.org/lists/lua-l/2011-05/msg00029.html
local function meta_tostring(object)
    -- Disable the custom __tostring to get the original value
    GuideItemMetatable.__tostring = nil;
    local originalString = tostring(object);

    -- Re-enable meta_tostring and return the result
    GuideItemMetatable.__tostring = meta_tostring;
    if object and type(object.GetLabel) == "function" then
        return "guide_item: " .. originalString:sub(8) .. " (" .. object:GetLabel() .. ")";
    else
        return originalString;
    end
end
GuideItemMetatable.__tostring = meta_tostring;

function Draghos_GuideStore:CreateGuideItem(mixin, data)
    local object = CreateAndInitFromMixin(mixin, data);
    return setmetatable(object, GuideItemMetatable);
end

-- *********************************************************************************************************************
-- ***** HOOKS
-- *********************************************************************************************************************

local frame;

function GuideStoreFrame_OnLoad(self)
    frame = self;
    Draghos_GuideStore:LoadSteps();
    Draghos_GuideStore.initialized = true;
end

function GuideStoreFrame_OnEvent(self, event, ...)
    local notifiers = Draghos_GuideStore.notifiers and Draghos_GuideStore.notifiers[event] or {};
    for _, notifier in pairs(notifiers) do
        notifier:NotifyWatchers(event, ...);
    end
end

function Draghos_GuideStore:RegisterForNotifications(item, event)
    self.notifiers = self.notifiers or {};
    self.notifiers[event] = self.notifiers[event] or {};
    table.insert(self.notifiers[event], item);
    if not frame:IsEventRegistered(event) then
        frame:RegisterEvent(event, self.OnEvent);
    end
end
