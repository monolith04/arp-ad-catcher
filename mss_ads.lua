mss_ads_sv = "0.1.2"

local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')
local mssf_ok, mssf = pcall(import, 'lib\\imgui_functions.lua')


local skin_names = {'биркой', 'пошив', 'скин'}
action = {}
act_text = {}
action["sell"] = "Продам "
action["buy"] = "Куплю "
action["change"] = "Обменяю..."
action[""] = "..."
act_text["sell"] = "Цена: "
act_text["buy"] = "Бюджет: "
action["n"] = 'nil'

ammunations_strings = {}
ammunations_strings[1] = "В магазине оружия ш. San-Fierro лучшие цены! | GPS: 11-6"
ammunations_strings[2] = "Стволы по самым низким ценам в штате! Оружейный San-Fierro! GPS:11-6"

sf_bank_strings = {}
sf_bank_strings[1] = "Переводи деньги с умом! Комиссия 0.7# в банке ш. SF. GPS 6-2"
sf_bank_strings[2] = "Комиссия на перевод 0.7# в банке ш. SF. Вход: 0$. | GPS 6-2"
sf_bank_strings[3] = "Самый минимальный процент на перевод в Банке ш. SF 0.6# | GPS 6-2"

binco_groove = {}
binco_groove[1] = "Устал от тряпок? Брендовая одежда в «Binco Grove». GPS 8-6"
binco_groove[2] = "Одежда премиального качества в «Binco Grove» | GPS 8-6."

gym_sf = {}
gym_sf[1] = "Прокачай свою силу в спортзале San Fierro | GPS 8-108"
gym_sf[2] = "Изучи стиль боя в нашем Спортзале! Ждем именно тебя | GPS 8 > 108"

--ВЫБОРЫ
av = {}
av[1] = "\"Против всех\" – значит за себя. Выборы 15 ноября. Anti Vote!"
av[2] = "Против выборов без конкуренции. За \"Против всех\", Anti Vote!"
av[3] = "Все кандидаты – подставные, 15 ноября за \"Против всех\". Anti Vote"
av[4] = "Кандидаты – друзья. 15 ноября за \"Против всех\". Anti Vote!"


function home_string(str, t_type, h_type, h_class, h_location)
    --print(str.." | "..t_type, h_type, h_class, h_location)
  return action[t_type]..h_type..h_class..h_location..". "..get_price(str, t_type)
end

function get_house_type(str)
  if str:find("мал[ыо]й") then
    home_type = "малый дом"
  elseif str:find("хат") or str:find("[Дд][Оо][Мм]") or str:find("Дом") or str:find("жилье") then
    home_type = "дом"
  elseif str:find("[Вв]рем") or str:find("трел") or str:find("трейл") or str:find("временяку")  then
    home_type = "временное жильё"
  elseif str:find("[Кк]варт") or str:find("[Кк]вар") or str:find("%sкв%s") then
    home_type = "квартиру"
  elseif str:find("[Вв]иллу") then
    home_type = "квартиру"
  elseif str:find("сарай") then
    home_type = "сарай"
  else
    home_type = "дом"
  end
  return home_type
end

function get_house_class(str)
  if str:find("[Сс]ред") then
    house_class = " среднего класса"
  elseif str:find("[Ээ]ко") then
    house_class = " эконом класса"
  elseif str:find("[Вв]ыс") then
    house_class = " высокого класса"
  elseif str:find("[Ээ]лит") then
    house_class = " элитного класса"
  else
    house_class = ""
  end
  return house_class
end

function get_location(str)
  if str:find("пасном") or str:find("гетто") or str:find("пасны[мй]") or str:find("оп р") then
    obj_location = " в опасном районе"
  elseif str:find("тамож") then
    obj_location = " на таможе в ш. Las Venturas"
  elseif str:find("баран") or str:find("arran") or str:find("барак") or str:find("aran") then
    obj_location = " в д. Las Barrancas"
  elseif str:find("санта") or str:find("(.*)anta") or str:find("(.*)aria") or str:find("(.)ария") then
    obj_location = " в р. Santa Maria"
  elseif str:find("лс") or str:find("ЛС") or str:find("лос") or str:find("Лос") or str:find("%s[Ll][Ss]") or str:find("LS%s?^[|]") or str:find("Los") or str:find("los") then
    if str:find("[Жж][Дд][Лл][Сс]") then
      obj_location = " в ш. Los Santos за ЖД"
    else
      obj_location = " в ш. Los Santos"
    end
  elseif str:find("[Лл][Вв]") or str:find("%sлас") or str:find("Лас") or str:find("lv") or str:find("LV%s^[|]") or str:find("enturas") or str:find("ентура") then
    if str:find("больн") then
      obj_location = " у больницы в ш. Las Venturas"
    else
      obj_location = " в ш. Las Venturas"
    end
  elseif str:find("сф") or str:find("СФ") or str:find("сан") or str:find("Сан") or str:find("ФИЕРРО") or str:find("sf") or str:find("SF%s^[|]") or str:find("San") or str:find("san") then
    if str:find("за больн") then
      obj_location = " в ш. San Fierro за больницей"
    else
      obj_location = " в ш. San Fierro"
    end
  elseif str:find("вмф") or str:find("ВМФ") then
    obj_location = " в д. Bayside"
  elseif str:find("над [Вв][Вв][Сс]") then
    obj_location = " в д. Las Payasadas"
  elseif str:find("вв") or str:find("ВВ") or str:find("ww") or str:find("(.+)ine(.+)ood") or str:find("(.+)а[ий]н(%s?)(.+)уд") then
    obj_location = " на г. VineWood"
  elseif str:find("тгомери") or str:find("монгомери") then
    obj_location = " в д. Montgomery"
  elseif str:find("[Rr]ed") and str:find("[Cc]ounty") then
    obj_location = " в р. Red County"
  elseif str:find("prickle") or str:find("рикл") or str:find("prikle") or str:find("[Лл][Кк][Нн]") then
    obj_location = " в р. Prickle Pine"  
  elseif str:find("[Вв][Мм][Фф]") or str:find("ayside") or str:find("[еэ]йсайд") then
    obj_location = " в р. Bayside"  
  elseif str:find("[Qq]ueb") or str:find("[Кк][аув]?[еа]?брадос") or str:find("[Кк][аув]?[еа]?бардос") then
    obj_location = " в д. El Quebrados"  
  elseif str:find("[Tt]emple") or str:find("[Тт]емпл") then
    obj_location = " в р. Temple" 
  elseif str:find("(.-)нжел") or str:find("[Ээ]нджел") or str:find("[Аа]нгел [Пп]ейн") or str:find("(.+)ngel%p?(.+)ine") then
    obj_location = " в д. Angel Pine"
  elseif str:find("[Пп][Кк]") or str:find("[Пп]аломино") or str:find("(.+)alomino%p?%s?(.+)reek") then
    obj_location = " в д. Palomino Creek"
  elseif str:find("[Фф][Кк]") or str:find("[Фф]орт") or str:find("[Кк]арсон") or str:find("(.+)ort%p?%s?(.+)arson") then
    obj_location = " в д. Fort Carson"
  elseif str:find("[Бб]лу") or str:find("[Bb]lue[Bb]erry") then
    obj_location = " в д. Blueberry"
  else
    obj_location = ""
  end
  return obj_location
end

function house_number(str)
  if str:find("%d+") then
    h_number = str:match("%s%p?(%d+)%s?")
    if h_number then
      return "№"..h_number
  else 
    return ""
    end
  end
end

function ad_handler(str)
  debug(str, 2)
  if str:find("[Сс]редняк") or str:find("[Ээ]литку") then
    return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_location(str))
  elseif not str:find("pacey") and str:find("[Дд][Оо][Мм]") or str:find("жильё") or str:find("[Вв]иллу") or str:find("сарай") or str:find("%sкв%s") or str:find("времянку") or str:find("временяку") or str:find("[Вв]ремен") or str:find("[Кк]вар") or str:find("хат") or str:find("трел") or str:find("трейл") or str:find("жилье") then
    if str:find("[Аа]ук") then
      return "На аукцион выставлен дом "..house_number(str)..get_location(str)..". Успей купить!"
    else
      return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_location(str))
    end
  elseif str:find("участок") or str:find("огород") then
    tt = trade_type(str)
    return action[tt].."земельный участок"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("иппи") then
    if str:find("лучшие для жизни") then
      return "Самые лучшие для жизни товары в магазине «Нижний Хиппи» GPS 8-127"
    elseif str:find("счастл") then
      return "Хочешь стать счастливым? Тогда тебе в «Нижний Хиппи» | GPS 8-127"
    end
    return "Продам бизнес \"Нижний Хиппи\""..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("nrg") or str:find("[Нн][Рр][Гг]") or str:find("NRG") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "мотоцикл", "NRG-500")
  elseif str:find("[Ff][Cc][Rr]") or str:find("[Фф][СсКк][Рр]") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "мотоцикл", "FCR-900")
  elseif str:find("GT") or str:find("гт") or str:find("супер гт") or str:find("Super GT") or str:find("super gt") then
    return vechicles(str, trade_type(str), "автомобиль", "Super GT")
  elseif str:find("султан") or str:find("sultan") or str:find("Султан") or str:find("Sultan") then 
    return vechicles(str, trade_type(str), "автомобиль", "Sultan")
  elseif str:find("[Bb][Ff]") or str:find("[Ii]njection") or str:find("[Бб][Фф]") then 
    return vechicles(str, trade_type(str), "автомобиль", "BF Injection")
  elseif str:find("мавер") or str:find("маврик") or str:find("averick") or str:find("мавик") or str:find("mavik")or str:find("аверик") or str:find("averiс") then 
    return vechicles(str, trade_type(str), "вертолёт", "Maverick")
  elseif str:find("zrx") or str:find("zrx 350") or str:find("zrx-350") or str:find("ZRX") or str:find("[Zz][Rr]") or str:find("ZRX-350") or str:find("ZRX 350") then 
    return vechicles(str, trade_type(str), "автомобиль", "ZRX-350")
  elseif str:find("ullet") or str:find("[Бб]улку") or str:find("[Бб]улет") or str:find("[Бб]уллет") then
    return vechicles(str, trade_type(str), "автомобиль", "Bullet")  
  elseif str:find("[Pp]remier") or str:find("[Пп]ремьер") then
    return vechicles(str, trade_type(str), "автомобиль", "Premier")  
  elseif str:find("(.*)an%s?(.*)ing") or str:find("(.*)[аэ]нд%s?(.*)инг") or str:find("(.*)[аэ]н(.*)инг") or str:find("СК") or str:find("(%s)ск(%s)") then
    return vechicles(str, trade_type(str), "автомобиль", "SandKing")
  elseif str:find("tretch") or str:find("сретч") or str:find("стретч") or str:find("tratch") or str:find("имузин") then
    return vechicles(str, trade_type(str), "автомобиль", "Stretch")
  elseif str:find("легию") or str:find("легия") or str:find("elegy") or str:find("legy") or str:find("enegy") then
    return vechicles(str, trade_type(str), "автомобиль", "Elegy")
  elseif str:find("риот") or str:find("riot") or str:find("роит") then
    return vechicles(str, trade_type(str), "автомобиль", "Patriot")
  elseif str:find("хантли") or str:find("Huntley") or str:find("антли") or str:find("untly") then
    return vechicles(str, trade_type(str), "автомобиль", "Huntley")
  elseif str:find("[Тт]урик") or str:find("[Тт]уризмо") or str:find("[Tt]urismo") then
    return vechicles(str, trade_type(str), "автомобиль", "Turismo")
  elseif str:find("[Bb]ansh") or str:find("[Бб]анш") then
    return vechicles(str, trade_type(str), "автомобиль", "Banshee")
  elseif str:find("[Кк]омет") or str:find("[Cc]omet") then
    return vechicles(str, trade_type(str), "автомобиль", "Comet")
  elseif str:find("[Bb]andit") or str:find("[Бб]андито") then
    return vechicles(str, trade_type(str), "автомобиль", "Bandito")
  elseif str:find("шамал") or str:find("hamal") or str:find("шаман") or str:find("shaman") then
    return vechicles(str, trade_type(str), "самолёт", "Shamal")
  elseif str:find("[Dd]odo") or str:find("[Дд]одо") then
    return vechicles(str, trade_type(str), "самолёт", "Dodo")
  elseif str:find("tun(.*)plane") or str:find("tunplane") then
    return vechicles(str, trade_type(str), "самолёт", "Stuntplane")
  elseif str:find("сперроу") or str:find("спароу") or str:find("arrow") or str:find("сперов") or str:find("спаров") then
    return vechicles(str, trade_type(str), "вертолёт", "Sparrow")
  elseif str:find("arquis") or str:find("маркиз") or str:find("маркис") then
    return vechicles(str, trade_type(str), "яхту", "Marquis")
  elseif str:find("heetah") or str:find("читах") or str:find("итах") or str:find("читу") then
    return vechicles(str, trade_type(str), "автомобиль", "Cheetah")
  elseif str:find("nfernus") or str:find("нфернус") or str:find("инф[ау]") or str:find("infu") or str:find("инфер") or str:find("инфенус") then
    return vechicles(str, trade_type(str), "автомобиль", "Infernus")
  elseif str:find("отринг б") or str:find("otring b") or str:find("otring B") or str:find("хотринг Б") or str:find("acer b") or str:find("acer B") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotring Racer B")
  elseif str:find("отринг а") or str:find("otring a") or str:find("otring A") or str:find("[Хх]отринг А") or str:find("acer a") or str:find("acer A") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotring Racer A")
  elseif str:find("отринг") or str:find("otring") or str:find("хотринг") or str:find("acer") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotring Racer")
  elseif str:find("Устроюсь") or str:find("транспортную") or str:find("%sТК%s?") or str:find("%sтк%s") and not str:find("сутки") then
    return "Ищу работу в транспортной компании. Жду звонков."
  elseif str:find("слет новых") then    -- реклама --
    return "Ежедневно слет новых сим-карт. Успейте подобрать себе | GPS 8-280"
  elseif str:find("илборд") and str:find("LV") then
    return "Билборды на любой вкус в рекламном агентстве ш. LV | GPS 8-234"
  elseif str:find("[Pp]rice%s7%s?%p%s?10") then
    if str:find("Любишь сладкое?") then
      return "Любишь сладкое? Тебе понравится наша кондитерская! Price 7-10"
    end
  elseif str:find("наруж") and str:find("LV") then
    return "Услуги наружной рекламы в «Рекламном агентстве» ш. LV | GPS 8-234"
  elseif str:find("Низкокалорийные") then 
    return "Низкокалорийные десерты в «Магазине Сладостей LS» | Price 7 -> 3"
  elseif str:find("[Оо]тель") and str:find("Океан") then
    if str:find("экономный") then
      return "Самый экономный отель №1 в ш.Los-Santos «Океан» | GPS 8-54"
    elseif str:find("бандитов") then
      return "Отель «Океан» ждет своих бандитов! 1,000$/сутки | GPS 8-54"
    end
  elseif str:find("етрах") then
    return "Приобрети новогодние ёлки в «Сад. центрах LS/LV» | GPS 8-271/272"
  elseif str:find("[Сс]ад") and str:find("[LlЛл][SsСс]") and str:find("[LlЛл][VvВв]") then
    if str:find("риобрети") then
      return "Приобрети новогодние ёлки в «Сад. центрах LS & LV». GPS 8-271/272"
    elseif str:find("овогод") then
      return "Купи новогоднюю ёлку в «Садовых центрах LS & LV». GPS 8-271/272"
    end
    return "Безоплатный вход в «Садовых центрах LS & LV». GPS 8-271/272"
  elseif str:find("[Aa]ttica") then
    return "Заходи в \"Attica Bar\". У нас вкусная закуска! Мы по GPS 8-65!"
  elseif str:find("[Dd][Ss]") and str:find("[Тт][Цц][Лл][Сс]") then
    if str:find("лакшери") then
      return "Большие скидки на лакшери одежду в «DS» ТЦЛС. GPS 8-39"
    end
  elseif str:find("GPS 8 > 10 АКЦИЯ") then
    return "В магазине «Spacey» акция! 10-й клиент получит 100.000$. GPS 8>10"
  elseif str:find("[Ss]pacey") then
    if str:find("машинки") then --str:find("[Bb][Mm][Ww]") then
      return "В магазин игрушек «Spacey» завезли новые машинки | Мы в GPS 8-10"
    elseif str:find("игрушки для своего дома") then
      return "Купи игрушки для своего дома в магазине игрушек «Spacey» GPS 8>10"
    elseif str:find("BMW") then
      return "В магазин игрушек «Spacey» завезли мини «BMW M5» | Мы в GPS 8-10"
    elseif str:find("игрушки") then
      return "В магазин игрушек «Spacey» завезли новые игрушки | Мы в GPS 8-10"
    elseif str:find("получает") then
      return "В магазине «Spacey» акция! 10-й клиент получит 100.000$. GPS 8>10"
    elseif str:find("родам") then
      return "Продам магазин игрушек «Spacey» GPS 8 > 10. "..get_price(str, trade_type(str))
    end
  elseif str:find("[Нн]омерные [Зз]наки") and str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4") then
    return "Самые низкие цены на номерные знаки только у нас! Price: 11 > 4."
  elseif str:find("[Тт]юнинг") and str:find("[Жж][Дд][Сс][Фф]") then
    if str:find("иски") then
      return "Диски, спойлера, обвесы в «Тюнинг-центре» у ЖДСФ. GPS 8 - 113"
    end
    return "Бесплатный вход в тюнинг-центре ЖДСФ | GPS: 8-113"
  elseif str:find("nvestical") and str:find("roup") then
    return "Компания «Investical Group» ищет новых сотрудников | GPS 4 > 7"
  elseif str:find("агаз") and str:find("груш") then
    if str:find("[Бб][Лл][Сс]") then
      return "Хочешь танк? Купи его в «Магазине игрушек» за БЛС | GPS 8 -> 10"
    end
  elseif str:find("[Vv]isage") then
    return "В Отеле «Visage» доступны VIP номера. Цена: 500$/д. GPS: 8-232."
  elseif str:find("lexande") and str:find("[Tt]oys") then
    if str:find("адиоуправляемый вертолет") then
      return "Купи радиоуправляемый вертолет в «Alexander's Toys» | Price 8 > 3"
    elseif str:find("BMW") then
      return "Магазин «Alexander's Toys» закупил мини «BMW M5» | Price 8 > 3"
    elseif str:find("Скучно?") then
      return "Тебе скучно? Мини-машинки в «Аlexanders Toys» | Price 8 >3"
    else
      return "Магазин «Alexander's Toys» пополнил ассортимент. Мы в Price 8 > 3"
    end
  elseif str:find("Binco Grove") or str:find("8%s?%p?%s?6") and str:find("[Gg][Pp][Ss]") then
    return binco_groove[math.random(1, 2)]
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?247") then
    if str:find("сохраним транспорт") then
      return "Cохраним ваш транспорт на время переезда всего за 699$ | GPS 8-247."
    end
  elseif str:find("бинко") and str:find("ольниц") and str:find("лв") then
    return "В магазине одежды «Binco» возле больницы LV самые низкие цены!"
  elseif str:find("[Bb]inco") and str:find("[Тт][Цц][Лл][Вв]") and str:find("[Pp]rice") then
    return "Лучшие бренды по самой низкой цене в \"Binco\" ТЦЛВ | Price 5-14!"
  elseif str:find("[Сс]амые низкие цены") and str:find("[Dd]illimore") and str:find("[Gg][Pp][Ss]") then
    return "Самые низкие цены в магазине д. Dillimore | GPS 8 -> 228."
  elseif str:find("24/7") or str:find("24-7") or str:find("24 7") then
    if str:find("[Пп]родам") then
      if str:find("Лас[ -]Вентурас") then
        return "Продам бизнес «24/7» в ш. Las Venturas. Цена: договорная"
      end
    end
    if str:find("lvfm") or str:find("LVFM") or str:find("ЛВФМ") then
      if str:find("джекпот") then
        return "Сорви джекпот купив лотерейный билет в «24/7» у LVFM | GPS 8-178"
      elseif str:find("куш") then
        return "Сорви куш с лотерейным билетиком из «24/7» у LVFM | GPS 8-178"
      end
    end
  elseif str:find("[Bb]if") and str:find("[Bb]rid") and str:find("[Gg][Pp][Ss]") then
    return "В отеле \"Biffin Bridge\" номера за 500$/сутки! | GPS 8-158"
  elseif str:find("[Пп]иро") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?73%s?") then -- GPS 8-73
    if str:find("Пальцы на месте") then
      return "Пальцы на месте, не выбитый глаз? Пиротехника ждет Вас | GPS 8-73"
    elseif str:find("А я сейчас") then
      return "А я сейчас вам покажу, где приобрести пиротехнику | GPS 8-73."
    end
    return "Ни разу не покупал пиротехнику? Фатальная ошибка | GPS 8-73"
  elseif str:find("[Бб]анк") and str:find("[Gg][Pp][Ss]") then -- GPS 8-73
    if str:find("[СсSs][FfФф]") or str:find("[Ff]ierro") then
      if str:find("[Сс]амый минимальный") then
        result = sf_bank_strings[3]
      end
    elseif str:find("[Bb]ar") and str:find("[Gg][Pp][Ss]") then
      result = "Минимальная комиссия 0.7# только в банке Las-Barrancas! | GPS 6-5"
    elseif str:find("[Pp]al") and str:find("[Gg][Pp][Ss]") then
      result = "Минимальная комиссия 0.7# в банке Palomino Creek. | Мы в GPS 6-3."
    else
      result = "ERROR"
    end
    return result
    -- ВЫБОРЫ и ПАРТИИ
  elseif str:find("[Aa]nti [Vv]ote") then
    return av[math.random(1,4)]
  elseif str:find("[Нн]аследие") then
    return "Партия \"Наследие\". Двигаемся дальше - 15 ноября. E.Сastellano"
  elseif str:find("[Сс]праведливости [Ии] [Рр]азвития") then
    if str:find("жить") then return "Хочешь жить, не выживать? Партия \"Справедливость и Развитие\"!" end
    return "Голосуй за партию Справедливости и Развития. Кандидат V.Granados"
    --ДРУГОЕ
  elseif not str:find("сим") and not str:find("sim") and not str:find("Сим") and not str:find("SIM") and str:find("карт") or str:find("Cart") or str:find("Kart") or str:find("Карт") or str:find("cart") or str:find("kart") then
    return vechicles(str, trade_type(str), "автомобиль", "Kart")
  elseif str:find("симку") or str:find("[Сс]им") or str:find("[Ss][Iil]m") or str:find("SIM") or str:find("смку") or str:find("одам номер") then -- ДРУГОЕ
    print("{66B8F3}Найдено объявление о покупке/продажи сим-карты!")
    sim_format = str:match("формата (%w+)$")
    result = "fdas"
    if sim_format == nil then
      result = "(AD_SIM_0): {BF4E8D}Я не знаю как определить сим-карту, пиши сам в поле:"
    else
      result = "Продам сим-карту формата\""..sim_format:upper().."\". "..get_price(str, nil)
    -- ДРУГОЕ
    end
    return result
  elseif str:find("азс") or str:find("АЗС") or str:find("[Aa][Zz][Ss]") then
    if str:find("[Цц]ентр") and str:find("[Лл][Вв]") or str:find("[Ll][Vv]") then
      if str:find("[Ff]uel") then
        return "На АЗС №17 \"Центральная ЛВ\" дизель по 25$ за 1л. | Fuel 17"
      end
      fuel_name = "Центральная ЛВ"
    elseif str:find("ontgomery") and str:find("[Ff]uel") then
      return "Самое дешевое топливо на \"АЗС Montgomery\" по 10$ за 1л. Fuel 10"
    else
      fuel_name = ""
    end
    return action[trade_type(str)].."\"АЗС "..fuel_name.."\". "..get_price(str, trade_type(str))
  elseif str:find("пиротехни") then
    return action[trade_type(str)].."магазин пиротехники"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("[Сс]алон [Кк]расоты") then
    return action[trade_type(str)].."салон красоты"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("инко") and str:find("[Тт][Цц][Лл][Вв]") and str:find("одам") then
    return action[trade_type(str)].."магазин одежды \"Binco\" в ТЦЛВ. "..get_price(str, trade_type(str))
  elseif str:find("[Ss]ex") or str:find("секс") and str:find("боль") and str:find("[Лл][Сс]") then
    return action[trade_type(str)].."секс-шоп за больницей ш. Los Santos. "..get_price(str, trade_type(str))
  elseif str:find("[Ss]ex") or str:find("[Сс]екс") and str:find("[ЛлLl][ВвVv]") then
    return action[trade_type(str)].."секс-шоп в ш. Las Venturas. "..get_price(str, trade_type(str))
  elseif str:find("[Рр]азвлекательный [Цц]ентр") then
    return action[trade_type(str)].."бизнес «Развлекательный центр» GPS 8-42. "..get_price(str, trade_type(str))
  elseif str:find("мебел") then
    w_location = location(str, "мебель", "n", "n")
    return w_location
    -- ==аксессуары== --
  elseif str:find("[Кк]ос[уа]") then
    return action[trade_type(str)].."аксессуар «Коса». "..get_price(str, trade_type(str))
  elseif str:find("[Шш]айб") then
    return action[trade_type(str)].."аксессуар «Маска-Шайба». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]вадрокоптер") then
    return action[trade_type(str)].."аксессуар «Квадрокоптер». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]рест") then
    return action[trade_type(str)].."аксессуар «Крест». "..get_price(str, trade_type(str))
  elseif str:find("[ОоАа]гн[еи]мет") or str:find("огнет") then
    return action[trade_type(str)].."аксессуар «Огнемет». "..get_price(str, trade_type(str))
  elseif str:find("[Аа]рмейский") or str:find("[Рр]ю[кд]зак") then
    return action[trade_type(str)].."аксессуар «Армейский рюкзак». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]ил[АаУу]") then
    return action[trade_type(str)].."аксессуар «Пила». "..get_price(str, trade_type(str))
  elseif str:find("[Гг]олов[АаУу]") and str:find("[Пп]ришель") then
    return action[trade_type(str)].."аксессуар «Голова пришельца». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]ас") and str:find("[Мм]апс") then
    return action[trade_type(str)].."аксессуар «Маска марсианина». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]атан") then
    return action[trade_type(str)].."аксессуар «Катана». "..get_price(str, trade_type(str))
  elseif str:find("[Бб]анан") then
    return action[trade_type(str)].."аксессуар «Банан». "..get_price(str, trade_type(str))
  elseif str:find("[Бб]рон") then
    return action[trade_type(str)].."аксессуар «Бронежилет». "..get_price(str, trade_type(str))
  elseif str:find("[Жж]ил[к]?ет") then
    return action[trade_type(str)].."аксессуар «Жилетка». "..get_price(str, trade_type(str))
  elseif str:find("[Сс]иг") then
    return action[trade_type(str)].."аксессуар «Сигарета». "..get_price(str, trade_type(str))
  elseif str:find("[Сс]абл[юя]") then
    return action[trade_type(str)].."аксессуар «Сабля». "..get_price(str, trade_type(str))
  elseif str:find("[Чч]асы") then
    return action[trade_type(str)].."аксессуар «Серебряные часы». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]рош") then
    return action[trade_type(str)].."аксессуар «Маска Кроша». "..get_price(str, trade_type(str))
  -- ==другое==
  elseif str:find("[Ff]amily") or str:find("[Сс]емья") then
    if str:find("[Gg]oldberg") then
      if str:find("дальних") then
        return "Семья Goldberg Family ищет дальних родственников."
      else
        return "Мечтаешь быть крутым и богатым? Семья Goldberg поможет!"
      end
    end
    if str:find("[Bb]lack") then
      return "Хочешь иметь стабильный заработок? Семья Black ждет именно тебя!"
    end
  elseif str:find("двокат") then
    return "От мэрии "..get_location(str):gsub(" в ", "").." работет опытный адвокат. Звоните."
  elseif str:find("ценз[её]р") or str:find("ЦЕНЗ[ЕЁ]Р") then
    return "От мэрии "..get_location(str):gsub(" в ", "").." работет лицензёр. Звоните."
  elseif str:find("врач") then
    if str:find("[LlЛл][VvВв]") or str:find("[LlЛл][AaАа][SsСс]") then
      return "От больницы ш. Las Venturas работает опытный врач. Звоните!"
    elseif str:find("[LlЛл][SsСс]") or str:find("[LlЛл][OoОо][SsСс]") then
      return "От больницы ш. Los Santos работает опытный врач. Звоните!"
    end
  elseif str:find("портзал") or str:find("боев") or str:find("искусс") or str:find("тзал") or str:find("стиль боя") or str:find("спорт") then
    --print("СПОРТ!!!")
    if str:find("родам") or str:find("уплю") then
      return action[trade_type(str)].."спортзал в"..get_location(str)..". "..get_price(str, trade_type(str))
    else
      return location(str, "спортзал", "n", "n")
    end

  elseif str:find("[Пп]родам%s%d+%sцена") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%sи%s%d+") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Кк]уплю%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("одежд") or str:find("скин") or str:find("skin") or str:find("костюм") or str:find("пошив") or str:find("бирк") then
    result = clothes(str, trade_type(str))
    return result
  elseif str:find("девуш") or str:find("дам[оу]") then
    return "Познакомлюсь с девушкой для серьёзных отношений. Позвони мне!"
  elseif str:find("мужчи") or str:find("парня") then
    return "Познакомлюсь с привлекательным мужчиной. О себе: при встрече."
  elseif str:find("ищ[ую]") or str:find("Ищ[ую]") then
    if str:find("_") then str = str:gsub("_", " ") end
    if str:find("человека") or str:find("игрока") then
      if str:find("[(имени)|(ником)] (%w+) (%w+)$") then
        --debug(str.."FOUND2", 1)
        first, last = str:match("[(имени)|(ником)]%s(.+)%s(.+)$")
        print(first, last)
      elseif str:find("[(имени)|(ником)]%s(%w+)%s(%w+)%s?%p?") then
        --debug(str.."FOUND4", 1)
        first, last = str:match("имени%s(.+)%s(.+)%sпоз")
        print(first, last)
      elseif str:find("ека (.+) (.+)%p?") then
        --debug(str.."FOUND3", 1)
        first, last = str:match("ека%s(.+)%s(.+)%p?")
        print(first, last)
      elseif str:find("щу (.+) (.+)") then
        --debug(str.."FOUND1", 1)
        first, last = str:match("щу%s(%w)%s(%w)%p?")
        print(first, last)
      elseif str:find("щу (.+) (.+)") then
        --щу Dmitriy Forost.
        --debug(str.."FOUND14", 1)
        first, last = str:match("щу%s(%w+)%s(%w+)%p")
        print(first, last)
      end
      if last == nil or first == nil then
        return "ERROR"
      end
      return "Ищу человека по имени "..first.." "..last..". Позвони мне!"
    elseif str:find("родствен") then
      return "Ищу дальних родственников. Позвоните мне!"
    else
      if str:find("щу (.+) (.+)") then
        --щу Dmitriy Forost.
        --debug(str.."FOUND14", 1)
        first, last = str:match("щу%s(%w+)%s(%w+)")
        print(first, last)
      end
      if last == nil or first == nil then
        return "ERROR"
      end
      return "Ищу человека по имени "..first.." "..last..". Позвони мне!"
    end
  elseif str:find("[Сс]алон") or str:find("[Сс]вязи") then
    return "Продажа симок до 5.000.000$. Поспешите! Мы в \"Салоне связи\" | GPS 8-280"
  elseif str:find("[Оо]руж") or str:find("ый [Мм]агаз") and str:find("[Gg][Pp][Ss]") or str:find("AMMO") then
    --locate, gps = location(str, "ammo", nil, nil)
    h_string = location(str, "ammo", nil, nil)
    return h_string
  elseif str:find("биз") or str:find("предпри") then
    if str:find("приб") then
      return action[trade_type(str)].."прибыльный бизнес. "..get_price(str, trade_type(str))
    else
      return action[trade_type(str)].."бизнес. "..get_price(str, trade_type(str))
    end
  elseif str:find("(.-)одам") or str:find("(.-)родаю") or str:find("одат") then
    if str:find("одежд[уы]") or str:find("скин") or str:find("skin") or str:find("костюм") or str:find("пошив") then
      return
    end
  else
    return "ERROR"
  end
  return "ERROR"
