
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", Пользователи.ТекущийПользователь());
		
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	
КонецПроцедуры

