# Snake Game — Lua / LÖVE2D

Run the folder in LÖVE 11.x: `love .` (if on PATH), or from Git Bash:

```bash
"/c/Program Files/LOVE/love.exe" .
```

Enter/Space starts from the menu. Arrow keys/WASD change direction. Escape quits. Space returns to the menu after game over.

Files implement game states, an entity with Position/Movement/Renderer components, Vector2 metamethods, a command-based input system, a high-score saver, and a bonus observer/event system.

**Modern Lua feature:** `Vector2.__add` is a metamethod letting the snake use `head + direction` to combine vectors. High scores use `love.filesystem` rather than Lua 5.4 `<close>`, since LÖVE 11 uses LuaJIT and does not support Lua 5.4 to-be-closed declarations.
