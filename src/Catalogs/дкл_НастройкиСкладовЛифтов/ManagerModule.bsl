#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс            

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция ВерсияПО(НастройкаСклада)  Экспорт
	//@skip-check wrong-string-literal-content
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаСклада, "ВерсияПО");
КонецФункции // ()

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция ЗначенияРеквизитов(НастройкаСклада, СписокРеквизитов)  Экспорт
	//@skip-check wrong-string-literal-content
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаСклада, СписокРеквизитов);
КонецФункции // ()

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
//@skip-check doc-comment-export-function-return-section
Функция ВидАСХ(НастройкаСклада) Экспорт
	//@skip-check wrong-string-literal-content
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаСклада, "ВидАСХ");
КонецФункции           

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
Процедура ПроверитьСоединения() Экспорт       
	
	Запрос = Новый Запрос;       
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дкл_НастройкиСкладовЛифтов.Ссылка КАК НастройкаСклада
		|ИЗ
		|	Справочник.дкл_НастройкиСкладовЛифтов КАК дкл_НастройкиСкладовЛифтов
		|ГДЕ
		|	дкл_НастройкиСкладовЛифтов.Активность
		|	И НЕ дкл_НастройкиСкладовЛифтов.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПроверитьСоединениеВФоне(ВыборкаДетальныеЗаписи.НастройкаСклада);
	КонецЦикла;
	
КонецПроцедуры            

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
Процедура ПроверитьСоединениеВФоне(НастройкаСклада) Экспорт
	
	ПараметрыФоновогоЗадания = Новый Массив;
	ПараметрыФоновогоЗадания.Добавить(НастройкаСклада); 
	ФоновыеЗадания.Выполнить("дкл_ОбщегоНазначенияСервер.ПроверитьСоединение",
				ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, 
					"Проверить соединение дкл_"); 	
	
КонецПроцедуры            

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
//@skip-check doc-comment-export-function-return-section
Функция ПроверитьСоединение(НастройкаСклада, НомерСтатуса = Неопределено, Статус = Неопределено, БуквенныйКод = Неопределено) Экспорт             

	Результат = дкл_ОбменДаннымиСервер.ПолучитьСтатусСклада(НастройкаСклада);
	
	БуквенныйКод = Результат.БуквенныйКод;
	
	Если Результат.НаСвязи И Результат.ВРаботе Тогда
		НомерСтатуса = 2;
		Статус = "В работе";
	ИначеЕсли Результат.НаСвязи И НЕ Результат.ВРаботе Тогда
		НомерСтатуса = 3;			
		Статус = "На связи, не в работе";
		Если ЗначениеЗаполнено(Результат.Статус) Тогда
			ОбщегоНазначения.СообщитьПользователю(Результат.Статус);		
		КонецЕсли;
	Иначе	
		НомерСтатуса = 1;   
		Статус = "Ошибка";
		Если ЗначениеЗаполнено(Результат.Статус) Тогда
			ОбщегоНазначения.СообщитьПользователю(Результат.Статус);		
		КонецЕсли;
	КонецЕсли;
	
	ЗаписатьСостояниеСкладаЛифта(НастройкаСклада, Результат, НомерСтатуса, Статус, БуквенныйКод);
	
	Возврат Результат.ВРаботе;
КонецФункции            

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
//@skip-check doc-comment-export-function-return-section
Функция ПроверитьСтрокуСоединения(НастройкаСклада, ВывестиСообщение = Ложь) Экспорт
	
	Результат = Истина;

	Возврат Результат;
	
	//@skip-check unreachable-statement
	УстановитьПривилегированныйРежим(Истина);

	// надо придумать проверки в разных режимах...
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаСклада, "СтрокаСоединения");
	
	Если НЕ ВРЕГ(ЗначенияРеквизитов.СтрокаСоединения) = ВРЕГ(СтрокаСоединенияИнформационнойБазы()) Тогда
		Если ВывестиСообщение Тогда
			Текст = "Строка соединения АСХ ""%1"" не совпадает с %2.";
			Текст = СтрШаблон(Текст, НастройкаСклада, СтрокаСоединенияИнформационнойБазы());
			ОбщегоНазначения.СообщитьПользователю(Текст);
		КонецЕсли;
		Результат = Ложь;  
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции // ()

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
//@skip-check doc-comment-export-function-return-section
Функция ПолучитьРеквизитыSKU(Номенклатура, Характеристика = Неопределено, Упаковка = Неопределено) Экспорт

	//@skip-check structure-consructor-too-many-keys
	Результат = Новый Структура("Номенклатура, Характеристика, Упаковка, 
		|itemId, extraCode, itemName, unit, vendorNumber, height, width, depth, weight, barcode");
	
	Запрос = Новый Запрос;    
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", ?(ЗначениеЗаполнено(Характеристика), Характеристика, Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка()));
	Запрос.УстановитьПараметр("Упаковка", ?(ЗначениеЗаполнено(Упаковка), Упаковка, Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка()));
	Запрос.УстановитьПараметр("itemId", Строка(Новый УникальныйИдентификатор));
	//ToDo: пока так...
	Запрос.УстановитьПараметр("unit", "EACH");
	Запрос.Текст =   
	//ToDo: не понятно на какие реквизиты ориентироваться, это не типовые:
	//ToDo: если штрихкодов несколько, какой брать...
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Номенкл.Ссылка КАК Номенклатура,
	|	&Характеристика КАК Характеристика,
	|	&Упаковка КАК Упаковка,
	|	&itemId КАК itemId,
	|	&unit КАК unit,
	|	Номенкл.Код КАК extraCode,
	// не типовые реквизиты
	|	Номенкл.Дк_Высота КАК height,
	|	Номенкл.Дк_Ширина КАК width,
	|	Номенкл.Дк_Глубина КАК depth,
	|	Номенкл.Дк_ВесБрутто КАК weight,
	// наименование собираем как Н + Х + У:
	|	ВЫБОР
	|		КОГДА НЕ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				И НЕ &Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА Номенкл.Наименование + "", "" + Характеристики.Наименование + "", "" + Упаковки.Наименование
	|		КОГДА НЕ &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				И &Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА Номенкл.Наименование + "", "" + Характеристики.Наименование
	|		КОГДА &Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				И НЕ &Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА Номенкл.Наименование + "", , "" + Упаковки.Наименование
	|		ИНАЧЕ Номенкл.Наименование
	|	КОНЕЦ КАК itemName,
	|	Номенкл.Артикул КАК vendorNumber,
	|	ШтрихкодыНоменклатуры.Штрихкод КАК barcode
	|ИЗ
	|	Справочник.Номенклатура КАК Номенкл
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО (ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура)
	|			И (ШтрихкодыНоменклатуры.Упаковка = &Упаковка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК Характеристики
	|		ПО (Характеристики.Ссылка = &Характеристика) 
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК Упаковки
	|		ПО (Упаковки.Ссылка = &Упаковка) 
	|ГДЕ
	|	Номенкл.Ссылка = &Номенклатура";                                                       
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(Результат, Выборка);
	
	Возврат Результат;

КонецФункции // ()

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
Процедура ЗаписатьСостояниеСкладаЛифта(
		НастройкаСклада, Результат, НомерСтатуса = Неопределено, Статус = Неопределено, БуквенныйКод = Неопределено) Экспорт
		
	Если НЕ ЗначениеЗаполнено(НастройкаСклада) Тогда
		Возврат;	
	КонецЕсли;
		
	НаборЗаписей = РегистрыСведений.дкл_СтатусыСкладовЛифтов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НастройкаСкладаЛифта.Установить(НастройкаСклада);
    НаборЗаписей.Прочитать();
	
	Если НЕ НаборЗаписей.Количество() = 0 Тогда
		Запись = НаборЗаписей[0];
	Иначе
		Запись = НаборЗаписей.Добавить();
	КонецЕсли;
	
	// коды "здоровья" АСХ                       
	// === в работе ===
	// 0 - АСХ находится в состоянии покоя.
	// 1 - Выполняется операция. 
	// === ошибка ===
	// 2 - Есть неполадки, мешающие работе АСХ.
	// (теперь нужен код, т.к. надо отображать все состояния)
	
	// в коллекции картинок:
	// 1 - ничего
	// 2 - красный (ошибка)
	// 3 - желтый (в движении)
	// 4 - зеленый (в покое)
	Если  Результат.Код = -1 Тогда
		НомерСтатуса = 3; // нет связи
	ИначеЕсли  Результат.Код = 0 Тогда
		НомерСтатуса = 4; // в работе
	ИначеЕсли  Результат.Код = 1 Тогда
		НомерСтатуса = 2; // выполняется операция
	ИначеЕсли  Результат.Код = 2 Тогда
		НомерСтатуса = 1; // ошибка
	КонецЕсли;
	
	Если Запись.НомерСтатуса = НомерСтатуса Тогда
		Возврат;
	КонецЕсли;

	Запись.НастройкаСкладаЛифта = НастройкаСклада;
	Запись.НомерСтатуса = НомерСтатуса;
	Запись.Статус = Результат.Статус; // текстовое описание кода    
	Запись.БуквенныйКод = БуквенныйКод;
	
	НаборЗаписей.Записать(); 
	
КонецПроцедуры

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция ЭтоСкладЛифт(Склад, Активность = Истина) Экспорт 

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дкл_НастройкиСкладовЛифтов.Ссылка КАК НастройкаСклада
		|ИЗ
		|	Справочник.дкл_НастройкиСкладовЛифтов КАК дкл_НастройкиСкладовЛифтов
		|ГДЕ
		|	дкл_НастройкиСкладовЛифтов.Активность = &Активность
		|	И дкл_НастройкиСкладовЛифтов.Склад = &Склад
		|	И НЕ дкл_НастройкиСкладовЛифтов.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Активность", Активность);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	УстановитьПривилегированныйРежим(Истина); 
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
//@skip-check bsl-variable-name-invalid
Функция НайтиНастройкуСкладаПоИдентификатору(machineId, Активность = Истина) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);

	Результат = Новый Структура("НастройкаСклада, Склад, Адрес");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	дкл_НастройкиСкладовЛифтов.Ссылка КАК НастройкаСклада,
		|	дкл_НастройкиСкладовЛифтов.Адрес КАК Адрес,
		|	дкл_НастройкиСкладовЛифтов.Склад КАК Склад,
		|	дкл_НастройкиСкладовЛифтов.АвтодобавлениеНоменклатуры КАК АвтодобавлениеНоменклатуры
		|ИЗ
		|	Справочник.дкл_НастройкиСкладовЛифтов КАК дкл_НастройкиСкладовЛифтов
		|ГДЕ
		|	дкл_НастройкиСкладовЛифтов.Активность = &Активность
		|	И дкл_НастройкиСкладовЛифтов.machineId = &machineId
		|	И НЕ дкл_НастройкиСкладовЛифтов.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Активность", Активность);
	Запрос.УстановитьПараметр("machineId" , machineId);
	Запрос.УстановитьПараметр("СтрокаСоединения", СтрокаСоединенияИнформационнойБазы());
	
	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();

	ЗаполнитьЗначенияСвойств(Результат, ВыборкаДетальныеЗаписи);
	
	УстановитьПривилегированныйРежим(Ложь);
			
	Возврат Результат;
	
КонецФункции

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция ДанныеНастройкиСклада(НастройкаСклада, Активность = Истина) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);

	Результат = Новый Структура("НастройкаСклада, Склад, Адрес");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дкл_НастройкиСкладовЛифтов.Ссылка КАК НастройкаСклада,
		|	дкл_НастройкиСкладовЛифтов.Адрес КАК Адрес,
		|	дкл_НастройкиСкладовЛифтов.Склад КАК Склад
		|ИЗ
		|	Справочник.дкл_НастройкиСкладовЛифтов КАК дкл_НастройкиСкладовЛифтов
		|ГДЕ
		|	дкл_НастройкиСкладовЛифтов.Активность = &Активность
		|	И дкл_НастройкиСкладовЛифтов.Ссылка = &НастройкаСклада
		|	И НЕ дкл_НастройкиСкладовЛифтов.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Активность", Активность);
	Запрос.УстановитьПараметр("НастройкаСклада", НастройкаСклада);
	Запрос.УстановитьПараметр("СтрокаСоединения", СтрокаСоединенияИнформационнойБазы());
	
	УстановитьПривилегированныйРежим(Истина); 
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	ЗаполнитьЗначенияСвойств(Результат, ВыборкаДетальныеЗаписи);
	
	УстановитьПривилегированныйРежим(Ложь);

	Возврат Результат;
	