end

function trade_type(str)
  if str:find("(.-)[Уу]п[а]?лю") or str:find("(.-)УПЛЮ") or str:find("[Кк]улю") or str:find("[Bb]uy") then
    return "buy"
  elseif str:find("(.-)одам") or str:find("(.-)родаю") or str:find("(.*)ро(.*)ам") or str:find("одат") or str:find("рдам") or str:find("(.-)ell") then
    return "sell"
  elseif str:find("бмен") then
    return "change"
  else
    return ""
  end
end

function location(str, type, act, house_type)
  if type == "ammo" then
    --debug("AMMO", 2)
    if str:find("Fier") or str:find("fier") or str:find("(%s?)11(%s?)-(%s?)6(%s?)") then
      return ammunations_strings[math.random(1,2)]
    elseif str:find("ngel") and str:find("ine") then
      if str:find("ие пушки") then
        return "Большие пушки, низкие цены - «AMMO Angel Pine» | GPS 11-3"
      else
        return "Самые низкие цены на оружие в «АММО Angel Pine» | GPS 11 -> 3"
      end
    end

  elseif type == "мебель" then
    if str:find("los") or str:find("лс") or str:find("лос") or str:find("Los") or str:find("Лос") or str:find("LS") or str:find("ЛС") then
      if str:find("удобная") then
        return "Мягкая удобная мебель в 'Мебельном салоне' ш. LS! Price 18-1"
      elseif str:find("лучшая") or str:find("удшая") then
        return "Самая лучшая мебель в \"Мебельном салоне\" ш. LS. Price 18-1"
      elseif str:find("оскошная") then
        return "Роскошная мебель в \"Мебельном салоне\" ш. LS. Price 18-1!"
      elseif str:find("люкс") then
        return "Покупай мебель класса люкс в \"Мебельном салоне\" ш. LS. Price 18-1"
      end
    end
  elseif type == "спортзал" then
    if str:find("[Сс]анта [Мм]ария") then
      return "Изучи новый стиль боя в спортзале в р. Santa Maria | Price 6-4"
    elseif str:find("san") or str:find("сан") or str:find("sf") or str:find("Сан") or str:find("San") or str:find('8 > 108') or str:find("108") then
      if str:find("борств") then
        return "Изучите стиль восточных единоборств в нашем Спортзале! GPS 8>108"
      end
      return gym_sf[math.random(1, 2)]
    else if str:find("8-28") or str:find("-(%s?)28") then
      return "Подкачайся в зале боевых искусств в ш. Los Santos. GPS 8-28"
    elseif str:find("[Вв]зл[её]т") then
      return "Изучите стиль боя в качалке «Взлет» | GPS 8 - 57"
    else if str:find("етто") or str:find("8-7") or str:find("-(%s?)7") then
      return "Тебя обижают? Подкачайся в спортзале опасного района | GPS 8-7"
    elseif str:find("[Pp]rice%s6%s?[>-]%s?3") then
      return "Хочешь драться как Джеки Чан? Изучай стиль боя у нас! | Price 6-3"
    elseif str:find("ort") and str:find("arson") then
      if str:find("с удара") then
        return "Хочешь вырубать всех с удара? Тебе в спортзал в д. Fort Carson!"
      elseif str:find("вход") then
        return "Бесплатный вход только в спорт-зале в д. Fort Carson. Ждем Вас!"
      end
    end
  end
