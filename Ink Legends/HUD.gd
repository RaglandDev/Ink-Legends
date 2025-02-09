extends CanvasLayer

@onready var playerBody = $".."
@onready var health = $Control/Bottom/HIBar/Health
@onready var ink = $Control/Bottom/HIBar/Ink

var qScene = preload("res://SkillShot.tscn")

var player = null
var qAim = false
var qHighlight = null

func _ready():
	health.value = playerBody.hp
	ink.value = playerBody.ink

func _process(_delta):
	if Input.is_action_just_released("Q") and qHighlight != null:
		qHighlight.queue_free()
		qAim = false
		return
	if Input.is_action_just_pressed("Q") and !qAim:
		player = get_tree().get_nodes_in_group("Player")[0]
		qHighlight = qScene.instantiate()
		qHighlight.scale = Vector3(10, 10, 10)
		player.add_child(qHighlight)
		qAim = true
		
	if qAim:
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mousePos = get_viewport().get_mouse_position()
		var rayLength = 100
		var from = camera.project_ray_origin(mousePos)
		var to = from + camera.project_ray_normal(mousePos) * rayLength
		var space = player.get_world_3d().direct_space_state
		var rayQuery :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		rayQuery.exclude = [player.get_rid()] # raycast ignore player model
		var result = space.intersect_ray(rayQuery)
		if result:
			result.position.y = qHighlight.position.y
			qHighlight.look_at(result.position)
			qHighlight.rotate_y(PI)


