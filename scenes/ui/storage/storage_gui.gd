extends StorageGUI

func initialize_storage(_storage_component: StorageComponent) -> void:
	storage_component = _storage_component
	super.load_slots()
