@tool
extends StaticBody3D

@export var auto_generate_mesh:bool = false
@export var Generate_mesh:bool : set=generate_mesh
@export var size:int = 3000
@export var fall_width:int = 10
@export var subdivide:int = 63
@export var amplitude:int = 163
@export var max_amplitude_clamp:int = 10000
@export var min_amplitude_clamp:int = -32
@export var terrain_height:int = 100
@export var noice_frequency:float = 0.001
@export var noise:FastNoiseLite = FastNoiseLite.new()
@export var amplitude_curve:Curve
@export var terrain_height_curve:Curve

func _ready() -> void:
	if auto_generate_mesh:
		generate_mesh(0)
	pass # Replace with function body.
	
func generate_mesh(__) -> void:
	print("Generating Mesh...")
	
	noise.seed = randi()
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size,size)
	plane_mesh.subdivide_depth = subdivide
	plane_mesh.subdivide_width = subdivide
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	
	for i in vertices.size():
		var vertex = vertices[i]
		var distance = 1-clamp(Vector2(vertex.x,vertex.z).distance_to(Vector2(0,0))/(size*0.5),0,1)
		vertices[i].y = clamp((noise.get_noise_2d(vertex.x,vertex.z) * (amplitude * amplitude_curve.sample(distance))),min_amplitude_clamp,max_amplitude_clamp) + ((terrain_height_curve.sample(distance) - 0.5) * terrain_height)
	data[ArrayMesh.ARRAY_VERTEX] = vertices
		
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()

	$MeshInstance3D.mesh = surface_tool.commit()
	$CollisionShape3D.shape = array_mesh.create_trimesh_shape()
