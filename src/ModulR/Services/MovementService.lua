--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)

--|| Module ||--
local MovementService: ModulRInterfaces.Service = {
    Client = {},
    Shared = {},
}

function MovementService:Initialize()
    print("[MovementService] - MovementService initialized.")
    ModulR:GetEventBus():Broadcast("MovementServiceInit")
    return self
end

function MovementService:Destroy()
    print("[MovementService] - MovementService destroyed.")
end

function MovementService.Client:DoubleJump()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        local vector = Vector3.new(0, 150, 0) -- Example jump force
        character.HumanoidRootPart.AssemblyLinearVelocity = vector
    else
        warn("[MovementService] - Humanoid not found for", player.Name)
    end
end

function MovementService.Client:Dash()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local dashSpeed = 120 -- Example dash speed
        local direction = character.HumanoidRootPart.CFrame.LookVector
        character.HumanoidRootPart.AssemblyLinearVelocity = direction * dashSpeed
    else
        warn("[MovementService] - Humanoid not found for", player.Name)
    end
end

function MovementService.Client:WallRide()
end

return MovementService
