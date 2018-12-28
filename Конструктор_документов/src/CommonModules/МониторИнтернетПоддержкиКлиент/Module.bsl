
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Монитор Интернет-поддержки".
// ОбщийМодуль.МониторИнтернетПоддержкиКлиент.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает монитор Интернет-поддержки.
//
// Параметры:
//	СтартовыеПараметры - Структура, Неопределено - дополнительные параметры
//		открытия монитора Интернет-поддержки;
//
Процедура ОткрытьМониторИнтернетПоддержки(СтартовыеПараметры = Неопределено) Экспорт
	
	МестоЗапуска = "handStartNew";
	
	// Выполнение сценария Интернет-поддержки.
	ИнтернетПоддержкаПользователейКлиент.ВыполнитьСценарий(МестоЗапуска, СтартовыеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Общего назначения

// Вызывается при начале работы системы из
// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы().
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыИПП = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ИнтернетПоддержкаПользователей;
	ИнтернетПоддержкаПользователейКлиент.ВыполнитьСценарий(
		"systemStartNew",
		,
		,
		Новый Структура("КонтекстВзаимодействия", ПараметрыИПП.МониторИнтернетПоддержки));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики бизнес-процессов

// Вызывается при формировании параметров открытия формы бизнес-процесса,
// передаваемых в метода ПолучитьФорму().
// Вызывается из ИнтернетПоддержкаПользователейКлиент.СформироватьПараметрыОткрытияФормы().
//
// Параметры:
//	КСКонтекст - см. функцию
//		ИнтернетПоддержкаПользователейВызовСервера.НовыйКонтекстВзаимодействия()
//	ИмяОткрываемойФормы - Строка - полное имя открываемой формы;
//	Параметры - Структура - заполняемые параметры открытия формы.
//
Процедура ПараметрыОткрытияФормы(КСКонтекст, ИмяОткрываемойФормы, Параметры) Экспорт
	
	Если ИмяОткрываемойФормы = "Обработка.МониторИнтернетПоддержки.Форма.Монитор" Тогда
		Параметры.Вставить("ХэшИнформацииМонитора", КСКонтекст.ХэшИнформацииМонитора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти