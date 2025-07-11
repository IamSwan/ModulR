local ModulR = require(game.ReplicatedStorage.ModulR)

ModulR:AddService("LevelService", require(game.ReplicatedStorage.ModulR.Services.LevelService))
ModulR:AddService("CombatService", require(game.ReplicatedStorage.ModulR.Services.CombatService))
ModulR:Initialize()

local CombatService = ModulR:GetService("CombatService")

-- Example usage of CombatService
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        CombatService:Attack()
    end
    if input.KeyCode == Enum.KeyCode.F then
        CombatService:Block()
    end
end)

uis.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F then
        CombatService:BlockEnd()
    end
end)
