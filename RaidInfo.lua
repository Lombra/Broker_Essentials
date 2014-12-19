local _, core = ...

local module

module = core:NewModule("RaidInfo", {
	type = "data source",
	label = "Instance lockouts",
	icon = [[Interface\Icons\Ability_TownWatch]],
	OnClick = function(self, button)
		ToggleRaidFrame(2)
		if RaidFrame:IsVisible() then
			RaidInfoFrame:Show()
		end
	end,
	OnTooltipShow = function(self)
		self:AddLine("Broker: RaidInfo", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		local isSaved
		for i = 1, GetNumSavedInstances() do
			local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, _, isRaid, maxPlayers, difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(i)
			if locked or extended then
				self:AddLine(instanceName)
				if defeatedBosses < maxBosses then
					for encounterIndex = 1, maxBosses do
						local encounterName, _, defeated = GetSavedInstanceEncounterInfo(i, encounterIndex)
						local color
						if defeated then
							color = RED_FONT_COLOR
						else
							color = GREEN_FONT_COLOR
						end
						self:AddDoubleLine("  "..encounterName, defeated and BOSS_DEAD or BOSS_ALIVE, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, color.r, color.g, color.b)
					end
				else
					self:AddLine("  Cleared", RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
				end
				isSaved = true
			end
		end
		for i = 1, GetNumSavedWorldBosses() do
			self:AddLine(GetSavedWorldBossInfo(i))
			self:AddLine("  "..BOSS_DEAD, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			isSaved = true
		end
		if not isSaved then
			self:AddLine("Not saved to any instances")
		end
		RequestRaidInfo()
		module.tooltipOwner = self:GetOwner()
	end
})

function module:OnInitialize()
	self:RegisterEvent("UPDATE_INSTANCE_INFO", "UpdateTooltip")
end

function module:UpdateTooltip()
	if self.tooltipOwner and GameTooltip:IsOwned(self.tooltipOwner) then
		GameTooltip:ClearLines()
		self.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	end
end