@tool
extends Node3D
const FLOOR_SIZE := Vector3(100, 1, 100)

func _ready():
	create_floor()
	

func create_floor():
	var floor = StaticBody3D.new()
	var mesh_instance = MeshInstance3D.new()
	var shape = BoxShape3D.new()
	shape.size = FLOOR_SIZE
	var box_mesh = BoxMesh.new()
	box_mesh.size = FLOOR_SIZE
	mesh_instance.mesh = box_mesh
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.23, 0.23, 0.21)
	mesh_instance.material_override = material
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = shape
	floor.add_child(mesh_instance)
	floor.add_child(collision_shape)
	add_child(floor)
