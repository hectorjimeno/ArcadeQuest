extends "res://Scripts/Enemigo.gd"

var initialX

func _ready():

	SPEED = 100
	FLOOR = Vector2(0, -1)
	motion = Vector2()
	movedir = Vector2(1,0)
	TYPE = "ENEMIGO"
	VT = 1
	is_dead = false
	DAMAGE = 1
	initialX = self.get_global_position().x

func set_vt(value):
	VT = value
	
func _physics_process(delta):
	if is_dead == false:
		print(TimerPickable.time_left)
		motion.y = 0
		motion.x = SPEED * -movedir.x
		
		if movedir.x == 1:
			$AnimacionEnemigo.flip_h = false
		else:
			$AnimacionEnemigo.flip_h = true
		motion = move_and_slide(motion, Vector2())
		damage_loop()
		
		if is_on_wall():
			movedir.x = movedir.x * -1
		if abs(self.get_global_position().x) - initialX < -200:
			movedir.x *=-1 
	else:
		move_and_slide(motion, Vector2())
	if not is_dead:
		$AnimacionEnemigo.play("Movimiento")	
	
func _on_AnimacionEnemigo_animation_finished():
	if $AnimacionEnemigo.animation == "Muerte":
		queue_free()
		save_load.delete_actor(self)

func dead():
	.dead()
	remove_child($ColisionEnemigo)
	GRAVITY = 100
	motion.y += GRAVITY
	$AnimacionEnemigo.play("Muerte")
		