КонецФункции

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-parameter-section
Процедура ДобавитьНоменклатуруВНастройкуСклада(Товары, ДанныеНастройкиСклада) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);

	 Если НЕ ЗначениеЗаполнено(ДанныеНастройкиСклада.НастройкаСклада) Тогда 
		 Возврат;
	 КонецЕсли;
	 
	 Если Ложь Тогда 
		 Товары = Новый ТаблицаЗначений;
	 КонецЕсли;

	 Если Товары.Количество() = 0 Тогда 
		 Возврат;
	 КонецЕсли;
	 
	 Если Товары.Колонки.Найти("Характеристика") = Неопределено Тогда 
		 Товары.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	 КонецЕсли;
	 
	 Если Товары.Колонки.Найти("Упаковка") = Неопределено Тогда 
		 Товары.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	 КонецЕсли;

	 Запрос = Новый Запрос; 
	 Запрос.УстановитьПараметр("Товары", Товары);
	 Запрос.УстановитьПараметр("НастройкаСклада", ДанныеНастройкиСклада.НастройкаСклада);
	 Запрос.УстановитьПараметр("Склад", ДанныеНастройкиСклада.Склад);
	 Запрос.Текст = 
	 "ВЫБРАТЬ
	 |	Товары.Номенклатура КАК Номенклатура,
	 |	Товары.Характеристика КАК Характеристика,
	 |	Товары.Упаковка КАК Упаковка
	 |ПОМЕСТИТЬ врТовары
	 |ИЗ
	 |	&Товары КАК Товары
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	&НастройкаСклада КАК НастройкаСклада,
	 |	Товары.Номенклатура КАК Номенклатура,
	 |	Товары.Характеристика КАК Характеристика,
	 |	Товары.Упаковка КАК Упаковка
	 |ИЗ
	 |	врТовары КАК Товары
	 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дкл_НоменклатураСкладов КАК дкл_НоменклатураСкладов
	 |		ПО Товары.Номенклатура = дкл_НоменклатураСкладов.Номенклатура
	 |			И Товары.Характеристика = дкл_НоменклатураСкладов.Характеристика
	 |			И (дкл_НоменклатураСкладов.НастройкаСклада = &НастройкаСклада)
	 |			И (дкл_НоменклатураСкладов.Активна)
	 |ГДЕ
	 |	дкл_НоменклатураСкладов.Номенклатура ЕСТЬ NULL";
	 
	 УстановитьПривилегированныйРежим(Истина);
	 
	 РезультатЗапроса = Запрос.Выполнить();
	 
	 УстановитьПривилегированныйРежим(Ложь);
	 
	 Если РезультатЗапроса.Пустой() Тогда 
		 УстановитьПривилегированныйРежим(Ложь);
		 Возврат;
	 КонецЕсли;
	 
	 Выборка = РезультатЗапроса.Выбрать();
	 
	 УстановитьПривилегированныйРежим(Истина);
	 
	 Пока Выборка.Следующий() Цикл
		 
		МенеджерЗаписи = РегистрыСведений.дкл_НоменклатураСкладов.СоздатьМенеджерЗаписи();
		//@skip-check query-in-loop
		РеквизитыSKU = ПолучитьРеквизитыSKU(Выборка.Номенклатура, Выборка.Характеристика, Выборка.Упаковка);
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, РеквизитыSKU); 
		МенеджерЗаписи.Активна = Истина;
		МенеджерЗаписи.Статус = Перечисления.дкл_Статусы.Изменено;
		МенеджерЗаписи.Записать();
		 
	 КонецЦикла;
	 
	 УстановитьПривилегированныйРежим(Ложь);
	 
 КонецПроцедуры

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция СостояниеСкладаЛифта(НастройкаСклада) Экспорт         
	 
	Результат = дкл_ОбменДаннымиСервер.ПолучитьСостояниеСкладаЛифта(НастройкаСклада); 
	
	ТабДок = Новый ТабличныйДокумент;	
	
	Макет  = ПолучитьМакет("Макет");
	
	ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал    			= Макет.ПолучитьОбласть("Подвал");
	ОбластьДетальныхЗаписей 	= Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Уровень = 0;
	
	Для Каждого Элемент из Результат Цикл           
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			ВывестиЭлементСтруктуру(ТабДок, Элемент.Значение, Макет, (Уровень + 1) );
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Массив") Тогда                     
			ВывестиЭлементМассив(ТабДок, Элемент.Значение, Макет, Уровень);           
		Иначе
			ОбластьДетальныхЗаписей.Параметры.Заполнить(Элемент); 
			ТабДок.Вывести(ОбластьДетальныхЗаписей);
		КонецЕсли;	
	КонецЦикла; 	

	ТабДок.Вывести(ОбластьПодвал);          
	
	Возврат ТабДок;
	
