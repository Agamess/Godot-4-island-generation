@tool
extends Node3D

@export var Delete:bool : set=delete
@export var Generate_stuff_in_editor:bool : set=generate_stuff
@export var Generate_stuff_on_start:bool
@export var rocks: Array[PackedScene]
@export var rock_count = 50
@export var trees: Array[PackedScene]
@export var tree_count = 150
@export var flowers: Array[PackedScene]
@export var flower_count = 100
@onready var tarrain = $tarrain
@export var world_size = 3000
@export var max_spawn_height = 100000
@export var min_spawn_height = 0.0


var MIN_X=-world_size/2
var MAX_X=world_size/2
var MIN_Z=-world_size/2
var MAX_Z=world_size/2
#const MAX_HEIGHT = 20

var stuff_placed = false
var complete_land = false
var offset = Vector3(0,2.5,0)

func _ready():
	seed(randi())
	if Generate_stuff_on_start:
		generate_stuff(0)


func delete(__):
	for i in get_children():
		i.queue_free()


func generate_stuff(__):
	stuff_placed = false
	complete_land = true
	
	#generate deatails
	if complete_land and stuff_placed == false:
		generate_trees()
		generate_rocks()
		generate_flowers()
		stuff_placed = true


func generate_trees():
	for i in tree_count:
		var num = randi_range(0,trees.size()-1)
		var treei = trees[num].instantiate()
		add_child(treei)
		var pos = Vector3(randi_range(MIN_Z,MAX_X), max_spawn_height, randi_range(MIN_Z,MAX_X))
		var fnl_pos = get_down_ray(pos)
		if fnl_pos == Vector3.ZERO:
			treei.queue_free()
		var rot = Vector3(0, randi_range(0,360), 0)
		treei.global_transform.origin = fnl_pos
		treei.rotation_degrees = rot


func generate_rocks():
	for i in rock_count:
		var num = randi_range(0,rocks.size()-1)
		var rocki = rocks[num].instantiate()
		add_child(rocki)
		var pos = Vector3(randi_range(MIN_Z,MAX_X), max_spawn_height, randi_range(MIN_Z,MAX_X))
		var fnl_pos = get_down_ray(pos)
		if fnl_pos == Vector3.ZERO:
			rocki.queue_free()
		var rot = Vector3(0, randi_range(0,360), 0)
		rocki.global_transform.origin = fnl_pos
		rocki.rotation_degrees = rot


func generate_flowers():
	for i in flower_count:
		var num = randi_range(0,flowers.size()-1)
		var floweri = flowers[num].instantiate()
		add_child(floweri)
		var pos = Vector3(randi_range(MIN_Z,MAX_X), max_spawn_height, randi_range(MIN_Z,MAX_X))
		var fnl_pos = get_down_ray(pos)
		if fnl_pos == Vector3.ZERO:
			floweri.queue_free()
		var rot = Vector3(0, randi_range(0,360), 0)
		floweri.global_transform.origin = fnl_pos
		floweri.rotation_degrees = rot


func get_down_ray(pos):
	var lenght = max_spawn_height - min_spawn_height;
	var query = PhysicsRayQueryParameters3D.create(pos, pos + Vector3(0, -lenght, 0))
	var collision = get_world_3d().direct_space_state.intersect_ray(query)
	if collision:
		return collision.position
	else:
		
		return Vector3.ZERO
