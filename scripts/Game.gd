extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (PackedScene) var playerScene
export (PackedScene) var mazeScene
var player
var mazeA


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$Menu/TextureButton.hide()
	mazeA = mazeScene.instance()
	mazeA.connect("maze_built", self, "_on_maze_built")
	mazeA.offset = Vector2(0,700)
	
	add_child(mazeA)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_maze_built():
	$Menu/TextureButton.show()


func _on_TextureButton_pressed():
	$Menu/TextureButton.hide()
	player = playerScene.instance()
	player.position = mazeA.offset
	player.position.x += 32
	add_child(player)
	pass # replace with function body
