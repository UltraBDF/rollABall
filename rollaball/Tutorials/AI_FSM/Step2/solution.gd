extends CharacterBody2D

var current_state: State

func _ready():
	# Nous initialiserons l'état à la prochaine étape.
	pass

func _physics_process(delta):
	# On délègue la logique de mise à jour à l'état actuel.
	if current_state:
		current_state.update(delta)
