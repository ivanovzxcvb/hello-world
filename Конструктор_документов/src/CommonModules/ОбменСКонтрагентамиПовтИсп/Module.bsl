////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиПовтИсп: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет массив актуальными видами электронных документов.
//
// Возвращаемое значение:
//  Массив - виды актуальных ЭД.
//
Функция ПолучитьАктуальныеВидыЭД() Экспорт
	
	МассивЭД = Новый Массив;
	ОбменСКонтрагентамиПереопределяемый.ПолучитьАктуальныеВидыЭД(МассивЭД);
	
	Если ЗначениеЗаполнено(МассивЭД) Тогда
		МассивЭД.Добавить(Перечисления.ВидыЭД.Подтверждение);
		МассивЭД.Добавить(Перечисления.ВидыЭД.ИзвещениеОПолучении);
		МассивЭД.Добавить(Перечисления.ВидыЭД.УведомлениеОбУточнении);
		МассивЭД.Добавить(Перечисления.ВидыЭД.ПредложениеОбАннулировании);
	КонецЕсли;
	
	МассивЭД.Добавить(Перечисления.ВидыЭД.ПроизвольныйЭД);
	
	МассивВозврата = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивЭД);
	
	Возврат МассивВозврата;
	
КонецФункции

// Возвращает пустую ссылку на справочник.
//
// Параметры:
//  ИмяСправочника - Строка - название справочника.
//
// Возвращаемое значение:
//  Ссылка - пустая ссылка на справочник.
//
Функция ПолучитьПустуюСсылку(ИмяСправочника) Экспорт
	
	Результат = Неопределено;
	
	ИмяПрикладногоСправочника = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ИмяСправочника);
	Если ЗначениеЗаполнено(ИмяПрикладногоСправочника) Тогда
		Результат = Справочники[ИмяПрикладногоСправочника].ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает значение перечисления по имени объектов метаданных.
// 
// Параметры:
//  ИмяПеречисления - Строка - наименование перечисления.
//  ПредставлениеПеречисления - Строка - наименование значения перечисления.
//
// Возвращаемое значение:
//  ПеречислениеСсылка - значение искомого перечисления.
//
Функция НайтиПеречисление(Знач ИмяПеречисления, ПредставлениеПеречисления) Экспорт
	
	НайденноеЗначение = Неопределено;
	
	СоответствиеПеречислений = Новый Соответствие;
	ОбменСКонтрагентамиПереопределяемый.ПолучитьСоответствиеПеречислений(СоответствиеПеречислений);
	
	ИмяПрикладногоПеречисления = СоответствиеПеречислений.Получить(ИмяПеречисления);
	Если ИмяПрикладногоПеречисления = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В коде прикладного решения необходимо указать соответствие для перечисления %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяПеречисления);
		ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(ТекстСообщения,
			2, УровеньЖурналаРегистрации.Предупреждение);
	ИначеЕсли ЗначениеЗаполнено(ИмяПрикладногоПеречисления) Тогда // задано какое-то значение
		ОбменСКонтрагентамиПереопределяемый.ПолучитьЗначениеПеречисления(
			ИмяПрикладногоПеречисления, ПредставлениеПеречисления, НайденноеЗначение);
		Если НайденноеЗначение = Неопределено Тогда
			Для Каждого ЭлПеречисления Из Метаданные.Перечисления[ИмяПрикладногоПеречисления].ЗначенияПеречисления Цикл
				Если ВРег(ЭлПеречисления.Синоним) = ВРег(ПредставлениеПеречисления)
					ИЛИ ВРег(ЭлПеречисления.Имя) = ВРег(ПредставлениеПеречисления) Тогда
					НайденноеЗначение = Перечисления[ИмяПрикладногоПеречисления][ЭлПеречисления.Имя];
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НайденноеЗначение;
	
КонецФункции

// Возвращает описание параметра для прикладного решения.
//
// Параметры:
//  Источник - Ссылка - ссылка, к которой относится параметр.
//  Параметр - Строка - наименование реквизита.
//
// Возвращаемое значение:
//  Результат - Строка - пользовательское описание реквизита.
//
Функция ПолучитьПользовательскоеПредставление(Источник, Параметр) Экспорт
	
	Результат = Параметр;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипИсточника", ТипЗнч(Источник));
	ПараметрыОтбора.Вставить("Параметр", Параметр);
	
	ТаблицаЗначений = ПользовательскоеПредставлениеПараметров();
	
	НайденныеСтроки = ТаблицаЗначений.НайтиСтроки(ПараметрыОтбора);
	Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
		
		ПользовательскоеПредставление = НайденныеСтроки[0].Представление;
		Если ЗначениеЗаполнено(ПользовательскоеПредставление) Тогда
			Результат = ПользовательскоеПредставление;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает признак использования справочника Партнеров в качестве
