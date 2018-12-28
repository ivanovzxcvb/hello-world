////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполнить завершение текущего сеанса, если установлена блокировка соединений 
// с информационной базой.
//
Процедура КонтрольРежимаЗавершенияРаботыПользователей() Экспорт

	// Получим текущее значение параметров блокировки.
	ТекущийРежим = СоединенияИБВызовСервера.ПараметрыБлокировкиСеансов();
	БлокировкаУстановлена = ТекущийРежим.Установлена;
	
	Если Не БлокировкаУстановлена Тогда
		Возврат;
	КонецЕсли;
		
	ВремяНачалаБлокировки = ТекущийРежим.Начало;
	ВремяОкончанияБлокировки = ТекущийРежим.Конец;
	
	// ИнтервалЗакрытьСЗапросом и ИнтервалПрекратить имеют отрицательное значение,
	// поэтому, когда идет сравнение этих параметров с разницей (ВремяНачалаБлокировки - ТекущийМомент),
	// то используется "<=", так как данная разница постоянно уменьшается.
	ИнтервалПредупреждения    = ТекущийРежим.ИнтервалОжиданияЗавершенияРаботыПользователей;
	ИнтервалЗакрытьСЗапросом = ИнтервалПредупреждения / 3;
	ИнтервалПрекратитьВМоделиСервиса = 60; // За минуту до начала блокировки.
	ИнтервалПрекратить        = 0; // В момент установки блокировки.
	ТекущийМомент             = ТекущийРежим.ТекущаяДатаСеанса;
	
	Если ВремяОкончанияБлокировки <> '00010101' И ТекущийМомент > ВремяОкончанияБлокировки Тогда
		Возврат;
	КонецЕсли;
	
	ДатаВремениНачалаБлокировки  = Формат(ВремяНачалаБлокировки, "ДЛФ=DD");
	ВремяВремениНачалаБлокировки = Формат(ВремяНачалаБлокировки, "ДЛФ=T");
	
	ТекстСообщения = СоединенияИБКлиентСервер.ИзвлечьСообщениеБлокировки(ТекущийРежим.Сообщение);
	Шаблон = НСтр("ru = 'Рекомендуется завершить текущую работу и сохранить все свои данные. Работа программы будет завершена %1 в %2. 
		|%3'");
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДатаВремениНачалаБлокировки, ВремяВремениНачалаБлокировки, ТекстСообщения);
	
	РазделениеВключено = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено;
	Если Не РазделениеВключено
		И (Не ЗначениеЗаполнено(ВремяНачалаБлокировки) Или ВремяНачалаБлокировки - ТекущийМомент < ИнтервалПрекратить) Тогда
		
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Ложь, ТекущийРежим.ПерезапуститьПриЗавершении);
		
	ИначеЕсли РазделениеВключено
		И (Не ЗначениеЗаполнено(ВремяНачалаБлокировки) Или ВремяНачалаБлокировки - ТекущийМомент < ИнтервалПрекратитьВМоделиСервиса) Тогда
		
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Ложь, Ложь);
		
	ИначеЕсли ВремяНачалаБлокировки - ТекущийМомент <= ИнтервалЗакрытьСЗапросом Тогда
		
		СоединенияИБКлиент.ЗадатьВопросПриЗавершенииРаботы(ТекстСообщения);
		
	ИначеЕсли ВремяНачалаБлокировки - ТекущийМомент <= ИнтервалПредупреждения Тогда
		
		ПоказатьПредупреждение(, ТекстСообщения, 30);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполнить завершение активных сеансов, если превышено время ожидания, а затем
// завершить текущий сеанс.
//
Процедура ЗавершитьРаботуПользователей() Экспорт

	// Получим текущее значение параметров блокировки.
	ТекущийРежим = СоединенияИБВызовСервера.ПараметрыБлокировкиСеансов(Истина);
	
	ВремяНачалаБлокировки = ТекущийРежим.Начало;
	ВремяОкончанияБлокировки = ТекущийРежим.Конец;
	ТекущийМомент = ТекущийРежим.ТекущаяДатаСеанса;
	
	Если ТекущийМомент < ВремяНачалаБлокировки Тогда
		ТекстСообщения = НСтр("ru = 'Блокировка работы пользователей запланирована на %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВремяНачалаБлокировки);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Завершение работы пользователей'"), 
			"e1cib/app/Обработка.БлокировкаРаботыПользователей", 
			ТекстСообщения, БиблиотекаКартинок.Информация32);
		Возврат;
	КонецЕсли;
		
	КоличествоСеансов = ТекущийРежим.КоличествоСеансов;
	Если КоличествоСеансов <= 1 Тогда
		// Отключены все пользователи, кроме текущего сеанса.
		// В последнюю очередь предлагаем завершить сеанс, запущенный с параметром "ЗавершитьРаботуПользователей".
		// Такой порядок отключений необходим для обновления конфигурации с помощью пакетного файла.
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Ложь);
		Оповестить("ЗавершениеРаботыПользователей", Новый Структура("Статус, КоличествоСеансов", "Готово", КоличествоСеансов));
		СоединенияИБКлиент.ЗавершитьРаботуЭтогоСеанса();
		Возврат;
	КонецЕсли; 
	
	БлокировкаУстановлена = ТекущийРежим.Установлена;
	Если Не БлокировкаУстановлена Тогда
		Возврат;
	КонецЕсли;
	
	// После начала блокировки сеансы всех пользователей должны быть отключены
	// если этого не произошло пробуем принудительно прервать соединения.
	ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
	
	Попытка
		ПараметрыАдминистрирования = СоединенияИБКлиент.СохраненныеПараметрыАдминистрирования();
		СоединенияИБКлиентСервер.УдалитьВсеСеансыКромеТекущего(ПараметрыАдминистрирования);
		СоединенияИБКлиент.СохранитьПараметрыАдминистрирования(Неопределено);
	Исключение
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Ложь);
			ПоказатьОповещениеПользователя(НСтр("ru = 'Завершение работы пользователей'"),
			"e1cib/app/Обработка.БлокировкаРаботыПользователей", 
			НСтр("ru = 'Завершение сеансов не выполнено. Подробности см. в Журнале регистрации.'"), БиблиотекаКартинок.Предупреждение32);
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(),
			"Ошибка", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),, Истина);
		Оповестить("ЗавершениеРаботыПользователей", Новый Структура("Статус,КоличествоСеансов", "Ошибка", КоличествоСеансов));
		Возврат;
	КонецПопытки;
	
	СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Ложь);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Завершение работы пользователей'"),
		"e1cib/app/Обработка.БлокировкаРаботыПользователей", 
		НСтр("ru = 'Завершение сеансов выполнено успешно'"), БиблиотекаКартинок.Информация32);
	Оповестить("ЗавершениеРаботыПользователей", Новый Структура("Статус,КоличествоСеансов", "Готово", КоличествоСеансов));
	СоединенияИБКлиент.ЗавершитьРаботуЭтогоСеанса();
	
КонецПроцедуры

#КонецОбласти
