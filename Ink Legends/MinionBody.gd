extends CharacterBody3D

@onready var navigationAgent = $NavigationAgent3D

const SPEED = 5
const MAXPOS = Vector3(99999, 99999, 99999)

func _ready():
	checkTarget() 

func _process(delta):
	if navigationAgent.is_target_reached():
		return	
	var next_position = navigationAgent.get_next_path_position()
	moveToPoint(delta, SPEED, next_position)

func moveToPoint(_delta, speed, next_position):
	var direction = global_position.direction_to(next_position)
	faceDirection(next_position)
	velocity = direction * speed 
	move_and_slide()

func faceDirection(direction):
	var lookAtPos = Vector3(direction.x, global_position.y, direction.z)
	look_at(lookAtPos, Vector3.UP)

func checkTarget():
	var targetPos = MAXPOS
	var enemyTowerLocations = get_tree().get_nodes_in_group("Enemy Tower Locations")
	for tower in enemyTowerLocations:
		var towerPos = tower.global_position
		var newDistance = global_position.distance_to(towerPos)
		var currDistance = global_position.distance_to(targetPos)
		if newDistance < currDistance:
			targetPos = getRandomPointClose(towerPos)
	if targetPos != MAXPOS:
		navigationAgent.target_position = targetPos

func getRandomPointClose(center: Vector3) -> Vector3:
	var randomAngle = randf_range(0, TAU)  # Random angle in radians
	var randomRadius = randf_range(0, 1)   # Random radius between 0 and 1 meters
	return center + Vector3(randomRadius * cos(randomAngle), randomRadius * sin(randomAngle), 0)
