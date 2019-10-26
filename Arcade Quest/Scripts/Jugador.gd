extends "res://Scripts/Enemigo.gd"

const UP = Vector2(0, -1)
const MAX_SPEED = 300
const JUMP_HEIGHT = -650
const ACCELERATION = 50
const MAX_JUMPS = 2

const DISPARO = preload("res://Escenas/Disparo.tscn")
const ATAQUE = preload("res://Escenas/Ataque.tscn")
const CARGADISPARO = preload("res://Escenas/EscenaDisparoCargando.tscn")

var jumps = 0
var agachado = false
var atacando = false
var disparando = false
var escalando = false
var current_animation = "Quieto"
var is_on_ladder = false
var next_pos_ID = ""
var enParedIzda = false
var enParedDcha = false
var esquivando = false
var daniosign = false
var cuerpoPickable = null
var AMMO
var cargando = false
var disparoDMG = 1
var cargaDisparo = null

export (int) var climb_speed


func _ready():
	GRAVITY = 25
	VT = Global.VT
	AMMO = Global.AMMO
	motion = Vector2()
	TYPE = "JUGADOR"
	movedir = Vector2()
	is_dead = false
	$TimerDisparo.set_wait_time(0.5)
	$TimerAtaque.set_wait_time(0.5)
	$TimerDisparo.start()
	$TimerAtaque.start()
	$TimerDash.start()
	danio = false

func set_vt(value):
	VT = value

func set_ammo(value):
	AMMO = value

func _init():
	AMMO = Global.AMMO
	VT = Global.VT
	print("He inicializado")

