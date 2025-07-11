--|| Test ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

local test = {}

function test:Initialize()
    ModulR:GetEventBus():Broadcast("TestServiceInit")
    return self
end

function test:TestMethod()
    print("TestMethod called from TestService")
end

return test
