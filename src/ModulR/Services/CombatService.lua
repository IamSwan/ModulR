--|| ModulR ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Parent.Interfaces)
local Debris = game:GetService("Debris")

--|| Module ||--
local CombatService: ModulRInterfaces.Service = {
    Client = {},
    Server = {},
    Shared = {},
}

function CombatService:Initialize()
    print("[CombatService] - CombatService initialized.")
    ModulR:GetEventBus():Broadcast("CombatServiceInit")
    return self
end

function CombatService:Destroy()
    print("[CombatService] - CombatService destroyed.")
end

function CombatService.Server:Attack(source: Instance, damage: number)
    print("[CombatService] - Player", source.Name, "is attacking with damage:", damage)
    local sourceRootPart = source:FindFirstChild("HumanoidRootPart")
    if not sourceRootPart then
        warn("[CombatService] - HumanoidRootPart not found for", source.Name)
        return
    end
    local hitbox = Instance.new("Part")
    hitbox.Name = "Hitbox"
    hitbox.Size = Vector3.new(4, 4, 4)
    hitbox.CanCollide = false
    hitbox.BrickColor = BrickColor.new("Bright red")
    hitbox.Transparency = 0.8
    hitbox.Material = Enum.Material.Neon
    hitbox.Parent = source

    local weld = Instance.new("Weld")
    weld.Part0 = sourceRootPart
    weld.Part1 = hitbox
    weld.Parent = hitbox
    weld.C0 = CFrame.new(0, 0, -hitbox.Size.Z / 2)

    hitbox.Touched:Once(function(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            if humanoid:GetAttribute("Block") then
                damage *= .5
            end
            humanoid:TakeDamage(damage)
            print("[CombatService] - Hit detected on", character.Name, "with damage:", damage)
        end
    end)

    Debris:AddItem(hitbox, 0.5)
end

function CombatService.Client:Attack()
    print("[CombatService] - Starting combat animation.")
    game.ReplicatedStorage.Remotes.CombatRemote:FireServer("Attack", 10)
end

function CombatService.Server:Block(source: Instance)
    print("[CombatService] - Entity", source.Name, "is blocking.")
    local humanoid = source:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:SetAttribute("Block", true)
        print("[CombatService] - Blocking enabled for", source.Name)
    else
        warn("[CombatService] - Humanoid not found for", source.Name)
    end
end

function CombatService.Server:BlockEnd(source: Instance)
    print("[CombatService] - Entity", source.Name, "has ended blocking.")
    local humanoid = source:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:SetAttribute("Block", false)
        print("[CombatService] - Blocking disabled for", source.Name)
    else
        warn("[CombatService] - Humanoid not found for", source.Name)
    end
end

function CombatService.Client:Block()
    print("[CombatService] - Starting block animation.")
    local character = game.Players.LocalPlayer.Character
    if not character then
        warn("[CombatService] - Character not found for blocking.")
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("[CombatService] - Humanoid not found for blocking.")
        return
    end
    humanoid.WalkSpeed = 5
    game.ReplicatedStorage.Remotes.CombatRemote:FireServer("Block")
end

function CombatService.Client:BlockEnd()
    print("[CombatService] - Ending block animation.")
    local character = game.Players.LocalPlayer.Character
    if not character then
        warn("[CombatService] - Character not found for ending block.")
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("[CombatService] - Humanoid not found for ending block.")
        return
    end
    humanoid.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed or 16
    game.ReplicatedStorage.Remotes.CombatRemote:FireServer("BlockEnd")
end

return CombatService
