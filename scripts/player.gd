extends CharacterBody2D

@export var init_speed = 100
@export var boost_speed = 200
@export var init_rotation_speed = 0.75
var rotation_speed
var speed
var is_boosting: bool = false
var anchor_dropped: bool = false

var rotation_direction = 0
var boost_timer: Timer

func _ready() -> void:
	speed = init_speed
	rotation_speed = init_rotation_speed
	boost_timer = $"../BoostTimer"

func get_input():
	if Input.is_action_just_pressed("drop_anchor"):
		if anchor_dropped:
			anchor_dropped = false
		else:
			anchor_dropped = true
		anchor_action()
			
	#handle the speed boost button
	if Input.is_action_just_pressed("speed_boost") and !is_boosting:
		is_boosting = true
		print("boosting")
		boost_timer.start()
		speed_boost()
	#handle rotation based on steering left or right
	rotation_direction = Input.get_axis("steer_left", "steer_right")
	# handle the forward momentum
	## Need a new way to handle this later where I'm not using a "dummy" input for back because we don't want backwards movement with the boat
	velocity = transform.x * Input.get_axis("dummy", "throttle") * speed
	# handle drop anchor

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func speed_boost():
	speed = speed + boost_speed

func _on_boost_timer_timeout() -> void:
	is_boosting = false
	speed = init_speed
	print("boosting complete")

func anchor_action():
	if anchor_dropped:
		speed = 0
		rotation_speed = 0.3
		print("anchor dropped")
	else:
		speed = init_speed
		rotation_speed = init_rotation_speed
		print("anchor raised")
