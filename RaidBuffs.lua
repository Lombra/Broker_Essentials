local _, core = ...

local module = core:NewModule("RaidBuffs", {
	type = "data source",
	icon = [[Interface\Icons\Spell_Nature_TimeStop]],
	label = "Raid buffs",
	OnTooltipShow = function(self)
		local buffmask, buffcount = GetRaidBuffInfo()
		if not buffmask then
			return
		end
		self:AddLine("Broker: RaidBuffs", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		local mask = 1
		for i = 1, NUM_LE_RAID_BUFF_TYPES do
			local name, rank, texture, duration, expiration, spellID, slot = GetRaidBuffTrayAuraInfo(i)
			if name then  
				self:AddLine(name)
				self:AddTexture(texture)
			else
				local color = GRAY_FONT_COLOR
				if bit.band(buffmask, 2 ^ (i - 1)) > 0 then
					color = RED_FONT_COLOR
				end
				self:AddLine(_G["RAID_BUFF_"..i], color.r, color.g, color.b)
				self:AddTexture([[Interface\Common\buff-bg]])
			end
			mask = bit.lshift(mask, 1)
		end
	end,
})

function module:OnInitialize()
	-- self:RegisterUnitEvent("UNIT_AURA", "player", "Update")
	self:RegisterEvent("UNIT_AURA", "Update")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "Update")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "Update")
end

function module:Update(unit)
	if unit and unit ~= "player" then return end
	if not IsInGroup() then
		self.text = "N/A"
		return
	end
	local numBuffs = 0
	local buffmask, buffcount = GetRaidBuffInfo()
	if not buffmask then
		return
	end
	for i = 1, NUM_LE_RAID_BUFF_TYPES do
		local name = GetRaidBuffTrayAuraInfo(i)
		if name then  
			numBuffs = numBuffs + 1
			if bit.band(buffmask, 2 ^ (i - 1)) == 0 then
				buffcount = buffcount + 1
			end
		end
	end
	if numBuffs == buffcount then
		self.text = format("%s%d/%d", GREEN_FONT_COLOR_CODE, numBuffs, buffcount)
	else
		self.text = format("%s%d/%d", RED_FONT_COLOR_CODE, numBuffs, buffcount)
	end
end