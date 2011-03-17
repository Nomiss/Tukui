local ElvuiConfig = LibStub("AceAddon-3.0"):NewAddon("ElvuiConfig", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ElvuiConfig", false)
local LSM = LibStub("LibSharedMedia-3.0")
local db
local defaults

function ElvuiConfig:LoadDefaults()
	local _, C, _, _ = unpack(ElvUI)
	--Defaults
	defaults = {
		profile = {
			general = C["general"],
			media = C["media"],
			nameplate = C["nameplate"],
			skin = C["skin"],
			unitframes = C["unitframes"],
			raidframes = C["raidframes"],
		},
	}
end	

function ElvuiConfig:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN")
	
	ElvuiConfig:RegisterChatCommand("ec", "ShowConfig")
	ElvuiConfig:RegisterChatCommand("elvui", "ShowConfig")
	
	self.OnInitialize = nil
end

function ElvuiConfig:ShowConfig(arg)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.ElvuiConfig)
end

function ElvuiConfig:PLAYER_LOGIN()
	self:LoadDefaults()

	-- Create savedvariables
	self.db = LibStub("AceDB-3.0"):New("ElvConfig", defaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	
	self:SetupOptions()
end

function ElvuiConfig:OnProfileChanged(event, database, newProfileKey)
	StaticPopup_Show("RELOAD_UI")
end

function ElvuiConfig:SetupOptions()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("ElvuiConfig", self.GenerateOptions)
	
	--Create Profiles Table
	self.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ElvProfiles", self.profileOptions)
	
	-- The ordering here matters, it determines the order in the Blizzard Interface Options
	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrames = {}
	self.optionsFrames.ElvuiConfig = ACD3:AddToBlizOptions("ElvuiConfig", "ElvUI", nil, "general")
	self.optionsFrames.Media = ACD3:AddToBlizOptions("ElvuiConfig", L["Media"], "ElvUI", "media")
	self.optionsFrames.Nameplates = ACD3:AddToBlizOptions("ElvuiConfig", L["Nameplates"], "ElvUI", "nameplate")
	self.optionsFrames.Unitframes = ACD3:AddToBlizOptions("ElvuiConfig", L["Unitframes"], "ElvUI", "unitframes")
	self.optionsFrames.Raidframes = ACD3:AddToBlizOptions("ElvuiConfig", L["Raidframes"], "ElvUI", "raidframes")
	self.optionsFrames.Skins = ACD3:AddToBlizOptions("ElvuiConfig", L["Addon Skins"], "ElvUI", "skin")
	self.optionsFrames.Profiles = ACD3:AddToBlizOptions("ElvProfiles", L["Profiles"], "ElvUI")
	self.SetupOptions = nil
end

function ElvuiConfig.GenerateOptions()
	if ElvuiConfig.noconfig then assert(false, ElvuiConfig.noconfig) end
	if not ElvuiConfig.Options then
		ElvuiConfig.GenerateOptionsInternal()
		ElvuiConfig.GenerateOptionsInternal = nil
		moduleOptions = nil
	end
	return ElvuiConfig.Options
end

function ElvuiConfig.GenerateOptionsInternal()
	local E, C, _, DB = unpack(ElvUI)
	
	ElvuiConfig.Options = {
		type = "group",
		name = "ElvUI",
		args = {
			general = {
				order = 1,
				type = "group",
				name = L["General Settings"],
				desc = L["General Settings"],
				get = function(info) return db.general[ info[#info] ] end,
				set = function(info, value) db.general[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["ELVUI_DESC"],
					},
					autoscale = {
						order = 2,
						name = L["Auto Scale"],
						desc = L["Automatically scale the User Interface based on your screen resolution"],
						type = "toggle",
					},					
					uiscale = {
						order = 3,
						name = L["Scale"],
						desc = L["Controls the scaling of the entire User Interface"],
						disabled = function(info) return db.general.autoscale end,
						type = "range",
						min = 0.64, max = 1, step = 0.01,
						isPercent = true,
					},
					multisampleprotect = {
						order = 4,
						name = L["Multisample Protection"],
						desc = L["Force the Blizzard Multisample Option to be set to 1x. WARNING: Turning this off will lead to blurry borders"],
						type = "toggle",
					},
					classcolortheme = {
						order = 5,
						name = L["Class Color Theme"],
						desc = L["Style all frame borders to be your class color, color unitframes to class color"],
						type = "toggle",
					},
					fontscale = {
						order = 6,
						name = L["Font Scale"],
						desc = L["Set the font scale for everything in UI. Note: This doesn't effect somethings that have their own seperate options (UnitFrame Font, Datatext Font, ect..)"],
						type = "range",
						min = 9, max = 15, step = 1,
					},
					resolutionoverride = {
						order = 7,
						name = L["Resolution Override"],
						desc = L["Set a resolution version to use. By default any screensize > 1440 is considered a High resolution. This effects actionbar/unitframe layouts. If set to None, then it will be automatically determined by your screen size"],
						type = "select",
						values = {
							["NONE"] = L["None"],
							["Low"] = L["Low"],
							["High"] = L["High"],
						},
					},
					layoutoverride = {
						order = 8,
						name = L["Layout Override"],
						desc = L["Force a specific layout to show."],
						type = "select",
						values = {
							["NONE"] = L["None"],
							["DPS"] = L["DPS"],
							["Heal"] = L["Heal"],
						},
					},
				},
			},
			media = {
				order = 2,
				type = "group",
				name = L["Media"],
				desc = L["MEDIA_DESC"],
				get = function(info) return db.media[ info[#info] ] end,
				set = function(info, value) db.media[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["MEDIA_DESC"],
					},
					Fonts = {
						type = "group",
						order = 2,
						name = L["Fonts"],
						guiInline = true,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								desc = L["The font that the core of the UI will use"],
								values = AceGUIWidgetLSMlists.font,	
							},
							uffont = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 2,
								name = L["UnitFrame Font"],
								desc = L["The font that unitframes will use"],
								values = AceGUIWidgetLSMlists.font,	
							},
							dmgfont = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 3,
								name = L["Combat Text Font"],
								desc = L["The font that combat text will use. WARNING: This requires a game restart after changing this option."],
								values = AceGUIWidgetLSMlists.font,						
							},					
						},
					},
					Textures = {
						type = "group",
						order = 3,
						name = L["Textures"],
						guiInline = true,
						args = {
							normTex = {
								type = "select", dialogControl = 'LSM30_Statusbar',
								order = 1,
								name = L["StatusBar Texture"],
								desc = L["Texture that gets used on all StatusBars"],
								values = AceGUIWidgetLSMlists.statusbar,								
							},
							glossTex = {
								type = "select", dialogControl = 'LSM30_Statusbar',
								order = 2,
								name = L["Gloss Texture"],
								desc = L["This gets used by some objects, unless gloss mode is on."],
								values = AceGUIWidgetLSMlists.statusbar,								
							},		
							glowTex = {
								type = "select", dialogControl = 'LSM30_Border',
								order = 3,
								name = L["Glow Border"],
								desc = L["Shadow Effect"],
								values = AceGUIWidgetLSMlists.border,								
							},
							blank = {
								type = "select", dialogControl = 'LSM30_Background',
								order = 4,
								name = L["Backdrop Texture"],
								desc = L["Used on almost all frames"],
								values = AceGUIWidgetLSMlists.background,							
							},
							glossyTexture = {
								order = 5,
								type = "toggle",
								name = L["Glossy Texture Mode"],
								desc = L["Glossy texture gets used in all aspects of the UI instead of just on various portions."],
							},
						},
					},
					Colors = {
						type = "group",
						order = 4,
						name = L["Colors"],
						guiInline = true,					
						args = {
							bordercolor = {
								type = "color",
								order = 1,
								name = L["Border Color"],
								desc = L["Main Frame's Border Color"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = unpack(db.media[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									StaticPopup_Show("RELOAD_UI")
									db.media[ info[#info] ] = {r, g, b}
								end,					
							},
							backdropcolor = {
								type = "color",
								order = 2,
								name = L["Backdrop Color"],
								desc = L["Main Frame's Backdrop Color"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = unpack(db.media[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									StaticPopup_Show("RELOAD_UI")
									db.media[ info[#info] ] = {r, g, b}
								end,						
							},
							backdropfadecolor = {
								type = "color",
								order = 3,
								name = L["Backdrop Fade Color"],
								desc = L["Faded backdrop color of some frames"],
								hasAlpha = true,
								get = function(info)
									local r, g, b, a = unpack(db.media[ info[#info] ])
									return r, g, b, a
								end,
								set = function(info, r, g, b, a)
									StaticPopup_Show("RELOAD_UI")
									db.media[ info[#info] ] = {r, g, b, a}
								end,						
							},
							valuecolor = {
								type = "color",
								order = 4,
								name = L["Value Color"],
								desc = L["Value color of various text/frame objects"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = unpack(db.media[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									StaticPopup_Show("RELOAD_UI")
									db.media[ info[#info] ] = {r, g, b}
								end,						
							},
						},
					},
					Sounds = {
						type = "group",
						order = 5,
						name = L["Sounds"],
						guiInline = true,					
						args = {
							whisper = {
								type = "select", dialogControl = 'LSM30_Sound',
								order = 1,
								name = L["Whisper Sound"],
								desc = L["Sound that is played when recieving a whisper"],
								values = AceGUIWidgetLSMlists.sound,								
							},			
							warning = {
								type = "select", dialogControl = 'LSM30_Sound',
								order = 2,
								name = L["Warning Sound"],
								desc = L["Sound that is played when you don't have a buff active"],
								values = AceGUIWidgetLSMlists.sound,								
							},							
						},
					},
				},
			},
			nameplate = {
				order = 3,
				type = "group",
				name = L["Nameplates"],
				desc = L["NAMEPLATE_DESC"],
				get = function(info) return db.nameplate[ info[#info] ] end,
				set = function(info, value) db.nameplate[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["NAMEPLATE_DESC"],
					},				
					enable = {
						type = "toggle",
						order = 2,
						name = ENABLE,
						desc = L["Enable/Disable Nameplates"],
						set = function(info, value)
							db.nameplate[ info[#info] ] = value; 
							StaticPopup_Show("RELOAD_UI")
						end,
					},
					Nameplates = {
						type = "group",
						order = 3,
						name = L["Nameplate Options"],
						guiInline = true,		
						disabled = function() return not db.nameplate.enable end,
						args = {
							showhealth = {
								type = "toggle",
								order = 1,
								name = L["Show Health"],
								desc = L["Display health values on nameplates, this will also increase the size of the nameplate"],
							},
							enhancethreat = {
								type = "toggle",
								order = 2,
								name = L["Health Threat Coloring"],
								desc = L["Color the nameplate's healthbar by your current threat, Example: good threat color is used if your a tank when you have threat, opposite for DPS."],
							},
							combat = {
								type = "toggle",
								order = 3,
								name = L["Toggle Combat"],
								desc = L["Toggles the nameplates off when not in combat."],							
							},
							trackauras = {
								type = "toggle",
								order = 4,
								name = L["Track Auras"],
								desc = L["Tracks your debuffs on nameplates."],									
							},
							trackccauras = {
								type = "toggle",
								order = 5,
								name = L["Track CC Debuffs"],
								desc = L["Tracks CC debuffs on nameplates from you or a friendly player"],										
							},
							Colors = {
								type = "group",
								order = 6,
								name = L["Colors"],
								guiInline = true,	
								get = function(info)
									local r, g, b = unpack(db.nameplate[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									db.nameplate[ info[#info] ] = {r, g, b}
									StaticPopup_Show("RELOAD_UI")
								end,
								disabled = function() return (not db.nameplate.enhancethreat or not db.nameplate.enable) end,								
								args = {
									goodcolor = {
										type = "color",
										order = 1,
										name = L["Good Color"],
										desc = L["This is displayed when you have threat as a tank, if you don't have threat it is displayed as a DPS/Healer"],
										hasAlpha = false,
									},		
									badcolor = {
										type = "color",
										order = 2,
										name = L["Bad Color"],
										desc = L["This is displayed when you don't have threat as a tank, if you do have threat it is displayed as a DPS/Healer"],
										hasAlpha = false,
									},
									transitioncolor = {
										type = "color",
										order = 3,
										name = L["Transition Color"],
										desc = L["This color is displayed when gaining/losing threat"],
										hasAlpha = false,									
									},
								},
							},
						},
					},
				},
			},
			unitframes = {
				order = 4,
				type = "group",
				name = L["Unitframes"],
				desc = L["UF_DESC"],
				get = function(info) return db.unitframes[ info[#info] ] end,
				set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["UF_DESC"],
					},								
					enable = {
						order = 2,
						type = "toggle",
						name = ENABLE,
						desc = L["Enable Unitframes"],
					},
					UFGroup = {
						order = 3,
						type = "group",
						name = L["General Settings"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,	
						args = {
							fontsize = {
								type = "range",
								order = 1,
								name = L["Font Scale"],
								desc = L["Controls the size of the unitframe font"],
								type = "range",
								min = 9, max = 15, step = 1,							
							},
							lowThreshold = {
								type = "range",
								order = 2,
								name = L["Low Mana Threshold"],
								desc = L["Point to warn about low mana"],
								type = "range",
								min = 1, max = 99, step = 1,							
							},
							targetpowerplayeronly = {
								type = "toggle",
								order = 3,
								name = L["Target Power on Player Only"],
								desc = L["Only display power values on player units"] ,
							},
							showfocustarget = {
								type = "toggle",
								order = 4,
								name = L["Focus's Target"],
								desc = L["Display the focus unit's target"],							
							},
							pettarget = {
								type = "toggle",
								order = 5,
								name = L["Pet's Target"],
								desc = L["Display the pet unit's target"],
								disabled = function() return (not db.unitframes.enable or not IsAddOnLoaded("ElvUI_RaidDPS")) end,	
							},
							showtotalhpmp = {
								type = "toggle",
								order = 6,
								name = L["Total HP/MP"],
								desc = L["Display the total HP/MP on all available units"],								
							},
							showsmooth = {
								type = "toggle",
								order = 7,
								name = L["Smooth Bars"],
								desc = L["Smoothly transition statusbars when values change"],									
							},
							charportrait = {
								type = "toggle",
								order = 8,
								name = L["Character Portrait"],
								desc = L["Display character portrait on available frames"],								
							},
							charportraithealth = {
								type = "toggle",
								order = 8,
								name = L["Character Portrait on Health"],
								desc = L["Overlay character portrait on the healthbar available frames"],
								disabled = function() return (not db.unitframes.enable or not db.unitframes.charportrait) end,
							},
							classcolor = {
								type = "toggle",
								order = 9,
								name = L["Class Color"],
								desc = L["Color unitframes by class"],						
							},
							healthcolor = {
								type = "color",
								order = 10,
								name = L["Health Color"],
								desc = L["Color of the healthbar"],
								hasAlpha = false,
								disabled = function() return (not db.unitframes.enable or db.unitframes.classcolor) end,
								get = function(info)
									local r, g, b = unpack(db.unitframes[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									db.unitframes[ info[#info] ] = {r, g, b}
									StaticPopup_Show("RELOAD_UI")
								end,								
							},
							healthcolorbyvalue = {
								type = "toggle",
								order = 11,
								name = L["Color Health by Value"],
								desc = L["Color the health frame by current ammount of hp remaining"],							
							},
							healthbackdrop = {
								type = "toggle",
								order = 12,
								name = L["Custom Backdrop Color"],
								desc = L["Enable using the custom backdrop color, otherwise 20% of the current health color gets used"],
							},
							healthbackdropcolor = {
								type = "color",
								order = 13,
								name = L["Health Backdrop Color"],
								desc = L["Color of the healthbar's backdrop"],
								hasAlpha = false,
								disabled = function() return (not db.unitframes.enable or not db.unitframes.healthbackdrop) end,
								get = function(info)
									local r, g, b = unpack(db.unitframes[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									db.unitframes[ info[#info] ] = {r, g, b}
									StaticPopup_Show("RELOAD_UI")
								end,								
							},
							combatfeedback = {
								type = "toggle",
								order = 14,
								name = L["Combat Feedback"],
								desc = L["Enable displaying incoming damage/healing on player/target frame"],							
							},
							debuffhighlight = {
								type = "toggle",
								order = 15,
								name = L["Debuff Highlighting"],
								desc = L["Enable highlighting unitframes when there is a debuff you can dispel"],							
							},
							classbar = {
								type = "toggle",
								order = 16,
								name = L["ClassBar"],
								desc = L["Display class specific bar (runebar/totembar/holypowerbar/soulshardbar/eclipsebar)"],							
							},
							combat = {
								type = "toggle",
								order = 17,
								name = L["Combat Fade"],
								desc = L["Fade main unitframes out when not in combat, unless you cast or mouseover the frame"],								
							},
							mini_powerbar = {
								type = "toggle",
								order = 18,
								name = L["Mini-Powerbar Theme"],
								desc = L["Style the unitframes with a smaller powerbar"],							
							},
							arena = {
								type = "toggle",
								order = 19,
								name = L["Arena Frames"],							
							},
							showboss = {
								type = "toggle",
								order = 20,
								name = L["Boss Frames"],							
							},							
						},
					},
					UFSizeGroup = {
						order = 4,
						type = "group",
						name = L["Frame Sizes"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,	
						args = {
							playtarwidth = {
								type = "range",
								order = 1,
								name = L["Player/Target Width"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 235, max = 320, step = 1,								
							},
							playtarheight = {
								type = "range",
								order = 2,
								name = L["Player/Target Height"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 35, max = 75, step = 1,								
							},
							smallwidth = {
								type = "range",
								order = 3,
								name = L["TargetTarget, Focus, FocusTarget, Pet Width"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 100, max = 175, step = 1,								
							},
							smallheight = {
								type = "range",
								order = 4,
								name = L["TargetTarget, Focus, FocusTarget, Pet Height"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 18, max = 55, step = 1,								
							},
							arenabosswidth = {
								type = "range",
								order = 5,
								name = L["Arena/Boss Width"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 175, max = 275, step = 1,								
							},
							arenabossheight = {
								type = "range",
								order = 6,
								name = L["Arena/Boss Height"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 30, max = 70, step = 1,								
							},
							assisttankwidth = {
								type = "range",
								order = 7,
								name = L["Assist/Tank Width"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 100, max = 140, step = 1,							
							},
							assisttankheight = {
								type = "range",
								order = 8,
								name = L["Assist/Tank Height"],
								desc = L["Controls the size of the frame"],
								type = "range",
								min = 15, max = 40, step = 1,							
							},							
						},
					},
					UFAurasGroup = {
						order = 5,
						type = "group",
						name = L["Auras"],
						guiInline = true,
						disabled = function() return not db.unitframes.enable end,	
						args = {
							playerauras = {
								type = "toggle",
								order = 1,
								name = L["Player Auras"],
								desc = L["Display auras on frame"],				
							},
							playershowonlydebuffs = {
								type = "toggle",
								order = 2,
								name = L["Hide Player's Buffs"],
								desc = L["Don't display player's buffs"],
								disabled = function() return (not db.unitframes.enable or not db.unitframes.playerauras) end,
							},
							targetauras = {
								type = "toggle",
								order = 3,
								name = L["Target Auras"],
								desc = L["Display auras on frame"],								
							},
							playerdebuffsonly = {
								type = "toggle",
								order = 4,
								name = L["Player's Debuffs Only"],
								desc = L["Only display debuffs on the targetframe that are from yourself"],
								disabled = function() return (not db.unitframes.enable or not db.unitframes.targetauras) end,							
							},
							auratimer = {
								type = "toggle",
								order = 5,
								name = L["Aura Timer"],
								desc = L["Display aura timer"],								
							},
							auratextscale = {
								type = "range",
								order = 6,
								name = L["Aura Text Scale"],
								desc = L["Controls the size of the aura font"],
								type = "range",
								min = 9, max = 15, step = 1,									
							},
							arenadebuffs = {
								type = "toggle",
								order = 7,
								name = L["Arena Debuff Filter"],
								desc = L["Enable filter for arena debuffs"],								
							},
							totdebuffs = {
								type = "toggle",
								order = 10,
								name = L["TargetTarget Debuffs"],
								desc = L["Display auras on frame"],									
							},
							focusdebuffs = {
								type = "toggle",
								order = 11,
								name = L["Focus Debuffs"],
								desc = L["Display auras on frame"],									
							},
							playtarbuffperrow = {
								type = "range",
								order = 12,
								name = L["Player/Target Auras in Row"],
								desc = L["The ammount of auras displayed in a single row"],
								type = "range",
								min = 7, max = 13, step = 1,								
							},
							smallbuffperrow = {
								type = "range",
								order = 13,
								name = L["Small Frames Auras in Row"],
								desc = L["The ammount of auras displayed in a single row"],
								type = "range",
								min = 3, max = 9, step = 1,								
							},
						},
					},
					UFCBGroup = {
						order = 6,
						type = "group",
						name = L["Castbar"],
						guiInline = true,
						disabled = function() return (not db.unitframes.enable or not db.unitframes.unitcastbar) end,	
						args = {
							unitcastbar = {
								type = "toggle",
								order = 1,
								name = ENABLE,
								desc = L["Enable/Disable Castbars"],
								disabled = false,
							},
							cblatency = {
								type = "toggle",
								order = 2,
								name = L["Castbar Latency"],
								desc = L["Show latency on player castbar"],							
							},
							cbicons = {
								type = "toggle",
								order = 3,
								name = L["Castbar Icons"],
								desc = L["Show icons on castbars"],								
							},
							castplayerwidth = {
								type = "range",
								order = 4,
								name = L["Width Player Castbar"],
								desc = L["The size of the castbar"],
								type = "range",
								min = 200, max = 450, step = 1,								
							},
							casttargetwidth = {
								type = "range",
								order = 5,
								name = L["Width Target Castbar"],
								desc = L["The size of the castbar"],
								type = "range",
								min = 200, max = 450, step = 1,								
							},	
							castfocuswidth = {
								type = "range",
								order = 6,
								name = L["Width Focus Castbar"],
								desc = L["The size of the castbar"],
								type = "range",
								min = 200, max = 450, step = 1,								
							},
							castbarcolor = {
								type = "color",
								order = 7,
								name = L["Castbar Color"],
								desc = L["Color of the castbar"],
								hasAlpha = false,
								disabled = function() return (not db.unitframes.enable or db.general.classcolortheme) end,
								get = function(info)
									local r, g, b = unpack(db.unitframes[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									db.unitframes[ info[#info] ] = {r, g, b}
									StaticPopup_Show("RELOAD_UI")
								end,							
							},
							nointerruptcolor = {
								type = "color",
								order = 8,
								name = L["Interrupt Color"],
								desc = L["Color of the castbar when you can't interrupt the cast"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = unpack(db.unitframes[ info[#info] ])
									return r, g, b
								end,
								set = function(info, r, g, b)
									db.unitframes[ info[#info] ] = {r, g, b}
									StaticPopup_Show("RELOAD_UI")
								end,								
							},
						},
					},
				},
			},
			raidframes = {
				order = 5,
				type = "group",
				name = L["Raidframes"],
				desc = L["RF_DESC"],
				get = function(info) return db.raidframes[ info[#info] ] end,
				set = function(info, value) db.raidframes[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,				
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["RF_DESC"],					
					},
					enable = {
						order = 2,
						type = "toggle",
						name = ENABLE,
						desc = L["Enable Raidframes"],
					},
					RFGroup = {
						order = 3,
						type = "group",
						name = L["General Settings"],
						guiInline = true,
						disabled = function() return not db.raidframes.enable end,	
						args = {
							fontsize = {
								type = "range",
								order = 1,
								name = L["Font Scale"],
								desc = L["Controls the size of the unitframe font"],
								type = "range",
								min = 9, max = 15, step = 1,							
							},
							scale = {
								type = "range",
								order = 2,
								name = L["Scale"],
								type = "range",
								min = 0.64, max = 1.5, step = 0.01,
								isPercent = true,
							},
							showrange = {
								order = 3,
								type = "toggle",
								name = L["Fade with Range"],
								desc = L["Fade the unit out when they become out of range"],
							},
							raidalphaoor = {
								type = "range",
								order = 2,
								name = L["Out of Range Alpha"],
								type = "range",
								min = 0, max = 1, step = 0.01,
								isPercent = true,							
							},
							healcomm = {
								order = 5,
								type = "toggle",
								name = L["Incoming Heals"],
								desc = L["Show predicted incoming heals"],
								disabled = false,	
							},
							gridhealthvertical = {
								order = 6,
								type = "toggle",
								name = L["Vertical Healthbar"],
								desc = L["Healthbar grows vertically instead of horizontally"],
								disabled = function() return not db.raidframes.enable or not IsAddOnLoaded("ElvUI_RaidHeal") end,	
							},
							showplayerinparty = {
								order = 7,
								type = "toggle",
								name = L["Player In Party"],
								desc = L["Show the player frame in the party layout"],							
							},
							maintank = {
								order = 8,
								type = "toggle",
								name = L["Maintank"],
								desc = L["Display unit"],								
							},
							mainassist = {
								order = 9,
								type = "toggle",
								name = L["Mainassist"],
								desc = L["Display unit"],								
							},
							partypets = {
								order = 10,
								type = "toggle",
								name = L["Party Pets"],
								desc = L["Display unit"],								
							},
							disableblizz = {
								order = 11,
								type = "toggle",
								name = L["Disable Blizzard Frames"],
								disabled = false,
							},
							healthdeficit = {
								order = 12,
								type = "toggle",
								name = L["Health Deficit"],
								desc = L["Display health deficit on the frame"],
							},
							griddps = {
								order = 13,
								type = "toggle",
								name = L["DPS GridMode"],
								desc = L["Show the DPS layout in gridmode instead of vertical"],
								disabled = function() return not db.raidframes.enable or not IsAddOnLoaded("ElvUI_RaidDPS") end,
							},
							role = {
								order = 14,
								type = "toggle",
								name = L["Role"],
								desc = L["Show the unit's role (DPS/Tank/healer) Note: Party frames always show this"],
							},
							partytarget = {
								order = 15,
								type = "toggle",
								name = L["Party Target's"],
								desc = L["Display unit"],
								disabled = function() return not db.raidframes.enable or not IsAddOnLoaded("ElvUI_RaidDPS") end,							
							},
							mouseglow = {
								order = 16,
								type = "toggle",
								name = L["Mouse Glow"],
								desc = L["Glow the unitframe to the unit's Reaction/Class when mouseover'd"],							
							},
							raidunitbuffwatch = {
								type = "toggle",
								order = 15,
								name = L["Raid Buff Display"],
								desc = L["Display special buffs on raidframes"],
								disabled = function() return not db.raidframes.enable and not db.unitframes.enable end,
							},
							buffindicatorsize = {
								type = "range",
								order = 17,
								name = L["Raid Buff Display Size"],
								desc = L["Size of the buff icon on raidframes"],
								disabled = function() return not db.raidframes.enable and not db.unitframes.enable end,
								type = "range",
								min = 3, max = 9, step = 1,									
							},
						},
					},
				},
			},
			skin = {
				order = 6,
				type = "group",
				name = L["Addon Skins"],
				desc = L["ADDON_DESC"],
				get = function(info) return db.skin[ info[#info] ] end,
				set = function(info, value) db.skin[ info[#info] ] = value; StaticPopup_Show("RELOAD_UI") end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["ADDON_DESC"],
					},
					embedright = {
						order = 2,
						type = "select",
						name = L["Embed Right"],
						desc = L["EMBED_DESC"],
						values = {
							["NONE"] = L["None"],
							["Recount"] = "Recount",
							["Omen"] = "Omen",
							["Skada"] = "Skada",
						},						
					},
					SkadaGroup = {
						order = 3,
						type = "group",
						name = "Skada",
						args = {
							skada = {
								order = 1,
								type = "toggle",
								name = ENABLE,
								desc = L["Enable this skin"],
							},
						},
					},
					RecountGroup = {
						order = 4,
						type = "group",
						name = "Recount",
						args = {
							recount = {
								order = 1,
								type = "toggle",
								name = ENABLE,
								desc = L["Enable this skin"],
							},
						},
					},	
					OmenGroup = {
						order = 5,
						type = "group",
						name = "Omen",
						args = {
							omen = {
								order = 1,
								type = "toggle",
								name = ENABLE,
								desc = L["Enable this skin"],
							},
						},
					},		
					KLEGroup = {
						order = 6,
						type = "group",
						name = "KLE",
						args = {
							kle = {
								order = 1,
								type = "toggle",
								name = ENABLE,
								desc = L["Enable this skin"],
							},
							hookkleright = {
								order = 2,
								type = "toggle",
								name = L["Hook KLE Bars"],
								desc = L["Attach KLE's Bars to the right window"],
							},
						},
					},	
					DBMGroup = {
						order = 7,
						type = "group",
						name = "DBM",
						args = {
							dbm = {
								order = 1,
								type = "toggle",
								name = ENABLE,
								desc = L["Enable this skin"],
							},
						},
					},		
					BigWigsGroup = {
						order = 8,
						type = "group",
						name = "BigWigs",
						args = {
							bigwigs = {
								order = 1,
								type = "toggle",
								name = ENABLE,
								desc = L["Enable this skin"],
							},
							hookbwright = {
								order = 2,
								type = "toggle",
								name = L["Hook BigWigs Bars"],
								desc = L["Attach BigWigs's Bars to the right window"],
							},							
						},
					},						
				},
			},			
		},
	}
end


