////////////////////////////////////////////////////////////////////////////////
// Подсистема "Мониторинг процессов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Восстанавливает набор показателей по умолчанию для текущего пользователя,
// при этом удаляя все существующие показатели.
//
Процедура ВосстановитьПоказателиПоУмолчанию() Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ПоказателиПроцессов");
		ЭлементБлокировки.УстановитьЗначение("Автор", ТекущийПользователь);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		// Удаляем старые показатели.
		Отбор = Справочники.ПоказателиПроцессов.ОтборПоказателейПроцессов();
		Отбор.Автор = ТекущийПользователь;
		ПоказателиПроцессов = Справочники.ПоказателиПроцессов.ПолучитьПоказателиПроцессов(Отбор);
		Для Каждого ПоказательПроцесса Из ПоказателиПроцессов Цикл
			РегистрыСведений.ПодпискиНаПоказателиПроцессов.Удалить(
				ПоказательПроцесса.Ссылка,
				ТекущийПользователь);
			ПоказательПроцессаОбъект = ПоказательПроцесса.Ссылка.ПолучитьОбъект();
			ПоказательПроцессаОбъект.УстановитьПометкуУдаления(Истина);
		КонецЦикла;
		
		// Создаем новые показатели.
		МониторингПроцессов.УстановитьПерсональнуюНастройку(
			"ДатаНастройкиПоказателейПоУмолчанию",
			Дата(1,1,1));
		МониторингПроцессов.ОбновитьПоказателиПоУмолчанию();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Создает библиотечный показатель.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//  НаборВариантовОтбора - Массив - Набор вариант отбора показателя.
//
// Возвращаемое значение:
//  СправочникСсылка.ПоказателиПроцессов - Ссылка на созданный показатель.
//
Функция ДобавитьБиблиотечныйПоказатель(ВариантРасчета, НаборВариантовОтбора) Экспорт
	
	Возврат Справочники.ПоказателиПроцессов.ДобавитьБиблиотечныйПоказатель(
		ВариантРасчета,
		НаборВариантовОтбора);
	
КонецФункции

// Выполняет пересчет показателей.
//
// Параметры:
//  ПоказателиПроцессов - Массив - Показатели процессов.
//  ДатаПересчета - Дата - Дата до которой следует выполнить пересчет.
//  УдалитьСтарыеЗначения - Булево - Очистить ранее рассчитанные значения показателя.
//
Процедура ПересчитатьПоказатели(ПоказателиПроцессов, ДатаПересчета, УдалитьСтарыеЗначения) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого ПоказательПроцесса Из ПоказателиПроцессов Цикл
			ПересчитатьПоказатель(ПоказательПроцесса, ДатаПересчета, УдалитьСтарыеЗначения);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Изменяет подписку на переданные показатели.
//
// Параметры:
//  ПоказателиПроцессов - Массив - Показатели процессов.
//
Функция Отслеживать(ПоказателиПроцессов) Экспорт
	
	КоличествоОбработанныхЭлементов = 0;
	ОбработанныйЭлемент = Неопределено;
	УстановленоОтслеживание = Ложь;
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПодпискиНаПоказателиПроцессов.ПоказательПроцесса КАК ПоказательПроцесса
			|ИЗ
			|	РегистрСведений.ПодпискиНаПоказателиПроцессов КАК ПодпискиНаПоказателиПроцессов
			|ГДЕ
			|	ПодпискиНаПоказателиПроцессов.ПоказательПроцесса В(&ПоказателиПроцессов)
			|	И ПодпискиНаПоказателиПроцессов.Пользователь = &Пользователь";
		
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
		Запрос.УстановитьПараметр("ПоказателиПроцессов", ПоказателиПроцессов);
		
		ОтслеживаемыеПоказатели = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПоказательПроцесса");
		НеОтслеживаемыеПоказатели = Новый Массив;
		Для Каждого Показатель Из ПоказателиПроцессов Цикл
			Если ОтслеживаемыеПоказатели.Найти(Показатель) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НеОтслеживаемыеПоказатели.Добавить(Показатель);
		КонецЦикла;
		
		Если НеОтслеживаемыеПоказатели.Количество() <> 0 Тогда
			УстановленоОтслеживание = Истина;
			Для Каждого Показатель Из НеОтслеживаемыеПоказатели Цикл
				РегистрыСведений.ПодпискиНаПоказателиПроцессов.Добавить(Показатель, Пользователь);
				КоличествоОбработанныхЭлементов = КоличествоОбработанныхЭлементов + 1;
				ОбработанныйЭлемент = Показатель;
			КонецЦикла;
		Иначе
			УстановленоОтслеживание = Ложь;
			Для Каждого Показатель Из ОтслеживаемыеПоказатели Цикл
				РегистрыСведений.ПодпискиНаПоказателиПроцессов.Удалить(Показатель, Пользователь);
				КоличествоОбработанныхЭлементов = КоличествоОбработанныхЭлементов + 1;
				ОбработанныйЭлемент = Показатель;
			КонецЦикла;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если КоличествоОбработанныхЭлементов <> 1 Тогда
		ОбработанныйЭлемент = Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КоличествоОбработанныхЭлементов", КоличествоОбработанныхЭлементов);
	Результат.Вставить("ОбработанныйЭлемент", ОбработанныйЭлемент);
	Результат.Вставить("УстановленоОтслеживание", УстановленоОтслеживание);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет пересчет показателя.
//
// Параметры:
//  ПоказательПроцесса - СправочникСсылка.ПоказателиПроцессов - Показатель процесса.
//  ДатаПересчета - Дата - Дата до которой следует выполнить пересчет.
//  УдалитьСтарыеЗначения - Булево - Очистить ранее рассчитанные значения показателя.
//
Процедура ПересчитатьПоказатель(ПоказательПроцесса, ДатаПересчета, УдалитьСтарыеЗначения)
	
	Если Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(ПоказательПроцесса).Изменение Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для пересчета показателя'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Если УдалитьСтарыеЗначения Тогда
			РегистрыСведений.ЗначенияПоказателейПроцессов.Очистить(ПоказательПроцесса);
		КонецЕсли;
		
		РегистрыСведений.ОчередьПересчетаПоказателейПроцессов.Добавить(ПоказательПроцесса, ДатаПересчета);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти