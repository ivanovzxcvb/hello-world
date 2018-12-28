// Загружает параметры Автообновление и ПериодАвтообновления списка из настроек
// 
// Параметры:
// Форма - уникальный идентификатор открытой формы
// ИмяСписка - Строка - имя элемента формы
// 
Процедура ЗагрузитьНастройкиАвтообновленияСписка(Форма, ИмяСписка) Экспорт
	
	КлючОбъекта = Форма.ИмяФормы + ".Автообновление." + ПолучитьСкоростьКлиентскогоСоединения();
	Настройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта, ИмяСписка);
	Если ЗначениеЗаполнено(Настройки) Тогда
		Форма.Элементы[ИмяСписка].Автообновление = Настройки.Автообновление;
		Форма.Элементы[ИмяСписка].ПериодАвтоОбновления = Настройки.ПериодАвтоОбновления;
	КонецЕсли;
	
КонецПроцедуры

// Получает параметры Автообновление и ПериодАвтообновления списка из настроек
// 
// Параметры:
// Форма - уникальный идентификатор открытой формы
// ИмяСписка - Строка - имя элемента формы
// 
// Возврвщает структуру:
// - Автообновление (Булево)
// - ПериодАвтоОбновления (Число)
//
Функция ПолучитьНастройкиАвтообновленияФормы(Форма) Экспорт
	
	Результат = Новый Структура("Автообновление, ПериодАвтоОбновления", Ложь, 0);
	
	Если ТипЗнч(Форма) = Тип("Строка") Тогда
		КлючОбъекта = Форма + ".Автообновление";
	Иначе
		КлючОбъекта = Форма.ИмяФормы + ".Автообновление";
	КонецЕсли;
	
	КлючНастройки = Строка(ПолучитьСкоростьКлиентскогоСоединения());
	Настройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта, КлючНастройки);
	Если ЗначениеЗаполнено(Настройки) Тогда
		Результат.Автообновление = Настройки.Автообновление;
		Результат.ПериодАвтоОбновления = Настройки.ПериодАвтоОбновления;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Сохраняет настройки автообновления списка
//
Процедура СохранитьНастройкиАвтообновленияСписка(ИмяФормы, ИмяСписка, Настройки) Экспорт
	
	КлючОбъекта = ИмяФормы + ".Автообновление." + ПолучитьСкоростьКлиентскогоСоединения();
	ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, ИмяСписка, Настройки);
	
КонецПроцедуры

// Сохраняет настройки автообновления Формы
//
Процедура СохранитьНастройкиАвтообновленияФормы(ИмяФормы, Настройки) Экспорт
	
	КлючОбъекта = ИмяФормы + ".Автообновление";
	КлючНастройки = Строка(ПолучитьСкоростьКлиентскогоСоединения());
	ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, КлючНастройки, Настройки);
	
КонецПроцедуры