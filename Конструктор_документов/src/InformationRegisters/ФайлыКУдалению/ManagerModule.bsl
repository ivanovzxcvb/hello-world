
// Делает запись о файле
//
// Параметры:
//   ПутьФайла - полный путь к временному файлу
//   Том - том
//
Процедура ЗаписатьФайл(Том, ПутьФайла, Описание) Экспорт
	
	Если Не ЗначениеЗаполнено(Том) Или Не ЗначениеЗаполнено(ПутьФайла) Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ФайлыКУдалению.ЗаписатьФайл'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			НСтр("ru = 'Не заполнен том или путь'"));
		
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ФайлыКУдалению.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Том = Том;
	МенеджерЗаписи.ПутьКФайлу = ПутьФайла;
	МенеджерЗаписи.ДатаУдаления = ТекущаяДатаСеанса();
	
	МенеджерЗаписи.Записать();
	
	ПолныйПутьНаТоме = ФайловыеФункцииСлужебный.ПолныйПутьТома(Том) + ПутьФайла;
	ОписаниеЖР = Описание + " " + ПолныйПутьНаТоме;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ФайлыКУдалению.ЗаписатьФайл'"),
		УровеньЖурналаРегистрации.Информация,,,
		ОписаниеЖР);
	
КонецПроцедуры

Процедура УдалитьСтарыеФайлы() Экспорт
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ФайлыКУдалению.УдалитьСтарыеФайлы'"),
		УровеньЖурналаРегистрации.Информация,,,
		НСтр("ru = 'Начало процедуры'"));
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФайлыКУдалению.Том,
		|	ФайлыКУдалению.ПутьКФайлу
		|ИЗ
		|	РегистрСведений.ФайлыКУдалению КАК ФайлыКУдалению
		|ГДЕ
		|	ФайлыКУдалению.ДатаУдаления < &Дата";
		  
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса() - 3600);	  // за последний час не стираем
	
	УдаленоСчетчик = 0;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		ПолныйПутьНаТоме = ФайловыеФункцииСлужебный.ПолныйПутьТома(Строка.Том) + Строка.ПутьКФайлу;
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ФайлыКУдалению.УдалитьСтарыеФайлы'"),
			УровеньЖурналаРегистрации.Информация,,,
			ПолныйПутьНаТоме);
		
		Попытка
			ФайлВременный = Новый Файл(ПолныйПутьНаТоме);	
			Если ФайлВременный.ЭтоФайл() И ФайлВременный.Существует() Тогда
				ФайлВременный.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ПолныйПутьНаТоме);
			КонецЕсли;
		Исключение
			// файла может не быть
		КонецПопытки;	
		
		// стираем запись
		МенеджерЗаписи = РегистрыСведений.ФайлыКУдалению.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ПутьКФайлу = Строка.ПутьКФайлу;
		МенеджерЗаписи.Том = Строка.Том;
		МенеджерЗаписи.Удалить();
		
		УдаленоСчетчик = УдаленоСчетчик + 1;
		
	КонецЦикла;	
	
	Описание = СтрШаблон(НСтр("ru = 'Конец процедуры. Удалено файлов: %1'"), УдаленоСчетчик);
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'ФайлыКУдалению.УдалитьСтарыеФайлы'"),
		УровеньЖурналаРегистрации.Информация,,,
		Описание);
	
КонецПроцедуры	
