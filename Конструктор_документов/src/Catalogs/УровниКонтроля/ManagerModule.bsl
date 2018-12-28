#Область ПрограммныйИнтерфейс

Функция УровеньКТПоУмолчанию() Экспорт 

	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Справочники.УровниКонтроля.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УровниКонтроля.Ссылка КАК Ссылка
		|ИЗ
		|	(ВЫБРАТЬ ПЕРВЫЕ 1
		|		УровниКонтроля.Ссылка КАК Ссылка,
		|		1 КАК Приоритет
		|	ИЗ
		|		Справочник.УровниКонтроля КАК УровниКонтроля
		|	ГДЕ
		|		УровниКонтроля.ПометкаУдаления = ЛОЖЬ
		|		И УровниКонтроля.Наименование = &Наименование
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ ПЕРВЫЕ 1
		|		УровниКонтроля.Ссылка,
		|		2
		|	ИЗ
		|		Справочник.УровниКонтроля КАК УровниКонтроля
		|	ГДЕ
		|		УровниКонтроля.ПометкаУдаления = ЛОЖЬ) КАК УровниКонтроля
		|
		|УПОРЯДОЧИТЬ ПО
		|	УровниКонтроля.Приоритет";
		
	Запрос.УстановитьПараметр("Наименование", "3 (Оперативный)");	
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;	

КонецФункции

#КонецОбласти