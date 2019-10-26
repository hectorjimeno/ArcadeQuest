extends Control

func win():
	$PopupGameOver.show()
	$AnimacionGameOver.play("Mostrar")
	get_tree().paused = true
	$TimerWin.start()
	#Global.pause = true

func _on_TimerWin_timeout():
			get_tree().paused = false
			$PopupGameOver.hide()
			Global.main_menu()
			print(get_parent().name)
			get_parent().get_parent().queue_free()
