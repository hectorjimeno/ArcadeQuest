extends "res://Scripts/Enemigo.gd"

var atacando = false

func _ready():
	GRAVITY = 20
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
	if not is_dead:
		motion.x = SPEED * -movedir.x
		motion.y += GRAVITY
		
		if movedir.x == 1:
			$AnimacionEnemigo.flip_h = false
		else:
			$AnimacionEnemigo.flip_h = true
			
		motion = move_and_slide(motion, FLOOR)
		damage_loop()
		
		if is_on_wall():
			if not atacando:
				movedir.x = movedir.x * -1
				$RayCastEnemigo.position.x *= -1
		
		if $RayCastEnemigo.is_colliding() == false:
			movedir.x = movedir.x * -1
			$RayCastEnemigo.position.x *= -1
		
		if not atacando:
			$AnimacionEnemigo.play("Movimiento")
		
func _on_AnimacionEnemigo_animation_finished():
	if $AnimacionEnemigo.animation == "Muerte":
		queue_free()
		save_load.delete_actor(self)
	elif $AnimacionEnemigo.animation == "Atacar":
		atacando = false

func dead():
	.dead()
	remove_child($ColisionEnemigo)
	$AnimacionEnemigo.play("Muerte")



func _on_CampoDeVision_body_entered(body):
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		if body.get_global_position().x > self.get_global_position().x:
			if movedir.x == 1:
				$RayCastEnemigo.position.x *= -1
				movedir.x =-1
		if body.get_global_position().x < self.get_global_position().x:
			if movedir.x == -1:
				$RayCastEnemigo.position.x *= -1
				movedir.x =1


func _on_CampoAtaque_body_entered(body):
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		if $TimerAtaque.time_left == 0:
			$AnimacionEnemigo.play("Atacar")
			$TimerAtaque.set_wait_time(2)
			$TimerAtaque.start()
			atacando = true
		
