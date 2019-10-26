extends KinematicBody2D

var TYPE = "ENEMIGO"
var GRAVITY = 0
var SPEED = 0
var FLOOR = Vector2(0,0)
var VT = 0
var motion = Vector2()
var movedir = Vector2(0,0)
var knockbackDir = 0
var is_dead = false
var DAMAGE = 0
var hitstun = 0
var danio = false

const POCION = preload("res://Escenas/PocionSalud.tscn")
const MUNICION = preload("res://Escenas/EscenaMunicion.tscn")

var TimerPickable = Timer.new()

func _ready():
	TimerPickable.set_wait_time(5)
	add_child(TimerPickable)
	TimerPickable.one_shot = false
	TimerPickable.start()

func damage_loop():
	for area in $Hitbox.get_overlapping_areas():
			if "Hitbox" in area.name:
				print("He entrado")
				var body = area.get_parent()
				print (area.name)
				if not body.is_dead:
						print(body.name)
						VT -= body.get("DAMAGE")
						if "Jugador" in body.name:
							print("di algo")
							body.knockbackDir = body.get_global_position().x - get_global_position().x
							body.get_node("Sprite").play("Danio")
							body.danio = true
							body.daniosign = true
							print("Vida del jugador", body.VT)
							print("Colision con enemigo")
							if not "EnemigoTierraEscudo" in name:
								$AnimacionEnemigo.play("Quieto")
							if "EnemigoTierraGeneral" in name:
								$AnimacionEnemigo.play("Movimiento")
							if has_node("TimerAtaque"):
								$TimerAtaque.start()
						if body.VT<= 0:
							body.dead()
			


func dead():
	if not self.name == "Jugador":
		if TimerPickable.time_left > 2 and TimerPickable.time_left < 2.5:
			var pocion = POCION.instance()
			get_parent().add_child(pocion)
			pocion.position = global_position
		elif TimerPickable.time_left >2.5 and TimerPickable.time_left < 3:
			var municion = MUNICION.instance()
			get_parent().add_child(municion)
			municion.position = global_position
	is_dead = true
	remove_child($Hitbox)
	remove_child($CampoDeVision)
	remove_child($CampoAtaque)
	print("Estoy muerto ", is_dead)
	motion = Vector2(0,0)
