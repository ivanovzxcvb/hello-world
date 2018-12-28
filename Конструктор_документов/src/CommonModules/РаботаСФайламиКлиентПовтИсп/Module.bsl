////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ФАЙЛАМИ
//

// Возвращает форму, которая используется при создании нового файла
// для выбора варианта создания
Функция ПолучитьФормуВыбораВариантаСозданияНовогоФайла() Экспорт
	
	ДоступнаКомандаСканировать = РаботаСоСканеромКлиентПовтИсп.ДоступнаКомандаСканировать();
	
	ПараметрыФормы = Новый Структура("ДоступнаКомандаСканировать", ДоступнаКомандаСканировать);
	Возврат ПолучитьФорму("Справочник.Файлы.Форма.ФормаНовогоСКнопкойСканера", ПараметрыФормы);
	
КонецФункции

// Возвращает форму, которая используется для информирования 
// пользователей об особенностях возврата файлов в веб-клиенте
Функция ПолучитьФормуНапоминанияПередПоместитьФайл() Экспорт
	Возврат ПолучитьФорму("Справочник.Файлы.Форма.ФормаНапоминанияПередПоместитьФайл");
КонецФункции

// Возвращает форму, которая используется при возврате отредактированного 
// файла на сервер
Функция ПолучитьФормуВозвратаФайла() Экспорт
	Возврат ПолучитьФорму("Справочник.Файлы.Форма.ФормаВозвратаФайла");
КонецФункции

// Возвращает форму, которая используется для ввода 
// режима сохранения при экспорте папки, если на диске уже есть файл с таким именем
Функция ПолучитьФормуЭкспортаПапкиФайлСуществует() Экспорт
	Возврат ПолучитьФорму("Справочник.Файлы.Форма.ФайлСуществует");
КонецФункции

