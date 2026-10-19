local SnakeGame = require("snake_game")
local Input = require("input")
local Playing = {game = nil, input = nil}
function Playing:enter()
    self.game = SnakeGame:new()
    self.input = Input:new()
    self.input:bind("up", function() self.game:changeDirection(0, -1) end)
    self.input:bind("w", function() self.game:changeDirection(0, -1) end)
    self.input:bind("down", function() self.game:changeDirection(0, 1) end)
    self.input:bind("s", function() self.game:changeDirection(0, 1) end)
    self.input:bind("left", function() self.game:changeDirection(-1, 0) end)
    self.input:bind("a", function() self.game:changeDirection(-1, 0) end)
    self.input:bind("right", function() self.game:changeDirection(1, 0) end)
    self.input:bind("d", function() self.game:changeDirection(1, 0) end)
end
function Playing:update(dt) self.game:update(dt) end
function Playing:draw() self.game:draw() end
function Playing:keypressed(key, manager)
    if self.game.gameOver and (key == "space" or key == "return") then
        manager:switch("menu")
    else
        self.input:handleKey(key)
    end
end
return Playing
