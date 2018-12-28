
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкаЭДО = "";
	Если Параметры.Свойство("НастройкаЭДО", НастройкаЭДО) И ЗначениеЗаполнено(НастройкаЭДО) Тогда
		ПараметрыНастроекЭДО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаЭДО,
			"Организация, Контрагент, СтатусПодключения, ТекстПриглашения,
			|ЭлектроннаяПочтаДляПриглашения, ИсходящиеДокументы");
			
		ИсходящиеДокументы = ПараметрыНастроекЭДО.ИсходящиеДокументы.Выгрузить();
		
		Отбор = Новый Структура;
		Отбор.Вставить("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском);
		НайденныеСтроки = ИсходящиеДокументы.НайтиСтроки(Отбор);
		Если Не ЗначениеЗаполнено(НайденныеСтроки) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО);
			НайденныеСтроки = ИсходящиеДокументы.НайтиСтроки(Отбор);
		КонецЕсли;
		
		// Для исходящих и входящих приглашений заполнение полей отличается.
		СтатусПодключения  = ПараметрыНастроекЭДО.СтатусПодключения;
		Если СтатусПодключения = Перечисления.СтатусыУчастниковОбменаЭД.ТребуетсяПригласить
			ИЛИ СтатусПодключения = Перечисления.СтатусыУчастниковОбменаЭД.Отсоединен
			ИЛИ СтатусПодключения = Перечисления.СтатусыУчастниковОбменаЭД.Ошибка
			ИЛИ СтатусПодключения = Перечисления.СтатусыУчастниковОбменаЭД.ОжидаемСогласия Тогда
			
			Отправитель      = ПараметрыНастроекЭДО.Организация;
			Получатель       = ПараметрыНастроекЭДО.Контрагент;
			Если Не ЗначениеЗаполнено(ПараметрыНастроекЭДО.ЭлектроннаяПочтаДляПриглашения) Тогда
				ЭлектроннаяПочта = ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(
					ПараметрыНастроекЭДО.Контрагент);
			Иначе
				ЭлектроннаяПочта = ПараметрыНастроекЭДО.ЭлектроннаяПочтаДляПриглашения;
			КонецЕсли;
			
		ИначеЕсли СтатусПодключения = Перечисления.СтатусыУчастниковОбменаЭД.ТребуетсяСогласие
			ИЛИ СтатусПодключения = Перечисления.СтатусыУчастниковОбменаЭД.Присоединен Тогда
			Отправитель              = ПараметрыНастроекЭДО.Контрагент;
			Получатель               = ПараметрыНастроекЭДО.Организация;
			ИдентификаторКонтрагента = НайденныеСтроки[0].ИдентификаторКонтрагента;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыНастроекЭДО.ТекстПриглашения) И Не ЗначениеЗаполнено(НастройкаЭДО) Тогда
			ТекстПриглашения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НайденныеСтроки[0].ПрофильНастроекЭДО,
				"ШаблонТекстаПриглашений");
		Иначе
			ТекстПриглашения = ПараметрыНастроекЭДО.ТекстПриглашения;
		КонецЕсли;
		ПрофильНастроекЭДО   = НайденныеСтроки[0].ПрофильНастроекЭДО;
		
		Параметры.Свойство("ФормаОткрытаИзНастройкиЭДО", ФормаОткрытаИзНастройкиЭДО);
		Параметры.Свойство("Принять",                    Принять);
		Параметры.Свойство("Отклонить",                  Отклонить);
		
		ШаблонНастройкиЭДО = НСтр("ru = 'Настройка ЭДО с контрагентом %1'");
		ТекстНастройкиЭДО  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНастройкиЭДО,
			ПараметрыНастроекЭДО.Контрагент);
		Элементы.ДекорацияНастройкаЭДО.Заголовок = ТекстНастройкиЭДО;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ФормаОткрытаИзНастройкиЭДО Тогда
		Элементы.ДекорацияНастройкаЭДО.Видимость = Ложь;
	КонецЕсли;
	
	Если Форма.СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.ТребуетсяПригласить")
		ИЛИ Форма.СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.Ошибка")
		ИЛИ Форма.СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.Отсоединен") Тогда
		Элементы.Идентификатор.Видимость = Ложь;
		Элементы.ГруппаКнопокТребуетсяСогласие.Видимость = Ложь;
		
	ИначеЕсли Форма.СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.ОжидаемСогласия") Тогда
		
		Элементы.Идентификатор.Видимость = Ложь;
		Элементы.ГруппаКнопокТребуетсяСогласие.Видимость   = Ложь;
		Элементы.ГруппаКнопокТребуетсяПригласить.Видимость = Ложь;
		Элементы.ТекстПриглашения.Доступность = Ложь;
		Элементы.ЭлектроннаяПочта.Доступность = Ложь;
		Элементы.КнопкаОтмена.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли Форма.СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.ТребуетсяСогласие")
		ИЛИ Форма.СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.Присоединен") Тогда
		
		Элементы.ЭлектроннаяПочта.Видимость = Ложь;
		Элементы.ТекстПриглашения.Видимость = Ложь;
		Элементы.ГруппаКнопокТребуетсяПригласить.Видимость = Ложь;
		
		Элементы.КнопкаПринять.КнопкаПоУмолчанию = Истина;
		Если Форма.Принять Тогда
			Элементы.КнопкаОтклонить.Видимость       = Ложь;
		КонецЕсли;
		Если Форма.Отклонить Тогда
			Элементы.КнопкаПринять.Видимость           = Ложь;
			Элементы.КнопкаОтклонить.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура ДекорацияНастройкаЭДОНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",           НастройкаЭДО);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандФормы

&НаКлиенте
Процедура ОтправитьПриглашение(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОтправитьПриглашениеОповещение", ЭтотОбъект);
	ЗаполнитьМаркер(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьПриглашение(Команда)
	
	ОчиститьСообщения();
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ПринятьПриглашениеОповещение", ЭтотОбъект);
	ЗаполнитьМаркер(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьПриглашение(Команда)
	
	ОчиститьСообщения();
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОтклонитьПриглашениеОповещение", ЭтотОбъект);
	ЗаполнитьМаркер(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
Процедура ОбновитьНастройкиЭДО(НастройкаЭДО)
	
	ИскомаяНастройкаЭДО = НастройкаЭДО.ПолучитьОбъект();
	ИскомаяНастройкаЭДО.ЭлектроннаяПочтаДляПриглашения = ЭлектроннаяПочта;
	ИскомаяНастройкаЭДО.ТекстПриглашения               = ТекстПриглашения;
	ИскомаяНастройкаЭДО.СтатусПодключения              = СтатусПодключения;
	ИскомаяНастройкаЭДО.СостояниеСоглашения            = СостояниеСоглашения;
	ИскомаяНастройкаЭДО.ОписаниеОшибки                 = "";
	ОбменСКонтрагентамиВнутренний.ОбновитьДатуИзмененияСтатуса(ИскомаяНастройкаЭДО);
	ИскомаяНастройкаЭДО.Записать();
	
КонецПроцедуры

&НаСервере
Функция ПринятьОтклонитьКонтактЧерезОператораЭДОНаСервере(Идентификатор, ПриглашениеПринято, Маркер)
	
	Результат = Ложь;
	
	ИскомаяНастройкаЭДО = НастройкаЭДО.ПолучитьОбъект();
	Если ИскомаяНастройкаЭДО.НастройкаЭДОУникальна() Тогда
		Результат = ОбменСКонтрагентамиВнутренний.ПринятьОтклонитьКонтактЧерезОператораЭДО(Идентификатор, ПриглашениеПринято,
		Маркер, ПрофильНастроекЭДО);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОтправитьПриглашенияСервер(ОтправленоПриглашений, Маркер)
	
	// Готовим таблицу с реквизитами контрагентов.
	ТаблицаПриглашений = Новый ТаблицаЗначений;
	ТаблицаПриглашений.Колонки.Добавить("ПрофильНастроекЭДО");
	ТаблицаПриглашений.Колонки.Добавить("НастройкаЭДО");
	ТаблицаПриглашений.Колонки.Добавить("Получатель");
	ТаблицаПриглашений.Колонки.Добавить("Наименование");
	ТаблицаПриглашений.Колонки.Добавить("НаименованиеДляСообщенияПользователю");
	ТаблицаПриглашений.Колонки.Добавить("ИНН");
	ТаблицаПриглашений.Колонки.Добавить("КПП");
	ТаблицаПриглашений.Колонки.Добавить("АдресЭП");
	ТаблицаПриглашений.Колонки.Добавить("ТекстПриглашения");
	ТаблицаПриглашений.Колонки.Добавить("ВнешнийКод");
	
	ИмяРеквизитаИННКонтрагента = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННКонтрагента");
	ИмяРеквизитаКППКонтрагента = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППКонтрагента");
	ИмяРеквизитаНаименованиеКонтрагента = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("НаименованиеКонтрагента");
	ИмяРеквизитаВнешнийКодКонтрагента = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ВнешнийКодКонтрагента");
	ИмяРеквизитаНаименованиеКонтрагентаДляСообщенияПользователю = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("НаименованиеКонтрагентаДляСообщенияПользователю");
	
	СтруктураПараметровКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель,
		ИмяРеквизитаИННКонтрагента + ", " + ИмяРеквизитаКППКонтрагента + ", " + ИмяРеквизитаНаименованиеКонтрагента + ", "
		+ ИмяРеквизитаВнешнийКодКонтрагента + ", " + ИмяРеквизитаНаименованиеКонтрагентаДляСообщенияПользователю);
		
	Если Не ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		ШаблонСообщения = НСтр("ru = 'Для отправки приглашения к обмену ЭД для получателя %1
									|необходимо заполнить электронную почту.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Получатель);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтруктураПараметровКонтрагента[ИмяРеквизитаИННКонтрагента]) Тогда
		ШаблонСообщения = НСтр("ru = 'Для отправки приглашения к обмену ЭД для получателя %1
									|необходимо заполнить ИНН.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Получатель);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ТаблицаПриглашений.Добавить();
	НоваяСтрока.ПрофильНастроекЭДО = ПрофильНастроекЭДО;
	НоваяСтрока.НастройкаЭДО       = НастройкаЭДО;
	НоваяСтрока.Получатель         = Получатель;
	НоваяСтрока.ТекстПриглашения   = ТекстПриглашения;
	НоваяСтрока.АдресЭП            = ЭлектроннаяПочта;
	НоваяСтрока.Наименование       = СтруктураПараметровКонтрагента[ИмяРеквизитаНаименованиеКонтрагента];
	НоваяСтрока.НаименованиеДляСообщенияПользователю = СтруктураПараметровКонтрагента[ИмяРеквизитаНаименованиеКонтрагентаДляСообщенияПользователю];
	НоваяСтрока.ИНН = СтруктураПараметровКонтрагента[ИмяРеквизитаИННКонтрагента];
	НоваяСтрока.КПП = СтруктураПараметровКонтрагента[ИмяРеквизитаКППКонтрагента];
	НоваяСтрока.ВнешнийКод = СтруктураПараметровКонтрагента[ИмяРеквизитаВнешнийКодКонтрагента];
		
	Если Не ЗначениеЗаполнено(ТаблицаПриглашений) Тогда
		Возврат;
	КонецЕсли;
	
	ДопПараметры = Новый Структура;
	ИмяФайла = ОбменСКонтрагентамиВнутренний.ИсходящийЗапросПриглашенияОператораЭДО(ТаблицаПриглашений, ДопПараметры);
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	ПутьДляПриглашений = ЭлектронноеВзаимодействиеСлужебный.РабочийКаталог("invite", Новый УникальныйИдентификатор);
	ИмяФайлаПриглашения = ПутьДляПриглашений + "SendContacts.xml";
	КопироватьФайл(ИмяФайла, ИмяФайлаПриглашения);
	ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайла);
	РезультатОтправки = ОбменСКонтрагентамиВнутренний.ОтправитьЧерезОператораЭДО(
																	Маркер,
																	ПутьДляПриглашений,
																	"SendContacts",
																	ПрофильНастроекЭДО);
	ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПутьДляПриглашений);
	Если РезультатОтправки <> 0 Тогда
		Для каждого СтрокаТаблицы Из ТаблицаПриглашений Цикл
			СтатусПодключения = Перечисления.СтатусыУчастниковОбменаЭД.ОжидаемСогласия;
			СостояниеСоглашения = Перечисления.СостоянияСоглашенийЭД.ОжидаетсяСогласование;
			ОбновитьНастройкиЭДО(СтрокаТаблицы.НастройкаЭДО);
		КонецЦикла;
		
		// Определим сколько отправлено приглашений.
		ОтправленоПриглашений = ТаблицаПриглашений.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМаркер(ОбработчикОповещения)
	
	Массив = Новый Массив;
	Массив.Добавить(ПрофильНастроекЭДО);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ПолучитьНастройкиЭДОИПараметрыСертификатов(ОбработчикОповещения, Массив);
	
