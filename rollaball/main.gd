# main.gd
extends Node3D

var score = 0
var collectible_nodes = []

@export var score_label: Label
@export var win_screen_container: CenterContainer

@export var obstacle_scene: PackedScene 
@export var number_of_obstacles = 15
@export var spawn_range = 9.0

@export var collectible_scene: PackedScene 
@export var number_of_collectibles = 10
@export var min_spawn_distance = 1.5 

# On n'a plus besoin de la liste collectible_nodes ici.
# var collectible_nodes = []
func _ready():
	generate_layout()
	
	# On s'assure que le score est bien affiché à "Score: 0" au début.
	update_score_display()
	

func _on_collectible_collected():
	score += 1 # On augmente le score de 1.
	update_score_display() # On appelle notre autre fonction pour rafraîchir le texte.
	
	if score >= number_of_collectibles:
		# On appelle une nouvelle fonction pour gérer la victoire proprement.
		game_won()

func update_score_display():
	# On vérifie si notre "prise" score_label est bien branchée à quelque chose.
	if score_label:
		# On met à jour la propriété "text" du Label.
		score_label.text = "Score: " + str(score)

func game_won():
	# On arrête le jeu. Le temps et la physique sont mis en pause.
	get_tree().paused = true
	
	# On s'assure que notre conteneur de victoire xest bien lié.
	if win_screen_container:
		# On récupère le Label à l'intérieur du conteneur.
		var win_label = win_screen_container.get_node("WinLabel")
	
		# On met à jour son texte avec le score final.
		win_label.text = "Gagné !\nScore final : " + str(score)
	
		# On affiche l'écran de victoire.
		win_screen_container.visible = true

func generate_layout():
	# On vérifie que les scènes sont bien liées pour éviter les erreurs.
	if not obstacle_scene or not collectible_scene:
		print("Erreur : Les scènes d'obstacle ou de collectible ne sont pas définies.")
		return

	var spawn_points = []
	var total_items_to_spawn = number_of_obstacles + number_of_collectibles
	var spawn_attempts = 0

	# On génère une liste de positions valides.
	while spawn_points.size() < total_items_to_spawn and spawn_attempts < 1000:
		spawn_attempts += 1 # Sécurité pour éviter une boucle infinie.
		
		var random_pos = Vector3(randf_range(-spawn_range, spawn_range), 1, randf_range(-spawn_range, spawn_range))
		
		# On vérifie que la position est valide (loin du joueur et des autres points).
		if is_position_valid(random_pos, spawn_points):
			spawn_points.append(random_pos)

	# On mélange la liste de positions.
	spawn_points.shuffle()

	# On place les obstacles.
	for i in number_of_obstacles:
		if spawn_points.is_empty(): break # Sécurité si on n'a pas pu générer assez de points.
		var pos = spawn_points.pop_front() # On prend la première position de la liste.
		var new_obstacle = obstacle_scene.instantiate()
		new_obstacle.position = pos
		add_child(new_obstacle)

	# On place les collectibles.
	for i in number_of_collectibles:
		if spawn_points.is_empty(): break
		var pos = spawn_points.pop_front() # On prend la nouvelle première position.
		var new_collectible = collectible_scene.instantiate()
		new_collectible.position = pos
		
		# On connecte le signal du nouveau collectible via le code.
		new_collectible.collected.connect(_on_collectible_collected)
		
		add_child(new_collectible)

func is_position_valid(pos, existing_points):
	# On vérifie la distance par rapport au point de départ du joueur.
	if pos.distance_to(Vector3.ZERO) < 3.0:
		return false
	
	# On vérifie la distance par rapport à tous les autres points déjà validés.
	for point in existing_points:
		if pos.distance_to(point) < min_spawn_distance:
			return false
	
	return true 
