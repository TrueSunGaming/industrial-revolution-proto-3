extends Node

var save: SaveData

func save_and_quit() -> void:
	if save: return save.save_and_quit()
	
	get_tree().quit()
