extends Camera3D

const THRESHOLD = 50
const STEP = .5
const ZOOM_STEP = 2

var zoom = 0

@onready var viewportSize = get_viewport().size

func _process(_delta):
	if Input.is_action_just_pressed("ZoomIn") and zoom < 3:
		position = position - Vector3(ZOOM_STEP, ZOOM_STEP, ZOOM_STEP)
		zoom += 1
	if Input.is_action_just_pressed("ZoomOut") and zoom > -10:
		position = position + Vector3(ZOOM_STEP, ZOOM_STEP, ZOOM_STEP)
		zoom -= 1
	var localMousePos = get_viewport().get_mouse_position()
	edgeScroll(localMousePos.x, localMousePos.y)

func edgeScroll(x, y):
	var moveDirection = Vector3.ZERO
	if x < THRESHOLD:
		moveDirection.x -= STEP  # Move left
	if x > viewportSize.x - THRESHOLD:
		moveDirection.x += STEP  # Move right
	if y < THRESHOLD:
		moveDirection.z -= STEP  # Move forward 
	if y > viewportSize.y - THRESHOLD:
		moveDirection.z += STEP  # Move backward
	if moveDirection.length() > 0:
		moveDirection = moveDirection.normalized() * STEP

	position += moveDirection
