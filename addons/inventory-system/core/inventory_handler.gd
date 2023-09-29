@tool
@icon("res://addons/inventory-system/icons/inventory_handler.svg")
extends NodeInventorySystemBase
class_name InventoryHandler

## Act by changing inventories, opening and closing them, moving items between them, dropping items from them
## 
## Inventory Handler is normally tied to a game agent, such as player.

## Emitted when the handler has dropped an item.
## Called for each item dropped from the [code]drop_from_inventory()[/code] function.
signal dropped(dropped_item)

## Emitted when the handler has picked an item.
## Called for each item picked from the [code]pick_to_inventory()[/code] function.
signal picked(dropped_item)

## Emitted when item is added to inventories by handler.
## Called on each item added by the [code]add_to_inventory()[/code] function to the inventory used by the handler.
signal added(item : InventoryItem, amount : int)

## Emitted when inventory is opened by the handler.
## Called when the [code]open()[/code] function is called and the inventory has not yet been opened
signal opened(inventory : Inventory)

## Emitted when inventory is closed by the handler.
## Called when the [code]close()[/code] function is called and the inventory has not yet been closed
signal closed(inventory : Inventory)

## Emitted when handler transfers slot is updated.
## Called when the function [code]set_transaction_slot()[/code] is executed.
signal updated_transaction_slot(item : InventoryItem, amount : int)

## Main [Inventory] node path.
## The main [Inventory] is used in most handler functions as a default inventory.
@export_node_path("Inventory") var inventory_path := NodePath("Inventory")

## Path to where a drop of [DroppedItem] should be instantiated by the handler.
@export_node_path var drop_parent_path := NodePath("../..")

## Main [Inventory] node.
@onready var inventory := get_node(inventory_path)

## Drop parent node for [code]drop()[/code].
@onready var drop_parent := get_node(drop_parent_path)

## All inventories currently open by this handler
var opened_inventories : Array

# TODO More slot transactions (Queue transactions equal Project Zomboid)
## Slot responsible for storing transaction information
var transaction_slot : Slot = Slot.new()


## Drops an amount of an [InventoryItem].
## The scene to be instantiated from the item is fetched from the [InventoryDatabase] 
## and placed as a child of [code]drop_parent[/code].
## For each dropped item a [code]dropped[/code] signal is emitted.
func drop(item : InventoryItem, amount := 1) -> bool:
	if item.properties.has("dropped_item"):
		var path = item.properties["dropped_item"]
		var dropped_item = load(path)
		for i in amount:
			_instantiate_dropped_item(dropped_item)
		return true
	else:
		return false


## Add an amount of an [InventoryItem] to a inventory.
## If this addition fails and the [code]drop_excess[/code] is true then a drop of the unadded items occurs
func add_to_inventory(inventory : Inventory, item : InventoryItem, amount := 1, drop_excess := false) -> int:
	var value_no_added = inventory.add(item, amount)
	emit_signal("added", item, amount - value_no_added)
	if (drop_excess):
		drop(item, value_no_added)
		return 0
	return value_no_added


## Drops a amount of [InventoryItem] from a inventory.
## This function removes the item from the inventory and then calls the function [code]drop[/code].
func drop_from_inventory(slot_index : int, amount := 1, inventory := self.inventory):
	if inventory.slots.size() <= slot_index:
		return
	if inventory.is_empty_slot(slot_index):
		return
	var slot = inventory.slots[slot_index]
	var item = slot.item
	if item == null:
		return
	var not_removed = inventory.remove_at(slot_index, item, amount)
	var removed = amount - not_removed
	drop(item, removed)


## Pick a [InventoryItem] to inventory.
## This function adds the item to the inventory and destroys the [DroppedItem] object.
func pick_to_inventory(dropped_item, inventory := self.inventory):
	if not dropped_item is DroppedItem3D and not dropped_item is DroppedItem2D:
		return false
	if not dropped_item.is_pickable:
		return false
	var item = dropped_item.item
	if item == null:
		printerr("item in dropped_item is null!")
	if add_to_inventory(inventory, item) == 0:
		emit_signal("picked", dropped_item)
		dropped_item.queue_free()
		return true;
	return false;


## Exchanges a amount of an [InventoryItem] between inventories.
## First remove from the "from" [Inventory], then the successfully removed value is added to the "to" [Inventory],
## if any value is not successfully added, this value is added again to the "from" [Inventory] at the same index,
## if in this last task values are not added with successes they will be dropped with [code]drop()[/code]
func move_between_inventories(from : Inventory, slot_index : int, amount : int, to : Inventory):
	var slot = from.slots[slot_index];
	var item = slot.item;
	var amount_not_removed = from.remove_at(slot_index, item, amount);
	var amount_for_swap = amount - amount_not_removed;
	var amount_not_swaped = to.add(item, amount_for_swap);
	var amount_not_undo = from.add_at(slot_index, item, amount_not_swaped);
	drop(item, amount_not_undo);


