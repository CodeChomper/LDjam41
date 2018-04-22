extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var motion = Vector2()
var posQueue = []
var posIndex = -1
const SPEED = 60

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _physics_process(delta):
	
	if posIndex == -1 and posQueue.size() > 0:
		posIndex += 1
		moveTowards(posQueue[posIndex])
	
	if abs(position.distance_to(posQueue[posIndex])) < SPEED *1.5:
		motion.x = 0
		motion.y = 0
		position = posQueue[posIndex]
		if posIndex < posQueue.size() - 1:
			posIndex += 1
			moveTowards(posQueue[posIndex])
			
	
	
	var coll = move_and_collide(motion)
	if coll and coll.collider.has_method("remove_wall"):
		coll.collider.remove_wall()

func moveTowards(newPos):
	motion = Vector2(0,0)
#	if abs(newPos.x - position.x) > abs(newPos.y - position.y):
#		if newPos.x < position.x:
#			motion.x = -SPEED
#		else:
#			motion.x = SPEED
#	else:
#		if newPos.y < position.y:
#			motion.y = -SPEED
#		else:
#			motion.y = SPEED

	if newPos.y < position.y:
		motion.y = -SPEED
	if newPos.y > position.y:
		motion.y = SPEED
	if newPos.x < position.x:
		motion.x = -SPEED
	if newPos.x > position.x:
		motion.x = SPEED
		


