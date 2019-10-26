extends "res://Scripts/Enemigo.gd"

var atacando = false
var enVision = false
var cuerpoColision 
var golpeado = false

const DISPARO = preload("res://Escenas/DisparoEnemigo.tscn")

func _ready():
	GRAVITY = 0
	SPEED = 100
	FLOOR = Vector2(0, -1)
	motion = Vector2()
	movedir = Vector2(1,0)
	TYPE = "ENEMIGO"
	VT = 1
	is_dead = false
	DAMAGE = 1
	$TimerAtaque.set_wait_time(2)
	$TimerAtaque.start() 


func set_vt(value):
	VT = value
	
func _physics_process(delta):
	if is_dead == false:
		motion.y += GRAVITY
		print("Tiempo: ", TimerPickable.time_left)
		if not atacando:
			if not $AnimacionEnemigo.animation == "Quieto":
				$AnimacionEnemigo.play("Quieto")
				print("me he levantado")

		if movedir.x == 1:
			$AnimacionEnemigo.flip_h = false
			$Position2DDisparo.position.x = -1
		else:
			$AnimacionEnemigo.flip_h = true
			$Position2DDisparo.position.x = 1
		
		motion = move_and_slide(motion, FLOOR)
		damage_loop()
		
		if is_on_wall():
			if not atacando:
				movedir.x = movedir.x * -1
		
		if enVision and not cuerpoColision == null and not atacando:
			_on_CampoAtaque_body_entered(cuerpoColision)
			
		if atacando and $TimerAtaque.time_left == 0:
			$AnimacionEnemigo.play("Atacar")
			
		if $AnimacionEnemigo.animation == "Atacar" and $AnimacionEnemigo.frame == 7 and $TimerAtaque.time_left == 0:
			var disparo = DISPARO.instance()
			if sign($Position2DDisparo.position.x) == 1:
				disparo.set_disparo_direction(1)
				disparo.get_node("SpriteDisparo").position.x *= -1
				disparo.get_node("ColisionDisparo").position.x *= -1
			else:
				disparo.set_disparo_direction(-1)
			get_parent().add_child(disparo)
			disparo.position = $Position2DDisparo.global_position
			$TimerAtaque.start()
	else:
		move_and_slide(motion, FLOOR)	
func _on_AnimacionEnemigo_animation_finished():
	if $AnimacionEnemigo.animation == "Muerte":
		queue_free()
		save_load.delete_actor(self)
	if $AnimacionEnemigo.animation == "Atacar":
		$AnimacionEnemigo.play("Quieto")

func dead():
	.dead()
	remove_child($ColisionEnemigo)
	GRAVITY = 40
	motion.y += GRAVITY
	$AnimacionEnemigo.play("Muerte")




func _on_CampoDeVision_body_entered(body):
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		if body.get_global_position().x > self.get_global_position().x:
			if movedir.x == 1:
				movedir.x =-1
		if body.get_global_position().x < self.get_global_position().x:
			if movedir.x == -1:
				movedir.x =1
		enVision = true		

func _on_CampoAtaque_body_entered(body):
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		cuerpoColision = body
		atacando = true
		


func _on_CampoDeVision_body_exited(body):
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		enVision = false
		atacando = false
		cuerpoColision = null