// дополнительной аналитики к справочнику Контрагенты.
//
// Возвращаемое значение:
//  ИспользуетсяСправочникПартнеры - Булево - флаг использования в библиотеке справочника Партнеры.
//
Функция ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры() Экспорт

	ИспользуетсяСправочникПартнеры = Ложь;
	ОбменСКонтрагентамиПереопределяемый.ДополнительнаяАналитикаКонтрагентовСправочникПартнеры(ИспользуетсяСправочникПартнеры);
	
	Возврат ИспользуетсяСправочникПартнеры;
	
КонецФункции

// Функция возвращает признак использования справочника "Характеристики номенклатуры" в качестве
// дополнительной аналитики к справочнику Номенклатура.
//
// Возвращаемое значение:
//  Булево - флаг использования в библиотеке справочника "Характеристики номенклатуры".
//
Функция ДополнительнаяАналитикаСправочникХарактеристикиНоменклатуры() Экспорт

	ИспользуетсяСправочникХарактеристикиНоменклатуры = Ложь;
	ОбменСКонтрагентамиПереопределяемый.ДополнительнаяАналитикаСправочникХарактеристикиНоменклатуры(ИспользуетсяСправочникХарактеристикиНоменклатуры);
	
	Возврат ИспользуетсяСправочникХарактеристикиНоменклатуры;
	
КонецФункции

// Функция возвращает признак использования справочника "Упаковки номенклатуры" в качестве
// дополнительной аналитики к справочнику Номенклатура.
//
// Возвращаемое значение:
//  Булево - флаг использования в библиотеке справочника "Упаковки номенклатуры".
//
Функция ДополнительнаяАналитикаСправочникУпаковкиНоменклатуры() Экспорт

	ИспользуетсяСправочникУпаковкиНоменклатуры = Ложь;
	ОбменСКонтрагентамиПереопределяемый.ДополнительнаяАналитикаСправочникУпаковкиНоменклатуры(ИспользуетсяСправочникУпаковкиНоменклатуры);
	
	Возврат ИспользуетсяСправочникУпаковкиНоменклатуры;
	
КонецФункции

// Сопоставление имен полей адреса ФНС в CML.
//
// Параметры:
//  ИмяПоля	- Строка - наименование поля адреса, например "Индекс".
//  CMLвФНС	- Булево - возвращать в формате ФНС.
// 
// Возвращаемое значение:
//  Строка - наименование поля.
//
Функция СопоставлениеИменПолейАдресаФНС_CML(ИмяПоля, CMLвФНС = Истина) Экспорт
	
	СопоставленноеИмя = ИмяПоля;
	ТЗСопоставления = ТЗСопоставленияПолейАдресаФНС_CML();
	СтрокаТЗ = ТЗСопоставления.Найти(ИмяПоля, ?(CMLвФНС, "ПредставлениеCML", "ПредставлениеФНС"));
	Если СтрокаТЗ <> Неопределено Тогда
		СопоставленноеИмя = СтрокаТЗ[?(CMLвФНС, "ПредставлениеФНС", "ПредставлениеCML")];
	КонецЕсли;
	
	Возврат СопоставленноеИмя;
	
КонецФункции

// Функция возвращает соответствующее переданному параметру значение ставки НДС.
// Если в функцию передан параметр ПредставлениеБЭД, то функция вернет ПрикладноеЗначение ставки НДС и наоборот.
//
// Параметры:
//   ПредставлениеБЭД - Строка - строковое представление ставки НДС.
//   ПрикладноеЗначение - ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - прикладное представление
//     соответствующего значения ставки НДС.
//
// Возвращаемое значение:
//   Строка, ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - соответствующее представление ставки НДС.
//
Функция СтавкаНДСИзСоответствия(ПредставлениеБЭД = "", ПрикладноеЗначение = Неопределено) Экспорт
	
	Соответствие = Новый Соответствие;
	ОбменСКонтрагентамиПереопределяемый.ЗаполнитьСоответствиеСтавокНДС(Соответствие);
	Значение = Неопределено;
	Если ЗначениеЗаполнено(ПредставлениеБЭД) Тогда
		Значение = Соответствие.Получить(ПредставлениеБЭД);
	Иначе
		Для Каждого КлючИЗначение Из Соответствие Цикл
			Если КлючИЗначение.Значение = ПрикладноеЗначение Тогда
				Значение = КлючИЗначение.Ключ;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Функция возвращает соответствующее переданному параметру значение ставки НДС.
