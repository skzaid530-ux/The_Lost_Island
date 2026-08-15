class_name BeachVegetation
extends Node3D

@export var palm_count: int = 8
@export var grass_cluster_count: int = 18
@export var driftwood_count: int = 5

func _ready() -> void:
        print("BEACH VEGETATION SYSTEM")
        print("Palm count: ", palm_count)
        print("Grass clusters: ", grass_cluster_count)
        print("Driftwood: ", driftwood_count)
        print("Natural vegetation: ACTIVE")
