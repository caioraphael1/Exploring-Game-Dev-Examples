/* 
Java 8 or newer
*/

import com.raylib.Jaylib.*;
import static com.raylib.Jaylib.*;

public class Main {
    public static void main(String[] args) {
        final int SCREEN_WIDTH = 800;
        final int SCREEN_HEIGHT = 450;

        InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Java | 1_moving_ball");
        SetTargetFPS(60);

        // Initialize ball
        Vector2 ballPosition = new Vector2(SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f);

        while (!WindowShouldClose()) {
            // Update ball position
            if (IsKeyDown(KEY_RIGHT)) ballPosition.x += 2.0f;
            if (IsKeyDown(KEY_LEFT))  ballPosition.x -= 2.0f;
            if (IsKeyDown(KEY_UP))    ballPosition.y -= 2.0f;
            if (IsKeyDown(KEY_DOWN))  ballPosition.y += 2.0f;

            // Draw
            BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawText("move the ball with arrow keys", 10, 10, 20, DARKGRAY);
            DrawCircleV(ballPosition, 50.0f, MAROON);

            EndDrawing();
        }

        CloseWindow();
    }
}
