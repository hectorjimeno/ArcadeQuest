extends Node2D

onready var navigation : Navigation2D = $Navigation2D
onready var pac : KinematicBody2D = $PacManPersonaje
onready var blinky : KinematicBody2D = $Blinky
onready var inky : KinematicBody2D = $Inky
onready var pinky: KinematicBody2D = $Pinky
onready var clyde: KinematicBody2D = $Clyde
onready var posicionPacMan = Vector2()

var inkyTimer = Timer.new()
var blinkyTimer = Timer.new()
var pinkyTimer = Timer.new()
var clydeTimer = Timer.new()

func _ready():
	add_child(inkyTimer)
	add_child(blinkyTimer)
	add_child(clydeTimer)
	add_child(pinkyTimer)
	inkyTimer.set_wait_time(2)
	blinkyTimer.set_wait_time(4)
	pinkyTimer.set_wait_time(6)
	clydeTimer.set_wait_time(8)
	inkyTimer.one_shot = true
	blinkyTimer.one_shot = true
	pinkyTimer.one_shot = true
	clydeTimer.one_shot = true
	inkyTimer.start()
	blinkyTimer.start()
	pinkyTimer.start()
	clydeTimer.start()

func _process(delta):
	print(blinkyTimer.time_left)
	if not blinky.dead and blinkyTimer.time_left <= 0:
		var new_path = null
		posicionPacMan.x = $Position2DAux.position.x + ($Position2DAux.position.x - pac.global_position.x)
		posicionPacMan.y = $Position2DAux.position.y + ($Position2DAux.position.y - pac.global_position.y)
		if not blinky.vulnerable:
			new_path = navigation.get_simple_path(blinky.global_position, pac.global_position)
		else:
			new_path = navigation.get_simple_path(blinky.global_position,  posicionPacMan)
			blinky.set_speed(pac.SPEED - 70)
		blinky.path = new_path
	if not inky.dead and inkyTimer.time_left <= 0:
		var new_path = null
		if not inky.vulnerable:
			new_path = navigation.get_simple_path(inky.global_position, pac.global_position)
		else:
			new_path = navigation.get_simple_path(inky.global_position, posicionPacMan)
			inky.set_speed(pac.SPEED - 70)
		inky.path = new_path
	if not pinky.dead and pinkyTimer.time_left <= 0:
		var new_path = null
		if not pinky.vulnerable:
			new_path = navigation.get_simple_path(pinky.global_position, pac.global_position)
		else:
			new_path = navigation.get_simple_path(pinky.global_position, posicionPacMan)
			pinky.set_speed(pac.SPEED -70)
		pinky.path = new_path
	if not clyde.dead and clydeTimer.time_left <= 0:
		var new_path = null
		if not clyde.vulnerable:
			new_path = navigation.get_simple_path(clyde.global_position, pac.global_position)
		else:
			new_path = navigation.get_simple_path(clyde.global_position, posicionPacMan)
			clyde.set_speed(pac.SPEED - 70)		
		clyde.path = new_path
