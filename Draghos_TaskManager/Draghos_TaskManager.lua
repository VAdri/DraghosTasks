-- *********************************************************************************************************************
-- ***** MAIN FRAME
-- *********************************************************************************************************************
UIPanelWindows["TaskManagerFrame"] = {area = "left", pushable = 1, whileDead = 1, width = 666, height = 488};

TaskManagerMixin = {};

function TaskManagerFrame_Toggle()
    if (not TaskManagerFrame:IsShown()) then
        ShowUIPanel(TaskManagerFrame);
    else
        HideUIPanel(TaskManagerFrame);
    end
end

function TaskManagerMixin:OnLoad()
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function TaskManagerMixin:OnShow()
    PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
end

function TaskManagerMixin:OnHide()
    PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
end

function TaskManagerMixin:OnEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD");

        -- Initialize portrait texture
        self:SetPortraitToAsset("Interface\\Icons\\inv_misc_scrollunrolled03");

        -- Set the title
        self:SetTitle(TASK_MANAGER_TITLE);

        -- Setup tabs
        ButtonFrameTemplate_HideButtonBar(self);

        -- Setup form
        TaskManagerFrame_InitializeForm();

        -- Setup scroll list
        TaskManagerFrame_InitializeSummaryList();

        -- Function called when the task store is updated
        Draghos_TaskLog:Subscribe(function()
            TaskManagerFrame.SummaryList:Update();
        end);
    end
end

-- *********************************************************************************************************************
-- ***** SCROLL
-- *********************************************************************************************************************

TaskManagerFrameSummaryListMixin = {};

function TaskManagerFrame_SelectTask(taskID)
    if not TaskManagerFrame:IsShown() then
        TaskManagerFrame_Toggle();
    end
    local index = Draghos_TaskLog:GetTaskIndexByTaskID(taskID);
    if index then
        TaskManagerFrame.SummaryList:SetSelectedListIndex(index);
    end
end

local function GetTaskFromListIndex(listIndex)
    local task = Draghos_TaskLog:GetTaskForTaskLogIndex(listIndex);
    if task then
        return task;
    end

    return nil;
end

local function OnSummaryLineSelectedChanged(listIndex)
    if not listIndex then
        listIndex = TaskManagerFrame.SummaryList:GetSelectedListIndex();
    end
    local task = GetTaskFromListIndex(listIndex);
    TaskManagerFrame_SetFormData(task);
end

local function GetNumResultsFunction()
    return Draghos_TaskLog:GetNumTaskLog() + 1;
end

function TaskManagerFrame_InitializeSummaryList()
    TaskManagerFrame.SummaryList:SetGetNumResultsFunction(GetNumResultsFunction);
    TaskManagerFrame.SummaryList:SetSelectionCallback(OnSummaryLineSelectedChanged);
    TaskManagerFrame.SummaryList:SetLineTemplate("TaskManagerSummaryLineTemplate", TaskManagerFrame);

    TaskManagerFrame.SummaryList:SetSelectedListIndex(1);
end

function TaskManagerFrameSummaryListMixin:OnLoad()
    self.InsetFrame:Hide();

    local selectedHighlight = self:GetSelectedHighlight();
    selectedHighlight:SetAtlas("auctionhouse-ui-row-select", true);
    selectedHighlight:SetBlendMode("ADD");
    selectedHighlight:SetAlpha(0.8);
end

function TaskManagerFrameSummaryListMixin:Update()
    TaskManagerFrame.SummaryList:RefreshScrollFrame();
    OnSummaryLineSelectedChanged();
end

TaskManagerSummaryLineMixin = {};

function TaskManagerSummaryLineMixin:OnLoad()
end

function TaskManagerSummaryLineMixin:InitLine(taskManagerFrame)
    self.taskManagerFrame = taskManagerFrame;
end

function TaskManagerSummaryLineMixin:UpdateDisplay()
    local task = GetTaskFromListIndex(self:GetListIndex());
    if task then
        self:SetIconShown(false);
        self.Text:SetText(task.title);
        self.Text:SetPoint("LEFT", 8, 0);
    else
        self:SetIconShown(true);
        self.Icon:SetTexture("Interface\\PaperDollInfoFrame\\Character-Plus");
        self.Text:SetText(TASKLOG_ADD_NEW_TASK);
        self.Text:SetPoint("LEFT", self.Icon, "RIGHT", 4, 0);
    end
end

function TaskManagerSummaryLineMixin:SetIconShown(shown)
    self.Icon:SetShown(shown);
    self.IconBorder:SetShown(shown);
