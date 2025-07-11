--|| Test ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

local test = {
    Client = {},
    Server = {},
    Shared = {}
}

function test:Initialize()
    ModulR:GetEventBus():Broadcast("TestServiceInit")
    return self
end

function test:Destroy()
    ModulR:GetEventBus():Unsubscribe("TestServiceInit", self)
    print("[TestService] - TestService destroyed.")
end

function test.Shared:TestMethod()
    print("TestMethod called from TestService")
end

return test
