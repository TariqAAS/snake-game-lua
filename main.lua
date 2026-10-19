local GameState = require("gamestate")
local Events = require("events")

Events:subscribe("food_eaten", function(data)
    print("Food eaten! Score:", data.score)
end)
local manager
function love.load()
    love.window.setMode(600, 600)
    love.window.setTitle("Snake Game - Lua Assignment")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)
    love.filesystem.setIdentity("lua_assignment_snake")
    manager = GameState:new()
end
function love.update(dt) manager:update(dt) end
function love.draw() manager:draw() end
function love.keypressed(key)
    if key == "escape" then love.event.quit(); return end
    manager:keypressed(key)
end
