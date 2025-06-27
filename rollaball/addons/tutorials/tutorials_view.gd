# addons/tutorials/tutorials_view.gd
@tool
extends Control

# -- NŒUDS UNIQUES --
@onready var description_container := %ScrollContainer
@onready var demo_container := %SubViewportContainer
@onready var solution_container := %CodeEditorContainer
@onready var solution_code := %SolutionCode
@onready var show_description_button := %ShowDescriptionButton
@onready var show_demo_button := %ShowDemoButton
@onready var show_solution_button := %ShowSolutionButton
@onready var tutorial_list: VBoxContainer = %TutorialList
@onready var tutorial_title: Label = %TutorialTitle
@onready var step_selector: OptionButton = %StepSelector
@onready var step_description: RichTextLabel = %StepDescription
@onready var sub_viewport_container: SubViewportContainer = %SubViewportContainer

const TUTORIALS_FILE_PATH = "res://tutorials.json"

# Variable pour stocker les données chargées
var tutorials_data: Array = []
var current_tutorial_index: int = -1
var current_step_index: int = -1

func _ready():
	# Connecter les signaux des éléments d'UI
	step_selector.item_selected.connect(_on_step_selected)

	# Charger les tutoriels depuis le JSON
	load_tutorials_from_file()
	
	show_solution_button.pressed.connect(_on_show_solution_pressed)
	show_description_button.pressed.connect(_on_show_description_pressed)
	show_demo_button.pressed.connect(_on_show_demo_pressed)
	
	# Construire la liste des tutoriels
	populate_tutorial_list()
	
	# Cacher tous les contenus au départ
	description_container.visible = false
	demo_container.visible = false
	solution_container.visible = false

func load_tutorials_from_file():
	if not FileAccess.file_exists(TUTORIALS_FILE_PATH):
		printerr("Plugin Tutoriels : Fichier 'tutorials.json' introuvable.")
		return

	var file = FileAccess.open(TUTORIALS_FILE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.parse_string(content)

	if json == null or not json.has("tutorials"):
		printerr("Plugin Tutoriels : Erreur de formatage dans 'tutorials.json'.")
		return
	
	tutorials_data = json.tutorials

func _on_show_description_pressed():
	_update_visible_section("description")

func _on_show_demo_pressed():
	_update_visible_section("demo")

func _on_show_solution_pressed():
	_update_visible_section("solution")

func _update_visible_section(section: String):
	description_container.visible = section == "description"
	demo_container.visible = section == "demo"
	solution_container.visible = section == "solution"

func populate_tutorial_list():
	# Vider la liste existante
	for child in tutorial_list.get_children():
		child.queue_free()
	
	# Créer un bouton pour chaque tutoriel trouvé dans le JSON
	for i in range(tutorials_data.size()):
		var tutorial = tutorials_data[i]
		var button = Button.new()
		button.text = tutorial.title
		button.pressed.connect(_on_tutorial_selected.bind(i))
		tutorial_list.add_child(button)

# Appelé lorsqu'un bouton de tutoriel est cliqué
func _on_tutorial_selected(index: int):
	current_tutorial_index = index
	var tutorial = tutorials_data[index]
	
	tutorial_title.text = tutorial.title
	
	# Vider le sélecteur d'étapes
	step_selector.clear()
	
	# Remplir le sélecteur avec les étapes du tutoriel choisi
	for step in tutorial.steps:
		step_selector.add_item(step.title)
	
	# Sélectionner et afficher la première étape par défaut
	if not tutorial.steps.is_empty():
		step_selector.select(0)
		_on_step_selected(0)

func _has_camera3d(node: Node) -> bool:
	for child in node.get_children():
		if child is Camera3D:
			return true
		if _has_camera3d(child):
			return true
	return false

# Appelé lorsqu'une étape est choisie dans l'OptionButton
func _on_step_selected(index: int):
	if current_tutorial_index == -1:
		return
	
	current_step_index = index
	var step = tutorials_data[current_tutorial_index].steps[index]
	
	# Afficher la description
	step_description.bbcode_enabled = true
	step_description.text = step.get("description", "Pas de description pour cette étape.")
	
	# Charger le code solution depuis le fichier
	var solution_path = step.get("solution_script", "")
	if solution_path != "" and FileAccess.file_exists(solution_path):
		var file = FileAccess.open(solution_path, FileAccess.READ)
		var solution_text = file.get_as_text()
		file.close()
		solution_code.text = solution_text
	else:
		solution_code.text = "Solution indisponible."
	
	# Préparer la démo
	for child in sub_viewport_container.get_children():
		child.queue_free()

	var demo_path = step.get("demo_scene", "")
	if demo_path != "" and ResourceLoader.exists(demo_path):
		var demo_scene = load(demo_path)
		var demo_instance = demo_scene.instantiate()

		var is_3d := demo_instance is Node3D or _has_camera3d(demo_instance)

		# Créer un viewport et le configurer selon la nature de la scène
		var viewport = SubViewport.new()
		viewport.size = sub_viewport_container.size
		viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		viewport.transparent_bg = true
		sub_viewport_container.add_child(viewport)

		# Ajouter la scène dans le viewport
		viewport.add_child(demo_instance)

		# Si c'est une scène 3D, ajouter une caméra automatiquement si aucune n’est trouvée
		if is_3d and not _has_camera3d(demo_instance):
			var camera := Camera3D.new()
			camera.position = Vector3(0, 5, 10)
			viewport.add_child(camera)
			camera.look_at(Vector3.ZERO)
			viewport.add_child(camera)

	# Par défaut, afficher uniquement la description
	_update_visible_section("description")
