extends KinematicBody2D

var padre
var vulnerable = false
var dead
var posicionInicial = Vector2()
export var speed := 0
var velocidadInicial = speed

func set_speed(value):
	speed = value

func get_speed():
	return speed

func _on_TimerRespawn_timeout():
	$ColisionEnemigoPacman.disabled = false
	visible = true
	$TimerRespawn.stop()
	dead = false
	set_vulnerable(false)

func _on_AreaHitBox_body_entered(body):
	if body.name == "PacManPersonaje":
		if vulnerable:
			visible = false
			$ColisionEnemigoPacman.disabled = true
			position = padre.get_node("Position2DEspera").position
			$TimerRespawn.start()
			set_vulnerable(false)
			dead = true
		else:
			body.dead()
			
var path : = PoolVector2Array() setget set_path

func _ready() -> void:
	set_process(false)
	$AnimacionEnemigoPacman.play("Lado")
	padre = get_parent()
	posicionInicial = padre.get_node("Position2DEspera").position
	position = posicionInicial
	velocidadInicial = get_speed()
	dead = false
	$TimerVulnerable.set_wait_time(6)

func _process(delta: float) -> void:
	if not dead:
		var move_distance = speed * delta
		move_along_path(move_distance)
		

func set_vulnerable(value):
	if value:
		if not dead and not position == posicionInicial:
			vulnerable = true
			$TimerVulnerable.start()
			$AnimacionEnemigoPacman.play("Vulnerable")
	else:
		$AnimacionEnemigoPacman.play("Lado")
		vulnerable = false
		set_speed(velocidadInicial)

func move_along_path(distance : float) -> void:
	var start_point : = position
	for i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value : PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	set_process(true)

func _on_TimerVulnerable_timeout():
	set_vulnerable(false)
