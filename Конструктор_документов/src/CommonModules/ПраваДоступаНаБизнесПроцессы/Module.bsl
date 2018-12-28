
////////////////////////////////////////////////////////////////////////////////
// Права доступа на бизнес процессы
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает таблицу участников процесса, привязанных к объекту или ссылке на объект
// Колонки:
//   Участник - ссылка на пользователя, роль, проект
//   СодержитсяВСтаройВерсии, СодержитсяВНовойВерсии - булево, признаки наличия участника 
//    в старой и новой версиях объекта, которые анализируются при назначении прав
//   ИмяРеквизитаОбъекта - строка, используется при выводе сообщения об ошибке, связанной с этим участником
//
Функция ПолучитьТаблицуУчастниковПроцесса(БизнесПроцессОбъект) Экспорт
	
	ТипыУчастников = Новый Массив;
	ТипыУчастников.Добавить(Тип("СправочникСсылка.Пользователи"));
	ТипыУчастников.Добавить(Тип("СправочникСсылка.ПолныеРоли"));
	ТипыУчастников.Добавить(Тип("СправочникСсылка.Проекты"));
	
	ТипУчастника = Новый ОписаниеТипов(ТипыУчастников);
	ТипБулево = Новый ОписаниеТипов("Булево");
	ТипСтрока = Новый ОписаниеТипов("Строка");
	
	Участники = Новый ТаблицаЗначений;
	Участники.Колонки.Добавить("Участник", ТипУчастника);
	Участники.Колонки.Добавить("ВлияетНаДоступКПодчиненнымОбъектам", ТипБулево);
	Участники.Колонки.Добавить("СодержитсяВСтаройВерсии", ТипБулево);
	Участники.Колонки.Добавить("СодержитсяВНовойВерсии", ТипБулево);
	Участники.Колонки.Добавить("ИмяРеквизитаОбъекта", ТипСтрока);
	
	МетаданныеБП = БизнесПроцессОбъект.Метаданные();
	ИмяБП = МетаданныеБП.Имя;
	ОписанияУчастников = БизнесПроцессы[ИмяБП].ЗаполнитьОписанияУчастников();
	
	ИменаРеквизитов = "";
	
	// Заполнение имен реквизитов для обращения к БД
	Для Каждого ОписаниеУчастника из ОписанияУчастников Цикл
		
		Если ОписаниеУчастника.Свойство("ТабличнаяЧасть") 
			И ЗначениеЗаполнено(ОписаниеУчастника.ТабличнаяЧасть) Тогда
			ИменаРеквизитов = ИменаРеквизитов + ?(ЗначениеЗаполнено(ИменаРеквизитов), ", ", "") 
				+ ОписаниеУчастника.ТабличнаяЧасть;
		Иначе
			ИменаРеквизитов = ИменаРеквизитов + 
			?(ЗначениеЗаполнено(ИменаРеквизитов), ", ", "") + ОписаниеУчастника.ИмяУчастника;
		КонецЕсли;
		
	КонецЦикла;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БизнесПроцессОбъект.Ссылка, ИменаРеквизитов);
	
	// Заполнение таблицы участников
	Для Каждого ОписаниеУчастника из ОписанияУчастников Цикл
		
		Если ОписаниеУчастника.Свойство("ТабличнаяЧасть") 
			И ЗначениеЗаполнено(ОписаниеУчастника.ТабличнаяЧасть) Тогда
			
			Если ЗначениеЗаполнено(Реквизиты[ОписаниеУчастника.ТабличнаяЧасть]) Тогда
				СтараяТабЧасть = Реквизиты[ОписаниеУчастника.ТабличнаяЧасть].Выгрузить();
				Для Каждого СторкаСтаройТЧ из СтараяТабЧасть Цикл
					НоваяСтрока = Участники.Добавить();
					НоваяСтрока.СодержитсяВСтаройВерсии	= Истина;
					ЗаполнитьСтрокуУчастникаИзИсточникаПоОписанию(НоваяСтрока, СторкаСтаройТЧ, ОписаниеУчастника);
				КонецЦикла;
			КонецЕсли;
			
			Для Каждого СтрокаНовойТЧ из БизнесПроцессОбъект[ОписаниеУчастника.ТабличнаяЧасть] Цикл
				НоваяСтрока = Участники.Добавить();
				НоваяСтрока.СодержитсяВНовойВерсии	= Истина;
				НоваяСтрока.ИмяРеквизитаОбъекта = ОписаниеУчастника.ТабличнаяЧасть
					+ "[" + Формат(СтрокаНовойТЧ.НомерСтроки - 1,"ЧГ=; ЧН=") + "]."
					+ ОписаниеУчастника.ИмяУчастника;
				ЗаполнитьСтрокуУчастникаИзИсточникаПоОписанию(НоваяСтрока, СтрокаНовойТЧ, ОписаниеУчастника);
			КонецЦикла;
			
		Иначе
			
			Если ЗначениеЗаполнено(Реквизиты[ОписаниеУчастника.ИмяУчастника]) Тогда
				НоваяСтрока = Участники.Добавить();
				НоваяСтрока.СодержитсяВСтаройВерсии	= Истина;
				ЗаполнитьСтрокуУчастникаИзИсточникаПоОписанию(НоваяСтрока, Реквизиты, ОписаниеУчастника);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(БизнесПроцессОбъект[ОписаниеУчастника.ИмяУчастника]) Тогда
				НоваяСтрока = Участники.Добавить();
				НоваяСтрока.СодержитсяВНовойВерсии	= Истина;
				НоваяСтрока.ИмяРеквизитаОбъекта = ОписаниеУчастника.ИмяУчастника;
				ЗаполнитьСтрокуУчастникаИзИсточникаПоОписанию(НоваяСтрока, БизнесПроцессОбъект, ОписаниеУчастника);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УчастникиСвернутая = Участники.Скопировать();
	УчастникиСвернутая.Свернуть("Участник, ВлияетНаДоступКПодчиненнымОбъектам",
		"СодержитсяВСтаройВерсии, СодержитсяВНовойВерсии");
		
	// Заполнение путей к реквизитам
	УчастникиСвернутая.Колонки.Добавить("ИмяРеквизитаОбъекта", ТипСтрока);
	СтруктураПоиска = Новый Структура("Участник, ВлияетНаДоступКПодчиненнымОбъектам");
		
	Для Каждого СтрСвернутая из УчастникиСвернутая Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрСвернутая);
		НайденныеСтроки = Участники.НайтиСтроки(СтруктураПоиска);
		Для Каждого НайденнаяСтрока из НайденныеСтроки Цикл
			Если ЗначениеЗаполнено(НайденнаяСтрока.ИмяРеквизитаОбъекта) Тогда
				СтрСвернутая.ИмяРеквизитаОбъекта = НайденнаяСтрока.ИмяРеквизитаОбъекта;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
		
	Возврат УчастникиСвернутая;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик подписки ПраваДоступаПередЗаписьюБизнесПроцессов
