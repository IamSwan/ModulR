--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)
local RunService = game:GetService("RunService")

--|| Module ||--
local LevelService: ModulRInterfaces.Service = {
    Client = {},
    Server = {},
    Shared = {}
}

function LevelService:Initialize()
    if not RunService:IsServer() then
        error("LevelService can only be initialized on the server.")
    end

    ModulR:GetEventBus():Broadcast("LevelServiceInit")
    return self
end

function LevelService:Destroy()
    ModulR:GetEventBus():Unsubscribe("LevelServiceInit", self)
    print("[LevelService] - LevelService destroyed.")
end

function LevelService.Server:GetExp(player: Player)
    print(player.Name)
    return 100
end

function LevelService.Server:SetExp(player: Player, exp: number)
    print(player.Name .. " has been set to " .. exp .. " experience points.")
end

function LevelService.Server:GetNeededExp(player: Player)
    print("Max experience for " .. player.Name .. " is 1000.")
    return 1000 -- Example max experience
end

function LevelService.Server:CanLevelUp(player: Player)
    local currentExp = self:GetExp(player)
    local neededExp = self:GetNeededExp(player)
    return currentExp >= neededExp
end

function LevelService.Client:RequestExp(player: Player)
    print("Client requested experience for " .. player.Name)
    -- Here you would typically send a request to the server to get the player's experience.
end

function LevelService.Shared:LogLevelChange(player: Player, level: number)
    print("[LevelService] - " .. player.Name .. " has reached level " .. level)
end

return LevelService
