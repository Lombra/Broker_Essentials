local _, core = ...

local module = core:NewModule("Currency", {
	type = "data source",
	label = CURRENCY,
	icon = [[Interface\Icons\Spell_Holy_ChampionsBond]],
	OnClick = function(self) ToggleCharacter("TokenFrame") end,
	OnTooltipShow = function(self)
		self:AddLine("Broker: Currency", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		for i = 1, C_CurrencyInfo.GetCurrencyListSize() do
			local currencyInfo = C_CurrencyInfo.GetCurrencyListInfo(i)
			if not currencyInfo.isHeader then
				self:AddDoubleLine(format("|T%s:0|t %s", currencyInfo.iconFileID, currencyInfo.name), currencyInfo.quantity, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			else
				local nextCurrencyInfo = C_CurrencyInfo.GetCurrencyListInfo(i + 1)
				if nextCurrencyInfo and not nextCurrencyInfo.isHeader then
					self:AddLine(currencyInfo.name)
				end
			end
		end
	end
})