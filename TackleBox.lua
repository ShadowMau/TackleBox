-- Author: ShadowMau
-- Last Updated: 10-24-2018
-- Version: 0.0.3
-- Requires: TackleBox.xml

-- See EOF for detailed notes

-- Initialize TackleBox Table
TackleBox = {}
TackleBox.name = "TackleBox"

-- Test to see of the addon that just loaded is our addon.  event and addonName are passed from the ESO API event manager
function AddonLoaded(event, addonName)
	if addonName == TackleBox.name then
		Initialize()
		-- ESO_API_CALL
		EVENT_MANAGER:UnregisterForEvent("TackleBox", EVENT_ADD_ON_LOADED)
	end
end

--Initiaze the rest of the addon settings and read in any saved variables
function Initialize()
	TackleBox.toggle = true -- Toggle for displaying message - should get weeded out as we go along.
	TackleBox.quotes = { -- A group of quotes to display as part of the initial testing and learning process
		"A leader is best when people barely know he exists, when his work is done, his aim fulfilled, they will say: we did it ourselves. —Lao Tzu",
		"Where there is no vision, the people perish. —Proverbs 29:18",
		"Anyone, anywhere, can make a positive difference. Mark Sanborn",
		"You manage things; you lead people. —Rear Admiral Grace Murray Hopper",
		"The first responsibility of a leader is to define reality. The last is to say thank you. In between, the leader is a servant. —Max DePree",
		"Leadership is the capacity to translate vision into reality. —Warren Bennis",
		"Lead me, follow me, or get out of my way. — General George Patton",
		"Before you are a leader, success is all about growing yourself. When you become a leader, success is all about growing others. —Jack Welch"
	}
	saveData = ZO_SavedVars:NewAccountWide("TackleBox_Data", 1)
end

-- Get a random elemnt from the array passed 
local function GetRandomElement(array)
	index = math.random(#array)
	return array[index]
end

local function OutputToChat(text)
	StartChatInput(text, CHAT_CHANNEL)
end

local function OutputToError(text)
	d(text)
end

function OutputToWindow(text)
	if TackleBox.toggle == true then
		d(text)
		-- XML_CALLS
		FlySwatterLabel:SetText(text) -- FlySwatterLabel is text label defined in TackleBox.xml
		FlySwatter:SetHidden(false) -- FlySwatter is the container defined in TackleBox.xml 
		
	else
		d("false")
		-- XML_CALLS
		FlySwatter:SetHidden(true)
		
	end
	TackleBox.toggle = not TackleBox.toggle -- Flips the toggle
end

function ProcessSlash(extra)
	local quote = GetRandomElement(TackleBox.quotes) -- Pull out a random quote
	if extra == "t" then
		OutputToError(quote)
	elseif extra == "test" then
		d("Processing Slash . . . ")
		OutputToWindow(quote)
	else
		OutputToChat(quote)
	end
end

-- ESO_API_CALL 
-- Register our slash command with the UI
SLASH_COMMANDS["/tb"] = ProcessSlash

-- ESO_API_CALL
-- When any addon loads, it triggers this event.  Check to see if this trigger is our addon
EVENT_MANAGER:RegisterForEvent(TackleBox.name, EVENT_ADD_ON_LOADED, AddonLoaded)

-- EOF Notes
--
-- Functions I Define
--
-- AddonLoaded(event, addonName) - Triggered when any addon loads, test to see if TackleBox was the one loaded
-- Initialize - Initializes the rest of the table and other TackleBox settings, loads saved variables
-- GetRandomElement(array) - Selects a randon element from the array and returns it 
-- OutputToChat(text) - Put the text into the entry line of the chat window, but does not press return
-- OutputToError(text) - Pass the text into the chat window as a diagnostic message
-- OutputToWindow(text) - Pass the text on to a window the pops up on the screen
-- ProcessSlash(extra) - Processes any slash commands used
--
-- ESO_API_CALLS
--
-- d(text) - Diagnostic and debugging tool that dumps info into the chat box that only you can see
-- StartChatInput(text, CHAT_CHANNEL) - Dump the text ready to be posed to the CHAT_CHANNEL but does not actually post
-- SLASH_COMMANDS - Set up our slash command
-- EVENT_MANAGER . . . EVENT_ADD_ON_LOADED - Register with ESO to trigger AddonLoaded function whenever an addon loads
--
-- LUA FUNCTIONS
--
-- math.random()
-- math.floor()
-- #array - Returns the number of elements in the array
--
-- XML_CALLS
--
-- Label.SetText(text) - Sets the label text to the string passed to it
-- Container.SetHidden(bolean) -- Tells XML if it should hide the container