Процедура ПраваДоступаПередЗаписьюБизнесПроцессовПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ВидЗаписи")
		И Источник.ДополнительныеСвойства.ВидЗаписи <>
			"ЗаписьСОбновлением_Предметов_ПредметовЗадач_Проекта_ОбщегоСпискаПроцессов_РабочихГруппПредметов_РабочихГруппПроцессов_ДопРеквизитовПоПредметам" Тогда
			
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Источник.Ссылка) Тогда
		
		// Получение таблицы участников процесса
		Если Источник.ДополнительныеСвойства.Свойство("УчастникиПроцесса") Тогда
			Участники = Источник.ДополнительныеСвойства.УчастникиПроцесса;
		Иначе
			Участники = ПолучитьТаблицуУчастниковПроцесса(Источник);
			Источник.ДополнительныеСвойства.Вставить("УчастникиПроцесса", Участники);
		КонецЕсли;
		
		// Проверка прав для новых участников процесса
		// и расширение рабочих групп предметов с автозаполняемыми рабочими группами.
		Если Источник.Стартован Тогда
			
			// Определим необходимость обновления рабочих групп.
			ОбновитьРабочиеГруппыПредметов = Ложь;
			Для Каждого Участник из Участники Цикл
				Если Участник.СодержитсяВНовойВерсии И Не Участник.СодержитсяВСтаройВерсии Тогда
					ОбновитьРабочиеГруппыПредметов = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ОбновитьРабочиеГруппыПредметов Тогда
				
				// Получим предметы процесса для обработки.
				ПредметыДляПроверки = Мультипредметность.ПредметыДляДействийПроцесса(Источник);
				
				// Обновим рабочие группы предметов с автоматическим заполнением рабочих групп.
				РаботаСРабочимиГруппами.ПерезаписатьРабочиеГруппыПредметовБизнесПроцесса(
						Источник, ПредметыДляПроверки);
				
				Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа()
					И Не РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
					
					// Определим предметы для проверки прав.
					ПредметыДляПроверкиПрав = 
						Мультипредметность.ПредметыДляПроверкиПрав(ПредметыДляПроверки, Источник.Ссылка);
						
					ПредметыДляПроверкиПравДоступаУчастников = 
						ПредметыДляПроверкиПрав.ДляПроверкиПравДоступаУчастников;
						
					// Проверим права на предметы без автоматического заполнения рабочей группы.
					УчастникиДляПроверки = Мультипредметность.УчастникиДляПроверкиПрав(Источник);
					ПользователиДляПроверки = Мультипредметность.ПользователиДляПроверкиПрав(УчастникиДляПроверки);
					
					ПраваУчастниковНаПредметы = ДокументооборотПраваДоступа.ПолучитьПраваПользователейПоОбъектам(
						ПредметыДляПроверкиПравДоступаУчастников,
						Истина,
						ПользователиДляПроверки.ВыгрузитьКолонку("Участник"));
					
					Для Каждого Предмет Из ПредметыДляПроверкиПравДоступаУчастников Цикл
						
						УчастникиНеИмеющиеПравДоступаНаТекущийПредмет = Новый Массив;
						
						Для Каждого СтрокаПользователь Из ПользователиДляПроверки Цикл
							
							Отбор = Новый Структура;
							Отбор.Вставить("ОбъектДоступа", Предмет);
							Отбор.Вставить("Пользователь", СтрокаПользователь.Участник);
							
							НайденныеПрава = ПраваУчастниковНаПредметы.НайтиСтроки(Отбор);
							Если НайденныеПрава.Количество() = 0 Тогда
								ТекстОшибки = СтрШаблон(
									НСтр("ru = 'Пользователь ""%1"" не имеет прав на предмет ""%2"".'"),
									СтрокаПользователь.Участник,
									Предмет);
									
								ВызватьИсключение ТекстОшибки;
							КонецЕсли;
						КонецЦикла;
						
					КонецЦикла
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	
	// Передача доп. реквизитов в другие обработчики.
	Источник.ДополнительныеСвойства.Вставить(
		"ДополнительныеРеквизиты", 
		Источник.Ссылка.ДополнительныеРеквизиты);
			
