--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)
local RunService = game:GetService("RunService")

--|| Module ||--
local LevelService: ModulRInterfaces.Service = {
}

function LevelService:Initialize()
    if not RunService:IsServer() then
        error("LevelService can only be initialized on the server.")
    end

    ModulR:GetEventBus():Broadcast("LevelServiceInit")
    return self
end

return LevelService
