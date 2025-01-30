extends CharacterBody3D
@onready var navigationAgent : NavigationAgent3D = $NavigationAgent3D
var SPEED = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if navigationAgent.is_target_reached():
		return
	moveToPoint(delta, SPEED)

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
		navigationAgent.target_position = result.position
