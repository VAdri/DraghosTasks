TASK_TRACKER_MODULE = ObjectiveTracker_GetModuleInfoTable();

OBJECTIVE_TRACKER_UPDATE_MODULE_TASK = 0x100000;

TASK_TRACKER_MODULE.updateReasonModule = OBJECTIVE_TRACKER_UPDATE_MODULE_TASK;
TASK_TRACKER_MODULE.updateReasonEvents = 0;
TASK_TRACKER_MODULE.usedBlocks = {};

TASK_TRACKER_MODULE.buttonOffsets = {groupFinder = {7, 4}, useItem = {3, 1}};

TASK_TRACKER_MODULE.paddingBetweenButtons = 2;

local TaskManagerFrame_SelectTask = TaskManagerFrame_SelectTask or function()
    return; --[[Do nothing]]
end;

-- *********************************************************************************************************************
-- ***** INITIALIZATION
-- *********************************************************************************************************************

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
                                "Frame", "ObjectiveTrackerBlocksFrame.TaskHeader", ObjectiveTrackerFrame.BlocksFrame,
                                "ObjectiveTrackerHeaderTemplate"
                            );

    TASK_TRACKER_MODULE:SetHeader(taskHeaderFrame, TRACKER_HEADER_TASKS, OBJECTIVE_TRACKER_UPDATE_REASON);

    table.insert(ObjectiveTrackerFrame.MODULES, TASK_TRACKER_MODULE);
    table.insert(ObjectiveTrackerFrame.MODULES_UI_ORDER, TASK_TRACKER_MODULE);

    ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_TASK);

    -- Function called when the task store is updated
    Draghos_TaskLog:Subscribe(
        function()
            ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_TASK);
        end
    );

    self:UnregisterEvent("PLAYER_ENTERING_WORLD");
    self.initialized = true;
end

-- *********************************************************************************************************************
-- ***** ANIMATIONS
-- *********************************************************************************************************************

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

-- *********************************************************************************************************************
-- ***** UPDATE FUNCTIONS
-- *********************************************************************************************************************

function TASK_TRACKER_MODULE:ShouldDisplayTask(task)
    return not task:IsCompleted();
end

function TASK_TRACKER_MODULE:BuildTaskWatchInfos()
    local infos = {};

    for i = 1, Draghos_TaskLog:GetNumTaskWatches() do
        local task = Draghos_TaskLog:GetTaskForTaskWatchIndex(i);
        if task and self:ShouldDisplayTask(task) then
            table.insert(infos, {task = task, index = i});
        end
    end

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

--- @param task Task
function TASK_TRACKER_MODULE:UpdateSingle(task)
    local taskID = task:GetID();

    local block = self:GetBlock(taskID);
    block.id = taskID;

    self:SetBlockHeader(block, task.title);

    for key, step in pairs(task.steps) do
        self:AddObjective(block, taskID .. ":" .. key, step:GetLabel());
    end

    block:SetHeight(block.height);

    if ObjectiveTracker_AddBlock(block) then
        block:Show();
        self:FreeUnusedLines(block);
    else
        block.used = false;
        return true; -- Can't add the block, we're done enumerating tasks
    end
end

function TASK_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)
    if mouseButton == "LeftButton" then
        TaskManagerFrame_SelectTask(block.id);
    elseif mouseButton == "RightButton" then
        ObjectiveTracker_ToggleDropDown(block, TaskObjectiveTracker_OnOpenDropDown);
    end
end

function TASK_TRACKER_MODULE:Update()
    self:BeginLayout();

    self:EnumTaskWatchData(self.UpdateSingle);

    self:EndLayout();
end

-- *********************************************************************************************************************
-- ***** BLOCK DROPDOWN FUNCTIONS
-- *********************************************************************************************************************

local MANUAL_STEPS_MENU_LIST = 1;

local function TaskObjectiveTracker_ShowManualStepsDropDown(self, level)
    local block = self.activeFrame;
    local task = Draghos_TaskLog:GetTaskByTaskID(block.id);

    local info = UIDropDownMenu_CreateInfo();

    local manualSteps = task:GetManualSteps();
    for index, step in pairs(manualSteps) do
        info.text = step:GetLabel();
        info.func = function()
            step:ToggleCompleted();
            step:SaveModifications(index);
        end;
        info.checked = step:IsCompleted();
        UIDropDownMenu_AddButton(info, level);
    end
end

local function TaskObjectiveTracker_ShowDropDown(self)
    local block = self.activeFrame;
    local task = Draghos_TaskLog:GetTaskByTaskID(block.id);

    local info = UIDropDownMenu_CreateInfo();
    info.text = task.title;
    info.isTitle = 1;
    info.notCheckable = 1;
    UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL);

    info = UIDropDownMenu_CreateInfo();
    info.text = OBJECTIVES_VIEW_TASK;
    info.notCheckable = 1;
    info.arg1 = block.id;
    info.func = function()
        TaskManagerFrame_SelectTask(block.id);
    end;
    info.checked = false;
    UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL);

    if task:HasManualSteps() then
        info.text = OBJECTIVES_MARK_STEP_AS_COMPLETE;
        info.arg1 = task.taskID;
        info.hasArrow = true;
        info.menuList = MANUAL_STEPS_MENU_LIST;
        info.func = nil;
        info.checked = false;
        UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL);
        info.hasArrow = false;
        info.menuList = nil;
    end

    info.text = OBJECTIVES_STOP_TRACKING;
    info.arg1 = block.id;
    info.func = function()
        task:StopTracking();
    end
    info.checked = false;
    UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL);
end

function TaskObjectiveTracker_OnOpenDropDown(self, level, menuList)
    if level == 1 then
        TaskObjectiveTracker_ShowDropDown(self);
    elseif level == 2 and menuList == MANUAL_STEPS_MENU_LIST then
        TaskObjectiveTracker_ShowManualStepsDropDown(self, level);
    end
end
