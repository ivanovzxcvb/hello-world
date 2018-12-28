#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	ПоПользователю = Пользователи.ТекущийПользователь();
	Если Параметры.РежимРаботы = "ПоказУведомлений" Или Не ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ() Тогда
		Элементы.ПоПользователю.Видимость = Ложь;
		Элементы.Пользователь.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ФормаЗакрыть.Видимость = (Параметры.РежимРаботы = "ПоказУведомлений");
	ОтображатьПросмотренные = (Параметры.РежимРаботы <> "ПоказУведомлений");
	
	ОтобразитьУведомленияПоПользователю();
	ОтобразитьУдаленныеУведомления();
	ОтобразитьПросмотренныеУведомления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.РежимРаботы = "ПоказУведомлений" Тогда
		Оповестить("ПоказаныУведомленияПрограммы");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ОтметитьПросмотрВсех();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтобразитьУдаленныеУведомления();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоПользователюПриИзменении(Элемент)
	
	ОтобразитьУведомленияПоПользователю();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
		Или ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		УстановитьДоступностьКомандОтправить(0);
		Возврат;
	КонецЕсли;
	
	УстановитьДоступностьКомандОтправить(ТекущиеДанные.ВидУведомления);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если ТекущиеДанные.ВидУведомления = 2 Тогда
		СсылкаДляПерехода = ТекущиеДанные.Ссылка;
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Объект) Тогда
		СсылкаДляПерехода = ТекущиеДанные.Объект;
	Иначе
		СсылкаДляПерехода = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ПоказатьЗначение(, СсылкаДляПерехода);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ОтображатьУдаленныеУведомления = Не ОтображатьУдаленныеУведомления;
	ОтобразитьУдаленныеУведомления();
	
КонецПроцедуры

&НаКлиенте
Процедура Просмотреть(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Отправить

&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Исполнение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомление(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Ознакомление");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникСозданияОсновныхПроцессов(ТипыОпераций)
	
	ВыделенныеСтроки = Новый Массив;
	
	Для Каждого СтрСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(СтрСписка).Ссылка);
	КонецЦикла;
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		ТипыОпераций, ВыделенныеСтроки, ЭтаФорма, "ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтобразитьУдаленныеУведомления()
	
	Если ОтображатьУдаленныеУведомления Тогда
		ПараметрОтображатьУдаленные = 
			Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтображатьУдаленные"));
		ПараметрОтображатьУдаленные.Использование = Ложь;
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленныеУведомления);
	КонецЕсли;
	Элементы.ФормаПоказыватьУдаленные.Пометка = ОтображатьУдаленныеУведомления;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьУведомленияПоПользователю()
	
	Если ЗначениеЗаполнено(ПоПользователю) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ПоПользователю);
	Иначе
		ПараметрПользователь = 
			Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Пользователь"));
		ПараметрПользователь.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтметитьПросмотрВсех()
	
	Справочники.УведомленияПрограммы.ОтметитьПросмотрВсех();
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьПросмотренныеУведомления()
	
	Если ОтображатьПросмотренные Тогда
		ПараметрОтображатьПросмотренные = 
			Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОтображатьПросмотренные"));
		ПараметрОтображатьПросмотренные.Использование = Ложь;
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("ОтображатьПросмотренные", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	// Непросмотренные элементы.
	Если Параметры.РежимРаботы <> "ПоказУведомлений" Тогда
		
		Элемент = Список.УсловноеОформление.Элементы.Добавить();
		
		Поля = Элемент.Поля.Элементы;
		Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("Описание");
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Просмотрено");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;
		
		Элемент.Оформление.УстановитьЗначениеПараметра(
			"Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина));
		
	КонецЕсли;
	
	// Помеченные на удаление элементы.
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра(
		"Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , , , , Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандОтправить(ВидУведомления)
	
	ДоступныКомандыОтправить = (ВидУведомления <> 0);
	
	Элементы.ГруппаОтправить.Доступность = ДоступныКомандыОтправить;
	
КонецПроцедуры

#КонецОбласти