extends Control

var continuar
var salir

func _ready():
	continuar = get_node("PopupPausa/VBoxContainer/BtContinuar")
	salir = get_node("PopupPausa/VBoxContainer/BtSalir")


func _physics_process(delta):
	if continuar.is_hovered():
		continuar.grab_focus()	
	if salir.is_hovered():
		salir.grab_focus()	


func _input(event):
	if(not Global.pause):
		if event.is_action_pressed("pause"):
			if not get_tree().paused:
				get_tree().paused = true
				$PopupPausa.show()
				continuar.grab_focus()
			else:
				get_tree().paused = false
				$PopupPausa.hide()
		if event.is_action_released("ui_accept"):
			if continuar.has_focus():
				get_tree().paused = false
				$PopupPausa.hide()
			elif salir.has_focus():
				get_tree().paused = false
				$PopupPausa.hide()
				Global.main_menu()