КонецПроцедуры

// Обработчик подписки ПраваДоступаПриЗаписиБизнесПроцессов
Процедура ПраваДоступаПриЗаписиБизнесПроцессовПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ДополнительныеСвойства.Свойство("ВидЗаписи")
		И Источник.ДополнительныеСвойства.ВидЗаписи <>
			"ЗаписьСОбновлением_Предметов_ПредметовЗадач_Проекта_ОбщегоСпискаПроцессов_РабочихГруппПредметов_РабочихГруппПроцессов_ДопРеквизитовПоПредметам" Тогда
			
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Источник.ДополнительныеСвойства.Свойство("УчастникиПроцесса") Тогда
		
		Участники = Источник.ДополнительныеСвойства.УчастникиПроцесса;
		ДобавитьСтарыхИсполнителейЗадачВРабочуюГруппу(Источник.Ссылка, Участники);
		
		НаборУчастниковПроцесса = РегистрыСведений.УчастникиПроцессов.ПолучитьУчастников(Источник.Ссылка);
		
		НаборУчастниковИзменен = Ложь;
		ИзмененныеУчастникиВлияющиеНаДочерниеПроцессы = Участники.СкопироватьКолонки();
		Для Каждого Участник из Участники Цикл
			
			Если Участник.СодержитсяВСтаройВерсии <> Участник.СодержитсяВНовойВерсии Тогда
				Если Участник.ВлияетНаДоступКПодчиненнымОбъектам Тогда
					ЗаполнитьЗначенияСвойств(ИзмененныеУчастникиВлияющиеНаДочерниеПроцессы.Добавить(), Участник);
				КонецЕсли;
				
				// РС УчастникиПроцессов - только добавление новых, старые участники не удаляются
				Если Участник.СодержитсяВНовойВерсии Тогда
					НаборУчастниковИзменен = Истина;
					ЗаполнитьЗначенияСвойств(НаборУчастниковПроцесса.Добавить(), Участник);
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		
		Если ИзмененныеУчастникиВлияющиеНаДочерниеПроцессы.Количество() > 0 Тогда
			ОбновитьРабочиеГруппыДочернихБизнесПроцессов(Источник.Ссылка, 
				ИзмененныеУчастникиВлияющиеНаДочерниеПроцессы);
		КонецЕсли;
		
		Если НаборУчастниковИзменен Тогда
			НаборУчастниковПроцесса.Свернуть("Участник");
			РегистрыСведений.УчастникиПроцессов.ЗаписатьНаборПоПроцессу(Источник.Ссылка, НаборУчастниковПроцесса);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьРабочиеГруппыДочернихБизнесПроцессов(БизнесПроцесс, СписокУчастников)
	
	ДочерниеПроцессы = Новый Массив;
	БизнесПроцессыИЗадачиСервер.ПолучитьДочерниеПроцессы(БизнесПроцесс, ДочерниеПроцессы);
	
	// Заполнение рабочей группы
	Для каждого Эл из ДочерниеПроцессы Цикл
		
		Набор = РегистрыСведений.РабочиеГруппы.СоздатьНаборЗаписей();
		Набор.Отбор.Объект.Установить(Эл);
		Набор.Прочитать();
		
		// Добавление в рабочую группу списка новых пользователей
		Для каждого Пользователь Из СписокУчастников Цикл
			
			// Проверка что этот пользователь уже есть в рабочей группе
			УжеЕсть = Ложь;
			Для каждого ЗаписьНабора Из Набор Цикл
				Если ЗаписьНабора.Участник = Пользователь.Участник Тогда
					УжеЕсть = Истина;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
			
			Если Не УжеЕсть Тогда
				Запись = Набор.Добавить();
				Запись.Объект = Эл;
				Запись.Участник = Пользователь.Участник;
			КонецЕсли;
			
		КонецЦикла;	
		
		Набор.Записать(Истина);
		
		// Рекурсивный вызов для дочерних процессов
		ОбновитьРабочиеГруппыДочернихБизнесПроцессов(Эл, СписокУчастников)
		
	КонецЦикла;
	
