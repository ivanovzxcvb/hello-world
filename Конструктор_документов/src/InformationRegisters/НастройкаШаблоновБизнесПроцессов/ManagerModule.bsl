
#Область СлужебныеПроцедурыИФункции

Функция КоличествоВидовДокументовПоШаблону(Шаблон)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РегистрСведенийНастройкаШаблоновБизнесПроцессов.ВидДокумента
		|ИЗ
		|	РегистрСведений.НастройкаШаблоновБизнесПроцессов КАК РегистрСведенийНастройкаШаблоновБизнесПроцессов
		|ГДЕ
		|	РегистрСведенийНастройкаШаблоновБизнесПроцессов.ШаблонБизнесПроцесса = &Шаблон";
	Запрос.Параметры.Вставить("Шаблон", Шаблон);
	Возврат Запрос.Выполнить().Выбрать().Количество();
	
КонецФункции

Функция УстановитьЗаголовокКомандыОткрытияФормаСпискаДляВидаДокумента(Шаблон) Экспорт
	
	КоличествоВидовДокумента = КоличествоВидовДокументовПоШаблону(Шаблон);
	
	Если КоличествоВидовДокумента > 0 Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Назначен %1'"),
			СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
				КоличествоВидовДокумента,
				НСтр("ru = 'виду документа,видам документов,видам документов'")));
	КонецЕсли;
	
	Возврат НСтр("ru = 'Назначить видам документа'");
	
КонецФункции

#КонецОбласти