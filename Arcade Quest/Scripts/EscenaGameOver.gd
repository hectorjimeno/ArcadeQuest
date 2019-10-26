extends Control

var continuar
var salir

func _ready():
	continuar = get_node("PopupGameOver/ColorRect/VBoxContainer/BtContinuar")
	salir = get_node("PopupGameOver/ColorRect/VBoxContainer/BtSalir")
	if save_load.slots["slot_1"].empty():
		$PopupGameOver/ColorRect/VBoxContainer/BtContinuar.disabled = true


func _physics_process(delta):
	if continuar.is_hovered():
		continuar.grab_focus()	
	if salir.is_hovered():
		salir.grab_focus()	

func gameOver():
	$PopupGameOver.show()
	$AnimacionGameOver.play("Mostrar")
	get_tree().paused = true
	Global.pause = true	
	continuar.grab_focus()	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if continuar.has_focus() and not $PopupGameOver/ColorRect/VBoxContainer/BtContinuar.disabled:
			get_tree().paused = false
			$PopupGameOver.hide()
			Global.pause = false
			if ! save_load.slots["slot_1"].empty():
				save_load.load_from_slot("slot_1")
		elif salir.has_focus():
			get_tree().paused = false
			$PopupGameOver.hide()
			Global.main_menu()
