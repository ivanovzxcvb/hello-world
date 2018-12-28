#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Отображать удаленные - при первом открытии формы нужно не отображать удаленные.
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Отображать удаленные
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоказыватьУдаленные()
	
	Параметр = Список.Параметры.НайтиЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ОтборПоказыватьУдаленные"));
	Параметр.Использование = Ложь;
	
	Элементы.ФормаПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	Если Не ПоказыватьУдаленные Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПоказыватьУдаленные", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти