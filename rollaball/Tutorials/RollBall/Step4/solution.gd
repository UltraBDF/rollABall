# camera_follow.gd
extends Camera3D

@export var target: Node3D

var offset = Vector3.ZERO

func _ready():
	if target:
		offset = global_position - target.global_position

func _process(delta):
	if target:
		global_position = target.global_position + offset
