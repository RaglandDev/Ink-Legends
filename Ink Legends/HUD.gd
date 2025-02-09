extends CanvasLayer

@onready var health = $Control/Bottom/HIBar/Health
@onready var ink = $Control/Bottom/HIBar/Ink

var qScene = preload("res://SkillShot.tscn")
var qProjScene = preload("res://QProjectile.tscn")

const Q_COST = 20

var player = null
var qAim = false
var qHighlight = null

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	health.value = player.hp
	ink.value = player.ink
	

func _process(_delta):
	if Input.is_action_just_released("Q") and qHighlight != null:
		qHighlight.queue_free()
		qAim = false
		player.ink -= Q_COST
		ink.value = player.ink
		var projectile = qProjScene.instantiate()
		get_tree().root.add_child(projectile)
		projectile.targetPos = qHighlight.get_node("Endpoint").global_position
		projectile.position = qHighlight.get_node("Startpoint").global_position
		projectile.look_at(projectile.targetPos)
		return
	if Input.is_action_just_pressed("Q") and !qAim and player.ink >= Q_COST:
		qHighlight = qScene.instantiate()
		qHighlight.scale = Vector3(12, 12, 12)
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


