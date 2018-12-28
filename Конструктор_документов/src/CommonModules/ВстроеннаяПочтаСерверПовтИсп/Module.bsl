// Возвращает строку, содержащую представление адресата
Функция ПолучитьПочтовогоАдресата(Адрес, Представление = Неопределено) Экспорт
	
	Возврат ВстроеннаяПочтаСервер.ПолучитьПочтовогоАдресата(Адрес, Представление);
	
КонецФункции

// Возвращает значение константы ВестиПротоколДоставкиПочты
Функция ПолучитьВестиПротоколДоставкиПочты() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ВестиПротоколДоставкиПочты.Получить();
	
КонецФункции

// Возвращает значение константы СокращатьИнформациюОПисьмеПриОтвете
Функция ПолучитьСокращатьИнформациюОПисьмеПриОтвете() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.СокращатьИнформациюОПисьмеПриОтвете.Получить();
	
КонецФункции

// Возвращает значение константы ПомечатьКаждуюСтрокуИсходногоПисьмаПриОтвете
Функция ПолучитьПомечатьКаждуюСтрокуИсходногоПисьмаПриОтвете() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ПомечатьКаждуюСтрокуИсходногоПисьмаПриОтвете.Получить();
	
КонецФункции

// Возвращает значение константы СокращатьИнформациюОПисьмеПриПересылке
Функция ПолучитьСокращатьИнформациюОПисьмеПриПересылке() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.СокращатьИнформациюОПисьмеПриПересылке.Получить();
	
КонецФункции

// Возвращает значение константы ПомечатьКаждуюСтрокуИсходногоПисьмаПриПересылке
Функция ПолучитьПомечатьКаждуюСтрокуИсходногоПисьмаПриПересылке() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ПомечатьКаждуюСтрокуИсходногоПисьмаПриПересылке.Получить();
	
КонецФункции

// Возвращает значение константы СокращатьПредставлениеАдресатов
Функция ПолучитьСокращатьПредставлениеАдресатов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.СокращатьПредставлениеАдресатов.Получить();
	
КонецФункции

// Возвращает значение константы ЧислоАдресатовДляКраткогоПредставления
Функция ПолучитьЧислоАдресатовДляКраткогоПредставления() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ЧислоАдресатовДляКраткогоПредставления.Получить();
	
КонецФункции

// Возвращает значение константы СимволЦитированияВПереписке
Функция ПолучитьСимволЦитированияВПереписке() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.СимволЦитированияВПереписке.Получить();
	
КонецФункции

// Возвращает вид цитирования для HTML
Функция ПолучитьВидЦитированияПриОтвете() Экспорт
	
	Возврат ВстроеннаяПочтаСервер.ПолучитьВидЦитированияПриОтвете();
	
КонецФункции	

// получить значение константы СворачиватьПрефиксОтветаИПересылкиВТемеПисьма
Функция ПолучитьСворачиватьПрефиксОтветаИПересылкиВТемеПисьма() Экспорт
	Возврат ВстроеннаяПочтаСервер.ПолучитьСворачиватьПрефиксОтветаИПересылкиВТемеПисьма();
КонецФункции	

// Получает учетные записи, где текущий пользователь - Ответственный
Функция ПолучитьУчетныеЗаписиТекущегоПользователя() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем.Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты.ОтветственныеЗаОбработкуПисем КАК УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем
		|ГДЕ
		|	УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем.Пользователь = &Пользователь
		|	И УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем.Ссылка.ВариантИспользования = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияПочты.Встроенная)
		|	И УчетныеЗаписиЭлектроннойПочтыОтветственныеЗаОбработкуПисем.Ссылка.ПометкаУдаления = ЛОЖЬ";
		
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	МассивУчетныхЗаписей = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
	Возврат МассивУчетныхЗаписей;
	
КонецФункции

// Кеширует вызов ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку
Функция ПолучитьПерсональнуюНастройку(Настройка) Экспорт
	Возврат ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку(Настройка);
КонецФункции	

// Возвращает соответствие для поиска символов перевода строки
Функция ПолучитьСоответствиеСимволовПереводаСтроки() Экспорт
	
	Результат = Новый Соответствие;
 	Результат.Вставить(Символы.ВК, Символы.ВК);
    Результат.Вставить(Символы.ВТаб, Символы.ВТаб);
	Результат.Вставить(Символы.ПС, Символы.ПС);
    Результат.Вставить(Символы.ПФ, Символы.ПФ);
    Результат.Вставить(Символы.Таб, Символы.Таб);	
	Результат.Вставить(Символ(32), Символ(32));
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение константы ИспользоватьInternetExplorerДляПолученияТекстаИзHTML
Функция ПолучитьИспользоватьInternetExplorerДляПолученияТекстаИзHTML() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ИспользоватьInternetExplorerДляПолученияТекстаИзHTML.Получить();
	
КонецФункции
