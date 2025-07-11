--|| Test ||--
local ModulR = require(game.ReplicatedStorage.ModulR)

local test = {}

function test:Initialize()
    ModulR:GetEventBus():Broadcast("TestServiceInit")
    return self
end

return test
