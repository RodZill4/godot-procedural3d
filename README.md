# godot-procedural3d
This Godot addon provides tools to generate procedural 3d scenes (such as dungeons) from modular assets.

The addon itself defines the following scripts:
* __modular_room.gd__: a script that is used to define connectable and configurable rooms
* __modular_room_exit.gd__: a script that is used to define the exits of rooms. When building a dungeon, exits help defining the rooms positions and orientations. Exits must be direct children of the room scene.
* __modular_room_object.gd__: A script that is used to define the location of objects (that could be doors, traps, treasures, enemy spawns, ...) in a room. Configuring a room consists in choosing an object for each object location in the room.
* __generator.gd__: a script that defines a scene generator. It must have a "rooms" child whose children are the available rooms, and an "objects" child whose children are the objects categories whose children are the objects scenes.

# The demo
The demo shows all available features.

To generate a dungeon, open the __test.tscn__ scene, and select the __DungeonGenerator__ node. The 3d view toolbar will show 3 buttons:
* __Generate__ will start generating a dungeon (or continue a previously stopped generation).
* __Stop__ will stop generation.
* __Clean__ will delete the generation result.

The demo uses the following assets:
* https://opengameart.org/content/modular-dungeon-2-3d-models
* https://opengameart.org/content/animated-human-low-poly
