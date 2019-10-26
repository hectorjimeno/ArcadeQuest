extends Node2D


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _on_Area2DParedFuerte_area_entered(area):
		if area.is_in_group("disparo"):
			if area.dmg > 6:
				$AnimationPlayer.play("Fade")

				
