TASK_TRACKER_MODULE = ObjectiveTracker_GetModuleInfoTable();

OBJECTIVE_TRACKER_UPDATE_MODULE_TASK = 0x100000;

TASK_TRACKER_MODULE.updateReasonModule = OBJECTIVE_TRACKER_UPDATE_MODULE_TASK;
TASK_TRACKER_MODULE.updateReasonEvents = 0;
TASK_TRACKER_MODULE.usedBlocks = {};

TASK_TRACKER_MODULE.buttonOffsets = {groupFinder = {7, 4}, useItem = {3, 1}};

TASK_TRACKER_MODULE.paddingBetweenButtons = 2;

-- *****************************************************************************************************
-- ***** INITIALIZATION
-- *****************************************************************************************************

function TaskObjectiveTracker_OnLoad(self, ...)
    self:RegisterEvent("PLAYER_ENTERING_WORLD");

    TaskObjectiveTrackerInitialize(self);
end

function TaskObjectiveTracker_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        TaskObjectiveTrackerInitialize(self);
    end
end

function TaskObjectiveTrackerInitialize(self)
    if self.initialized or not ObjectiveTrackerFrame.initialized then
        return;
    end

    local taskHeaderFrame = CreateFrame(
                                "Frame", "TaskHeader", ObjectiveTrackerFrame.BlocksFrame,
                                "ObjectiveTrackerHeaderTemplate"
                            );

    TASK_TRACKER_MODULE:SetHeader(taskHeaderFrame, TRACKER_HEADER_TASKS, 0);

    table.insert(ObjectiveTrackerFrame.MODULES, TASK_TRACKER_MODULE);
    table.insert(ObjectiveTrackerFrame.MODULES_UI_ORDER, TASK_TRACKER_MODULE);

    ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_TASK);

    self:UnregisterEvent("PLAYER_ENTERING_WORLD");
    self.initialized = true;
end

-- *****************************************************************************************************
-- ***** ANIMATIONS
-- *****************************************************************************************************

function TaskObjectiveTracker_FinishGlowAnim(line)
    if (line.state == "ADDING") then
        line.state = "PRESENT";
    else
        -- local questID = line.block.id;
        -- if (IsQuestSequenced(questID)) then
        --     line.FadeOutAnim:Play();
        --     line.state = "FADING";
        -- else
        line.state = "COMPLETED";
        ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_TASK);
        -- end
    end
end

function TaskObjectiveTracker_FinishFadeOutAnim(line)
    local block = line.block;
    block.module:FreeLine(block, line);
    for _, otherLine in pairs(block.lines) do
        if (otherLine.state == "FADING") then
            -- some other line is still fading
            return;
        end
    end
    ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_TASK);
end

-- *****************************************************************************************************
-- ***** UPDATE FUNCTIONS
-- *****************************************************************************************************

local function CompareTaskWatchInfos(info1, info2)
    return info1.index < info2.index;
end

function TASK_TRACKER_MODULE:ShouldDisplayTask(task)
    -- TODO
    return true;
end

function TASK_TRACKER_MODULE:BuildTaskWatchInfos()
    local infos = {};

    for i = 1, Draghos_TaskLog:GetNumTaskWatches() do
        local taskID = Draghos_TaskLog:GetTaskIDForTaskWatchIndex(i);
        if taskID then
            local task = TaskCache:Get(taskID);
            if self:ShouldDisplayTask(task) then
                table.insert(infos, {task = task, index = i});
            end
        end
    end

    table.sort(infos, CompareTaskWatchInfos);
    return infos;
end

function TASK_TRACKER_MODULE:EnumTaskWatchData(func)
    local infos = self:BuildTaskWatchInfos();
    for _, taskWatchInfo in ipairs(infos) do
        if func(self, taskWatchInfo.task) then
            return;
        end
    end
end

function TASK_TRACKER_MODULE:UpdateSingle(task)
    local taskID = task:GetID();

    local block = self:GetBlock(taskID);

    self:SetBlockHeader(block, task.title);
    self:AddObjective(block, "TaskTest", "Test");

    block:SetHeight(block.height);

    if ObjectiveTracker_AddBlock(block) then
        block:Show();
        self:FreeUnusedLines(block);
    else
        block.used = false;
        return true; -- Can't add the block, we're done enumerating tasks
    end
end

function TASK_TRACKER_MODULE:Update()
    self:BeginLayout();

    self:EnumTaskWatchData(self.UpdateSingle);

    self:EndLayout();
end
