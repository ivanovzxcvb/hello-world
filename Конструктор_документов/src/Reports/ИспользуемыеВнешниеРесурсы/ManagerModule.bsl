#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Передается "как есть" из ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//       Может использоваться для получения настроек варианта этого отчета при помощи функции ВариантыОтчетов.ОписаниеВарианта().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки этого отчета,
//       уже сформированные при помощи функции ВариантыОтчетов.ОписаниеОтчета() и готовые к изменению.
//       См. "Свойства для изменения" процедуры ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь);
//
// Примеры:
//
//  1. Установка описания варианта.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Описание = НСтр("ru = '<Описание>'");
//
//  2. Отключение варианта отчета.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Ложь;
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.Описание = НСтр("ru = 'Внешние ресурсы, используемые программой и дополнительными модулями'");
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиОтчета.НастройкиДляПоиска.НаименованияПолей = 
		НСтр("ru = 'Имя и идентификатор COM-класса
		|Имя компьютера
		|Адрес
		|Чтение данных
		|Запись данных
		|Имя макета или файла компоненты
		|Контрольная сумма
		|Шаблон командной строки
		|Протокол
		|Адрес Интернет-ресурса
		|Порт'");
	НастройкиОтчета.НастройкиДляПоиска.НаименованияПараметровИОтборов = "";
КонецПроцедуры

// Возвращает словарь свойств конфигурации.
//
// Возвращаемое значение: Структура:
//                         * Именительный - синоним вида модуля в именительном падеже,
//                         * Родительный - синоним вида модуля в родительном падеже.
//
Функция СловарьМодуляКонфигурации() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Именительный", НСтр("ru = 'Программа'"));
	Результат.Вставить("Родительный", НСтр("ru = 'Программы'"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
//
Функция ПредставлениеЗапросовРазрешенийНаИспользованиеВнешнихРесурсов(Знач ОперацииАдминистрирования, Знач ОписаниеДобавляемыхРазрешений, Знач ОписаниеУдаляемыхРазрешений, Знач КакТребуемые = Ложь) Экспорт
	
	Макет = ПолучитьМакет("ПредставленияРазрешений");
	ОбластьОтступа = Макет.ПолучитьОбласть("Отступ");
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	ВсеПрограммныеМодули = Новый Соответствие();
	
	Для Каждого Описание Из ОперацииАдминистрирования Цикл
		
		Ссылка = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
			Описание.ТипПрограммногоМодуля, Описание.ИдентификаторПрограммногоМодуля);
		
		Если ВсеПрограммныеМодули.Получить(Ссылка) = Неопределено Тогда
			ВсеПрограммныеМодули.Вставить(Ссылка, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Описание Из ОписаниеДобавляемыхРазрешений Цикл
		
		Ссылка = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
			Описание.ТипПрограммногоМодуля, Описание.ИдентификаторПрограммногоМодуля);
		
		Если ВсеПрограммныеМодули.Получить(Ссылка) = Неопределено Тогда
			ВсеПрограммныеМодули.Вставить(Ссылка, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Описание Из ОписаниеУдаляемыхРазрешений Цикл
		
		Ссылка = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
			Описание.ТипПрограммногоМодуля, Описание.ИдентификаторПрограммногоМодуля);
		
		Если ВсеПрограммныеМодули.Получить(Ссылка) = Неопределено Тогда
			ВсеПрограммныеМодули.Вставить(Ссылка, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаМодулей = Новый ТаблицаЗначений();
	ТаблицаМодулей.Колонки.Добавить("ПрограммныйМодуль", ОбщегоНазначения.ОписаниеТипаВсеСсылки());
	ТаблицаМодулей.Колонки.Добавить("ЭтоКонфигурация", Новый ОписаниеТипов("Булево"));
	
	Для Каждого КлючИЗначение Из ВсеПрограммныеМодули Цикл
		Строка = ТаблицаМодулей.Добавить();
		Строка.ПрограммныйМодуль = КлючИЗначение.Ключ;
		Строка.ЭтоКонфигурация = (КлючИЗначение.Ключ = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
	КонецЦикла;
	
	ТаблицаМодулей.Сортировать("ЭтоКонфигурация УБЫВ");
	
	Для Каждого СтрокаТаблицыМодулей Из ТаблицаМодулей Цикл
		
		ТабличныйДокумент.Вывести(ОбластьОтступа);
		
		Свойства = РаботаВБезопасномРежимеСлужебный.СвойстваДляРегистраРазрешений(
			СтрокаТаблицыМодулей.ПрограммныйМодуль);
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", Свойства.Тип);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", Свойства.Идентификатор);
		
		СформироватьПредставлениеОпераций(ТабличныйДокумент, Макет, ОперацииАдминистрирования.НайтиСтроки(Отбор));
		
		ЭтоПрофильКонфигурации = (Свойства.Тип= Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
		
		Если ЭтоПрофильКонфигурации Тогда
			
			Словарь = СловарьМодуляКонфигурации();
			НаименованиеМодуля = Метаданные.Синоним;
			
		Иначе
			
			ПрограммныйМодуль = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
				Свойства.Тип, Свойства.Идентификатор);
			
			МенеджерВнешнегоМодуля = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(ПрограммныйМодуль);
			
			Словарь = МенеджерВнешнегоМодуля.СловарьКонтейнераВнешнегоМодуля();
			Пиктограмма = МенеджерВнешнегоМодуля.ПиктограммаВнешнегоМодуля(ПрограммныйМодуль);
			НаименованиеМодуля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрограммныйМодуль, "Наименование");
			
		КонецЕсли;
		
		Добавляемые = ОписаниеДобавляемыхРазрешений.Скопировать(Отбор);
		Если Добавляемые.Количество() > 0 Тогда
			
			Если КакТребуемые Тогда
				
				ТекстШапки = СтрШаблон(
					НСтр("ru = 'Для %1 ""%2"" требуется использование следующих внешних ресурсов:'"),
					НРег(Словарь.Родительный),
					НаименованиеМодуля);
				
			Иначе
				
				ТекстШапки = СтрШаблон(
					НСтр("ru = 'Для %1 ""%2"" будут предоставлены следующие разрешения на использование внешних ресурсов:'"),
					НРег(Словарь.Родительный),
					НаименованиеМодуля);
				
			КонецЕсли;
			
			Область = Макет.ПолучитьОбласть("Шапка");
			
			Область.Параметры["ТекстШапки"] = ТекстШапки;
			Если Не ЭтоПрофильКонфигурации Тогда
				
				Область.Параметры["ПрограммныйМодуль"] = ПрограммныйМодуль;
				Область.Параметры["Пиктограмма"] = Пиктограмма;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(Область);
			
			ТабличныйДокумент.НачатьГруппуСтрок(, Истина);
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
			СформироватьПредставлениеРазрешений(ТабличныйДокумент, Макет, Добавляемые, КакТребуемые);
			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
		КонецЕсли;
		
		Удаляемые = ОписаниеУдаляемыхРазрешений.Скопировать(Отбор);
		Если Удаляемые.Количество() > 0 Тогда
			
			Если КакТребуемые Тогда
				ВызватьИсключение НСтр("ru = 'Некорректный запрос разрешений'");
			КонецЕсли;
			
			ТекстШапки = СтрШаблон(
					НСтр("ru = 'Будут удалены следующие ранее предоставленные для %1 ""%2"" разрешения на использование внешних ресурсов:'"),
					НРег(Словарь.Родительный),
					НаименованиеМодуля);
			
			Область = Макет.ПолучитьОбласть("Шапка");
			
			Область.Параметры["ТекстШапки"] = ТекстШапки;
			Если Не ЭтоПрофильКонфигурации Тогда
				Область.Параметры["ПрограммныйМодуль"] = ПрограммныйМодуль;
				Область.Параметры["Пиктограмма"] = Пиктограмма;
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(Область);
			
			ТабличныйДокумент.НачатьГруппуСтрок(, Истина);
			
			СформироватьПредставлениеРазрешений(ТабличныйДокумент, Макет, Удаляемые, Ложь);
			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
		КонецЕсли;
		
		Если Добавляемые.Количество() > 0 Или Удаляемые.Количество() > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует представление операций администрирования разрешений на использование внешних ресурсов.
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент, в который будет выведено представление операций,
//  Макет - ТабличныйДокумент, полученный из макета отчета ПредставленияРазрешений,
//  ОперацииАдминистрирования - ТаблицаЗначений, см.
//                              Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ОперацииАдминистрированияВЗапросах().
//
Процедура СформироватьПредставлениеОпераций(ТабличныйДокумент, Знач Макет, Знач ОперацииАдминистрирования)
	
	Для Каждого Описание Из ОперацииАдминистрирования Цикл
		
		Если Описание.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.Удаление Тогда
			
			ЭтоПрофильКонфигурации = (Описание.ТипПрограммногоМодуля = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
			
			Если ЭтоПрофильКонфигурации Тогда
				
				Словарь = СловарьМодуляКонфигурации();
				НаименованиеМодуля = Метаданные.Синоним;
				
			Иначе
				
				ПрограммныйМодуль = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
					Описание.ТипПрограммногоМодуля, Описание.ИдентификаторПрограммногоМодуля);
				Словарь = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(ПрограммныйМодуль).СловарьКонтейнераВнешнегоМодуля();
				НаименованиеМодуля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрограммныйМодуль, "Наименование");
				
			КонецЕсли;
			
			ТекстШапки = СтрШаблон(
					НСтр("ru = 'Будет удален профиль безопасности для %1 ""%2"".'"),
					НРег(Словарь.Родительный),
					НаименованиеМодуля);
			
			Область = Макет.ПолучитьОбласть("Шапка");
			
			Область.Параметры["ТекстШапки"] = ТекстШапки;
			Если Не ЭтоПрофильКонфигурации Тогда
				Область.Параметры["ПрограммныйМодуль"] = ПрограммныйМодуль;
			КонецЕсли;
			Область.Параметры["Пиктограмма"] = БиблиотекаКартинок.Удалить;
			
			ТабличныйДокумент.Вывести(Область);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует представление разрешений.
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент - документ, в который будет выведено представление операций,
//  НаборыРазрешений - Структура - см. Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ТаблицыРазрешений(),
//  Макет - ТабличныйДокумент - документ, полученный из макета отчета ПредставленияРазрешений,
//  КакТребуемые - Булево - флаг использования в представлении терминов вида "требуются следующие ресурсы" вместо
//                          "будут предоставлены следующие ресурсы".
//
Процедура СформироватьПредставлениеРазрешений(Знач ТабличныйДокумент, Знач Макет, Знач НаборыРазрешений, Знач КакТребуемые = Ложь)
	
	ОбластьОтступа = Макет.ПолучитьОбласть("Отступ");
	
	Типы = НаборыРазрешений.Скопировать();
	Типы.Свернуть("Тип");
	Типы.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	
	ПорядокСортировки = ПорядокСортировкиТиповРазрешений();
	Для Каждого СтрокаТипа Из Типы Цикл
		СтрокаТипа.Порядок = ПорядокСортировки[СтрокаТипа.Тип];
	КонецЦикла;
	
	Типы.Сортировать("Порядок ВОЗР");
	
	Для Каждого СтрокаТипа Из Типы Цикл
		
		ТипРазрешения = СтрокаТипа.Тип;
		
		Отбор = Новый Структура();
		Отбор.Вставить("Тип", СтрокаТипа.Тип);
		СтрокиРазрешений = НаборыРазрешений.НайтиСтроки(Отбор);
		
		Количество = 0;
		Для Каждого СтрокаРазрешений Из СтрокиРазрешений Цикл
			Количество = Количество + СтрокаРазрешений.Разрешения.Количество();
		КонецЦикла;
		
		Если Количество > 0 Тогда
			
			ОбластьГруппы = Макет.ПолучитьОбласть("Группа" + ТипРазрешения);
			ЗаполнитьЗначенияСвойств(ОбластьГруппы.Параметры, Новый Структура("Количество", Количество));
			ТабличныйДокумент.Вывести(ОбластьГруппы);
			
			ТабличныйДокумент.НачатьГруппуСтрок(ТипРазрешения, Истина);
			
			ОбластьШапки = Макет.ПолучитьОбласть("Шапка" + ТипРазрешения);
			ТабличныйДокумент.Вывести(ОбластьШапки);
			
			ОбластьСтроки = Макет.ПолучитьОбласть("Строка" + ТипРазрешения);
			
			Для Каждого СтрокаРазрешений Из СтрокиРазрешений Цикл
				
				Для Каждого КлючИЗначение Из СтрокаРазрешений.Разрешения Цикл
					
					Разрешение = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(КлючИЗначение.Значение);
					
					Если ТипРазрешения = "AttachAddin" Тогда
						
						ЗаполнитьЗначенияСвойств(ОбластьСтроки.Параметры, Разрешение);
						ТабличныйДокумент.Вывести(ОбластьСтроки);
						
						ТабличныйДокумент.НачатьГруппуСтрок(Разрешение.TemplateName);
						
						ДополнениеРазрешения = СтрокаРазрешений.ДополненияРазрешений.Получить(КлючИЗначение.Ключ);
						Если ДополнениеРазрешения = Неопределено Тогда
							ДополнениеРазрешения = Новый Структура();
						Иначе
							ДополнениеРазрешения = ОбщегоНазначения.ЗначениеИзСтрокиXML(ДополнениеРазрешения);
						КонецЕсли;
						
						Для Каждого КлючИЗначениеДополнения Из ДополнениеРазрешения Цикл
							
							ОбластьСтрокиФайла = Макет.ПолучитьОбласть("СтрокаAttachAddinДополнительная");
							
							ЗаполнитьЗначенияСвойств(ОбластьСтрокиФайла.Параметры, КлючИЗначениеДополнения);
							ТабличныйДокумент.Вывести(ОбластьСтрокиФайла);
							
						КонецЦикла;
						
						ТабличныйДокумент.ЗакончитьГруппуСтрок();
						
					Иначе
						
						ДополнениеРазрешения = Новый Структура();
						
						Если ТипРазрешения = "FileSystemAccess" Тогда
							
							Если Разрешение.Path = "/temp" Тогда
								ДополнениеРазрешения.Вставить("Path", НСтр("ru = 'Каталог временных файлов'"));
							КонецЕсли;
							
							Если Разрешение.Path = "/bin" Тогда
								ДополнениеРазрешения.Вставить("Path", НСтр("ru = 'Каталог, в который установлен сервер 1С:Предприятия'"));
							КонецЕсли;
							
						КонецЕсли;
						
						ЗаполнитьЗначенияСвойств(ОбластьСтроки.Параметры, Разрешение);
						ЗаполнитьЗначенияСвойств(ОбластьСтроки.Параметры, ДополнениеРазрешения);
						
						ТабличныйДокумент.Вывести(ОбластьСтроки);
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
//
Функция ПорядокСортировкиТиповРазрешений()
	
	Результат = Новый Структура();
	
	Результат.Вставить("FileSystemAccess", 1);
	Результат.Вставить("CreateComObject", 2);
	Результат.Вставить("AttachAddin", 3);
	Результат.Вставить("ExternalModule", 4);
	Результат.Вставить("RunApplication", 5);
	Результат.Вставить("InternetResourceAccess", 6);
	Результат.Вставить("ExternalModulePrivilegedModeAllowed", 7);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#КонецОбласти

#КонецЕсли