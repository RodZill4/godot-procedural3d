tool
extends EditorScenePostImport

func _ready():
	pass

func post_import(scene):
	
	for object in scene.get_children():
		var object_name = object.name
		var mesh = object.mesh
		if mesh.get_surface_count() == 0:
			print("Mesh "+object_name+" is empty")
			scene.remove_child(object)
			continue
		for i in range(mesh.get_surface_count()):
			var mat = mesh.surface_get_material(i)
			var mat_filename = "res://models/materials/"+mat.resource_name+".tres"
			mat.metallic = 0.0
			mat.roughness = 1.0
			ResourceSaver.save(mat_filename, mat)
			mesh.surface_set_material(i, load(mat_filename))
		ResourceSaver.save("res://models/meshes/"+object_name+".tres", mesh)
	if scene.get_children().size() == 1:
		return scene.get_child(0)
	scene.name = scene.get_child(0).name
	return scene
	
