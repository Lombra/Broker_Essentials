local _, core = ...

local function onClick(self, index)
	C_MountJournal.Summon(index)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self, level)
	for i = 1, C_MountJournal.GetNumMounts() do
		local creatureName, _, icon, active, isUsable, _, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfo(i)
		if isFavorite and isUsable then
			local info = UIDropDownMenu_CreateInfo()
			info.text = creatureName
			info.icon = icon
			info.func = onClick
			info.arg1 = i
			info.notCheckable = true
			self:AddButton(info)
		end
	end
end

local module = core:NewModule("Mounts", {
	type = "data source",
	label = "Mounts",
	icon = [[Interface\Icons\MountJournalPortrait]],
	OnClick = function(self)
		dropdown:Toggle(nil, self)
	end,
})