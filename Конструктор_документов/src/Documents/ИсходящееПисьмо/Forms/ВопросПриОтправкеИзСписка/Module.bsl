
///////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДекорацияВопрос.Заголовок = СтрШаблон(
		НСтр("ru = 'Сейчас произойдет отправка выбранных писем (%1 шт).'"),
		Параметры.КоличествоПисем);
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отправить(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НеОтправлять(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры
