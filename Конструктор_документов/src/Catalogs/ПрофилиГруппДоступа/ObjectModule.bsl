
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		// Проверка наличия ролей в конфигурации.
		НомерСтроки = Роли.Количество() - 1;
		Пока НомерСтроки >= 0 Цикл
			Если Роли[НомерСтроки].Роль = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Роль.ПолныеПрава")
			   И Ссылка <> Справочники.ПрофилиГруппДоступа.Администратор Тогда
				
				Роли.Удалить(НомерСтроки);
			КонецЕсли;
			НомерСтроки = НомерСтроки - 1;
		КонецЦикла;
		
		Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
			ПоставляемыйПрофильИзменен = Ложь;
		Иначе
			ПоставляемыйПрофильИзменен = Справочники.ПрофилиГруппДоступа.ПоставляемыйПрофильИзменен(ЭтотОбъект);
		КонецЕсли;
		
		Если УправлениеДоступомПереопределяемый.УпрощенныйИнтерфейсНастройкиПравДоступа() Тогда
			// Обновление наименования у персональных групп доступа этого профиля (если есть)
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Профиль",      Ссылка);
			Запрос.УстановитьПараметр("Наименование", Наименование);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ГруппыДоступа.Ссылка
			|ИЗ
			|	Справочник.ГруппыДоступа КАК ГруппыДоступа
			|ГДЕ
			|	ГруппыДоступа.Профиль = &Профиль
			|	И ГруппыДоступа.Пользователь <> НЕОПРЕДЕЛЕНО
			|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
			|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
			|	И ГруппыДоступа.Наименование <> &Наименование";
			ИзмененныеГруппыДоступа = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
			Если ИзмененныеГруппыДоступа.Количество() > 0 Тогда
				Для каждого ГруппаДоступаСсылка Из ИзмененныеГруппыДоступа Цикл
					ПерсональнаяГруппаДоступаОбъект = ГруппаДоступаСсылка.ПолучитьОбъект();
					ПерсональнаяГруппаДоступаОбъект.Наименование = Наименование;
					ПерсональнаяГруппаДоступаОбъект.ОбменДанными.Загрузка = Истина;
					ПерсональнаяГруппаДоступаОбъект.Записать();
				КонецЦикла;
				ДополнительныеСвойства.Вставить("ПерсональныеГруппыДоступаСОбновленнымНаименованием", ИзмененныеГруппыДоступа);
			КонецЕсли;
		КонецЕсли;
		
		Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
			Пользователь = Неопределено;
		КонецЕсли;
		
		// При установке пометки удаления установка пометки удаления групп доступа профиля
		Если ПометкаУдаления И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") = Ложь Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Профиль", Ссылка);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ГруппыДоступа.Ссылка
			|ИЗ
			|	Справочник.ГруппыДоступа КАК ГруппыДоступа
			|ГДЕ
			|	(НЕ ГруппыДоступа.ПометкаУдаления)
			|	И ГруппыДоступа.Профиль = &Профиль";
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
				ГруппаДоступаОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ГруппаДоступаОбъект.УстановитьПометкуУдаления(Истина);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка однозначности поставляемых данных.
	Если ИдентификаторПоставляемыхДанных <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ИдентификаторПоставляемыхДанных", ИдентификаторПоставляемыхДанных);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПрофилиГруппДоступа.Ссылка КАК Ссылка,
		|	ПрофилиГруппДоступа.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
		|ГДЕ
		|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных = &ИдентификаторПоставляемыхДанных";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() > 1 Тогда
			
			КраткоеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при записи полномочий ""%1"".
				           |Поставляемый элемент уже существует:'"),
				Наименование);
			
			ПодробноеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при записи полномочий ""%1"".
				           |Идентификатор поставляемых данных ""%2"" уже используется в полномочиях:'"),
				Наименование,
				Строка(ИдентификаторПоставляемыхДанных));
			
			Пока Выборка.Следующий() Цикл
				Если Выборка.Ссылка <> Ссылка Тогда
					
					КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки
						+ Символы.ПС + """" + Выборка.Наименование + """.";
					
					ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки
						+ Символы.ПС + """" + Выборка.Наименование + """ ("
						+ Строка(Выборка.Ссылка.УникальныйИдентификатор())+ ")."
				КонецЕсли;
			КонецЦикла;
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Управление доступом.Нарушение однозначности поставляемых полномочий'",
				     ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки);
			
			ВызватьИсключение КраткоеПредставлениеОшибки;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
		
	Если ДополнительныеСвойства.Свойство("ОбновитьГруппыДоступаПрофиля") Тогда
		Справочники.ГруппыДоступа.ОбновитьГруппыДоступаПрофиля(Ссылка, Ложь);
	КонецЕсли;
	
	// Обновление прав групп доступа на таблицы
	// Обновление значений групп доступа
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Профиль = &Профиль
	|	И (НЕ ГруппыДоступа.ЭтоГруппа)");
	Запрос.УстановитьПараметр("Профиль", Ссылка);
	ГруппыДоступа = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	РегистрыСведений.ПраваГруппДоступаНаТаблицы.Обновить(ГруппыДоступа);
	
	ДополнительныеСвойства.Вставить("НеОбновлятьРолиПользователей", Истина); // Роли обновляются в отдельной подписке
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
		// Обновление ролей пользователей.
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставыГруппПользователей.Пользователь
		|ИЗ
		|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ПО СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь
		|			И (ГруппыДоступаПользователи.Ссылка.Профиль = &Профиль)");
		Запрос.УстановитьПараметр("Профиль", Ссылка);
		ПользователиПрофиля = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
		
		ЕстьОшибки = Ложь;
		УправлениеДоступом.ОбновитьРолиПользователей(ПользователиПрофиля, ЕстьОшибки);
		Если ЕстьОшибки И НЕ ДополнительныеСвойства.Свойство("ЕстьОшибки") Тогда
			ДополнительныеСвойства.Вставить("ЕстьОшибки");
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторПоставляемыхДанных = Неопределено;
	
КонецПроцедуры

#КонецЕсли
