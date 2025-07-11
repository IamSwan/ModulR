local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LevelService", require(game.ReplicatedStorage.ModulR.Services.LevelService))
ModulR:AddService("CombatService", require(game.ReplicatedStorage.ModulR.Services.CombatService))
ModulR:Initialize()

local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "Remotes"
remoteFolder.Parent = game.ReplicatedStorage

local combatRemote = Instance.new("RemoteEvent")
combatRemote.Name = "CombatRemote"
combatRemote.Parent = remoteFolder

local combatService = ModulR:GetService("CombatService")

-- Example usage of CombatService
combatRemote.OnServerEvent:Connect(function(player, action, ...)
    if action == "Attack" then
        local damage = select(1, ...)
        combatService:Attack(player, damage)
    elseif action == "Block" then
        combatService:Block(player)
    end
end)
