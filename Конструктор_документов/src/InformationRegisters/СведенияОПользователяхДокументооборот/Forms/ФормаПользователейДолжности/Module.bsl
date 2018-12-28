
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"Должность",
		Параметры.Должность);
		
	ПоказыватьНедействительныхПользователей = Ложь;
	
	Если ПоказыватьНедействительныхПользователей Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Пользователь.Недействителен");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор,
			"Пользователь.Недействителен",
			Ложь);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	ПоказыватьНедействительныхПользователей = Не ПоказыватьНедействительныхПользователей;
	
	Элементы.ФормаПоказыватьНедействительныхПользователей.Пометка = ПоказыватьНедействительныхПользователей;
	
	Если ПоказыватьНедействительныхПользователей Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Пользователь.Недействителен");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор,
			"Пользователь.Недействителен",
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Пользователь);
	
КонецПроцедуры
