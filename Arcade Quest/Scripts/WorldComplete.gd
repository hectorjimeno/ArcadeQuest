extends Node2D

export(String, FILE, "*.tscn") var map
export var pos_id = ""


func _on_Area2D_body_entered(body):
	if body.name == "Jugador":
		print("He entrado en el area de teletransporte")
		#get_tree().set_pause(true)
		save_load.update_current_data()
		Global.change_level(map, pos_id)

		#get_tree().change_scene("res://Pac-Man/Escenas/PacMan.tscn")
		
		
#		var s = ResourceLoader.load("res://Pac-Man/Escenas/PacMan.tscn")	
#		var scene = s.instance()
#		get_parent().queue_free()
#		get_tree().get_root().add_child(scene)