КонецПроцедуры

// Добавляет в рабочую группу старых исполнителей, по которым есть выполненные задачи
Процедура ДобавитьСтарыхИсполнителейЗадачВРабочуюГруппу(БизнесПроцесс, Участники)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Участники, присутствующие только в старой версии объекта
	УдаленныеУчастникиПроцесса = Участники.Скопировать();
	УдаленныеУчастникиПроцесса.Свернуть("Участник",
		"СодержитсяВНовойВерсии");
		
	КоличествоУдаленных = УдаленныеУчастникиПроцесса.Количество();
	Для Инд = 1 По КоличествоУдаленных Цикл
		ТекущаяСтрока = УдаленныеУчастникиПроцесса[КоличествоУдаленных - Инд];
		Если ТекущаяСтрока.СодержитсяВНовойВерсии Тогда
			УдаленныеУчастникиПроцесса.Удалить(КоличествоУдаленных - Инд);
		КонецЕсли;
	КонецЦикла;
	
	Если УдаленныеУчастникиПроцесса.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	// Получение старых участников, не входящих в РГ и являющихся исполнителями выполненных задач по процессу
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	ТаблицаУдаленныхУчастников.Участник
		|ПОМЕСТИТЬ УдаленныеУчастники
		|ИЗ
		|	&ТаблицаУдаленныхУчастников КАК ТаблицаУдаленныхУчастников
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УдаленныеУчастники.Участник
		|ПОМЕСТИТЬ НеНайденныеВРабочейГруппе
		|ИЗ
		|	УдаленныеУчастники КАК УдаленныеУчастники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РабочиеГруппы КАК РабочиеГруппы
		|		ПО УдаленныеУчастники.Участник = РабочиеГруппы.Участник
		|			И (РабочиеГруппы.Объект = &БизнесПроцесс)
		|ГДЕ
		|	РабочиеГруппы.Участник ЕСТЬ NULL 
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НеНайденныеВРабочейГруппе.Участник
		|ПОМЕСТИТЬ ДобавитьВРабочуюГруппу
		|ИЗ
		|	НеНайденныеВРабочейГруппе КАК НеНайденныеВРабочейГруппе
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|		ПО НеНайденныеВРабочейГруппе.Участник = ЗадачаИсполнителя.Исполнитель
		|			И (ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс)
		|ГДЕ
		|	ЗадачаИсполнителя.Выполнена
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НеНайденныеВРабочейГруппе.Участник
		|ИЗ
		|	НеНайденныеВРабочейГруппе КАК НеНайденныеВРабочейГруппе
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|		ПО НеНайденныеВРабочейГруппе.Участник = ЗадачаИсполнителя.РольИсполнителя
		|			И (ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс)
		|ГДЕ
		|	ЗадачаИсполнителя.Выполнена
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДобавитьВРабочуюГруппу.Участник КАК Участник,
		|	ВЫРАЗИТЬ(ДобавитьВРабочуюГруппу.Участник КАК Справочник.ПолныеРоли).Владелец КАК УдалитьУчастник,
		|	ВЫРАЗИТЬ(ДобавитьВРабочуюГруппу.Участник КАК Справочник.ПолныеРоли).ОсновнойОбъектАдресации КАК УдалитьОсновнойОбъектАдресации,
		|	ВЫРАЗИТЬ(ДобавитьВРабочуюГруппу.Участник КАК Справочник.ПолныеРоли).ДополнительныйОбъектАдресации КАК УдалитьДополнительныйОбъектАдресации
		|ИЗ
		|	ДобавитьВРабочуюГруппу КАК ДобавитьВРабочуюГруппу");
		
	Запрос.УстановитьПараметр("ТаблицаУдаленныхУчастников", УдаленныеУчастникиПроцесса);
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс.Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Набор = РегистрыСведений.РабочиеГруппы.СоздатьНаборЗаписей();
		Набор.Отбор.Объект.Установить(БизнесПроцесс.Ссылка);
		Набор.Прочитать();
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Запись = Набор.Добавить();
			Запись.Объект = БизнесПроцесс.Ссылка;
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			
		КонецЦикла;
		
		Набор.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокуУчастникаИзИсточникаПоОписанию(СтрокаУчастника, Источник, Описание)

	СтрокаУчастника.Участник = Источник[Описание.ИмяУчастника];
	
	СтрокаУчастника.ВлияетНаДоступКПодчиненнымОбъектам = Описание.ВлияетНаДоступКПодчиненнымОбъектам;
	
КонецПроцедуры

#КонецОбласти