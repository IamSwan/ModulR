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
function ModulREventBus:Subscribe(eventName: string, subscriberService: ModulRInterfaces.Service, callback: (any) -> any)
    if not subscribers[eventName] then
        subscribers[eventName] = {}
    end

    if not subscribers[eventName][subscriberService] then
        subscribers[eventName][subscriberService] = {}
    end

    table.insert(subscribers[eventName][subscriberService], callback)
end

function ModulREventBus:Unsubscribe(eventName: string, subscriberService: ModulRInterfaces.Service)
    if not subscribers[eventName] or not subscribers[eventName][subscriberService] then
        return
    end

    subscribers[eventName][subscriberService] = nil
end

function ModulREventBus:Clear()
    subscribers = {}
end

function ModulREventBus:Broadcast(eventName)
    if not subscribers[eventName] then
        return
    end

    for service, callbacks in pairs(subscribers[eventName]) do
        for _, callback in ipairs(callbacks) do
            local success, err = pcall(callback)
            if not success then
                warn("Error in event callback for '" .. eventName .. "': " .. tostring(err))
            end
        end
    end
end

return ModulREventBus
