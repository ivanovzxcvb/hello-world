
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ИспользоватьСВД = ПолучитьФункциональнуюОпцию("ИспользоватьСВД");
	Если Не ИспользоватьСВД Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СпособыДоставки.Ссылка,
			|	СпособыДоставки.Наименование
			|ИЗ
			|	Справочник.СпособыДоставки КАК СпособыДоставки
			|ГДЕ
			|	СпособыДоставки.Наименование ПОДОБНО &Текст
			|	И СпособыДоставки.Наименование <> &Наименование";
		
		Запрос.УстановитьПараметр("Текст", Строка(Параметры.СтрокаПоиска) + "%");
		Запрос.УстановитьПараметр("Наименование", "СВД");
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Наименование);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
