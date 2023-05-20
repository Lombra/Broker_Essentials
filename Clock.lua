local _, core = ...

local module = core:NewModule("Clock", {
	type = "data source",
	label = "Clock",
	icon = [[Interface\Icons\INV_Misc_PocketWatch_01]],
	OnClick = function(self)
		TimeManager_Toggle()
	end,
})

local interval = 1
local lastUpdate = 0

module:SetOnUpdate(function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	while lastUpdate > interval do
		self.text = format(TIMEMANAGER_TICKER_24HOUR, GetGameTime())
		lastUpdate = lastUpdate - 1
	end
end)
