extends CharacterBody2D

var current_state: State

# --- Classe interne pour l'état de Patrouille ---
class PatrolState extends State:
	var direction = 1
	var speed = 50.0

	func update(_delta: float):
		character.velocity.x = direction * speed
		character.move_and_slide()
		# Si on est sur un mur, on change de direction.
		if character.is_on_wall():
			direction *= -1

# --- Fonctions principales de l'ennemi ---
func _ready():
	current_state = PatrolState.new()
	current_state.character = self
	current_state.enter()

func _physics_process(delta):
	if current_state:
		current_state.update(delta)
