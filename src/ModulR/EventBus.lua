--|| ModulR ||--

--|| Event Bus Module ||--
local ModulREventBus = {}
ModulREventBus.__index = ModulREventBus

--|| Private Attributes ||--
local bus = {}

--|| Destructor ||--
function ModulREventBus:Destroy()
    self:Clear()
end

--|| Public Methods ||--
function ModulREventBus:Subscribe(eventName: string, callback: () -> any)
    if not bus[eventName] then
        bus[eventName] = {}
    end
    table.insert(bus[eventName], callback)
end

function ModulREventBus:Unsubscribe(eventName: string): boolean
    if not bus[eventName] then
        return false
    end
    bus[eventName] = nil
    return true
end

function ModulREventBus:Publish(eventName: string, ...)
    if not bus[eventName] then
        return false
    end
    for _, callback in ipairs(bus[eventName]) do
        callback(...)
    end
    return true
end

function ModulREventBus:Clear()
    bus = {}
end

function ModulREventBus:GetEvents(): {[string]: () -> any}
    return bus
end

function ModulREventBus:HasEvent(eventName: string): boolean
    return bus[eventName] ~= nil
end
