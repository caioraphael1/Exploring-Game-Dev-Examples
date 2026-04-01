/* 
clang main.c -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
*/

#include "../raylib/include/raylib.h"
#include "../raylib/include/raymath.h"

#include <stdbool.h>

#define MAX_COINS 20
#define PLAYER_SPEED 4.0f

typedef struct Player {
    Vector2 position;
    float   radius;
    int     score;
} Player;

typedef struct Coin {
    Vector2 position;
    float   radius;
    bool    active;
} Coin;

int main(void) {
    const int SCREEN_WIDTH = 800;
    const int SCREEN_HEIGHT = 600;

    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C | 2_collect_the_coins");
    SetTargetFPS(60);

    // Initialize player
    Player player = {0};
    player.position = (Vector2){400, 300};
    player.radius = 20;
    player.score = 0;

    // Initialize coins
    Coin coins[MAX_COINS];
    for (int i = 0; i < MAX_COINS; i++) {
        coins[i].position = (Vector2){
            GetRandomValue(20, SCREEN_WIDTH - 20),
            GetRandomValue(20, SCREEN_HEIGHT - 20)
        };
        coins[i].radius = 8;
        coins[i].active = true;
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
        for (int i = 0; i < MAX_COINS; i++) {
            if (coins[i].active) {
                DrawCircleV(coins[i].position, coins[i].radius, GOLD);
            }
        }
        DrawText(TextFormat("Score: %d", player.score), 10, 10, 20, WHITE);

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
