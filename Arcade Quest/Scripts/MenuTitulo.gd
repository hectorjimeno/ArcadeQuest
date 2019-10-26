extends Node

var start
var continuar
var salir
var hud: PackedScene

func _ready():
	Global.current_scene = self.get_tree().get_current_scene()
	start = get_node("MarginContainerMenuInicio/VBoxBotonesMenuInicio/BtStart")
	continuar = get_node("MarginContainerMenuInicio/VBoxBotonesMenuInicio/BtContinue")
	salir = get_node("MarginContainerMenuInicio/VBoxBotonesMenuInicio/BtSalir")
	start.grab_focus()
	
func _physics_process(delta):
	if $AnimationPlayer.is_playing():
		get_tree().get_root().set_disable_input(true)
	else:
		get_tree().get_root().set_disable_input(false)
		if start.is_hovered():
			start.grab_focus()	
		if continuar.is_hovered():
			continuar.grab_focus()
		if salir.is_hovered():
			salir.grab_focus()	
		if Input.is_action_just_pressed("ui_accept"):
			if start.has_focus():
				#PONER ESTO EN LA MEMORIA
				$AnimationPlayer.rset("Intro", 0)
				self.queue_free()
				Global.first_level()
			if salir.has_focus():
				get_tree().quit()

func _on_BtContinue_pressed():
	if ! save_load.slots["slot_1"].empty():
		save_load.load_from_slot("slot_1")
		Global.cargar_interfaz()
