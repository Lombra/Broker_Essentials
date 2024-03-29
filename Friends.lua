local _, core = ...

local clientLevelNameString = "%s (%d |c%s%s|r%s) |cff%02x%02x%02x%s|r"
local levelNameClassString = "%d %s%s%s"
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
local statusTable = { "|cffff0000[AFK]|r", "|cffff0000[DND]|r", "" }
local groupedTable = { "|cffaaaaaa*|r", "" } 

local function onClick(self, arg1)
	ChatFrame_SendSmartTell(arg1)
end

local dropdown = CreateFrame("Frame")
dropdown.displayMode = "MENU"
dropdown.initialize = function(self, level)
	if level ~= 1 then return end
	local numBNetTotal, numBNetOnline, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()
	local numWoWOnline = C_FriendList.GetNumOnlineFriends()
	if (numBNetOnline + numWoWOnline) > 0 then
		if numWoWOnline > 0 then
			local info = UIDropDownMenu_CreateInfo()
			info.text = "World of Warcraft"
			info.isTitle = true
			info.notCheckable = true
			UIDropDownMenu_AddButton(info)
			
			for i = 1, numWoWOnline do
				local friendInfo = C_FriendList.GetFriendInfoByIndex(i)
				local name = friendInfo.name
				local class = friendInfo.class
				local zonec
				if friendInfo.area == GetRealZoneText() then
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
				info.text = format(levelNameClassString, friendInfo.level, name, groupedTable[grouped], " "..friendInfo.status)
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

			local friendIndices = {}
			for i = 1, numBNetFavoriteOnline do tinsert(friendIndices, i) end
			for i = numBNetFavorite + 1, numBNetOnline + (numBNetFavorite - numBNetFavoriteOnline) do tinsert(friendIndices, i) end
			
			for i, v in ipairs(friendIndices) do
				local accountInfo = C_BattleNet.GetFriendAccountInfo(v)
				local accountName = accountInfo.accountName
				local gameAccountInfo = accountInfo.gameAccountInfo
				local characterName = gameAccountInfo and gameAccountInfo.characterName
				local client = gameAccountInfo and gameAccountInfo.clientProgram
				if client == BNET_CLIENT_WOW then
					local class = gameAccountInfo.className
					for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
					local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
					
					local grouped
					if UnitInParty(characterName) or UnitInRaid(characterName) then
						grouped = 1
					else
						grouped = 2
					end
					local info = UIDropDownMenu_CreateInfo()
					info.text = accountName
					-- info.value = i
					info.func = onClick
					info.arg1 = accountName
					-- info.colorCode = "|c"..classc.colorStr
					info.notCheckable = true
					UIDropDownMenu_AddButton(info)
				else
					GameTooltip:AddDoubleLine("|cffeeeeee"..accountName.."|r", "|cffeeeeee"..client.." ("..(characterName or "")..")|r")
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
	local numWoWOnline = C_FriendList.GetNumOnlineFriends()
	
	self.text = numBNetOnline + numWoWOnline
end

function module:OnTooltipShow()
	local numBNetTotal, numBNetOnline, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()
	local numWoWOnline = C_FriendList.GetNumOnlineFriends()
	if (numBNetOnline + numWoWOnline) > 0 then
		self:AddLine("Friends", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		if numWoWOnline > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("World of Warcraft")
			
			for i = 1, numWoWOnline do
				local friendInfo = C_FriendList.GetFriendInfoByIndex(i)
				local name = friendInfo.name
				local status = 0
				if friendInfo.isAFK then
					status = 1
				elseif friendInfo.isDND then
					status = 2
				else
					status = 3
				end

				local zonec
				if friendInfo.area == GetRealZoneText() then
					zonec = activezone
				else
					zonec = inactivezone
				end
				
				local class = friendInfo.className
				for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
					if v == class then
						class = k
					end
				end
				
				local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				
				local grouped
				if UnitInParty(name) or UnitInRaid(name) then
					grouped = 1
				else
					grouped = 2
				end
				GameTooltip:AddDoubleLine(format(levelNameClassString, friendInfo.level, name, groupedTable[grouped], " "..statusTable[status]), friendInfo.area, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
			end
		end
		if numBNetOnline > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Battle.net")

			local friendIndices = {}
			for i = 1, numBNetFavoriteOnline do tinsert(friendIndices, i) end
			for i = numBNetFavorite + 1, numBNetOnline + (numBNetFavorite - numBNetFavoriteOnline) do tinsert(friendIndices, i) end
			
			for i, v in ipairs(friendIndices) do
				local accountInfo = C_BattleNet.GetFriendAccountInfo(v)
				local gameAccountInfo = accountInfo.gameAccountInfo
				local characterName = gameAccountInfo.characterName
				local client = gameAccountInfo.clientProgram
				if client == BNET_CLIENT_WOW then
					local status = 0
					if accountInfo.isAFK then
						status = 1
					elseif accountInfo.isDND then
						status = 2
					else
						status = 3
					end

					local class = gameAccountInfo.className
					for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
					local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
					
					local grouped
					if UnitInParty(characterName) or UnitInRaid(characterName) then
						grouped = 1
					else
						grouped = 2
					end
					GameTooltip:AddDoubleLine(accountInfo.accountName, format(clientLevelNameString, client, gameAccountInfo.characterLevel, classc or "ffffffff", characterName, groupedTable[grouped], 255, 0, 0, statusTable[status]), 238, 238, 238, 238, 238, 238)
					if IsShiftKeyDown() then
						local zoneName = gameAccountInfo.areaName
						local zonec
						if GetRealZoneText() == zoneName then
							zonec = activezone
						else
							zonec = inactivezone
						end
						
						local realmName = gameAccountInfo.realmName
						local realmc
						if GetRealmName() == realmName then
							realmc = activezone
						else
							realmc = inactivezone
						end
						
						GameTooltip:AddDoubleLine("  "..zoneName, realmName, zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
					end
				else
					if client ~= BNET_CLIENT_APP and client ~= "BSAp" then
						characterName = BNet_GetValidatedCharacterName(characterName, accountInfo.battleTag, client)
						GameTooltip:AddDoubleLine(accountInfo.accountName, format("%s (%s)", client, characterName), 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
					else
						GameTooltip:AddLine(accountInfo.accountName, 1.0, 1.0, 1.0)
					end
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
