Config = {}

-- Add suggestions for the commands in the default chat resource
Config.AddChatSuggestion = true

-- How long the tooltip should be visible in ms
Config.TooltipTimer = 6000

-- The defult key bindings, the players themselvs can change this in Settings>Key Bindings>Fivem
Config.KeyMapping = {
	Start = 'F1',
	ActionReplay = 'F2',
	Cancel = 'F3'
}

Config.Localization = {
	-- Info text that show up for the first 5 seconds when recording
	Info = {
		Recording = "Once you've recorded your clip, press %s to save the recording, or %s to discard it.",
		ActionReplay = "Action Replay is active. Press %s at any time to save a clip, or %s to disable action replay."
	},

	-- Descriptions in Settings>Key Bindings>Fivem
	KeyMapping = {
		Record = "(Rec) Start / Save Recording",
		ActionReplay = "(Rec) Toggle Action Replay",
		Cancel = "(Rec) Cancel Recording"
	},

	-- Chat help/suggestion text
	Chat = {
		Start = "Starts/stops the current recording",
		ActionReplay = "Toggles the action replay recording",
		Cancel = "Cancels the current recording",
		Editor = "Enter the Rockstar Editor. Note: This will make you leave your current session"
	},

	-- Notifications
	Notifications = {
		ActionReplaySaved = "The action replay clip was saved.",
		ClipSaved = "The clip was savedm",
		ActionReplayStop = "Action replay was turned off.", 
		ActionReplayStart = "Action replay is now active.",
		AlreadyRecording = "You are already recording, stop the recording before turning on action replay!",
		NotRecording = "You aren't recording anything!",
		Discarded = "The clip was discarded."
	}
}