func _physics_process(delta):
	
	if not is_dead:
		Global.AMMO = AMMO
		Global.VT = VT
		if not is_on_ladder:
			escalando = false
		
		if not escalando and not enParedDcha and not enParedIzda:
			motion.y += GRAVITY
		var friction = false
		
		if agachado:
			$HitboxAgachado/ColisionAgachado.disabled = false
			$Hitbox/CollisionShape2D.disabled = true

		else:
			$Hitbox/CollisionShape2D.disabled = false
			$HitboxAgachado/ColisionAgachado.disabled = true
		
		if not danio and not esquivando:
			if Input.is_action_pressed("ui_right"):
				if not disparando and not atacando and not agachado and not escalando and not enParedDcha and not cargando:
					if enParedIzda:
						enParedIzda = false
					motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
					if is_on_floor():
						$Sprite.play("Correr")
					if sign($Position2DDisparoPie.position.x) == -1:
						$Position2DDisparoAgachado.position.x *= -1
						$Position2DDisparoPie.position.x *= -1
					$Sprite.flip_h = false
			elif Input.is_action_pressed("ui_left"):
				if not disparando and not atacando and not agachado and not escalando and not enParedIzda and not cargando:
					if enParedDcha:
						enParedDcha = false
					motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
					if is_on_floor():
						$Sprite.play("Correr")
					if sign($Position2DDisparoPie.position.x) == 1:
						$Position2DDisparoAgachado.position.x *= -1
						$Position2DDisparoPie.position.x *= -1
					$Sprite.flip_h = true
			else:
				if is_on_floor() and not disparando and not atacando and not agachado:
					$Sprite.play("Quieto")
				friction = true
			if Input.is_action_pressed("Disparar") and not agachado and is_on_floor():
				if $TimerDisparo.time_left == 0 and AMMO > 0:
					motion.x = 0
					if not cargando:
						cargaDisparo = CARGADISPARO.instance()
						cargaDisparo.position = $Position2DDisparoPie.global_position
						get_parent().add_child(cargaDisparo)
					cargando = true
					if disparoDMG + 0.03 < 8.01:
						disparoDMG += 0.03
					else:
						disparoDMG = 8
					$Sprite.play("Disparar")
			if Input.is_action_just_released("Disparar"):
				if $TimerDisparo.time_left == 0 and AMMO > 0:
					var disparo = DISPARO.instance()
					print(disparo.dmg)
					if sign($Position2DDisparoPie.position.x) == 1:
						disparo.set_disparo_direction(1)
					else:
						disparo.set_disparo_direction(-1)
					get_parent().add_child(disparo)
					if agachado:
						disparo.position = $Position2DDisparoAgachado.global_position
					else:
						disparo.position = $Position2DDisparoPie.global_position
					if jumps < 2:	
						if is_on_floor() and not agachado:
							$Sprite.play("Disparar")
							if disparoDMG > 2:
								disparo.set_dmg(disparoDMG)
							disparando = true
							motion.x = 0
					if cargando:
						cargando = false
						cargaDisparo.queue_free()
						cargaDisparo = null
					cargando = false
					AMMO -= 1
					disparoDMG = 1
					$TimerDisparo.start()
			if Input.is_action_just_released("ui_down") and not cargando:
				agachado = false
			if Input.is_action_just_pressed("Atacar") and not cargando:
				if not escalando and not agachado:
					if $TimerAtaque.time_left == 0:
						var ataque = ATAQUE.instance()
						if sign($Position2DDisparoPie.position.x) == 1:
							ataque.set_ataque_direction(1)
						else:
							ataque.set_ataque_direction(-1)
						get_parent().add_child(ataque)
						ataque.position = $Position2DDisparoAgachado.global_position
						if jumps <2:
							if is_on_floor():
								$Sprite.play("Atacar")
								atacando = true
								motion.x = 0
							else:
								$Sprite.play("AtacarAire")
						$TimerAtaque.start()
			if Input.is_action_pressed("ui_up") and is_on_ladder:
					escalando = true
					motion.y =-climb_speed
					friction = false
					motion.x = 0
					$Sprite.play("Escalar")	
				
			if is_on_floor() and not cargando:
				jumps = 0
				if Input.is_action_just_pressed("Saltar") and not agachado:
					motion.y = JUMP_HEIGHT
					print("Numero de saltos = ", jumps)
				elif Input.is_action_pressed("ui_down"):
					if not agachado:
						$Sprite.play("Agacharse")
						if not cuerpoPickable == null:
							if cuerpoPickable.is_in_group("pocion"):
								if VT + 2 < 9:
									set_vt(VT+2)
								else:
									set_vt(9)
								print(VT)
							elif cuerpoPickable.is_in_group("municion"):
								if AMMO + 2 < 5:
									set_ammo(AMMO + 2)
								else:
									set_ammo(5)
								print(AMMO)
							cuerpoPickable.queue_free()
						print("Me he agachado")
					agachado = true
					motion = Vector2(0,0)
				if friction == true:
					motion.x = lerp(motion.x, 0, 0.2)
			elif not agachado and not cargando:
				if not escalando:
					if jumps == 0:
						jumps += 1
						if not enParedDcha and not enParedIzda:
							$Sprite.play("Saltar")
					if motion.y<0:
						if friction == true:
							motion.x = lerp(motion.x, 0, 0.05)
					else:
						if not enParedDcha and not enParedIzda:
							$Sprite.play("Caer")
							if friction == true:
								motion.x = lerp(motion.x, 0, 0.05)
					if Input.is_action_just_pressed("Saltar"):
						if jumps < MAX_JUMPS:
							if enParedDcha:
								motion.x = -400
								motion.y = JUMP_HEIGHT
								$Sprite.flip_h = true
							elif enParedIzda:
								motion.x = 400
								motion.y = JUMP_HEIGHT
								$Sprite.flip_h = false
							else:
								motion.y = JUMP_HEIGHT / 1.2
								print("Saltos: ", jumps)
							jumps += 1
							$Sprite.play("DobleSalto")
						
			if escalando and Input.is_action_just_released("ui_up"):
				motion.y = 0
				$Sprite.stop()
			elif escalando and (Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
				escalando = false
			
			if Input.is_action_just_released("Dash") and $TimerDash.time_left == 0 and not enParedDcha and not enParedIzda:
				if $Sprite.animation == "Quieto" or $Sprite.animation == "Correr" or not is_on_floor() and jumps < 2:
					esquivando = true
					set_collision_layer_bit(0, false)
					jumps +=1
					$Sprite.play("Dash")
					
		if esquivando:
			motion = move_and_slide(Vector2(sign($Position2DDisparoPie.position.x)*450, 0), FLOOR)
		elif daniosign:
			if not escalando:
				motion = move_and_slide(Vector2(sign(knockbackDir)*300,-200), FLOOR)
			daniosign = false
		else:
			motion = move_and_slide(motion, UP)
		if not danio and not esquivando:
			damage_loop()
		else:
			if escalando:
				escalando = false
			if esquivando:
				$Hitbox.set_collision_layer_bit(0, false)
	else:
		print("Knockback direction: ", sign(knockbackDir))
		motion = move_and_slide(Vector2(sign(knockbackDir)*1200, -300), FLOOR)

func _on_Sprite_animation_finished():
	if atacando:
		atacando = false
	if disparando:
		disparando = false
	if danio:
		danio = false
	if esquivando:
		esquivando = false
		$Colision.disabled = false
		$Hitbox.set_collision_layer_bit(0, true)
		$TimerDash.start()


func dead():
	.dead()
	remove_child($Colision)
	remove_child($HitboxAgachado)
	remove_child($AreaColisionAux)
	remove_child($Area2DDcha)
	remove_child($Area2DIzda)
	$Sprite.play("Muerte")
	var temporizador = Timer.new()
	temporizador.wait_time = 1
	temporizador.connect("timeout", self, "_on_AuxDeadTimer_timeout")
	add_child(temporizador)
	temporizador.start()

	
func _on_AuxDeadTimer_timeout():
	$CanvasGameOver/EscenaGameOver.gameOver()


func _on_Area2DIzda_body_entered(body):
	if body.is_in_group("pared") and not is_on_floor() and not danio and not daniosign:
		enParedIzda = true
		esquivando = false
		jumps = 0
		$Sprite.play("SaltoPared")
		motion.y = GRAVITY *3.5
		print("He tocado una pared a mi izquierda")


func _on_Area2DDcha_body_entered(body):
	if body.is_in_group("pared") and not is_on_floor() and not danio and not daniosign:
		enParedDcha = true
		esquivando = false
		jumps =0
		$Sprite.play("SaltoPared")
		motion.y = GRAVITY *3.5
		print("He tocado una pared a mi derecha")


func _on_Area2DIzda_body_exited(body):
	if body.is_in_group("pared"):
		enParedIzda = false


func _on_Area2DDcha_body_exited(body):
	if body.is_in_group("pared"):
		enParedDcha = false


func _on_Hitbox_area_entered(area):
	if area.get_parent().is_in_group("pickable"):
		print("He entrado en un cuerpo pickable")
		cuerpoPickable = area.get_parent()
		


func _on_Hitbox_area_exited(area):
	if area.get_parent().is_in_group("pickable"):
		cuerpoPickable = null


func _on_VisibilityNotifier2D_screen_exited():
	dead()



func _on_Hitbox_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("pickable"):
		print("He entrado en un cuerpo pickable")
		cuerpoPickable = body
