# PaddleKick

A 2D soccer goal game built with Godot 4.6. Control a paddle to deflect the ball into the goal.

## Gameplay

- A ball bounces around the screen
- Move the paddle left and right to knock the ball into the goal at the top of the screen
- Lose a life each time the ball goes out of bounds
- The game ends when all lives are gone

## Controls

| Input | Action |
|-------|--------|
| `←` / `A` | Move paddle left |
| `→` / `D` | Move paddle right |

## Scoring

- **+1 point** per goal
- **+300 bonus points** for hitting the UFO with the ball
- Start with **3 lives** (shown as soccer ball icons)
- Score persists across rounds within the same session
- Score resets when you restart after game over

## Obstacle Characters

After scoring the first goal, characters begin crossing the screen from the sides (up to 3 at a time).

| Character | Uniform | Effect |
|-----------|---------|--------|
| UFO | — | Destroyed by the ball for +300 points |
| GK (Goalkeeper) | Yellow-green | Deflects the ball |
| FW (Forward) | Red | Deflects the ball |
| MF (Midfielder) | Blue | Deflects the ball |
| DF (Defender) | White | Deflects the ball |
| Referee | Black | Deflects the ball |
| Captain | Orange | Deflects the ball |

All characters are drawn entirely in code — no external sprite assets.

## Requirements

- **Engine**: Godot 4.6
- **Renderer**: Mobile
- **Resolution**: 1190 × 980

## Running the Game

1. Install [Godot 4.6](https://godotengine.org/)
2. Clone this repository
3. Open the project in Godot and run `game.tscn`

## License

[MIT License](LICENSE)
