// Заполняет XML из исходящего документа в соответствии с 
// ГОСТ Р 53898-2010 «Системы электронного документооборота. 
// Взаимодействие систем управления документами. Требования к электронному сообщению»
//
// Параметры:
//  Документ - СправочникСсылка.ИсходящиеДокументы - Ссылка на входящий документ.
//  ИмяФайла - Имя файла на сервере, содержащего xml.
//
// Возвращаемое значение:
//  Строка - Имя временного файла с XML.
Функция Выгрузить(Документ) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла);
	
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	//Корневой элемент
	ЗаписьXML.ЗаписатьНачалоЭлемента("Header");
	ЗаписьXML.ЗаписатьАтрибут("standart", "Стандарт системы управления документами");
	ЗаписьXML.ЗаписатьАтрибут("version", "1.0");
	
	Время = ТекущаяДата();
	Время = РаботаСФайламиКлиентСервер.ПолучитьУниверсальноеВремя(Время);
	ЗаписьXML.ЗаписатьАтрибут("time", XMLСтрока(Время));
		
	ЗаписьXML.ЗаписатьАтрибут("msg_type", "1");
	ЗаписьXML.ЗаписатьАтрибут("msg_acknow", "0");
	ЗаписьXML.ЗаписатьАтрибут("from_organization", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Организация)));
	ЗаписьXML.ЗаписатьАтрибут("from_department", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Подразделение)));
	ЗаписьXML.ЗаписатьАтрибут("from_system", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML("1С:Документооборот 8"));
	
	Если ТипЗнч(Документ) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
		СтрокаПолучателей = "";
		Для каждого Получатель Из Документ.Получатели Цикл
			СтрокаПолучателей = СтрокаПолучателей + Строка(Получатель.Получатель);
		КонецЦикла;			
		ЗаписьXML.ЗаписатьАтрибут("to_organization", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(СтрокаПолучателей));
	КонецЕсли;
	
		//Элемент Document
		ЗаписьXML.ЗаписатьНачалоЭлемента("Document");
		ЗаписьXML.ЗаписатьАтрибут("id_number", Строка(Документ.УникальныйИдентификатор()));
		Если ТипЗнч(Документ) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
			ЗаписьXML.ЗаписатьАтрибут("type", "0");
		ИначеЕсли ТипЗнч(Документ) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
			ЗаписьXML.ЗаписатьАтрибут("type", "1");
		Иначе
			ЗаписьXML.ЗаписатьАтрибут("type", "2"); // Внутренний документ
		КонецЕсли;	
		ЗаписьXML.ЗаписатьАтрибут("kind", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.ВидДокумента)));
		ЗаписьXML.ЗаписатьАтрибут("title", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Заголовок)));
		ЗаписьXML.ЗаписатьАтрибут("annotation", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Содержание)));
		
			//Элемент RegNumber
			ЗаписьXML.ЗаписатьНачалоЭлемента("RegNumber");
			Время = РаботаСФайламиКлиентСервер.ПолучитьУниверсальноеВремя(Документ.ДатаРегистрации);
			ЗаписьXML.ЗаписатьАтрибут("time", XMLСтрока(Время));
			ЗаписьXML.ЗаписатьТекст(РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.РегистрационныйНомер)));
			ЗаписьXML.ЗаписатьКонецЭлемента(); // "RegNumber"
			
			//Элемент Confident
			ЗаписьXML.ЗаписатьНачалоЭлемента("Confident");
			Если ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа") Тогда
				ЗаписьXML.ЗаписатьАтрибут("flag", "1");
				ЗаписьXML.ЗаписатьТекст(РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.ГрифДоступа)));
			Иначе
				ЗаписьXML.ЗаписатьАтрибут("flag", "0");
			КонецЕсли;
			ЗаписьXML.ЗаписатьКонецЭлемента(); // "Confident"
			
			//Элемент Author
			ЗаписьXML.ЗаписатьНачалоЭлемента("Author");
			
				Если ТипЗнч(Документ) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
					
					Если Документ.ВидДокумента.ЯвляетсяОбращениемОтГраждан Тогда
						//Элемент PrivatePersonWithSign
						ЗаписьXML.ЗаписатьНачалоЭлемента("PrivatePersonWithSign");
						
							//Элемент Name
							ЗаписьXML.ЗаписатьНачалоЭлемента("Name");
							ЗаписьXML.ЗаписатьТекст(РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Отправитель)));
							ЗаписьXML.ЗаписатьКонецЭлемента(); // "Name"
						
						ЗаписьXML.ЗаписатьКонецЭлемента(); // "PrivatePersonWithSign"
					Иначе
						//Элемент OrganizationWithSign
						ЗаписьXML.ЗаписатьНачалоЭлемента("OrganizationWithSign");
						Если ПустаяСтрока(Документ.Отправитель.НаименованиеПолное) Тогда
							ЗаписьXML.ЗаписатьАтрибут("organization_string", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Отправитель.Наименование)));
						Иначе
							ЗаписьXML.ЗаписатьАтрибут("organization_string", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Отправитель.НаименованиеПолное)));
						КонецЕсли;
						
						ЗаписьXML.ЗаписатьКонецЭлемента(); // "OrganizationWithSign
					КонецЕсли;	
				
				Иначе
					
					//Элемент OrganizationWithSign
					ЗаписьXML.ЗаписатьНачалоЭлемента("OrganizationWithSign");
					НаименованиеОрганизации = РаботаСОрганизациями.ПолучитьНаименованиеОрганизации(Документ.Организация);
					ЗаписьXML.ЗаписатьАтрибут("organization_string", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(НаименованиеОрганизации)));
					
						//Элемент OfficialPersonWithSign
						ЗаписьXML.ЗаписатьНачалоЭлемента("OfficialPersonWithSign");
						
							//Элемент Name
							ЗаписьXML.ЗаписатьНачалоЭлемента("Name");
							Если ТипЗнч(Документ) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
								ЗаписьXML.ЗаписатьТекст(РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Подписал)));
							Иначе	
								ЗаписьXML.ЗаписатьТекст(РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(Документ.Утвердил)));
							КонецЕсли;	
							ЗаписьXML.ЗаписатьКонецЭлемента(); // "Name"
						
						ЗаписьXML.ЗаписатьКонецЭлемента(); // "OfficialPersonWithSign"
					
					ЗаписьXML.ЗаписатьКонецЭлемента(); // "OrganizationWithSign"
			
				КонецЕсли;	
			
			ЗаписьXML.ЗаписатьКонецЭлемента(); // "Author"
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // "Document"
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); // "Header"
	ЗаписьXML.Закрыть();
	
	Возврат ИмяВременногоФайла;
	
