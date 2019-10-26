# MenuInicio.gd
extends Control


func _on_StartButton_pressed():
	get_tree().change_scene("res://FaseDebug.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
