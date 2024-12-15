extends Node

const environments := [
	"factory"
]

const resources := [
	"fallback",
	"tiles/transformers/assemblers/assembler_1"
]

func _init() -> void:
	for i in environments: load("res://scenes/environment/" + i + "/" + i + ".tres")
	for i in resources: load("res://scripts/resource/resources/" + i + ".tres")
