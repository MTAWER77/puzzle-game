extends CharacterBody3D
class_name Player

# ======== SETTINGS ========
@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 5.0
@export var MOUSE_SENSITIVITY: float = 0.0025

# ======== VARIABLES ========
var input_dir: Vector2 = Vector2.ZERO

# ======== NODE REFERENCES ========
@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var shape_cast_3d: ShapeCast3D = $Head/Camera3D/ShapeCast3D
@onready var interact_container: Control = $UIControl/InteractContainer
@onready var interact_label: Label = $UIControl/InteractContainer/HBoxContainer/InteractLabel
@onready var note_control: Control = $NoteControl
@onready var note_texture: TextureRect = $NoteControl/TextureRect
@onready var note_text_label: Label = $NoteControl/TextureRect/TextLabel


var can_move:bool = true
func show_note(note:Note3d) -> void:
	can_move = false
	note_text_label.text = note.note_contents
	note_control.show()

func close_note():
	can_move = true
	note_control.hide()




# ======== READY ========
func _ready() -> void:
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_3d.set_current(true)
	interact_container.hide() 
	note_control.hide()
	# يخفي رسالة التفاعل أول ما اللعبة تفتح

# ======== PHYSICS ========
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if shape_cast_3d.is_colliding():
		var collider = shape_cast_3d.get_collider(0)
		if collider and collider.get_parent().has_method("interact"):
			var collider_thing = collider.get_parent()
			interact_label.text = collider_thing.use_text
			interact_container.show()
		else:
			interact_container.hide()
	else:
		interact_container.hide()

	
	# الجاذبية


	# حركة اللاعب
	input_dir = Input.get_vector("left", "right", "up", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# تنفيذ الحركة
	move_and_slide()

	# ===== INTERACT =====
	
# ======== INPUT ========
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	
	
	
	
	
	
	
	if !can_move:
		if event is InputEventKey:
			if Input.is_action_just_pressed("use"):
				close_note()
	
	
	
	
	
	
	# تحريك الكاميرا بالماوس
	if event is InputEventMouseMotion:
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, -PI / 2, PI / 2)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		return

	# قفل / فتح الماوس


	# تنفيذ interact عند الضغط على "use"
	if event is InputEventKey:
		if Input.is_action_just_pressed("use"):
			if shape_cast_3d.is_colliding():
				var collider = shape_cast_3d.get_collider(0)
				if collider.get_parent().has_method("interact"):
					collider.get_parent().interact()
