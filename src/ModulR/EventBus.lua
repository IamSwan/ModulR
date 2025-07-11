--|| ModulR ||--

--|| Dependencies ||--
local ModulRInterfaces = require(script.Parent.Interfaces)

--|| Event Bus Module ||--
local ModulREventBus = {}
ModulREventBus.__index = ModulREventBus

--|| Private Attributes ||--
local subscribers = {}

--|| Destructor ||--
function ModulREventBus:Destroy()
    self:Clear()
end

--|| Public Methods ||--
function ModulREventBus:Subscribe(eventName: string, callback: (any) -> any)
    if not subscribers[eventName] then
        subscribers[eventName] = {}
    end

    table.insert(subscribers[eventName], callback)
end

function ModulREventBus:Unsubscribe(eventName: string, callback: (any) -> any)
    if not subscribers[eventName] then
        return
    end

    for i, cb in ipairs(subscribers[eventName]) do
        if cb == callback then
            table.remove(subscribers[eventName], i)
            break
        end
    end
end

function ModulREventBus:Clear()
    subscribers = {}
end

function ModulREventBus:Broadcast(eventName)
    if not subscribers[eventName] then
        return
    end

   for _, callback in ipairs(subscribers[eventName]) do
       local success, err = pcall(callback)
       if not success then
           warn("Error in event callback for '" .. eventName .. "': " .. tostring(err))
       end
   end
end

return ModulREventBus
