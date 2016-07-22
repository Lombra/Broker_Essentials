local Libra = LibStub("Libra")
local LDB = LibStub("LibDataBroker-1.1")

local addon = Libra:NewAddon(...)
Libra:Embed(addon)

function addon:OnInitialize()
	Broker_EssentialsDB = Broker_EssentialsDB or {}
end

local function getDB(self, defaults)
	Broker_EssentialsDB[self.name] = Broker_EssentialsDB[self.name] or defaults or {}
	return Broker_EssentialsDB[self.name]
end

function addon:OnModuleCreated(name, data)
	LDB:NewDataObject(name, data)
	data.GetDB = getDB
end