/* 
clang++ main.cpp -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
Only for C++11 or newer.
*/

#include "../raylib/include/raylib.h"
#include "../raylib/include/raymath.h"

#include <array>
#include <vector>

constexpr int   MAX_BULLETS  = 64; // Comparing to C: Real language construction with type-checking
constexpr float BULLET_SPEED = 6.0f;

struct Player {
    Vector2 position{};
    float   radius{};
};

struct Bullet {
    Vector2 position{};
    Vector2 velocity{};
    float   radius{};
    bool    active{};
};

struct Enemy {
    Vector2 position{};
    float   radius{};
    bool    active{};
    Color   color{};
};

void spawn_bullet(std::array<Bullet, MAX_BULLETS>& bullets, Vector2 pos);
void spawn_inactive_enemies(std::vector<Enemy>& enemies);

int main() {
    constexpr int SCREEN_WIDTH  = 800;
    constexpr int SCREEN_HEIGHT = 600;

    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C++ | 3_space_invaders");
    SetTargetFPS(60);

    // Initialize player
    Player player{{400.0f, 500.0f}, 20.0f};
    std::array<Bullet, MAX_BULLETS> bullets{};  // Stack allocation

    // Initialize enemies
    std::vector<Enemy> enemies(20); // Heap allocation
    int enemies_destroyed_count = 0;
    spawn_inactive_enemies(enemies);

    while (!WindowShouldClose()) {
        // Update player
        if (IsKeyDown(KEY_A)) player.position.x -= 4.0f;
        if (IsKeyDown(KEY_D)) player.position.x += 4.0f;
        if (IsKeyDown(KEY_W)) player.position.y -= 4.0f;
        if (IsKeyDown(KEY_S)) player.position.y += 4.0f;
        if (IsKeyPressed(KEY_SPACE)) {
            spawn_bullet(bullets, player.position);
        }

        // Update bullets
        for (auto& b : bullets) {
            if (b.active) {
                b.position.x += b.velocity.x;
                b.position.y += b.velocity.y;

                if (b.position.y < 0) {
                    b.active = false;
                }
            }

        }

        // Update enemies
        int active_enemies = 0;
        for (auto& e : enemies) {
            if (e.active) {
                e.position.y += 0.5f;
                active_enemies += 1;
            }
        }

        // Respawn
        if (active_enemies < 5) {
            spawn_inactive_enemies(enemies);
        }

        // Collisions
        for (auto& b : bullets) {
            if (!b.active) continue;

            for (auto& e : enemies) {
                if (!e.active) continue;

                float d = Vector2Distance(b.position, e.position);
                float r = b.radius + e.radius;

                if (d < r) {
                    b.active = false;
                    e.active = false;
                    enemies_destroyed_count += 1;
                }
            }
        }

        // Draw
        BeginDrawing();
        ClearBackground(BLACK);

        DrawCircleV(player.position, player.radius, BLUE);

        for (const auto& b : bullets) {
            if (b.active) {
                DrawCircleV(b.position, b.radius, YELLOW);
            }
        }

        for (const auto& e : enemies) {
            if (e.active) {
                DrawCircleV(e.position, e.radius, e.color);
            }
        }

        DrawText("Space Invaders: WASD move | SPACE shoot", 10, 10, 20, WHITE);
        DrawText(TextFormat("Enemies destroyed: %d", enemies_destroyed_count),
                 10, 40, 20, YELLOW);

        EndDrawing();
    }

    CloseWindow();
    return 0;
}

// Spawn first inactive bullet
void spawn_bullet(std::array<Bullet, MAX_BULLETS>& bullets, Vector2 pos) {
    for (auto& b : bullets) {
        if (!b.active) {
            b.active   = true;
            b.position = pos;
            b.velocity = {0.0f, -BULLET_SPEED};
            b.radius   = 5.0f;
            return;
        }
    }
}

// Activate all inactive enemies
void spawn_inactive_enemies(std::vector<Enemy>& enemies) {
    for (auto& e : enemies) {
        if (!e.active) {
            e.position = {
                static_cast<float>(GetRandomValue(50, 750)),
                static_cast<float>(GetRandomValue(50, 300))
            };
            e.radius = 15.0f;
            e.active = true;
            e.color  = {
                static_cast<unsigned char>(GetRandomValue(100, 255)),
                static_cast<unsigned char>(GetRandomValue(100, 255)),
                static_cast<unsigned char>(GetRandomValue(100, 255)),
                255
            };
        }
    }
}
