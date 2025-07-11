local ModulR = require(game.ReplicatedStorage.ModulR)

local Players = game:GetService("Players")

ModulR:AddService("LevelService", require(game.ReplicatedStorage.ModulR.Services.LevelService))
ModulR:AddService("CombatService", require(game.ReplicatedStorage.ModulR.Services.CombatService))
ModulR:AddService("StatusService", require(game.ReplicatedStorage.ModulR.Services.StatusService))
ModulR:AddService("InventoryService", require(game.ReplicatedStorage.ModulR.Services.InventoryService))
ModulR:Initialize()

local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "Remotes"
remoteFolder.Parent = game.ReplicatedStorage

local combatRemote = Instance.new("RemoteEvent")
combatRemote.Name = "CombatRemote"
combatRemote.Parent = remoteFolder

local combatService = ModulR:GetService("CombatService")
local StatusService = ModulR:GetService("StatusService")
local inventoryService = ModulR:GetService("InventoryService")


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

task.wait(3)
for _, player in ipairs(Players:GetPlayers()) do
    inventoryService:PrintInventory(player)
    inventoryService:AddItem(player, "sword", 1, "A sharp sword.")
    inventoryService:AddItem(player, "fish")
    inventoryService:PrintInventory(player)
    inventoryService:RemoveItem(player, "sword", 1)
    inventoryService:PrintInventory(player)
end
