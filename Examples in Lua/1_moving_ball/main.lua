--[[
lua55 main.lua
]]

local rl = require("raylib")

local SCREEN_WIDTH  = 800
local SCREEN_HEIGHT = 450

rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C | 1_moving_ball")
rl.SetTargetFPS(60)

-- Initialize ball
local ball_position = { 
    x = SCREEN_WIDTH / 2, 
    y = SCREEN_HEIGHT / 2 
}

while not rl.WindowShouldClose() do
    -- Update ball position
    if rl.IsKeyDown(rl.KEY_RIGHT) then ball_position.x = ball_position.x + 2.0 end
    if rl.IsKeyDown(rl.KEY_LEFT)  then ball_position.x = ball_position.x - 2.0 end
    if rl.IsKeyDown(rl.KEY_UP)    then ball_position.y = ball_position.y - 2.0 end
    if rl.IsKeyDown(rl.KEY_DOWN)  then ball_position.y = ball_position.y + 2.0 end

    -- Draw
    rl.BeginDrawing()
    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawText("move the ball with arrow keys", 10, 10, 20, rl.DARKGRAY)
    rl.DrawCircleV(ball_position, 50, rl.MAROON)
    
    rl.EndDrawing()
end

rl.CloseWindow()
