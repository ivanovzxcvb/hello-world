////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик вызывается перед завершением работы системы при обновлении конфигурации из помощника.
//
// Пример реализации:
// #Если Клиент Тогда
//		  глЗапрашиватьПодтверждениеПриЗакрытии = Ложь;
// #КонецЕсли
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
КонецПроцедуры

// Проверить, что информационную базу можно обновить.
// Например, если выясняется, что обновление конфигурации не пройдет или 
// будет идти с проблемами, то пользователю выдается предупреждение, и 
// предлагается самостоятельно устранить причины, после чего 
// повторить попытку обновления.
//
// Параметры:
//	КонфигурацияГотоваКОбновлению - Булево - признак готовности ИБ к проведению обновления.
//
// Пример реализации:
//
//	КонфигурацияГотоваКОбновлению = ПроверитьКорректностьДанных();
//	Если Не КонфигурацияГотоваКОбновлению И ВыдаватьСообщения Тогда
//		Предупреждение("Конфигурация не может быть обновлена, так как ...");
//	КонецЕсли;
//
Процедура ПриОпределенииГотовностиКОбновлениюКонфигурации(КонфигурацияГотоваКОбновлению) Экспорт
	
КонецПроцедуры

// Получить адрес веб-страницы с информацией о том, как получить доступ к 
// пользовательскому разделу на сайте поставщика конфигурации.
//
// Параметры:
//	АдресСтраницы - Строка - адрес веб-страницы.
//
Процедура ПриОпределенииАдресаСтраницыПолученияДоступаКСайтуОбновлений(АдресСтраницы) Экспорт
	
КонецПроцедуры

// Проверят необходимость проверки обновления для следующей редакции платформы.
// Рекомендуется устанавливать значение Истина, только при следующих условиях:
// - Для конфигурации используется обновление с сайта поддержки пользователей системы 1С:Предприятие.
// - Вышла новая редакция платформы.
// - Конфигурация поддерживает прямое обновление на новую версию, использующую новую редакцию платформы.
//
// Если процедура устанавливает значение Истина, то при проверке обновления на сайте поддержки пользователей
// в случае если не найдено обновлений для текущей редакции платформы программа автоматически проверит
// обновления для следующей редакции платформы.
// 
// Параметры:
//	ПроверятьОбновление - Булево - Признак необходимости проверки обновления для следующей редакции.
//
Процедура ПриПроверкеОбновленияДляСледующейРедакцииПлатформы(ПроверятьОбновление) Экспорт
	
КонецПроцедуры

// Признак необходимости использования проверки легальности скачивания обновления.
// Рекомендуется устанавливать значение Истина, если конфигурация поддерживает обновление
// с сайта поддержки пользователей.
//
Процедура ПриПроверкеЛегальностиСкачиванияОбновлений(ПроверятьЛегальность) Экспорт
	
КонецПроцедуры

// Обработчик вызывается при скачивании файла обновления из Интернета
//
// Параметры:
//    URL, ПараметрыПолучения       - см. описание одноименных параметров
//                                    в ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте.
//    Результат                     - см. описание возвращаемого значения в процедуре
//                                    ПолучениеФайловИзИнтернетаКлиент.СкачатьФайлНаКлиенте.
//    СтандартнаяОбработка - Булево - Признак использования стандартного получения файла
//
Процедура ПриСкачиванииФайлаОбновления(URL, ПараметрыПолучения, Результат, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти
