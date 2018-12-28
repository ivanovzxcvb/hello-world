////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ РЕАЛИЗАЦИЮ МЕХАНИКИ ПРОТОКОЛИРОВАНИЯ РАБОТЫ ПОЛЬЗОВАТЕЛЕЙ
// 

// Возвращает значение константы ИспользоватьПротоколированиеРаботыПользователей.
Функция ПолучитьИспользоватьПротоколированиеРаботыПользователей() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ИспользоватьПротоколированиеРаботыПользователей.Получить();
	
КонецФункции	

// Делает запись в регистр сведений ПротоколРаботыПользователей.
Процедура Записать(ПараметрыЗаписи) Экспорт
	
	Если НЕ ПротоколированиеРаботыПользователейПовтИсп.ПолучитьИспользоватьПротоколированиеРаботыПользователей() Тогда
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбъектДанных = ПараметрыЗаписи.ОбъектДанных;
	Если Не ЗначениеЗаполнено(ОбъектДанных) Тогда
		ОбъектДанных = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ПротоколРаботыПользователей.СоздатьНаборЗаписей();
	
	ДатаЗаписи = ТекущаяДата();
	НаборЗаписей.Отбор.Дата.Установить(ДатаЗаписи);
	НаборЗаписей.Отбор.ОбъектДанных.Установить(ОбъектДанных);
	НаборЗаписей.Отбор.Пользователь.Установить(ПользователиКлиентСервер.ТекущийПользователь());
	НаборЗаписей.Отбор.ТипСобытия.Установить(ПараметрыЗаписи.ТипСобытия);

	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Дата = ДатаЗаписи;
	НоваяЗапись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	НоваяЗапись.ТипСобытия = ПараметрыЗаписи.ТипСобытия;
	НоваяЗапись.ОбъектДанных = ОбъектДанных;
	НоваяЗапись.Длительность = ПараметрыЗаписи.Длительность;
	НоваяЗапись.ДополнительныеСведения = ПараметрыЗаписи.ДополнительныеСведения;
	НоваяЗапись.ОписаниеСобытия = ПараметрыЗаписи.ОписаниеСобытия;
	ТекСеанс = ПолучитьТекущийСеансИнформационнойБазы(); 
	НоваяЗапись.ИмяКомпьютера = ТекСеанс.ИмяКомпьютера; 

	НаборЗаписей.Записать();
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при открытии карточки.
Процедура ЗаписатьОткрытие(ОбъектДанных) Экспорт
	
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.Просмотр, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при интерактивном изменении объекта.
Процедура ЗаписатьИзменение(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.Изменение, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при не-интерактивной пометке удаления объекта.
Процедура ЗаписатьПометкуУдаления(ОбъектДанных, ПометкаУдаления) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		Если ПометкаУдаления Тогда
			ТипСобытия = Перечисления.ТипыСобытийПротоколаРаботыПользователей.УстановкаПометкиУдаления;
		Иначе
			ТипСобытия = Перечисления.ТипыСобытийПротоколаРаботыПользователей.СнятиеПометкиУдаления;
		КонецЕсли;		
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, ТипСобытия, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при интерактивном создании объекта.
Процедура ЗаписатьСоздание(ОбъектДанных, ЭтоНовыйОбъект) Экспорт
		
	Если ЭтоНовыйОбъект И Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.Создание, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при интерактивном получении файла.
Процедура ЗаписатьПолучениеФайла(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ПолучениеФайла, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при полнотекстовом поиске.
Процедура ЗаписатьПолнотекстовыйПоиск(Длительность, ОписаниеСобытия, ДополнительныеСведения) Экспорт
		
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		Неопределено, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ПолнотекстовыйПоиск, Длительность, ОписаниеСобытия, ДополнительныеСведения);
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при поиске по реквизитам.
Процедура ЗаписатьПоискПоРеквизитам(Длительность, ОписаниеСобытия, ДополнительныеСведения) Экспорт
		
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		Неопределено, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ПоискПоРеквизитам, Длительность, ОписаниеСобытия, ДополнительныеСведения);
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при входе в систему.
Процедура ЗаписатьВходВСистему() Экспорт
	
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		Неопределено, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ВходВСистему, 0, "", "");
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при выходе из системы.
Процедура ЗаписатьВыходИзСистемы() Экспорт
	
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		Неопределено, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ВыходИзСистемы, 0, "", "");
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при отправке по почте.
Процедура ЗаписатьОтправкуПоПочте(ОбъектДанных, ОписаниеСобытия) Экспорт
		
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ОтправкаПоПочте, 
		0, ОписаниеСобытия, "");
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при приемке почты.
Процедура ЗаписатьПолучениеПочты(ОбъектДанных, ОписаниеСобытия) Экспорт
		
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ЗагрузкаПочты, 
		0, ОписаниеСобытия, "");
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при загрузке почты.
Процедура ЗаписатьЗагрузкуПочты(ОбъектДанных, ОписаниеСобытия, ДополнительныеСведения) Экспорт
		
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ЗагрузкаПочты, 0, ОписаниеСобытия, ДополнительныеСведения);
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при изменении файла 
// (например, при выполнении команды "Закончить редактирование")
Процедура ЗаписатьИзменениеФайла(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ИзменениеФайла, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при регистрации документа.
Процедура ЗаписатьРегистрациюДокумента(ОбъектДанных, РегистрационныйНомер) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Регистрационный номер: %1'"), Строка(РегистрационныйНомер));
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.РегистрацияДокумента, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при сканировании.
Процедура ЗаписатьСканирование(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.Сканирование, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при импорте файлов.
Процедура ЗаписатьИмпортФайлов(ОбъектДанных, ПолноеИмя) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Путь импортированного файла: %1'"), ПолноеИмя);
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ИмпортФайла, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при экспорте файлов.
Процедура ЗаписатьЭкспортФайлов(ОбъектДанных, ПолныйПуть) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Путь экспорта файла: %1'"), ПолныйПуть);
		
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ЭкспортПапки, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при выполнении команды "Сохранить как" для файла.
Процедура ЗаписатьСохранитьКак(ОбъектДанных, ПолныйПуть) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Путь сохранения файла: %1'"), ПолныйПуть);
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.СохранениеНаДиск, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при изменении прав на объект.
Процедура ЗаписатьИзменениеПрав(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ИзменениеПравДоступа, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при перенаправлении задачи.
Процедура ЗаписатьПеренаправлениеЗадачи(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ПеренаправлениеЗадачи, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при старте бизнес процесса.
Процедура ЗаписатьСтартБизнесПроцесса(ОбъектДанных, ПараметрыЗаписи) Экспорт
		
	Если Не ОбъектДанных.Пустая() 
		И (ПараметрыЗаписи.Свойство("Старт") Или ПараметрыЗаписи.Свойство("ФоновыйСтартПроцесса")) Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.СтартБизнесПроцесса, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при прерывании бизнес процесса.
Процедура ЗаписатьПрерываниеБизнесПроцесса(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ПрерываниеБизнесПроцесса, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при установке подписи ЭП.
Процедура ЗаписатьПодписаниеЭП(ОбъектДанных, КомуВыданСертификат, Комментарий) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Сертификат:%1  Комментарий:%2'"), КомуВыданСертификат, Комментарий);
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ПодписаниеЭП, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при удалении подписи ЭП.
Процедура ЗаписатьУдалениеПодписиЭП(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.УдалениеПодписиЭП, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при шифровании.
Процедура ЗаписатьШифрование(ОбъектДанных, СтрокаСертификатов) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Сертификаты: %1'"), СтрокаСертификатов);
		
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.Шифрование, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при расшифровывании.
Процедура ЗаписатьРасшифрование(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.Расшифровывание, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при перемещении файла.
Процедура ЗаписатьПеремещениеФайла(ОбъектДанных, ПапкаОткуда, ПапкаКуда) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Исходная папка: %1   Папка, куда переместили: %2'"), ПапкаОткуда, ПапкаКуда);
		
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ПеремещениеФайлов, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при удалении записей регламентным заданием.
Процедура ЗаписатьУдалениеЗаписейПротоколаРаботыПользователей(ДатаОтсечения, ПутьФайлаZip) Экспорт
		
	ДополнительныеСведения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Удалены записи с датой более старой, чем дата: %1.  Удаленные записи сохранены в файле: %2'"), ДатаОтсечения, ПутьФайлаZip);
	
	ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
		Неопределено, Перечисления.ТипыСобытийПротоколаРаботыПользователей.УдалениеЗаписейПротоколаРаботыПользователей, 0, "", ДополнительныеСведения);
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при добавлении элемента в комплект или при удалении элемента из комплекта.
Процедура ЗаписатьИзменениеСоставаКомплекта(Комплект, Описание) Экспорт
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ОбъектДанных", Комплект);
	ПараметрыЗаписи.Вставить("ТипСобытия", Перечисления.ТипыСобытийПротоколаРаботыПользователей.ИзменениеСоставаКомплекта);
	ПараметрыЗаписи.Вставить("Длительность", 0);
	ПараметрыЗаписи.Вставить("ОписаниеСобытия", "");
	ПараметрыЗаписи.Вставить("ДополнительныеСведения", Описание);
	
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

// Удаляет протоколы старше определенной даты, сперва записывая их в mxl файл на диск.
Процедура ОбработкаПротоколаРаботыПользователей() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаНачала = ТекущаяДата();
	
	Пока ВыполнитьОбработкуПротоколаРаботыПользователей(ДатаНачала) Цикл
	КонецЦикла;	

КонецПроцедуры

// Удаляет протоколы старше определенной даты, сперва записывая их в mxl файл на диск. 
Функция ВыполнитьОбработкуПротоколаРаботыПользователей(ДатаНачала)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СрокХраненияПротоколаРаботыПользователей = Константы.СрокХраненияПротоколаРаботыПользователей.Получить();
	Если СрокХраненияПротоколаРаботыПользователей = 0 Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	КаталогСохраненияКопииПротоколаРаботыПользователей = "";
	
	ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 Или ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		КаталогСохраненияКопииПротоколаРаботыПользователей = Константы.КаталогСохраненияКопииПротоколаРаботыПользователейWindows.Получить();
	Иначе	
		КаталогСохраненияКопииПротоколаРаботыПользователей = Константы.КаталогСохраненияКопииПротоколаРаботыПользователейLinux.Получить();
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(КаталогСохраненияКопииПротоколаРаботыПользователей) Тогда
		Возврат Ложь;
	КонецЕсли;	
	КаталогСохраненияКопииПротоколаРаботыПользователей = 
		ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			КаталогСохраненияКопииПротоколаРаботыПользователей, ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера());
	
	ДатаОтсечения = ДатаНачала - СрокХраненияПротоколаРаботыПользователей * 86400 * 30; // 86400 (сек в сутках) * 30(дней в месяце)
	
	Если НЕ ПротоколированиеРаботыПользователейПовтИсп.ПолучитьИспользоватьПротоколированиеРаботыПользователей() Тогда
		ДатаОтсечения = ДатаНачала + 86400 * 30; // если функциональную опцию протоколирования выключили - очищаем ВСЕ записи - для этого ставим дату отсечения на месяц вперед от текущей
	КонецЕсли;	
	
	Запрос = Новый Запрос;

	Макет = РегистрыСведений.ПротоколРаботыПользователей.ПолучитьМакет("Макет");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПротоколРаботыПользователей.Дата КАК Дата,
		|	ПротоколРаботыПользователей.Пользователь,
		|	ПротоколРаботыПользователей.Пользователь.Наименование,
		|	ПротоколРаботыПользователей.ОбъектДанных,
		|	ПРЕДСТАВЛЕНИЕ(ПротоколРаботыПользователей.ОбъектДанных),
		|	ПротоколРаботыПользователей.ТипСобытия,
		|	ПротоколРаботыПользователей.ОписаниеСобытия,
		|	ПротоколРаботыПользователей.ДополнительныеСведения,
		|	ПротоколРаботыПользователей.Длительность
		|ИЗ
		|	РегистрСведений.ПротоколРаботыПользователей КАК ПротоколРаботыПользователей
		|ГДЕ
		|	ПротоколРаботыПользователей.Дата <= &ДатаОтсечения
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";

	Запрос.УстановитьПараметр("ДатаОтсечения", ДатаОтсечения);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;	

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок = Новый ТабличныйДокумент;
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	ЗаписиДляУдаления = Новый Массив;
	ЧислоВыбранныхЗаписей = 0;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
		ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень());
		
		СтруктураДляУдаления = Новый Структура("Дата, ОбъектДанных, Пользователь, ТипСобытия",
			ВыборкаДетальныеЗаписи.Дата, ВыборкаДетальныеЗаписи.ОбъектДанных, 
			ВыборкаДетальныеЗаписи.Пользователь, ВыборкаДетальныеЗаписи.ТипСобытия);
		ЗаписиДляУдаления.Добавить(СтруктураДляУдаления);
		
		ЧислоВыбранныхЗаписей = ЧислоВыбранныхЗаписей + 1;
		
		Если ЧислоВыбранныхЗаписей >= 50000 Тогда
			Прервать;
		КонецЕсли;	
		
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
	
	Если ЗаписиДляУдаления.Количество() > 0 Тогда
		ИмяФайла = "protocol_" + Формат(ТекущаяДата(), "ДФ=yyyy-MM-dd-hh-mm-ss"); // protocolDDMMYYYY.mxl
		ПутьФайлаMxl = КаталогСохраненияКопииПротоколаРаботыПользователей + ИмяФайла + ".mxl";
		ТабДок.Записать(ПутьФайлаMxl);
		
		ПутьФайлаZip = КаталогСохраненияКопииПротоколаРаботыПользователей + ИмяФайла + ".zip";
		
		// сжимаем в zip
		Архиватор = Новый ЗаписьZipФайла(ПутьФайлаZip, "", "");
		Архиватор.Добавить(ПутьФайлаMxl);
		Архиватор.Записать();
		
		// удаляем mxl
		УдалитьФайлы(ПутьФайлаMxl);
		
		// удаляем записи в регистре
		Для Каждого ЗаписьДляУдаления Из ЗаписиДляУдаления Цикл
			
			НаборЗаписей = РегистрыСведений.ПротоколРаботыПользователей.СоздатьНаборЗаписей();
			
			НаборЗаписей.Отбор.Дата.Установить(ЗаписьДляУдаления.Дата);
			НаборЗаписей.Отбор.ОбъектДанных.Установить(ЗаписьДляУдаления.ОбъектДанных);
			НаборЗаписей.Отбор.Пользователь.Установить(ЗаписьДляУдаления.Пользователь);
			НаборЗаписей.Отбор.ТипСобытия.Установить(ЗаписьДляУдаления.ТипСобытия);
			
			НаборЗаписей.Записать();
			
		КонецЦикла;
		
		ЗаписатьУдалениеЗаписейПротоколаРаботыПользователей(ДатаОтсечения, ПутьФайлаZip);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Делает запись в регистр сведений ПротоколРаботыПользователей при изменении у объекта свойства Действителен.
Процедура ЗаписатьИзменениеДействительностиОбъекта(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
	
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ИзменениеДействительностиОбъекта, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при изменении предмета бизнес-процесса.
Процедура ЗаписатьИзменениеПредметаБизнесПроцесса(ОбъектДанных, Предмет) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		Если ЗначениеЗаполнено(Предмет) Тогда
			ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Новый предмет: %1'"),
				Предмет); 
		Иначе
			ОписаниеСобытия = НСтр("ru = 'Предмет очищен'");
		КонецЕсли; 
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ИзменениеПредметаБизнесПроцесса, 0, ОписаниеСобытия, "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры

// Делает запись в регистр сведений ПротоколРаботыПользователей при изменении состава рабочей группы.
Процедура ЗаписатьИзменениеРабочейГруппы(ОбъектДанных, Описание) Экспорт

	Если Не ОбъектДанных.Пустая() Тогда

		ПараметрыЗаписи = 
			Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.ИзменениеРабочейГруппыОбъекта, 0, "", Описание);

		Записать(ПараметрыЗаписи);

	КонецЕсли;

КонецПроцедуры

// Возвращает записи регистра сведений ПротоколРаботыПользователей по заданному объекту 
// и параметрам отбора
// 
// Параметры:
//  ОбъектДанных - Ссылка - объект по которому производится выборка
//  ПараметрыОтбора - Структура - дополнительные параметры отбора 
//
// Возвращаемое значение:
//  ТаблицаЗначений - результат выборки регистра
//
Функция ВыбратьЗаписиПротоколаРаботыПользователейПоОбъекту(ОбъектДанных, ПараметрыОтбора = Неопределено) Экспорт

	Если НЕ ПротоколированиеРаботыПользователейПовтИсп.ПолучитьИспользоватьПротоколированиеРаботыПользователей() Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПостроительЗапроса = Новый ПостроительЗапроса();
		
	ПостроительЗапроса.Текст = 
		"ВЫБРАТЬ
		|	ПротоколРаботыПользователей.Дата,
		|	ПротоколРаботыПользователей.Пользователь,
		|	ПротоколРаботыПользователей.ТипСобытия
		|ИЗ
		|	РегистрСведений.ПротоколРаботыПользователей КАК ПротоколРаботыПользователей
		|ГДЕ
		|	ПротоколРаботыПользователей.ОбъектДанных = &ОбъектДанных
		|{ГДЕ
		|	ПротоколРаботыПользователей.Пользователь.*,
		|	ПротоколРаботыПользователей.ТипСобытия.*}";

	Если ТипЗнч(ПараметрыОтбора) = Тип("Структура") Тогда
		Пользователь = Неопределено;	
		Если ПараметрыОтбора.Свойство("Пользователь", Пользователь) Тогда		
			НовыйПараметр = ПостроительЗапроса.Отбор.Добавить("Пользователь");
			НовыйПараметр.Установить(Пользователь);
		КонецЕсли;	
			
		ТипСобытия = Неопределено;
		Если ПараметрыОтбора.Свойство("ТипСобытия", ТипСобытия) Тогда
			НовыйПараметр = ПостроительЗапроса.Отбор.Добавить("ТипСобытия");
			НовыйПараметр.Установить(ТипСобытия);
		КонецЕсли;		
	КонецЕсли;
	
	ПостроительЗапроса.Параметры.Вставить("ОбъектДанных", ОбъектДанных);

	ПостроительЗапроса.Выполнить();
	
	Если ПостроительЗапроса.Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе	
		Возврат ПостроительЗапроса.Результат.Выгрузить();
	КонецЕсли;	
	
КонецФункции

// Возвращает информацию о том, кто и когда прервал бизнес процесс
//
// Возвращаемое значение:
//  Структура - Дата - дата прерывания процесса, Пользователь - пользователь прервавший процесс
//
Функция ИнформацияОПрерыванииПроцессаИзПротокола(БизнесПроцесс) Экспорт
	
	Результат = Неопределено;
	
	ПараметрыОтбора = Новый Структура(
		"ТипСобытия", 
		ПредопределенноеЗначение(
			"Перечисление.ТипыСобытийПротоколаРаботыПользователей.ПрерываниеБизнесПроцесса"));
			
	ЗаписиПротокола = ВыбратьЗаписиПротоколаРаботыПользователейПоОбъекту(
		БизнесПроцесс, 
		ПараметрыОтбора);
	
	Если ЗаписиПротокола <> Неопределено Тогда
		Результат = Новый Структура("Дата, Пользователь");
		ЗаполнитьЗначенияСвойств(Результат, ЗаписиПротокола[0]);		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Делает запись в регистр сведений ПротоколРаботыПользователей 
// при удалении смене свойства ОбязательныйДляШифрования
// ОбъектДанных - справочник СертификатыКлючейЭлектроннойПодписиИШифрования
Процедура ЗаписатьСменуСвойстваСертификатаОбязательныйДляШифрования(ОбъектДанных) Экспорт
		
	Если Не ОбъектДанных.Пустая() Тогда	
		
		ПараметрыЗаписи = Новый Структура("ОбъектДанных, ТипСобытия, Длительность, ОписаниеСобытия, ДополнительныеСведения",
			ОбъектДанных, Перечисления.ТипыСобытийПротоколаРаботыПользователей.СменаСвойстваСертификатаОбязательныйДляШифрования, 0, "", "");
		
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;	
	
КонецПроцедуры
