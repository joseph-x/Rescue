extends Node

enum CHARACTER_TYPE {
	PATIENT,
	STAFF
}

enum CRISIS_LEVEL {
	IDLE,
	LOW,
	MEDIUM,
	HIGH,
	CRITICAL
}

# 游戏速度倍率
enum GAME_SPEED {
	PAUSED = 0,
	NORMAL = 1,
	FAST = 2,
	FASTEST = 4
}
