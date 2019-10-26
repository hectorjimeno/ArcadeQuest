extends Area2D

const SPEED = 700
const DMG = 1
var motion = Vector2()
var direction = 1
var colision = false

export (int) var dmg = DMG

func _ready():
	dmg = 1

func set_ataque_direction(dir):
	direction = dir
	if dir == -1:
		$SpriteAtaque.flip_h = true
	else:
		$SpriteAtaque.flip_h = false

func _physics_process(delta):
		$SpriteAtaque.play("Atacar")



func _on_SpriteAtaque_animation_finished():
	if $SpriteAtaque.animation == "Atacar":
		queue_free()


func _on_Ataque_body_entered(body):
	if not body.get("TYPE") == null and "ENEMIGO" in body.TYPE:
		print("Colision con enemigo de slash")
		var nodo = body
		nodo.set_vt(nodo.VT -dmg)
		print (nodo.VT)
		if body.name == "EnemigoTierraEscudo":
			body.knockbackDir = body.get_global_position().x - get_global_position().x
			body.get_node("AnimacionEnemigo").play("Danio")
			body.danio = true
			body.daniosign = true
		if nodo.VT == 0:
			nodo.dead()
