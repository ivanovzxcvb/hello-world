
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РезультатыПриглашенияПринято = Перечисления.РезультатыПриглашения.Принято;
	РезультатыПриглашенияНеПринято = Перечисления.РезультатыПриглашения.НеПринято;
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект);
	
	ДатаНачалаМероприятия = Объект.БизнесПроцесс.ДатаНачалаМероприятия;
	ДатаОкончанияМероприятия = Объект.БизнесПроцесс.ДатаОкончанияМероприятия;
	МестоПроведения = Объект.БизнесПроцесс.МестоПроведения;
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Объект.Ссылка,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
		
	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.Принято.Доступность = Ложь;
		Элементы.Отклонено.Доступность = Ложь;
		
		Элементы.ДеревоПриложений.ИзменятьПорядокСтрок = Ложь;
		Элементы.ДеревоПриложений.ИзменятьСоставСтрок = Ложь;
		
		Элементы.Перенаправить.Доступность = Ложь;
		Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
		Элементы.ИзменитьДатуВыполнения.Доступность = Ложь;
	КонецЕсли;
	
	Если Объект.СостояниеБизнесПроцесса <> Перечисления.СостоянияБизнесПроцессов.Активен
		Или Объект.Выполнена Тогда
		
		Элементы.ДеревоПриложений.ИзменятьПорядокСтрок = Ложь;
		Элементы.ДеревоПриложений.ИзменятьСоставСтрок = Ложь;
	КонецЕсли;
	
	ИспользоватьРабочийКалендарь = ПолучитьФункциональнуюОпцию("ИспользоватьРабочийКалендарь");
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыРеквизитыНевыполненныхЗадач" И Параметр = Объект.БизнесПроцесс И Не Объект.Выполнена Тогда 
		
		ДатаИсполнения = Объект.ДатаИсполнения;
		Прочитать();
		Объект.ДатаИсполнения = ДатаИсполнения;
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "ФайлЗанятДляРедактирования" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" И Параметр.ИдентификаторРодительскойФормы = УникальныйИдентификатор Тогда
		
		МультипредметностьВызовСервера.ОбработатьДобавлениеПредметаЗадачи(
			Объект.Ссылка, Объект.БизнесПроцесс, Параметр.Файл, УникальныйИдентификатор);
			
		Прочитать();
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "СозданНовыйВопросВыполненияЗадачи" И Параметр = Объект.Ссылка Тогда
		
		БизнесПроцессыИЗадачиКлиентСервер.ЗаполнитьЗаголовокКомандыЗадатьВопрос(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма Тогда
		
		ПрочитатьДанныеЗадачиВФорму = Ложь;
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			ПрочитатьДанныеЗадачиВФорму = Параметр.Найти(Объект.Ссылка) <> Неопределено;
		Иначе
			ПрочитатьДанныеЗадачиВФорму = (Параметр = Объект.Ссылка);
		КонецЕсли;
		
		Если ПрочитатьДанныеЗадачиВФорму Тогда
			Прочитать();
		КонецЕсли;
		
		КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "Перенаправление_ЗадачаИсполнителя" И Источник = Объект.Ссылка Тогда
		Закрыть();
		
	КонецЕсли;
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Мультипредметность.ИзмененыПредметыЗадачи(Объект.Ссылка) Тогда
			ОбновитьДеревоПриложенийСервер();
		КонецЕсли;
	КонецЕсли;
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	
	Если Не Объект.Выполнена Тогда
		Объект.ДатаИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПередЗаписьюНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	Если ПараметрыЗаписи.Свойство("ВыполнитьЗадачу") И ПараметрыЗаписи.ВыполнитьЗадачу Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		ПриглашениеОбъект = ТекущийОбъект.БизнесПроцесс.ПолучитьОбъект();
		ПриглашениеОбъект.ДополнительныеСвойства.Вставить("ТекущаяЗадача",ТекущийОбъект.Ссылка);
		ПриглашениеОбъект.ДополнительныеСвойства.Вставить("РезультатПриглашения",ПараметрыЗаписи.РезультатПриглашения);
		ЗаблокироватьДанныеДляРедактирования(ПриглашениеОбъект.Ссылка);
		РаботаСБизнесПроцессами.ЗаписатьПроцесс(ПриглашениеОбъект, "ЗаписьСОбработкойВыполненияЗадачи");
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыФоновогоВыполнения = Новый Структура;
	
	Если ПараметрыЗаписи.Свойство("ВыполнитьЗадачуФоново")
		И ПараметрыЗаписи.ВыполнитьЗадачуФоново Тогда
	
		ПараметрыФоновогоВыполнения.Вставить("РезультатПриглашения",
			ПараметрыЗаписи.РезультатПриглашения);
	КонецЕсли;
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриЗаписиНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи, ПараметрыФоновогоВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗадачаИзменена", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ОбзорЗадачКлиент.ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопрос(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ЗадатьВопрос(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСИнструкциямиКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Элемент.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "РезультатВыполнения",
		ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ЗадачаПригласить"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДеревоПриложений

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоПриложений.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяПредмета) И НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура();
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ДеревоПриложенийВыборПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);         
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета, ТекущиеДанные.Ссылка, СтандартнаяОбработка, ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	Иначе
		РаботаСБизнесПроцессамиКлиент.ДеревоПриложенийВыбор(
			ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийВыборПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("Предмет", НСтр("ru = 'Предмет'"));
	СписокВыбора.Добавить("Файл", НСтр("ru = 'Файл'"));
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ДеревоПриложенийПередНачаломДобавления_Завершение", ЭтаФорма);
	
	СписокВыбора.ПоказатьВыборЭлемента(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления_Завершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Предмет = Неопределено;
	
	Если РезультатВыбора.Значение = "Файл" Тогда
		Предмет = ПредопределенноеЗначение("Справочник.Файлы.ПустаяСсылка");
	КонецЕсли;
	
	ДеревоПриложенийДобавлениеНаКлиенте(Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтаФорма.ТолькоПросмотр Или Элементы.ДеревоПриложений.ТолькоПросмотр Или Объект.Выполнена Тогда 
		Возврат;
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Перенаправить(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.Перенаправить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтаФорма, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(, Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПереключитьХронометраж(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ДатаОтчета = ТекущаяДата();
	Если Объект.Выполнена Тогда
		ДатаОтчета = Объект.ДатаИсполнения;
	КонецЕсли;	
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		Объект.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Объект.Выполнена,
		ЭтаФорма); 
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДатуВыполнения(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ИзменитьДатуВыполнения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	
	ПараметрыФормы = Новый Структура("ЗадачаСсылка", Объект.Ссылка);
	ОткрытьФорму("БизнесПроцесс.Приглашение.Форма.ФормаИсторияПриглашения", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьИнструкции(Команда)
	
	ПоказыватьИнструкции = Не ПоказыватьИнструкции;
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура Принято(Команда, ОбработанныеВопросы = Неопределено)
	
	Если РаботаСБизнесПроцессамиКлиент.ЗапретВыполненияИзФормы(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Команда", Команда);
	ДопПараметры.Вставить("ОбработанныеВопросы", ОбработанныеВопросы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПринятоПослеВыбораФактическогоИсполнителя", ЭтаФорма, ДопПараметры);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьИсполнителяЗадачи(
		ЭтаФорма,
		Объект.Исполнитель,
		ТекущийПользователь,
		ФактическийИсполнительЗадачи,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПринятоПослеВыбораФактическогоИсполнителя(
	ВыбранныйФактическийИсполнитель, ДопПараметры) Экспорт
	
	Если ВыбранныйФактическийИсполнитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйФактическийИсполнитель <> Объект.Исполнитель Тогда
		ФактическийИсполнительЗадачи = ВыбранныйФактическийИсполнитель;
	КонецЕсли;
	
	Команда = ДопПараметры.Команда;
	ОбработанныеВопросы = ДопПараметры.ОбработанныеВопросы;
	
	Если ОбработанныеВопросы = Неопределено Тогда
		ОбработанныеВопросы = Новый Структура;
	КонецЕсли;
	
	Если Не ОбработанныеВопросы.Свойство("ЗанятостьИсполнителей") Тогда
		
		ИсключенияЗанятости = Новый Массив;
		Для Каждого Предмет Из Объект.Предметы Цикл
			Если Предмет.РольПредмета = ПредопределенноеЗначение("Перечисление.РолиПредметов.Основной")
				И ТипЗнч(Предмет.Предмет) = Тип("СправочникСсылка.Мероприятия") Тогда 
				ИсключенияЗанятости.Добавить(Предмет.Предмет);
			КонецЕсли;
		КонецЦикла;
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Команда", Команда);
		ПараметрыОбработчика.Вставить("ОбработанныеВопросы", ОбработанныеВопросы);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПринятоЗавершениеВопросаОЗанятостиПользователя",
			ЭтотОбъект,
			ПараметрыОбработчика);
		
		Если Не РаботаСРабочимКалендаремКлиент.ПроверитьДоступностьПользователей(
				Объект.Исполнитель, ДатаНачалаМероприятия, ДатаОкончанияМероприятия,
				ИспользоватьРабочийКалендарь, ИсключенияЗанятости, Истина, ОписаниеОповещения) Тогда
			Возврат;
		КонецЕсли;
		
		ОбработанныеВопросы.Вставить("ЗанятостьИсполнителей", Истина);
		
	КонецЕсли;
	
	Если МультипредметностьКлиент.ПроверитьЗаполнениеПредметовЗадачи(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы",
		ЭтотОбъект, Истина);
		
	РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НеПринято(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиНеПринятоПослеВыбораФактическогоИсполнителя", ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьИсполнителяЗадачи(
		ЭтаФорма,
		Объект.Исполнитель,
		ТекущийПользователь,
		ФактическийИсполнительЗадачи,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиНеПринятоПослеВыбораФактическогоИсполнителя(
	ВыбранныйФактическийИсполнитель, ДопПараметры) Экспорт
	
	Если ВыбранныйФактическийИсполнитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйФактическийИсполнитель <> Объект.Исполнитель Тогда
		ФактическийИсполнительЗадачи = ВыбранныйФактическийИсполнитель;
	КонецЕсли;
	
	Если МультипредметностьКлиент.ПроверитьЗаполнениеПредметовЗадачи(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Комментарий"" не заполнено'"),,"Объект.РезультатВыполнения");
		Возврат;	
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы",
		ЭтотОбъект, Ложь);
		
	РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятоЗавершениеВопросаОЗанятостиПользователя(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.ОбработанныеВопросы.Вставить("ЗанятостьИсполнителей", Истина);
	Принято(ДополнительныеПараметры.Команда, ДополнительныеПараметры.ОбработанныеВопросы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы(Результат, ПриглашениеПринято) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПриглашениеПринято Тогда
		КлючеваяОперация = "ПриглашениеВыполнениеКомандыПринято";
		РезультатПриглашения = РезультатыПриглашенияПринято;
		ИмяСобытия = "ПриглашениеПринято";
	Иначе
		КлючеваяОперация = "ПриглашениеВыполнениеКомандыНеПринято";
		РезультатПриглашения = РезультатыПриглашенияНеПринято;
		ИмяСобытия = "ПриглашениеОтклонено";
	КонецЕсли;
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
		
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("РезультатПриглашения", РезультатПриглашения);
	
	Если Не ВыполнениеЗадачКлиент.ВыполнитьЗадачуИзФормы(ЭтаФорма, ПараметрыЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект, ИмяСобытия);
	
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВводаВремени(Результат, ИмяСобытия) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
		
	ОсновныеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(Объект,, Истина);
	Для Каждого Предмет Из ОсновныеПредметы Цикл
		Оповестить(ИмяСобытия, Предмет);
	КонецЦикла;
		
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Подзадачи

&НаКлиенте
Процедура ПроцессСогласование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Согласование", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессУтверждение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Утверждение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессРегистрация(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Регистрация", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессРассмотрение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Рассмотрение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Исполнение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомление(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Ознакомление", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессПриглашение(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Приглашение", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОбработка(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"КомплексныйПроцесс", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_РаботаСФлагами

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		БиблиотекаКартинок.КрасныйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		БиблиотекаКартинок.СинийФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		БиблиотекаКартинок.ЖелтыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		БиблиотекаКартинок.ЗеленыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		БиблиотекаКартинок.ОранжевыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		БиблиотекаКартинок.ЛиловыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.ПустаяСсылка"),
		БиблиотекаКартинок.ПустойФлаг);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_ДеревоПриложений

&НаКлиенте
Процедура ДобавитьПредмет(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте(ПредопределенноеЗначение("Справочник.Файлы.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДляПросмотра(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьТекущийФайлДляПросмотра(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.РедактироватьТекущийФайл(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗакончитьРедактированиеТекущегоФайла(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	РаботаСБизнесПроцессамиКлиент.СохранитьТекущийФайл(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура КомандаОбновитьДеревоПриложений(Команда)
	
	ОбновитьДеревоПриложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеПриложения(Команда)
	
	ОтображатьУдаленныеПриложения = Не ОтображатьУдаленныеПриложения;
	Элементы.ДеревоПриложенийКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленныеПриложения;
	
	ТекущаяСсылкаВДереве = Неопределено;
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
	КонецЕсли;	
	
	ОтображатьУдаленныеПриложенияСервер();
	
	Если ТекущаяСсылкаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве);
	КонецЕсли;	
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 70, 100);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма,
		РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ДеревоПриложений

&НаСервере
Процедура ОтображатьУдаленныеПриложенияСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьДеревоПриложений(ЭтаФорма);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		ИмяФормы,
		"ОтображатьУдаленныеПриложения",
		ОтображатьУдаленныеПриложения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоПриложений(ТекущееИмяПредметаВДереве = Неопределено)
	
	ТекущаяСсылкаВДереве = Неопределено;
	
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено И ТекущееИмяПредметаВДереве = Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
		ТекущееИмяПредметаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.ИмяПредмета;
	КонецЕсли;
	
	Если Элементы.Найти("ДеревоПриложений") <> Неопределено  Тогда
		ОбновитьДеревоПриложенийСервер();
	КонецЕсли;
	
	Если ТекущаяСсылкаВДереве <> Неопределено ИЛИ ТекущееИмяПредметаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве, ТекущееИмяПредметаВДереве);
	КонецЕсли;
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоПриложенийСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьДеревоПриложений(ЭтаФорма);
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьПредметСервер()
	
	Мультипредметность.УстановитьЗначенияДопРеквизитовИДоступностьЭлементовФормыПроцесса(ЭтаФорма, Объект);
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиенте(Предмет = Неопределено)

	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	НовыйИмяПредмета = Неопределено;
	
	ПараметрыОбработчикаОповещения = Новый Структура();
	ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийВыборПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, НовыйИмяПредмета, Предмет,,ОписаниеОповещения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиенте()
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	Иначе
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура;
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьКарточкуНаКлиентеПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(
			ЭтаФорма,
			СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета,
			ТекущиеДанные.Ссылка,,
			ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиенте()
	
	ВыделенныеСтрокиПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из Элементы.ДеревоПриложений.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ДеревоПриложений.ДанныеСтроки(ВыделеннаяСтр);
		ВыделенныеСтрокиПредметов.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийУдалениеНаКлиентеПродолжение",
		ЭтотОбъект,
		ВыделенныеСтрокиПредметов);
		
	МультипредметностьКлиент.ПолученоПодтверждениеОбУдаленииПредмета(Объект, ВыделенныеСтрокиПредметов, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиентеПродолжение(Результат, ВыделенныеСтрокиПредметов) Экспорт
	
	Если Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	
	ИменаУдаляемыхПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из ВыделенныеСтрокиПредметов Цикл
		Если ВыделеннаяСтр.ДоступноУдаление Тогда
			ИменаУдаляемыхПредметов.Добавить(ВыделеннаяСтр.ИмяПредмета);
		КонецЕсли;
	КонецЦикла;
	
	Если ИменаУдаляемыхПредметов.Количество() = 0 Тогда
		
		КоличествоВыделенныхСтрок = ВыделенныеСтрокиПредметов.Количество();
		Если КоличествоВыделенныхСтрок = 1 Тогда
			ТекстСообщения = НСтр("ru = 'Удалить текущий предмет можно только в карточке процесса.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Удалить выделенные предметы можно только в карточке процесса.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	Если Не МультипредметностьКлиент.УдалитьПредметыЗадачи(ЭтаФорма, СообщениеОбОшибке, ИменаУдаляемыхПредметов) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	ОбновитьДеревоПриложений();
	УстановитьПредметСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Хронометраж

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	УчетВремени.ПереключитьХронометражСервер(
	ПараметрыОповещения,
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ВидыРабот,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
		ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	УчетВремени.ОтключитьХронометражСервер(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

#КонецОбласти
