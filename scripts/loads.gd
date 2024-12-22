extends Node

const player_inventory_gui: PackedScene = preload("res://scenes/ui/gui/player-inventory/PlayerInventoryGUI.tscn")
const debug_gui: PackedScene = preload("res://scenes/ui/gui/debug/DebugWindow.tscn")

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
