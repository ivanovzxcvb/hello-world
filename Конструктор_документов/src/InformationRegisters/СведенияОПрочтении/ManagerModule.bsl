#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает признак Прочтен для объекта у Пользователя (ТекущегоПользователя).
Процедура УстановитьСведенияОПрочтении(Объект, Прочтен, Знач Пользователь = Неопределено) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запись = РегистрыСведений.СведенияОПрочтении.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Объект = Объект;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.Объект = Объект;
	Запись.Прочтен = Прочтен;
	Запись.Записать(Истина);
	
КонецПроцедуры

// Убирает признак Прочтено для объекта у всех пользователей.
Процедура УбратьСведенияОПрочтении(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СведенияОПрочтении.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Объект);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Возвращает признак Прочтен для объекта у Пользователя (ТекущегоПользователя).
Функция ОбъектБылПрочтен(Объект, Знач Пользователь = Неопределено) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Прочтен = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОПрочтении.Прочтен
		|ИЗ
		|	РегистрСведений.СведенияОПрочтении КАК СведенияОПрочтении
		|ГДЕ
		|	СведенияОПрочтении.Пользователь = &Пользователь
		|	И СведенияОПрочтении.Объект = &Объект";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	НачатьТранзакцию();
	Попытка
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Прочтен = Выборка.Прочтен;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
		
		Возврат Прочтен;
		
	Исключение
		ОтменитьТранзакцию();
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Произошла ошибка при получении сведений о прочтении:
			|%1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Встроенная почта.Получение сведений о прочтении'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,
			, 
			Объект,
			СообщениеОбОшибке);
		ВызватьИсключение;
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#КонецЕсли