КонецФункции

// Заполняет входящий документ из XML файла, который содержит сообщение соответствующее
// ГОСТ Р 53898-2010 «Системы электронного документооборота. 
// Взаимодействие систем управления документами. Требования к электронному сообщению»
//
// Параметры:
//  Документ - СправочникСсылка.ВходящиеДокументы - Ссылка на входящий документ.
//  ИмяФайла - Имя файла на сервере, содержащего xml.
Процедура ЗагрузитьВходящийДокумент(Документ, ИмяФайла) Экспорт
	
	Файл = Новый ЧтениеXML;
	Файл.ОткрытьФайл(ИмяФайла);
	
	Путь = "";
	ПоследнийЭлемент = "";
	ДополнительноеСодержание = "";
	
	ОграничениеДоступаКДокументу = Ложь;
	
	Пока Файл.Прочитать() Цикл
		
		Если Файл.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ПоследнийЭлемент = Файл.Имя;
			Путь = Путь + "\" + ПоследнийЭлемент;
			
			Если НРег(Путь) = НРег("\Header\Document") Тогда
				Пока Файл.ПрочитатьАтрибут() Цикл
					Если Файл.Имя = "title" Тогда
						Документ.Наименование = Файл.Значение;
					ИначеЕсли Файл.Имя = "annotation" Тогда	
						Документ.Содержание = Файл.Значение;
					ИначеЕсли Файл.Имя = "type" Тогда
						Если Не ПустаяСтрока(ДополнительноеСодержание) Тогда
							ДополнительноеСодержание = ДополнительноеСодержание + Символы.ВК;
						КонецЕсли;
						ДополнительноеСодержание = ДополнительноеСодержание + НСтр("ru = 'Тип документа у контрагента: '");
						Если Файл.Значение = "0" Тогда
							ДополнительноеСодержание = ДополнительноеСодержание + НСтр("ru = 'Исходящий документ'");
						ИначеЕсли Файл.Значение = "1" Тогда
							ДополнительноеСодержание = ДополнительноеСодержание + НСтр("ru = 'Входящий документ'");
						ИначеЕсли Файл.Значение = "2" Тогда
							ДополнительноеСодержание = ДополнительноеСодержание + НСтр("ru = 'Внутренний документ'");
						КонецЕсли;	
					ИначеЕсли Файл.Имя = "kind" Тогда
						Если Не ПустаяСтрока(ДополнительноеСодержание) Тогда
							ДополнительноеСодержание = ДополнительноеСодержание + Символы.ВК;
						КонецЕсли;
						ДополнительноеСодержание = ДополнительноеСодержание + НСтр("ru = 'Вид документа у контрагента: '") + Файл.Значение;
					КонецЕсли;	
				КонецЦикла;
			КонецЕсли;
			
			Если НРег(Путь) = НРег("\Header\Document\RegNumber") Тогда
				Пока Файл.ПрочитатьАтрибут() Цикл
					Если Файл.Имя = "time" Тогда
						ДатаВремя = XMLЗначение(Тип("Дата"), Файл.Значение);
						ДатаВремя = МестноеВремя(ДатаВремя);
						Документ.ИсходящаяДата = ДатаВремя;
					КонецЕсли;	
				КонецЦикла;
			КонецЕсли;	
			
			Если НРег(Путь) = НРег("\Header\Document\Confident") Тогда
				Пока Файл.ПрочитатьАтрибут() Цикл
					Если Файл.Имя = "flag" Тогда
						Если Файл.Значение = "1" Тогда
							ОграничениеДоступаКДокументу = Истина;
						КонецЕсли;	
					КонецЕсли;	
				КонецЦикла;
			КонецЕсли;	
			
		ИначеЕсли Файл.ТипУзла = ТипУзлаXML.Текст Тогда	
			Если НРег(Путь) = НРег("\Header\Document\RegNumber") Тогда
				Документ.ИсходящийНомер = Файл.Значение;
			КонецЕсли;	
			
			Если НРег(Путь) = НРег("\Header\Document\Author\OrganizationWithSign\OfficialPersonWithSign\Name") Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	КонтактныеЛица.Ссылка
					|ИЗ
					|	Справочник.КонтактныеЛица КАК КонтактныеЛица
					|ГДЕ
					|	КонтактныеЛица.Наименование = &Наименование
					|	И КонтактныеЛица.Владелец = &Владелец";

				Запрос.УстановитьПараметр("Владелец", Документ.Отправитель);
				Запрос.УстановитьПараметр("Наименование", Файл.Значение);

				Результат = Запрос.Выполнить();

				ВыборкаДетальныеЗаписи = Результат.Выбрать();

				КонтактноеЛицо = Неопределено;
				Если ВыборкаДетальныеЗаписи.Следующий() Тогда
					КонтактноеЛицо = ВыборкаДетальныеЗаписи.Ссылка;
				Иначе	
					// Добавляем новое контактное лицо
					КонтактноеЛицо = Справочники.КонтактныеЛица.СоздатьЭлемент();
					КонтактноеЛицо.Владелец = Документ.Отправитель;
					КонтактноеЛицо.Наименование = Файл.Значение;
					КонтактноеЛицо.Комментарий = НСтр("ru = 'Создан при загрузке из почты входящего документа №'") + Документ.Код;
					КонтактноеЛицо.Записать();
				КонецЕсли;
				Документ.Подписал = КонтактноеЛицо.Ссылка;
			КонецЕсли;	
			
			Если НРег(Путь) = НРег("\Header\Document\Confident") И ОграничениеДоступаКДокументу Тогда
				Если Не ПустаяСтрока(ДополнительноеСодержание) Тогда
					ДополнительноеСодержание = ДополнительноеСодержание + Символы.ВК;
				КонецЕсли;	
				ДополнительноеСодержание = ДополнительноеСодержание + НСтр("ru = 'Гриф контрагента: '");
				ДополнительноеСодержание = ДополнительноеСодержание + Файл.Значение;
			КонецЕсли;	
			
		ИначеЕсли Файл.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Путь = Лев(Путь, СтрДлина(Путь) - СтрДлина(ПоследнийЭлемент) - 1);
		КонецЕсли;		
		
	КонецЦикла;
	
	Документ.Содержание = Документ.Содержание + Символы.ВК + ДополнительноеСодержание;

	Файл.Закрыть();
	
КонецПроцедуры