//
// Параметры:
//   СтавкаНДС - ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - прикладное представление
//               соответствующего значения ставки НДС.
//
// Возвращаемое значение:
//   Строка, ПеречислениеСсылка.СтавкиНДС, СправочникСсылка.СтавкиНДС - соответствующее представление ставки НДС.
//
Функция СтавкаНДСПеречисление(СтавкаНДС) Экспорт
	
	Соответствие = Новый Соответствие;
	ОбменСКонтрагентамиПереопределяемый.ЗаполнитьСоответствиеСтавокНДС(Соответствие);
	
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Если КлючИЗначение.Значение = СтавкаНДС Тогда
			Значение = КлючИЗначение.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Значение = "0" Или Значение = "10" Или Значение = "18" Тогда
		Значение = Значение + "%";
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Функция преобразует строковое представление ставки НДС (внутреннее представление БЭД) в числовое.
//
// Параметры:
//   СтрокаСтавкаНДС - Строка - строковое представление ставки НДС.
//
// Возвращаемое значение:
//   Число - числовое представление ставки НДС.
//
Функция СтавкаНДСЧислом(СтрокаСтавкаНДС) Экспорт
	
	СтавкаНДС = СтрЗаменить(СтрокаСтавкаНДС, "\", "/");
	ПозицияСимвола = СтрНайти(СтавкаНДС, "/");
	Если ПозицияСимвола > 0 Тогда
		СтавкаЧислом = Окр(Вычислить(СтавкаНДС) * 100, 4);
	Иначе
		СтавкаЧислом = Число(СтавкаНДС);
	КонецЕсли;
	
	Возврат СтавкаЧислом;
	
КонецФункции

// Функция преобразует из представления ставки НДС в значение перечисления.
//
// Параметры:
//  ПредставлениеСтавкиНДС - Число, Строка - представление ставки НДС;
//
// Возвращаемое значение:
//   ПеречислениеСсылка, СправочникСсылка, Неопределено - значение ставки НДС прикладного решения.
//
Функция СтавкаНДСИзПредставления(ПредставлениеСтавкиНДС) Экспорт
	
	ЗначениеНДС = Неопределено;
	
	Если ТипЗнч(ПредставлениеСтавкиНДС) = Тип("Строка") Тогда
		СтрСтавкаНДС = СокрЛП(ПредставлениеСтавкиНДС);
	ИначеЕсли ТипЗнч(ПредставлениеСтавкиНДС) = Тип("Число") Тогда
		СтрСтавкаНДС = Строка(ПредставлениеСтавкиНДС);
	Иначе // неправильный тип
		СтрСтавкаНДС = Неопределено;
	КонецЕсли;
	
	Если СтрСтавкаНДС = Неопределено ИЛИ СтрНайти(НСтр("ru ='БЕЗ НДС'"), ВРег(СтрСтавкаНДС)) > 0 Тогда
		ЗначениеНДС = НСтр("ru ='без НДС'");
	Иначе
		СтрСтавкаНДС = СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрСтавкаНДС, ",", "."), "\", "/"), " ", ""), "%", "");
		// # - разделитель представлений ставок.
		Если СтрНайти("0", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "0";
		ИначеЕсли СтрНайти("10#0.1#0.10", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "10";
		ИначеЕсли СтрНайти("18#0.18", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "18";
		ИначеЕсли СтрНайти("20#0.2#0.20", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "20";
		ИначеЕсли СтрНайти("10/110#0.0909#9.0909", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "10/110";
		ИначеЕсли СтрНайти("18/118#0.1525#15.2542", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "18/118";
		ИначеЕсли СтрНайти("20/120#0.1667#16.6667", СтрСтавкаНДС) > 0 Тогда
			ЗначениеНДС = "20/120";
		КонецЕсли;
	КонецЕсли;
	
	СтавкаНДС = СтавкаНДСИзСоответствия(ЗначениеНДС);
	
	Возврат СтавкаНДС;
	
КонецФункции

// Возвращает КНД, соответствующий переданному в параметре Виду ЭД.
//
// Параметры:
//  ВидЭД - ПеречислениеСсылка.ВидыЭД - вид электронного документа.
//
// Возвращаемое значение:
//  Строка, Неопределено - соответствующий переданному виду ЭД КНД, Неопределено, если для переданного 
//                         вида ЭД не указано соответствие КНД.
//
Функция КНДПоВидуЭД(ВидЭД) Экспорт
	
	СоответствиеВидаЭДиКНД = Новый Соответствие;
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ВидыЭД.СчетФактура,                 "1115101");
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ВидыЭД.КорректировочныйСчетФактура, "1115108");
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ВидыЭД.ТОРГ12Продавец,              "1175004");
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ВидыЭД.ТОРГ12Покупатель,            "1175005");
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ВидыЭД.АктИсполнитель,              "1175006");
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ВидыЭД.АктЗаказчик,                 "1175007");
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ТипыЭлементовВерсииЭД.ТОРГ12Покупатель,            "1175005");
	СоответствиеВидаЭДиКНД.Вставить(Перечисления.ТипыЭлементовВерсииЭД.АктЗаказчик,                 "1175007");
	
	Возврат СоответствиеВидаЭДиКНД.Получить(ВидЭД);
	
