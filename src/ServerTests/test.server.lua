local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LevelService", require(game.ReplicatedStorage.ModulR.Services.LevelService))
ModulR:AddService("CombatService", require(game.ReplicatedStorage.ModulR.Services.CombatService))
ModulR:AddService("StatusService", require(game.ReplicatedStorage.ModulR.Services.StatusService))
ModulR:Initialize()

local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "Remotes"
remoteFolder.Parent = game.ReplicatedStorage

local combatRemote = Instance.new("RemoteEvent")
combatRemote.Name = "CombatRemote"
combatRemote.Parent = remoteFolder

local combatService = ModulR:GetService("CombatService")
local StatusService = ModulR:GetService("StatusService")

-- Example usage of CombatService
combatRemote.OnServerEvent:Connect(function(player, action, ...)
    if action == "Attack" then
        local damage = select(1, ...)
        combatService:Attack(player.Character or player.CharacterAdded:Wait(), damage)
    elseif action == "Block" then
        combatService:Block(player.Character or player.CharacterAdded:Wait())
    elseif action == "BlockEnd" then
        combatService:BlockEnd(player.Character or player.CharacterAdded:Wait())
    end
end)

game.Players.PlayerAdded:Connect(function(player)
    StatusService:ApplyStatusEffect(player, "Stunned", 5)
end)
