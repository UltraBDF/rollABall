# Ce fichier doit être créé. Il définit la base de tous nos états.
class_name State
var character: CharacterBody2D

# Appelé quand on entre dans l'état.
func enter():
	pass

# Appelé à chaque frame de physique.
func update(_delta: float):
	pass

# Appelé quand on quitte l'état.
func exit():
	pass
