
local E, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

------------------------------------------------------------------------
-- Chat Animation Functions
------------------------------------------------------------------------
E.ToggleSlideChatL = function()
	if E.ChatLIn == true then
		for i = 1, NUM_CHAT_WINDOWS do
			local chat = _G[format("ChatFrame%s", i)]
			local tab = _G[format("ChatFrame%sTab", i)]
			chat:SetParent(tab)
		end
		E.SlideOut(ChatLBackground)	
		E.ChatLIn = false
		ElvuiInfoLeftLButton.text:SetTextColor(unpack(C["media"].valuecolor))
	else
		E.SlideIn(ChatLBackground)
		E.ChatLIn = true
		ElvuiInfoLeftLButton.text:SetTextColor(1,1,1,1)
	end
end

E.ToggleSlideChatR = function()
	if E.RightChat ~= true then return end
	if E.ChatRIn == true then
		E.SlideOut(ChatRBackground)	
		if IsAddOnLoaded("DXE") and DXEAlertsTopStackAnchor and C["skin"].hookdxeright == true and C["chat"].showbackdrop == true then
			DXEAlertsTopStackAnchor:ClearAllPoints()
			DXEAlertsTopStackAnchor:SetPoint("BOTTOM", ChatRBackground2, "TOP", 13, -5)
		end
		E.ChatRIn = false
		E.ChatRightShown = false
		ElvuiInfoRightRButton.text:SetTextColor(unpack(C["media"].valuecolor))
	else
		E.SlideIn(ChatRBackground)
		if IsAddOnLoaded("DXE") and DXEAlertsTopStackAnchor and C["skin"].hookdxeright == true and C["chat"].showbackdrop == true then
			DXEAlertsTopStackAnchor:ClearAllPoints()
			DXEAlertsTopStackAnchor:SetPoint("BOTTOM", ChatRBackground2, "TOP", 13, 18)
		end
		E.ChatRIn = true
		E.ChatRightShown = true
		ElvuiInfoRightRButton.text:SetTextColor(1,1,1,1)
	end
end

--Bindings For Chat Sliders
function ChatLeft_HotkeyPressed(keystate)
	if keystate == "up" then return end
	if E.ChatLIn == true then
		for i = 1, NUM_CHAT_WINDOWS do
			local chat = _G[format("ChatFrame%s", i)]
			local tab = _G[format("ChatFrame%sTab", i)]
			chat:SetParent(tab)
		end
		E.ToggleSlideChatL()
	else
		E.ToggleSlideChatL()
	end		
end

function ChatRight_HotkeyPressed(keystate)
	if keystate == "up" then return end
	E.ToggleSlideChatR()		
end

function ChatBoth_HotkeyPressed(keystate)
	if keystate == "up" then return end
	if E.ChatLIn == true then
		E.ToggleSlideChatR()
		E.ToggleSlideChatL()
	else
		E.ToggleSlideChatR()
		E.ToggleSlideChatL()
	end
end