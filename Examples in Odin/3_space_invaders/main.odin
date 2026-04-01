package main

import rl "vendor:raylib"
import "core:fmt"

MAX_BULLETS  :: 64
BULLET_SPEED :: 6.0

Player :: struct {
    position: rl.Vector2,
    radius:   f32,
}

Bullet :: struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    radius:   f32,
    active:   bool,
}

Enemy :: struct {
    position: rl.Vector2,
    radius:   f32,
    active:   bool,
    color:    rl.Color,
}

main :: proc() {
    SCREEN_WIDTH  :: 800
    SCREEN_HEIGHT :: 600

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Odin | 3_space_invaders")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    // Initialize player
    player := Player{ 
        { 400, 500 }, 
        20,
    } 
    bullets: [MAX_BULLETS]Bullet // Stack allocation

    // Initialize enemies
    enemies := make([]Enemy, 20) // Heap allocation, using context.allocator implicitly
    defer delete(enemies)
    enemies_destroyed_count := 0
    spawn_inactive_enemies(enemies)

    for !rl.WindowShouldClose() {
        // Update player
        if rl.IsKeyDown(.A) { player.position.x -= 4 }
        if rl.IsKeyDown(.D) { player.position.x += 4 }
        if rl.IsKeyDown(.W) { player.position.y -= 4 }
        if rl.IsKeyDown(.S) { player.position.y += 4 }
        if rl.IsKeyPressed(.SPACE) {
            spawn_bullet(bullets[:], player.position)
        }

        // Update bullets
        for i in 0..<len(bullets) {
            if bullets[i].active {
                bullets[i].position.x += bullets[i].velocity.x
                bullets[i].position.y += bullets[i].velocity.y

                if bullets[i].position.y < 0 {
                    bullets[i].active = false
                }
            }
        }

        // Update enemies
        active_enemies := 0
        for i in 0..<len(enemies) {
            if enemies[i].active {
                enemies[i].position.y += 0.5
                active_enemies += 1
            }
        }

        // Respawn inactive enemies
        if active_enemies < 5 {
            spawn_inactive_enemies(enemies)
        }

        // Check Collisions
        for i in 0..<len(bullets) {
            if !bullets[i].active { continue }

            for j in 0..<len(enemies) {
                if !enemies[j].active { continue }

                d := rl.Vector2Distance(bullets[i].position, enemies[j].position)
                r := bullets[i].radius + enemies[j].radius

                if d < r {
                    bullets[i].active  = false
                    enemies[j].active  = false
                    enemies_destroyed_count += 1
                }
            }
        }

        // Draw
        {
            rl.BeginDrawing()
            defer rl.EndDrawing()
            rl.ClearBackground(rl.BLACK)

            rl.DrawCircleV(player.position, player.radius, rl.BLUE)

            for i in 0..<len(bullets) {
                if bullets[i].active {
                    rl.DrawCircleV(bullets[i].position, bullets[i].radius, rl.YELLOW)
                }
            }
            for i in 0..<len(enemies) {
                if enemies[i].active {
                    rl.DrawCircleV(enemies[i].position, enemies[i].radius, enemies[i].color)
                }
            }

            rl.DrawText("Space Invaders: WASD move | SPACE shoot", 10, 10, 20, rl.WHITE)

            rl.DrawText(fmt.ctprintf("Enemies destroyed: %v", enemies_destroyed_count), 10, 40, 20, rl.YELLOW)
                // Prints while doing a temporary allocation.
        }

        free_all(context.temp_allocator)
    }
}

spawn_bullet :: proc(bullets: []Bullet, pos: rl.Vector2) {
    for i in 0..<len(bullets) {
        if !bullets[i].active {
            bullets[i].active   = true
            bullets[i].position = pos
            bullets[i].velocity = {0, -BULLET_SPEED}
            bullets[i].radius   = 5
            return
        }
    }
}

spawn_inactive_enemies :: proc(enemies: []Enemy) {
    for i in 0..<len(enemies) {
        if !enemies[i].active {
            enemies[i].position = {
                f32(rl.GetRandomValue(50, 750)),
                f32(rl.GetRandomValue(50, 300)),
            }
            enemies[i].radius = 15
            enemies[i].active = true
            enemies[i].color  = {
                u8(rl.GetRandomValue(100, 255)),
                u8(rl.GetRandomValue(100, 255)),
                u8(rl.GetRandomValue(100, 255)),
                255,
            }
        }
    }
}
