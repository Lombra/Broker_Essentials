local _, core = ...
local db, sessionCharacter, sessionAccount

local player

local module = core:NewModule("Gold", {
	type = "data source",
	label = "Gold",
	icon = [[Interface\Icons\INV_Misc_Coin_02]],
	OnTooltipShow = function(self)
		self:AddLine("Gold", HIGHLIGHT_FONT_COLOR:GetRGB())
		local sum = db.account
		for character, money in pairs(db.characters) do
			if core:IsConnectedRealm(character:match("%-(.+)"), true) then
				self:AddDoubleLine(Ambiguate(character, "none"), GetMoneyString(money, true, true), nil, nil, nil, HIGHLIGHT_FONT_COLOR:GetRGB())
				sum = sum + money
			end
		end
		if db.account > 0 then
			self:AddLine(" ")
			self:AddDoubleLine("Warband bank", GetMoneyString(db.account, true, true), nil, nil, nil, HIGHLIGHT_FONT_COLOR:GetRGB())
		end
		self:AddLine(" ")
		self:AddDoubleLine("Total", GetMoneyString(sum, true, true), nil, nil, nil, HIGHLIGHT_FONT_COLOR:GetRGB())
		self:AddLine(" ")
		local color = HIGHLIGHT_FONT_COLOR
		local delta = (GetMoney() + db.account) - (sessionCharacter + sessionAccount)
		if delta > 0 then
			-- we have gained money
			color = GREEN_FONT_COLOR
		elseif delta < 0 then
			-- we have lost money
			delta = abs(delta)
			color = RED_FONT_COLOR
		end
		self:AddDoubleLine("Earned this session", GetMoneyString(delta, true, true), nil, nil, nil, color:GetRGB())
	end
})

local defaults = {
	characters = { },
}

function module:OnInitialize()
	db = self:GetDB(defaults)
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_MONEY", self.UpdatePlayerMoney)
	self:RegisterEvent("ACCOUNT_MONEY", self.UpdateAccountMoney)
end

function module:PLAYER_LOGIN()
	player = strjoin("-", UnitFullName("player"))
	self:UpdatePlayerMoney()
	self:UpdateAccountMoney()
end

function module:UpdateText()
	self.text = GetMoneyString(db.characters[player], true, true)
end

function module:UpdatePlayerMoney()
	local money = GetMoney()
	sessionCharacter = sessionCharacter or money
	db.characters[player] = money
	self:UpdateText()
end

function module:UpdateAccountMoney()
	local money = C_Bank.FetchDepositedMoney(Enum.BankType.Account)
	sessionAccount = sessionAccount or money
	db.account = money
end
