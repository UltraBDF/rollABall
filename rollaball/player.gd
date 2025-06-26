extends CharacterBody3D

# Vitesse de déplacement du joueur
@export var speed = 14.0
@export var acceleration = 5.0
@export var deceleration = 1.0

# Obtenir la gravité définie dans les paramètres du projet.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# On définit une "vitesse cible" basée sur l'entrée.
	var target_velocity = direction * speed

	var accel 
	if direction != Vector3.ZERO:
		# Si le joueur appuie sur une touche, on utilise la variable d'accélération.
		accel = acceleration
	else:
		# Si le joueur ne touche à rien, on utilise la variable de décélération.
		accel = deceleration
	
	# On interpole la vélocité actuelle vers la vélocité cible.
	velocity.x = lerp(velocity.x, target_velocity.x, accel * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, accel * delta)

	move_and_slide()
