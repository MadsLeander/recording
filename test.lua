-- Variables --
local isRecording = false
local actionReplay = false


-- Functions --
local function DisplayNotification(msg)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandThefeedPostTicker(false, false)
end

local function GiveRecTooltip(normal)
    local timeout = 10
    while not IsRecording() do
        Citizen.Wait(100)
        timeout = timeout - 1
        if timeout < 0 then
            print("GiveRecTooltip() timed out!")
            return
        end
    end

    local helpText = {}
    if normal then
        helpText = { "recording_clip_info_keyboard", "recording_clip_info_controller" }
    else
        helpText = { "replay_clip_info_keyboard", "replay_clip_info_controller" }
    end

    local startTime = GetGameTimer()
    while IsRecording() do
        Citizen.Wait(0)
        if GetGameTimer() - startTime < 5000 then
            if IsUsingKeyboard(1) then
                DisplayHelpTextThisFrame(helpText[1], false)
            elseif Config.UseControllerKeybinds then
                DisplayHelpTextThisFrame(helpText[2], false)
            end
        end
    end
end

local function StartRec()
    if not IsRecording() then
        isRecording = true
        StartRecording(1)
        GiveRecTooltip(true)
    elseif isRecording then
        DisplayNotification(Config.Localization.AlreadyRecording)
    elseif actionReplay then
        DisplayNotification(Config.Localization.AlreadyRecordingActionReplay)
        StopRecordingAndSaveClip()
    end
end

local function StopRec(save)
    if IsRecording() then
        if save then
            StopRecordingAndSaveClip()
        else
            StopRecordingAndDiscardClip()
            DisplayNotification(Config.Localization.Discard)
        end
        actionReplay = false
        isRecording = false
    elseif isRecording then
        DisplayNotification(Config.Localization.NotRecording)
    end
end

local function ToggleActionReplay()
    if not actionReplay then
        if not IsRecording() then
            actionReplay = true
            StartRecording(0)
            DisplayNotification(Config.Localization.StartActionReplay)
            GiveRecTooltip()
        else
            DisplayNotification(Config.Localization.ActionReplayRecWarning)
        end
    elseif isRecording then
        DisplayNotification(Config.Localization.ActionReplayRecWarning)
    else
        actionReplay = false
        StopRecordingAndDiscardClip()
        DisplayNotification(Config.Localization.StopActionReplay)
    end
end

local function OpenRockstarEditor()
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
end


-- Commands & Key Mapping --
-- Start
RegisterKeyMapping('startrec', Config.Localization.Start, 'keyboard', Config.KeyMapping.Start.Keyboard)
RegisterCommand('startrec', function()
	StartRec()
end, false)

-- Save Clip
RegisterKeyMapping('saverec', Config.Localization.Save, 'keyboard', Config.KeyMapping.Save.Keyboard)
RegisterCommand('saverec', function()
	StopRec(true)
end, false)

-- Discard
RegisterKeyMapping('discardrec', Config.Localization.DiscardKey, 'keyboard', Config.KeyMapping.Discard.Keyboard)
RegisterCommand('discardrec', function()
	StopRec(false)
end, false)

-- Action Replay
RegisterKeyMapping('actionreplay', Config.Localization.ActionReplay, 'keyboard', Config.KeyMapping.ActionReplay.Keyboard)
RegisterCommand('actionreplay', function()
	ToggleActionReplay()
end, false)

-- Rockstar Editor
RegisterCommand('rockstareditor', function()
	OpenRockstarEditor()
end, false)

-- Controller Key Mapping --
if Config.UseControllerKeybinds then
    -- Start
    RegisterKeyMapping('recording:start', Config.Localization.Start..Config.Localization.Controller, 'PAD_ANALOGBUTTON', Config.KeyMapping.Start.Controller)
    RegisterCommand('recording:start', function()
        StartRec()
    end, false)

    -- Save Clip
    RegisterKeyMapping('recording:saveclip', Config.Localization.Save..Config.Localization.Controller, 'PAD_ANALOGBUTTON', Config.KeyMapping.Save.Controller)
    RegisterCommand('recording:saveclip', function()
        StopRec(true)
    end, false)

    -- Discard
    RegisterKeyMapping('recording:discard', Config.Localization.DiscardKey..Config.Localization.Controller, 'PAD_ANALOGBUTTON', Config.KeyMapping.Discard.Controller)
    RegisterCommand('recording:discard', function()
        StopRec(false)
    end, false)

    RegisterKeyMapping('recording:actionreplay', Config.Localization.ActionReplay..Config.Localization.Controller, 'PAD_ANALOGBUTTON', Config.KeyMapping.ActionReplay.Controller)
    RegisterCommand('recording:actionreplay', function()
        StopRec(false)
    end, false)
end

-- Initialize --
local function Init()
    AddTextEntry("recording_clip_info_keyboard", string.format(Config.Localization.RecordingHelpText, "~INPUT_951A15C7~", "~INPUT_3AF45FDB~"))
    AddTextEntry("recording_clip_info_controller", string.format(Config.Localization.RecordingHelpText, "~INPUT_C94364B3~", "~INPUT_70BE9C91~"))
    AddTextEntry("replay_clip_info_keyboard", string.format(Config.Localization.ReplayHelpText, "~INPUT_951A15C7~"))
    AddTextEntry("replay_clip_info_controller", string.format(Config.Localization.ReplayHelpText, "~INPUT_C94364B3~"))

    if Config.AddChatSuggestion then
        TriggerEvent('chat:addSuggestion', '/startrec', Config.Localization.StartChatHelp)
        TriggerEvent('chat:addSuggestion', '/saverec', Config.Localization.SaveChatHelp)
        TriggerEvent('chat:addSuggestion', '/discardrec', Config.Localization.DiscardChatHelp)
        TriggerEvent('chat:addSuggestion', '/actionreplay', Config.Localization.ActionChatHelp)
        TriggerEvent('chat:addSuggestion', '/rockstareditor', Config.Localization.EditorChatHelp)
    end
end

Init()





-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         print(IsRecording())
--     end
-- end)




-- NOTES:
--[[

notify blinking red on some messages?

help text on commands

--]]



