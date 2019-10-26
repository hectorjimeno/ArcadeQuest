extends Area2D

const SPEED = 1200
var DMG = 1
var motion = Vector2()
var direction = 1
var colision = false
var golpeado = false

export (int) var dmg = DMG

func set_dmg(value):
	dmg = value

func _ready():
	dmg = 1

func set_disparo_direction(dir):
	direction = dir
	if dir == -1:
		$SpriteDisparo.flip_h = true
	else:
		$SpriteDisparo.flip_h = false
		
func _physics_process(delta):
	motion.x = SPEED * delta * direction 
	if not colision:
		translate(motion)
		if dmg < 6:
			$SpriteDisparo.play("Disparar")
		else:
			$SpriteDisparo.play("DispararGrande")

func _on_Disparo_body_entered(body):
	var nodo = body
	if not nodo.get("TYPE") == null and "ENEMIGO" in nodo.TYPE:
		print("dmg: ", dmg)
		nodo.set_vt(nodo.VT -dmg)
		print("soy un enemiiiiiiiiiigo")
		print(nodo.VT)
		if body.name == "EnemigoTierraEscudo":
			body.knockbackDir = body.get_global_position().x - get_global_position().x
			body.get_node("AnimacionEnemigo").play("Danio")
			body.danio = true
			body.daniosign = true
		if nodo.VT <= 0:
			nodo.dead()
			motion = Vector2(0,0)
	elif not nodo.get("TYPE") == null and "JUGADOR" in nodo.TYPE:
		if not nodo.danio:
			nodo.get_node("Sprite").play("Danio")
			nodo.set_vt(nodo.VT -2)
			nodo.danio = true
			nodo.knockbackDir = nodo.get_global_position().x - get_global_position().x
			golpeado = true
			if nodo.VT <= 0:
				nodo.dead()
				motion = Vector2(0,0)
	if $SpriteDisparo.animation == "Disparar":
		$SpriteDisparo.play("Destruir")
	elif $SpriteDisparo.animation == "DispararGrande":
		$SpriteDisparo.play("DestruirGrande")
	colision = true
	

		

func _on_SpriteDisparo_animation_finished():
	if $SpriteDisparo.animation == "Destruir" or $SpriteDisparo.animation == "DestruirGrande":
		queue_free()
		golpeado = false
		

func _on_Disparo_area_entered(area):
	if area.name == "Disparo":
		print ("Entrando en area disparo")
		motion = Vector2(0,0)
		colision = true
		area.motion = Vector2(0,0)
		area.colision = true
		area.get_node("SpriteDisparo").play("Destruir")
		$SpriteDisparo.play("Destruir")
