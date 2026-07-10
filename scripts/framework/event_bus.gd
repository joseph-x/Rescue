extends Node

# GameData
signal data_loaded

# 背包
signal inventory_changed(item: Variant)
signal inventory_added(item: Variant, count: int)
signal inventory_removed(item: Variant, count: int)

# 经济
signal credit_changed(amount: int)
signal money_changed(amount: int)

# 时间
signal day_passed

# 任务
signal quest_started(quest: Quest)
signal quest_completed(quest: Quest)


# NPC
signal npc_talk(npc)
signal npc_relationship_changed(npc1, npc2, relationship)


# Save/Load
signal before_save
signal game_saved
signal before_load
signal game_loaded

signal auto_saved
signal save_failed
signal load_failed
