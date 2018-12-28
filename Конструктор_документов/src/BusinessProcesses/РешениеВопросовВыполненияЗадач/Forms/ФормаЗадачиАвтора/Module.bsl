
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Запись истории по данной задаче
	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.КомандаРассмотрено.Доступность = Ложь;
		Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;	
	
	// Общие действия при создании карточки задачи
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект);
	
	// Инициализация учета времени
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
	
	// Инициализация реквизитов карточки
	ПредметРассмотрения = Объект.БизнесПроцесс.ПредметРассмотрения;
	БизнесПроцессПредметаРассмотрения = Объект.БизнесПроцесс.ПредметРассмотрения.БизнесПроцесс;
	НаименованиеПроцессаПредметаРассмотренияГиперссылка = БизнесПроцессПредметаРассмотрения.Наименование;
		
	// Инициализация списка файлов
	Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.БизнесПроцесс.Ссылка);
	Файлы.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Файлы);
	ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		
		// Подсистема "Свойства"
		ОбновитьЭлементыДополнительныхРеквизитов();
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		
		Элементы.Файлы.Обновить();
		ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			Элементы.Файлы.ТекущаяСтрока = Параметр.Файл;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ВладелецФайла = Неопределено;
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("Владелец")
			 И ЗначениеЗаполнено(Параметр.Владелец)  Тогда
			ВладелецФайла = Параметр.Владелец;
		Иначе	
			ВладелецФайла = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Источник, "ВладелецФайла");
		КонецЕсли;	
		Если ВладелецФайла = Объект.Ссылка Тогда
			Элементы.Файлы.Обновить();
			ОбновитьДоступностьКомандСпискаФайлов();
			ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
		КонецЕсли;	
		
	ИначеЕсли ИмяСобытия = "ФайлЗанятДляРедактирования" Тогда
		
		Элементы.Файлы.Обновить();
		ОбновитьДоступностьКомандСпискаФайлов();
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
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
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПередЗаписьюНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриЗаписиНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеПараметра = Файлы.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВладелецФайла"));
	Если Не ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда 
		Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.Ссылка);
	КонецЕсли;
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗадачаИзменена", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ОбзорЗадачКлиент.ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметРассмотренияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ПредметРассмотрения);
	
КонецПроцедуры

&НаКлиенте
Процедура БизнесПроцессПредметаРассмотренияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, БизнесПроцессПредметаРассмотрения);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "РезультатВыполнения",
		ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ЗадачаРешениеВопросовРассмотреть"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Файлы

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
	ВыбраннаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаРедактирования", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(Обработчик, ДанныеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаРедактирования(Результат, ПараметрыВыполнения) Экспорт
	
	РезультатОткрыть = "Открыть";
	РезультатРедактировать = "Редактировать";
	РезультатОткрытьКарточку = "ОткрытьКарточку";
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект, ПараметрыВыполнения);
	
	Если Результат = РезультатРедактировать Тогда
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	ИначеЕсли Результат = РезультатОткрытьКарточку Тогда
		ПоказатьЗначение(, ПараметрыВыполнения.ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	
	ОбновитьДоступностьКомандСпискаФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ДобавитьФайл(Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Файлы.ТолькоПросмотр Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;	
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
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
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
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
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРассмотрено(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВыбораФактическогоИсполнителя", ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьИсполнителяЗадачи(
		ЭтаФорма,
		Объект.Исполнитель,
		ТекущийПользователь,
		ФактическийИсполнительЗадачи,
		ОписаниеОповещения);
	
КонецПроцедуры

	&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВыбораФактическогоИсполнителя(
	ВыбранныйФактическийИсполнитель, ДопПараметры) Экспорт
	
	Если ВыбранныйФактическийИсполнитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйФактическийИсполнитель <> Объект.Исполнитель Тогда
		ФактическийИсполнительЗадачи = ВыбранныйФактическийИсполнитель;
	КонецЕсли; 
	
	Отказ = Ложь;
	
	// Проверка заполнения обязательных полей
	ОчиститьСообщения();
	Если НЕ ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда
		Текст = НСтр("ru = 'Поле ""Комментарий"" не заполнено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			,
			"Объект.РезультатВыполнения",
			,Отказ);			
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// Конец проверки заполнения обязательных полей
	
	Если Не ВыполнениеЗадачКлиент.ВыполнитьЗадачуИзФормы(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект);
	
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВводаВремени(Результат, Параметры) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфера(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда 
		
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	КомпонентаУстановлена = РаботаСКартинкамиКлиент.ПроинициализироватьКомпоненту();
	Если Не КомпонентаУстановлена Тогда
		
		Обработчик = Новый ОписаниеОповещения("ВставитьКартинкуИзБуфераЗавершение", ЭтотОбъект);		
		РаботаСКартинкамиКлиент.УстановитьКомпоненту(Обработчик);
		Возврат;
		
	КонецЕсли;
	
	ВставитьКартинкуИзБуфераЗавершение(Истина, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфераЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат = Истина Тогда
		
		ПутьКФайлу = КомпонентаПолученияКартинкиИзБуфера.ПолучитьКартинкуИзБуфера();
	
		Если Не ПустаяСтрока(ПутьКФайлу) Тогда
			
			НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
			РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(
				ПутьКФайлу, Объект.БизнесПроцесс, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
				
		Иначе
			ПоказатьПредупреждение(,НСтр("ru = 'Буфер обмена не содержит картинки'"));
		КонецЕсли;
	
	КонецЕсли;	
	
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

#Область ОбработчикиКомандФормы_Файлы

&НаКлиенте
Процедура КомандаДобавитьФайл(Команда)
	
	ДобавитьФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаИРабочийКаталог(Элементы.Файлы.ТекущаяСтрока);
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Обработчик,
		ДанныеФайла, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Объект.Ссылка.Пустая()
		И Элементы.ФайлыДобавленные.ТекущаяСтрока <> Неопределено Тогда
		Если ЭтоАдресВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть) Тогда 
			ТекущийФайлВСпискеДобавленных = ПолучитьИзВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть).Ссылка;
			Записать();
		Иначе			
			РаботаСФайламиКлиент.ЗапуститьПриложениеПоИмениФайла(
				Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть);
		КонецЕсли;	
	Иначе
		Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
		РаботаСФайламиКлиент.РедактироватьСОповещением(Обработчик, Элементы.Файлы.ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
		
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, 
		Элементы.Файлы.ТекущаяСтрока, ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;
	ПараметрыОбновленияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
	ПараметрыОбновленияФайла.Редактирует = ТекущиеДанные.Редактирует;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ЗанятьСОповещением(Обработчик, Элементы.Файлы.ТекущаяСтрока);	
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
		
	ПараметрыОсвобожденияФайла = РаботаСФайламиКлиент.ПараметрыОсвобожденияФайла(Обработчик, 
		Элементы.Файлы.ТекущаяСтрока);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;	
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	РаботаСФайламиКлиент.СохранитьИзмененияФайлаСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока, 
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеФайлы(Команда)
	
	ОтображатьУдаленныеФайлыСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

#Область СлужебныеПроцедурыИФункции_Файлы

&НаКлиенте
Процедура ОбновитьДоступностьКомандСпискаФайлов(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	УстановитьДоступностьКоманд(Элементы.Файлы.ТекущиеДанные);
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьДоступностьКоманды(Команда, Доступность)
	
	Команда.Доступность = Доступность;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда 
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Ложь);	
	Иначе	
		РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
		Редактирует = ТекущиеДанные.Редактирует;
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, НЕ ТекущиеДанные.ПодписанЭП);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Не Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Истина);		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтображатьУдаленныеФайлыСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаБизнесПроцессаОтображатьУдаленныеФайлы(ЭтаФорма);
	ОбновитьВидимостьТаблицыФайлов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Копирование = Ложь)
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайла = Объект.БизнесПроцесс;
	ФайлОснование = Элементы.Файлы.ТекущаяСтрока;
	
	Если Не Копирование Тогда
		Попытка
			РежимСоздания = 1;
			РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, ВладелецФайла, ЭтаФорма, РежимСоздания, Истина);
		Исключение
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка создания нового файла: %1'"),
				КраткоеПредставлениеОшибки(Инфо)));
		КонецПопытки;
	Иначе
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	КонецЕсли;
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьТаблицыФайлов(Форма)
	
	Параметр = Форма.Файлы.Параметры.Элементы.Найти("ОтображатьУдаленные");
	ОтображатьУдаленные = Параметр.Значение И Параметр.Использование;
	
	КоличествоФайлов = КоличествоФайлов(Форма.Объект.БизнесПроцесс, ОтображатьУдаленные);
	
	Если КоличествоФайлов > 0 Тогда
		Форма.Элементы.Файлы.Видимость = Истина;
	Иначе
		Форма.Элементы.Файлы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоФайлов(ВладелецФайла, ОтображатьУдаленные)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.Ссылка
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.ВладелецФайла = &ВладелецФайла
		|	И (&ОтображатьУдаленные
		|			ИЛИ НЕ Файлы.ПометкаУдаления)";
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	Запрос.УстановитьПараметр("ОтображатьУдаленные", ОтображатьУдаленные);
	
	Возврат Запрос.Выполнить().Выбрать().Количество();
	
КонецФункции

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
