
&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	ДанныеУсловия = Новый Структура("ВидУсловия, ЗначениеУсловия", ВидУсловия, ТекстУсловия);
	Закрыть(ДанныеУсловия); 
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидУсловия = Перечисления.ВидыУсловийПравилАвтоматическойКатегоризации.КлючевыеСлова;
	Если ЗначениеЗаполнено(Параметры.ВидУсловия) И ЗначениеЗаполнено(Параметры.Выражение) Тогда
		ВидУсловия = Параметры.ВидУсловия;
		ТекстУсловия = Параметры.Выражение;
	КонецЕсли;
	
КонецПроцедуры
