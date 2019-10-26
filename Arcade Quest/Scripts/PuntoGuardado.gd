extends Node2D

func _on_AreaPuntoGuardado_body_entered(body):
	if body.name == "Jugador":
		body.VT = 9
		save_load.save_to_slot("slot_1")
		$AnimationPlayer.play("Fade out")

func _on_AnimationPlayer_animation_finished(anim_name):
	$AreaPuntoGuardado/ColisionPuntoGuardado.disabled = true
