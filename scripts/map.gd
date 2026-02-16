extends Node2D

# Константы (pts - "points", состояния анимаций)
const MAP_PTS_GROUP = "map_points"
const HOVER_SCALE = Vector2(1.14, 1.14)
const DEFAULT_SCALE = Vector2.ONE
const SELECTED_SCALE = Vector2(1.25, 1.25)

# Переменные
var disabled_input := false

# Ноды
@onready var info_panel = $Canvas/InfoPanel
@onready var info_title = $Canvas/InfoPanel/Margin/VBox/Title
@onready var info_image = $Canvas/InfoPanel/Margin/VBox/Image
@onready var info_close_btn = $Canvas/InfoPanel/Margin/VBox/Header/CloseBtn

# Обработка ввода
func _input(_event):
	if disabled_input:
		get_viewport().set_input_as_handled()

# Настройка сцены
func _ready() -> void:
	# Подключаем системную функцию-обработчик к кнопкам
	for point in get_tree().get_nodes_in_group(MAP_PTS_GROUP):
		setup_point_style(point)
		point.pressed.connect(handle_map_point.bind(point))
		point.mouse_entered.connect(handle_point_hover.bind(point, true))
		point.mouse_exited.connect(handle_point_hover.bind(point, false))
	
	info_panel.close_info_panel()
	print("[LOG | Map] Loaded scene.")


# Анимация подскока
func bounce_animation(point: Button, jump_height: float = 20.0, duration: float = 0.45) -> void:
	var tween = point.create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	var original_pos = point.position
	var jumped_pos = original_pos + Vector2(0, -jump_height)
	
	disabled_input = true
	tween.tween_property(point, "position", jumped_pos, duration / 2)
	tween.tween_property(point, "position", original_pos, duration / 2)

	await tween.finished
	disabled_input = false
	print("[LOG | Map] Played point animation \"Bounce\" for ", duration, " s.")


# Функция-обработчик точек (Карта)
func handle_map_point(point: Button) -> void:
	# Не обрабатываем кнопку, если выбрали ту же кнопку
	if point == System.selected_point:
		return
	
	print("[LOG | Map] Started \"Point handle\".")
	set_selected_point(point)
	System.load_map_point(point)
	await bounce_animation(point)
	info_panel.open_info_panel(point)


# Настройка точки
func setup_point_style(point: Button) -> void:
	# Устанавливаем центр кнопки, подсказку
	point.pivot_offset = point.size / 2.0
	point.tooltip_text = System.points_titles.get(point.name, point.name).replace("\n", " ")


# Hover-эффект для невыбранных точек (увеличение).
func handle_point_hover(point: Button, is_hovered: bool) -> void:
	# Если точка выбрана, значит не применяем эффект
	if point == System.selected_point:
		return

	var tween = point.create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	if is_hovered:
		tween.tween_property(point, "scale", HOVER_SCALE, 0.14)
	else:
		tween.tween_property(point, "scale", DEFAULT_SCALE, 0.14)


# Переключение выбранной точки.
func set_selected_point(point: Button) -> void:
	# Уменьшаем прошлую выбранную точку обратно и сбрасываем её
	if System.selected_point and point != System.selected_point:
		deselect_point()

	# Увеличиваем выбранную точку
	System.selected_point = point
	System.selected_point.scale = SELECTED_SCALE
	
func deselect_point() -> void:
	System.selected_point.scale = DEFAULT_SCALE
	System.selected_point = null
