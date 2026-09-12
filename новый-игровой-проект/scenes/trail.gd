extends MeshInstance3D

@export var fade_time: float = 0.08
@export var trail_color: Color = Color(1.0, 0.85, 0.3)

func _ready() -> void:
	top_level = true  # draw in world space, ignore whatever parents it later

	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = trail_color
	material_override = mat

func draw(from: Vector3, to: Vector3) -> void:
	var im := ImmediateMesh.new()
	mesh = im
	im.surface_begin(Mesh.PRIMITIVE_LINES)
	im.surface_add_vertex(from)
	im.surface_add_vertex(to)
	im.surface_end()

	var tween := create_tween()
	tween.tween_property(material_override, "albedo_color:a", 0.0, fade_time)
	tween.tween_callback(queue_free)
