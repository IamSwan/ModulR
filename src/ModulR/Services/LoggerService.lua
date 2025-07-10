--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local LoggerService: ModulRInterfaces.Service = {}

function LoggerService:Initialize()
    self.Name = "LoggerService"
    self.Server = {}
    self.Client = {}

    ModulR:GetEventBus():Subscribe("Info1", self, function()
        print("[LoggerService] - Info1 event received.")
    end)
    return self
end

return LoggerService
