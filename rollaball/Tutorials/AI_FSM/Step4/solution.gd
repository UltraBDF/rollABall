extends CharacterBody2D

var current_state: State

class PatrolState extends State:
	var direction = 1
	var speed = 50.0
	func update(_delta: float):
		character.velocity.x = direction * speed
		character.move_and_slide()
		if character.is_on_wall():
			direction *= -1

func _ready():
	current_state = PatrolState.new()
	current_state.character = self
	current_state.enter()

func _physics_process(delta):
	if current_state:
		current_state.update(delta)

# --- Fonctions connectées aux signaux ---
func _on_zone_detection_body_entered(body):
	# On vérifie que c'est bien le joueur
	if body.name == "Joueur":
		print("Joueur détecté !")
		# Logique de changement d'état à venir...

func _on_zone_detection_body_exited(body):
	if body.name == "Joueur":
		print("Joueur perdu !")
		# Logique de changement d'état à venir...
