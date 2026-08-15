class_name BeachDetail
extends Node3D

@export var palm_count: int = 6
@export var rock_count: int = 10

func _ready() -> void:
	print("BEACH DETAIL SYSTEM")
	print("Palm density: ", palm_count)
	print("Rock density: ", rock_count)
	print("Shoreline detailing: ACTIVE")
