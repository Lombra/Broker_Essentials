if select(2, UnitClass("player")) ~= "SHAMAN" then
	return
end

local _, core = ...

local REINCARNATION_ID = 20608

local COOLDOWN_MAX_TIME = 1800

local function GetGradientColor(percent)
	local r1, g1, b1, r2, g2, b2
	if percent <= 0.5 then
		percent = percent * 2
		r1, g1, b1 = 0.2, 1, 0.2
		r2, g2, b2 = 1, 1, 0.2
	else
		percent = percent * 2 - 1
		r1, g1, b1 = 1, 1, 0.2
		r2, g2, b2 = 1, 0.2, 0.2
	end
	return r1 + (r2 - r1) * percent, g1 + (g2 - g1) * percent, b1 + (b2 - b1) * percent
end

local module = core:NewModule("Reincarnation", {
	type = "data source",
	label = "Reincarnation",
	icon = GetSpellTexture(REINCARNATION_ID),
	text = "Ready"
})

local interval = 1
local nextUpdate = 0

local function onUpdate(self, elapsed)
	nextUpdate = nextUpdate - elapsed
	while nextUpdate < interval do
		local start, duration = GetSpellCooldown(REINCARNATION_ID)
		duration = start + duration - GetTime()
		nextUpdate = duration % 1
		-- print(duration)
		local maxCount = 1
		if duration < 60 then
			-- interval = 1
		elseif duration < 3600 then
			-- interval = 60
			
		elseif duration % 3600 < 60 then
		else
			maxCount = 2
		end
		if duration > 0 then
			local r, g, b = GetGradientColor(duration / COOLDOWN_MAX_TIME)
			self.text = format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, SecondsToTime(duration, nil, nil, maxCount))
		else
			self:RemoveOnUpdate()
			self.text = format("|cff33ff33%s|r", READY)
		end
		nextUpdate = nextUpdate + 1
	end
end

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("SELF_RES_SPELL_CHANGED")
end

function module:PLAYER_LOGIN()
	if GetSpellCooldown(REINCARNATION_ID) > 0 then
		self:SetOnUpdate(onUpdate)
	end
	
	self:SPELLS_CHANGED()
	
	-- self.PLAYER_LOGIN = nil
end

function module:PLAYER_ALIVE()
	if UnitIsGhost("player") then
		return
	end

end

function module:SELF_RES_SPELL_CHANGED()
end

function module:SPELLS_CHANGED()
	if not IsSpellKnown(REINCARNATION_ID) then
		return
	end

	self:UnregisterEvent("SPELLS_CHANGED")

	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")

	-- local start, duration = GetSpellCooldown(REINCARNATION_ID)
	-- if start and duration and start > 0 and duration > 0 then
		-- self:Reincarnate(start)
		-- timer:Play()
	-- end

	-- self:UpdateText()
end