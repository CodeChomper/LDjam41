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
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.codes = 0
	$Menu/TextureButton.hide()
	mazeA = mazeScene.instance()
	var level = Global.get_next_level()
	mazeA.width = level + 4
	mazeA.height = level  + 4
	mazeA.connect("maze_built", self, "_on_maze_built")
	mazeA.offset = Vector2(0,1700)
	
	add_child(mazeA)
	
	pass

func _on_exit_touched():
	if Global.codes == 3:
		get_tree().reload_current_scene()

func _process(delta):
	if Global.codes == 3:
		mazeA.exit.show()
	# Called every frame. Delta is time since last frame.
	if player and mazeA and mazeA.timeLeft <= 0:
		player.health = 0
	pass

func _on_maze_built():
	mazeA.exit.connect("exit_touched", self, "_on_exit_touched")
	$Menu/TextureButton.show()
	$Menu/TextureButton.grab_focus()
	$Menu/BuildingText.hide()


func _on_TextureButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Menu/TextureButton.hide()
	mazeA.timerStart = true
	player = playerScene.instance()
	player.position = mazeA.offset
	player.position.x += 32
	add_child(player)
	pass # replace with function body
