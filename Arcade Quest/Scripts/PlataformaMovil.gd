extends KinematicBody2D


var velocity = Vector2(150,0)
var initialX
var max_movement = 250
var movedir = Vector2(1,0)

func _ready():
	initialX = self.get_global_position().x

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta *-movedir)
	if collision and (collision.get_collider().is_in_group("paredNormal") or collision.get_collider().is_in_group("pared")):
		print("He chocado con una pared")
		velocity.x = velocity.x * movedir.x*-1
		

	if abs(self.get_global_position().x - initialX) >= max_movement:
		velocity.x = velocity.x * movedir.x*-1

	
	
	
	
	
	
	
	
	
	
	
	
