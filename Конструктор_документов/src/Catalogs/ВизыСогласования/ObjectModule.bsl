#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка прав на добавление или изменение. Права на добавление имеет автор, 
	// на изменение - автор и исполнитель, а также их делегаты и руководители.
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа()
		И Не ПривилегированныйРежим()
		И Не Пользователи.ЭтоПолноправныйПользователь(ТекущийПользователь) Тогда
		
		// Права на добавление/изменение документа
		ПраваНаДокумент = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Документ);
		ОперацияРазрешена = ?(ЭтоНовый(), 
			ПраваНаДокумент.Добавление Или ПраваНаДокумент.Изменение,
			ПраваНаДокумент.Изменение);
			
		Если ОперацияРазрешена Тогда
			
			// Права на добавление/изменение визы
			Запрос = Новый Запрос(
				"ВЫБРАТЬ
				|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.ПравоДобавления), ЛОЖЬ) КАК ПравоДобавления,
				|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.ПравоИзменения), ЛОЖЬ) КАК ПравоИзменения
				|ИЗ
				|	(ВЫБРАТЬ
				|		ИСТИНА КАК ПравоДобавления,
				|		ИСТИНА КАК ПравоИзменения
				|	ИЗ
				|		РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
				|	ГДЕ
				|		СоставСубъектовПравДоступа.Пользователь = &ТекущийПользователь
				|		И СоставСубъектовПравДоступа.Субъект = &Автор
				|	
				|	ОБЪЕДИНИТЬ ВСЕ
				|	
				|	ВЫБРАТЬ
				|		ЛОЖЬ,
				|		ИСТИНА
				|	ИЗ
				|		РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
				|	ГДЕ
				|		СоставСубъектовПравДоступа.Пользователь = &ТекущийПользователь
				|		И СоставСубъектовПравДоступа.Субъект = &Исполнитель) КАК ВложенныйЗапрос");
			
			Запрос.УстановитьПараметр("ТекущийПользователь", ТекущийПользователь);
			Запрос.УстановитьПараметр("Автор", Автор);
			Запрос.УстановитьПараметр("Исполнитель", ?(ЗначениеЗаполнено(Исполнитель), Исполнитель, РольИсполнителя));
			
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			
			ОперацияРазрешена = ?(ЭтоНовый(), Выборка.ПравоДобавления, Выборка.ПравоИзменения);
			
		КонецЕсли;
		
		Если Не ОперацияРазрешена Тогда
			ВызватьИсключение НСтр("ru = 'Недостаточно прав для выполнения операции. 
			|Обратитесь к администратору.'");
		КонецЕсли;
		
	КонецЕсли;
	
	// Добавление участников из самого документа
	Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(Документ) Тогда 
		
		ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(Документ);
		
		НоваяТаблицаУчастников = ТаблицаУчастников.Скопировать();
		
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(НоваяТаблицаУчастников, Исполнитель);
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(НоваяТаблицаУчастников, Автор);
		
		Если НоваяТаблицаУчастников.Количество() <> ТаблицаУчастников.Количество() Тогда
			Попытка
				РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(Документ, НоваяТаблицаУчастников, Истина);
			Исключение
				Если ЗначениеЗаполнено(Источник) Тогда
					// Если виза создана процессом или задачей, то
					// ошибку перезаписи обрабатываем особым образом.
					РаботаСРабочимиГруппами.ОбработатьИсключениеПерезаписиРабочейГруппыПредметаПроцесса(Документ);
				Иначе
					ВызватьИсключение;
				КонецЕсли;
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли