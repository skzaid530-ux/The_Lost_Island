class_name WaterAtmosphere
extends Node3D

@export var water_level: float = 0.0
@export var wave_speed: float = 0.35
@export var wave_strength: float = 0.08

func _ready() -> void:
	print("WATER + ATMOSPHERE SYSTEM")
	print("Water level: ", water_level)
	print("Wave speed: ", wave_speed)
	print("Atmosphere: ACTIVE")

func _process(_delta: float) -> void:
	# Reserved for lightweight shoreline/water animation.
	pass
