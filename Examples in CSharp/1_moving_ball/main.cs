using System.Numerics;
using Raylib_cs;

class Program {
    static void Main() {
        const int SCREEN_WIDTH  = 800;
        const int SCREEN_HEIGHT = 450;

        Raylib.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C#");
        Raylib.SetTargetFPS(60);

        Vector2 ball_position = new Vector2(SCREEN_WIDTH / 2f, SCREEN_HEIGHT / 2f);

        while (!Raylib.WindowShouldClose()) {
            if (Raylib.IsKeyDown(KeyboardKey.Right)) ball_position.X += 2f;
            if (Raylib.IsKeyDown(KeyboardKey.Left))  ball_position.X -= 2f;
            if (Raylib.IsKeyDown(KeyboardKey.Up))    ball_position.Y -= 2f;
            if (Raylib.IsKeyDown(KeyboardKey.Down))  ball_position.Y += 2f;

            Raylib.BeginDrawing();
            Raylib.ClearBackground(Color.RayWhite);

            Raylib.DrawText("Move the ball with arrow keys", 10, 10, 20, Color.DarkGray);
            Raylib.DrawCircleV(ball_position, 50, Color.Maroon);

            Raylib.EndDrawing();
        }

        Raylib.CloseWindow();
    }
}
