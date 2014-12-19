local _, core = ...

local function onClick(self, arg1)
	ChatFrame_SendSmartTell(arg1)
end

local dropdown = CreateFrame("Frame")
dropdown.displayMode = "MENU"
dropdown.initialize = function(self, level)
	if level ~= 1 then return end
	local numBNetTotal, numBNetOnline = BNGetNumFriends()
	local numWoWTotal, numWoWOnline = GetNumFriends()
	local zonec, realmc, grouped
	if (numBNetOnline + numWoWOnline) > 0 then
		if numWoWOnline > 0 then
			local info = UIDropDownMenu_CreateInfo()
			info.text = "World of Warcraft"
			info.isTitle = true
			info.notCheckable = true
			UIDropDownMenu_AddButton(info)
			
			for i = 1, numWoWOnline do
				local name, level, class, area, connected, status = GetFriendInfo(i)
				local zonec
				if GetRealZoneText() == area then
					zonec = activezone
				else
					zonec = inactivezone
				end
				
				for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				
				local grouped
				if UnitInParty(name) or UnitInRaid(name) then
					grouped = 1
				else
					grouped = 2
				end
				
				local info = UIDropDownMenu_CreateInfo()
				info.text = format(levelNameClassString, level, name, groupedTable[grouped], " "..status)
				-- info.value = i
				info.func = onClick
				info.arg1 = name
				info.colorCode = "|c"..classc.colorStr
				info.notCheckable = true
				UIDropDownMenu_AddButton(info)
			end
		end
		if numBNetOnline > 0 then
			local info = UIDropDownMenu_CreateInfo()
			info.text = "Battle.net"
			info.isTitle = true
			info.notCheckable = true
			UIDropDownMenu_AddButton(info)

			local status = 0
			for i = 1, numBNetOnline do
				local presenceID, presenceName, _, _, toonName, toonID, client, _, _, isAFK, isDND = BNGetFriendInfo(i)
				local hasFocus, _, _, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(presenceID)
				if client == BNET_CLIENT_WOW then
					if isAFK then
						status = 1
					elseif isDND then
						status = 2
					else
						status = 3
					end

					for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
					local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
					
					local grouped
					if UnitInParty(toonName) or UnitInRaid(toonName) then
						grouped = 1
					else
						grouped = 2
					end
					local info = UIDropDownMenu_CreateInfo()
					info.text = presenceName
					-- info.value = i
					info.func = onClick
					info.arg1 = presenceName
					-- info.colorCode = "|c"..classc.colorStr
					info.notCheckable = true
					UIDropDownMenu_AddButton(info)
					-- GameTooltip:AddDoubleLine(presenceName, format(clientLevelNameString, client, level, classc, toonName, groupedTable[grouped], 255, 0, 0, statusTable[status]),238,238,238,238,238,238)
				else
					GameTooltip:AddDoubleLine("|cffeeeeee"..presenceName.."|r", "|cffeeeeee"..client.." ("..toonName..")|r")
				end
			end
		end
	end
end

