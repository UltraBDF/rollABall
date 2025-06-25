# main.gd
extends Node3D

var score = 0

@export var score_label: Label

func _ready():
	# On s'assure que le score est bien affiché à "Score: 0" au début.
	update_score_display()

func _on_collectible_collected():
	score += 1 # On augmente le score de 1.
	update_score_display() # On appelle notre autre fonction pour rafraîchir le texte.

func update_score_display():
	# On vérifie si notre "prise" score_label est bien branchée à quelque chose.
	if score_label:
		# On met à jour la propriété "text" du Label.
		score_label.text = "Score: " + str(score)
