/* 
cargo run
*/

use raylib::prelude::*;

fn main() {
    const SCREEN_WIDTH: i32 = 800;
    const SCREEN_HEIGHT: i32 = 450;

    let (mut rl, thread) = raylib::init()
        .size(SCREEN_WIDTH, SCREEN_HEIGHT)
        .title("Raylib in Rust | 1_moving_ball")
        .build();

    rl.set_target_fps(60);

    // Initialize ball
    let mut ball_position = Vector2 {
        x: SCREEN_WIDTH  as f32 / 2.0,
        y: SCREEN_HEIGHT as f32 / 2.0,
    };

    while !rl.window_should_close() {
        // Update ball position
        if rl.is_key_down(KeyboardKey::KEY_RIGHT) {
            ball_position.x += 2.0;
        }
        if rl.is_key_down(KeyboardKey::KEY_LEFT) {
            ball_position.x -= 2.0;
        }
        if rl.is_key_down(KeyboardKey::KEY_UP) {
            ball_position.y -= 2.0;
        }
        if rl.is_key_down(KeyboardKey::KEY_DOWN) {
            ball_position.y += 2.0;
        }

        // Draw
        let mut d = rl.begin_drawing(&thread);
        d.clear_background(Color::RAYWHITE);

        d.draw_text("move the ball with arrow keys", 10, 10, 20, Color::DARKGRAY);

        d.draw_circle_v(ball_position, 50.0, Color::MAROON);
    }
}
