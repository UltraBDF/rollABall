# camera_follow.gd
extends Camera3D

# Une référence au noeud du joueur. @export permet de le glisser-déposer depuis l'éditeur.
@export var target: Node3D

# La distance entre la caméra et le joueur.
var offset = Vector3.ZERO

func _ready():
	# Calculer l'offset initial au démarrage.
	if target:
		offset = global_transform.origin - target.global_transform.origin

func _process(delta):
	# Mettre à jour la position de la caméra à chaque image.
	if target:
		global_transform.origin = target.global_transform.origin + offset
