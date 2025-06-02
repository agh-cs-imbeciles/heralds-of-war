extends Node

const CELL_COST_INFINITY = 16777215  # 2^24 - 1

const PLAYER_A_COLOR = Color(1, 0.8, 0.8)
const PLAYER_B_COLOR = Color(0.8, 0.8, 1)
const PLAYER_TEXT_COLOR_CURRENT = Color.WHITE # Text color for the active player in the queue
const PLAYER_TEXT_COLOR_NORMAL = Color.LIGHT_GRAY # Text color for inactive players in the queue
const PLAYER_TEXT_BG_CURRENT = Color(0.9, 0.9, 0.1, 0.6) # Background color for the active player in the queue
const PLAYER_TEXT_BG_NORMAL = Color(0.5, 0.5, 0.5, 0.4) # Background color for inactive players in the queue
