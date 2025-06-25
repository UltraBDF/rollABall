# collectible.gd
extends Area3D

signal collected

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("collected")
		queue_free()