local module = core:NewModule("Friends", {
	type = "data source",
	label = "Friends",
	OnClick = function(self, button)
		if button == "LeftButton" then
			ToggleFriendsFrame(1)
		else
			GameTooltip:Hide() 
			ToggleDropDownMenu(nil, nil, dropdown, self, 0, 0)
		end
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN", "Update")
	self:RegisterEvent("FRIENDLIST_UPDATE", "Update")
	self:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE", "Update")
	self:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE", "Update")
end

function module:Update()
	local numBNetTotal, numBNetOnline = BNGetNumFriends()
	local numWoWTotal, numWoWOnline = GetNumFriends()
	
	self.text = numBNetOnline + numWoWOnline
end

local clientLevelNameString = "%s (%d |c%s%s|r%s) |cff%02x%02x%02x%s|r"
local levelNameClassString = "%d %s%s%s"
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
local statusTable = { "|cffff0000[AFK]|r", "|cffff0000[DND]|r", "" }
local groupedTable = { "|cffaaaaaa*|r", "" } 

function module:OnTooltipShow()
	local numBNetTotal, numBNetOnline = BNGetNumFriends()
	local numWoWTotal, numWoWOnline = GetNumFriends()
	local zonec, realmc, grouped
	if (numBNetOnline + numWoWOnline) > 0 then
		self:AddLine("Friends", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		if numWoWOnline > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("World of Warcraft")
			
			for i = 1, numWoWOnline do
				local name, level, class, area, connected, status = GetFriendInfo(i)
				local zonec
				if GetRealZoneText() == area then
					zonec = activezone
				else
					zonec = inactivezone
				end
				
				for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				
				local grouped
				if UnitInParty(name) or UnitInRaid(name) then
					grouped = 1
				else
					grouped = 2
				end
				GameTooltip:AddDoubleLine(format(levelNameClassString, level, name, groupedTable[grouped], " "..status), area, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
			end
		end
		if numBNetOnline > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Battle.net")

			local status = 0
			for i = 1, numBNetOnline do
				local presenceID, presenceName, _, _, toonName, toonID, client, _, _, isAFK, isDND = BNGetFriendInfo(i)
				local hasFocus, _, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(toonID)
				if client == BNET_CLIENT_WOW then
					if isAFK then
						status = 1
					elseif isDND then
						status = 2
					else
						status = 3
					end

					for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
					local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
					
					local grouped
					if UnitInParty(toonName) or UnitInRaid(toonName) then
						grouped = 1
					else
						grouped = 2
					end
					GameTooltip:AddDoubleLine(presenceName, format(clientLevelNameString, client, level, classc or "ffffffff", toonName, groupedTable[grouped], 255, 0, 0, statusTable[status]),238,238,238,238,238,238)
					if IsShiftKeyDown() then
						if GetRealZoneText() == zoneName then
							zonec = activezone
						else
							zonec = inactivezone
						end
						if GetRealmName() == realmName then
							realmc = activezone
						else
							realmc = inactivezone
						end
						GameTooltip:AddDoubleLine("  "..zoneName, realmName, zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
					end
				else
					GameTooltip:AddDoubleLine("|cffeeeeee"..presenceName.."|r", "|cffeeeeee"..client.." ("..toonName..")|r")
				end
			end
		end
		GameTooltip:Show()
	-- else 
		-- GameTooltip:Hide() 
	end
end

local menuList = {
	{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
	{ text = INVITE, hasArrow = true,notCheckable=true, },
	{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true, },			
	{ text = PLAYER_STATUS, hasArrow = true, notCheckable=true,
		menuList = {
			{ text = "|cff2BC226"..AVAILABLE.."|r", notCheckable=true, func = function() if IsChatAFK() then SendChatMessage("", "AFK") elseif IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffE7E716"..DND.."|r", notCheckable=true, func = function() if not IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffFF0000"..AFK.."|r", notCheckable=true, func = function() if not IsChatAFK() then SendChatMessage("", "AFK") end end },
		},
	},
	{ text = BN_BROADCAST_TOOLTIP, notCheckable=true, func = function() T.ShowPopup("TUKUI_SET_BN_BROADCAST") end },
}

local function inviteClick(self, arg1, arg2, checked)
	menuFrame:Hide()
	if type(arg1) ~= 'number' then
		InviteUnit(arg1)
	else
		BNInviteFriend(arg1);
	end
end

local function whisperClick(self,name,bnet)
	menuFrame:Hide()
	if bnet then
		ChatFrame_SendSmartTell(name)
	else
		SetItemRef( "player:"..name, ("|Hplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )
	end
end

-- Stat:RegisterEvent("BN_FRIEND_INFO_CHANGED")
-- Stat:RegisterEvent("BN_FRIEND_TOON_ONLINE")
-- Stat:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
-- Stat:RegisterEvent("BN_TOON_NAME_UPDATED")