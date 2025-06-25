# collectible.gd
extends Area3D

# Signal qui sera émis lorsque l'objet est collecté.
signal collected

@export var rotation_speed = 2.0

func _process(delta):
	rotate_y(rotation_speed * delta)


# C'est la fonction qui est appelée AUTOMATIQUEMENT par Godot
# quand un corps physique (comme notre joueur) entre dans l'Area3D.
func _on_body_entered(body):
	# On vérifie que le corps qui est entré est bien le joueur.
	if body.is_in_group("player"):
		# On envoie le signal "collected" pour alerter la scène principale.
		emit_signal("collected")
		
		# On demande à l'objet de se supprimer de la scène.
		queue_free()
