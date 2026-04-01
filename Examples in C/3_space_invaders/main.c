/* 
clang main.c -o main.exe -L../raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm
*/

#include "../raylib/include/raylib.h"
#include "../raylib/include/raymath.h"

#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

#define MAX_BULLETS  64
#define BULLET_SPEED 6.0f

typedef struct {
    Vector2 position;
    float   radius;
} Player;

typedef struct {
    Vector2 position;
    Vector2 velocity;
    float   radius;
    bool    active;
} Bullet;

typedef struct {
    Vector2 position;
    float   radius;
    bool    active;
    Color   color;
} Enemy;

void spawn_bullet(Bullet bullets[], int count, Vector2 pos);
void spawn_inactive_enemies(Enemy* enemies, int enemies_count);

int main(void) {
    const int SCREEN_WIDTH = 800;
    const int SCREEN_HEIGHT = 600;

    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C | 3_space_invaders");
    SetTargetFPS(60);

    // Initialize player
    Player player = { (Vector2){400, 500}, 20 }; 
    Bullet bullets[MAX_BULLETS] = {0}; // Stack allocation

    // Initialize enemies
    int enemies_count = 20;
    Enemy* enemies = malloc(sizeof(Enemy) * enemies_count); // Heap allocation
    int enemies_destroyed_count = 0;
    spawn_inactive_enemies(enemies, enemies_count);

    while (!WindowShouldClose()) {
        // Update player
        if (IsKeyDown(KEY_A)) player.position.x -= 4;
        if (IsKeyDown(KEY_D)) player.position.x += 4;
        if (IsKeyDown(KEY_W)) player.position.y -= 4;
        if (IsKeyDown(KEY_S)) player.position.y += 4;
        if (IsKeyPressed(KEY_SPACE)) {
            spawn_bullet(bullets, MAX_BULLETS, player.position);
        }

        // Update bullets
        for (int i = 0; i < MAX_BULLETS; i += 1) {
            if (bullets[i].active) {
                bullets[i].position.x += bullets[i].velocity.x;
                bullets[i].position.y += bullets[i].velocity.y;

                if (bullets[i].position.y < 0) {
                    bullets[i].active = false;
                }
            }
        }

        // Update enemies
        int active_enemies = 0;
        for (int i = 0; i < enemies_count; i += 1) {
            if (enemies[i].active) {
                enemies[i].position.y += 0.5f;
                active_enemies += 1;
            }
        }

        // Respawn inactive enemies
        if (active_enemies < 5) {
            spawn_inactive_enemies(enemies, enemies_count);
        }

        // Check Collisions
        for (int i = 0; i < MAX_BULLETS; i += 1) {
            if (!bullets[i].active) continue;

            for (int j = 0; j < enemies_count; j += 1) {
                if (!enemies[j].active) continue;

                float d = Vector2Distance(bullets[i].position, enemies[j].position);
                float r = bullets[i].radius + enemies[j].radius;

                if (d < r) {
                    bullets[i].active = false;
                    enemies[j].active = false;
                    enemies_destroyed_count += 1;
                }
            }
        }

        BeginDrawing();
        ClearBackground(BLACK);

        DrawCircleV(player.position, player.radius, BLUE);

        for (int i = 0; i < MAX_BULLETS; i += 1) {
            if (bullets[i].active) {
                DrawCircleV(bullets[i].position, bullets[i].radius, YELLOW);
            }
        }
        for (int i = 0; i < enemies_count; i += 1) {
            if (enemies[i].active) {
                DrawCircleV(enemies[i].position, enemies[i].radius, enemies[i].color);
            }
        }

        DrawText("Space Invaders: WASD move | SPACE shoot", 10, 10, 20, WHITE);

        char buffer[64];
        snprintf(buffer, sizeof(buffer), "Enemies destroyed: %d", enemies_destroyed_count);
        DrawText(buffer, 10, 40, 20, YELLOW);

        EndDrawing();
    }

    free(enemies);

    CloseWindow();
    return 0;
}


void spawn_bullet(Bullet bullets[], int count, Vector2 pos) {
    for (int i = 0; i < count; i += 1) {
        if (!bullets[i].active) {
            bullets[i].active = true;
            bullets[i].position = pos;
            bullets[i].velocity = (Vector2){0, -BULLET_SPEED};
            bullets[i].radius = 5;
            return;
        }
    }
}

void spawn_inactive_enemies(Enemy* enemies, int enemies_count) {
    for (int i = 0; i < enemies_count; i += 1) {
        if (!enemies[i].active) {
            enemies[i].position = (Vector2){
                GetRandomValue(50, 750),
                GetRandomValue(50, 300)
            };
            enemies[i].radius = 15;
            enemies[i].active = true;
            enemies[i].color = (Color){ GetRandomValue(100, 255), GetRandomValue(100, 255), GetRandomValue(100, 255), 255 };
        }
    }
}
