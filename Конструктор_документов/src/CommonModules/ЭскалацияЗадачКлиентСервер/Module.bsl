////////////////////////////////////////////////////////////////////////////////
// Эскалация задач: модуль для работы с эскалацией и автоматическим выполнением задач.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует представление направления эскалации.
//
// Параметры:
//  НаправлениеЭскалации - СправочникСсылка.ПолныеРоли, СправочникСсылка.Пользователи,
//                         Строка - Направление эскалации.
// 
// Возвращаемое значение:
//  Тип - Представление направления эскалации
//
Функция ПредставлениеНаправленияЭскалации(НаправлениеЭскалации) Экспорт
	
	Представление = Строка(НаправлениеЭскалации);
	
	Возврат Представление;
	
КонецФункции

// Возвращает разделитель запросов ОБЪЕДИНИТЬ ВСЕ.
//
// Возвращаемое значение:
//  Строка - Разделитель запросов ОБЪЕДИНИТЬ ВСЕ.
//
Функция РазделительЗапросовОбъединитьВсе() Экспорт
	
	РазделительЗапросов = 
		"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
	
	Возврат РазделительЗапросов;
	
КонецФункции

// Возвращает число дней просрочки.
//
// Параметры:
//  Срок - Число - Срок в секундах.
// 
// Возвращаемое значение:
//  Число - Число дней просрочки.
//
Функция ЧислоДнейСрока(Срок) Экспорт
	
	ЧислоДней = Цел(Срок / 86400); // 86400 - число секунд в дне.
	
	Возврат ЧислоДней;
	
КонецФункции

// Возвращает число часов просрочки.
//
// Параметры:
//  Срок - Число - Срок в секундах.
// 
// Возвращаемое значение:
//  Число - Число часов просрочки.
//
Функция ЧислоЧасовСрока(Срок) Экспорт
	
	ЧислоЧасов = Цел((Срок - ЧислоДнейСрока(Срок) * 86400) / 3600); // 3600 - число секунд в часе.
	
	Возврат ЧислоЧасов;
	
КонецФункции

#КонецОбласти