local _, core = ...
local db, session

local player

local module = core:NewModule("Gold", {
	type = "data source",
	label = "Gold",
	icon = [[Interface\Icons\INV_Misc_Coin_02]],
	OnTooltipShow = function(self)
		self:AddLine("Gold", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		local sum = 0
		for character, money in pairs(db) do
			if core:IsConnectedRealm(character:match("%-(.+)"), true) then
				self:AddDoubleLine(Ambiguate(character, "none"), GetMoneyString(money), nil, nil, nil, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
				sum = sum + money
			end
		end
		self:AddLine(" ")
		self:AddDoubleLine("Total", GetMoneyString(sum), nil, nil, nil, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		self:AddLine(" ")
		local color = HIGHLIGHT_FONT_COLOR
		local delta = GetMoney() - session
		if delta > 0 then
			-- we have gained money
			color = GREEN_FONT_COLOR
		elseif delta < 0 then
			-- we have lost money
			delta = abs(delta)
			color = RED_FONT_COLOR
		end
		self:AddDoubleLine("Earned this session", GetMoneyString(delta), nil, nil, nil, color.r, color.g, color.b)
	end
})

function module:OnInitialize()
	db = self:GetDB()
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_MONEY", "Update")
end

function module:PLAYER_LOGIN()
	player = strjoin("-", UnitFullName("player"))
	self:Update()
end

function module:Update()
	local money = GetMoney()
	session = session or money
	db[player] = money
	self.text = GetMoneyString(money)
end
