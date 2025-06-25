# main.gd
extends Node3D

# 1. Une variable pour stocker le score actuel. Elle commence à 0.
var score = 0

# 2. Une variable "exportée" pour faire le lien avec notre Label.
# @export permet de voir et de modifier cette variable directement dans l'éditeur Godot.
# C'est comme une "prise" publique où l'on viendra brancher notre nœud Label.
@export var score_label: Label

# 3. Cette fonction est appelée une seule fois au démarrage du jeu.
func _ready():
	# On s'assure que le score est bien affiché à "Score: 0" au début.
	update_score_display()

# 4. C'est la fonction qui sera DÉCLENCHÉE par les objets collectés.
# Elle sera exécutée à chaque fois qu'un collectible enverra le signal "collected".
func _on_collectible_collected():
	score += 1 # On augmente le score de 1.
	update_score_display() # On appelle notre autre fonction pour rafraîchir le texte.

# 5. Une fonction juste pour mettre à jour le texte du Label.
# On la met à part pour ne pas répéter le code.
func update_score_display():
	# On vérifie si notre "prise" score_label est bien branchée à quelque chose.
	if score_label:
		# On met à jour la propriété "text" du Label.
		# str(score) convertit notre nombre (ex: 5) en chaîne de caractères ("5").
		score_label.text = "Score: " + str(score)


func _on_collectible_2_collected() -> void:
	pass # Replace with function body.


func _on_collectible_3_collected() -> void:
	pass # Replace with function body.


func _on_collectible_4_collected() -> void:
	pass # Replace with function body.


func _on_collectible_5_collected() -> void:
	pass # Replace with function body.
