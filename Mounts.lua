local _, core = ...

local function onClick(self, mountID)
	C_MountJournal.SummonByID(mountID)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self, level)
	for i, mountID in ipairs(C_MountJournal.GetMountIDs()) do
		local creatureName, _, icon, active, isUsable, _, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
		if isFavorite and isUsable then
			local info = UIDropDownMenu_CreateInfo()
			info.text = creatureName
			info.icon = icon
			info.func = onClick
			info.arg1 = mountID
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