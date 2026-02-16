extends Node

# Данные
var points_titles = {
	"Cathedral3Saints": "Собор\nТрёх Святителей",
	"CathedralChrist": "Собор\nХриста Спасителя",
	"Church1WW": "Церковь-памятник Всех Святых\nпамяти павших в годы\nПервой мировой войны",
	"ChurchAdrian": "Храм святых\nАдриана и Наталии",
	"ChurchDimitry": "Храм святого великомученика\nДимитрия Солунского",
	"ChurchGeorgiy": "Храм великомученика\nГеоргия Победоносца",
	"ChurchGospodnya": "Храм преображения\nГосподня",
	"ChurchIoann": "Храм святого\nИоанна Предтечи",
	"ChurchKazan": "Храм иконы Божьей Матери\n\"Казанская\"",
	"ChurchMichael": "Храм\nархангела Михаила",
	"ChurchNevskii": "Храм святого благоверного\nкнязя Александра Невского",
	"ChurchPetrPavel": "Храм святых апостолов\nПетра и Павла",
	"ChurchRadoneshskii": "Храм в честь преподобногов\nСергия Ранонежского",
	"ChurchSofia": "Храм святых мучениц\nВеры, Надежды,\nЛюбови и матери их Софии",
	"ChurchSpirit": "Храм святого духа\n",
	"ChurchTihon": "Храм в честь святителя Тихона,\nПатриарха Московского\nи Всея Руси",
	"ChurchTihvin": "Храм Тихвинской иконы\nБожией Матери",
	"ChurchVarvara": "Храм святой\nвеликомученицы Варвары",
	"ChurchVladimir": "Храм в честь иконы\nБожией Матери \"Владимирская\"",
	"Derzhavnaya": "Державная\n(Женский монастырь)",
	"Gymnasya1": "Православная гимназия\nКалининградской Епархии",
	"Kirha": "Юдиттен-Кирха\n",
	"Kypelka": "Купелька\n(​Православный детский сад)",
	"MonasteryDerzhavnaya": "Женский монастырь\nиконы Божией Матери\n\"Державная\"",
	"MonasteryEkaterina": "Свято-Екатерининский\n(Женский монастырь)",
	"MonasteryElasavet": "Свято-Елисаветинский\n(Женский монастырь)",
	"PodvoryeNevskii": "Патриаршее подворье храма\n в честь благоверного князя\nАлександра Невского",
	"Skit": "Спасо-Преображенский скит\n(Мужской монастырь)",
}

# Переменные текущего объекта
var cur_title: String
var cur_img_path: String
var selected_point: Button
var active_panel_edge: String

# Функция-обработчик кнопок (Контент)
func load_map_point(point: Button) -> void:
	cur_title = points_titles[point.name]
	cur_img_path = "res://sprites/%s.png" % point.name
	
	print("[LOG | System] Point data recognized:\n▪️Title: %s\n▪️Img path: %s." % ([cur_title.strip_escapes(), cur_img_path]))
