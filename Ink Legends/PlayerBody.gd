extends CharacterBody3D

@onready var navigationAgent : NavigationAgent3D = $NavigationAgent3D
@onready var animationTree : AnimationTree = $AnimationTree
@onready var stateMachine = animationTree["parameters/playback"]

var maxSpeed = 10
var hp = 50
var ink = 50

func _ready():
	navigationAgent.target_position = position


func _process(delta):
	if navigationAgent.is_target_reached():
		stateMachine.travel("idle")
		return
	if self.velocity.x !=0 or self.velocity.z != 0:
		stateMachine.travel("sprint")
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
		var result = space.intersect_ray(rayQuery)
		result.position.y = 0 # prevent vertical movement
		navigationAgent.target_position = result.position

