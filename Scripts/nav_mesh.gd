extends Node3D

func _ready() -> void:
	# Находим NavigationRegion3D
	var nav_region: NavigationRegion3D = $NavigationRegion3D
	if not nav_region:
		push_error("NavigationRegion3D not found!")
		return
	
	# Создаем NavigationMesh
	var nav_mesh: NavigationMesh = NavigationMesh.new()
	nav_mesh.cell_size = 0.25
	nav_mesh.cell_height = 0.25
	nav_mesh.agent_radius = 0.5
	nav_mesh.agent_height = 0.3
	nav_mesh.max_slope = deg_to_rad(45.0)
	
	# Создаем MeshInstance3D для навигационной сетки
	var mesh_instance: MeshInstance3D = $NavigationRegion3D/NavMeshInstance
	if not mesh_instance:
		push_error("NavMeshInstance not found!")
		return
	
	# Устанавливаем NavigationMesh
	mesh_instance.mesh = nav_mesh
	
	# Указываем источник геометрии (трава)
	var source_geometry: NavigationMeshSourceGeometryData3D = NavigationMeshSourceGeometryData3D.new()
	var terrain_node = $HTerrainDetailLayer  # Замени на узел с травой, если это не HTerrainDetailLayer
	if terrain_node:
		source_geometry.add_node(terrain_node)
	else:
		push_error("Terrain node not found! Add a node with grass geometry.")
		return
	
	# Бейк навигационной сетки
	nav_mesh.bake_navigation_mesh(source_geometry, nav_region)
	nav_region.navigation_mesh = nav_mesh
	print("NavigationMesh baked successfully!")
