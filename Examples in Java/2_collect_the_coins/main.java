import com.raylib.Jaylib.*;
import static com.raylib.Jaylib.*;

public class CollectTheCoins {

    static final int MAX_COINS = 20;
    static final float PLAYER_SPEED = 4.0f;

    static class Player {
        Vector2 position;
        float radius;
        int score;

        Player(Vector2 pos, float r) {
            this.position = pos;
            this.radius = r;
            this.score = 0;
        }
    }

    static class Coin {
        Vector2 position;
        float radius;
        boolean active;

        Coin(Vector2 pos, float r) {
            this.position = pos;
            this.radius = r;
            this.active = true;
        }
    }

    public static void main(String[] args) {
        final int SCREEN_WIDTH = 800;
        final int SCREEN_HEIGHT = 600;

        InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Java | 2_collect_the_coins");
        SetTargetFPS(60);

        // Initialize player
        Player player = new Player(new Vector2(400, 300), 20);

        // Initialize coins
        Coin[] coins = new Coin[MAX_COINS];
        for (int i = 0; i < MAX_COINS; i++) {
            coins[i] = new Coin(
                new Vector2(
                    GetRandomValue(20, SCREEN_WIDTH - 20),
                    GetRandomValue(20, SCREEN_HEIGHT - 20)
                ),
                8
            );
        }

        while (!WindowShouldClose()) {
            // Update player
            if (IsKeyDown(KEY_W)) player.position.y -= PLAYER_SPEED;
            if (IsKeyDown(KEY_S)) player.position.y += PLAYER_SPEED;
            if (IsKeyDown(KEY_A)) player.position.x -= PLAYER_SPEED;
            if (IsKeyDown(KEY_D)) player.position.x += PLAYER_SPEED;

            // Check collisions
            for (int i = 0; i < MAX_COINS; i++) {
                if (coins[i].active) {
                    float dist = Vector2Distance(player.position, coins[i].position);
                    if (dist < player.radius + coins[i].radius) {
                        coins[i].active = false;
                        player.score += 1;
                    }
                }
            }

            // Draw
            BeginDrawing();
            ClearBackground(DARKGREEN);

            DrawCircleV(player.position, player.radius, BLUE);
            for (Coin coin : coins) {
                if (coin.active) {
                    DrawCircleV(coin.position, coin.radius, GOLD);
                }
            }
            DrawText(TextFormat("Score: %d", player.score), 10, 10, 20, WHITE);

            EndDrawing();
        }

        CloseWindow();
    }
}
