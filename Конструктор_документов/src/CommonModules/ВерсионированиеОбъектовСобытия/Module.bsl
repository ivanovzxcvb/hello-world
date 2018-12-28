////////////////////////////////////////////////////////////////////////////////
// Подсистема "Версионирование объектов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Записывает версию объекта (кроме документов) в информационную базу.
//
// Параметры:
//  Источник - Объект - записываемый объект ИБ;
//  Отказ    - Булево - признак отказа от записи объекта.
//
Процедура ЗаписатьВерсиюОбъекта(Источник, Отказ) Экспорт
	
	ВерсионированиеОбъектов.ЗаписатьВерсиюОбъекта(Источник, Ложь);
	
КонецПроцедуры

// Записывает версию документа в информационную базу.
//
// Параметры:
//  Источник - Объект - записываемый документ ИБ;
//  Отказ    - Булево - признак отказа от записи документа.
//
Процедура ЗаписатьВерсиюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ВерсионированиеОбъектов.ЗаписатьВерсиюОбъекта(Источник, РежимЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему.

// См. описание одноименной процедуры в общем модуле РегламентныеЗаданияПереопределяемый.
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	//Настройка = Настройки.Добавить();
	//Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов;
	//Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВерсионированиеОбъектов;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// Только для внутреннего использования.
//
Процедура УдалитьИнформациюОбАвтореВерсии(Источник, Отказ) Экспорт
	
	РегистрыСведений.ВерсииОбъектов.УдалитьИнформациюОбАвтореВерсии(Источник.Ссылка);
	
КонецПроцедуры

#КонецОбласти
