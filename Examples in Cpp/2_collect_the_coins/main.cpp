/*
clang++ main.cpp -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
Only for C++11 or newer.
*/

#include "../raylib/include/raylib.h"
#include "../raylib/include/raymath.h"

#include <array>

constexpr int   MAX_COINS    = 20; // Comparing to C: Real language construction with type-checking
constexpr float PLAYER_SPEED = 4.0;

struct Player {
    Vector2 position{}; // Zero-initialized by default.
    float   radius{};
    int     score{};
};

struct Coin {
    Vector2 position{};
    float   radius{};
    bool    active{};
};

int main() {
    const int SCREEN_WIDTH  = 800;
    const int SCREEN_HEIGHT = 600;

    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C++ | 2_collect_the_coins");
    SetTargetFPS(60);

    // Initialize player
    Player player{};
    player.position = {400.0, 300.0};
    player.radius   = 20.0;
    player.score    = 0;

    // Initialize coins
    std::array<Coin, MAX_COINS> coins{};
    for (auto& coin : coins) {
        coin.position = {
            static_cast<float>(GetRandomValue(20, SCREEN_WIDTH - 20)),
            static_cast<float>(GetRandomValue(20, SCREEN_HEIGHT - 20))
        };
        coin.radius = 8.0;
        coin.active = true;
    }

    while (!WindowShouldClose()) {
        // Update player
        if (IsKeyDown(KEY_W)) player.position.y -= PLAYER_SPEED;
        if (IsKeyDown(KEY_S)) player.position.y += PLAYER_SPEED;
        if (IsKeyDown(KEY_A)) player.position.x -= PLAYER_SPEED;
        if (IsKeyDown(KEY_D)) player.position.x += PLAYER_SPEED;

        // Check collisions
        for (auto& coin : coins) {
            if (coin.active) {
                float dist = Vector2Distance(player.position, coin.position);

                if (dist < player.radius + coin.radius) {
                    coin.active = false;
                    player.score += 1;
                }
            }
        }

        // Draw
        BeginDrawing();
        ClearBackground(DARKGREEN);

        DrawCircleV(player.position, player.radius, BLUE);
        for (const auto& coin : coins) {
            if (coin.active) {
                DrawCircleV(coin.position, coin.radius, GOLD);
            }
        }
        DrawText(TextFormat("Score: %d", player.score), 10, 10, 20, WHITE);

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
