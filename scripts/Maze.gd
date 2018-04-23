extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const NODE_SIZE = 128
const HALF_NODE_SIZE = NODE_SIZE / 2
var width
var height
var grid = []
var puck
var fromPop
var pathStack
var mazeDone = false
var timerStart = false
var timeLeft = 0
var exit
var c1
var c2
var c3

export (PackedScene) var mazeNode
export (PackedScene) var puckObj
export (PackedScene) var exitScene
export (PackedScene) var codeScene

 

export var offset = Vector2()
signal maze_built


func _ready():
	exit = exitScene.instance()
	fromPop = true
	self.pathStack = []
	self.position = offset
	randomize()
	#width = 15
	#height = 8
	timeLeft = (width * height) /1.5
	
	for x in range(width):
		grid.append([])
		for y in range(height):
			var tmpNode = mazeNode.instance()
			tmpNode.pos.x = x
			tmpNode.pos.y = y
			tmpNode.set_position(Vector2(x*NODE_SIZE + HALF_NODE_SIZE, y*NODE_SIZE + HALF_NODE_SIZE))
			add_child(tmpNode)
			grid[x].append(tmpNode)
	
	puck = puckObj.instance()
	puck.position = Vector2(HALF_NODE_SIZE, HALF_NODE_SIZE)
	add_child(puck)
	
	make_maze()
	pass

func make_maze():
	
	# Get starting pos
	var pos = Vector2(0,0)
	var curNode = grid[pos.x][pos.y]
	curNode.visited = true
	
	self.pathStack.push_back(curNode)
	puck.posQueue.append(Vector2(pos.x * NODE_SIZE + HALF_NODE_SIZE, pos.y * NODE_SIZE + HALF_NODE_SIZE))
	#loop--------------------------
	while pathStack.size() > 0:
		
		# Get unvistied neighbors
		var neighbors = []
		#look up
		if pos.y > 0 and !grid[pos.x][pos.y - 1].visited:
			neighbors.append(Vector2(pos.x, pos.y - 1))
		#look down
		if pos.y < height - 1 and !grid[pos.x][pos.y + 1].visited:
			neighbors.append(Vector2(pos.x, pos.y + 1))
		#look left
		if pos.x > 0 and !grid[pos.x - 1][pos.y].visited:
			neighbors.append(Vector2(pos.x - 1, pos.y))
		#look right
		if pos.x < width - 1 and !grid[pos.x + 1][pos.y].visited:
			neighbors.append(Vector2(pos.x + 1, pos.y))
		
		# choose a random neighbor to visit
		if neighbors.size() > 0:
			if fromPop:
				self.pathStack.push_back(grid[pos.x][pos.y])
				puck.posQueue.append(Vector2(pos.x * NODE_SIZE + HALF_NODE_SIZE, pos.y * NODE_SIZE + HALF_NODE_SIZE))
				fromPop = false
			
			var newPos = neighbors[randi() % neighbors.size()]
			grid[newPos.x][newPos.y].visited = true
			# move to neighbor and mark it visited
			pos = newPos
			# put neighbor on stack
			self.pathStack.push_back(grid[newPos.x][newPos.y])
			puck.posQueue.append(Vector2(newPos.x * NODE_SIZE + HALF_NODE_SIZE, newPos.y * NODE_SIZE + HALF_NODE_SIZE))
		# if no unvisted neighbors and stack not empty
		else:
			fromPop = true
			#puck.posQueue.append(Vector2(pos.x * NODE_SIZE + HALF_NODE_SIZE, pos.y * NODE_SIZE + HALF_NODE_SIZE))
			# move to prev node by pop of stack
			if pathStack.size() > 0:
				var tmpNode = pathStack.pop_back()
				var newPos = tmpNode.pos
				puck.posQueue.append(Vector2(newPos.x * NODE_SIZE + HALF_NODE_SIZE, newPos.y * NODE_SIZE + HALF_NODE_SIZE))
				pos = newPos
	place_exit()
	place_codes()

func _on_collect_code(obj):
	remove_child(obj)
	Global.codes += 1
	if Global.codes >= 3:
		exit.unlockSound.play()
	

func place_codes():
	c1 = codeScene.instance()
	var pos = Vector2(randi() % width, randi() % height)
	c1.position = pos * NODE_SIZE + Vector2(HALF_NODE_SIZE, HALF_NODE_SIZE)
	c1.connect("area_entered", self, "_on_collect_code")
	add_child(c1)
	
	c2 = codeScene.instance()
	pos = Vector2(randi() % width, randi() % height)
	c2.position = pos * NODE_SIZE + Vector2(HALF_NODE_SIZE, HALF_NODE_SIZE)
	c2.connect("area_entered", self, "_on_collect_code")
	add_child(c2)
	
	c3 = codeScene.instance()
	pos = Vector2(randi() % width, randi() % height)
	c3.position = pos * NODE_SIZE + Vector2(HALF_NODE_SIZE, HALF_NODE_SIZE)
	c3.connect("area_entered", self, "_on_collect_code")
	add_child(c3)
	
	

func place_exit():
	while true:
		var pos = Vector2(randi() % width, randi() % height)
		if pos.x > width / 2 or pos.y > height / 2:
			exit.position = pos * NODE_SIZE + Vector2(HALF_NODE_SIZE, HALF_NODE_SIZE)
			break
	add_child(exit)

func _process(delta):
	if puck.posIndex == puck.posQueue.size() - 1 and !mazeDone:
		emit_signal("maze_built")
		mazeDone = true
		remove_child(puck)
	
	if Global.codes >= 3:
		exit.doorSprite.play("Active")
	
	if timeLeft <= 0:
		$UI/TimeLeftLabel.text = "You Died"
	
	if timerStart and timeLeft > 0:
		$UI/TimeLeftLabel.show()
		timeLeft -= delta
		$UI/TimeLeftLabel.text = "Time Left: " + str(round(timeLeft))
		
		

	#TODO REMOVE THIS FOR PROD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if Input.is_action_just_pressed("ui_page_up"):
		get_tree().reload_current_scene()
		
