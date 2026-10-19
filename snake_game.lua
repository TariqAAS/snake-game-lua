local Vector2 = require("vector2")
local Entity = require("entity")
local HighScore = require("highscore")
local Events = require("events")
local SnakeGame = {}
SnakeGame.__index = SnakeGame
local GRID, CELL, STEP_TIME = 20, 30, 0.12

function SnakeGame:new()
    local game = setmetatable({}, SnakeGame)
    game:reset()
    return game
end

function SnakeGame:reset()
    self.snake = {Vector2:new(10,10), Vector2:new(9,10), Vector2:new(8,10)}
    self.direction = Vector2:new(1,0)
    self.nextDirection = Vector2:new(1,0)
    self.timer, self.score, self.gameOver = 0, 0, false
    self.highScore = HighScore:load()
    self.entity = Entity:new()
    self.entity:addComponent("Position", self.snake[1])
    self.entity:addComponent("Movement", self.direction)
    self.entity:addComponent("Renderer", {color = {0.3, 0.9, 0.4}, size = CELL})
    self:spawnFood()
end

function SnakeGame:spawnFood()
    local free = {}
    for y = 0, GRID - 1 do
        for x = 0, GRID - 1 do
            local spot = Vector2:new(x,y)
            local occupied = false
            for _, seg in ipairs(self.snake) do
                if seg == spot then occupied = true; break end
            end
            if not occupied then free[#free + 1] = spot end
        end
    end
    self.food = #free > 0 and free[love.math.random(#free)] or nil
end

function SnakeGame:changeDirection(dx, dy)
    if self.gameOver then return end
    -- Compare with current direction to prevent instant 180-degree turns.
    if dx == -self.direction.x and dy == -self.direction.y then return end
    if (math.abs(dx) + math.abs(dy)) ~= 1 then return end
    self.nextDirection = Vector2:new(dx,dy)
end

function SnakeGame:moveSnake()
    self.direction = self.nextDirection
    local nextHead = self.snake[1] + self.direction -- Vector2 __add metamethod
    if nextHead.x < 0 or nextHead.x >= GRID or nextHead.y < 0 or nextHead.y >= GRID then
        self.gameOver = true
        return
    end
    local eating = self.food and (nextHead == self.food)
    -- The tail leaves its old position on ordinary moves, so don't collide with it.
    local lastToCheck = #self.snake - (eating and 0 or 1)
    for i = 1, lastToCheck do
        if nextHead == self.snake[i] then
            self.gameOver = true
            return
        end
    end
    table.insert(self.snake, 1, nextHead)
    self.entity:addComponent("Position", nextHead)
    self.entity:addComponent("Movement", self.direction)
    if eating then
        self.score = self.score + 1
        Events:emit("food_eaten", {score = self.score})
        if self.score > self.highScore then
            self.highScore = self.score
            HighScore:save(self.highScore)
        end
        self:spawnFood()
        if not self.food then self.gameOver = true end
    else
        table.remove(self.snake)
    end
end

function SnakeGame:update(dt)
    if self.gameOver then return end
    self.timer = self.timer + dt
    while self.timer >= STEP_TIME and not self.gameOver do
        self.timer = self.timer - STEP_TIME
        self:moveSnake()
    end
end

function SnakeGame:draw()
    if self.food then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.rectangle("fill", self.food.x*CELL, self.food.y*CELL, CELL-2, CELL-2)
    end
    for i, seg in ipairs(self.snake) do
        if i == 1 then love.graphics.setColor(0.6, 1, 0.6)
        else love.graphics.setColor(0.3, 0.9, 0.4) end
        love.graphics.rectangle("fill", seg.x*CELL, seg.y*CELL, CELL-2, CELL-2)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: "..self.score.."   Best: "..self.highScore, 10, 10)
    if self.gameOver then
        love.graphics.setColor(0, 0, 0, 0.75)
        love.graphics.rectangle("fill", 0, 0, GRID*CELL, GRID*CELL)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("GAME OVER\nScore: "..self.score.."\nPress SPACE for menu", 0, 245, 600, "center")
    end
end
return SnakeGame
