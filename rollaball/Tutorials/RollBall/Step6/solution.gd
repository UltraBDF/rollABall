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

func _ready():
	generate_layout()
	
	# We make sure the score is correctly displayed as "Score: 0" at the start.
	update_score_display()
	
func _on_collectible_collected():
	score += 1 # We increment the score by 1.
	update_score_display() # We call our other function to refresh the text.
	
	if score >= number_of_collectibles:
		# We call a new function to handle the victory properly.
		game_won()

func update_score_display():
	# We check if our score_label reference is properly connected to something.
	if score_label:
		# We update the "text" property of the Label.
		score_label.text = "Score: " + str(score)

func game_won():
	# We stop the game. Time and physics are paused.
	get_tree().paused = true
	
	# We make sure our victory container is properly linked.
	if win_screen_container:
		# We get the Label inside the container.
		var win_label = win_screen_container.get_node("WinLabel")
	
		# We update its text with the final score.
		win_label.text = "You Win!\nFinal Score: " + str(score)
	
		# We display the victory screen.
		win_screen_container.visible = true

func generate_layout():
	# We check that the scenes are properly linked to avoid errors.
	if not obstacle_scene or not collectible_scene:
		print("Error: Obstacle or collectible scenes are not defined.")
		return

	var spawn_points = []
	var total_items_to_spawn = number_of_obstacles + number_of_collectibles
	var spawn_attempts = 0

	# We generate a list of valid positions.
	while spawn_points.size() < total_items_to_spawn and spawn_attempts < 1000:
		spawn_attempts += 1 # Safety measure to avoid an infinite loop.
		
		var random_pos = Vector3(randf_range(-spawn_range, spawn_range), 1, randf_range(-spawn_range, spawn_range))
		
		# We check that the position is valid (far from the player and other points).
		if is_position_valid(random_pos, spawn_points):
			spawn_points.append(random_pos)

	# We shuffle the list of positions.
	spawn_points.shuffle()

	# We place the obstacles.
	for i in number_of_obstacles:
		if spawn_points.is_empty(): break # Safety measure in case we couldn't generate enough points.
		var pos = spawn_points.pop_front() # We take the first position from the list.
		var new_obstacle = obstacle_scene.instantiate()
		new_obstacle.position = pos
		add_child(new_obstacle)

	# We place the collectibles.
	for i in number_of_collectibles:
		if spawn_points.is_empty(): break
		var pos = spawn_points.pop_front() # We take the new first position.
		var new_collectible = collectible_scene.instantiate()
		new_collectible.position = pos
		
		# We connect the signal of the new collectible through code.
		new_collectible.collected.connect(_on_collectible_collected)
		
		add_child(new_collectible)

func is_position_valid(pos, existing_points):
	# We check the distance from the player's starting point.
	if pos.distance_to(Vector3.ZERO) < 3.0:
		return false
	
	# We check the distance from all other already validated points.
	for point in existing_points:
		if pos.distance_to(point) < min_spawn_distance:
			return false
	
	return true
