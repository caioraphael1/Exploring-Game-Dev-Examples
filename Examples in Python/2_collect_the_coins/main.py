""" 
python main.py
py -3.13 main.py
"""

import pyray as rl
from dataclasses import dataclass

MAX_COINS = 20
PLAYER_SPEED = 4.0


@dataclass
class Player:
    position: rl.Vector2
    radius:   float
    score:    int


@dataclass
class Coin:
    position: rl.Vector2
    radius:   float
    active:   bool


def main():
    SCREEN_WIDTH = 800
    SCREEN_HEIGHT = 600

    rl.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C | 2_collect_the_coins")
    rl.set_target_fps(60)

    # Initialize player
    player = Player(
        position = rl.Vector2(400, 300),
        radius   = 20,
        score    = 0
    )

    # Initialize coins
    coins = []
    for i in range(MAX_COINS):
        coins.append(Coin(
            position = rl.Vector2(
                rl.get_random_value(20, SCREEN_WIDTH - 20),
                rl.get_random_value(20, SCREEN_HEIGHT - 20)
            ),
            radius = 8,
            active = True
        ))

    while not rl.window_should_close():
        # Update player
        if rl.is_key_down(rl.KEY_W):
            player.position.y -= PLAYER_SPEED
        if rl.is_key_down(rl.KEY_S):
            player.position.y += PLAYER_SPEED
        if rl.is_key_down(rl.KEY_A):
            player.position.x -= PLAYER_SPEED
        if rl.is_key_down(rl.KEY_D):
            player.position.x += PLAYER_SPEED

        # Check collisions
        for i in range(MAX_COINS):
            if coins[i].active:
                dist = rl.vector2_distance(player.position, coins[i].position)

                if dist < player.radius + coins[i].radius:
                    coins[i].active = False
                    player.score += 1

        # Draw
        rl.begin_drawing()
        rl.clear_background(rl.DARKGREEN)

        rl.draw_circle_v(player.position, player.radius, rl.BLUE)
        for i in range(MAX_COINS):
            if coins[i].active:
                rl.draw_circle_v(coins[i].position, coins[i].radius, rl.GOLD)

        rl.draw_text(f"Score: {player.score}", 10, 10, 20, rl.WHITE)

        rl.end_drawing()

    rl.close_window()


if __name__ == "__main__":
    main()
