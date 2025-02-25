extends Node

var items: Dictionary = {}
var item_recipes: Dictionary = {}
var enemies: Dictionary = {}
var quests: Dictionary = {}

func load_game_data(directory: String):
	if !DirAccess.dir_exists_absolute(directory):
		return

	var dir = DirAccess.open(directory)
	dir.list_dir_begin()

	var dir_name = dir.get_next()
	while dir_name != "":
		var dir_category = DirAccess.open(directory + "/" + dir_name)
		if dir_category:
			dir_category.list_dir_begin()
			var file_name = dir_category.get_next()
			while file_name != "":
				if file_name.ends_with(".tres"):
					var resource = load(directory + "/" + dir_name + "/" + file_name)
					if resource is ItemResource:
						items[resource.name] = resource
					elif resource is EnemyResource:
						enemies[resource.name] = resource
					elif resource is QuestResource:
						quests[resource.title] = resource
					elif resource is ItemRecipeResource:
						item_recipes[resource.name] = resource
				file_name = dir_category.get_next()
			dir_category.list_dir_end()
		dir_name = dir.get_next()
	
	dir.list_dir_end()


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
	for item_recipe in items.values():
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
	return items.get(name, null)

func get_item_recipe(name: String) -> ItemRecipeResource:
	return item_recipes.get(name, null)

func get_enemy(name: String) -> EnemyResource:
	return enemies.get(name, null)

func get_quest(title: String) -> QuestResource:
	return quests.get(title, null)
