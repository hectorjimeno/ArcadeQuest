extends Node

var current_scene = null
var pause = null
var points = 0
var player_name = "player"
var first_level = "res://Escenas/Escena01.tscn"
var main_menu = "res://Escenas/MenuTitulo.tscn"
var interfaz
var instanciaInterfaz
var VT = 9
var AMMO = 5

func player():
	for x in get_tree().get_nodes_in_group("player"):
		return x

func time(sec):
	var timer = Timer.new()
	timer.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().get_root().add_child(timer) #to process
	timer.set_wait_time(sec) # Set Timer's delay to "sec" seconds
	timer.start() # Start the Timer counting down
	return timer

func delete_actor(relate):
	print("Eliminando enemigo")
	save_load.current_data.erase([level_root().filename, relate.name])
	relate.queue_free()

func teleport_actor(relate, map, pos_ID):
	if save_load.current_data.has([level_root().filename, relate.name]):
		var old = (save_load.current_data[[level_root().filename, relate.name]]).duplicate()
		save_load.current_data[[map, relate.name]] = old
		save_load.current_data[[map, relate.name]]["next_pos_ID"] = pos_ID
		save_load.current_data.erase([level_root().filename, relate.name])
		relate.queue_free()

func change_level(map, pos_ID):
	teleport_actor(player(), map, pos_ID)
	yield(time(0.01), "timeout")
	get_tree().change_scene(map)


func first_level():
	#interfaz = preload("res://Escenas/Interface.tscn")
	cargar_interfaz()
	save_load.visited_maps = []
	save_load.update_current_data()
	print(current_scene)
	AMMO = 5
	VT = 9
	get_tree().change_scene(first_level)

	#instanciaInterfaz = interfaz.instance()
	
	#add_child(instanciaInterfaz)
	
func main_menu():
	AMMO = 5
	VT = 9
	get_tree().change_scene(main_menu)
	remove_child(instanciaInterfaz)


func cargar_interfaz():
	interfaz = preload("res://Escenas/Interface.tscn")
	instanciaInterfaz = interfaz.instance()
	add_child(instanciaInterfaz)

func level_root():
	for x in get_tree().get_nodes_in_group("level_root"):
		return x

func main():
	return level_root().get_node("main")

func get_position_2D(ID):
	for x in get_tree().get_nodes_in_group("pos"):
		if x.name == ID:
			return x
