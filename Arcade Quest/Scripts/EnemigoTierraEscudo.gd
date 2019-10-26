extends "res://Scripts/Enemigo.gd"

var atacando = false
var enVision = false
var cuerpoColision 
var daniosign = false
var golpeado = false

func _ready():
	GRAVITY = 20
	SPEED = 100
	FLOOR = Vector2(0, -1)
	motion = Vector2()
	movedir = Vector2(1,0)
	TYPE = "ENEMIGO"
	VT = 2
	is_dead = false
	DAMAGE = 1
	$TimerAtaque.set_wait_time(2)
	$TimerAtaque.start() 


func set_vt(value):
	VT = value
	
func _physics_process(delta):
	if is_dead == false:
		motion.y += GRAVITY
		if not daniosign:
			if not danio:
				if not enVision and not atacando:
					motion.x = 0
					if motion.x == 0 and not $AnimacionEnemigo.animation == "Quieto":
						print("Reproduciendo quieto")
						$AnimacionEnemigo.play("Quieto")
				elif not atacando:
					motion.x = SPEED * -movedir.x
					$AnimacionEnemigo.play("Movimiento")
		
				if movedir.x == 1:
					#print ("x = 1")
					$AnimacionEnemigo.flip_h = true
				else:
					#print ("x = ", movedir.x)
					$AnimacionEnemigo.flip_h = false
		#		if not atacando:
		#			$AnimacionEnemigo.play("Movimiento")	
			motion = move_and_slide(motion, FLOOR)
		else:
			print("Knockback direction: ", sign(knockbackDir))
			motion = move_and_slide(Vector2(sign(knockbackDir)*100, -100), FLOOR)
			daniosign = false
		damage_loop()
		
		
		if is_on_wall():
			if not atacando:
				movedir.x = movedir.x * -1
				$RayCastEnemigo.position.x *= -1

		if $RayCastEnemigo.is_colliding() == false:
			print("Caballero colliding")
			movedir.x = movedir.x * -1
			$RayCastEnemigo.position.x *= -1
			$CampoAtaque/ColisionAtaque.position.x *= -1
			
		if $AnimacionEnemigo.animation == "Atacar" and $AnimacionEnemigo.frame == 7:
			if  not cuerpoColision == null and cuerpoColision.TYPE == "JUGADOR" and not golpeado:
				cuerpoColision.VT -= get("DAMAGE")
				cuerpoColision.get_node("Sprite").play("Danio")
				cuerpoColision.danio = true
				golpeado = true
				print("EL cuerpo es: ", cuerpoColision)
				print("Vida: ", cuerpoColision.VT)
				if cuerpoColision.VT <= 0:
					cuerpoColision.dead()

		
		
func _on_AnimacionEnemigo_animation_finished():
	if is_dead:
		queue_free()
		save_load.delete_actor(self)
	elif atacando:
		atacando = false
		golpeado = false
	elif danio:
		danio = false

func dead():
	.dead()
	remove_child($ColisionEnemigo)
	$AnimacionEnemigo.play("Muerte")


func _on_CampoDeVision_body_entered(body):
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		
		if body.get_global_position().x > self.get_global_position().x:
			if movedir.x == 1:
				$RayCastEnemigo.position.x *= -1
				$CampoEspada/ColisionEspada.position.x *= -1
				movedir.x =-1
		if body.get_global_position().x < self.get_global_position().x:
			if movedir.x == -1:
				$RayCastEnemigo.position.x *= -1
				$CampoEspada/ColisionEspada.position.x *= -1
				movedir.x =1
		$AnimacionEnemigo.play("Movimiento")
		motion.x = SPEED * -movedir.x
		enVision = true
		

func _on_CampoAtaque_body_entered(body):
	print("He entrado en el campo de ataque")
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		cuerpoColision = body
		print("Tiempo: ", $TimerAtaque.time_left)
		if $TimerAtaque.time_left == 0:
			$AnimacionEnemigo.play("Atacar")
			motion.x = 0
			$TimerAtaque.set_wait_time(2)
			$TimerAtaque.start()
			atacando = true

		


func _on_CampoDeVision_body_exited(body):
	if not body.get("TYPE") == null and "JUGADOR" in body.TYPE:
		enVision = false
		cuerpoColision = null


func _on_CampoEspada_body_exited(body):
	cuerpoColision = null
