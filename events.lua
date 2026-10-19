local Events = {}
local listeners = {}
function Events:subscribe(event, callback)
    listeners[event] = listeners[event] or {}
    table.insert(listeners[event], callback)
end
function Events:emit(event, data)
    for _, callback in ipairs(listeners[event] or {}) do
        callback(data)
    end
end
return Events
