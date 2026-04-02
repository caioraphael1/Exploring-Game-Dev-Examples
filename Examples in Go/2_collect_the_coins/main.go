/*
go run main.go
*/

package main

import (
	"fmt"
	"math/rand"
	"time"

	rl "github.com/gen2brain/raylib-go/raylib"
)

const (
    SCREEN_WIDTH  = 800
    SCREEN_HEIGHT = 600
    MAX_COINS     = 20
    PLAYER_SPEED  = 4.0
)

type Player struct {
    position rl.Vector2
    radius   float32
    score    int
}

type Coin struct {
    position rl.Vector2
    radius   float32
    active   bool
}

func main() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Go | 2_collect_the_coins")
    rl.SetTargetFPS(60)
    defer rl.CloseWindow()

    // Seed random generator
    rand.Seed(time.Now().UnixNano())

    // Initialize player
    player := Player{
        position: rl.NewVector2(SCREEN_WIDTH/2, SCREEN_HEIGHT/2),
        radius:   20,
        score:    0,
    }

    // Initialize coins
    var coins [MAX_COINS]Coin
    for i := 0; i < MAX_COINS; i++ {
        coins[i] = Coin{
            position: rl.NewVector2(float32(rand.Intn(SCREEN_WIDTH-40)+20), float32(rand.Intn(SCREEN_HEIGHT-40)+20)),
            radius:   8,
            active:   true,
        }
    }

    // Main game loop
    for !rl.WindowShouldClose() {
        // Update player
        if rl.IsKeyDown(rl.KeyW) {
            player.position.Y -= PLAYER_SPEED
        }
        if rl.IsKeyDown(rl.KeyS) {
            player.position.Y += PLAYER_SPEED
        }
        if rl.IsKeyDown(rl.KeyA) {
            player.position.X -= PLAYER_SPEED
        }
        if rl.IsKeyDown(rl.KeyD) {
            player.position.X += PLAYER_SPEED
        }

        // Check collisions
        for i := 0; i < MAX_COINS; i++ {
            if coins[i].active {
                dist := rl.Vector2Distance(player.position, coins[i].position)
                if dist < player.radius+coins[i].radius {
                    coins[i].active = false
                    player.score++
                }
            }
        }

        // Draw
        rl.BeginDrawing()
        rl.ClearBackground(rl.DarkGreen)

        rl.DrawCircleV(player.position, player.radius, rl.Blue)
        for i := 0; i < MAX_COINS; i++ {
            if coins[i].active {
                rl.DrawCircleV(coins[i].position, coins[i].radius, rl.Gold)
            }
        }
        rl.DrawText(fmt.Sprintf("Score: %d", player.score), 10, 10, 20, rl.White)

        rl.EndDrawing()
    }
}
