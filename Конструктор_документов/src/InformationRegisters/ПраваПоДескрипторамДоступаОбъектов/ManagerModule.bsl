
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает права пользователя по дескрипторам объекта.
//
// Параметры:
//  СсылкаНаОбъект - Ссылка - ссылка на объект, чьи права нужно проверить.
//  Пользователь - пользователь, чьи права проверяются. Если не указан, то текущий.
//
// Возвращаемое значение:
//  Структура - структура прав доступа пользователя к объекту.
//
Функция ПолучитьПраваПользователейПоОбъектам(
			ОбъектыДоступа,
			Пользователи = Неопределено,
			ВключаяРуководителейИДелегатов = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбъектыДоступа.Количество() = 0 Тогда
		Возврат ДокументооборотПраваДоступа.ТаблицаПравПользователейПоОбъектам();
	КонецЕсли;
	
	// Права по дескрипторам с учетом неограниченных прав.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДескрипторыДляОбъектов.Объект КАК ОбъектДоступа,
		|	ПраваПоДескрипторамДоступаОбъектов.Пользователь КАК Пользователь,
		|	ИСТИНА КАК Чтение,
		|	МАКСИМУМ(ПраваПоДескрипторамДоступаОбъектов.Добавление) КАК Добавление,
		|	МАКСИМУМ(ПраваПоДескрипторамДоступаОбъектов.Изменение) КАК Изменение,
		|	МАКСИМУМ(ПраваПоДескрипторамДоступаОбъектов.Удаление) КАК Удаление,
		|	МАКСИМУМ(ПраваПоДескрипторамДоступаОбъектов.УправлениеПравами) КАК УправлениеПравами
		|ИЗ
		|	РегистрСведений.ДескрипторыДляОбъектов КАК ДескрипторыДляОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПраваПоДескрипторамДоступаОбъектов КАК ПраваПоДескрипторамДоступаОбъектов
		|		ПО ДескрипторыДляОбъектов.Дескриптор = ПраваПоДескрипторамДоступаОбъектов.Дескриптор
		|ГДЕ
		|	ДескрипторыДляОбъектов.Объект В(&ОбъектыДоступа)
		|	И ПраваПоДескрипторамДоступаОбъектов.Пользователь В(&Пользователи)
		|	И ПраваПоДескрипторамДоступаОбъектов.ОбъектОснование = НЕОПРЕДЕЛЕНО
		|	И НЕ ДескрипторыДляОбъектов.Отключен
		|
		|СГРУППИРОВАТЬ ПО
		|	ДескрипторыДляОбъектов.Объект,
		|	ПраваПоДескрипторамДоступаОбъектов.Пользователь");
		
	Если Пользователи = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
			"И ПраваПоДескрипторамДоступаОбъектов.Пользователь В(&Пользователи)", "");
	КонецЕсли;
	
	Если ВключаяРуководителейИДелегатов Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
			"И ПраваПоДескрипторамДоступаОбъектов.ОбъектОснование = Неопределено", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ОбъектыДоступа", ОбъектыДоступа);
	Запрос.УстановитьПараметр("Пользователи", Пользователи);
	
	ТаблицаПрав = ДокументооборотПраваДоступа.ТаблицаПравПользователейПоОбъектам();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаПрав.Добавить(), Выборка);
	КонецЦикла;
	
	Возврат ТаблицаПрав;
	
КонецФункции

// Возвращает общие права пользователей контейнера по стандартному дескриптору объекта.
// 
// Параметры:
//  СсылкаНаОбъект - Ссылка - ссылка на объект, чьи права нужно проверить.
//  Контейнеры - контейнеры, чьи права проверяются.
//
// Возвращаемое значение:
//  ТаблицаЗначений, Неопределено - таблица прав доступа.
 //  Возвращаются минимальные права пользователей контейнера.
