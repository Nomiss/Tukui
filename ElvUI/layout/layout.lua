local E, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

-- BUTTON SIZES
E.buttonsize = E.Scale(C["actionbar"].buttonsize)
E.buttonspacing = E.Scale(C["actionbar"].buttonspacing)
E.petbuttonsize = E.Scale(C["actionbar"].petbuttonsize)
E.buttonspacing = E.Scale(C["actionbar"].buttonspacing)

--BOTTOM DUMMY FRAME DOES NOTHING BUT HOLDS FRAME POSITIONS
local bottompanel = CreateFrame("Frame", "ElvuiBottomPanel", UIParent)
bottompanel:SetHeight(23)
bottompanel:SetWidth(UIParent:GetWidth() + (E.mult * 2))
bottompanel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -E.mult, -E.mult)
bottompanel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", E.mult, -E.mult)

local mini = CreateFrame("Frame", "ElvuiMinimap", Minimap)
E.CreatePanel(mini, E.Scale(144 + 4), E.Scale(144 + 4), "CENTER", Minimap, "CENTER", -0, 0)
mini:ClearAllPoints()
mini:SetPoint("TOPLEFT", E.Scale(-2), E.Scale(2))
mini:SetPoint("BOTTOMRIGHT", E.Scale(2), E.Scale(-2))
E.CreateShadow(ElvuiMinimap)
TukuiMinimap = ElvuiMinimap -- conversion

-- MINIMAP STAT FRAMES
if ElvuiMinimap then
	local minimapstatsleft = CreateFrame("Frame", "ElvuiMinimapStatsLeft", ElvuiMinimap)
	E.CreatePanel(minimapstatsleft, (ElvuiMinimap:GetWidth() / 2) - 2, 19, "TOPLEFT", ElvuiMinimap, "BOTTOMLEFT", 0, E.Scale(-3))

	local minimapstatsright = CreateFrame("Frame", "ElvuiMinimapStatsRight", ElvuiMinimap)
	E.CreatePanel(minimapstatsright, (ElvuiMinimap:GetWidth() / 2) -2, 19, "TOPRIGHT", ElvuiMinimap, "BOTTOMRIGHT", 0, E.Scale(-3))
	E.SetNormTexTemplate(ElvuiMinimapStatsLeft)
	E.SetNormTexTemplate(ElvuiMinimapStatsRight)
	E.CreateShadow(ElvuiMinimapStatsLeft)
	E.CreateShadow(ElvuiMinimapStatsRight)
	
	TukuiMinimapStatsLeft = ElvuiMinimapStatsLeft -- conversion
	TukuiMinimapStatsRight = ElvuiMinimapStatsRight -- conversion
end

