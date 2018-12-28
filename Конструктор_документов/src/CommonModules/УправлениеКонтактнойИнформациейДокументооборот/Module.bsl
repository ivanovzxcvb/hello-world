
// Процедура обновления ИБ для справочника видов контактной информации.
Процедура КонтактнаяИнформацияОбновлениеИБ() Экспорт
	
	// Справочник "Организации"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 1;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 3;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
		
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ФаксОрганизации;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Факс;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 4;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailОрганизации;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 5;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 6;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Другое");
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияОрганизации;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Другое;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 7;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	// Справочник "Контактные лица"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 3;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	// Справочник "Контрагенты"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ФактическийАдресКонтрагента;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ЮридическийАдресКонтрагента;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 3;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 4;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ФаксКонтрагента;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Факс;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 5;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
		
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтрагента;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 6;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
		
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.СайтКонтрагента;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 7;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
		
	// Справочник "Физические лица"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ДомашнийАдресФизическогоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ДомашнийТелефонФизическогоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.МобильныйТелефонФизическогоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 3;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 4;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 4;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	// Справочник "Личные адресаты"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailАдресата;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ФаксАдресата;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Факс;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 3;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАдресата;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 4;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	// Справочник "РолиИсполнителей"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации();
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailРоли;
	ПараметрыВида.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение = Ложь;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры
