-- Variables --
local isRecording = false
local actionReplay = false

-- Functions --
local function DisplayNotification(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

local function ShowRecordingTooltip(helpText)
    local startTime = GetGameTimer()
    while IsRecording() do
        Citizen.Wait(0)
        if GetGameTimer() - startTime < Config.TooltipTimer then
            DisplayHelpTextThisFrame(helpText, false)
        end
    end
end

local function ToggleRecording()
    if IsRecording() then
        if actionReplay then
            StopRecordingAndSaveClip()
            if SaveRecordingClip() then
                DisplayNotification(Config.Localization.Notifications.ActionReplaySaved)
            end
        else
            isRecording = false
            StopRecordingAndSaveClip()
            if SaveRecordingClip() then
                DisplayNotification(Config.Localization.Notifications.ClipSaved)
            end
        end
    else
        isRecording = true
        StartRecording(1)
        Citizen.Wait(100)
        if IsRecording() then
            ShowRecordingTooltip("recording_clip_info")
        end
    end
end

local function ToggleActionReplay()
    if IsRecording() then
        if not isRecording then
            actionReplay = false
            StopRecordingAndDiscardClip()
            DisplayNotification(Config.Localization.Notifications.ActionReplayStop)
        else
            DisplayNotification(Config.Localization.Notifications.AlreadyRecording)
        end
    else
        actionReplay = true
        StartRecording(0)

        Citizen.Wait(100)
        if IsRecording() then
            DisplayNotification(Config.Localization.Notifications.ActionReplayStart)
            ShowRecordingTooltip("action_replay_info")
        end
    end
end

local function CancelRecording()
    if IsRecording() then
        if actionReplay then
            DisplayNotification(Config.Localization.Notifications.ActionReplayStop)
        else
            DisplayNotification(Config.Localization.Notifications.Discarded)
        end
        StopRecordingAndDiscardClip()
    else
        DisplayNotification(Config.Localization.Notifications.NotRecording)
    end
    actionReplay = false
    isRecording = false
end

local function OpenRockstarEditor()
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
end


-- Commands & Key Mapping --
-- Record
RegisterKeyMapping('record', Config.Localization.KeyMapping.Record, 'keyboard', Config.KeyMapping.Start)
RegisterCommand('record', function()
    ToggleRecording()
end, false)

-- Action Replay
RegisterKeyMapping('actionreplay', Config.Localization.KeyMapping.ActionReplay, 'keyboard', Config.KeyMapping.ActionReplay)
RegisterCommand('actionreplay', function()
    ToggleActionReplay()
end, false)

-- Cancel
RegisterKeyMapping('cancelrecording', Config.Localization.KeyMapping.Cancel, 'keyboard', Config.KeyMapping.Cancel)
RegisterCommand('cancelrecording', function()
    CancelRecording()
end, false)

-- Rockstar Editor
RegisterCommand('rockstareditor', function()
    OpenRockstarEditor()
end, false)


-- Initialize --
local function Init()
    AddTextEntry("recording_clip_info", string.format(Config.Localization.Info.Recording, "~INPUT_D138F64A~", "~INPUT_79E55105~"))
    AddTextEntry("action_replay_info", string.format(Config.Localization.Info.ActionReplay, "~INPUT_D138F64A~", "~INPUT_618BC690~"))

    if Config.AddChatSuggestion then
        TriggerEvent('chat:addSuggestion', '/record', Config.Localization.Chat.Start)
        TriggerEvent('chat:addSuggestion', '/actionreplay', Config.Localization.Chat.ActionReplay)
        TriggerEvent('chat:addSuggestion', '/cancelrecording', Config.Localization.Chat.Cancel)
        TriggerEvent('chat:addSuggestion', '/rockstareditor', Config.Localization.Chat.Editor)
    end
end

Init()
