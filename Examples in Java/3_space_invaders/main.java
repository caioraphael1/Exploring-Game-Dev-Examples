import com.raylib.Jaylib.*;
import static com.raylib.Jaylib.*;

public class SpaceInvadersJava {

    static final int   MAX_BULLETS  = 64;
    static final float BULLET_SPEED = 6.0f;

    static class Player {
        Vector2 position;
        float   radius;

        Player(Vector2 position, float radius) {
            this.position = position;
            this.radius   = radius;
        }
    }

    static class Bullet {
        Vector2 position;
        Vector2 velocity;
        float   radius;
        boolean active;

        Bullet() {
            this.active   = false;
            this.position = new Vector2();
            this.velocity = new Vector2();
            this.radius   = 0;
        }
    }

    static class Enemy {
        Vector2 position;
        float radius;
        boolean active;
        Color color;

        Enemy() {
            this.active   = false;
            this.position = new Vector2();
            this.color    = new Color();
        }
    }

    public static void spawnBullet(Bullet[] bullets, Vector2 pos) {
        for (Bullet b : bullets) {
            if (!b.active) {
                b.active = true;
                b.position = new Vector2(pos.x, pos.y);
                b.velocity = new Vector2(0, -BULLET_SPEED);
                b.radius = 5;
                return;
            }
        }
    }

    public static void spawnInactiveEnemies(Enemy[] enemies) {
        for (Enemy e : enemies) {
            if (!e.active) {
                e.position = new Vector2(GetRandomValue(50, 750), GetRandomValue(50, 300));
                e.radius = 15;
                e.active = true;
                e.color = new Color(
                        GetRandomValue(100, 255),
                        GetRandomValue(100, 255),
                        GetRandomValue(100, 255),
                        255
                );
            }
        }
    }

    public static void main(String[] args) {
        final int SCREEN_WIDTH = 800;
        final int SCREEN_HEIGHT = 600;

        InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Java | Space Invaders");
        SetTargetFPS(60);

        Player player = new Player(new Vector2(400, 500), 20);
        Bullet[] bullets = new Bullet[MAX_BULLETS];
        for (int i = 0; i < MAX_BULLETS; i++) bullets[i] = new Bullet();

        int enemiesCount = 20;
        Enemy[] enemies = new Enemy[enemiesCount];
        for (int i = 0; i < enemiesCount; i++) enemies[i] = new Enemy();

        int enemiesDestroyed = 0;
        spawnInactiveEnemies(enemies);

        while (!WindowShouldClose()) {

            // Player movement
            if (IsKeyDown(KEY_A)) player.position.x -= 4;
            if (IsKeyDown(KEY_D)) player.position.x += 4;
            if (IsKeyDown(KEY_W)) player.position.y -= 4;
            if (IsKeyDown(KEY_S)) player.position.y += 4;
            if (IsKeyPressed(KEY_SPACE)) spawnBullet(bullets, player.position);

            // Update bullets
            for (Bullet b : bullets) {
                if (b.active) {
                    b.position.x += b.velocity.x;
                    b.position.y += b.velocity.y;
                    if (b.position.y < 0) b.active = false;
                }
            }

            // Update enemies
            int activeEnemies = 0;
            for (Enemy e : enemies) {
                if (e.active) {
                    e.position.y += 0.5f;
                    activeEnemies++;
                }
            }

            // Respawn enemies if needed
            if (activeEnemies < 5) spawnInactiveEnemies(enemies);

            // Collision detection
            for (Bullet b : bullets) {
                if (!b.active) continue;
                for (Enemy e : enemies) {
                    if (!e.active) continue;
                    float d = Vector2Distance(b.position, e.position);
                    float r = b.radius + e.radius;
                    if (d < r) {
                        b.active = false;
                        e.active = false;
                        enemiesDestroyed++;
                    }
                }
            }

            BeginDrawing();
            ClearBackground(BLACK);

            DrawCircleV(player.position, player.radius, BLUE);

            for (Bullet b : bullets)
                if (b.active) DrawCircleV(b.position, b.radius, YELLOW);

            for (Enemy e : enemies)
                if (e.active) DrawCircleV(e.position, e.radius, e.color);

            DrawText("Space Invaders: WASD move | SPACE shoot", 10, 10, 20, WHITE);
            DrawText(String.format("Enemies destroyed: %d", enemiesDestroyed), 10, 40, 20, YELLOW);

            EndDrawing();
        }

        CloseWindow();
    }
}
