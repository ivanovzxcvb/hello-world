
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет задачу в очередь для фонового выполнения
//
// Параметры:
//   Задача - ЗадачаСсылка.ЗадачаИсполнителя - ссылка на задачу
//   Параметры - Структура - структура параметров выполнения задачи
//
Процедура ДобавитьЗадачуДляФоновогоВыполнения(Задача, Параметры = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗадачиДляВыполнения");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Задача", Задача.Ссылка);
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка.Заблокировать();
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Задача.Установить(Задача.Ссылка);
		
		Запись = НаборЗаписей.Добавить();
		Запись.Задача = Задача.Ссылка;
		Запись.МоментВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();
		Запись.СостояниеВыполнения = Перечисления.СостоянияЗадачДляВыполнения.ГотоваКВыполнению;
		
		Если Параметры = Неопределено Тогда
			Параметры = Новый Структура;
		КонецЕсли;
		
		Если Не Параметры.Свойство("ДатаИсполнения") Тогда
			Параметры.Вставить("ДатаИсполнения", Задача.ДатаИсполнения);
		КонецЕсли;
		
		Если Не Параметры.Свойство("ИсполнительЗадачи") Тогда
			Параметры.Вставить("ИсполнительЗадачи", Задача.ТекущийИсполнитель);
		КонецЕсли;
		
		Если ТипЗнч(Параметры.ИсполнительЗадачи) = Тип("СправочникСсылка.ПолныеРоли") Тогда
			Параметры.ИсполнительЗадачи = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
		Если Не Параметры.Свойство("РезультатВыполнения") Тогда
			Параметры.Вставить("РезультатВыполнения", Задача.РезультатВыполнения);
		КонецЕсли;
		
		Если Не Параметры.Свойство("ПользовательИсполнитель") Тогда
			Параметры.Вставить("ПользовательИсполнитель", ПользователиКлиентСервер.ТекущийПользователь());
		КонецЕсли;
		
		Запись.Параметры = Новый ХранилищеЗначения(Параметры);
		
		РезультатПроверки = БизнесПроцессыИЗадачиСервер.ПроверитьУсловияЗапретаВыполнения(Задача.Ссылка, Параметры);
		Если РезультатПроверки.ЗапретВыполнения Тогда
			ВызватьИсключение РезультатПроверки.ТекстПредупреждения;
		КонецЕсли;
		
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Удаляет задачу из очереди для фонового выполнения
//
// Параметры:
//   Задача - ЗадачаСсылка.ЗадачаИсполнителя - ссылка на задачу
//
Процедура УдалитьЗадачуИзОчереди(Задача) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗадачиДляВыполнения");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Задача", Задача);
	
	НачатьТранзакцию();
	
	Блокировка.Заблокировать();
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Задача.Установить(Задача);
	НаборЗаписей.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Возвращает состояние выполнения задачи
//
// Параметры:
//   Задача - ЗадачаСсылка.ЗадачаИсполнителя - ссылка на задачу
//
// Возвращаемое значение:
//   Структура
//     СостояниеВыполнения - Перечисление.СостоянияЗадачДляВыполнения, Неопределено - принимает значение неопределено,
//                           если задачи нет регистре.
//     ПричинаОтменыВыполнения - Строка - содержит причину отмены выполнения
//
Функция СостояниеВыполненияЗадачи(Задача) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СостояниеВыполнения", Неопределено);
	Результат.Вставить("ПричинаОтменыВыполнения", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиДляВыполнения.СостояниеВыполнения,
		|	ЗадачиДляВыполнения.ПричинаОтменыВыполнения
		|ИЗ
		|	РегистрСведений.ЗадачиДляВыполнения КАК ЗадачиДляВыполнения
		|ГДЕ
		|	ЗадачиДляВыполнения.Задача = &Задача";
	Запрос.УстановитьПараметр("Задача", Задача);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Записывает факт отмены выполнения задачи в регистр.
//
// Параметры:
//   Задача - ЗадачаСсылка.ЗадачаИсполнителя - ссылка на задачу
//   Причина - Строка - причина отмены выполнения
//
Процедура ЗарегистрироватьОтменуВыполнения(Задача, Причина) Экспорт
	
	УстановитьБезопасныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗадачиДляВыполнения");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Задача", Задача);
	
	НачатьТранзакцию();
	
	Блокировка.Заблокировать();
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Задача.Установить(Задача);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
		Запись = НаборЗаписей[0];
		Запись.ПричинаОтменыВыполнения = Причина;
		Запись.СостояниеВыполнения = Перечисления.СостоянияЗадачДляВыполнения.ВыполнениеОтменено;
		
		НаборЗаписей.Записать();
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

// Увеличивает счетчик попыток выполнения задачи
//
// Параметры:
//   Задача - ЗадачаСсылка.ЗадачаИсполнителя - ссылка на задачу
//
Процедура ЗарегистрироватьПопыткуВыполненияЗадачи(Задача) Экспорт
	
	УстановитьБезопасныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗадачиДляВыполнения");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Задача", Задача);
	
	НачатьТранзакцию();
	
	Блокировка.Заблокировать();
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Задача.Установить(Задача);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
		Запись = НаборЗаписей[0];
		Запись.КоличествоПопытокОбработки = Запись.КоличествоПопытокОбработки + 1;
		НаборЗаписей.Записать();
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