//   Если объект не использует стандартные дескрипторы, то Неопределено.
// 
Функция ПолучитьСтандартныеПраваКонтейнеровПоОбъекту(СсылкаНаОбъект, Контейнеры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаПрав = Новый ТаблицаЗначений;
	ТаблицаПрав.Колонки.Добавить("Контейнер");
	ТаблицаПрав.Колонки.Добавить("Чтение");
	ТаблицаПрав.Колонки.Добавить("Добавление");
	ТаблицаПрав.Колонки.Добавить("Изменение");
	ТаблицаПрав.Колонки.Добавить("Удаление");
	ТаблицаПрав.Колонки.Добавить("УправлениеПравами");
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрСведений.ДескрипторыДляОбъектов КАК ДескрипторыДляОбъектов
		|ГДЕ
		|	ДескрипторыДляОбъектов.Объект = &Объект
		|	И ДескрипторыДляОбъектов.ТипДескриптора = 0");
	
	Запрос.УстановитьПараметр("Объект", СсылкаНаОбъект);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		// Если объект не использует стандартные дескрипторы, возвращается Неопределено.
		Возврат Неопределено;
	КонецЕсли;
	
	// Права по стандартным дескрипторам и дескрипторам для лок. администраторов,
	// с учетом неограниченных прав.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.Контейнер КАК Контейнер,
		|	ВложенныйЗапрос.Пользователь КАК Пользователь,
		|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.Чтение), ЛОЖЬ) КАК Чтение,
		|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.Добавление), ЛОЖЬ) КАК Добавление,
		|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.Изменение), ЛОЖЬ) КАК Изменение,
		|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.Удаление), ЛОЖЬ) КАК Удаление,
		|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.УправлениеПравами), ЛОЖЬ) КАК УправлениеПравами
		|ПОМЕСТИТЬ ПраваПользователейКонтейнеров
		|ИЗ
		|	(ВЫБРАТЬ
		|		ПользователиВКонтейнерах.Контейнер КАК Контейнер,
		|		ПользователиВКонтейнерах.Пользователь КАК Пользователь,
		|		ИСТИНА КАК Чтение,
		|		ПраваПоДескрипторамДоступаОбъектов.Добавление КАК Добавление,
		|		ПраваПоДескрипторамДоступаОбъектов.Изменение КАК Изменение,
		|		ПраваПоДескрипторамДоступаОбъектов.Удаление КАК Удаление,
		|		ПраваПоДескрипторамДоступаОбъектов.УправлениеПравами КАК УправлениеПравами
		|	ИЗ
		|		РегистрСведений.ДескрипторыДляОбъектов КАК ДескрипторыДляОбъектов
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПраваПоДескрипторамДоступаОбъектов КАК ПраваПоДескрипторамДоступаОбъектов
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиВКонтейнерах КАК ПользователиВКонтейнерах
		|				ПО (ПользователиВКонтейнерах.Пользователь = ПраваПоДескрипторамДоступаОбъектов.Пользователь)
		|			ПО ДескрипторыДляОбъектов.Дескриптор = ПраваПоДескрипторамДоступаОбъектов.Дескриптор
		|	ГДЕ
		|		ПользователиВКонтейнерах.Контейнер В(&Контейнеры)
		|		И ДескрипторыДляОбъектов.Объект = &Объект
		|		И (ДескрипторыДляОбъектов.ТипДескриптора = 0
		|				ИЛИ ДескрипторыДляОбъектов.ТипДескриптора = 4)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ПользователиВВыбранныхКонтейнерах.Контейнер,
		|		ПользователиВВыбранныхКонтейнерах.Пользователь,
		|		ПраваРолей.ЧтениеБезОграничения,
		|		ПраваРолей.ИзменениеБезОграничения,
		|		ПраваРолей.ИзменениеБезОграничения,
		|		ПраваРолей.ИзменениеБезОграничения,
		|		ЛОЖЬ
		|	ИЗ
		|		РегистрСведений.ПолномочияПользователей КАК ПолномочияПользователей
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПраваРолей КАК ПраваРолей
		|				ПО ПрофилиГруппДоступаРоли.Роль = ПраваРолей.Роль
		|			ПО ПолномочияПользователей.Полномочия = ПрофилиГруппДоступаРоли.Ссылка
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиВКонтейнерах КАК ПользователиВоВсехКонтейнерах
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиВКонтейнерах КАК ПользователиВВыбранныхКонтейнерах
		|				ПО ПользователиВоВсехКонтейнерах.Пользователь = ПользователиВВыбранныхКонтейнерах.Пользователь
		|			ПО ПолномочияПользователей.Владелец = ПользователиВоВсехКонтейнерах.Контейнер
		|	ГДЕ
		|		ПраваРолей.ЧтениеБезОграничения
		|		И ПользователиВВыбранныхКонтейнерах.Контейнер В(&Контейнеры)
		|		И ПраваРолей.ОбъектМетаданных = &Идентификатор) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Контейнер,
		|	ВложенныйЗапрос.Пользователь
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПользователиВКонтейнерах.Контейнер,
		|	МИНИМУМ(ЕСТЬNULL(ПраваПользователейКонтейнеров.Чтение, ЛОЖЬ)) КАК Чтение,
		|	МИНИМУМ(ЕСТЬNULL(ПраваПользователейКонтейнеров.Добавление, ЛОЖЬ)) КАК Добавление,
		|	МИНИМУМ(ЕСТЬNULL(ПраваПользователейКонтейнеров.Изменение, ЛОЖЬ)) КАК Изменение,
		|	МИНИМУМ(ЕСТЬNULL(ПраваПользователейКонтейнеров.Удаление, ЛОЖЬ)) КАК Удаление,
		|	МИНИМУМ(ЕСТЬNULL(ПраваПользователейКонтейнеров.УправлениеПравами, ЛОЖЬ)) КАК УправлениеПравами
		|ИЗ
		|	РегистрСведений.ПользователиВКонтейнерах КАК ПользователиВКонтейнерах
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПраваПользователейКонтейнеров КАК ПраваПользователейКонтейнеров
		|		ПО ПользователиВКонтейнерах.Контейнер = ПраваПользователейКонтейнеров.Контейнер
		|			И ПользователиВКонтейнерах.Пользователь = ПраваПользователейКонтейнеров.Пользователь
		|ГДЕ
		|	ПользователиВКонтейнерах.Контейнер В(&Контейнеры)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПользователиВКонтейнерах.Контейнер");
		
	Запрос.УстановитьПараметр("Объект", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("Контейнеры", Контейнеры);
	Запрос.УстановитьПараметр("Идентификатор", 
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(СсылкаНаОбъект.Метаданные()));
	
	ТаблицаПрав = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаПрав;
	
КонецФункции

#КонецОбласти

#КонецЕсли
