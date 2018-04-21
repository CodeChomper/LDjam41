extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const NODE_SIZE = 64
const HALF_NODE_SIZE = NODE_SIZE / 2
var width
var height
var grid = []
var puck

export (PackedScene) var mazeNode
export (PackedScene) var puckObj


func _ready():
	randomize()
	width = 20
	height = 20
	for x in range(width):
		grid.append([])
		for y in range(height):
			var tmpNode = mazeNode.instance()
			tmpNode.set_position(Vector2(x*NODE_SIZE + HALF_NODE_SIZE, y*NODE_SIZE + HALF_NODE_SIZE))
			add_child(tmpNode)
			grid[x].append(tmpNode)
	
	puck = puckObj.instance()
	puck.position = Vector2(HALF_NODE_SIZE, HALF_NODE_SIZE)
	add_child(puck)
	
	make_maze()
	pass

func make_maze():
	var pathStack = []
	# Get starting pos
	var pos = Vector2(0,0)
	var curNode = grid[pos.x][pos.y]
	
	print(curNode.position)
	pathStack.push_back(curNode)
	#loop--------------------------
	while pathStack.size() > 0:
		# Get unvistied neighbors
		var neighbors = []
		#look up
		if pos.y > 0 and !grid[pos.x][pos.y - 1].visited:
			print("can go up")
			neighbors.append(Vector2(pos.x, pos.y - 1))
		#look down
		if pos.y < height and !grid[pos.x][pos.y + 1].visited:
			print("can go down")
			neighbors.append(Vector2(pos.x, pos.y + 1))
		#look left
		if pos.x > 0 and !grid[pos.x - 1][pos.y].visited:
			print("can go left")
			neighbors.append(Vector2(pos.x - 1, pos.y))
		#look right
		if pos.x < width and !grid[pos.x + 1][pos.y].visited:
			print("can go right")
			neighbors.append(Vector2(pos.x + 1, pos.y))
		
		print(neighbors)
		pathStack.pop_back()
		
		# if no unvisted neighbors and stack not empty
			# move to prev node by pop of stack
		# if no unvistied neighbors and stack empty
			# maze complete
		# choose a random neighbor to visit
		if neighbors.size() > 0:
			var newPos = neighbors[randi() % neighbors.size()]
			print(newPos)
			pathStack.push_back(grid[newPos.x][newPos.y])
			puck.moveTowards(Vector2(newPos.x * NODE_SIZE + HALF_NODE_SIZE, newPos.y * NODE_SIZE + HALF_NODE_SIZE))
			# move to neighbor and mark it visited
			# put neighbor on stack
		
		pathStack.pop_back()

