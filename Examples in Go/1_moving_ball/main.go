/*
go run main.go
*/

package main

import (
	rl "github.com/gen2brain/raylib-go/raylib"
)

func main() {
    const SCREEN_WIDTH = 800
    const SCREEN_HEIGHT = 450

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Go | 1_moving_ball")
    rl.SetTargetFPS(60)

    // Initialize ball
    ball_position := rl.Vector2{X: SCREEN_WIDTH / 2.0, Y: SCREEN_HEIGHT / 2.0}

    for !rl.WindowShouldClose() {
        // Update ball position
        if rl.IsKeyDown(rl.KeyRight) {
            ball_position.X += 2.0
        }
        if rl.IsKeyDown(rl.KeyLeft) {
            ball_position.X -= 2.0
        }
        if rl.IsKeyDown(rl.KeyUp) {
            ball_position.Y -= 2.0
        }
        if rl.IsKeyDown(rl.KeyDown) {
            ball_position.Y += 2.0
        }

        // Draw
        rl.BeginDrawing()
        rl.ClearBackground(rl.RayWhite)

        rl.DrawText("move the ball with arrow keys", 10, 10, 20, rl.DarkGray)
        rl.DrawCircleV(ball_position, 50.0, rl.Maroon)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
