local _, core = ...

local PVP_TYPE_COLORS = {
	["sanctuary"] = {
		r = 0.41,
		g = 0.8,
		b = 0.94,
	},
	["arena"] = {
		r = 1.0,
		g = 0.1,
		b = 0.1,
	},
	["friendly"] = {
		r = 0.1,
		g = 1.0,
		b = 0.1,
	},
	["hostile"] = {
		r = 1.0,
		g = 0.1,
		b = 0.1,
	},
	["contested"] = {
		r = 1.0,
		g = 0.7,
		b = 0.0,
	},
	["combat"] = {
		r = 1.0,
		g = 0.1,
		b = 0.1,
	},
}

local function getPvPTypeColor(pvpType)
	return PVP_TYPE_COLORS[pvpType] or NORMAL_FONT_COLOR
end

local module = core:NewModule("Location", {
	type = "data source",
	label = "Location",
	icon = [[Interface\Icons\INV_Misc_Coin_02]],
	OnClick = function(self)
		ToggleWorldMap()
	end,
	OnTooltipShow = function(self)
		local zoneName = GetZoneText()
		local subzoneName = GetSubZoneText()
		if subzoneName == zoneName then
			subzoneName = ""
		end

		self:AddLine(zoneName, 1.0, 1.0, 1.0)

		local pvpType, isSubZonePvP, factionName = C_PvP.GetZonePVPInfo()
		local color = getPvPTypeColor(pvpType)
		if pvpType == "sanctuary" then
			self:AddLine(subzoneName, color.r, color.g, color.b)
			self:AddLine(SANCTUARY_TERRITORY, color.r, color.g, color.b)
		elseif pvpType == "arena" then
			self:AddLine(subzoneName, color.r, color.g, color.b)
			self:AddLine(FREE_FOR_ALL_TERRITORY, color.r, color.g, color.b)
		elseif pvpType == "friendly" then
			if factionName and factionName ~= "" then
				self:AddLine(subzoneName, color.r, color.g, color.b)
				self:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), color.r, color.g, color.b)
			end
		elseif pvpType == "hostile" then
			if factionName and factionName ~= "" then
				self:AddLine(subzoneName, color.r, color.g, color.b)
				self:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), color.r, color.g, color.b)
			end
		elseif pvpType == "contested" then
			self:AddLine(subzoneName, 1.0, 0.7, 0.0 )
			self:AddLine(CONTESTED_TERRITORY, 1.0, 0.7, 0.0)
		elseif pvpType == "combat" then
			self:AddLine(subzoneName, 1.0, 0.1, 0.1)
			self:AddLine(COMBAT_ZONE, 1.0, 0.1, 0.1)
		else
			self:AddLine(subzoneName, color.r, color.g, color.b)
		end

		GameTooltip:AddLine(MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP"))
	end
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN", "Update")
	self:RegisterEvent("ZONE_CHANGED", "Update")
	self:RegisterEvent("ZONE_CHANGED_INDOORS", "Update")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Update")
end

function module:Update()
	local pvpType, isSubZonePvP, factionName = C_PvP.GetZonePVPInfo()
	local color = getPvPTypeColor(pvpType)
	self.text = WrapTextInColor(GetMinimapZoneText(), CreateColor(color.r, color.g, color.b))
end
