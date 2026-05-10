# First-person maze-game
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/Am1085/First-person-maze-game)

This repository contains a first-person 3D maze game developed using the Godot Engine. Players navigate a dark, procedurally generated maze with the aid of a flashlight, aiming to find the exit as quickly as possible. The project demonstrates core Godot concepts including 3D character control, scene instantiation, UI management, and audio integration.

## Features

-   **First-Person Controller:** Navigate the maze with standard WASD controls for movement and mouse for looking.
-   **Dynamic Maze Generation:** The maze is built at runtime from a pre-defined 2D array, allowing for easy modification of the layout.
-   **Atmospheric Environment:** A dark setting enhanced with fog, a player-controlled flashlight, and a procedural sky.
-   **Gameplay Timer:** A timer tracks your progress, displayed on the win screen upon completion.
-   **Audio Feedback:** Includes background music, footstep sounds that play when moving, and a sound effect upon winning.
-   **In-Game Minimap:** After 10 seconds, a hint appears, allowing the player to toggle a top-down minimap for assistance.
-   **Win Screen:** A custom win screen appears when you reach the goal, showing your completion time and providing an option to restart.

## How it Works

The maze is logically represented by a `30x30` 2D array within the `MazeGenerator.gd` script.
-   A value of `1` represents a wall.
-   A value of `0` represents a path.

At runtime, the script iterates through this grid. For each cell containing a `1`, it instantiates a wall scene, which is a `StaticBody3D` with its own mesh and collision shape. The 2D array indices (`row`, `col`) are mapped to the 3D world's `Z` and `X` axes, respectively, to position the walls and form the maze structure.

The main scene (`manual.tscn`) composes the different elements—the player, the maze, the floor, lighting, and the UI—into a playable game.

## Getting Started

To run this project, you will need the Godot Engine (v4.6 or later).

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/am1085/first-person-maze-game.git
    ```
2.  **Open the Godot Project Manager.**
3.  Click the **Import** button and navigate to the cloned repository's `program` directory.
4.  Select the `project.godot` file to import the project.
5.  Once imported, open the project in the Godot Editor.
6.  Press the **Play** button (or F5) to run the main scene (`manual.tscn`).

## Controls

| Action                      | Key              |
| --------------------------- | ---------------- |
| Movement                    | `up`, `left`, `down`, `right` |
| Look                        | `Mouse`          |
| Toggle Minimap              | `H`              |
| Release Mouse Cursor        | `Esc`            |
| Restart Game (on win screen) | `Enter`          |
## Project Structure

-   `program/scenes/manual.tscn`: The main scene that assembles all game components.
-   `program/scripts/MazeGenerator.gd`: Contains the 2D grid and the logic for generating the 3D maze.
-   `program/scripts/player.gd`: Manages player movement, camera controls, flashlight, and footstep audio.
-   `program/scripts/timer.gd`: Handles the gameplay timer and the logic for the minimap hint and toggle.
-   `program/scripts/goal.gd`: Script for the `Area3D` that detects when the player reaches the exit and triggers the win condition.
-   `program/scripts/winscreen.gd`: Dynamically builds and displays the UI for the victory screen.
