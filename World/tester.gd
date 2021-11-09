tool
extends Node2D

export(float)var number

func _physics_process(delta):
	modulate.r = number / 20.0
