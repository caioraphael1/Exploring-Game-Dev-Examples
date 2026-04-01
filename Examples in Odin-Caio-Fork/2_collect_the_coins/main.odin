/* 
odin run .
*/

import rl "vendor:raylib"

MAX_COINS    :: 20
PLAYER_SPEED :: 4.0

Player :: struct {
    position: [2]f32,
    radius:   f32,
    score:    int,
}

Coin :: struct {
    position: [2]f32,
    radius:   f32,
    active:   bool,
}

main :: proc() {
    SCREEN_WIDTH  :: 800
    SCREEN_HEIGHT :: 600

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Odin-Caio-Fork | 2_collect_the_coins")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    // Initialize player
    player := Player{
        position = { 400, 300 },
        radius   = 20,
        score    = 0,
    }

    // Initialize coins
    coins: [MAX_COINS]Coin
    for i in 0..<MAX_COINS {
        coins[i].position = {
            f32(rl.GetRandomValue(20, SCREEN_WIDTH - 20)),
            f32(rl.GetRandomValue(20, SCREEN_HEIGHT - 20)),
        }
        coins[i].radius = 8
        coins[i].active = true
    }

    for !rl.WindowShouldClose() {
        // Update player
        if rl.IsKeyDown(.W) { player.position.y -= PLAYER_SPEED }
        if rl.IsKeyDown(.S) { player.position.y += PLAYER_SPEED }
        if rl.IsKeyDown(.A) { player.position.x -= PLAYER_SPEED }
        if rl.IsKeyDown(.D) { player.position.x += PLAYER_SPEED }

        // Check collisions
        for i in 0..<MAX_COINS {
            if coins[i].active {
                dist := rl.Vector2Distance(player.position, coins[i].position)

                if dist < player.radius + coins[i].radius {
                    coins[i].active = false
                    player.score += 1
                }
            }
        }

        // Draw
        {
            rl.BeginDrawing()
            defer rl.EndDrawing()
            rl.ClearBackground(rl.DARKGREEN)

            rl.DrawCircleV(player.position, player.radius, rl.BLUE)
            for i in 0..<MAX_COINS {
                if coins[i].active {
                    rl.DrawCircleV(coins[i].position, coins[i].radius, rl.GOLD)
                }
            }

            rl.DrawText(rl.TextFormat("Score: %d", player.score), 10, 10, 20, rl.WHITE)            
        }
    }
}
