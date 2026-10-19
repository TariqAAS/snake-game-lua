local GameState = {}
GameState.__index = GameState

function GameState:new()
    local state = {
        current = "menu",
        states = {
            menu = require("states.menu_state"),
            playing = require("states.game_state")
        }
    }
    return setmetatable(state, GameState)
end

function GameState:switch(newState)
    assert(self.states[newState], "Unknown state: " .. tostring(newState))
    self.current = newState
    if self.states[newState].enter then self.states[newState]:enter() end
end

function GameState:update(dt)
    self.states[self.current]:update(dt)
end

function GameState:draw()
    self.states[self.current]:draw()
end

function GameState:keypressed(key)
    local state = self.states[self.current]
    if state.keypressed then state:keypressed(key, self) end
end

return GameState
