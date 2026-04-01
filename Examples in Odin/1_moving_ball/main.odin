package main

/* 
odin run .
*/

import rl "vendor:raylib"


main :: proc() {
    SCREEN_WIDTH  :: 800
    SCREEN_HEIGHT :: 450

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Odin | 1_moving_ball")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    // Initialize ball
    ball_position := rl.Vector2{ SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 }

    for !rl.WindowShouldClose() {
        // Update ball position
        if rl.IsKeyDown(.RIGHT) { ball_position.x += 2.0 }
        if rl.IsKeyDown(.LEFT)  { ball_position.x -= 2.0 }
        if rl.IsKeyDown(.UP)    { ball_position.y -= 2.0 }
        if rl.IsKeyDown(.DOWN)  { ball_position.y += 2.0 }

        // Draw
        { 
            rl.BeginDrawing()
            defer rl.EndDrawing()
            rl.ClearBackground(rl.WHITE)
            
            rl.DrawText("move the ball with arrow keys", 10, 10, 20, rl.DARKGRAY)
            rl.DrawCircleV(ball_position, 50, rl.MAROON)
        }
    }
}