КонецФункции

// Возвращает представление документа ИБ для вида электронного документа.
//
// Параметры:
//  ВидЭД - перечисление - вид электронного документа.
//
// Возвращаемое значение:
//  ПредставлениеОснования - строковое имя документа информационной базы, на основании которого формируется исходящий ЭД.
//
Функция ПредставлениеОснованияДляВидаЭД(ВидЭД) Экспорт
	
	МассивЭД = Новый Массив;
	ОбменСКонтрагентамиПереопределяемый.ПолучитьАктуальныеВидыЭД(МассивЭД);
	
	СоответствиеВидовЭДДокументамИБ = Новый Соответствие;
	Для каждого ЭлементВидЭД Из МассивЭД Цикл
		Если ЭлементВидЭД <> Перечисления.ВидыЭД.ТОРГ12Покупатель
			И ЭлементВидЭД <> Перечисления.ВидыЭД.АктЗаказчик
			И ЭлементВидЭД <> Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиПолучатель
			И ЭлементВидЭД <> Перечисления.ВидыЭД.ПередачаТоваровМеждуОрганизациями
			И ЭлементВидЭД <> Перечисления.ВидыЭД.ВозвратТоваровМеждуОрганизациями
			И ЭлементВидЭД <> Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
		
			СоответствиеВидовЭДДокументамИБ.Вставить(ЭлементВидЭД, "");
		КонецЕсли;
	КонецЦикла;
	
	ОбменСКонтрагентамиПереопределяемый.СоответствиеИсходящихВидовЭДДокументамИБ(СоответствиеВидовЭДДокументамИБ);
	
	// Электронное взаимодействие
	СоответствиеВидовЭДДокументамИБ.Вставить(Перечисления.ВидыЭД.ПроизвольныйЭД, НСтр("ru = 'Исходящий произвольный документ'"));
	
	ПредставлениеОснования = СоответствиеВидовЭДДокументамИБ.Получить(ВидЭД);
	Если ПредставлениеОснования = Неопределено Тогда // не задано соответствие
		ШаблонСообщения = НСтр("ru = 'В переопределяемом модуле прикладного решения необходимо указать представление документаИБ(основания) и хоз. операции для вида ЭД %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ВидЭД);
		ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(ТекстСообщения, 0, УровеньЖурналаРегистрации.Предупреждение);
	КонецЕсли;
	
	Возврат ПредставлениеОснования;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает таблицу соответствий параметров для типов метаданных их пользовательским представлениям.
//
// Параметры:
//  ТаблицаСоответствия - таблица - соответствие параметров для типов метаданных их пользовательским представлениям.
//
Функция ПользовательскоеПредставлениеПараметров()
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ТипИсточника");
	ТаблицаЗначений.Колонки.Добавить("Параметр");
	ТаблицаЗначений.Колонки.Добавить("Представление");
	
	ОбменСКонтрагентамиПереопределяемый.ПолучитьТаблицуСоответствияПараметровПользовательскимПредставлениям(
		ТаблицаЗначений);
	
	Возврат ТаблицаЗначений;
	
КонецФункции

Функция ТЗСопоставленияПолейАдресаФНС_CML()
	
	ТЗ = Новый ТаблицаЗначений;
	
	ТЗ.Колонки.Добавить("ПредставлениеФНС");
	ТЗ.Колонки.Добавить("ПредставлениеCML");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Индекс";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Почтовый индекс'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "КодРегион";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Регион'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "НаселПункт";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Населенный пункт'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Город";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Город'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Улица";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Улица'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Дом";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Дом'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Корпус";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Корпус'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "Кварт";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Квартира'");
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.ПредставлениеФНС = "КодСтр";
	НоваяСтрока.ПредставлениеCML = НСтр("ru = 'Страна'");
	
	Возврат ТЗ;
	
КонецФункции

#КонецОбласти
