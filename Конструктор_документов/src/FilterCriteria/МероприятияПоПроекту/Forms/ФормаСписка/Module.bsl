#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Параметры списка
	Список.Параметры.УстановитьЗначениеПараметра("ЗначениеОтбора", Параметры.ЗначениеОтбора);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Мероприятия по проекту ""%1""'"),
		Параметры.ЗначениеОтбора);
	
	// Задачи
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи") Тогда 
		Элементы.Задачи.Видимость = Ложь;
	КонецЕсли;
	
	// Контроль
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Элементы.СостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
	// Категории
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных") Тогда
		Элементы.ЕстьКатегорииДанных.Видимость = Ложь;
	КонецЕсли;
	
	// Отображение удаленных
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Отображение удаленных
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.Файлы Тогда
		ПараметрыОткрытия = Новый Структура("Ключ, ОткрытьЗакладкуФайлы", ВыбраннаяСтрока, Истина);
		ОткрытьФорму("Справочник.Мероприятия.ФормаОбъекта", ПараметрыОткрытия);
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.Задачи Тогда
		ОткрытьФорму("ОбщаяФорма.ПроцессыИЗадачи",
			Новый Структура("Предмет", ВыбраннаяСтрока),
			ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ЕстьКатегорииДанных Тогда
		ПараметрыОткрытия = Новый Структура("Ключ, ОткрытьЗакладкуКатегории", ВыбраннаяСтрока, Истина);
		ОткрытьФорму("Справочник.Мероприятия.ФормаОбъекта", ПараметрыОткрытия);
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СостояниеКонтроля Тогда
		КонтрольКлиент.ОбработкаКомандыКонтроль(ВыбраннаяСтрока, ЭтаФорма);
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ", ВыбраннаяСтрока);
	ОткрытьФорму("Справочник.Мероприятия.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереключитьОтображатьУдаленные()
	
	Элементы.СписокКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленные);
	
КонецПроцедуры


#КонецОбласти