end
end
end

function clothes(str, act)
  --debug(str, 1)
  --3 скина
  --продам скины 272 208 99
  if str:find('%d+%p%s%d+%p%s%d+%p') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)%p", 3)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%s(%d+)$", 3)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%p%d+%p%d+%s') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%s", 3)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    --куплю одежду 240, 294, 295 договор
  elseif str:find('пошива%s%d+%p%d+%p%d+%p?$') then    --куплю одежду пошива 303,304,305
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p?$", 3)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 

  elseif str:find('%s%d+%p?%s%d+%p?%s%d+%p?%s?') then
    --toast.Show(u8'3', toast.TYPE.WARN, 5)
    clothes_ids = get_clothes_id(str, "%s(%d+)%p?%s(%d+)%p?%s(%d+)%p?%s?", 3)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    --куплю скин 109, 115 и 114
  elseif str:find('%s%d+%p?%s%d+%sи%s%d+%s?') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p?%s(%d+)%sи%s(%d+)%s?', 3)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    --пошива%s\"%d+\"%s\"%d+\"%s\"%d+\"%p
  elseif str:find('%s\"%d+\"%s\"%d+\"%s\"%d+\"%p') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)\"%s\"(%d+)\"%s\"(%d+)\"%p", 3)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  --2 скина
  --Куплю костюмы с бирками №286, 287. Бюджет: свободный.
  --Продам одежду под биркой 103 и 303 Цена логоврная.
  --продам одежду пошива 271 цена 3.3
  --Продам одежду пошива 270,271
  --биркой 295, 296
  elseif str:find('скины%s%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "скины%s(%d+)%p(%d+)$", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(пошива)|(биркой)]%s%d+%p%s?%d+%s?') then
    clothes_ids = get_clothes_id(str, "[(пошива)|(биркой)]%s(%d+)%p%s?(%d+)%s?", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[Пп]родам%s%d+%sи%s%d+$') then
    clothes_ids = get_clothes_id(str, "[Пп]родам%s(%d+)%sи%s(%d+)$", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
    --пошива 124 240 
    --у 110, 102 б
  elseif str:find('у%s%d+%p%s%d+%sб') then
    clothes_ids = get_clothes_id(str, "у%s(%d+)%p%s(%d+)%sб", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('пошива%s%d+%s%d+%s') then
    clothes_ids = get_clothes_id(str, "пошива%s(%d+)%s(%d+)%s", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%sили%s%d+%s') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%sили%s(%d+)%s', 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+%p%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%p(%d+)\"", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%s\"(%d+)\"", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s%d+%sскин$') then
    clothes_ids = get_clothes_id(str, "%s(%d+)%s(%d+)%sскин$", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%sи%s%d+$?') then
    clothes_ids = get_clothes_id(str, "(%d+)%sи%s(%d+)", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+%p+%d+%s") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+(%d+)%s", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+%s+%d+%s") then
    clothes_ids = get_clothes_id(str, "(%d+)%s+(%d+)%s", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("^[цена]%s%d+%p+%s?%d+$") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+%s?(%d+)$", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
    --Продам одежду пошива 70,267.
  elseif str:find("%s%d+%p+%s?%d+%p%s?Ц") then
    clothes_ids = get_clothes_id(str, "%s(%d+)%p+%s?(%d+)%p", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("№%d+%p+%s?%d+$?") then
    --debug("ОООО", 2)
    clothes_ids = get_clothes_id(str, "№(%d+)%p+%s?(%d+)$?", 2)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
    --debug(h_string, 2)
  --elseif str:find("%d+ за") or str:find("%d+ цена") then
    --h_string = action[act].."одежду с биркой "..get_price(str)
  --1 скин
  "[Пп]родам%s%d+$"
  elseif str:find("[Пп]родам%s%d+$") then skin_id = str:match("[Пп]родам%s(%d+)$")
  h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
elseif str:find("[Кк]уплю%s%d+$") then skin_id = str:match("[Кк]уплю%s(%d+)$")
  h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("одежд[уы] %d+%s?") then skin_id = str:match("%s(%d+)")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("одежд[уы]%s(%d+)%sпошив") then skin_id = str:match("%s(%d+)%s")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("№%s?%d+") then skin_id = str:match("№%s?(%d+)")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%sбирку") then skin_id = str:match("%s(%d+)%s")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%sскин") then skin_id = str:match("%s(%d+)%s")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("№%s?\"%d+\"") then skin_id = str:match("№%s?\"(%d+)\"")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("№%s?%d+") then skin_id = str:match("№%s?(%d+)")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+(%s|$)") then skin_id = str:match("%s(%d+)(%s|$)")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s[(биркой)|(бирка)|(бирку)|(пошив)|(пошива)|(скин)|(костюм)|(одежду)]+%s%p?%d+%p?%s?") then skin_id = str:match("%s[(биркой)|(бирка)|(бирку)|(пошив)|(пошива)|(скин)|(костюм)|(одежду)]+%s%p?(%d+)%p?%s?")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+%s?[(пошив)|(одежду)]") then skin_id = str:match("%s(%d+)%s?[(пошив)|(одежду)]")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%sскин%s%d+%s") then skin_id = str:match("%sскин%s(%d+)%s")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("[Пп]родам%s%d+%sцена") then skin_id = str:match("[Пп]родам%s(%d+)%sцена")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  else
    h_string = "ERROR"
  end
  --debug(h_string, 2)
  return h_string
end

function get_clothes_id(str, pattern, count)
  --local results = string.match(str, "%d+%s%d+$")
  if count == 2 then
    num1, num2 = str:match(pattern)
    withn = num1:gsub(num1, "№"..num1)..' и '..num2:gsub(num2, "№"..num2)
    return withn
  elseif count == 3 then
    num1, num2, num3 = str:match(pattern)
    withn = num1:gsub(num1, "№"..num1)..', '..num2:gsub(num2, "№"..num2)..' и '..num3:gsub(num3, "№"..num3)
    return withn
  else return "Error..."
  end
end

function vechicles(str, trade, v_type, model)
  if str:find("рынок") or str:find("рынке") or str:find("укци") then
    return "На авторынке выставлен "..v_type.." марки «"..model.."» "..car_tuning(str)
  end
  --print(action[trade], v_type, model, car_tuning(str), get_price(str, trade))
  return action[trade]..v_type.." марки «"..model.."»"..car_tuning(str)..". "..get_price(str, trade)
end

function car_tuning(str)
  if str:find("ft") or str:find("фт") or str:find("FT") or str:find("ФТ") then
    return " [FT]"
  else
    return ""
  end
end
--цена 1.5 млн 
function get_price(str, act)
  --debug(str, 2)
  if str:find("догов") or str:find("Догов") or str:find("дог") or str:find("Дог") or str:find("[Сс]вобо") or str:find("[Сс]овбо") or str:find("огов") then
    return "Цена: договорная."
    --куплю одежду пошива 303,304,305
  elseif str:find("цена") or str:find ("за %d") or str:find("[Кк][Кк]") or str:find("Цена") or str:find("юджет") or str:find("%d[кk]$") or str:find("kk") and not str:find("договорная") then
    if str:find("%d%p%dкк%s") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("кк%s")-1).."00.000$" k = 0
      --12,500kk
    elseif str:find("%d%p%d[(кк)|(kk)]") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("[(кк)|(kk)]$")-2).."00.000$" k = 122
    elseif str:find("%d%p%d[(кк)|(kk)]") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("[(кк)|(kk)]")-1).."00.000$" k = 1
    elseif str:find("%d%p%d%s?млн") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%s?млн")-1).."00.000$" k = 2
    elseif str:find("%d%s?млн") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s?млн")-1)..".000.000$" k = 2
    elseif str:find("%d%sляма") then price = ''..str:sub(str:find("%s%d")+1, str:find("%sл")-1)..".000.000$" k = 23
    elseif str:find("%s%d+%p%d+%$.") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")) k = 18
    elseif str:find("%d%p%d$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")-1).."00.000$" k = 3 --Цена:2.500.000$
    elseif str:find("%s%d+%p%d+kk$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("kk$")-1):gsub(",", ".")..".000$" k = 30 --Цена:2.500.000$
    elseif str:find(".%d00.00%$$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%d%$")).."0$" k = 8 
    elseif str:find("[:]?%s%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find('%d+%p%d+%p%d+'), str:find("%d%$")).."$" k = 4 --Цена: 35.000.000$
    elseif str:find("[:]%s?%d+%p%d%d%d%p%d+%$") then price = ''..str:sub(str:find('%d+%p'), str:find("%d%$")).."$" k = 12
    elseif str:find("%s%d+%p%d+%p%d+%s") then price = ''..str:sub(str:find('%d%p'), str:find("%d%s")).."0$" k = 13 --1.300.00$
    elseif str:find("%s%d+%s%d+%s%d+%s?") then price = ''..str:sub(str:find('%s%d')+1, str:find("%$")-1):gsub(" ", ".").."$" k = 14 --400 000 000$
    elseif str:find("%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('%d+%p'), str:find("%d$")).."$" k = 5 -- 8.000.000
    elseif str:find("%s%d+%s?[Кк][Кк]") then price = ''..str:sub(str:find('%s%d+%s?[Кк]')+1, str:find("%s?[Кк][Кк]")-1)..".000.000$" k = 6
    elseif str:find("а:%d+%s?[Кк][Кк]") then price = ''..str:sub(str:find('а:%d+%s?[Кк]')+2, str:find("%s?[Кк][Кк]")-1)..".000.000$" k = 19
    elseif str:find("%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('%s%d+%p')+1, str:find("$")).."$" k = 16
    elseif str:find("%s%d+%p%d+%p%d+%$%p$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."" k = 15
    elseif str:find(".00.000%$") then price = ''..str:sub(str:find("[:%s?]%d+%p")+1, str:find("%p%d")+4).."00.000$" k = 7 
    elseif str:find("%s%d+[кk]$") then price = ''..str:sub(str:find("%s%d+[кk]")+1, str:find("[кk]$")-1):gsub(" ", "")..".000$" k = 9 --продам симку 888886 цена 300к
    elseif str:find("%s%d%p%d+$") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d+$")+2)..".000$" k = 10 --Куплю дом бюджет 1.100.00 тел 999779
    elseif str:find("%s%d+%p%d00%p00%s?") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d+$")+2).."0$" k = 11
    elseif str:find("%s%d+%p%d+%s?кк$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("кк$")-1)..".000$" k = 9 --продам симку 888886 цена 300к
      --Продам аксессуар "Маска кроша". Цена 611.111$
    elseif str:find("%s%d+%p%d+%$$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%$$")) k=17
      --врик 18.кк
    elseif str:find("%s%d+%pкк") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%pкк")-1)..".000.000$"
    else price="UNKWN" k="a" -- сф за 750к или пре
    end
    debug(str.."-"..k, 1)
    --debug(price, 2)
    return act_text[act]..price
  elseif str:find("%d%p%d$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")-1).."00.000$" return act_text[act]..price
  elseif str:find("%s%d%p%d+%p%d+$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")-1).."$" return act_text[act]..price
  else
    return "Цена: договорная."
  end
end