КонецПроцедуры

&НаКлиенте
Функция Маркер(Результат)
	
	Соответствие = Неопределено;
	Маркер = Неопределено;
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("СоответствиеПрофилейИПараметровСертификатов", Соответствие)
		И ТипЗнч(Соответствие) = Тип("Соответствие") Тогда
		
		СтСертификата = Соответствие.Получить(ПрофильНастроекЭДО);
		Если ТипЗнч(СтСертификата) = Тип("Структура") Тогда
			СтСертификата.Свойство("МаркерРасшифрованный", Маркер);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Маркер;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиАсинхронныхДиалогов

&НаКлиенте
Процедура ОтправитьПриглашениеОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	ТекстЗаголовка = НСтр("ru = 'Отправка приглашений получателям'");
	ОтправленоПриглашений = 0;
	
	Маркер = Маркер(Результат);
	
	Если ЗначениеЗаполнено(Маркер) Тогда
		
		
		ОтправитьПриглашенияСервер(ОтправленоПриглашений, Маркер);
		
		ШаблонСообщения = НСтр("ru = 'Отправлено приглашений: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ОтправленоПриглашений);
		
		ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСообщения);
		
		Если ЗначениеЗаполнено(ОтправленоПриглашений) Тогда
			Оповестить("ОбновитьСостояниеЭД");
			Закрыть();
		КонецЕсли;
	Иначе
		ШаблонОшибки = НСтр("ru = 'При отправке приглашения возникли ошибки.
			|Необходимо выполнить тест настроек ЭДО с контрагентом %1.'");
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Получатель);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьПриглашениеОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	ТекстЗаголовка = НСтр("ru = 'Отклоняются приглашения'");
	КоличествоОтклоненныхПриглашений = 0;
	
	Маркер = Маркер(Результат);
	
	Если ЗначениеЗаполнено(Маркер) Тогда
		Результат = ПринятьОтклонитьКонтактЧерезОператораЭДОНаСервере(ИдентификаторКонтрагента, Ложь, Маркер);
		Если Результат Тогда
			СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.Отсоединен");
			СостояниеСоглашения = ПредопределенноеЗначение("Перечисление.СостоянияСоглашенийЭД.Закрыто");
			ОбновитьНастройкиЭДО(НастройкаЭДО);
			
			КоличествоОтклоненныхПриглашений = 1;
		КонецЕсли;
		
		ШаблонСообщения = НСтр("ru = 'Отклонено приглашений: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КоличествоОтклоненныхПриглашений);
		
		ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСообщения);
		
		Если ЗначениеЗаполнено(КоличествоОтклоненныхПриглашений) Тогда
			Оповестить("ОбновитьСостояниеЭД");
			Закрыть();
		КонецЕсли;
	Иначе
		ШаблонОшибки = НСтр("ru = 'При отклонении приглашения возникли ошибки.
			|Необходимо выполнить тест настроек ЭДО с контрагентом %1.'");
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Получатель);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьПриглашениеОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	ТекстЗаголовка = НСтр("ru = 'Принимаются приглашения'");
	КоличествоПринятыхПриглашений = 0;
	
	Маркер = Маркер(Результат);
	
	Если ЗначениеЗаполнено(Маркер) Тогда
		Результат = ПринятьОтклонитьКонтактЧерезОператораЭДОНаСервере(ИдентификаторКонтрагента, Истина, Маркер);
		Если Результат Тогда
			СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыУчастниковОбменаЭД.Присоединен");
			СостояниеСоглашения = ПредопределенноеЗначение("Перечисление.СостоянияСоглашенийЭД.ПроверкаТехническойСовместимости");
			ОбновитьНастройкиЭДО(НастройкаЭДО);
			
			КоличествоПринятыхПриглашений = 1;
		КонецЕсли;
		
		ШаблонСообщения = НСтр("ru = 'Принято приглашений: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КоличествоПринятыхПриглашений);
		
		ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСообщения);
		
		Если ЗначениеЗаполнено(КоличествоПринятыхПриглашений) Тогда
			Оповестить("ОбновитьСостояниеЭД");
			Закрыть();
		КонецЕсли;
	Иначе
		ШаблонОшибки = НСтр("ru = 'При принятии приглашения возникли ошибки.
			|Необходимо выполнить тест настроек ЭДО с контрагентом %1.'");
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Получатель);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
