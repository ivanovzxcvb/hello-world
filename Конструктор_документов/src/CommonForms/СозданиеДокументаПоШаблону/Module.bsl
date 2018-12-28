
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	//Проверка на существование шаблонов для указанного типа документа
	НеНайденоШаблонов = Ложь;
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ШаблоныДокументов.Ссылка
		|ИЗ
		|	Справочник." + Параметры.ТипШаблонаДокумента + " КАК ШаблоныДокументов
		|ГДЕ
		|	НЕ ШаблоныДокументов.ЭтоГруппа
		|	И НЕ ШаблоныДокументов.ПометкаУдаления";
					
	Если Параметры.Свойство("СозданиеОбращенияГраждан") И Параметры.СозданиеОбращенияГраждан Тогда
			
		Запрос.Текст = Запрос.Текст + "
		|	И	(ШаблоныДокументов.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыВходящихДокументов.ПустаяСсылка)
		|			ИЛИ ШаблоныДокументов.ВидДокумента.ЯвляетсяОбращениемОтГраждан = ИСТИНА)";
		
		СозданиеОбращенияГраждан = Параметры.СозданиеОбращенияГраждан;
			
	КонецЕсли;
	
	ОбщееКоличествоШаблонов = Запрос.Выполнить().Выбрать().Количество();
	Если ОбщееКоличествоШаблонов = 0 Тогда
		НеНайденоШаблонов = Истина;
		ВызватьИсключение("СоздатьПустойДокумент");
	КонецЕсли;

	ТипШаблонаДокумента = Параметры.ТипШаблонаДокумента;
	ВозможностьСозданияПустогоДокумента = Параметры.ВозможностьСозданияПустогоДокумента;
	
	Если Параметры.Свойство("НаименованиеКнопкиВыбора") Тогда 
		ЭтаФорма.Элементы.СоздатьПоШаблону.Заголовок = Параметры.НаименованиеКнопкиВыбора;
	КонецЕсли;
	
	СоздатьПоШаблону = Истина;
	
	АвтоЗаголовок = Ложь;
	Если Параметры.ВозможностьСозданияПустогоДокумента Тогда
		Если ТипШаблонаДокумента = "ШаблоныВнутреннихДокументов" Тогда
			Заголовок = НСтр("ru = 'Создание нового внутреннего документа'");
			ТипВида = "ВидыВнутреннихДокументов";
		ИначеЕсли ТипШаблонаДокумента = "ШаблоныВходящихДокументов" Тогда
			Заголовок = НСтр("ru = 'Создание нового входящего документа'");
			ТипВида = "ВидыВходящихДокументов";
		ИначеЕсли ТипШаблонаДокумента = "ШаблоныИсходящихДокументов" Тогда
			Заголовок = НСтр("ru = 'Создание нового исходящего документа'");
			ТипВида = "ВидыИсходящихДокументов";
		КонецЕсли;
	Иначе
		Если ТипШаблонаДокумента = "ШаблоныВнутреннихДокументов" Тогда
			Заголовок = НСтр("ru = 'Заполнение внутреннего документа по шаблону'");
			ТипВида = "ВидыВнутреннихДокументов";
		ИначеЕсли ТипШаблонаДокумента = "ШаблоныВходящихДокументов" Тогда
			Заголовок = НСтр("ru = 'Заполнение входящего документа по шаблону'");
			ТипВида = "ВидыВходящихДокументов";
		ИначеЕсли ТипШаблонаДокумента = "ШаблоныИсходящихДокументов" Тогда
			Заголовок = НСтр("ru = 'Заполнение исходящего документа по шаблону'");
			ТипВида = "ВидыИсходящихДокументов";
		КонецЕсли;
	КонецЕсли;
	
	ЕстьДоступныеУчетныеЗаписиДляОтправки = 
		РаботаСПочтовымиСообщениямиВызовСервера.ЕстьДоступныеУчетныеЗаписиДляОтправки();
		
	ПостроитьДеревоШаблонов();
	СохранениеВводимыхЗначений.ЗагрузитьСписокВыбора(ЭтаФорма, "СтрокаПоиска");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИспользованиеЛегкойПочты = ПолучитьФункциональнуюОпциюИнтерфейса("ИспользованиеЛегкойПочты");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		
		СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
		Если СтрДлина(СтрокаПоиска) < 3 И СтрокаПоиска <> "*" И СтрокаПоиска <> "**" Тогда
			ЭтаФорма.ТекущийЭлемент = Элементы.СтрокаПоиска;
			ЭтаФорма.Активизировать();
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо ввести минимум 3 символа'"));
			Возврат;
		КонецЕсли;
		
		ПустойРезультатПоиска = Ложь;
		НайтиШаблоны();
		ПустойРезультатПоиска = СписокШаблоновПоиск.ПолучитьЭлементы().Количество() = 0;
		
		Если ПустойРезультатПоиска Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'По вашему запросу ничего не найдено'"));
			ЭтаФорма.ТекущийЭлемент = Элементы.СтрокаПоиска;
		Иначе
			ЭтаФорма.ТекущийЭлемент = Элементы.СписокШаблонов;
			СохранениеВводимыхЗначенийКлиент.ОбновитьСписокВыбора(ЭтаФорма, "СтрокаПоиска", 10);
		КонецЕсли;
		
		ПоискВключен = Истина;
	Иначе
		Если ПоискВключен Тогда
			ПостроитьДеревоШаблонов();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтрокаПоиска = Неопределено;
	ПостроитьДеревоШаблонов();
	ЭтаФорма.ТекущийЭлемент = Элементы.СписокШаблонов;
	
