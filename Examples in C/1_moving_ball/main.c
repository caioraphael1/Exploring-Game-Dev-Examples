/* 
clang main.c -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
*/

#include "../raylib/include/raylib.h"


int main(void) {
    const int SCREEN_WIDTH  = 800;
    const int SCREEN_HEIGHT = 450;

    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C | 1_moving_ball");
    SetTargetFPS(60);

    // Initialize ball
    Vector2 ball_position = { (float)SCREEN_WIDTH/2, (float)SCREEN_HEIGHT/2 };

    while (!WindowShouldClose()) {
        // Update ball position
        if (IsKeyDown(KEY_RIGHT)) ball_position.x += 2.0f;
        if (IsKeyDown(KEY_LEFT))  ball_position.x -= 2.0f;
        if (IsKeyDown(KEY_UP))    ball_position.y -= 2.0f;
        if (IsKeyDown(KEY_DOWN))  ball_position.y += 2.0f;

        // Draw
        BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawText("move the ball with arrow keys", 10, 10, 20, DARKGRAY);
        DrawCircleV(ball_position, 50, MAROON);
        
        EndDrawing();
    }

    CloseWindow();

    return 0;
}
