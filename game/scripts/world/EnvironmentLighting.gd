class_name EnvironmentLighting
extends Node3D

@export var sun_energy: float = 1.15
@export var sun_angle: float = -38.0

func _ready() -> void:
        print("ENVIRONMENT LIGHTING")
        print("Sun energy: ", sun_energy)
        print("Cinematic atmosphere: ACTIVE")
