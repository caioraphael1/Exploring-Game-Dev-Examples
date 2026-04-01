""" 
python main.py
py -3.13 main.py
"""

import pyray as rl

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 450

def main():
    rl.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in Python | 1_moving_ball")
    rl.set_target_fps(60)

    # Initialize ball
    ball_position = rl.Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

    while not rl.window_should_close():
        # Update ball position
        if rl.is_key_down(rl.KEY_RIGHT):
            ball_position.x += 2.0
        if rl.is_key_down(rl.KEY_LEFT):
            ball_position.x -= 2.0
        if rl.is_key_down(rl.KEY_UP):
            ball_position.y -= 2.0
        if rl.is_key_down(rl.KEY_DOWN):
            ball_position.y += 2.0

        # Draw
        rl.begin_drawing()
        rl.clear_background(rl.RAYWHITE)

        rl.draw_text("move the ball with arrow keys", 10, 10, 20, rl.DARKGRAY)
        rl.draw_circle_v(ball_position, 50, rl.MAROON)

        rl.end_drawing()

    rl.close_window()


if __name__ == "__main__":
    main()
