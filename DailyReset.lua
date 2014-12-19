local _, core = ...

local module = core:NewModule("DailyReset", {
	type = "data source",
	label = "Daily reset",
	icon = [[Interface\GossipFrame\DailyQuestIcon]],
})

local interval = 1
local lastUpdate = 0

module:SetOnUpdate(function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	while lastUpdate > interval do
		local resetTime = GetQuestResetTime()
		local maxCount = 1
		if resetTime < 60 then
			-- interval = 1
		elseif resetTime < 3600 then
			-- interval = 60
			
		elseif resetTime % 3600 < 60 then
		else
			maxCount = 2
		end
		self.text = SecondsToTime(resetTime, nil, nil, maxCount)
		lastUpdate = lastUpdate - 1
	end
end)