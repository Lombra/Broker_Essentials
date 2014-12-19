local _, core = ...

local chores = {
	["World bosses"] = {
		Sha = 32099,
		Galleon = 32098,
		Nalak = 32518,
		Oondasta = 32519,
	},
	["Isle of Thunder"] = {
		Incantation = 32611,
		Trove = 32609,
		LeiShenKey = 32626,
		["Shan'ze Ritual Stone"] = 32610,
		Chamberlain = 32505,
	},
}

local module = core:NewModule("Chores", {
	type = "data source",
	label = "Chores",
	icon = [[Interface\GossipFrame\AvailableQuestIcon]],
	OnTooltipShow = function(self)
		self:AddLine("Chores", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		for type, v in pairs(chores) do
			self:AddLine(" ")
			self:AddLine(type)
			for chore, quest in pairs(v) do
				local complete, color
				if IsQuestFlaggedCompleted(quest) then
					complete, color = "Yes", GREEN_FONT_COLOR
				else
					complete, color = "No", RED_FONT_COLOR
				end
				self:AddDoubleLine(chore, complete, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, color.r, color.g, color.b)
			end
		end
	end
})