""" 
python main.py
py -3.13 main.py
"""

import pyray as rl
from dataclasses import dataclass

MAX_BULLETS  = 64
BULLET_SPEED = 6.0


@dataclass
class Player:
    position: rl.Vector2
    radius:   float

@dataclass
class Bullet:
    position: rl.Vector2
    velocity: rl.Vector2
    radius:   float
    active:   bool

@dataclass
class Enemy:
    position: rl.Vector2
    radius:   float
    active:   bool
    color:    rl.Color

def spawn_bullet(bullets, count, pos):
    for i in range(count):
        if not bullets[i].active:
            bullets[i].active = True
            bullets[i].position = rl.Vector2(pos.x, pos.y)
            bullets[i].velocity = rl.Vector2(0, -BULLET_SPEED)
            bullets[i].radius = 5
            return


def spawn_inactive_enemies(enemies, enemies_count):
    for i in range(enemies_count):
        if not enemies[i].active:
            enemies[i].position = rl.Vector2(
                rl.get_random_value(50, 750),
                rl.get_random_value(50, 300)
            )
            enemies[i].radius = 15
            enemies[i].active = True
            enemies[i].color  = rl.Color(
                rl.get_random_value(100, 255),
                rl.get_random_value(100, 255),
                rl.get_random_value(100, 255),
                255
            )


def main():
    SCREEN_WIDTH = 800
    SCREEN_HEIGHT = 600

    rl.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "Raylib in C | 3_space_invaders")
    rl.set_target_fps(60)

    # Initialize player
    player = Player(rl.Vector2(400, 500), 20)
    bullets = [Bullet(rl.Vector2(0, 0), rl.Vector2(0, 0), 0, False) for _ in range(MAX_BULLETS)]  # Stack allocation

    # Initialize enemies
    enemies_count = 20
    enemies = [Enemy(rl.Vector2(0, 0), 0, False, rl.BLACK) for _ in range(enemies_count)]  # Heap allocation
    enemies_destroyed_count = 0
    spawn_inactive_enemies(enemies, enemies_count)

    while not rl.window_should_close():
        # Update player
        if rl.is_key_down(rl.KEY_A):
            player.position.x -= 4
        if rl.is_key_down(rl.KEY_D):
            player.position.x += 4
        if rl.is_key_down(rl.KEY_W):
            player.position.y -= 4
        if rl.is_key_down(rl.KEY_S):
            player.position.y += 4
        if rl.is_key_pressed(rl.KEY_SPACE):
            spawn_bullet(bullets, MAX_BULLETS, player.position)

        # Update bullets
        for i in range(MAX_BULLETS):
            if bullets[i].active:
                bullets[i].position.x += bullets[i].velocity.x
                bullets[i].position.y += bullets[i].velocity.y

                if bullets[i].position.y < 0:
                    bullets[i].active = False

        # Update enemies
        active_enemies = 0
        for i in range(enemies_count):
            if enemies[i].active:
                enemies[i].position.y += 0.5
                active_enemies += 1

        # Respawn inactive enemies
        if active_enemies < 5:
            spawn_inactive_enemies(enemies, enemies_count)

        # Check Collisions
        for i in range(MAX_BULLETS):
            if not bullets[i].active:
                continue

            for j in range(enemies_count):
                if not enemies[j].active:
                    continue

                d = rl.vector2_distance(bullets[i].position, enemies[j].position)
                r = bullets[i].radius + enemies[j].radius

                if d < r:
                    bullets[i].active = False
                    enemies[j].active = False
                    enemies_destroyed_count += 1

        rl.begin_drawing()
        rl.clear_background(rl.BLACK)

        rl.draw_circle_v(player.position, player.radius, rl.BLUE)

        for i in range(MAX_BULLETS):
            if bullets[i].active:
                rl.draw_circle_v(bullets[i].position, bullets[i].radius, rl.YELLOW)

        for i in range(enemies_count):
            if enemies[i].active:
                rl.draw_circle_v(enemies[i].position, enemies[i].radius, enemies[i].color)

        rl.draw_text("Space Invaders: WASD move | SPACE shoot", 10, 10, 20, rl.WHITE)

        rl.draw_text(f"Enemies destroyed: {enemies_destroyed_count}", 10, 40, 20, rl.YELLOW)

        rl.end_drawing()

    rl.close_window()


if __name__ == "__main__":
    main()
