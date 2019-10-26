extends KinematicBody2D

var direccion = Vector2(0, 0)
const SPEED = 150
var motion = Vector2()
var padre 
var win
var dead 
var blinky
var inky
var pinky
var clyde


func _ready():
	$AnimatedSprite.play("Movimiento")
	padre = get_parent()
	position = padre.get_node("Position2D").position
	blinky = get_parent().get_node("Blinky")
	inky = get_parent().get_node("Inky")
	pinky = get_parent().get_node("Pinky")
	clyde = get_parent().get_node("Clyde")
	win = false
	dead = false

func _process(delta):
	if not win and not dead:
		if Input.is_action_just_pressed("ui_up"):
			direccion = Vector2(0, -1)
			rotation = deg2rad(-90)
		elif Input.is_action_just_pressed("ui_down"):
			direccion = Vector2(0, 1)
			rotation = deg2rad(90)
		elif Input.is_action_just_pressed("ui_left"):
			direccion = Vector2(-1,0)
			rotation = deg2rad(180)
		elif Input.is_action_just_pressed("ui_right"):
			direccion = Vector2(1, 0)
			rotation = deg2rad(0)
			
		motion = move_and_slide(direccion * SPEED * delta)
		if position.x < padre.get_node("Position2DIzda").position.x:
			position.y = padre.get_node("Position2DDcha").position.y
			position.x = padre.get_node("Position2DDcha").position.x -50
		if position.x > padre.get_node("Position2DDcha").position.x:
			position.y = padre.get_node("Position2DIzda").position.y
			position.x = padre.get_node("Position2DIzda").position.x +50
		position += SPEED * direccion * delta
		
		if get_parent().get_node("Puntos").get_child_count() == 0:
			win = true
		
		if win:
			var escenaWin =padre.get_node("CanvasWinPacman").get_node("EscenaWinPacMan")
			escenaWin.win()

func _on_AreaHitbox_area_entered(area):
	if area.get_parent().is_in_group("puntoPacman"):
		print("Soy un punto")
		area.get_parent().queue_free()
	elif area.get_parent().is_in_group("puntoPoder"):
		print("Soy un punto de poder")
		blinky.set_vulnerable(true)
		inky.set_vulnerable(true)
		pinky.set_vulnerable(true)
		clyde.set_vulnerable(true)
		area.get_parent().queue_free()

func dead():
	get_tree().paused = true
	dead = true
	$AnimatedSprite.play("Muerte")

func _on_AnimatedSprite_animation_finished():
	if dead:
		visible = false
		$CanvasGameOver/EscenaGameOver.gameOver()
