extends Node2D

func _on_area_2d_body_entered(_body):
	$AnimationPlayer.play("fade_in")

func _on_area_2d_body_exited(_body):
	$AnimationPlayer.play("fade_out")
