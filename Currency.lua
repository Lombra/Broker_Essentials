local _, core = ...

local module = core:NewModule("Currency", {
	type = "data source",
	label = CURRENCY,
	icon = [[Interface\Icons\Spell_Holy_ChampionsBond]],
	OnClick = function(self) ToggleCharacter("TokenFrame") end,
	OnTooltipShow = function(self)
		self:AddLine("Broker: Currency", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		for i = 1, GetCurrencyListSize() do
			local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(i)
			if not isHeader then
				self:AddDoubleLine(format("|T%s:0|t %s", icon, name), count, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			else
				local nextName, nextIsHeader = GetCurrencyListInfo(i + 1)
				if nextName and not nextIsHeader then
					self:AddLine(name)
				end
			end
		end
	end
})