## Swap slot information for inventories.
func swap_between_inventories(inventory : Inventory, slot_index : int, other_inventory : Inventory, other_slot_index : int, amount := 1):
	if inventory.database != other_inventory.database:
		return
	var slot = inventory.slots[slot_index];
	var other_slot = other_inventory.slots[other_slot_index];
	# Same Item in slot and other_slot
	if other_inventory.is_empty_slot(other_slot_index) or slot.item == other_slot.item:
		var item = slot.item
		if item == null:
			return
		var for_trade = 0
		if other_inventory.is_empty_slot(other_slot_index):
			for_trade = amount
		else:
			for_trade = min(item.max_stack - other_slot.amount, amount)
		var no_remove = inventory.remove_at(slot_index, item, for_trade)
		other_inventory.add_at(other_slot_index, item, for_trade - no_remove)
	# Different items in slot and other_slot
	else:
		if slot.amount == amount:
			inventory.set_slot_with_other_slot(slot_index, other_slot)
			other_inventory.set_slot_with_other_slot(other_slot_index, slot)


## Opens an [Inventory] that is closed.
## Returns [code]true[/code] if opened successfully.
func open(inventory : Inventory) -> bool:
	if opened_inventories.has(inventory):
		return false 
	if !inventory.open():
		return false
	opened_inventories.append(inventory)
	emit_signal("opened", inventory)
	return true


## Close an [Inventory] that is opened.
## Returns [code]true[/code] if closed successfully.
func close(inventory : Inventory) -> bool:
	var index = opened_inventories.find(inventory)
	if index == -1:
		return false
	if !inventory.close():
		return false
	opened_inventories.remove_at(index)
	emit_signal("closed", inventory)
	if self.inventory == inventory:
		if is_transaction_active():
			var item = transaction_slot.item
			var amount_no_add = inventory.add(item, transaction_slot.amount)
			if amount_no_add > 0:
				drop(item, amount_no_add)
			_set_transaction_slot(null, 0)
	return true


## Returns [code]true[/code] if main [Inventory] is open.
func is_open_main_inventory() -> bool:
	return is_open(inventory)


## Returns [code]true[/code] if any [Inventory] is open.
func is_open_any_inventory() -> bool:
	return opened_inventories.size() > 0


## Returns [code]true[/code] if [Inventory] is open.
func is_open(inventory : Inventory) -> bool:
	return inventory.is_open


## Open main [Inventory]. Return [code]true[/code] if opened successfully.
func open_main_inventory() -> bool:
	return open(inventory)


## Close main [Inventory]. Return [code]true[/code] if closed successfully.
func close_main_inventory() -> bool:
	return close(inventory)


## Close all open [Inventory]s.
func close_all_inventories():
	for i in range(opened_inventories.size() - 1, -1, -1):
		var inv = opened_inventories[0]
		close(inv)


## Move slot information from [code]slot_index[/code] of [Inventory] to transfer slot.
func to_transaction(slot_index : int, inventory : Inventory, amount : int):
	if is_transaction_active():
		return
	var slot = inventory.slots[slot_index]
	var item = slot.item
	if item == null:
		return
	var amount_no_removed = inventory.remove_at(slot_index, item, amount)
	_set_transaction_slot(item, amount - amount_no_removed)


## Moves transfer slot information to the [code]slot_index[/code] slot of [Inventory].
func transaction_to_at(slot_index : int, inventory : Inventory):
	if not is_transaction_active():
		return
	var slot = inventory.slots[slot_index]
	var item = transaction_slot.item
	if item == null:
		return
	if inventory.is_empty_slot(slot_index) or slot.item == item:
		var amount_no_add = inventory.add_at(slot_index, item, transaction_slot.amount)
		_set_transaction_slot(item, amount_no_add)
	else:
		# Different items in slot and other_slot
		# Check if transaction_slot amount is equal of origin_slot amount
		var new_amount = transaction_slot.amount
		if slot is CategorizedSlot:
			var c_slot = slot as CategorizedSlot
			if not c_slot.is_accept_category(item):
				return
		_set_transaction_slot(slot.item, inventory.slots[slot_index].amount)
		inventory.set_slot(slot_index, item, new_amount)


## Moves transfer slot information to [Inventory].
func transaction_to(inventory : Inventory):
	if not is_transaction_active():
		return
	var item = transaction_slot.item
	if item == null:
		return
	var amount_no_add = inventory.add(item, transaction_slot.amount)
	_set_transaction_slot(item, amount_no_add)


## Return [code]true[/code] if contains information in slot transaction.
func is_transaction_active() -> bool:
	return transaction_slot.item != null


## Drop [InventoryItem] from slot transaction.
func drop_transaction():
	if is_transaction_active():
		drop(transaction_slot.item, transaction_slot.amount)
	_set_transaction_slot(null, 0)


func _instantiate_dropped_item(dropped_item : PackedScene):
	var obj = dropped_item.instantiate()
	drop_parent.add_child(obj)
	obj.position = get_parent().position
	obj.rotation = get_parent().rotation
	emit_signal("dropped", obj)


func _set_transaction_slot(item : InventoryItem, amount : int):
	transaction_slot.amount = amount
	if amount > 0:
		transaction_slot.item = item
	else:
		transaction_slot.item = null
	emit_signal("updated_transaction_slot", transaction_slot.item, transaction_slot.amount)
