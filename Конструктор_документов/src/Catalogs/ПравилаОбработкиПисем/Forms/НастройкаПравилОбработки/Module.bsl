
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		ОписаниеПравилаОбработки = ПолучитьПустоеОписание();
	КонецЕсли;
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ОписаниеПравилаОбработки = ПолучитьПустоеОписание();
		Элементы.СписокКонтекстноеМенюВключитьПравило.Доступность = Ложь;
		Элементы.СписокКонтекстноеМенюВыключитьПравило.Доступность = Ложь;
		ТекущееПравило = Неопределено;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") 
		ИЛИ ТекущееПравило = Элемент.ТекущаяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееПравило = Элемент.ТекущаяСтрока;
	ОписаниеПравилаОбработки = ПолучитьОписаниеПравилаОбработки(ТекущееПравило);
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда 
		Элементы.СписокКонтекстноеМенюВключитьПравило.Доступность = Ложь;
		Элементы.СписокКонтекстноеМенюВыключитьПравило.Доступность = Ложь;
	Иначе 
		Элементы.СписокКонтекстноеМенюВключитьПравило.Доступность = Не Элемент.ТекущиеДанные.Используется;
		Элементы.СписокКонтекстноеМенюВыключитьПравило.Доступность = Элемент.ТекущиеДанные.Используется;	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПустоеОписание()
	
	ОписаниеПравила = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<html><body><font size=""2"" color=""gray"">%1</font></body></html>",
			НСтр("ru = 'Описание правила'"));		
	Возврат ОписаниеПравила;	
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("УчетнаяЗапись", Неопределено);
	
	УчетныеЗаписи.Параметры.УстановитьЗначениеПараметра("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникУчетныеЗаписиЭлектроннойПочты.Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК СправочникУчетныеЗаписиЭлектроннойПочты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			МоиУчетныеЗаписи.Ссылка КАК Ссылка
		|		ИЗ
		|			Справочник.УчетныеЗаписиЭлектроннойПочты.ОтветственныеЗаОбработкуПисем КАК МоиУчетныеЗаписи
		|		ГДЕ
		|			МоиУчетныеЗаписи.Пользователь = &Пользователь) КАК МоиУчетныеЗаписи
		|		ПО (МоиУчетныеЗаписи.Ссылка = СправочникУчетныеЗаписиЭлектроннойПочты.Ссылка)
		|ГДЕ
		|	СправочникУчетныеЗаписиЭлектроннойПочты.ВариантИспользования = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияПочты.Встроенная)
		|	И СправочникУчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() = 1 Тогда
			Выборка.Следующий();
			ТекущаяУчетнаяЗапись = Выборка.Ссылка;
			ЗагрузитьСписокПравил(ТекущаяУчетнаяЗапись);
			Элементы.УчетныеЗаписи.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Отказ = Истина;
		Текст = НСтр("ru = 'Нет ни одной учетной записи, для которой можно настроить правила обработки писем.
			|Обратитесь к аминистратору.'");
		ВызватьИсключение(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчетныеЗаписиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.УчетныеЗаписи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено 
		ИЛИ Элемент.ТекущаяСтрока = ТекущаяУчетнаяЗапись Тогда
		Возврат;
	КонецЕсли;
	ТекущаяУчетнаяЗапись = Элемент.ТекущаяСтрока;
	ЗагрузитьСписокПравил(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокПравил(УчетнаяЗапись)
	
	Список.Параметры.УстановитьЗначениеПараметра("УчетнаяЗапись", УчетнаяЗапись);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоВверх(Команда)
	
	Если Не ЗначениеЗаполнено(ТекущееПравило)
		Или Элементы.Список.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	ПереместитьПравило(Элементы.Список.ТекущаяСтрока, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоВниз(Команда)
	
	Если Не ЗначениеЗаполнено(ТекущееПравило)
		Или Элементы.Список.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	ПереместитьПравило(Элементы.Список.ТекущаяСтрока, 1);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОписаниеПравилаОбработки(ПравилоСсылка)
	
	Если ТипЗнч(ПравилоСсылка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат "";
	КонецЕсли;
	Если ЗначениеЗаполнено(ПравилоСсылка) Тогда
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ПравилоСсылка);
		Возврат Менеджер.ПолучитьОписаниеПравила(ПравилоСсылка);
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПереместитьПравило(Правило, Направление)
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Правило,
	    "Порядок, ДляВходящихПисем, ДляИсходящихПисем");
	
	Запрос = Новый Запрос;
	Если Направление < 0 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПравилаОбработкиПисем.Ссылка
			|ИЗ
			|	Справочник.ПравилаОбработкиПисем КАК ПравилаОбработкиПисем
			|ГДЕ
			|	ПравилаОбработкиПисем.ДляВходящихПисем = &ДляВходящихПисем
			|	И ПравилаОбработкиПисем.ДляИсходящихПисем = &ДляИсходящихПисем
			|	И ПравилаОбработкиПисем.Порядок < &Порядок
			|	И ПравилаОбработкиПисем.УчетнаяЗапись = &УчетнаяЗапись
			|	И ПравилаОбработкиПисем.ПометкаУдаления = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПравилаОбработкиПисем.Порядок УБЫВ";	
	Иначе
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПравилаОбработкиПисем.Ссылка
			|ИЗ
			|	Справочник.ПравилаОбработкиПисем КАК ПравилаОбработкиПисем
			|ГДЕ
			|	ПравилаОбработкиПисем.ДляВходящихПисем = &ДляВходящихПисем
			|	И ПравилаОбработкиПисем.ДляИсходящихПисем = &ДляИсходящихПисем
			|	И ПравилаОбработкиПисем.Порядок > &Порядок
			|	И ПравилаОбработкиПисем.УчетнаяЗапись = &УчетнаяЗапись
			|	И ПравилаОбработкиПисем.ПометкаУдаления = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПравилаОбработкиПисем.Порядок Возр";	
	КонецЕсли;	
		
	Запрос.УстановитьПараметр("УчетнаяЗапись", ТекущаяУчетнаяЗапись);
	Запрос.УстановитьПараметр("ДляВходящихПисем", Реквизиты.ДляВходящихПисем);
	Запрос.УстановитьПараметр("ДляИсходящихПисем", Реквизиты.ДляИсходящихПисем);
	Запрос.Установитьпараметр("Порядок", Реквизиты.Порядок);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			ДругоеПравило = Выборка.Ссылка.ПолучитьОбъект();
			ДанноеПравило = Правило.ПолучитьОбъект();
			
			ПорядокБуфер = ДругоеПравило.Порядок;
			ДругоеПравило.Порядок = ДанноеПравило.Порядок;
			ДанноеПравило.Порядок = ПорядокБуфер;
			
			ДругоеПравило.Записать();
			ДанноеПравило.Записать();
			
			Элементы.Список.Обновить();
			
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПравилоОбработкиПисем" Тогда
		ОписаниеПравилаОбработки = ПолучитьОписаниеПравилаОбработки(Элементы.Список.ТекущаяСтрока);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДляВходящих(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяЗапись", ТекущаяУчетнаяЗапись);
	ПараметрыФормы.Вставить("ДляВходящихПисем", Истина);
	ПараметрыФормы.Вставить("ДляИсходящихПисем", Ложь);
	ОткрытьФорму("Справочник.ПравилаОбработкиПисем.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДляИсходящих(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяЗапись", ТекущаяУчетнаяЗапись);
	ПараметрыФормы.Вставить("ДляВходящихПисем", Ложь);
	ПараметрыФормы.Вставить("ДляИсходящихПисем", Истина);
	ОткрытьФорму("Справочник.ПравилаОбработкиПисем.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьПравило(Команда)
	
	Если Не ЗначениеЗаполнено(ТекущееПравило) Тогда
		Возврат;
	КонецЕсли;	
	ВключитьВыключить(Элементы.Список.ТекущаяСтрока, Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыключитьПравило(Команда)
	
	Если Не ЗначениеЗаполнено(ТекущееПравило) Тогда
		Возврат;
	КонецЕсли;
	ВключитьВыключить(Элементы.Список.ТекущаяСтрока, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ВключитьВыключить(Ссылка, Включен)
	
	ОбъектПравило = Ссылка.ПолучитьОбъект();
	ОбъектПравило.Используется = Включен;
	ОбъектПравило.Записать();
	
	Элементы.Список.Обновить();
	
	Элементы.СписокКонтекстноеМенюВключитьПравило.Доступность = Не Ссылка.Используется;
	Элементы.СписокКонтекстноеМенюВыключитьПравило.Доступность = Ссылка.Используется;
	                                                                               	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьПравило(Команда)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") 
		Или Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Правило", Элементы.Список.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ЗаголовокКнопкиГотово", НСтр("ru = 'Готово'"));
	ПараметрыФормы.Вставить(
		"ЗаголовокФормы", 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Применение правила ""%1""'"),
			Строка(Элементы.Список.ТекущаяСтрока)));
	ОткрытьФорму(
		"Справочник.ПравилаОбработкиПисем.Форма.ФормаВыбораПапкиДляПрименения",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Отказ = Истина;
		Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПравилоОснование", Элементы.Список.ТекущаяСтрока);
		ОткрытьФорму("Справочник.ПравилаОбработкиПисем.ФормаОбъекта", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Переименовать(Команда)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") 
		Или Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элементы.Список.ТекущаяСтрока);
	ОткрытьФорму("Справочник.ПравилаОбработкиПисем.Форма.ПереименованиеПравила", ПараметрыФормы);
	
КонецПроцедуры

