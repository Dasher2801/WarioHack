# Space Minigame Adventure

Welcome to Space Minigame Adventure, a fast-paced and quirky arcade-style game built from scratch using the Godot Engine.
The project started as a fun experiment in combining tight platforming mechanics with unpredictable mini-challenges set against a starry cosmic background. 

In this game, you control a rather expressive little character navigating through zero-gravity environments and platform layouts.
Your main objective is to clear various levels and minigames by collecting items under strict time pressure while keeping an eye on your remaining lives.
Each stage ramps up the tension, forcing you to think and move quickly before the countdown hits zero.

## Gameplay and Features

The game is structured around progression through distinct levels and minigames managed by a central global state.
You will encounter platforming challenges, avoidance tasks, and collection objectives where precision and timing are everything.
If you fail to complete the objectives in time or run out of attempts,
the game loops you back to the intermission screen to try again or face the consequences.

## Technical Background

Developed using GDScript in Godot, the project relies on a clean,
centralized script structure to handle scene transitions, dynamic node loading, and custom countdown logic without relying on fragile external dependencies.
It features robust safety checks for node references to ensure smooth performance and zero unexpected crashes during scene changes.

## Getting Started

To run or modify this project yourself, make sure you have the Godot Engine installed (version 4.x recommended).
Simply clone or download this repository, open the project manager in Godot, and import the project folder.
From there, you can explore the scene tree, tweak the minigame scripts, and jump straight into the editor to test your own modifications.
