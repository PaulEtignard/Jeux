extends CharacterBody2D

const SPEED = 150.0
const DASH_SPEED = 800.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Gérer le cooldown du dash
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	# Gérer le dash
	if is_dashing:
		dash_timer -= delta
		velocity = dash_direction * DASH_SPEED
		
		if dash_timer <= 0:
			is_dashing = false
			velocity = Vector2.ZERO
	else:
		# Mouvement normal
		handle_normal_movement()
		
		# Déclencher le dash
		if Input.is_action_just_pressed("ui_accept") and dash_cooldown_timer <= 0:
			start_dash()
	
	move_and_slide()

func handle_normal_movement():
	# Mouvement horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Mouvement vertical (optionnel, pour un mouvement 2D complet)
	var vertical_direction := Input.get_axis("ui_up", "ui_down")
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func start_dash():
	# Déterminer la direction du dash
	var input_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	# Si aucune direction n'est pressée, dash vers la droite par défaut
	if input_direction.length() == 0:
		dash_direction = Vector2.RIGHT
	else:
		dash_direction = input_direction.normalized()
	
	# Activer le dash
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN
