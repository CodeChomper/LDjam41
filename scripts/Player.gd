extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_POWER = 500
const WALL_BOUNCE = 450
var motion = Vector2()
var spawnPos = Vector2()
var jumpCnt = 0

func _ready():
	spawnPos = position


func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED);
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED);
		$Sprite.flip_h = true
	else:
		friction = true
	
	#Slow down when running on ground and let off the controller
	if is_on_floor():

		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	
	# In air friction
	else:
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	
	handleJumps()
	
	motion = move_and_slide(motion, UP)
	pass

func handleJumps():
	#standing
	if is_on_floor():
		jumpCnt = 0
		
		#first jump
		if Input.is_action_just_pressed("ui_up"):
			motion.y -= JUMP_POWER
			jumpCnt += 1
	
	#mid air not touching wall
	if !is_on_floor() and !is_on_wall() and jumpCnt < 2 and Input.is_action_just_pressed("ui_up"):
		motion.y -= JUMP_POWER
		jumpCnt += 1
	
	
	#wall jump
	if is_on_wall() and !is_on_floor() and Input.is_action_just_pressed("ui_up"):
		jumpCnt = 4
		var left = test_move(transform, Vector2(1,0))
		motion.y -= JUMP_POWER
		motion.x = -WALL_BOUNCE if left else WALL_BOUNCE

func _process(delta):
	if position.y > 700.0 and $ResponTimer.is_stopped():
		$DeathSound.play()
		$ResponTimer.start()
	

func _on_ResponTimer_timeout():
	$ResponTimer.stop()
	$DeathSound.stop()
	motion.y = 0
	motion.x = 0
	position = spawnPos
	
