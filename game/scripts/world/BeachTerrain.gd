class_name BeachTerrain
extends Node3D

@export var beach_width: float = 42.0
@export var beach_depth: float = 24.0

func _ready() -> void:
        print("BEACH TERRAIN SYSTEM")
        print("Beach width: ", beach_width)
        print("Beach depth: ", beach_depth)
        print("Walkable ground: READY")
