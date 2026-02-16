extends Panel

# Константы
const PANEL_ANIM_TIME = 0.22
const PANEL_HIDDEN_SCALE = Vector2(0.94, 0.94)
const PANEL_EDGE_OFFSET = 30.0

# Ноды
@onready var map_scene = $"../.."
@onready var overlay = $"../Overlay"
@onready var info_image = %Image
@onready var info_title = %Title
@onready var info_close_btn = %CloseBtn

# Настройка объекта
func _ready() -> void:
	# Подключение функции-выхода для кнопки
	info_close_btn.pressed.connect(close_info_panel)
	overlay.gui_input.connect(handle_overlay_input)

# Определение края открытия карточки
func get_panel_edge(point_center: Vector2, viewport_size: Vector2) -> String:
	if point_center.x < viewport_size.x / 2.0:
		return "right"
	else:
		return "left"

# Расчет позиции панели от выбранного края экрана
func calculate_panel_position(point: Button) -> Vector2:
	var viewport_size = get_viewport_rect().size
	var point_center = point.position + point.size / 2.0
	
	System.active_panel_edge = get_panel_edge(point_center, viewport_size)

	var pos_x = 0
	if System.active_panel_edge == "right":
		pos_x = viewport_size.x - self.size.x

	return Vector2(pos_x, 0)


# Открытие панели информации
func open_info_panel(point: Button) -> void:	
	# > Загрузка данных текущего объекта (System)
	var point_title = System.cur_title
	var point_img_path = System.cur_img_path
	var panel_pos = calculate_panel_position(point)
	
	info_image.texture = load(point_img_path)
	info_title.text = point_title
	
	# Если точка не выделена, убеждаемся в отсутствии затемнения и панели
	if not System.selected_point:
		self.modulate.a = 0.0
		overlay.modulate.a = 0.0
	
	# Открываем панель
	self.show()
	self.scale = PANEL_HIDDEN_SCALE
	self.position = panel_pos
	overlay.show()
	
	# Запуск анимации
	if System.active_panel_edge == "right":
		self.position.x += PANEL_EDGE_OFFSET
	else:
		self.position.x -= PANEL_EDGE_OFFSET
	
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "position", panel_pos, PANEL_ANIM_TIME)
	tween.tween_property(self, "modulate:a", 1.0, PANEL_ANIM_TIME)
	tween.tween_property(self, "scale", Vector2.ONE, PANEL_ANIM_TIME)
	tween.tween_property(overlay, "modulate:a", 1.0, PANEL_ANIM_TIME)

# Закрытие панели
func close_info_panel() -> void:
	# Если панель и так закрыта, убеждаемся, что overlay скрыт
	if not self.visible:
		overlay.hide()
		return

	# Сбрасываем визуальное выделение активной точки.
	if System.selected_point:
		map_scene.deselect_point()

	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(self, "modulate:a", 0.0, PANEL_ANIM_TIME)
	tween.tween_property(self, "scale", PANEL_HIDDEN_SCALE, PANEL_ANIM_TIME)
	tween.tween_property(overlay, "modulate:a", 0.0, PANEL_ANIM_TIME)

	await tween.finished
	self.hide()
	overlay.hide()

# Обработчик клика по затемненной области
func handle_overlay_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		close_info_panel()
