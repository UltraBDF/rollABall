extends CharacterBody3D

# Vitesse de déplacement du joueur, @export permet de la modifier dans l'Inspecteur.
@export var speed = 14.0
# Puissance du saut (non utilisé dans ce tuto, mais bon à savoir).
@export var jump_velocity = 4.5

# Obtenir la gravité définie dans les paramètres du projet.
# Note : C'est ici que l'erreur se trouvait, le mot "public" a été retiré.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Appliquer la gravité à chaque frame de physique si le joueur n'est pas au sol.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Récupérer les entrées du clavier (flèches directionnelles ou ZQSD).
	# Godot les configure par défaut dans Projet -> Paramètres du projet -> Input Map.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Calculer la direction du mouvement dans l'espace 3D basé sur la vue de la caméra.
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Appliquer le mouvement si le joueur appuie sur une touche.
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Ralentir progressivement jusqu'à l'arrêt si aucune touche n'est appuyée.
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# Appliquer le vecteur de mouvement au corps du personnage. C'est la fonction qui déplace le joueur.
	move_and_slide()
