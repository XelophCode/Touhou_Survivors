extends Resource
class_name FolderListResource

@export_dir
@onready var FolderPath : String:
	set(value):
		FolderPath = value
		load_all_resources()



@export
var ResourceCategory : String

var all_resources = []

func load_all_resources() -> void:
	if FolderPath:
		var folder = DirAccess.open(FolderPath)
		folder.list_dir_begin()
		
		var file_name = folder.get_next()
		while file_name != "":
			if not folder.current_is_dir() and file_name.find(".gd") == -1:
				all_resources.push_back(load(FolderPath.path_join(file_name)))
			
			file_name = folder.get_next()
			
		folder.list_dir_end()
	else:
		print("An error occurred when trying to access the folder.")
	

func find_index_of(resource : Resource) -> int:
	return all_resources.find(resource)

