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

export (PackedScene) var mazeNode
export (PackedScene) var puckObj
export (PackedScene) var exitScene

export var offset = Vector2()
signal maze_built


func _ready():
	fromPop = true
	self.pathStack = []
	self.position = offset
	randomize()
	width = 15
	height = 15
	
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

func place_exit():
	var exit = exitScene.instance()
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
		

	if Input.is_action_just_pressed("ui_page_up"):
		get_tree().reload_current_scene()
		
