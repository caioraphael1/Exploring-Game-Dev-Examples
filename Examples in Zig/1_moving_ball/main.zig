const std = @import("std");
const rl = @import("../raylib/src/raylib.zig");

pub fn main() void {
    const SCREEN_WIDTH: i32 = 800;
    const SCREEN_HEIGHT: i32 = 450;

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Zig | 1_moving_ball");
    rl.SetTargetFPS(60);

    var ball_position = rl.Vector2{
        .x = SCREEN_WIDTH / 2.0,
        .y = SCREEN_HEIGHT / 2.0,
    };

    while (!rl.WindowShouldClose()) : (void) {
        // Update ball position
        if (rl.IsKeyDown(rl.KEY_RIGHT)) ball_position.x += 2.0;
        if (rl.IsKeyDown(rl.KEY_LEFT))  ball_position.x -= 2.0;
        if (rl.IsKeyDown(rl.KEY_UP))    ball_position.y -= 2.0;
        if (rl.IsKeyDown(rl.KEY_DOWN))  ball_position.y += 2.0;

        // Draw
        rl.BeginDrawing();
        rl.ClearBackground(rl.RAYWHITE);

        rl.DrawText("move the ball with arrow keys", 10, 10, 20, rl.DARKGRAY);
        rl.DrawCircleV(ball_position, 50.0, rl.MAROON);

        rl.EndDrawing();
    }

    rl.CloseWindow();
}
