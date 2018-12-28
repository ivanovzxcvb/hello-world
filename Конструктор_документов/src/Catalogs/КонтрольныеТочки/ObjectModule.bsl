#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = Описание;
	
	// Определяем и сохраняем числовой код, для использования его при создании 
	// новых контрольных точек
	СтрокаЧисел = "0123456789";
	Для Индекс = 1 По СтрДлина(КодКТ) Цикл
		СимволПоиска = Сред(КодКТ, Индекс, 1);
		Если СтрНайти(СтрокаЧисел, СимволПоиска) <> 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПодстрокаКодаКТ = Сред(КодКТ, Индекс);
	Если Не ПустаяСтрока(ПодстрокаКодаКТ) Тогда
		ЧисловойКод = Число(ПодстрокаКодаКТ);
	Иначе	
		ЧисловойКод = 0;
	КонецЕСли;
	
	Если Создал.Пустая() Тогда
		Создал = Пользователи.ТекущийПользователь();
		ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	
	// Проверяем группу
	Если ГруппаКТ = Справочники.ГруппыКонтрольныхТочек.Все 
		ИЛИ ГруппаКТ = Справочники.ГруппыКонтрольныхТочек.НеВГруппе Тогда
		
		ГруппаКТ = Справочники.ГруппыКонтрольныхТочек.ПустаяСсылка();
		
	КонецЕсли;	
	
	СтарыеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ОбъектКТ, ГруппаКТ, ПометкаУдаления"); 
	ДополнительныеСвойства.Вставить("СтарыйОбъектКТ", СтарыеРеквизиты.ОбъектКТ);
	ДополнительныеСвойства.Вставить("СтараяГруппаКТ", СтарыеРеквизиты.ГруппаКТ);
	ДополнительныеСвойства.Вставить("ПометкаУдаления", СтарыеРеквизиты.ПометкаУдаления);
	
	Если (Исполнено = Истина И Не ЗначениеЗаполнено(Проверяющий)) ИЛИ Проверено = Истина Тогда
		Пройдена = Истина;
	КонецЕсли;
	
	Если Исполнено = Ложь ИЛИ (ЗначениеЗаполнено(Проверяющий) И Проверено = Ложь) Тогда
		Пройдена = Ложь;
	КонецЕсли;	
	
	Если Исполнено = Ложь И Проверено = Истина Тогда
		Проверено = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ПометкаУдаления <> ПометкаУдаления Тогда
		РегистрыСведений.ЧислоКТВКонтейнерах.ОбновитьЧислоКТПоГруппе(ГруппаКТ);
	КонецЕсли;	
	
	Если ДополнительныеСвойства.СтараяГруппаКТ <> ГруппаКТ Тогда
		РегистрыСведений.ЧислоКТВКонтейнерах.ОбновитьЧислоКТПоГруппе(ГруппаКТ);
		Если ЗначениеЗаполнено(ДополнительныеСвойства.СтараяГруппаКТ) Тогда
			РегистрыСведений.ЧислоКТВКонтейнерах.ОбновитьЧислоКТПоГруппе(ДополнительныеСвойства.СтараяГруппаКТ);	
		КонецЕсли;	
	КонецЕсли;
	
	Если ДополнительныеСвойства.СтарыйОбъектКТ <> ОбъектКТ 
		ИЛИ ДополнительныеСвойства.ПометкаУдаления <> ПометкаУдаления Тогда
		РегистрыСведений.ЧислоКТВКонтейнерах.ОбновитьЧислоКТПоОбъекту(ОбъектКТ);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Проверяющий = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

