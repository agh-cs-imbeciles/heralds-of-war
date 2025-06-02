extends Node

const CELL_COST_INFINITY = 16777215  # 2^24 - 1

const PLAYER_A_COLOR = Color(1, 0.8, 0.8) # Czerwony dla gracza A
const PLAYER_B_COLOR = Color(0.8, 0.8, 1) # Niebieski dla gracza B
const PLAYER_TEXT_COLOR_CURRENT = Color.WHITE # Kolor tekstu dla aktywnego gracza w kolejce
const PLAYER_TEXT_COLOR_NORMAL = Color.LIGHT_GRAY # Kolor tekstu dla nieaktywnych graczy w kolejce
const PLAYER_TEXT_BG_CURRENT = Color(0.9, 0.9, 0.1, 0.6) # Lekko żółtawe tło dla aktywnego
const PLAYER_TEXT_BG_NORMAL = Color(0.5, 0.5, 0.5, 0.4) # Szarawe tło dla nieaktywnych
