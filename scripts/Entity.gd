extends KinematicBody2D

onready var sprite = $Sprite

const ACCELERATION = 512
const VELOCITY = 128
const FRICTION = 0.25
const AIR_RESISTANCE = 0.05
const GRAVITY = 600
const JUMPING = 218

var motion = Vector2.ZERO

func _physics_process(delta):
	
	# inputs
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# fliping
	if direction:
		sprite.flip_h = direction < 0
	
	# acceleration
	if direction:
		motion.x += direction * ACCELERATION * delta
		motion.x = clamp(motion.x,-VELOCITY,VELOCITY)
	
	# friction on floor
	if !direction and is_on_floor():
		motion.x = lerp(motion.x,0, FRICTION)
	
	# friction on air
	if !direction and !is_on_floor():
		motion.x = lerp(motion.x,0, AIR_RESISTANCE)
	
	# jumping
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMPING
			
	# jumping height
	if !is_on_floor():
		if Input.is_action_just_released("ui_up") and motion.y < - JUMPING / 2:
			motion.y = -JUMPING / 2
	
	# gravity
	motion.y += GRAVITY * delta
	
	# entity
	motion = move_and_slide(motion,Vector2.UP)