end

function TaskManagerSummaryLineMixin:OnSelected()
end

function TaskManagerSummaryLineMixin:OnEnter()
    -- Show tooltip
end

function TaskManagerSummaryLineMixin:OnLeave()
    -- Hide tooltip
end

-- *********************************************************************************************************************
-- ***** FORM
-- *********************************************************************************************************************

local function SelectRepeatValue(self)
    UIDropDownMenu_SetSelectedValue(TaskManagerFrame.RepeatDropDown, self.value);
end

local function InitializeRepeatDropDown()
    local selectedValue = UIDropDownMenu_GetSelectedValue(TaskManagerFrame.RepeatDropDown);
    local info = UIDropDownMenu_CreateInfo();

    info.func = SelectRepeatValue;

    info.text = CALENDAR_REPEAT_NEVER;
    info.value = TASK_REPEAT_NEVER;
    info.checked = selectedValue == info.value;
    UIDropDownMenu_AddButton(info);

    info.text = CALENDAR_REPEAT_DAILY;
    info.value = TASK_REPEAT_DAILY;
    info.checked = selectedValue == info.value;
    UIDropDownMenu_AddButton(info);

    info.text = CALENDAR_REPEAT_WEEKLY;
    info.value = TASK_REPEAT_WEEKLY;
    info.checked = selectedValue == info.value;
    UIDropDownMenu_AddButton(info);

    info.text = CALENDAR_REPEAT_BIWEEKLY;
    info.value = TASK_REPEAT_BIWEEKLY;
    info.checked = selectedValue == info.value;
    UIDropDownMenu_AddButton(info);

    info.text = CALENDAR_REPEAT_MONTHLY;
    info.value = TASK_REPEAT_MONTHLY;
    info.checked = selectedValue == info.value;
    UIDropDownMenu_AddButton(info);
end

function TaskManagerFrame_InitializeForm()
    UIDropDownMenu_Initialize(TaskManagerFrame.RepeatDropDown, InitializeRepeatDropDown);
end

--- @return Task
local function GetFormTask()
    return TaskMixin:Create(
               TaskManagerFrame.taskID, TaskManagerFrame.TitleEditBox:GetText(),
               TaskManagerFrame.ActivateCheckButton:GetChecked(),
               UIDropDownMenu_GetSelectedValue(TaskManagerFrame.RepeatDropDown)
           );
end

--- @param task Task|nil
function TaskManagerFrame_SetFormData(task)
    if task then
        TaskManagerFrame.taskID = task.taskID;
        TaskManagerFrame.TitleEditBox:SetText(task.title);
        TaskManagerFrame.ActivateCheckButton:SetChecked(task.isActive);
        UIDropDownMenu_SetSelectedValue(TaskManagerFrame.RepeatDropDown, task.repeating);
        TaskManagerFrame.RemoveButton:Show();
    else
        TaskManagerFrame.taskID = nil;
        TaskManagerFrame.TitleEditBox:SetText("");
        TaskManagerFrame.ActivateCheckButton:SetChecked(true);
        UIDropDownMenu_SetSelectedValue(TaskManagerFrame.RepeatDropDown, TASK_REPEAT_NEVER);
        TaskManagerFrame.RemoveButton:Hide();
    end
    TaskManagerFrame_UpdateFormStatus();
    TaskManagerFrame_InitializeForm()
end

function TaskManagerFrame_UpdateFormStatus()
    local newTask = GetFormTask();
    if not newTask:IsValid() or not newTask:IsModified() then
        TaskManagerFrame.SaveButton:Disable();
        return;
    end

    TaskManagerFrame.SaveButton:Enable();
end

TaskManagerFormMixin = {};

function TaskManagerFormMixin:UpdateFormStatus()
    TaskManagerFrame_UpdateFormStatus();
end

TaskManagerSaveButtonMixin = {};

function TaskManagerSaveButtonMixin:OnLoad()
    self:Disable();
end

function TaskManagerSaveButtonMixin:OnClick()
    local newTask = GetFormTask();
    if newTask:IsValid() then
        newTask:Save();
    end
end

TaskManagerRemoveButtonMixin = {};

function TaskManagerRemoveButtonMixin:OnLoad()
    self:Hide();
end

function TaskManagerRemoveButtonMixin:OnClick()
    if TaskManagerFrame.taskID then
        Draghos_TaskLog:RemoveTaskByID(TaskManagerFrame.taskID);
    end
end
