extends CharacterBody3D

@onready var navigationAgent : NavigationAgent3D = $NavigationAgent3D
@onready var animationTree = $AnimationTree

var maxSpeed = 10
var hp = 100
var ink = 100

var idle = false
var sprint = false 
var qAttack = false


func _ready():
	idle = true
	navigationAgent.target_position = position


func _process(delta):
	if position.distance_to(navigationAgent.target_position) > .25:
		sprint = true
		idle = false
		qAttack = false
	elif !qAttack:
		idle = true
		sprint = false
		qAttack = false
	animationTree.set("parameters/conditions/idle", idle)
	animationTree.set("parameters/conditions/sprint", sprint)
	animationTree.set("parameters/conditions/q", qAttack)
	if navigationAgent.is_target_reached():
		return
	moveToPoint(delta, maxSpeed)
	navigationAgent.get_next_path_position()
	

func moveToPoint(_delta, speed):
	var targetPos = navigationAgent.target_position
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	velocity = direction * speed 
	move_and_slide()

func faceDirection(direction):
	var lookAtPos := Vector3(direction.x, global_position.y, direction.z)
	if lookAtPos != self.position:
		look_at(lookAtPos, Vector3.UP)
		rotate_y(deg_to_rad(180))
	
func _input(_event):
	if Input.is_action_just_pressed("RightMouse"):
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mousePos = get_viewport().get_mouse_position()
		var rayLength = 100
		var from = camera.project_ray_origin(mousePos)
		var to = from + camera.project_ray_normal(mousePos) * rayLength
		var space = get_world_3d().direct_space_state
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		rayQuery.exclude = [self.get_rid()] # raycast ignore player model
		var result = space.intersect_ray(rayQuery)
		result.position.y = 0 # prevent vertical movement
		navigationAgent.target_position = result.position

func q():
	idle = false
	sprint = false
	qAttack = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "spell 1h":
		qAttack = false
		idle = true 
		sprint = false