КонецФункции                         

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция СпикокПолок(НастройкаСклада) Экспорт 
	
	Результат = дкл_ОбменДаннымиСервер.ПолучитьСписокПолокСкладаЛифта(НастройкаСклада); 
	
	ТабДок = Новый ТабличныйДокумент;	
	
	Макет  = ПолучитьМакет("СписокПолок");
	
	ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал    			= Макет.ПолучитьОбласть("Подвал");
	ОбластьДетальныхЗаписей 	= Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Для Каждого Элемент из Результат.tray Цикл           
		ОбластьДетальныхЗаписей.Параметры.Заполнить(Элемент); 
		ТабДок.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла; 	

	ТабДок.Вывести(ОбластьПодвал);          
	
	Возврат ТабДок;
	
КонецФункции                         

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция СравнитьОстатки(НастройкаСклада) Экспорт 
	
	Результат = дкл_ОбменДаннымиСервер.ПолучитьОстатки(НастройкаСклада); 
	
	Таб = ПолучитьРезультатСравненияОстатков(Результат);
	
	ТабДок = Новый ТабличныйДокумент;	
	
	Макет  = ПолучитьМакет("СравнениеОстатков");
	
	ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал    			= Макет.ПолучитьОбласть("Подвал");
	ОбластьДетальныхЗаписей 	= Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Для Каждого Стр из Таб Цикл           
		ОбластьДетальныхЗаписей.Параметры.Заполнить(Стр); 
		ТабДок.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла; 	

	ТабДок.Вывести(ОбластьПодвал);          
	
	Возврат ТабДок;
	
