# collectible.gd
extends Area3D

# Signal to be emitted when the object is collected.
signal collected

@export var rotation_speed = 2.0

func _process(delta):
	rotate_y(rotation_speed * delta)

# This is the function that is called AUTOMATICALLY by Godot
# when a physical body (like our player) enters Area3D.
func _on_body_entered(body):
	# We check that the body that has entered is actually the player.
	if body.is_in_group("player"):
		# The “collected” signal is sent to alert the main stage.
		emit_signal("collected")
		
		# The object is asked to remove itself from the scene.
		queue_free()
