extends CharacterBody2D

# Variable pour garder en mémoire l'état actuel (Patrouille ou Poursuite)
var current_state: State

# --- Comportement n°1 : La Patrouille ---
# L'ennemi va de gauche à droite sans se soucier du joueur.
class PatrolState extends State:
	var direction = 1
	var speed = 40.0

	func update(_delta: float):
		# Applique une vitesse horizontale simple.
		character.velocity.x = direction * speed
		character.move_and_slide()
		
		# Change de direction en touchant un mur.
		if character.is_on_wall():
			direction *= -1

# --- Comportement n°2 : La Poursuite ---
# L'ennemi ignore les murs et fonce vers la position du joueur.
class ChaseState extends State:
	var joueur_ref: Node2D # Variable pour savoir qui poursuivre.
	var speed = 150.0     # Il est plus rapide en poursuite.

	func update(_delta: float):
		# Si le joueur n'existe plus, on ne fait rien pour éviter un crash.
		if not is_instance_valid(joueur_ref):
			return

		# Calcule la direction vers le joueur (uniquement sur l'axe X).
		var direction_vers_joueur = character.global_position.direction_to(joueur_ref.global_position)
		character.velocity.x = direction_vers_joueur.x * speed
		character.move_and_slide()


# Fonction d'initialisation, appelée une seule fois au début.
func _ready():
	# On s'assure que l'ennemi commence toujours par patrouiller.
	change_state(PatrolState.new())

# Boucle de jeu principale, appelée à chaque frame.
func _physics_process(delta):
	# On délègue toute la logique à l'état actuel.
	if current_state:
		current_state.update(delta)

# Fonction propre pour changer de comportement.
func change_state(new_state: State):
	current_state = new_state
	current_state.character = self
	print("Nouveau comportement : ", current_state.get_class())

# Appelé quand un objet entre dans la zone de détection.
func _on_zone_detection_body_entered(body):
	# On vérifie si c'est bien le joueur.
	if body.name == "Joueur":
		# C'est le joueur ! On passe en mode Poursuite.
		var etat_poursuite = ChaseState.new()
		etat_poursuite.joueur_ref = body # On dit à l'état qui il doit poursuivre.
		change_state(etat_poursuite)

# Appelé quand un objet quitte la zone de détection.
func _on_zone_detection_body_exited(body):
	# On vérifie si c'est bien le joueur.
	if body.name == "Joueur":
		# Le joueur s'est échappé ! On retourne en mode Patrouille.
		change_state(PatrolState.new())
