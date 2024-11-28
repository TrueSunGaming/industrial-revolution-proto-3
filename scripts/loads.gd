extends Node

const environments := [
	"factory"
]

func _init() -> void:
	for i in environments: load("res://scenes/environment/" + i + "/" + i + ".tres")
