#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Дела по месту хранения.
	Если Параметры.Свойство("МестоХранения") И ЗначениеЗаполнено(Параметры.МестоХранения) Тогда 
		МестоХранения = Параметры.МестоХранения;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "МестоХраненияДел", МестоХранения,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
		ПоказыватьДела = "Все";
		ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
			Элементы.ПоказыватьДела, ПоказыватьДела, "Все");
		Подразделение = Неопределено;
		Организация = Неопределено;
		УстановитьОтбор();
		
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дела (тома) по месту хранения: %1'"), Строка(МестоХранения));
	Иначе 
		ПоказыватьДела = "Открытые";
		Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	УстановитьОтбор();
	
	Если ЗначениеЗаполнено(Параметры.НоменклатураДел) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, 
			"НоменклатураДел", 
			Параметры.НоменклатураДел);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПометкаУдаления", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
				
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанель);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаНоменклатураДел" Тогда 
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(МестоХранения) Тогда 
		Настройки["Подразделение"] = Неопределено;
		Настройки["Организация"] = Неопределено;
		Настройки["ПоказыватьДела"] = "Все";
	КонецЕсли;
	
	ПоказыватьДела = Настройки["ПоказыватьДела"];
	Организация = Настройки["Организация"];
	Подразделение = Настройки["Подразделение"];
	
	УстановитьОтборСписка(Настройки);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ПоказыватьДела, ПоказыватьДела, "Все");
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.Организация, Организация);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.Подразделение, Подразделение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьДелаПриИзменении(Элемент)
	
	УстановитьОтбор();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(
		Элементы.ПоказыватьДела, ПоказыватьДела, "Все");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьДелаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказыватьДела = "Все";
	
	УстановитьОтбор();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, 
		ПоказыватьДела, "Все");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтбор();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	УстановитьОтбор();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, Подразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ЗначениеЗаполнено(МестоХранения) Тогда 
		Отказ = Истина;
		
		Если ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			МестоХранения, "ЗапрещеноРазмещатьНовыеДела") Тогда
			СообщениеОбОшибке = НСтр("ru = 'В указанное место хранения запрещено размещать новые дела.'");
			ПоказатьПредупреждение(, СообщениеОбОшибке);
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		
		Если Копирование Тогда 
			ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
		Иначе 
			ПараметрыФормы.Вставить("МестоХранения", МестоХранения);
		КонецЕсли;
		
		Открытьформу("Справочник.ДелаХраненияДокументов.ФормаОбъекта", ПараметрыФормы,
			Элементы.Список, Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереносДокументовДела(Команда)
	
	ПараметрыФормы = Новый Структура("ПеренестиИзДела", Элементы.Список.ТекущаяСтрока);
	Открытьформу("Справочник.ДелаХраненияДокументов.Форма.ФормаПереносаДокументовДела", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	Если Не ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДела(Команда)
	
	ПараметрыФормы = Новый Структура("Подразделение, Организация", Подразделение, Организация);
	ОткрытьФорму("Справочник.ДелаХраненияДокументов.Форма.ФормаСозданияДел", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
  
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
		
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.ДелаТомаСписок");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по Делам(томам)'");
	
	РазделГипперссылка = НастройкиВариантовОтчетовДокументооборот.ПолучитьРазделОтчетаПоИмени("ДокументыИФайлы");

	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, РазделГипперссылка", 
										Раздел, ЗаголовокФормы, Истина, РазделГипперссылка);
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		"ДелаТомаСписок");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборСписка(ПараметрыОтбора)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		ПараметрыОтбора["Организация"] = Неопределено;
	КонецЕсли;
	
	Если ПараметрыОтбора["ПоказыватьДела"] = "Все"
	 Или ПараметрыОтбора["ПоказыватьДела"] = "Открытые"
	 Или ПараметрыОтбора["ПоказыватьДела"] = "Закрытые"
	 Или ПараметрыОтбора["ПоказыватьДела"] = "Переданные в архив"
	 Или ПараметрыОтбора["ПоказыватьДела"] = "Уничтоженные" Тогда 
	 
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Состояние");
			
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"ДелоЗакрыто");	
			
	КонецЕсли;	
	
	Если ПараметрыОтбора["ПоказыватьДела"] = "Открытые" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Состояние", 
			Перечисления.СостоянияДелХраненияДокументов.ПустаяСсылка());
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ДелоЗакрыто", 
			Ложь);
			
	ИначеЕсли ПараметрыОтбора["ПоказыватьДела"] = "Закрытые" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Состояние", 
			Перечисления.СостоянияДелХраненияДокументов.ПустаяСсылка());
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ДелоЗакрыто", 
			Истина);		
			
	ИначеЕсли ПараметрыОтбора["ПоказыватьДела"] = "Переданные в архив" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Состояние", 
			Перечисления.СостоянияДелХраненияДокументов.ПереданоВАрхив);
		
	ИначеЕсли ПараметрыОтбора["ПоказыватьДела"] = "Уничтоженные" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Состояние", 
			Перечисления.СостоянияДелХраненияДокументов.Уничтожено);
		
	КонецЕсли;	
	
	// организация 
	Если Не ЗначениеЗаполнено(ПараметрыОтбора["Организация"]) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Организация");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Организация",
			ПараметрыОтбора["Организация"]);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ПараметрыОтбора["Подразделение"]) Тогда 
		
		МассивПодразделений = Делопроизводство.ПолучитьПодразделениеИРодителей(ПараметрыОтбора["Подразделение"]);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Подразделение",
			МассивПодразделений,
			ВидСравненияКомпоновкиДанных.ВСписке);
			
	Иначе 
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Подразделение");	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ПараметрыОтбора["ПоказыватьУдаленные"]) Тогда
		
		Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
		
		Если Не ПоказыватьУдаленные Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "ПометкаУдаления", Ложь,
				ВидСравненияКомпоновкиДанных.Равно, , Истина);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("ПоказыватьДела", ПоказыватьДела);	
	ПараметрыОтбора.Вставить("Организация",    Организация);	
	ПараметрыОтбора.Вставить("Подразделение",  Подразделение);	
	УстановитьОтборСписка(ПараметрыОтбора);
	
КонецПроцедуры	

#КонецОбласти
