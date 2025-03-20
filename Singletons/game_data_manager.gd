extends Node

var items: Dictionary = {}
var seeds: Dictionary = {}
var item_recipes: Dictionary = {}
var enemies: Dictionary = {}
var quests: Dictionary = {}


func load_resources_recursive(path: String) -> void:
	var dir = DirAccess.open(path)
	
	if dir:
		var file_names = dir.get_files()
		for file in file_names:
			# Refer to https://github.com/godotengine/godot/issues/66014
			file = file.trim_suffix('.remap')
			if file.ends_with(".tres"):
				var resource_path = path + file
				var res = load(resource_path)
				if !res:
					continue
				
				if res is SeedItemResource:
					seeds[res.name] = res
				elif res is ItemResource:
					items[res.name] = res
				elif res is EnemyResource:
					enemies[res.name] = res
				elif res is QuestResource:
					quests[res.title] = res
				elif res is ItemRecipeResource:
					item_recipes[res.name] = res
		var subdirs = dir.get_directories()
		for subdir in subdirs:
			if subdir == "scripts":
				continue
			load_resources_recursive(path + subdir + "/")
	else:
		print("Failed to open directory:", path)


func save_resource(resource: Resource, path: String):
	var result: int = ResourceSaver.save(resource, path)


func save_game_data(directory: String):
	if !DirAccess.dir_exists_absolute(directory):
		DirAccess.make_dir_absolute(directory)
		
	var items_directory = directory + "/items/"
	if !DirAccess.dir_exists_absolute(items_directory):
		DirAccess.make_dir_absolute(items_directory)
	for item in items.values():
		save_resource(item, items_directory + item.name + ".tres")
		
	var item_recipes_directory = directory + "/item_recipes/"
	if !DirAccess.dir_exists_absolute(item_recipes_directory):
		DirAccess.make_dir_absolute(item_recipes_directory)
	for item_recipe in item_recipes.values():
		save_resource(item_recipe, item_recipes_directory + item_recipe.name + ".tres")
	
	var enemies_directory = directory + "/enemies/"
	if !DirAccess.dir_exists_absolute(enemies_directory):
		DirAccess.make_dir_absolute(enemies_directory)
	for enemy in enemies.values():
		save_resource(enemy, enemies_directory + enemy.name + ".tres")
	
	var quests_directory = directory + "/quests/"
	if !DirAccess.dir_exists_absolute(quests_directory):
		DirAccess.make_dir_absolute(quests_directory)
	for quest in quests.values():
		save_resource(quest, quests_directory + quest.name + ".tres")

func get_item(name: String) -> ItemResource:
	if name.contains("Seed"):
		return seeds.get(name, null)
	
	return items.get(name, null)

func get_seed_item(name: String) -> SeedItemResource:
	return seeds.get(name, null)

func get_item_recipe(name: String) -> ItemRecipeResource:
	return item_recipes.get(name, null)

func get_enemy(name: String) -> EnemyResource:
	return enemies.get(name, null)

func get_quest(title: String) -> QuestResource:
	return quests.get(title, null)

func is_item(name: String) -> bool:
	return items.has(name) or seeds.has(name)
