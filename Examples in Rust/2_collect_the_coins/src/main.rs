/* 
cargo run
*/

use raylib::prelude::*;
use rand::Rng;

const MAX_COINS:  usize = 20;
const PLAYER_SPEED: f32 = 4.0;

struct Player {
    position: Vector2,
    radius:   f32,
    score:    i32,
}

struct Coin {
    position: Vector2,
    radius:   f32,
    active:   bool,
}

fn main() {
    const SCREEN_WIDTH: i32  = 800;
    const SCREEN_HEIGHT: i32 = 600;

    let (mut rl, thread) = raylib::init()
        .size(SCREEN_WIDTH, SCREEN_HEIGHT)
        .title("Raylib in Rust | 2_collect_the_coins")
        .build();

    rl.set_target_fps(60);

    // Initialize player
    let mut player = Player {
        position: Vector2::new(400.0, 300.0),
        radius: 20.0,
        score: 0,
    };

    // Initialize coins
    let mut rng = rand::thread_rng();
    let mut coins: Vec<Coin> = (0..MAX_COINS)
        .map(|_| Coin {
            position: Vector2::new(
                rng.gen_range(20.0..(SCREEN_WIDTH as f32 - 20.0)),
                rng.gen_range(20.0..(SCREEN_HEIGHT as f32 - 20.0)),
            ),
            radius: 8.0,
            active: true,
        })
        .collect();

    while !rl.window_should_close() {
        // Update player
        if rl.is_key_down(KeyboardKey::KEY_W) {
            player.position.y -= PLAYER_SPEED;
        }
        if rl.is_key_down(KeyboardKey::KEY_S) {
            player.position.y += PLAYER_SPEED;
        }
        if rl.is_key_down(KeyboardKey::KEY_A) {
            player.position.x -= PLAYER_SPEED;
        }
        if rl.is_key_down(KeyboardKey::KEY_D) {
            player.position.x += PLAYER_SPEED;
        }

        // Check collisions
        for coin in coins.iter_mut() {
            if coin.active {
                let dist = player.position.distance_to(coin.position);
                if dist < player.radius + coin.radius {
                    coin.active = false;
                    player.score += 1;
                }
            }
        }

        // Draw
        let mut d = rl.begin_drawing(&thread);
        d.clear_background(Color::DARKGREEN);

        d.draw_circle_v(player.position, player.radius, Color::BLUE);
        for coin in coins.iter() {
            if coin.active {
                d.draw_circle_v(coin.position, coin.radius, Color::GOLD);
            }
        }
        d.draw_text(&format!("Score: {}", player.score), 10, 10, 20, Color::WHITE);
    }
}