КонецПроцедуры

&НаКлиенте
Процедура СводкаПоШаблонуПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Лев(ДанныеСобытия.Href, 6) <> "v8doc:" Тогда 
		Возврат;
	КонецЕсли;	
	НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
	
	Если Найти(НавигационнаяСсылкаПоля, "message") > 0 Тогда 	
		
		Если Не ИспользованиеЛегкойПочты Тогда 
			ТекстСообщения = НСтр("ru = 'Для отправки письма требуется включить использование легкой почты.'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		ИначеЕсли Не ЕстьДоступныеУчетныеЗаписиДляОтправки Тогда 
			ТекстСообщения = НСтр("ru = 'Для отправки письма требуется настройка учетной записи электронной почты.'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		Иначе 		
			АдресПочты = СокрЛП(СтрЗаменить(НавигационнаяСсылкаПоля, "message", ""));
			РаботаСПочтовымиСообщениямиКлиент.ОткрытьФормуОтправкиПочтовогоСообщения(, АдресПочты);
		КонецЕсли;	
						
	Иначе	
		
		ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаПоля);
		
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокШаблонов

&НаКлиенте
Процедура СписокШаблоновВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.СписокШаблонов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.КомандаСсылка = "Пустой" Тогда 
		СоздатьПустойДокумент = Истина;
		СоздатьПоШаблону = Ложь;
		Закрыть("СоздатьПустойДокумент");
		Возврат;
	КонецЕсли;
	
	СоздатьПустойДокумент = Ложь;
	СоздатьПоШаблону = Истина;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ШаблонДокумента", ТекущиеДанные.КомандаСсылка);
	Закрыть(ДанныеЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокШаблоновПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СводкаПоШаблону = ПолучитьСводкуПоШаблону(Элемент.ТекущиеДанные.КомандаСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокШаблоновПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.СписокШаблонов.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		Если ЗначениеЗаполнено(ТекущиеДанные.ОбъектГруппировки) Тогда
			ПоказатьЗначение(, ТекущиеДанные.ОбъектГруппировки);
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.КомандаСсылка) И 
			Не ТекущиеДанные.ЭтоГруппа Тогда
			ПоказатьЗначение(, ТекущиеДанные.КомандаСсылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	СоздатьПоШаблонуВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	СоздатьПустойДокумент = Ложь;
	СоздатьПоШаблону = Ложь;
	Закрыть("ПрерватьОперацию");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуШаблона(Команда)
	
	ТекущиеДанные = Элементы.СписокШаблонов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа 
		Или ТекущиеДанные.КомандаСсылка = "Пустой" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено И НЕ ТекущиеДанные.ЭтоГруппа Тогда
		ПоказатьЗначение(, ТекущиеДанные.КомандаСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИсторию(Команда)
	
	СохранениеВводимыхЗначенийКлиент.ОчиститьСписокВыбора(ЭтаФорма, "СтрокаПоиска");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НайтиШаблоны()
	
	Дерево = РеквизитФормыВЗначение("СписокШаблоновПоиск");
	Дерево.Строки.Очистить();
	
	ПолучитьВсеШаблоныДокументов(Дерево, СтрокаПоиска);
	ЗначениеВДанныеФормы(Дерево, СписокШаблоновПоиск);
	
	Если СписокШаблоновПоиск.ПолучитьЭлементы().Количество() > 0 Тогда 
		ЗначениеВДанныеФормы(Дерево, СписокШаблонов);
		УстановитьТекущуюСтрокуВДеревеНаПервыйЗначащийЭлемент();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоШаблонуВыполнить()
	
	ТекущиеДанные = Элементы.СписокШаблонов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.КомандаСсылка = "Пустой" Тогда 
		СоздатьПустойДокумент = Истина;
		СоздатьПоШаблону = Ложь;
		Закрыть("СоздатьПустойДокумент");
		Возврат;
	КонецЕсли;
	
	СоздатьПустойДокумент = Ложь;
	СоздатьПоШаблону = Истина;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ШаблонДокумента", ТекущиеДанные.КомандаСсылка);
	Закрыть(ДанныеЗаполнения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСводкуПоШаблону(ШаблонСсылка)
	
	Если НЕ ЗначениеЗаполнено(ШаблонСсылка) Тогда
		Возврат "";
	КонецЕсли;
	
	Если ТипЗнч(ШаблонСсылка) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов") Тогда
		Сводка = ОбзорДокумента.ПолучитьОбзорШаблонаВнутреннегоДокумента(ШаблонСсылка);
		Возврат Сводка;
	КонецЕсли;
	
	Если ТипЗнч(ШаблонСсылка) = Тип("СправочникСсылка.ШаблоныИсходящихДокументов") Тогда
		Сводка = ОбзорДокумента.ПолучитьОбзорШаблонаИсходящегоДокумента(ШаблонСсылка);
		Возврат Сводка;
	КонецЕсли;
	
	Если ТипЗнч(ШаблонСсылка) = Тип("СправочникСсылка.ШаблоныВходящихДокументов") Тогда
		Сводка = ОбзорДокумента.ПолучитьОбзорШаблонаВходящегоДокумента(ШаблонСсылка);
		Возврат Сводка;
	КонецЕсли;
	
	Если ТипЗнч(ШаблонСсылка) = Тип("Строка") И ШаблонСсылка = "Пустой" Тогда 
		Сводка = ОбзорДокумента.ПолучитьОбзорПустогоШаблона();
	КонецЕсли;
		
	Возврат Сводка;
	
КонецФункции

&НаСервере
Процедура ПостроитьДеревоШаблонов()
	
	Дерево = РеквизитФормыВЗначение("СписокШаблонов");
	Дерево.Строки.Очистить();
	
	Если ОбщееКоличествоШаблонов > 5 Тогда 
		ПолучитьНедавноИспользуемыеШаблоныДокументов(Дерево);
	КонецЕсли;
	
	ПолучитьВсеШаблоныДокументов(Дерево);
	
	ЗначениеВДанныеФормы(Дерево, СписокШаблонов);
	УстановитьТекущуюСтрокуВДеревеНаПервыйЗначащийЭлемент();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНедавноИспользуемыеШаблоныДокументов(Дерево)
	
	ТаблицаПоследних = РаботаСШаблонамиДокументовСервер.ПолучитьПоследниеИспользованныеШаблоны(
		"СправочникСсылка." + ТипШаблонаДокумента);
		
	КоличествоНедавнихШаблонов = ТаблицаПоследних.Количество();
	Если КоличествоНедавнихШаблонов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЗаголовка = Дерево.Строки.Добавить();
	СтрокаЗаголовка.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Недавние (%1)'"), ТаблицаПоследних.Количество());
	СтрокаЗаголовка.КомандаСсылка = "Недавние";
	СтрокаЗаголовка.ЭтоГруппа = Истина;
	
	Для Каждого Строка Из ТаблицаПоследних Цикл
		СтрокаПредмета = СтрокаЗаголовка.Строки.Добавить();
		
		Если ЗначениеЗаполнено(Строка.Шаблон) Тогда 
			СтрокаПредмета.Представление = Строка(Строка.Шаблон);
			СтрокаПредмета.КомандаСсылка = Строка.Шаблон;
		Иначе 
			СтрокаПредмета.КомандаСсылка = "Пустой";
			СтрокаПредмета.Представление = НСтр("ru = 'Пустой'");
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПолучитьВсеШаблоныДокументов(Дерево, СтрПоиска = "")
	
	ЭтоПоиск = ЗначениеЗаполнено(СтрПоиска);
	КоличествоШаблонов = 0;
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|ВидыДокументов.Наименование,
		|ВидыДокументов.ЭтоГруппа КАК ЭтоГруппа,
		|ВидыДокументов.Ссылка,
		|ВидыДокументов.Родитель КАК Родитель
		|ИЗ
		|	Справочник." + ТипВида + " КАК ВидыДокументов
		|ГДЕ
		|	ВидыДокументов.ПометкаУдаления = ЛОЖЬ
		|	И ВидыДокументов.ЭтоГруппа
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ,
		|	Наименование";
		
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если Не ЭтоПоиск И ОбщееКоличествоШаблонов > 5 И КоличествоНедавнихШаблонов > 0 Тогда 
		СтрокаВсе = Дерево.Строки.Добавить();
		СтрокаВсе.КомандаСсылка = "Все";
		СтрокаВсе.ЭтоГруппа = Истина;
	Иначе 
		СтрокаВсе = Дерево;
	КонецЕсли;
	
	Если ВозможностьСозданияПустогоДокумента И Не ЭтоПоиск Тогда 
		СтрокаПустой = СтрокаВсе.Строки.Добавить();
		СтрокаПустой.КомандаСсылка = "Пустой";
		СтрокаПустой.Представление = НСтр("ru = 'Пустой'");
		СтрокаПустой.ЭтоГруппа = Ложь;
		КоличествоШаблонов = КоличествоШаблонов + 1;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		ОбъектГруппировки = Выборка.Родитель;
		
		Если ЗначениеЗаполнено(ОбъектГруппировки) Тогда
			
			НайденнаяСтрока = Дерево.Строки.Найти(ОбъектГруппировки, "ОбъектГруппировки", Истина);
			
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = НайденнаяСтрока.Строки.Добавить();
			Иначе
				СтрокаГруппировки = СтрокаВсе.Строки.Добавить();
				СтрокаГруппировки.ОбъектГруппировки = Выборка.Ссылка;
				СтрокаГруппировки.ЭтоГруппа = Выборка.ЭтоГруппа;
				СтрокаГруппировки.Представление = Строка(Выборка.Ссылка);
				СтрокаГруппировки.КомандаСсылка = Выборка.Ссылка;
				
				Если Не Выборка.ЭтоГруппа Тогда 
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = СтрокаГруппировки.Строки.Добавить();
			КонецЕсли;
			
			НоваяСтрока.ОбъектГруппировки = Выборка.Ссылка;
			НоваяСтрока.ЭтоГруппа = Выборка.ЭтоГруппа;
			НоваяСтрока.Представление = Строка(Выборка.Ссылка);
			НоваяСтрока.КомандаСсылка = Выборка.Ссылка;
		Иначе 
			
			СтрокаГруппировки = СтрокаВсе.Строки.Добавить();
			СтрокаГруппировки.ОбъектГруппировки = Выборка.Ссылка;
			СтрокаГруппировки.ЭтоГруппа = Выборка.ЭтоГруппа;
			СтрокаГруппировки.Представление = Строка(Выборка.Ссылка);
			СтрокаГруппировки.КомандаСсылка = Выборка.Ссылка;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|ШаблоныДокументов.Наименование,
		|ШаблоныДокументов.КомментарийКШаблону,
		|ШаблоныДокументов.ЭтоГруппа КАК ЭтоГруппа,
		|ШаблоныДокументов.Ссылка,
		|ШаблоныДокументов.ВидДокумента.Родитель КАК Родитель
		|ИЗ
		|	Справочник." + ТипШаблонаДокумента + " КАК ШаблоныДокументов
		|ГДЕ
		|	ШаблоныДокументов.ПометкаУдаления = ЛОЖЬ
		|	И НЕ ШаблоныДокументов.ЭтоГруппа";
	
	Если СозданиеОбращенияГраждан Тогда
		Запрос.Текст = Запрос.Текст + "
			|	И (ШаблоныДокументов.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыВходящихДокументов.ПустаяСсылка)
			|	ИЛИ ШаблоныДокументов.ВидДокумента.ЯвляетсяОбращениемОтГраждан)";
	КонецЕсли;
	
	Если ЭтоПоиск Тогда 
		Запрос.Текст = Запрос.Текст + "
			|	И ШаблоныДокументов.Наименование Подобно &СтрокаПоиска";
		Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
			|УПОРЯДОЧИТЬ ПО
			|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОбъектГруппировки = Выборка.Родитель;
		
		Если ЗначениеЗаполнено(ОбъектГруппировки) Тогда
			
			НайденнаяСтрока = Дерево.Строки.Найти(ОбъектГруппировки, "ОбъектГруппировки", Истина);
			
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = НайденнаяСтрока.Строки.Добавить();
			Иначе
				СтрокаГруппировки = СтрокаВсе.Строки.Добавить();
				СтрокаГруппировки.ОбъектГруппировки = Выборка.Ссылка;
				СтрокаГруппировки.ЭтоГруппа = Выборка.ЭтоГруппа;
				СтрокаГруппировки.Представление = Строка(Выборка.Ссылка);
				СтрокаГруппировки.КомандаСсылка = Выборка.Ссылка;
				
				Если Не Выборка.ЭтоГруппа Тогда 
					КоличествоШаблонов = КоличествоШаблонов + 1;
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = СтрокаГруппировки.Строки.Добавить();
			КонецЕсли;
			
			НоваяСтрока.ОбъектГруппировки = Выборка.Ссылка;
			НоваяСтрока.ЭтоГруппа = Выборка.ЭтоГруппа;
			НоваяСтрока.Представление = Строка(Выборка.Ссылка);
			НоваяСтрока.КомандаСсылка = Выборка.Ссылка;
			Если Не Выборка.ЭтоГруппа Тогда 
				КоличествоШаблонов = КоличествоШаблонов + 1;
				Продолжить;
			КонецЕсли;
		Иначе 
			
			СтрокаГруппировки = СтрокаВсе.Строки.Добавить();
			СтрокаГруппировки.ОбъектГруппировки = Выборка.Ссылка;
			СтрокаГруппировки.ЭтоГруппа = Выборка.ЭтоГруппа;
			СтрокаГруппировки.Представление = Строка(Выборка.Ссылка);
			СтрокаГруппировки.КомандаСсылка = Выборка.Ссылка;
			
			Если Не Выборка.ЭтоГруппа Тогда 
				КоличествоШаблонов = КоличествоШаблонов + 1;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УдалитьПапкиБезАктивныхШаблонов(Дерево);
	
	Если Не ЭтоПоиск И ОбщееКоличествоШаблонов > 5 
		И КоличествоНедавнихШаблонов > 0 И КоличествоШаблонов > 0 Тогда 
		СтрокаВсе.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Все (%1)'"), КоличествоШаблонов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтрокуВДеревеНаПервыйЗначащийЭлемент()
	
	ЭлементыДерева = СписокШаблонов.ПолучитьЭлементы();
	Если ЭлементыДерева.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ПерваяГруппа = ЭлементыДерева[0];
	Если ПерваяГруппа.ПолучитьЭлементы().Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ПервыйЭлементПервойГруппы = ПерваяГруппа.ПолучитьЭлементы()[0];
	Индекс = ПервыйЭлементПервойГруппы.ПолучитьИдентификатор();
	Элементы.СписокШаблонов.ТекущаяСтрока = Индекс;
	
КонецПроцедуры

&НаСервере
Функция УдалитьПапкиБезАктивныхШаблонов(Дерево)
	
	ЕстьШаблоны = Ложь;
	МассивУдаляемыхГрупп = Новый Массив;
	
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.ЭтоГруппа Тогда 
			Если Не УдалитьПапкиБезАктивныхШаблонов(СтрокаДерева) Тогда 
				МассивУдаляемыхГрупп.Добавить(СтрокаДерева);
			Иначе 
				ЕстьШаблоны = Истина;
			КонецЕсли;
		Иначе 
			ЕстьШаблоны = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Группа Из МассивУдаляемыхГрупп Цикл 
		Для Каждого СтрокаДерева Из Дерево.Строки Цикл
			Если Группа = СтрокаДерева Тогда 
				Дерево.Строки.Удалить(СтрокаДерева);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ЕстьШаблоны;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ТестЦентр

&НаКлиенте
Функция ТЦСоздатьПоШаблону() Экспорт
	
	СоздатьПоШаблону(Неопределено);
	Возврат Истина;
	
КонецФункции

#КонецОбласти
