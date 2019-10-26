extends Area2D

func _physics_process(delta):
	var bodies = get_
	print(bodies)
	for body in bodies:
		if body.name == "Jugador":
			print("He chocado con el jugador")