КонецФункции                         

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция СравнитьНоменклатуру(НастройкаСклада) Экспорт 
	
	Результат = дкл_ОбменДаннымиСервер.ПолучитьСписокНоменклатуры(НастройкаСклада); 
	
	Таб = ПолучитьРезультатСравненияНоменклатуры(Результат);
	
	ТабДок = Новый ТабличныйДокумент;	
	
	Макет  = ПолучитьМакет("СравнениеНоменклатуры");
	
	ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал    			= Макет.ПолучитьОбласть("Подвал");
	ОбластьДетальныхЗаписей 	= Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Для Каждого Стр из Таб Цикл           
		ОбластьДетальныхЗаписей.Параметры.Заполнить(Стр); 
		ТабДок.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла; 	

	ТабДок.Вывести(ОбластьПодвал);          
	
	Возврат ТабДок;
	
КонецФункции                     

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция СравнитьПользователей(НастройкаСклада) Экспорт 
	
	Результат = дкл_ОбменДаннымиСервер.ПолучитьСписокПользователей(НастройкаСклада); 
	
	Таб = ПолучитьРезультатСравненияПользователей(Результат);
	
	ТабДок = Новый ТабличныйДокумент;	
	
	Макет  = ПолучитьМакет("СравнениеПользователей");
	
	ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал    			= Макет.ПолучитьОбласть("Подвал");
	ОбластьДетальныхЗаписей 	= Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Для Каждого Стр из Таб Цикл           
		ОбластьДетальныхЗаписей.Параметры.Заполнить(Стр); 
		ТабДок.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла; 	

	ТабДок.Вывести(ОбластьПодвал);          
	
	Возврат ТабДок;
	
