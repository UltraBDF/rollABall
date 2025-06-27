extends CharacterBody3D

# Player movement speed
@export var speed = 14.0
@export var acceleration = 5.0
@export var deceleration = 1.0

# Get the gravity from the project settings.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# We define a "target velocity" based on the input.
	var target_velocity = direction * speed

	var accel
	if direction != Vector3.ZERO:
		# If the player is pressing a key, we use the acceleration variable.
		accel = acceleration
	else:
		# If the player isn't pressing anything, we use the deceleration variable.
		accel = deceleration
	
	# We interpolate the current velocity towards the target velocity.
	velocity.x = lerp(velocity.x, target_velocity.x, accel * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, accel * delta)

	move_and_slide()
