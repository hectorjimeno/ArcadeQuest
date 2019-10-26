extends Node2D


var disparado = false

func _ready():
	$TimerCarga.set_wait_time(3)
	$TimerCarga.start()
	$AnimatedSpriteDisparoCargando.play("Cargando")

func _on_TimerCarga_timeout():
	$AnimatedSpriteDisparoCargando.play("Cargado")
