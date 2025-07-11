--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)
local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")

--|| Module ||--
local LevelService: ModulRInterfaces.Service = {
    Client = {},
    Server = {},
    Shared = {}
}

local function onPlayerAdded(player: Player)
    player:SetAttribute("Level", 1)
    player:SetAttribute("Experience", 0)
    player:SetAttribute("NeededExperience", 1000)
    player:GetAttributeChangedSignal("Experience"):Connect(function()
        if LevelService.Server:CanLevelUp(player) then
            LevelService.Server:LevelUp(player)
            LevelService.Shared:LogLevelChange(player, player:GetAttribute("Level"))
        end
    end)
    player:GetAttributeChangedSignal("NeededExperience"):Connect(function()
        if LevelService.Server:CanLevelUp(player) then
            LevelService.Server:LevelUp(player)
            LevelService.Shared:LogLevelChange(player, player:GetAttribute("Level"))
        end
    end)
end

function LevelService:Initialize()
    if RunService:IsServer() then
        for _, player in ipairs(PlayerService:GetPlayers()) do
            onPlayerAdded(player)
        end
        PlayerService.PlayerAdded:Connect(onPlayerAdded)
    end
    ModulR:GetEventBus():Broadcast("LevelServiceInit")
    return self
end

function LevelService:Destroy()
    ModulR:GetEventBus():Unsubscribe("LevelServiceInit", self)
    print("[LevelService] - LevelService destroyed.")
end

function LevelService.Server:GetExp(player: Player)
    return player:GetAttribute("Experience")
end

function LevelService.Server:SetExp(player: Player, exp: number)
    player:SetAttribute("Experience", exp)
end

function LevelService.Server:GetNeededExp(player: Player)
    return player:GetAttribute("NeededExperience")
end

function LevelService.Server:SetNeededExp(player: Player, neededExp: number)
    player:SetAttribute("NeededExperience", neededExp)
end

function LevelService.Server:CanLevelUp(player: Player)
    local currentExp = self:GetExp(player)
    local neededExp = self:GetNeededExp(player)
    return currentExp >= neededExp
end

function LevelService.Server:LevelUp(player: Player)
    local newNeededExp = self:GetNeededExp(player) * 1.1
    local newExp = self:GetNeededExp(player) - self:GetExp(player)
    self:SetExp(player, newExp)
    self:SetNeededExp(player, newNeededExp)
end

function LevelService.Client:FetchExp(player: Player)
    return player:GetAttribute("Experience")
end

function LevelService.Client:FetchNeededExp(player: Player)
    return player:GetAttribute("NeededExperience")
end

function LevelService.Shared:LogLevelChange(player: Player, level: number)
    print("[LevelService] - " .. player.Name .. " has reached level " .. level)
end

return LevelService
