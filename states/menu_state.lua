local Menu = {}
function Menu:update(dt) end
function Menu:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("SNAKE GAME", 0, 200, 600, "center")
    love.graphics.printf("Press ENTER to play\nArrows / WASD to move\nESC to quit", 0, 270, 600, "center")
end
function Menu:keypressed(key, manager)
    if key == "return" or key == "space" then manager:switch("playing") end
end
return Menu