КонецФункции                     

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция СписокОшибокЛифта(НастройкаСклада) Экспорт
	
	Результат = дкл_ОбменДаннымиСервер.ПолучитьСписокОшибокЛифта(НастройкаСклада); 
	
	ТабДок = Новый ТабличныйДокумент;	
	
	Макет  = ПолучитьМакет("СписокОшибокЛифта");
	
	ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал    			= Макет.ПолучитьОбласть("Подвал");
	ОбластьДетальныхЗаписей 	= Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	
	Для Каждого Стр из Результат.ErrorLogRecord Цикл           
		ОбластьДетальныхЗаписей.Параметры.Заполнить(Стр); 
		ТабДок.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла; 	

	ТабДок.Вывести(ОбластьПодвал);          
	
	Возврат ТабДок;
	
КонецФункции      

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//@skip-check export-procedure-missing-comment
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция ПолучитьРезультатСравненияОстатков(Результат)
	
	ОписаниеТипа = Новый ОписаниеТипов("Число");	
	
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("Номенклатура"       , Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Таб.Колонки.Добавить("Количество" 	     , Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Любой)));
	Таб.Колонки.Добавить("КоличествоВЛифте"   , Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Любой)));
	Таб.Колонки.Добавить("ID"  				 , Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Любой)));
	
	Для каждого Стр Из Результат.itemBalance Цикл
		Нов = Таб.Добавить();
		Нов.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Стр.itemId));		
		Нов.ID = Стр.itemId;		                                                                                
		Нов.КоличествоВЛифте = ОписаниеТипа.ПривестиЗначение(Стр.availableQuantity);
	КонецЦикла;

	Возврат Таб;
	
КонецФункции

Процедура ВывестиЭлементСтруктуру(ТабДок,СтруктураЭлементов, Макет, Знач Уровень)           
	
	Область = Макет.ПолучитьОбласть("Детали" + Уровень); 
	
	Для Каждого Элемент из СтруктураЭлементов Цикл           
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			ВывестиЭлементСтруктуру(ТабДок, Элемент.Значение, Макет, (Уровень + 1));
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Массив") Тогда
			ВывестиЭлементМассив(ТабДок, Элемент.Значение, Макет, Уровень);
		Иначе
			Область.Параметры.Заполнить(Элемент); 
			ТабДок.Вывести(Область);
		КонецЕсли;	
	КонецЦикла; 	
	
КонецПроцедуры

Процедура ВывестиЭлементМассив(ТабДок, МассивЭлементов, Макет, Знач Уровень)           
	
	Область = Макет.ПолучитьОбласть("Детали" + Уровень); 
	
	Для Каждого Элемент из МассивЭлементов Цикл           
		Если ТипЗнч(Элемент) = Тип("Структура") Тогда
			ВывестиЭлементСтруктуру(ТабДок, Элемент, Макет, (Уровень + 1));
		ИначеЕсли ТипЗнч(Элемент) = Тип("Массив") Тогда
			ВывестиЭлементМассив(ТабДок, Элемент, Макет, Уровень);
		Иначе
			Область.Параметры.Значение = Элемент; 
			ТабДок.Вывести(Область);
		КонецЕсли;	
	КонецЦикла; 	
	
КонецПроцедуры

Функция ПолучитьРезультатСравненияНоменклатуры(Результат)
	
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("Номенклатура"       ,  Новый ОписаниеТипов("СправочникСсылка.Номенклатура, Строка", ,
												Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	
	Для каждого Стр Из Результат.item Цикл
		Нов = Таб.Добавить();                                                                     
		Попытка
			Нов.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Стр.itemId));		
		Исключение   
			Нов.Номенклатура = Стр.itemId;		
		КонецПопытки;
	КонецЦикла;

	Возврат Таб;
	
КонецФункции

Функция ПолучитьРезультатСравненияПользователей(Результат)
	
	Таб = Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("Пользователь"       ,  Новый ОписаниеТипов("СправочникСсылка.Пользователи, Строка", ,
												Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	
	Для каждого Стр Из Результат.user Цикл
		Нов = Таб.Добавить();                                                                     
		Попытка
			Нов.Пользователь = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(Стр.userId));		
		Исключение   
			Нов.Пользователь = Стр.userId;		
		КонецПопытки;
	КонецЦикла;

	Возврат Таб;
	
КонецФункции      

#КонецОбласти

#КонецЕсли