-- MAIN ACTION BAR
local barbg = CreateFrame("Frame", "ElvuiActionBarBackground", UIParent)
if C["actionbar"].bottompetbar ~= true then
	E.CreatePanel(barbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
else
	E.CreatePanel(barbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, (E.buttonsize + (E.buttonspacing * 2)) + E.Scale(8))
end
barbg:SetWidth(((E.buttonsize * 12) + (E.buttonspacing * 13)))
barbg:SetFrameStrata("LOW")
barbg:SetHeight(E.buttonsize + (E.buttonspacing * 2))
E.CreateShadow(barbg)

if C["actionbar"].enable ~= true then
	barbg:SetAlpha(0)
end

--SPLIT BAR PANELS
local splitleft = CreateFrame("Frame", "ElvuiSplitActionBarLeftBackground", ElvuiActionBarBackground)
E.CreatePanel(splitleft, (E.buttonsize * 3) + (E.buttonspacing * 4), ElvuiActionBarBackground:GetHeight(), "RIGHT", ElvuiActionBarBackground, "LEFT", E.Scale(-4), 0)
splitleft:SetFrameLevel(ElvuiActionBarBackground:GetFrameLevel())
splitleft:SetFrameStrata(ElvuiActionBarBackground:GetFrameStrata())

local splitright = CreateFrame("Frame", "ElvuiSplitActionBarRightBackground", ElvuiActionBarBackground)
E.CreatePanel(splitright, (E.buttonsize * 3) + (E.buttonspacing * 4), ElvuiActionBarBackground:GetHeight(), "LEFT", ElvuiActionBarBackground, "RIGHT", E.Scale(4), 0)
splitright:SetFrameLevel(ElvuiActionBarBackground:GetFrameLevel())
splitright:SetFrameStrata(ElvuiActionBarBackground:GetFrameStrata())

E.CreateShadow(splitleft)
E.CreateShadow(splitright)


-- RIGHT BAR
if C["actionbar"].enable == true then
	local barbgr = CreateFrame("Frame", "ElvuiActionBarBackgroundRight", ElvuiActionBarBackground)
	E.CreatePanel(barbgr, 1, (E.buttonsize * 12) + (E.buttonspacing * 13), "RIGHT", UIParent, "RIGHT", E.Scale(-4), E.Scale(-8))
	barbgr:Hide()
	E.AnimGroup(ElvuiActionBarBackgroundRight, E.Scale(350), 0, 0.4)

	local petbg = CreateFrame("Frame", "ElvuiPetActionBarBackground", UIParent)
	if C["actionbar"].bottompetbar ~= true then
		E.CreatePanel(petbg, E.petbuttonsize + (E.buttonspacing * 2), (E.petbuttonsize * 10) + (E.buttonspacing * 11), "RIGHT", UIParent, "RIGHT", E.Scale(-6), E.Scale(-13.5))
	else
		E.CreatePanel(petbg, (E.petbuttonsize * 10) + (E.buttonspacing * 11), E.petbuttonsize + (E.buttonspacing * 2), "BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
	end
	
	local ltpetbg = CreateFrame("Frame", "ElvuiLineToPetActionBarBackground", petbg)
	if C["actionbar"].bottompetbar ~= true then
		E.CreatePanel(ltpetbg, 30, 265, "LEFT", petbg, "RIGHT", 0, 0)
	else
		E.CreatePanel(ltpetbg, 265, 30, "BOTTOM", petbg, "TOP", 0, 0)
	end
	
	ltpetbg:SetScript("OnShow", function(self)
		self:SetFrameStrata("BACKGROUND")
		self:SetFrameLevel(0)
	end)

	
	E.CreateShadow(barbgr)
	E.CreateShadow(petbg)
end

-- VEHICLE BAR
if C["actionbar"].enable == true then
	local vbarbg = CreateFrame("Frame", "ElvuiVehicleBarBackground", UIParent)
	E.CreatePanel(vbarbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
	vbarbg:SetWidth(((E.buttonsize * 11) + (E.buttonspacing * 12))*1.2)
	vbarbg:SetHeight((E.buttonsize + (E.buttonspacing * 2))*1.2)
	E.CreateShadow(vbarbg)
end

-- CHAT BACKGROUND LEFT (MOVES)
local chatlbgdummy = CreateFrame("Frame", "ChatLBackground", UIParent)
chatlbgdummy:SetWidth(C["chat"].chatwidth)
chatlbgdummy:SetHeight(C["chat"].chatheight+6)
chatlbgdummy:SetPoint("BOTTOMLEFT", ElvuiBottomPanel, "TOPLEFT", E.Scale(4),  E.Scale(7))

-- CHAT BACKGROUND LEFT (DOESN'T MOVE THIS IS WHAT WE ATTACH FRAMES TO)
local chatlbgdummy2 = CreateFrame("Frame", "ChatLBackground2", UIParent)
chatlbgdummy2:SetWidth(C["chat"].chatwidth)
chatlbgdummy2:SetHeight(C["chat"].chatheight+6)
chatlbgdummy2:SetPoint("BOTTOMLEFT", ElvuiBottomPanel, "TOPLEFT", E.Scale(4),  E.Scale(7))

-- CHAT BACKGROUND RIGHT (MOVES)
local chatrbgdummy = CreateFrame("Frame", "ChatRBackground", UIParent)
chatrbgdummy:SetWidth(C["chat"].chatwidth)
chatrbgdummy:SetHeight(C["chat"].chatheight+6)
chatrbgdummy:SetPoint("BOTTOMRIGHT", ElvuiBottomPanel, "TOPRIGHT", E.Scale(-4),  E.Scale(7))

-- CHAT BACKGROUND RIGHT (DOESN'T MOVE THIS IS WHAT WE ATTACH FRAMES TO)
local chatrbgdummy2 = CreateFrame("Frame", "ChatRBackground2", UIParent)
chatrbgdummy2:SetWidth(C["chat"].chatwidth)
chatrbgdummy2:SetHeight(C["chat"].chatheight+6)
chatrbgdummy2:SetPoint("BOTTOMRIGHT", ElvuiBottomPanel, "TOPRIGHT", E.Scale(-4),  E.Scale(7))

E.AnimGroup(ChatLBackground, E.Scale(-375), 0, 0.4)
E.AnimGroup(ChatRBackground, E.Scale(375), 0, 0.4)

E.ChatRightShown = false
if C["chat"].showbackdrop == true then
	local chatlbg = CreateFrame("Frame", nil, ChatLBackground)
	E.SetTransparentTemplate(chatlbg)
	chatlbg:SetAllPoints(chatlbgdummy)
	chatlbg:SetFrameStrata("BACKGROUND")
	
	local chatltbg = CreateFrame("Frame", nil, chatlbg)
	E.SetNormTexTemplate(chatltbg)
	chatltbg:SetPoint("BOTTOMLEFT", chatlbg, "TOPLEFT", 0, E.Scale(3))
	chatltbg:SetPoint("BOTTOMRIGHT", chatlbg, "TOPRIGHT", E.Scale(-24), E.Scale(3))
	chatltbg:SetHeight(E.Scale(22))
	chatltbg:SetFrameStrata("BACKGROUND")
	
	E.CreateShadow(chatlbg)
	E.CreateShadow(chatltbg)
end

if C["chat"].showbackdrop == true then
	local chatrbg = CreateFrame("Frame", "ChatRBG", ChatRBackground)
	chatrbg:SetAllPoints(chatrbgdummy)
	E.SetTransparentTemplate(chatrbg)
	chatrbg:SetFrameStrata("BACKGROUND")
	chatrbg:SetBackdropColor(unpack(C["media"].backdropfadecolor))
	chatrbg:SetAlpha(0)

	local chatrtbg = CreateFrame("Frame", nil, chatrbg)
	E.SetNormTexTemplate(chatrtbg)
	chatrtbg:SetPoint("BOTTOMLEFT", chatrbg, "TOPLEFT", 0, E.Scale(3))
	chatrtbg:SetPoint("BOTTOMRIGHT", chatrbg, "TOPRIGHT", E.Scale(-24), E.Scale(3))
	chatrtbg:SetHeight(E.Scale(22))
	chatrtbg:SetFrameStrata("BACKGROUND")
	E.CreateShadow(chatrbg)
	E.CreateShadow(chatrtbg)
end

--INFO LEFT
local infoleft = CreateFrame("Frame", "ElvuiInfoLeft", UIParent)
infoleft:SetFrameLevel(2)
E.SetNormTexTemplate(infoleft)
E.CreateShadow(infoleft)
infoleft:SetPoint("TOPLEFT", chatlbgdummy2, "BOTTOMLEFT", E.Scale(17), E.Scale(-4))
infoleft:SetPoint("BOTTOMRIGHT", chatlbgdummy2, "BOTTOMRIGHT", E.Scale(-17), E.Scale(-26))

	--INFOLEFT L BUTTON
	local infoleftLbutton = CreateFrame("Button", "ElvuiInfoLeftLButton", ElvuiInfoLeft)
	E.SetNormTexTemplate(infoleftLbutton)
	infoleftLbutton:SetPoint("TOPRIGHT", infoleft, "TOPLEFT", E.Scale(-2), 0)
	infoleftLbutton:SetPoint("BOTTOMLEFT", chatlbgdummy2, "BOTTOMLEFT", 0, E.Scale(-26))

	--INFOLEFT R BUTTON
	local infoleftRbutton = CreateFrame("Button", "ElvuiInfoLeftRButton", ElvuiInfoLeft)
	E.SetNormTexTemplate(infoleftRbutton)
	infoleftRbutton:SetPoint("TOPLEFT", infoleft, "TOPRIGHT", E.Scale(2), 0)
	infoleftRbutton:SetPoint("BOTTOMRIGHT", chatlbgdummy2, "BOTTOMRIGHT", 0, E.Scale(-26))
	
	infoleft.shadow:ClearAllPoints()
	infoleft.shadow:SetPoint("TOPLEFT", infoleftLbutton, "TOPLEFT", E.Scale(-4), E.Scale(4))
	infoleft.shadow:SetPoint("BOTTOMRIGHT", infoleftRbutton, "BOTTOMRIGHT", E.Scale(4), E.Scale(-4))

	infoleftLbutton.Text = E.SetFontString(ElvuiInfoLeftLButton, C["media"].font, C["general"].fontscale, "THINOUTLINE")
	infoleftLbutton.Text:SetText("<")
	infoleftLbutton.Text:SetPoint("CENTER")

	infoleftRbutton.Text = E.SetFontString(ElvuiInfoLeftRButton, C["media"].font, C["general"].fontscale, "THINOUTLINE")
	infoleftRbutton.Text:SetText("L")
	infoleftRbutton.Text:SetPoint("CENTER")

--INFO RIGHT
local inforight = CreateFrame("Frame", "ElvuiInfoRight", UIParent)
E.SetNormTexTemplate(inforight)
infoleft:SetFrameLevel(2)
E.CreateShadow(inforight)
inforight:SetPoint("TOPLEFT", chatrbgdummy2, "BOTTOMLEFT", E.Scale(17), E.Scale(-4))
inforight:SetPoint("BOTTOMRIGHT", chatrbgdummy2, "BOTTOMRIGHT", E.Scale(-17), E.Scale(-26))

	--INFORIGHT L BUTTON
	local inforightLbutton = CreateFrame("Button", "ElvuiInfoRightLButton", ElvuiInfoRight)
	E.SetNormTexTemplate(inforightLbutton)
	inforightLbutton:SetPoint("TOPRIGHT", inforight, "TOPLEFT", E.Scale(-2), 0)
	inforightLbutton:SetPoint("BOTTOMLEFT", chatrbgdummy2, "BOTTOMLEFT", 0, E.Scale(-26))

	--INFORIGHT R BUTTON
	local inforightRbutton = CreateFrame("Button", "ElvuiInfoRightRButton", ElvuiInfoRight)
	E.SetNormTexTemplate(inforightRbutton)
	inforightRbutton:SetPoint("TOPLEFT", inforight, "TOPRIGHT", E.Scale(2), 0)
	inforightRbutton:SetPoint("BOTTOMRIGHT", chatrbgdummy2, "BOTTOMRIGHT", 0, E.Scale(-26))
	
	inforight.shadow:ClearAllPoints()
	inforight.shadow:SetPoint("TOPLEFT", inforightLbutton, "TOPLEFT", E.Scale(-4), E.Scale(4))
	inforight.shadow:SetPoint("BOTTOMRIGHT", inforightRbutton, "BOTTOMRIGHT", E.Scale(4), E.Scale(-4))

	inforightLbutton.Text = E.SetFontString(ElvuiInfoRightLButton, C["media"].font, C["general"].fontscale, "THINOUTLINE")
	inforightLbutton.Text:SetText("R")
	inforightLbutton.Text:SetPoint("CENTER")

	inforightRbutton.Text = E.SetFontString(ElvuiInfoRightRButton, C["media"].font, C["general"].fontscale, "THINOUTLINE")
	inforightRbutton.Text:SetText(">")
	inforightRbutton.Text:SetPoint("CENTER")
	
TukuiInfoLeft = ElvuiInfoLeft -- conversion
TukuiInfoRight = ElvuiInfoRight -- conversion	

-- BATTLEGROUND STATS FRAME
local shownbg = true
if C["datatext"].battleground == true then
	infoleft:SetScript("OnMouseDown", function(self) 
		if shownbg == true then 
			E.SlideOut(ElvuiInfoBattleGroundL) 
			E.SlideOut(ElvuiInfoBattleGroundR) 
			shownbg = false 
		else 
			E.SlideIn(ElvuiInfoBattleGroundL) 
			E.SlideIn(ElvuiInfoBattleGroundR) 
			shownbg = true 
		end 
	end)
	infoleft:RegisterEvent("PLAYER_ENTERING_WORLD")
	infoleft:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	infoleft:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
		local inInstance, instanceType = IsInInstance()
		if (inInstance and (instanceType == "pvp")) then
			if not InCombatLockdown() then
				infoleft:EnableMouse(true)
				ElvuiInfoBattleGroundL:Show()
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		else
			if not InCombatLockdown() then
				infoleft:EnableMouse(false)
				ElvuiInfoBattleGroundL:Hide()
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		end
		shownbg = true
	end)

	inforight:SetScript("OnMouseDown", function(self) 
		if shownbg == true then 
			E.SlideOut(ElvuiInfoBattleGroundL) 
			E.SlideOut(ElvuiInfoBattleGroundR) 
			shownbg = false 
		else 
			E.SlideIn(ElvuiInfoBattleGroundL) 
			E.SlideIn(ElvuiInfoBattleGroundR) 
			shownbg = true 
		end 
	end)
	inforight:RegisterEvent("PLAYER_ENTERING_WORLD")
	inforight:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	inforight:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
		local inInstance, instanceType = IsInInstance()
		if (inInstance and (instanceType == "pvp")) then
			if not InCombatLockdown() then
				inforight:EnableMouse(true)
				ElvuiInfoBattleGroundR:Show()
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		else
			if not InCombatLockdown() then
				inforight:EnableMouse(false)
				ElvuiInfoBattleGroundR:Hide()
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		end
		shownbg = true
	end)


	local bgframeL = CreateFrame("Frame", "ElvuiInfoBattleGroundL", UIParent)
	E.CreatePanel(bgframeL, 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframeL:SetAllPoints(ElvuiInfoLeft)
	bgframeL:SetFrameLevel(ElvuiInfoLeft:GetFrameLevel() + 1)
	E.SetNormTexTemplate(bgframeL)
	bgframeL:SetFrameStrata("HIGH")
	bgframeL:SetScript("OnEnter", function(self)
		local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
			if name then
				if name == E.myname then
					local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
					local classcolor = ("|cff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
					GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
					GameTooltip:ClearLines()
					GameTooltip:AddDoubleLine(L.datatext_ttstatsfor, classcolor..name.."|r")
					GameTooltip:AddLine' '
					--Add extra statistics to watch based on what BG you are in.
					if GetRealZoneText() == "Arathi Basin" then --
						GameTooltip:AddDoubleLine(L.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Warsong Gulch" then --
						GameTooltip:AddDoubleLine(L.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_flagsreturned,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Eye of the Storm" then --
						GameTooltip:AddDoubleLine(L.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
					elseif GetRealZoneText() == "Alterac Valley" then
						GameTooltip:AddDoubleLine(L.datatext_graveyardsassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_graveyardsdefended,GetBattlefieldStatData(i, 2),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_towersassaulted,GetBattlefieldStatData(i, 3),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_towersdefended,GetBattlefieldStatData(i, 4),1,1,1)
					elseif GetRealZoneText() == "Strand of the Ancients" then
						GameTooltip:AddDoubleLine(L.datatext_demolishersdestroyed,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_gatesdestroyed,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Isle of Conquest" then
						GameTooltip:AddDoubleLine(L.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					end			
					GameTooltip:Show()
				end
			end
		end
	end) 
	
	local bgframeR = CreateFrame("Frame", "ElvuiInfoBattleGroundR", UIParent)
	E.CreatePanel(bgframeR, 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	E.SetNormTexTemplate(bgframeR)
	bgframeR:SetAllPoints(ElvuiInfoRight)
	bgframeR:SetFrameLevel(ElvuiInfoRight:GetFrameLevel() + 1)
	bgframeR:SetFrameStrata("HIGH")
	bgframeR:SetScript("OnEnter", function(self)
		local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
			if name then
				if name == E.myname then
					local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
					local classcolor = ("|cff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
					GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
					GameTooltip:ClearLines()
					GameTooltip:AddDoubleLine(L.datatext_ttstatsfor, classcolor..name.."|r")
					GameTooltip:AddLine' '
					--Add extra statistics to watch based on what BG you are in.
					if GetRealZoneText() == "Arathi Basin" then --
						GameTooltip:AddDoubleLine(L.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Warsong Gulch" then --
						GameTooltip:AddDoubleLine(L.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_flagsreturned,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Eye of the Storm" then --
						GameTooltip:AddDoubleLine(L.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
					elseif GetRealZoneText() == "Alterac Valley" then
						GameTooltip:AddDoubleLine(L.datatext_graveyardsassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_graveyardsdefended,GetBattlefieldStatData(i, 2),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_towersassaulted,GetBattlefieldStatData(i, 3),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_towersdefended,GetBattlefieldStatData(i, 4),1,1,1)
					elseif GetRealZoneText() == "Strand of the Ancients" then
						GameTooltip:AddDoubleLine(L.datatext_demolishersdestroyed,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_gatesdestroyed,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Isle of Conquest" then
						GameTooltip:AddDoubleLine(L.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(L.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					end			
					GameTooltip:Show()
				end
			end
		end
	end)
	
	E.AnimGroup(ElvuiInfoBattleGroundL, 0, E.Scale(-150), 0.4)
	E.AnimGroup(ElvuiInfoBattleGroundR, 0, E.Scale(-150), 0.4)

	bgframeL:SetScript("OnMouseDown", function(self) 
		if shownbg == true then 
			E.SlideOut(ElvuiInfoBattleGroundL) 
			E.SlideOut(ElvuiInfoBattleGroundR) 
			shownbg = false 
		else 
			E.SlideIn(ElvuiInfoBattleGroundL) 
			E.SlideIn(ElvuiInfoBattleGroundR) 
			shownbg = true 
		end 
	end)
	bgframeL:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	bgframeL:RegisterEvent("PLAYER_ENTERING_WORLD")
	bgframeL:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	bgframeL:SetScript("OnEvent", function(self, event)
		local inInstance, instanceType = IsInInstance()
		if (inInstance and (instanceType == "pvp")) then
			if not InCombatLockdown() then
				ElvuiInfoBattleGroundL:Show()
				ElvuiInfoLeft:EnableMouse(true)
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		else
			if not InCombatLockdown() then
				ElvuiInfoBattleGroundL:Hide()
				ElvuiInfoLeft:EnableMouse(false)
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		end
		shownbg = true
	end)
	
	bgframeR:SetScript("OnMouseDown", function(self) 
		if shownbg == true then 
			E.SlideOut(ElvuiInfoBattleGroundL) 
			E.SlideOut(ElvuiInfoBattleGroundR) 
			shownbg = false 
		else 
			E.SlideIn(ElvuiInfoBattleGroundL) 
			E.SlideIn(ElvuiInfoBattleGroundR) 
			shownbg = true 
		end 
	end)
	bgframeR:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	bgframeR:RegisterEvent("PLAYER_ENTERING_WORLD")
	bgframeR:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	bgframeR:SetScript("OnEvent", function(self, event)
		local inInstance, instanceType = IsInInstance()
		if (inInstance and (instanceType == "pvp")) then
			if not InCombatLockdown() then
				ElvuiInfoBattleGroundR:Show()
				ElvuiInfoRight:EnableMouse(true)
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		else
			if not InCombatLockdown() then
				ElvuiInfoBattleGroundR:Hide()
				ElvuiInfoRight:EnableMouse(false)
			else
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		end
		shownbg = true
	end)
end

--Mover buttons uses this
function E.PositionAllPanels()
	ElvuiActionBarBackground:ClearAllPoints()
	ElvuiPetActionBarBackground:ClearAllPoints()
	ElvuiLineToPetActionBarBackground:ClearAllPoints()
	
	if C["actionbar"].bottompetbar ~= true then
		ElvuiActionBarBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
		if E["actionbar"].rightbars > 0 then
			ElvuiPetActionBarBackground:SetPoint("RIGHT", ElvuiActionBarBackgroundRight, "LEFT", E.Scale(-6), 0)
		else
			ElvuiPetActionBarBackground:SetPoint("RIGHT", UIParent, "RIGHT", E.Scale(-6), E.Scale(-13.5))
		end
		ElvuiPetActionBarBackground:SetSize(E.petbuttonsize + (E.buttonspacing * 2), (E.petbuttonsize * 10) + (E.buttonspacing * 11))
		ElvuiLineToPetActionBarBackground:SetSize(30, 265)
		ElvuiLineToPetActionBarBackground:SetPoint("LEFT", ElvuiPetActionBarBackground, "RIGHT", 0, 0)
	else
		ElvuiActionBarBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, (E.buttonsize + (E.buttonspacing * 2)) + E.Scale(8))	
		ElvuiPetActionBarBackground:SetSize((E.petbuttonsize * 10) + (E.buttonspacing * 11), E.petbuttonsize + (E.buttonspacing * 2))
		ElvuiPetActionBarBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
		ElvuiLineToPetActionBarBackground:SetSize(265, 30)
		ElvuiLineToPetActionBarBackground:SetPoint("BOTTOM", ElvuiPetActionBarBackground, "TOP", 0, 0)
	end
	
	if E["actionbar"].bottomrows == 3 then
		ElvuiActionBarBackground:SetHeight((E.buttonsize * 3) + (E.buttonspacing * 4))
	elseif E["actionbar"].bottomrows == 2 then
		ElvuiActionBarBackground:SetHeight((E.buttonsize * 2) + (E.buttonspacing * 3))
	else
		ElvuiActionBarBackground:SetHeight(E.buttonsize + (E.buttonspacing * 2))
	end
	
	--SplitBar
	if E["actionbar"].splitbar == true then
		if E["actionbar"].bottomrows == 3 then
			ElvuiSplitActionBarLeftBackground:SetWidth((E.buttonsize * 4) + (E.buttonspacing * 5))
			ElvuiSplitActionBarRightBackground:SetWidth((E.buttonsize * 4) + (E.buttonspacing * 5))
		else
			ElvuiSplitActionBarLeftBackground:SetWidth((E.buttonsize * 3) + (E.buttonspacing * 4))
			ElvuiSplitActionBarRightBackground:SetWidth((E.buttonsize * 3) + (E.buttonspacing * 4))	
		end
		ElvuiSplitActionBarLeftBackground:Show()
		ElvuiSplitActionBarRightBackground:Show()
		ElvuiSplitActionBarLeftBackground:SetHeight(ElvuiActionBarBackground:GetHeight())
		ElvuiSplitActionBarRightBackground:SetHeight(ElvuiActionBarBackground:GetHeight())
	else
		ElvuiSplitActionBarLeftBackground:Hide()
		ElvuiSplitActionBarRightBackground:Hide()	
	end
	
	--RightBar
	ElvuiActionBarBackgroundRight:Show()
	if E["actionbar"].rightbars == 1 then
		ElvuiActionBarBackgroundRight:SetWidth(E.buttonsize + (E.buttonspacing * 2))
	elseif E["actionbar"].rightbars == 2 then
		ElvuiActionBarBackgroundRight:SetWidth((E.buttonsize * 2) + (E.buttonspacing * 3))
	elseif E["actionbar"].rightbars == 3 then
		ElvuiActionBarBackgroundRight:SetWidth((E.buttonsize * 3) + (E.buttonspacing * 4))
	else
		ElvuiActionBarBackgroundRight:Hide()
	end	
end

--Fixes chat windows not displaying
ChatLBackground.anim_o:HookScript("OnFinished", function()
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local point = GetChatWindowSavedPosition(id)
		local _, _, _, _, _, _, _, _, docked, _ = GetChatWindowInfo(id)
		chat:SetParent(tab)
	end
end)

ChatLBackground.anim_o:HookScript("OnPlay", function()
	if E.ChatLIn == true then
		for i = 1, NUM_CHAT_WINDOWS do
			local chat = _G[format("ChatFrame%s", i)]
			local tab = _G[format("ChatFrame%sTab", i)]
			chat:SetParent(tab)
		end		
	end
end)

ChatLBackground.anim:HookScript("OnFinished", function()
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local point = GetChatWindowSavedPosition(id)
		local _, _, _, _, _, _, _, _, docked, _ = GetChatWindowInfo(id)
		chat:SetParent(UIParent)
		
		if C["chat"].rightchat == true then
			ChatFrame3:SetParent(ChatFrame3Tab)
		end
	end
	ElvuiInfoLeft.shadow:SetBackdropBorderColor(0,0,0,1)
	ElvuiInfoLeft:SetScript("OnUpdate", function() end)
	E.StopFlash(ElvuiInfoLeft.shadow)
end)

if C["chat"].rightchat == true then
	ChatRBackground.anim_o:HookScript("OnPlay", function()
		ChatFrame3:SetParent(ChatFrame3Tab)
		ChatFrame3:SetFrameStrata("LOW")
	end)

	ChatRBackground.anim:HookScript("OnFinished", function()
		ChatFrame3:SetParent(UIParent)
		ChatFrame3:SetFrameStrata("LOW")
		ElvuiInfoRight.shadow:SetBackdropBorderColor(0,0,0,1)
		ElvuiInfoRight:SetScript("OnUpdate", function() end)
		E.StopFlash(ElvuiInfoRight.shadow)
	end)
end

--Setup Button Scripts
infoleftLbutton:SetScript("OnMouseDown", function(self, btn)
	if btn == "RightButton" then
		if E.ChatLIn == true then
			for i = 1, NUM_CHAT_WINDOWS do
				local chat = _G[format("ChatFrame%s", i)]
				local tab = _G[format("ChatFrame%sTab", i)]
				chat:SetParent(tab)
			end
			E.ToggleSlideChatR()
			E.ToggleSlideChatL()
		else
			E.ToggleSlideChatR()
			E.ToggleSlideChatL()
		end	
	else
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
end)

inforightRbutton:SetScript("OnMouseDown", function(self, btn)
	if C["chat"].rightchat ~= true then self:EnableMouse(false) return end
	if btn == "RightButton" then
		E.ToggleSlideChatR()
		E.ToggleSlideChatL()
	else
		E.ToggleSlideChatR()
	end
end)

--Toggle UI lock button
ElvuiInfoLeftRButton:SetScript("OnMouseDown", function(self)
	if InCombatLockdown() then return end
		
	E.ToggleMovers()
	
	if C["actionbar"].enable == true then
		E.ToggleABLock()
	end

	if oUF then
		E.MoveUF()
	end	
	
	if ElvuiInfoLeftRButton.hovered == true then
		local locked = false
		GameTooltip:ClearLines()
		for name, _ in pairs(E.CreatedMovers) do
			if _G[name]:IsShown() then
				locked = true
			else
				locked = false
			end
		end	
		
		if locked ~= true then
			GameTooltip:AddLine(UNLOCK.." "..BUG_CATEGORY5,1,1,1)
		else
			GameTooltip:AddLine(LOCK.." "..BUG_CATEGORY5,unpack(C["media"].valuecolor))
		end
	end
end)

ElvuiInfoLeftRButton:SetScript("OnEnter", function(self)
	ElvuiInfoLeftRButton.hovered = true
	if InCombatLockdown() then return end
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, E.Scale(6));
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, E.mult)
	GameTooltip:ClearLines()
	
	local locked = false
	for name, _ in pairs(E.CreatedMovers) do
		if _G[name]:IsShown() then
			locked = true
			break
		else
			locked = false
		end
	end	
	
	if locked ~= true then
		GameTooltip:AddLine(UNLOCK.." "..BUG_CATEGORY5,1,1,1)
	else
		GameTooltip:AddLine(LOCK.." "..BUG_CATEGORY5,unpack(C["media"].valuecolor))
	end
	GameTooltip:Show()
end)

ElvuiInfoLeftRButton:SetScript("OnLeave", function(self)
	ElvuiInfoLeftRButton.hovered = false
	GameTooltip:Hide()
end)