/* 
cargo run
*/

use raylib::prelude::*;
use rand::Rng;

const MAX_BULLETS: usize = 64;
const BULLET_SPEED:  f32 = 6.0;

#[derive(Clone, Copy)]
struct Player {
    position: Vector2,
    radius: f32,
}

#[derive(Clone, Copy)]
struct Bullet {
    position: Vector2,
    velocity: Vector2,
    radius: f32,
    active: bool,
}

#[derive(Clone, Copy)]
struct Enemy {
    position: Vector2,
    radius: f32,
    active: bool,
    color: Color,
}

fn spawn_bullet(bullets: &mut [Bullet; MAX_BULLETS], pos: Vector2) {
    for bullet in bullets.iter_mut() {
        if !bullet.active {
            bullet.active = true;
            bullet.position = pos;
            bullet.velocity = Vector2::new(0.0, -BULLET_SPEED);
            bullet.radius = 5.0;
            return;
        }
    }
}

fn spawn_inactive_enemies(enemies: &mut [Enemy]) {
    let mut rng = rand::thread_rng();
    for enemy in enemies.iter_mut() {
        if !enemy.active {
            enemy.position = Vector2::new(rng.gen_range(50..751) as f32, rng.gen_range(50..301) as f32);
            enemy.radius = 15.0;
            enemy.active = true;
            enemy.color = Color::new(
                rng.gen_range(100..255),
                rng.gen_range(100..255),
                rng.gen_range(100..255),
                255,
            );
        }
    }
}

fn main() {
    const SCREEN_WIDTH:  i32 = 800;
    const SCREEN_HEIGHT: i32 = 600;

    let (mut rl, thread) = raylib::init()
        .size(SCREEN_WIDTH, SCREEN_HEIGHT)
        .title("Raylib in Rust | 3_space_invaders")
        .build();

    rl.set_target_fps(60);

    let mut player = Player {
        position: Vector2::new(400.0, 500.0),
        radius: 20.0,
    };

    let mut bullets: [Bullet; MAX_BULLETS] = [Bullet {
        position: Vector2::zero(),
        velocity: Vector2::zero(),
        radius: 0.0,
        active: false,
    }; MAX_BULLETS];

    let enemies_count = 20;
    let mut enemies: Vec<Enemy> = vec![
        Enemy {
            position: Vector2::zero(),
            radius: 0.0,
            active: false,
            color: Color::BLACK,
        };
        enemies_count
    ];

    let mut enemies_destroyed_count = 0;
    spawn_inactive_enemies(&mut enemies);

    while !rl.window_should_close() {
        // Player movement
        if rl.is_key_down(KeyboardKey::KEY_A) { player.position.x -= 4.0; }
        if rl.is_key_down(KeyboardKey::KEY_D) { player.position.x += 4.0; }
        if rl.is_key_down(KeyboardKey::KEY_W) { player.position.y -= 4.0; }
        if rl.is_key_down(KeyboardKey::KEY_S) { player.position.y += 4.0; }
        if rl.is_key_pressed(KeyboardKey::KEY_SPACE) {
            spawn_bullet(&mut bullets, player.position);
        }

        // Update bullets
        for bullet in bullets.iter_mut() {
            if bullet.active {
                bullet.position.x += bullet.velocity.x;
                bullet.position.y += bullet.velocity.y;
                if bullet.position.y < 0.0 { bullet.active = false; }
            }
        }

        // Update enemies
        let mut active_enemies = 0;
        for enemy in enemies.iter_mut() {
            if enemy.active {
                enemy.position.y += 0.5;
                active_enemies += 1;
            }
        }

        // Respawn inactive enemies
        if active_enemies < 5 {
            spawn_inactive_enemies(&mut enemies);
        }

        // Collision detection
        for bullet in bullets.iter_mut() {
            if !bullet.active { continue; }
            for enemy in enemies.iter_mut() {
                if !enemy.active { continue; }
                if Vector2::distance_to(&bullet.position, enemy.position) < (bullet.radius + enemy.radius) {
                    bullet.active = false;
                    enemy.active = false;
                    enemies_destroyed_count += 1;
                }
            }
        }

        let mut d = rl.begin_drawing(&thread);
        d.clear_background(Color::BLACK);

        d.draw_circle_v(player.position, player.radius, Color::BLUE);

        for bullet in bullets.iter() {
            if bullet.active {
                d.draw_circle_v(bullet.position, bullet.radius, Color::YELLOW);
            }
        }

        for enemy in enemies.iter() {
            if enemy.active {
                d.draw_circle_v(enemy.position, enemy.radius, enemy.color);
            }
        }

        d.draw_text("Space Invaders: WASD move | SPACE shoot", 10, 10, 20, Color::WHITE);
        d.draw_text(
            &format!("Enemies destroyed: {}", enemies_destroyed_count),
            10,
            40,
            20,
            Color::YELLOW,
        );
    }
}
