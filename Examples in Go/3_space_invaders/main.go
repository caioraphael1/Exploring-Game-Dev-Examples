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
    MAX_BULLETS   = 64
    BULLET_SPEED  = 6.0
)

type Player struct {
    Position rl.Vector2
    Radius   float32
}

type Bullet struct {
    Position rl.Vector2
    Velocity rl.Vector2
    Radius   float32
    Active   bool
}

type Enemy struct {
    Position rl.Vector2
    Radius   float32
    Active   bool
    Color    rl.Color
}

func spawnBullet(bullets []Bullet, pos rl.Vector2) {
    for i := range bullets {
        if !bullets[i].Active {
            bullets[i].Active = true
            bullets[i].Position = pos
            bullets[i].Velocity = rl.Vector2{X: 0, Y: -BULLET_SPEED}
            bullets[i].Radius = 5
            return
        }
    }
}

func spawnInactiveEnemies(enemies []Enemy) {
    for i := range enemies {
        if !enemies[i].Active {
            enemies[i].Position = rl.Vector2{
                X: float32(rand.Intn(701) + 50),
                Y: float32(rand.Intn(251) + 50),
            }
            enemies[i].Radius = 15
            enemies[i].Active = true
            enemies[i].Color = rl.NewColor(
                uint8(rand.Intn(156)+100),
                uint8(rand.Intn(156)+100),
                uint8(rand.Intn(156)+100),
                255,
            )
        }
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Go | 3_space_invaders")
    rl.SetTargetFPS(60)

    player := Player{Position: rl.Vector2{X: 400, Y: 500}, Radius: 20}
    var bullets [MAX_BULLETS]Bullet // Stack allocation.

    enemiesCount := 20
    enemies := make([]Enemy, enemiesCount) // Heap allocation.
		// No need to free this, as there's Go is garbage collected. You can't manually free it.
    enemiesDestroyedCount := 0
    spawnInactiveEnemies(enemies)

    for !rl.WindowShouldClose() {
        // Player movement
        if rl.IsKeyDown(rl.KeyA) {
            player.Position.X -= 4
        }
        if rl.IsKeyDown(rl.KeyD) {
            player.Position.X += 4
        }
        if rl.IsKeyDown(rl.KeyW) {
            player.Position.Y -= 4
        }
        if rl.IsKeyDown(rl.KeyS) {
            player.Position.Y += 4
        }
        if rl.IsKeyPressed(rl.KeySpace) {
            spawnBullet(bullets[:], player.Position)
        }

        // Update bullets
        for i := range bullets {
            if bullets[i].Active {
                bullets[i].Position.X += bullets[i].Velocity.X
                bullets[i].Position.Y += bullets[i].Velocity.Y

                if bullets[i].Position.Y < 0 {
                    bullets[i].Active = false
                }
            }
        }

        // Update enemies
        activeEnemies := 0
        for i := range enemies {
            if enemies[i].Active {
                enemies[i].Position.Y += 0.5
                activeEnemies++
            }
        }

        // Respawn inactive enemies if too few
        if activeEnemies < 5 {
            spawnInactiveEnemies(enemies)
        }

        // Check collisions
        for i := range bullets {
            if !bullets[i].Active {
                continue
            }
            for j := range enemies {
                if !enemies[j].Active {
                    continue
                }
                d := rl.Vector2Distance(bullets[i].Position, enemies[j].Position)
                r := bullets[i].Radius + enemies[j].Radius
                if d < r {
                    bullets[i].Active = false
                    enemies[j].Active = false
                    enemiesDestroyedCount++
                }
            }
        }

        // Drawing
        rl.BeginDrawing()
        rl.ClearBackground(rl.Black)

        rl.DrawCircleV(player.Position, player.Radius, rl.Blue)

        for i := range bullets {
            if bullets[i].Active {
                rl.DrawCircleV(bullets[i].Position, bullets[i].Radius, rl.Yellow)
            }
        }
        for i := range enemies {
            if enemies[i].Active {
                rl.DrawCircleV(enemies[i].Position, enemies[i].Radius, enemies[i].Color)
            }
        }

        rl.DrawText("Space Invaders: WASD move | SPACE shoot", 10, 10, 20, rl.White)
        rl.DrawText(fmt.Sprintf("Enemies destroyed: %d", enemiesDestroyedCount), 10, 40, 20, rl.Yellow)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}
