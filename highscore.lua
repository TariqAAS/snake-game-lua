local HighScore = {}
-- LÖVE uses LuaJIT, so Lua 5.4's 'local file <close>' is not supported.
-- love.filesystem provides safe, portable save data instead.
function HighScore:save(score)
    return love.filesystem.write("highscore.txt", tostring(score))
end
function HighScore:load()
    local contents = love.filesystem.read("highscore.txt")
    return tonumber(contents) or 0
end
return HighScore
