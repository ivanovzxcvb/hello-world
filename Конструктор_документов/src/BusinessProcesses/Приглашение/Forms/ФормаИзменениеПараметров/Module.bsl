
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Учет переносов сроков выполнения
	ПереносСроковВыполненияЗадач.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Сроки выполнения
	УстановитьУсловноеОформлениеИстекшихСроков();
	СрокиИсполненияПроцессов.КарточкаПроцессаПриСозданииНаСервере(
		ЭтаФорма, БизнесПроцессы.Приглашение.ТочкиМаршрута.Ознакомиться, Истина);
	
	Предметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(Объект,, Истина);
	
	ШаблоныПоПредметам.ЗагрузитьЗначения(МультипредметностьВызовСервера.ПолучитьШаблоныПоПредметам(Предметы, "ШаблоныПриглашения"));
	УстановитьДоступностьПоШаблону();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	Мультипредметность.ПроцессПриСозданииНаСервере(ЭтаФорма, Объект);
	
	ПроверятьОтсутствие = Отсутствия.ПредупреждатьОбОтсутствии();
	
	ЯвкаОбязательнаПоУмолчанию = УправлениеМероприятиями.ПолучитьПерсональнуюНастройку("ЯвкаОбязательнаПоУмолчанию");
	
	РеквизитыТабЧастиИсполнители = Объект.Ссылка.Метаданные().ТабличныеЧасти.Исполнители.Реквизиты;
	Для Каждого СтрРеквизит Из РеквизитыТабЧастиИсполнители Цикл
		РеквизитыТабЧастиИсполнителиСтрокой = РеквизитыТабЧастиИсполнителиСтрокой + "," + СтрРеквизит.Имя;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	Мультипредметность.ОбработатьОписаниеПредметовПроцесса(Объект);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(Объект.Исполнители, "Исполнитель");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Учет переноса сроков
	ПереносСроковВыполненияЗадач.ПередатьПричинуИЗаявкуНаПереносаСрока(ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Мультипредметность.ПроцессПослеЗаписиНаСервере(ЭтаФорма, Объект);
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковВТаблицеИсполнителей(
		Объект.Исполнители, ИспользоватьДатуИВремяВСрокахЗадач);
	ОбновитьПризнакиИстекшихСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоИтерацийПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.КоличествоИтерацийПриИзменении(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_СрокОбработкиРезультатовПредставление

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокОбработкиРезультатовПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокОбработкиРезультатов";
	ДопПараметры.Исполнитель = Объект.Автор;
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		СрокОбработкиРезультатовПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокОбработкиРезультатовДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокОбработкиРезультатовЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокОбработкиРезультатовМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаВариантУстановкиСрока = "ВариантУстановкиСрокаОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокОбработкиРезультатовПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.СрокиПредшественников = Объект.Исполнители;
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.Участник = Объект.Автор;
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьОтносительныйСрокУчастникаПроцесса(
		ЭтаФорма,
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		СрокОбработкиРезультатовПредставление,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		Направление,
		"СрокОбработкиРезультатов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Исполнители

&НаКлиенте
Процедура ИсполнителиПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПриАктивизацииСтроки(
		ЭтаФорма,
		Элементы.Исполнители,
		Элементы.ИсполнителиСрокИсполненияПредставление,
		ДоступностьПоШаблону);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПриНачалеРедактирования(
		ЭтаФорма, НоваяСтрока,
		Элементы.Исполнители,
		Объект.Исполнители);
		
	Если НоваяСтрока Тогда 
		ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
		ТекущиеДанные.ЯвкаОбязательна = ЯвкаОбязательнаПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПриОкончанииРедактирования(
		ЭтаФорма, НоваяСтрока, ОтменаРедактирования, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПослеУдаления(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПослеУдаления(ЭтаФорма, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Поле Исполнитель

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительПриИзменении(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительНачалоВыбора(
		ЭтаФорма, СтандартнаяОбработка,
		Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОчистка(
		СтандартнаяОбработка, Элементы.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОбработкаВыбора(
		ЭтаФорма, ВыбранноеЗначение, Элементы.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительАвтоПодбор(
		ЭтаФорма, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОкончаниеВводаТекста(
		ЭтаФорма, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Поле ИсполнителиСрокИсполненияПредставление

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеПриИзменении(Элемент)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияПоПредставлениюВТаблицеИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокИсполненияДляСтрокиТаблицыИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияВТаблицеИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Направление);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ЗначениеЗаполнено(РезультатВыполнения) Тогда
		
		СообщениеОбОшибке = НСтр("ru = 'Не заполнен комментарий'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"РезультатВыполнения");
		
		Возврат;
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПодтвержденияПереносаСрока", ЭтотОбъект);
	
	СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку(
		ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПодтвержденияПереносаСрока(Результат, Параметры) Экспорт

	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПроверкиОтсутствия", ЭтотОбъект);
	Если Не ОтсутствияКлиент.ПроверитьОтсутствиеПоПроцессу(ЭтаФорма, ОписаниеОповещения) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПроверкиОтсутствия(РезультатПроверкиОтсутствий, Параметры) Экспорт
	
	Если РезультатПроверкиОтсутствий <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Результат = СтруктураРезультата();
	
	Если Модифицированность Тогда 
		
		Если ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры <> Неопределено 
			И ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("УникальныйИдентификаторФормыИзмененияПараметров") Тогда
			ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.УникальныйИдентификаторФормыИзмененияПараметров = 
				УникальныйИдентификатор;
		КонецЕсли;
		
		ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(Объект.Исполнители, "Исполнитель");
		ОчиститьСообщения();
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("ПричинаПереносаСрока", ПричинаПереносаСрока);
		
		Если Записать(ПараметрыЗаписи) Тогда
			
			// Сроки выполнения
			СрокиИсполненияПроцессовКлиент.ОповеститьОПереносеСроков(ЭтаФорма);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Изменение:'"),
				ПолучитьНавигационнуюСсылку(Объект.Ссылка),
				Строка(Объект.Ссылка),
				БиблиотекаКартинок.Информация32);
			Результат.КодВозврата = КодВозвратаДиалога.ОК;
			Закрыть(Результат);
		КонецЕсли;
		
	Иначе
		Результат.КодВозврата = КодВозвратаДиалога.ОК;
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(СтруктураРезультата());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Исполнители

&НаКлиенте
Процедура Подобрать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПодобратьИсполнителей(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЯвкаОбязательнаДляВсех(Команда)
	
	Для Каждого Исполнитель Из Объект.Исполнители Цикл
		Исполнитель.ЯвкаОбязательна = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьЯвкаОбязательнаДляВсех(Команда)
	
	Для Каждого Исполнитель Из Объект.Исполнители Цикл
		Исполнитель.ЯвкаОбязательна = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьПоШаблону()
	
	ДоступностьПоШаблону = Истина;
	
	Если Не ЗначениеЗаполнено(Объект.Шаблон) И Не ЗначениеЗаполнено(Объект.ВедущаяЗадача) Тогда 
		Возврат;
	КонецЕсли;
	
	ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(Объект);
	
	Если Объект.Исполнители.Количество() > 0 Тогда
		
		Элементы.Исполнители.ИзменятьСоставСтрок = ДоступностьПоШаблону;
		Элементы.Исполнители.ИзменятьПорядокСтрок = ДоступностьПоШаблону;
		Для Каждого ЭлементТаблицыИсполнители Из Элементы.Исполнители.ПодчиненныеЭлементы Цикл
			ЭлементТаблицыИсполнители.ТолькоПросмотр = Не ДоступностьПоШаблону;
		КонецЦикла;
		
		Элементы.Подобрать.Доступность = ДоступностьПоШаблону;
	Иначе
		
		Элементы.Исполнители.ИзменятьСоставСтрок = Истина;
		Элементы.Исполнители.ИзменятьПорядокСтрок = Истина;
		Для Каждого ЭлементТаблицыИсполнители Из Элементы.Исполнители.ПодчиненныеЭлементы Цикл
			ЭлементТаблицыИсполнители.ТолькоПросмотр = Ложь;
		КонецЦикла;
		
		Элементы.Подобрать.Доступность = Истина;
	КонецЕсли;
	
	ПараметрыДоступности = 
		СрокиИсполненияПроцессовКлиентСервер.ПараметрыДоступностиЭлементаУправления();
	ПараметрыДоступности.ДоступностьПоШаблону = ДоступностьПоШаблону;
	
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.СрокОбработкиРезультатовПредставление,
		СрокОбработкиРезультатовПредставление,
		ПараметрыДоступности);
	
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.КоличествоИтераций,
		Объект.КоличествоИтераций,
		ПараметрыДоступности);
	
КонецПроцедуры

// Возвращает структуру результата для процедур закрытия формы.
//
&НаКлиенте
Функция СтруктураРезультата()
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("РезультатВыполнения", РезультатВыполнения);
	СтруктураРезультата.Вставить("КодВозврата", КодВозвратаДиалога.Отмена);
	СтруктураРезультата.Вставить("МестоПроведения", Объект.МестоПроведения);
	СтруктураРезультата.Вставить("ДатаНачалаМероприятия", Объект.ДатаНачалаМероприятия);
	СтруктураРезультата.Вставить("ДатаОкончанияМероприятия", Объект.ДатаОкончанияМероприятия);
	
	СтруктураРезультата.Вставить("СрокИсполненияПроцесса", Объект.СрокИсполненияПроцесса);
	
	СтруктураРезультата.Вставить("СрокОбработкиРезультатов", Объект.СрокОбработкиРезультатов);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовДни", Объект.СрокОбработкиРезультатовДни);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовЧасы", Объект.СрокОбработкиРезультатовЧасы);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовМинуты", Объект.СрокОбработкиРезультатовМинуты);
	СтруктураРезультата.Вставить("ВариантУстановкиСрокаОбработкиРезультатов", Объект.ВариантУстановкиСрокаОбработкиРезультатов);
	
	СтруктураРезультата.Вставить("ПричинаПереносаСрока", ПричинаПереносаСрока);
	
	СтруктураРезультата.Вставить("КоличествоИтераций", Объект.КоличествоИтераций);
	
	СтруктураРезультата.Вставить("Исполнители", Новый Массив);
	
	Для Каждого СтрИсполнитель Из Объект.Исполнители Цикл
		СтруктураСтрИсполнителя = Новый Структура(РеквизитыТабЧастиИсполнителиСтрокой);
		ЗаполнитьЗначенияСвойств(СтруктураСтрИсполнителя, СтрИсполнитель);
		СтруктураРезультата.Исполнители.Добавить(СтруктураСтрИсполнителя);
	КонецЦикла;
	
	Возврат СтруктураРезультата;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ТестЦентр

&НаКлиенте
Процедура ТЦВыполнитьКомандуОК() Экспорт
	
	ОК(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_СрокиИсполненияПроцессов

// Заполняет представление сроков в карточке процесса
//
&НаСервере
Процедура ОбновитьСрокиИсполненияНаСервере() Экспорт
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчетаДляРасчетаСроков;
	ПараметрыДляРасчетаСроков.РеквизитТаблицаСИзмененнымСроком = РеквизитТаблицаСИзмененнымСроком;
	ПараметрыДляРасчетаСроков.ИндексСтроки = ИндексСтрокиСИзмененнымСроком;
	ПараметрыДляРасчетаСроков.ТекущаяИтерация = Объект.НомерИтерации + 1;
	ПараметрыДляРасчетаСроков.ЗаполнятьСрокПроцессаТолькоПриПревышении = Истина;
	
	СрокиИсполненияПроцессовКОРП.РассчитатьСрокиПриглашения(Объект, ПараметрыДляРасчетаСроков);
	
	СрокиИсполненияПроцессов.ПроверитьИзменениеСроковВФормеПроцесса(ЭтаФорма);
		
	РеквизитТаблицаСИзмененнымСроком = "";
	ИндексСтрокиСИзмененнымСроком = 0;
	
	ОбновитьПризнакиИстекшихСроков();
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// см. ОбновитьСрокиИсполненияНаСервере
&НаКлиенте
Процедура ОбновитьСрокиИсполнения()
	
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// см. ОбновитьСрокиИсполнения
&НаКлиенте
Процедура ОбновитьСрокиИсполненияОтложенно(РеквизитТаблица = "", ИндексСтроки = 0) Экспорт
	
	РеквизитТаблицаСИзмененнымСроком = РеквизитТаблица;
	ИндексСтрокиСИзмененнымСроком = ИндексСтроки;
	
	ПодключитьОбработчикОжидания("ОбновитьСрокиИсполнения", 0.2, Истина);
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроковИсполнения() Экспорт
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// Устанавливает условное оформление истекших сроков.
//
&НаСервере
Процедура УстановитьУсловноеОформлениеИстекшихСроков()
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения истек (Исполнители)'"),
		"Объект.Исполнители.СрокИсполненияИстек",
		"ИсполнителиСрокИсполненияПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок обработки результатов истек'"),
		"СрокОбработкиРезультатовИстек",
		"СрокОбработкиРезультатовПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения процесса истек'"),
		"СрокИсполненияПроцессаИстек",
		"СрокИсполненияПроцессаПредставление");
	
КонецПроцедуры

// Обновляет признаки истекших сроков в карточке.
//
&НаСервере
Процедура ОбновитьПризнакиИстекшихСроков()
	
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшихСроковВТаблицеИсполнителей(
		Объект.Исполнители, ТекущаяДатаСеанса());
	
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаУчастника(
		Объект.СрокОбработкиРезультатов, СрокОбработкиРезультатовИстек, ТекущаяДатаСеанса());
		
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаПроцесса(
		Объект.СрокИсполненияПроцесса, Объект.ДатаЗавершения, СрокИсполненияПроцессаИстек);
	
КонецПроцедуры

#КонецОбласти
