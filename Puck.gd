extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var motion = Vector2()
var newPos
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		motion.y = -5
		motion.x = 0
	elif Input.is_action_pressed("ui_down"):
		motion.y = 5
		motion.x = 0
	elif Input.is_action_pressed("ui_left"):
		motion.x = -5
		motion.y = 0
	elif Input.is_action_pressed("ui_right"):
		motion.x = 5
		motion.y = 0
	
	if abs(position.distance_to(newPos)) < 0.3 :
		motion.x = 0
		motion.y = 0
	
	
	var coll = move_and_collide(motion)
	if coll and coll.collider.has_method("remove_wall"):
		coll.collider.remove_wall()

func moveTowards(newPos):
	if newPos.y < position.y:
		motion.y = -1
	if newPos.y > position.y:
		motion.y = 1
	if newPos.x < position.x:
		motion.x = -1
	if newPos.x > position.x:
		motion.x = 1
		
	self.newPos = newPos


