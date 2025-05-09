mss_ads_sv = "0.2.9"

local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')
local mssf_ok, mssf = pcall(import, 'lib\\imgui_functions.lua')


local skin_names = {'биркой', 'пошив', 'скин'}
action = {}
act_text = {}
action["sell"] = "Продам "
action["buy"] = "Куплю "
action["change"] = "Обменяю "
action["my_change"] = "Обменяю "
action["ur_change"] = "Обменяю "
action["d_change"] = "Обменяю "
action[""] = "..."
act_text["sell"] = "Цена: "
act_text["buy"] = "Бюджет: "
act_text["auction"] = "Ставка от "
act_text["my_change"] = "Моя доплата: "
act_text["ur_change"] = "Ваша доплата: "
act_text["d_change"] = "С доплатой."
act_text["carmarket"] = "за "
action["n"] = 'nil'

ammunations_strings = {}
ammunations_strings[1] = "В магазине оружия ш. San-Fierro лучшие цены! | GPS: 11-6"
ammunations_strings[2] = "Стволы по самым низким ценам в штате! Оружейный San-Fierro! GPS:11-6"

sf_bank_strings = {}
sf_bank_strings[1] = "Переводи деньги с умом! Комиссия 0.7# в банке ш. SF. GPS 6-2"
sf_bank_strings[2] = "Комиссия на перевод 0.7# в банке ш. SF. Вход: 0$. | GPS 6-2"
sf_bank_strings[3] = "Самый минимальный процент на перевод в Банке ш. SF 0.6# | GPS 6-2"



function home_string(str, t_type, h_type, h_class, h_repair, h_number, h_location)
 --debug(t_type, 4)
  if t_type == "my_change" or t_type == "ur_change" or t_type == "change" then
    if str:find(".- на .+, на дом .+") then
      str_1, str_2 = str:match(".- на (.+), на дом (.+)")
      print("ОБМЕН (секция 1): ", get_location(str_1), home_changer(str_2))
      return action[t_type]..h_type..h_class..h_repair..get_location(str_1)..home_changer(str_2).." "..get_price(str, t_type)
    elseif str:find(" на ") then
      str_1, str_2 = str:match("(.+) на (.+)")
      print("ОБМЕН (секция 2): ", get_location(str_1), home_changer(str_2))
      return action[t_type]..h_type..h_class..h_repair..get_location(str_1)..home_changer(str_2).." "..get_price(str, t_type)
    else
      print(action[t_type], h_type, h_class, h_repair, h_number, h_location, get_price(str, t_type))
      return action[t_type]..h_type..h_class..h_repair..h_location..home_changer(str).." "..get_price(str, t_type)
    end
  end 
    price = get_price(str, t_type)
    print(str.." | "..t_type, h_type, h_class, h_location, price)
  return action[t_type]..h_type..h_class..h_repair..h_number..h_location..". "..get_price(str, t_type)
end

function home_changer(str)
  if str:find("дом [в]?%s?[Лл][Вв]") then
    return " на дом в ш. Las Venturas."
  elseif str:find("дом в Los Santos") then
    return " на дом в ш. Los Santos"
  elseif str:find("дом на вв") then
    return " на дом на г. VineWood"
  elseif str:find("дом у вмф") then
    return " на дом в д. Bayside"
  elseif str:find("в гетто") then
    return " на дом в опасном районе."
  elseif str:find("в [СS][ФF]") then
    return " на дом в ш. San Fierro"
  elseif str:find("в .+ [Ll]os%p?%s?[Ss]antos") then
    return " на дом в LS."
  elseif str:find("[Tt][ea]mple") or str:find("[Тт][еи]м[лп][лп][е]?") or str:find("ТЕМПЛ") then
    return " на дом в р. Temple"
  elseif str:find("[ПпPp][KkКк]") or str:find("[Пп][ао]л[д]?[оа]м[ио][нк][оа]") or str:find("(.+)[ao]lo[nm]ino%p?%s?(.+)re[ea]k") then
    return " на дом в д. Palomino Creek."
  else
    return " на ваш дом."
  end
end

function get_house_type(str)
  if str:find("мал[ыо]й") then
    home_type = "малый дом"
  elseif str:find("[Сс]ельский") or str:find("СЕЛЬСКИЙ") then
    home_type = "сельский дом"
  elseif str:find("[Шш]алаш") then
    home_type = "шалаш"
  elseif str:find("[дД]ом [Фф]ермер") then
    home_type = "дом фермера"
  elseif str:find("[Фф]ермерский") then
    home_type = "одинокий фермерский дом"
  elseif str:find("[Вв][ао]гон") then
    home_type = "вагончик"
  elseif str:find("[Ээ]лит(.-) [Рр]езид(.-)") then
    home_type = "элитную резиденцию"
  elseif str:find("[Мм]отель") then
    home_type = "мотель"
  elseif str:find("[Хх]ижи") then
    home_type = "хижину"
  elseif str:find("[Мм]ини%pдом") or str:find("мини дом") then
    home_type = "мини-дом"
  elseif str:find("[тТ]ру[щш][ео]б[уыа]?") then
    home_type = "трущебу"
  elseif str:find("[Аа][пп]артаменты") then
    home_type = "апартаменты"
  elseif str:find("избу") then
    home_type = "избушку"
  elseif str:find("[Пп]оместье у озера") then
    home_type = "поместье у озера"
  elseif str:find("[кК]рас") and str:find("[Тт]ера[с]?со") then
    home_type = "красивый дом с терассой"
  elseif str:find("дом у океана") and (str:find("огромный") or str:find("большой")) then
    home_type = "огромный дом у океана"
  elseif str:find("[Оо]соб[ня]") then
    if str:find("у моря") then
      home_type = "особняк у моря"
    else
      home_type = "особняк"
    end
  elseif str:find("[Тт]рел") or str:find("[Тт]рейл") then
    if str:find("одиночный трейлер") then
      home_type = "одиночный трейлер"
    elseif str:find("мини%p?%s?трейлер") then
      home_type = "мини-трейлер"
    else
      home_type = "трейлер"
    end
  elseif str:find("[Вв]рем") or str:find("врем[е]?няку") or str:find("ВРЯМЯНКУ") or str:find("ВРЕМЕННОЕ") or str:find("vremenoe jilie")  then
    home_type = "временное жильё"
  elseif str:find("хат") or str:find("[Дд][Оо][Мм]") or str:find("Дом") or str:find("жилье") then
    home_type = "дом"
  elseif str:find("[Кк]в[оа]рт") or str:find("картиру") or str:find("[Кк]ва[рт]") or str:find("%sкв%s") or str:find("КВАРТИРУ") then
    if str:find("[ЭэЕе]ли[т]?н") then
      if str:find("[Аа]ук") then
        home_type = "элитная квартира"
      else
        home_type = "элитную квартиру"
      end
    else
      home_type = "квартиру"
    end
  elseif str:find("[Вв]иллу") then
    home_type = "виллу"
  elseif str:find("[сС]арай") then
    home_type = "сарай"
  else
    home_type = "дом"
  end
  return home_type
end

function get_house_class(str)
  if str:find("[СсCc][ТтЕе]?[Рр][Ее][дн]") or str:find("СРЕДНЫЙ") or str:find("[Сс]ердный") or str:find("ср.%s?кл") then
    house_class = " среднего класса"
  elseif str:find("[ЭэЕе]к[оа]") or str:find("низкого") then
    house_class = " эконом класса"
  elseif str:find("[Пп]реми") then
    house_class = " премиум класса"
  elseif str:find("[Вв]ыс[^(та)]") or str:find("ВЫСОКОГО") or str:find("виского") or str:find("[Вв]исокий") then
    house_class = " высокого класса"
  elseif str:find("[ЭэЕеЖж][лЛ][иИ][тТ]") and not str:find("[Рр]езиден") then
    if str:find("[Аа]укц") then
      if str:find("кварт") then
        house_class = " элитная"
      else
        house_class = " элитный"
      end
    elseif str:find("кварти") then
      house_class = ""
    else
      house_class = " элитного класса"
    end
  elseif str:find("[Аа]втомеханика") then
    house_class = " автомеханика"
  elseif str:find("[Кк]ирпич") then
    house_class = " кирпичный"
  else
    house_class = ""
  end
  return house_class
end

function get_house_repair(str)
  if str:find("[ЕеэЭ]вро%s?%p?[ер][ер][мо][мо]н") or str:find("ЕВРОРЕМ") then
    house_repair = " с евроремонтом"
  elseif str:find("рем[но][он]т") or str:find("интой") or str:find("инта") or str:find("ИНТОЙ") or str:find("интерьером") then
    house_repair = " с ремонтом"
    if str:find("шикарным") then
      house_repair = " с шикарным ремонтом"
    elseif str:find("эксклюзивным") then
      house_repair = " с эксклюзивным ремонтом"
    end
  elseif str:find("авто%s?гаражо[ми]") or str:find("АВТОГАРАЖОМ") then
    house_repair = " с автогаражом"
  elseif str:find("бас[с]?ейном") then
    house_repair = " с бассейном"
  else
    house_repair = ""
  end
  return house_repair
end

function get_location(str)
  if str:find("па[см][Сс]?[Тт]?но[гмй]") or str:find("[Гг][еэ][т]?т[о]?[т]?[оа]") or str:find("ГЕТТО") or str:find("[Гг]етт") or str:find("[Gg][h]?et[t]?o") or str:find("%sг[еэ]тт%s") or str:find("пасны[мй]") or str:find("оп р") or str:find("опастом") then
    if str:find("ЖДЛС") or str:find("%s[ЖжДд][ДдЖж]%s") then
      obj_location = " в опасном районе у ЖДЛС"
    elseif str:find("[IiLl]dl[e]?wood") then
      obj_location = " в опасном р. Idlewood"
    elseif str:find("центр") then
      obj_location = " в центре опасного района"
    elseif str:find("на кольце") or str:find("коль[ь]?ц[ео] грув") then
      obj_location = " на кольце р. Ganton"
    elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("[Гг]рув [Сс]трит") or str:find("[Gg]anton") or str:find("[Гг][аэ]нтон") or str:find("[Gg]roove") then
      obj_location = " в опасном районе Ganton"
    elseif str:find("[Gg]len [Pp]ark") or str:find("[Гг]лен [Пп]арк") then
      obj_location = " в опасном р. Glen Park"
    else
      obj_location = " в опасном районе"
    end
  elseif str:find("[ДдТт][ао]м[о]?ж") then
    obj_location = " на таможне в ш. Las Venturas"
  elseif str:find("у [аА][пП]") then
    obj_location = " у АП в LS"
  elseif str:find("[Rr]ocksh[oe]r") and str:find("[Ww]est") then
    obj_location = " в р. Rockshore West ш. LV"
  elseif str:find("ЛС или ЛВ") or str:find("в лв или в лс") then
    obj_location = " в ш. Los Santos или ш. Las Venturas"
  elseif str:find("[Лл]ас%s?%p?[Бб]ар[р]?анкас") or str:find("Las-Barancas") or str:find("бар[р]?а[нк]") or str:find("arran") or str:find("бар[р]?аак") or str:find("aran") or str:find("д.LB") then
    obj_location = " в д. Las Barrancas"
  elseif str:find("санта") or str:find("(.*)anta") or str:find("(.*)aria") or str:find("[Мм]ария") then
    obj_location = " в р. Santa Maria"
  elseif str:find("[Mm]arina") or str:find("[Мм]арин[ае]") or str:find("[Нн]а [мМ]ари[яи]") then
    obj_location = " в р. Marina"
  elseif str:find("ТЦ%s?ЛС") or str:find("тц%s?лс") then
    obj_location = " в ТЦЛС"
  elseif str:find("у ап$") or str:find("у адм президента") or str:find("[Аа]дм. [Пп]резидента") or str:find("[Аа]дминистрации [Пп]резидента") then
    obj_location = " у АП в LS"
  elseif str:find("[лЛ]с") or str:find("ЛС") or str:find("лос") or str:find("Лос") or str:find("ш.LS") or str:find("%s[Ll][Ss]") or str:find("LS%s?^[|]") or str:find("Los") or str:find("los") then
    if str:find("[Жж][Дд][Лл][Сс]") or str:find("%s[ЖжДд][ДдЖж]%s")  then
      obj_location = " в ш. Los Santos за ЖД"
    elseif str:find("на горе вагос") or str:find("[Гг]ор[еа] [Вв]агос") or str:find("в районе [Vv]agos") or str:find("[Тт]ер[ие]тории [Вв]агос") then
      obj_location = " в опасном р. Los Flores"
    elseif str:find("у [Бб]оль[кн]") or str:find("[Бб][Лл][Сс]") then
      obj_location = " у больницы LS"
    elseif str:find("[Mm]ulhol[l]?and") then
      obj_location = " в р. Mulholland, ш. LS"
    elseif str:find("боль[кн]") or str:find("[Бб][Лл][Сс]") then
      obj_location = " в LS за больницей"
    elseif str:find("у [Аа][Пп]") then
      obj_location = " в LS у АП"
    elseif str:find("у [Аа]вторын") then
      obj_location = " у «Авторынка» LS"
    elseif str:find("[Вв] [Тт]орговом [Цц]ентре") then
      obj_location = " в ТЦ ш. Los Santos"
    elseif str:find("[Ee]ast [Bb]each") then
      obj_location = " в р. East Beach, ш. LS"
    elseif str:find("[Ee]l [Cc]orona") then
      obj_location = " в LS, р. El Corona"
    elseif str:find("Обменяю дом в Palomino") then
      obj_location = " в д. Palomino Creek"
    elseif str:find("на кольце") or str:find("коль[ь]?ц[ео] грув") then
      obj_location = " на кольце р. Ganton"
    elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("коль[ь]?ц[ео] [(грув)|(Grove)|(grove)]") or str:find("[Гг]рув [Сс]трит") or str:find("[Gg]anton") or str:find("[Гг][аэ]нтон") or str:find("[Gg]roove") then
      obj_location = " в опасном районе Ganton"
    elseif str:find("аэропорт[(ом)|(а)]") or str:find("АЭРОПОРТ[(ОМ)|(А)]") then
      obj_location = " в LS за аэропортом"
    elseif str:find("[Лл]ос [Вв]ентурас") or str:find("[Ll]os [Vv]enturas") then
      obj_location = " в ш. Las Venturas"
    elseif str:find("ТЦ%s?ЛС") or str:find("тц%s?лс") then
      obj_location = " в ТЦЛС"
    elseif str:find("пригоро") then
      obj_location = " в пригороде Los Santos"
    else
      obj_location = " в ш. Los Santos"
    end
  elseif not str:find("куебра") and str:find("[Ллl][BВвv]") or str:find("%sлас") or str:find("Лас") or str:find("ш.L%p?V") or str:find("%sL.V.") or str:find("%sLV") or str:find("LV[($)|(.)]") or str:find("LVPD") or str:find("enturas") or str:find("ентура") then
    if str:find("[Бб]ол[ь]?[нк]") or str:find("[Бб][Лл][Вв]") then
      obj_location = " у больницы ш. LV"
    elseif str:find("ЖДЛВ") or str:find("%s[Жж][Дд]%s[ЛлLl][VvВв]") then
      obj_location = " на ЖДЛВ"
    elseif str:find("[Bb][r]?u[jg]as") or str:find("[Бб][р]?у[д]?жас") then
      obj_location = " в д. Las Brujas"
    elseif str:find("[Лл][Кк][Нн]") or str:find("[Ll]a [Cc]osa [Nn]ostra") then
      obj_location = " в ш. Las Venturas, р. Prickle Pine"
    elseif str:find("[(над)|(у)|(горе)|(рядом с)] [Вв][Вв][Сс]") or str:find("[Pp]ay[a]?sad[aeo]") or str:find("[Пп]айдас") or str:find("[Пп]а[й]?[ая]садас") then
      obj_location = " в д. Las Payasadas"
    elseif str:find("[Пп]усты") then
      obj_location = " в пустыне ш. Las Venturas"
    elseif str:find("[(около)|(напротив)] м[еэ]рии") or str:find("[(у)|(рядом)] м[еэ]рии") or str:find("админист") or str:find("%sмерия%s") then
      chatDebug(str)
      obj_location = " в ш. Las Venturas около мэрии"
    elseif str:find("ЛВПД") or str:find("LVPD") then
      obj_location = " у ЛВПД"
    elseif str:find("[Ww][ht]ite%s?[Ww]ood [Ee]st") or str:find("у [РрP][MМм]") then
      obj_location = " в LV, р. Whitewood Estates"
    elseif str:find("[Rr]e[d]?sands") then
      obj_location = " в LV, р. Redsands West"
    elseif str:find("[Pp]rickle") or str:find("[Пп]ри[к]?[н]?л") or str:find("[Ll]a [Cc]osa [Nn]ostra") or str:find("%s[Пп]райкс%s[Пп]райн") or str:find("[Пп]ринцил") or str:find("пикл пайн") or str:find("%sприк%s") or str:find("[Pp][r]?i[n]?[c]?[k]?le") or str:find("[Лл][Кк][Нн]") or str:find("[Ll][CckK][Nn]") or str:find("[Ии]тал") and ("[Пп]осольства") then
      obj_location = " в р. Prickle Pine"  
    elseif str:find("у пожарки") then
      obj_location = " у пожарного депо LV"
    elseif str:find("лас%s?сантоса") then
      obj_location = " в ш. Los Santos"
    else
      obj_location = " в ш. Las Venturas"
    end
  elseif str:find("[Oo]cean [Ff]lats") then
    obj_location = " в SF, р. Ocean Flats"
  elseif str:find("[Bb][r]?u[jg]as") or str:find("[Бб][р]?у[д]?жас") then
    obj_location = " в д. Las Brujas"
  elseif str:find("на отшибе") then
    obj_location = " на отшибе в ш. Los Santos"
  elseif not str:find("[Rr]e[d]?sands") and str:find("[СсCc][Фф]") or str:find("сан") or str:find("САН %p ФИЕР[Р]?О") or str:find("[СC][аa]н") or str:find("ФИЕРРО") or str:find("[шг].SF") or str:find("%sSF") or str:find("sf") or str:find("SF%s^[|]") or str:find("San") or str:find("san") then
    if str:find("[(за)|(у)] боль[кн]") then
      obj_location = " в ш. San Fierro за больницей"
    elseif str:find("моря") then
      obj_location = " в ш. San Fierro у моря"
    elseif str:find("%s[Тт]ира") then
      obj_location = " в ш. San Fierro у тира"
    elseif str:find("%s[Цц]еркви[(%s)|(%p)]") then
      obj_location = " в ш. San Fierro у церкви"
    elseif str:find("Т[Ее]р") and str:find("Роба") then
      obj_location = " в о. Tierra Robada"
    elseif str:find("[Дд]жунипер [Хх]ол[л]?оу") or str:find("Juniper Hollow") then
      obj_location = " в р. Juniper Hollow, ш. SF"
    elseif str:find("СФФМ") or str:find("[(у)|(возле)] радио") or str:find("SF%s?FM") then
      obj_location = " у радиоцентра SF"
    elseif str:find("около [Вв][Мм][Фф]") then
      obj_location = " в д. Bayside"
    else
      obj_location = " в ш. San Fierro"
    end
  elseif str:find("у [Аа]втошколы") then
    obj_location = " в ш. SF у автошколы"
  elseif str:find("[Dd][ei]l[l]?imor[e]?") or str:find("[Дд][еи]л[л]?[ие]м[оу]р") then
    obj_location = " в д. Dillimore"
  elseif str:find("[(над)|(у)|(горе)|(рядом с)] [Вв][Вв][Сс]") or str:find("[Pp]ay[a]?[sl]ad[aeo]") or str:find("[Пп]айдас") or str:find("[Пп]а[й][ая]садас") then
    obj_location = " в д. Las Payasadas"
  elseif str:find("[Тт][иь]?[Рр]?[Ееа][рг][р]?[ао][^с]") or str:find("[Tt]ier[r]?[oa]") or str:find("[Tt]iro [Rr]obada") or str:find("%s[Тт][Рр]%s") or str:find("[TТ]%s[(Робада)|Robada]") then
    obj_location = " в о. Tierra Robada"
  elseif str:find("[ВвB][вВB][^с]") or str:find("ВВ[^С]") or str:find("на горе вв") or str:find("на [г]?%p?[Вв][Вв]$") or str:find("[wW][Ww]") or str:find("(.+)ine(.+)ood") or str:find("(.+)а[ий][н]?(%s?)(.+)у[н]?д") then
    obj_location = " на г. VineWood"
  elseif str:find("[Дд]жунипер [Хх]ол[л]?оу") or str:find("Juniper Hollow") then
    obj_location = " в р. Juniper Hollow, ш. SF"
  elseif str:find("[Ee]ast [Bb]each") then
    obj_location = " в р. East Beach, ш. LS"
  elseif str:find("тгомери") or str:find("[Mm]on[tg][h]?[tg][oe]m[eo]r[ey]") or str:find("мон[о]?гомери") or str:find("M[ao]ntogomery") or str:find("фарм.+%sфаб") or str:find("[Мм]о[н]?[т?][о]?г[еуо]м[ое]ри") or str:find("мандгомери") or str:find("mogomtery") or str:find("[Мм]отенегри") or str:find("монтенегро") or str:find("[Mm]on[t]?go") then
    obj_location = " в д. Montgomery"
  elseif str:find("[Rr]ed") and str:find("[Cc]ount[r]?y") or str:find("RedCount[r]?y") or str:find("[Рр]ед%s?[Кк][ао][у]?нтри") or str:find("о.Red") or str:find("[Оо]круг[е]? [Рр]ед") then
    obj_location = " в о. Red"
  elseif str:find("[Ff]lint") and str:find("[Cc]ount[r]?y") or str:find("[фФ]линт") or str:find("о.Flint") or str:find("в%sFC%p") then
    obj_location = " в о. Flint"
  elseif str:find("на [Фф]ерме") then
    obj_location = " в о. Flint"
  elseif str:find("[iI]ntersect") then
    obj_location = " в р. Flint Intersection"
  elseif str:find("[Bb]one") or str:find("[Бб]о[ну][ен]? [Кк][ао][у]?[н]?т[р]?[иу]") or str:find("[Пп]устын") then
    obj_location = " в о. Bone"
  elseif str:find("%s[Рр][Мм][(%s)|(%p)]") or str:find("около [Рр]усской мафии") or str:find("[Ww][ht]ite%s?[Ww]ood [Ee]st") or str:find("у [РрPp][MМм]") then
    obj_location = " в р. Whitewood Estates"
  elseif str:find("[IiLl]dl[e]?wood") then
    obj_location = " в опасном р. Idlewood"
  elseif str:find("[Pp]ri[n]?[c]?kl[e]?") or str:find("[Пп]ри[кн]?[нк]?л") or str:find("[Пп]ринцил") or str:find("%s[Пп]райкс%s[Пп]райн") or str:find("%sприк%s") or str:find("[Pp][r]?i[n]?[c]?[k]?le") or str:find("[Лл][Кк][Нн]") or str:find("[Ll][CcKk][Nn]") or str:find("[Ии]тал") and ("[Пп]осольства") then
    obj_location = " в р. Prickle Pine"  
  elseif str:find("[Ee]l [Cc]orona") then
    obj_location = " в LS, р. El Corona"
  elseif str:find("у телецентра") then
    obj_location = " у телецентрa в ш. LS"
  elseif str:find("[ВвBb][МмMmфФ][ФфМм]") or str:find("[au]ys[ia][di][ed]") or str:find("[еэаА][йЙ]?са[й]?д") or str:find("[Бб]аунсайд") then
    obj_location = " в д. Bayside"  
  elseif str:find("[Ww]hetstone") or str:find("[УуВв]этстоун") then
    obj_location = " в р. Whetstone"
  elseif str:find("[Qq]u[ea][a]?[br]") or str:find("[Кк][аув]?[еа]?[бпр]?[пб]рад[оа]с") or str:find("[Кк][аув]?[еа]?бардос") or str:find("[Кк]арбенос") or str:find("[Кк]вадрос")then
    obj_location = " в д. El Quebrados"  
  elseif str:find("[Tt][ea]mple") or str:find("[Тт][еи]м[лп][лп][е]?") or str:find("ТЕМПЛ") then
    obj_location = " в р. Temple" 
  elseif str:find("(.-)нжел") or str:find("[Аа]нг[е]?[й]?л [Пп][а]?й") or str:find("[Ээ]нджел") or str:find("[Аа]нгел [Пп][еаэи][йн][не]") or str:find("(.+)[Nnh]gel%p?%s?(.+)[ie][ni][en]") or str:find("(.+)ngel%p?(.+)ain")or str:find("[Дд]еревн[яе] за [Шш]ахтой") then
    obj_location = " в д. Angel Pine"
  elseif str:find("[ПпPp][KkКк]") or str:find("[Пп][ао]л[д]?[оа]м[ио][нк][оа]") or str:find("(.+)[ao]lo[nm]ino%p?%s?(.+)r[ei][eac]k") then
    obj_location = " в д. Palomino Creek"
  elseif str:find("[Фф][Кк]") or str:find("[Фф]орт") or str:find("[Кк][а][а]?рсон") or str:find("[Кк]артсон") or str:find("(.+)or[td]%p?%s?%s?(.+)arso[n]?") then
    obj_location = " в д. Fort Carson"
  elseif str:find("на кольце") or str:find("коль[ь]?ц[ео] грув") then
    obj_location = " на кольце в р. Ganton"
  elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("коль[ь]?ц[ео] [(грув)|(Grove)|(grove)]") or str:find("[Гг]рув [Сс]трит") or str:find("[Gg]anton") or str:find("[Гг][аэ]нтон") or str:find("[Gg]roove") then
    obj_location = " в опасном районе Ganton"
  elseif str:find("[Бб]л[ую]") or str:find("[Bb]lu[ed]?[Bb]e[r]?ry") or str:find("[(около)|(возле)|(у)] завода") then
    if str:find("[(около)|(возле)|(у)] завода") then
      obj_location = " в д. Blueberry"
    else
      obj_location = " в д. Blueberry"
    end
  elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("[Гг]рув [Сс]трит") or str:find("[Gg]anton") or str:find("[Gg]roove") then
    obj_location = " в р. Ganton, ш. Los Santos"
  elseif str:find("на горе вагос") or str:find("Горе Вагос") or str:find("[Тт]ер[ие]тории [Вв]агос") or str:find("[Рр]еспа [Вв]агос")  then
    obj_location = " в опасном р. Los Flores"
  elseif str:find("[хХ]им") and str:find("[зЗ]авод") then
    obj_location = " у химического завода"
  elseif str:find("за респ(.-)") and (str:find("[Bb]al[l]?as") or str:find("[Бб]ал[л]?ас")) then
    obj_location = " в опасном р. Glen Park"
  elseif str:find("[Ll]as [Cc]olinas") or str:find("[Лл]ас [Кк]олинас") then
    obj_location = " в опасном р. Las Colinas"
  elseif str:find("[Gg]len [Pp]ark") or str:find("[Гг]лен [Пп]арк") then
    obj_location = " в опасном р. Glen Park"
  elseif str:find("респе риф") or str:find("у рифы") then
    obj_location = " в опасном р. Playa de Seville"
  elseif str:find("[Рр]есп[еи] [вВ]агос") or str:find("у [вВ]агос") then
    obj_location = " в опасном р. Las Colinas"
  elseif str:find("[Ee]l [Cc]asti") then
    obj_location = " в д. El Castillo del Diablo"
  elseif str:find("[Gg][Pp][Ss]%s4%s?%p?%s?8") then
    obj_location = " в ш. Las Venturas"
  else
    obj_location = ""
  end
  return obj_location
end

function house_number(str)
  if str:find("№%s?%d+%s") then
    h_number = " №"..str:match("№%s?(%d+)%s?")
  elseif str:find("№%s?%d+%p") then
    h_number = " №"..str:match("№%s?(%d+)%p?")
  elseif str:find("дом №%d+$") then
    h_number = " №"..str:match("дом №(%d+)$")
  elseif str:find("[дД]ом N %d+") then
    h_number = " №"..str:match("[дД]ом N (%d+)")
  elseif str:find("номер%s%d+%p?%s") then
    h_number = " №"..str:match("номер%s(%d+)%p?%s")
  elseif str:find("клас[сc]а %d+ возле") then
    h_number = " №"..str:match("клас[сc]а (%d+) возле")
  elseif str:find("номером%s%d+%p?%s") then
    h_number = " №"..str:match("номером%s(%d+)%p?%s")
  elseif str:find("номером%s%d+!") then
    h_number = " №"..str:match("номером%s(%d+)!")
  elseif str:find("трейлер%s%d+$") then
    h_number = " №"..str:match("трейлер%s(%d+)$")
  elseif str:find("%W+%s%d+%sуспейте$") then
    h_number = " №"..str:match("%W+%s(%d+)%sуспейте$")
  elseif str:find("#%d+%p?%s") then
    h_number = " №"..str:match("#(%d+)%p?%s")
  elseif str:find("[Дд]ом%s%s?%d+%s[^( кк)]") then
    h_number = " №"..str:match("[Дд]ом%s%s?(%d+)%s")
  elseif str:find("выставлен дом %d+, в") then
    h_number = " №"..str:match("выставлен дом (%d+), в")
  elseif str:find("[Нн]а аукцион выставлен дом %d+$") then
    h_number = " №"..str:match("[Нн]а аукцион выставлен дом (%d+)$")
  elseif str:find("[Дд]ом%s%W+%s?%d+%s[^( кк)]") and str:find("[Аа]ук") then
    h_number = " №"..str:match("[Дд]ом%s%W+(%d+)%s")
  elseif str:find("ом фермера %d+") then
    h_number = " фермера №"..str:match("ом фермера (%d+)")
  else h_number = "" end
  return h_number
end

function auction(str)
  house_type = get_house_type(str)
  debug("AUCTION | "..str, 3)
  if str:find("[Цц]ена") or str:find("[Сс]тавка") or str:find("%sза%s") and str:find("%$") then
    word = auction_word(str)
    auction_string = "На аукцион "..word.." "..house_type..get_house_class(str)..house_number(str)..get_location(str)..". "..get_price(str, trade_type(str))
    return auction_shortener(auction_string)
  end
  print(get_house_type(str))
  word = auction_word(str)
  return "На аукцион "..word..get_house_class(str).." "..house_type..house_number(str)..get_location(str)..". Успей!"
end

function auction_shortener(str)
  if str:find("среднего") then
    str = str:gsub("среднего класса", "сред.")
  elseif str:find("элитного") or str:find("[Ээ]лит") then
    str = str:gsub("элитного класса", "элит."):gsub("Элит", "элит.")
  elseif str:find("эк[оа]ном") then
    str = str:gsub("эконом класса", "экон.")
  elseif str:find("высокого") then
    str = str:gsub("высокого класса", "выс. кл.")
  end
  return str
end

function auction_word(str)
  if house_type:find("квартир[уа]") then
    word = "выставлена"
    house_type = "квартира"
  else
    word = "выставлен"
  end
  return word
end

function ad_handler(str)
 --debug(str, 2)
  if str:find("[СсCc][Ее]?ред[ня][ян]%s?к") or str:find("[Сс]реднего") or str:find("[Сс]ердный") or str:find("[^(Работает)]%s[Ээ]лит[кн][оауиы]") or str:find("ЭЛИТК") or str:find("[Ээ]к[оа]номк[ау]") or str:find("[Ээ]к[оа]ном") or str:find("[Вв]ысокий класс") or str:find("[Сс]редний класс") then
    -- debug("CATCHED", 3)
    if str:find("[Аа]ук") then
       return auction(str)
    end
    return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_house_repair(str), house_number(str), get_location(str))
  
  elseif not str:find("pacey") and not str:find("[Сс]имку") and not str:find("24%p7") and not str:find("роймат") and not str:find("[Gg][Pp][Ss]") and not str:find("адовых") and not str:find("[Рр]иелт") and not str:find("[Сс]кин") and not str:find("GPS 8%p2") and not str:find("антех") and str:find("%s[Дд][;жл]?[МмОоЛл][МмСсОо]") or str:find("^[Дд]ом%s") or str:find("^%W- дои$") or str:find("[Пп]родам %pДом") or str:find("%W+%pдом%s") or str:find("плю до в") or str:find("дамдом") or str:find("жильё") or str:find("%shouse") or str:find("картиру") or str:find("[Вв]илла") or str:find("%shome") or str:find("[Вв]иллу") or str:find("dom") or str:find("[сС]арай") or str:find("[Кк]аварт") or str:find("%sкв%s") or str:find("[Ээ]лит(.-) [Рр]езид(.-)") or str:find("[Шш]алаш") or str:find("[Мм]ини%pдом") or str:find("[Вв][ро]ем[я]?нк[уа]") or str:find("врем[е]?няку") or str:find("времяну") or str:find("ВРЕМЕННОЕ") or str:find("[Вв]рем[ея]н") or str:find("[Кк][Вв][АаОо][Тт]?[Рр]") or str:find("%sхат") or str:find("[Вв][ао]гончик") or str:find("%sтрел") or str:find("[Тт]рейл") or str:find("жилье") or str:find("мини%p?%s?дом") or str:find("плю дам") or str:find("дам [Аа]партаменты") or str:find("[Пп]оместье у озера") or str:find("vremenoe jilie") or str:find("[тТ]ру[щш][ео]б[уыа]?") or str:find("[Хх]ижин[ау]") or str:find("[Оо]соб[ня][ян]к") or str:find("избу") or str:find("[Мм]отель") then
    --debug("HATA", 5)
    if str:find("[Аа]ук") or str:find("[Нн]а аук[е]?") or str:find("[Аа]ууционе") then
      house_type = get_house_type(str)
      
      --debug("AUCTION | "..str, 3)
      if str:find("[Цц]ена") or str:find("[Сс]тавка") or str:find("%sза%s") and str:find("%$") then
        word = auction_word(str)
        auction_string = "На аукцион "..word.." "..house_type..get_house_class(str)..house_number(str)..get_location(str)..". "..get_price(str, trade_type(str))
        return auction_shortener(auction_string)
      end
      print(get_house_type(str))
      word = auction_word(str)
      return "На аукцион "..word..get_house_class(str).." "..house_type..house_number(str)..get_location(str)..". Успей!"
    else
      return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_house_repair(str), house_number(str), get_location(str))
    end
  elseif not str:find("бирж") and not str:find("8%p273") and not str:find("[Pp]rice") and not str:find("[Сс]адов") and str:find("[уУ][й]?част[оь][кв]") or str:find("огород[(%s)|($)]") or str:find("ельный часток%s") or str:find("ЗЕМЕЛЬНЫЙ УЧАСТОК") then
    tt = trade_type(str)
    return action[tt].."земельный участок"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("иппи") then
    if str:find("лучшие для жизни") then
      return "Самые лучшие для жизни товары в магазине «Нижний Хиппи» GPS 8-127"
    elseif str:find("[Хх]иппи%p[Мм]обиль") then
      return "Уникальный Хиппи-Мобиль только в магазине по GPS 8-127"
    elseif str:find("счастл") then
      return "Хочешь стать счастливым? Тогда тебе в «Нижний Хиппи» | GPS 8-127"
    elseif str:find("[Вв][еe]р[xх]") then
      --debug("+++", 1)
      if str:find("[(Сниженные)|(Снизил)] цены на табак") then
        return "Сниженные цены на табак только в «Верхнем Хиппи» | GPS 8-127"
      elseif str:find("учший [Тт]абак в") then
        return "Лучший табак только в «Верхнем-Хиппи» | Мы в GPS: 8-127"
      elseif str:find("[Кк]урящий попугай") then
        return "Курящий попугай Кеша только в Вeрхнем-Хиппи! Мы в GPS 8-127"
      elseif str:find("[Мм]одный попугай") then
        return "Модный попугай Кеша только в «Верхнем-Хиппи»! | Мы в GPS 8-127"
      elseif str:find("Hippy%pCar") then
        return "Уникальный «Hippy Car» только в «Верхнем-Хиппи»! Мы в GPS 8-127"
      else
        return "Продам бизнес «Верхний Хиппи» в ш. San Fierro. "..get_price(str, trade_type(str))
      end
    end
    return "Продам бизнес \"Нижний Хиппи\""..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("[Лл]юб[оа][йя] [Мм]арк[иа]") or str:find("[Кк]уплю [аА]втомобиль%s?%p?$") or str:find("[Лл]юб[оа][йя] [FfФф][TtТт]") or str:find("[FfФф][TtТт] автомобиль") or str:find("любое авто") or str:find("[Кк]уплю авто%p") or str:find("[Кк]уплю [Мм]аш[иы]н[уы]%p?$") or str:find("[Кк]уплю [Мм]аш[иы]ну [Бб]юд") or str:find("вертолёт%.") or str:find("самол[её]т любой") then
    if str:find("[Вв]ерт") or str:find("воздуш") or str:find("вертолёт%.") then
      return "Куплю вертолёт любой марки. "..get_price(str, trade_type(str))
    elseif str:find("[Сс]амол") and str:find("[Лл]юб") then
      return "Куплю самолёт любой марки. "..get_price(str, trade_type(str))
    end
    return "Куплю автомобиль любой марки"..car_tuning(str)..". "..get_price(str, trade_type(str))
  elseif str:find("[Nn][RrGg][GRrg]") or str:find("[Нн][РргГ][ГгРр]") or str:find("NRG") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "мотоцикл", "NRG-500")
  elseif str:find("[Ff][Cc][Rr]") or str:find("[Фф][СсКк][Рр]") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "мотоцикл", "FCR-900")
  elseif str:find("[Pp][Cc][Jj]") or str:find("[Пп][Сс][Жж]") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "мотоцикл", "PCJ-600")
  elseif str:find("[Ss]anchez") or str:find("[Сс]анчез") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "мотоцикл", "Sanchez")
  elseif str:find("[Ff]reeway") or str:find("[Фф]ривей") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "мотоцикл", "Freeway")
  elseif str:find("[Bb][Mm][Xx]") then -- ПРОДАЖА ТРАНСПОРТА
    return vechicles(str, trade_type(str), "велосипед", "BMX")
    elseif str:find("[mM]o[vw]er[(%p)|($)|(%s)]") or str:find("[Мм][оу]вер[(%p)|($)]") then
    return vechicles(str, trade_type(str), "газонокосилку", "Mower")
  elseif str:find("GT[^A]") or str:find("%sгт[^а]") or str:find("супер [Гг][Тт]") or str:find("Super GT") or str:find("[(super)|(супер)] gt") then
    return vechicles(str, trade_type(str), "автомобиль", "Super GT")
  elseif str:find("су[лт][тл][(ан)]?") or str:find("s[uy]ltan") or str:find("[Сс][ул][ула]?[та][та]?н") or str:find("S[uy]l[l]?tan") or str:find("S[YU]LTAN") or str:find("[Сс]улик") then 
    return vechicles(str, trade_type(str), "автомобиль", "Sultan")
  elseif str:find("[Bb][Ff]") or str:find("[Ii]njection") or str:find("[Бб][Фф]") then 
    return vechicles(str, trade_type(str), "автомобиль", "BF Injection")
  elseif str:find("[мМ][еоа]в[ае]р") or str:find("маврик") or str:find("aver[r]?i[c]?[kc]") or str:find("мавик") or str:find("mavik") or str:find("ав[ео][р]?ик") or str:find("averiс") then 
    return vechicles(str, trade_type(str), "вертолёт", "Maverick")
  elseif str:find("zrx") or str:find("zrx 350") or str:find("zrx-350") or str:find("ZRX") or str:find("[Zz][Rr]") or str:find("ZRX-350") or str:find("ZRX 350") then 
    return vechicles(str, trade_type(str), "автомобиль", "ZRX-350")
  elseif str:find("ul[l]?et") or str:find("[Бб]улк[уа]") or str:find("[Бб]ул[реи]т") or str:find("[Бб]улл[л]?[еи]т") then
    return vechicles(str, trade_type(str), "автомобиль", "Bullet")
  elseif str:find("[Pp]remier") or str:find("PREMIER") or str:find("[Пп]р[еи]м[ье][ер][рь]") then
    return vechicles(str, trade_type(str), "автомобиль", "Premier")
  elseif str:find("[Ee]legant") or str:find("[ЕеЭэ]легант") then
    return vechicles(str, trade_type(str), "автомобиль", "Elegant")
  elseif str:find("[Rr]emington") or str:find("[Рр]емин[г]?тон") then
    return vechicles(str, trade_type(str), "автомобиль", "Remington")
  elseif str:find("[Ww]il[l]?ard") or str:find("[ВУву]ил[л]?ард") then
    return vechicles(str, trade_type(str), "автомобиль", "Willard")
  elseif str:find("[Ss][ea]nti[n]?el") or str:find("[Сс]ентинел") then
    return vechicles(str, trade_type(str), "автомобиль", "Sentinel")
  elseif str:find("(.*)an%s?(.*)in[gd]") or str:find("[Сс]анд[кК]инг") or str:find("санкенг") or str:find("(.*)[аэе]н[дг]?%s?[к]?ин[у]?г") or str:find("sek ft") or str:find("%s[СSs][КKk]%s") or str:find("(%s)[Сс][Кк](%s)") or str:find("(%s)[Сс][Кк]$") or str:find("(%s)с[аэ]н[дк](%s)") or str:find("(%s)САНД КИНГ") or str:find("SANDKING") or str:find("сандкинг") then
    return vechicles(str, trade_type(str), "автомобиль", "Sandking")
  elseif str:find("tre[tsn]ch") or str:find("сретч") or str:find("[сС]третч") or str:find("[Ss]tr[ae][t]?[cs]h") or str:find("[Лл][Дд]?[ия]муз[и]?н") or str:find("[Пп]рода[мю] стреч") then
    return vechicles(str, trade_type(str), "автомобиль", "Stretch")
  elseif str:find("легию") or str:find("легия") or str:find("[Ee]leg[yu]") or str:find("legy") or str:find("enegy") or str:find("[ЭэЕе]леги") or str:find("[ЭэЕе]ле[дж][жд]и") or str:find("[Ее]лег") then
    return vechicles(str, trade_type(str), "автомобиль", "Elegy")
  elseif str:find("[РрRr][ИиIi][ОоOo][ТтTt]%s?%+") or str:find("[rt]iot%s?%+") or str:find("роит %+") or str:find("[Хх]ам[ме][не]р %+") or str:find("[Пп]атрик %+") or str:find("[Pp]atrik %+") or str:find("хам[м]?ер %+") or str:find("[Пп]атриот [Пп]люс") then
    return vechicles(str, trade_type(str), "автомобиль", "Patriot +")
  elseif str:find("ри[т]?от") or str:find("riot") or str:find("[^(ст)]роит") or str:find("[Хх]ам[ме][не]р") or str:find("[Пп]атрик") or str:find("[Pp]atrik") or str:find("хам[м]?ер") then
    return vechicles(str, trade_type(str), "автомобиль", "Patriot")
  elseif str:find("[Пп]ревион") or str:find("[Pp]revion") then
    return vechicles(str, trade_type(str), "автомобиль", "Previon")
  elseif str:find("[Хх]от%p?%s?[Дд]ог") or str:find("[Hh]ot%p?%s?[Dd]og") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotdog")
  elseif str:find("[Аа]дмирал") or str:find("[Aa]dmiral") then
    return vechicles(str, trade_type(str), "автомобиль", "Admiral")
  elseif str:find("х[ае]нтли") or str:find("[Hh]unt[le][el][yt]") or str:find("[ае]нтли") or str:find("untly") or str:find("ХАНТЛИ") then
    return vechicles(str, trade_type(str), "автомобиль", "Huntley")
  elseif str:find("[Ll]andstalker") or str:find("[Лл][аэ]н[д]?сталкер") then
    return vechicles(str, trade_type(str), "автомобиль", "Landstalker")
  elseif str:find("[Тт][Цц]?[Уу][Рр][Ии][Кк]") or str:find("[Тт]ури[зс]м[ао]") or str:find("[Tt][UuYy]ri[sz]mo") then
    return vechicles(str, trade_type(str), "автомобиль", "Turismo")
  elseif str:find("[Cc]adrona") or str:find("[Кк]адрона") then
    return vechicles(str, trade_type(str), "автомобиль", "Cadrona")
  elseif str:find("[Ии]скр[ау]") and (str:find("[Пп]род") or str:find("[Кк]уп")) then
    return vechicles(str, trade_type(str), "автомобиль", "Искра")
  elseif str:find("[Мм]ерит") or str:find("[Mm]erit") then
    return vechicles(str, trade_type(str), "автомобиль", "Merit")
  elseif str:find("[^(имени%s)][Aa]lpha") or str:find("[(марки)] Alpha") or str:find("[Аа]льф[ау]") then
    return vechicles(str, trade_type(str), "автомобиль", "Alpha")
  elseif str:find("[Uu]ranus") or str:find("[Уу]ранус") then
    return vechicles(str, trade_type(str), "автомобиль", "Uranus")
  elseif str:find("[Jj]ester") or str:find("[Дд]жестер") then
    return vechicles(str, trade_type(str), "автомобиль", "Jester")
  elseif str:find("[Bb]uffalo") or str:find("[Бб]уф[ф]?ал[л]?о") then
    return vechicles(str, trade_type(str), "автомобиль", "Buffalo")
  elseif str:find("[Pp]hoenix") or str:find("[Фф]еникс") then
    return vechicles(str, trade_type(str), "автомобиль", "Phoenix")
  elseif str:find("[Hh]ot%s?[Kk][hn]ife") or str:find("[Хх]от[к]?найф") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotknife")
  elseif str:find("[Mm]esa") or str:find("[Мм]ес[ау]") then
    return vechicles(str, trade_type(str), "автомобиль", "Mesa")
  elseif str:find("[Oo]ceanic") or str:find("[Оо]кеаник") then
    return vechicles(str, trade_type(str), "автомобиль", "Oceanic")
  elseif str:find("[Bb]ansh") or str:find("[Бб]ан[ь]?ш") then
    return vechicles(str, trade_type(str), "автомобиль", "Banshee")
  elseif str:find("[Ss]unri[sc]e") or str:find("[Сс][уа]нрай[сз]") then
    return vechicles(str, trade_type(str), "автомобиль", "Sunrise")
  elseif str:find("марки %p?%p?[SsСс]%p?[WwВв]%p?[AaАа]%p?[TtТт]") or str:find("S.W.A.T") or str:find("S[Ww][Aa][Tt]") or str:find("[сС][вВ][аА][Тт]") then
    return vechicles(str, trade_type(str), "автомобиль", "S.W.A.T")
  elseif str:find("[Ee]uros") or str:find("[ЕеЭэ][ув]рос") then
    return vechicles(str, trade_type(str), "автомобиль", "Euros")
  elseif str:find("[Ss]avan") or str:find("[Сс]аван") then
    return vechicles(str, trade_type(str), "автомобиль", "Savanna")
  elseif str:find("[Ff]ortune") or str:find("[Ff]ORTUNE") or str:find("[Фф]орт") and not str:find("[Pp]rice") then
    return vechicles(str, trade_type(str), "автомобиль", "Fortune")
  elseif str:find("[Dd]un[ea]") or str:find("[Дд]юн[ау]?") then
    return vechicles(str, trade_type(str), "автомобиль", "Dune")
  elseif str:find("[Dd][eo]lor[ei][a]?n") or str:find("[Дд][еэ]лор[еи]ан") then
    return vechicles(str, trade_type(str), "автомобиль", "Delorean")
  elseif str:find("[Bb]lade") or str:find("[Бб]л[эеа]йд") then
    return vechicles(str, trade_type(str), "автомобиль", "Blade")
  elseif str:find("[Vv]oodoo") or str:find("[Вв]уду") then
    return vechicles(str, trade_type(str), "автомобиль", "Voodoo")
  elseif str:find("[Mm]onster") or str:find("[Мм]%s?онст[еа]?[р]?") or str:find("MONSTER") or str:find("МОНСТ[Е]?Р") then
    return vechicles(str, trade_type(str), "автомобиль", "Monster A")
  elseif str:find("[Ss]lamvan") or str:find("[Сс]л[аеэ]мв[аеэ]н") then
    return vechicles(str, trade_type(str), "автомобиль", "Slamvan")
  elseif str:find("[Mm]oonbe") or str:find("[Мм]унбим") then
    return vechicles(str, trade_type(str), "автомобиль", "Moonbeam")
  elseif str:find("[Rr][ua][mnp][mp]o") or str:find("[Рр][уа][мн]по") then
    return vechicles(str, trade_type(str), "автомобиль", "Rumpo")
  elseif str:find("[Rr]omero") or str:find("[Рр]омеро") then
    return vechicles(str, trade_type(str), "автомобиль", "Romero")
  elseif str:find("[WwVv]indsor") or str:find("[Вв]инд[зс]ор") then
    return vechicles(str, trade_type(str), "автомобиль", "Windsor")
  elseif str:find("[Jj]ourney") then
    return vechicles(str, trade_type(str), "автомобиль", "Journey")
  elseif str:find("[Bb]uccaneer") then
    return vechicles(str, trade_type(str), "автомобиль", "Buccaneer")
  elseif str:find("[Bb]lista [Cc]ompact") or str:find("[Бб]листа") then
    return vechicles(str, trade_type(str), "автомобиль", "Blista Compact")
  elseif str:find("[Pp]eren[n]?i[ea]l") or str:find("[Пп]ерениал") then
    return vechicles(str, trade_type(str), "автомобиль", "Perennial")
  elseif str:find("[Bb]roadway") or str:find("[Бб]родв[эе]й") then
    return vechicles(str, trade_type(str), "автомобиль", "Broadway")
  elseif str:find("[Ss]taf[f]?ord") or str:find("[CcСс]т[аэ]ф[ф]?орд") then
    return vechicles(str, trade_type(str), "автомобиль", "Stafford")
  elseif str:find("[Yy]osemite") or str:find("[Йй]осемит") then
    return vechicles(str, trade_type(str), "автомобиль", "Yosemite")
  elseif str:find("[Gg]lendale") or str:find("[Гг]лендейл") then
    return vechicles(str, trade_type(str), "автомобиль", "Glendale")
  elseif str:find("[Ff][BbIi][BbIiRr]%s?%p?[Rr][n]?a[cn][ncs]?[hn]e[rl]") or str:find("F[BI][BRI] RANCHER") or str:find("ФБ[ИР] РАН[Е]?[ЧЦ]ЕР") or str:find("ф[би][бирл] [Рр][ае]?[ач]?н[е]?[чр]") or str:find("[Рр][ае]н[цч]ер [Фф][Бб][РрИи]") then
    return vechicles(str, trade_type(str), "автомобиль", "FBI Rancher")
  elseif str:find("[Ff][BbIi][BbIiRr]%s?%p?[Tt]r[ua]ck") or str:find("[Фф][БбИи][БбИиРр] [Тт]р[ау][к]?") then
    return vechicles(str, trade_type(str), "автомобиль", "FBI Truck")
  elseif str:find("[Rr]an[cs][hn]e[rl]") or str:find("[Рр]а[ч]?н[чц]ер") then
    return vechicles(str, trade_type(str), "автомобиль", "Rancher")
  elseif str:find("[Ww]ashington") or str:find("[Вв]ашингтон") then
    return vechicles(str, trade_type(str), "автомобиль", "Washington")
  elseif str:find("[Уу]дарник") then
    return vechicles(str, trade_type(str), "автомобиль", "Ударник")
  elseif not str:find("мастер") and str:find("[Cc]lover") or str:find("[КкСс]ловер") and not str:find("[Дд]евушк") then
    return vechicles(str, trade_type(str), "автомобиль", "Clover")
  elseif str:find("[Mm]anana") or str:find("[Мм]анан[ау]") then
    return vechicles(str, trade_type(str), "автомобиль", "Manana")
  elseif str:find("[Ss]t[ae]l[l]?ion") or str:find("[Сс]т[аеэ]л[л]?ион") then
    return vechicles(str, trade_type(str), "автомобиль", "Stallion")
  elseif str:find("[Ss]abre") or str:find("[Сс]ейбр") or str:find("[Сс]абре") then
    return vechicles(str, trade_type(str), "автомобиль", "Sabre")
  elseif str:find("[Ff]l[ae]sh") or str:find("[Фф]л[эе]ш") then
    return vechicles(str, trade_type(str), "автомобиль", "Flash")
  elseif str:find("[Кк]омет") or str:find("[CcСс]omet") then
    return vechicles(str, trade_type(str), "автомобиль", "Comet")
  elseif str:find("[Сс]тратум") or str:find("[Ss]tratum") then
    return vechicles(str, trade_type(str), "автомобиль", "Stratum")
  elseif str:find("[Bb]andit") or str:find("[Бб]агги") or str:find("[Бб]андит[т]?о") and not str:find("кеан") then
    return vechicles(str, trade_type(str), "автомобиль", "Bandito")
  elseif str:find("[Шш]амал") or str:find("hamal") or str:find("шаман") or str:find("[Ss]hama[nl]") then
    return vechicles(str, trade_type(str), "самолёт", "Shamal")
  elseif str:find("[Nn]evad[ae]") or str:find("[Нн]евада") then
    return vechicles(str, trade_type(str), "самолёт", "Nevada")
  elseif str:find("[Rr]ustler") or str:find("[Рр][ау]с[т]?лер") then
    return vechicles(str, trade_type(str), "самолёт", "Rustler")
  elseif str:find("[Aa]ndrom[ae]da") or str:find("[Аа]ндр[оа]м[аеэ]д[ау]") then
    return vechicles(str, trade_type(str), "самолёт", "Andromada")
  elseif str:find("[Bb]eagle") or str:find("[Бб][ие][а]?гл") then
    return vechicles(str, trade_type(str), "самолёт", "Beagle")
  elseif str:find("[Cc]ropduster") then
    return vechicles(str, trade_type(str), "гидроплан", "Cropduster")
  elseif str:find("[Dd]odo") or str:find("[Дд]одо") then
    return vechicles(str, trade_type(str), "самолёт", "Dodo")
  elseif str:find("t[au]n(.*)%s?[Pp]la[(ne)|(y)]") or str:find("tun[t]?%s?[Pp]la[(ne)|(y)]") or str:find("СТАНТП%s?Л(.+)Н") or str:find("[Сс]тан[тд]%s?[Пп]л(.+)") then
    return vechicles(str, trade_type(str), "самолёт", "Stuntplane")
  elseif str:find("сперроу") or str:find("спароу") or str:find("a[r]?row") or str:find("[Ss]appraw") or str:find("сперов") or str:find("спар[р]?ов") or str:find("СПАР[Р]?ОВ") then
    return vechicles(str, trade_type(str), "вертолёт", "Sparrow")
  elseif str:find("[Rr]ain[e]?dance") or str:find("[Рр]ейнда") then
    return vechicles(str, trade_type(str), "вертолёт", "Raindance")
  elseif str:find("[Ll]ev[ie]athan") or str:find("[Лл]евиа[тф]ан") then
    return vechicles(str, trade_type(str), "вертолёт", "Leviathan")
  elseif str:find("arq[ui][ie]s") or str:find("маркиз") or str:find("маркис") then
    return vechicles(str, trade_type(str), "яхту", "Marquis")
  elseif str:find("[Tt]ropic") or str:find("[Тт]ропик") then
    return vechicles(str, trade_type(str), "яхту", "Tropic")
  elseif str:find("[Vv]ortex") or str:find("[Вв]ортекс") then
    return vechicles(str, trade_type(str), "судно", "Vortex")
  elseif str:find("[Ss]peader") or str:find("[Сс]пидер") then
    return vechicles(str, trade_type(str), "судно", "Speader")
  elseif str:find("[Rr]e[ae]fer") or str:find("[Рр]ифер") then
    return vechicles(str, trade_type(str), "судно", "Reefer")
  elseif str:find("[Dd]ingh[iy]") or str:find("[Дд]инги") then
    return vechicles(str, trade_type(str), "судно", "Dinghy")
  elseif str:find("[Jj]etmax") or str:find("[Дд]жетмакс") then
    return vechicles(str, trade_type(str), "судно", "Jetmax")
  elseif str:find("[Ss]qual[l]?o") or str:find("[Сс]куало") then
    return vechicles(str, trade_type(str), "судно", "Squallo")
  elseif str:find("[Ss]pe[e]?der") or str:find("[Сс]пидер") then
    return vechicles(str, trade_type(str), "судно", "Speeder")
  elseif str:find("heetah") or str:find("читах") or str:find("итах") or str:find("читу") or str:find("чейтах") then
    return vechicles(str, trade_type(str), "автомобиль", "Cheetah")
  elseif str:find("nf[er][er]nus") or str:find("н[ф]?е[ру][нр][ун]с") or str:find("инф[ау]") or str:find("[Ii]nf[eu](.-)s") or str:find("[иИ][Нн][Фф][Ее][Рр]") or str:find("инф[р]?енус") or str:find("INFERNUS") or str:find("%sИНФА%s") or str:find("infa") then
    return vechicles(str, trade_type(str), "автомобиль", "Infernus")
  elseif str:find("от%s?ри[н]?г [ВвБбbB]") or str:find("o[r]?t[r]?ing [ВвBbВв]") or str:find("otring B") or str:find("[Хх]отр[(инг)]? [БбBbВв]") or str:find("[aа][cс][eе][rр] [BbВвБб]") or str:find("acer B") or str:find("[Рр]ейсер [Бб]") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotring Racer B")
  elseif str:find("о[тр][три][ир][н]?г[а]? [AaАа]") or str:find("o[r]?t[r]?ing a") or str:find("ot[Rr]ing A") or str:find("[Хх]отр[(инг)]? [АаAa]") or str:find("[aаAА][cсCС][eеEЕ][rрРR] [АаAa]") or str:find("acer %p?A%p?") or str:find("ейс[еи][рн](.-) [Аа]") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotring Racer A")
  elseif str:find("отринг") or str:find("o[r]?t[r]?ing") or str:find("хотрин[Гг]") or str:find("acer") then
    return vechicles(str, trade_type(str), "автомобиль", "Hotring Racer")
  elseif str:find("[Bb]l[o]?odring [Bb]anger") or str:find("BLOODRING BANGER") or str:find("[Бб]лудринг") then
    return vechicles(str, trade_type(str), "автомобиль", "Bloodring Banger")
  elseif not str:find("[Лл]ичным") and str:find("Устроюсь") or str:find("[Тт]ранспортн[(ую)|(ои)]") or str:find("%s[Тт][Кк]%s?") or str:find("дальнобой") or str:find("%sтк%s") and not str:find("сутки") then
    if str:find("Ищу человека") or str:find("[Ии]щу напарника") then
      return "Ищу напарника для совместного труда в трансп. компании. Звоните!"
    end
    return "Ищу работу в транспортной компании. Жду звонков."
  elseif str:find("[Лл]ичн[ыо][гм](.-) [Вв]одител") then
    return "Предоставляю услуги личного водителя. Звоните."
  
  elseif str:find("[Gg][Pp][Ss]") and str:find("[Ss]%p?%s?4%s?%p%s?7") and not str:find("[Дд]илимур") then
    if str:find("[Pp]rada") then -- Проходит собеседование в магазин Сhiesa GPS 4-7.
      --debug("ЧИЕССА", 3)
      if str:find("[Ии]д[её]т собеседовани") or str:find("Собеседование") then
        return "Идет собеседование в Страховую Компанию «Prada»! Ждем: GPS 4-7"
      elseif str:find("[Пп]роходит") then
        return "Проходит собеседование в СК «Prada» | Приходите: GPS 4-7"
      end
    elseif str:find("[Cc]hiesa")then
      if str:find("[Пп]роходит собеседование") then
        return "Проходит собеседование в сельхоз. компанию «Chiesa» | GPS 4-7"
      end
    end
    
  elseif str:find("[Gg][Pp][Ss]") and str:find("4%s?%p%s?9") then
    if str:find("Проходит набор в") and str:find("[Мм]едвеж") then
      return "Проходит набор в «ЧОП Русский медвежонок». | Мы в GPS 4-9"
    end

  elseif str:find("[Gg][Pp][Ss]") and str:find("4%s?%p%s?4") then
    if str:find("Проходит набор в") then
      return "Проходит набор в Авто-клуб «DRIFA». | GPS 4-4 | Ждём!"
    end

  elseif str:find("слет новых") then    -- реклама --
    return "Ежедневно слет новых сим-карт. Успейте подобрать себе | GPS 8-280"
  elseif str:find("[Рр]екл[ам][ма]н(.+) [Аа]ген(.+)") and str:find("[LlЛл][VvВв]") then
    if str:find("Реклама вашего бизне") then
      return "Реклама вашего бизнеса только в Рекламном Агенстве ЛВ | GPS 8-234"
    elseif str:find("Арендуй [Бб]илборд") then
      return "Арендуй билборд в «Рекламном агенстве LV» | GPS 8-234"
    elseif str:find("Свободные [Бб]илборд") then
      return "Свободные билборды в «Рекламном агенстве LV» | GPS 8-234"
    elseif str:find("освободились б[ы]?илборды") then
      return "В «Рекламном агенстве LV» освободились быилборды | GPS 8-234"
    end
  elseif str:find("[Рр]екламной [Кк]омпании") and str:find("8%s?%p?%s?84") then
    if str:find("Компании LS свободные билборды") then
      return "В «Рекламной Компании LS» свободные билборды. GPS 8-84."
    end
  elseif str:find("[Кк]луб") and str:find("[Пп]арашютистов") then
    if str:find("Повысь адреналин") then
      return "Повысь адреналин прыжком в «Клубе парашютистов». GPS 8-55"
    elseif str:find("Всегда мечтал полетать") then
      return "Всегда мечтал полетать? Тебе в клуб парашютистов! Мы в аэроп. LS!"
    elseif str:find("Хочешь испытать экстрим") then
      return "Хочешь испытать экстрим? Клуб парашютистов ждет Вас! | GPS 8-55"
    end

  elseif str:find("[Gg]aydar [Ss]tation") then
    if str:find("Устал от работы") then
      return "Устал от работы? Развейся в клубе «Gaydar Station». | Price 3-29"
    elseif str:find("[Пп]родам") then
      return "Продам клуб «Gaydar Station»"..get_location(str)..". "..get_price(str, trade_type(str))
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("7%s?%p%s?1") then
    if str:find("Ты пацан%p%s?Ты") then
      return "Ты пацан? Ты с улицы? Тогда тебе в «Advance Club». | Мы в GPS 7-1"
    elseif str:find("Самые качественные сигары") then
      return "Самые качественные сигары только в «Advance Club». GPS 7-1"
    elseif str:find("Лучшие вечеринки") then
      return "Лучшие вечеринки в клубе «Advance Club» | GPS 7-1"
    elseif str:find("Лучшие тусовки только") then
      return "Лучшие тусовки только в «Advance Club». GPS 7-1! Станцуй лучше!"
    elseif str:find("Сочные девушки") then
      return "Сочные девушки! Стильная музыка! Только в «Advance Club»! GPS 7-1"
    end
  elseif str:find("[Тт]ире") and str:find("7%s?%p%s?2") or str:find("8%s?%p%s?281") then
    if str:find("свой навык ст[ре][ер]льбы") then
      return "Прокачай свой навык стрельбы в «Тире» ш. San Fierro | GPS 7-2"
    elseif str:find("Плохо стреляешь") then
      return "Плохо стреляешь? Повысь навыки стрельбы в «ТИР SF»! | GPS 8-281"
    end
    
  elseif str:find("[Уу]правлени[ией] [Сс]татистик[ио][й]?") and str:find("8%s?%p%s?46") then
    if str:find("АЗС") then
      return "В «Управлении статистики» АЗС по гос. цене | GPS 8-46"
    elseif str:find("[Бб]изнесы") then
      return "В «Управлении статистики» бизнесы от 125.000$ | GPS 8-46"
    elseif str:find("Хочешь бизнес") then
      return "Хочешь бизнес? тогда тебе в «Управление статистики» | GPS 8-46"
    elseif str:find("Лучшие бизнес проекты") then
      return "Лучшие бизнес проекты в «Управлений статистики»! | GPS 8-46"
      --В "Управлений статистикой" лучшие бизнес-проекты! GPS 8 > 46.
    elseif str:find("статистик[ио][й]?%p лучшие бизнес%p?проекты") then
      return "В «Управлении статистики» лучшие бизнес-проекты | GPS 8-46"
    end
  elseif str:find("[Рр]есторан") and str:find("8%s?%p%s?46") then
    if str:find("алее звёзд ждёт") then
      return "Ресторан на алее звёзд ждёт тебя! | Мы напротив GPS 8-46"
    end
  
  elseif str:find("[Кк]ази[нк]о") and not str:find("[Пп]род") and not str:find("[Кк]уплю") then
    if str:find("очешь поднять бабла") then
      return "Хочешь поднять бабла? В «Казино LS» ставки до 300.000$ | GPS 8-22"
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?20") then
      if str:find("риходите в казино Лос%pСантоса") then
        return "Приходите в «Казино Лос-Сантоса». | Ищите нас по GPS 7-20"
      elseif str:find("В частном") then
        return "В частном «Казино Los Santos» играют на большие ставки | GPS 7-20"
      elseif str:find("играют на большие") then
        return "В «Казино LS» играют на большие ставки! | Мы в GPS 7-20"
      elseif str:find("выпивка и игры") then
        return "Лучшая выпивка и игры в «Казино Los Santos» | Приходите: GPS 7-20"
      elseif str:find("большие выигрыши в казино") then
        return "Самые большие выигрыши в казино ш. Лос Сантос! | GPS 7-20"
      elseif str:find("Хочешь веселый вечер") then
        return "Хочешь веселый вечер? Купи выпивку в «Казино LS» | GPS 7-20"
      elseif str:find("выпивка и игроки") then
        return "Лучшая выпивка и игроки в «Kазино Los Santos». | GPS 7-20"
      elseif str:find("Увеличь свой доход") then
        return "Увеличь свой доход с играми в «Казино Los Santos». | GPS 7-20"
      end
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?22") then
      if str:find("Хочешь выйграть КУШ") then
        return "Хочешь выйграть КУШ? Тогда тебе в «Восточное Казино» | GPS 7-22"
      elseif str:find("В частном кази[кн]о") then
        return "В частном казино «Восточное» играют на большие ставки! | GPS 7-22"
      end
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?21") then
      if str:find("Выпивай и [вВ]ыигрывай") then
        return "Выпивай и выигрывай в частном «Казино Лас-Вентураса» | GPS 7-21"
      elseif str:find("Задолбал [Бб]осс") then
        return "Задолбал Босс? Отдохни в частном Казино Лас-Вентураса. GPS 7-21"
      end
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?18") then
      if str:find("играют на большие суммы") then
        return "В казино «4 дракона» играют на большие суммы! | GPS 7-18"
      end
    else
      print("{cc0000}ERROR 1:{b2b2b2}", str)
      return "ERROR"
    end
  
  elseif str:find("[Pp]rice%s7%s?%p%s?10") then
    if str:find("Любишь сладкое?") then
      return "Любишь сладкое? Тебе понравится наша кондитерская! Price 7-10"
    elseif str:find("Смакуй свой день") then 
      return "Смакуй свой день с «Десертами Angel Pine»! | Price 7-10"
    elseif str:find("отмерь") then
      return "7 раз отмерь, 1 раз отрежь - «Десерты Angel Pine». Price 7-10"
    end
  elseif str:find("%s?8%s?%p%s?147") then
    if str:find("Отведай удивительные") then
      return "Отведай удивительные космические десерты по GPS 8-147!"
    elseif str:find("Насладись вкусом вне") then
      return "Насладись вкусом вне земли прямо на земле по GPS 8-147!"
    elseif str:find("Заходи в кондитерскую") then
      return "Заходи в кондитерскую Fort Carson по GPS 8-147!"
    end

  elseif str:find("%s?8%s?%p%s?193") then --  
    if str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-193"
    end

    if str:find("Самые низкие цены на еду") then
      return "Самые низкие цены на еду в «Burger Shot №3» в LV | "..biz_loc
    elseif str:find("вкусные пончики") then
      return "Cамые вкусные пончики у нас | "..biz_loc
    end  
  elseif str:find("[Pp]rice%s7%s?%p%s?19") or str:find("%s?8%s?%p%s?195") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 7-19"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-195"
    end

    if str:find("Самый сладкий десерт") then
      return "Самый сладкий десерт только в «Сладости Las-Venturas». "..biz_loc
    elseif str:find("Кайфуй и ешь десерты") then
      return "Кайфуй и ешь десерты в «Сладости Las-Venturas» | "..biz_loc
    elseif str:find("Ешь и кайфуй") then
      return "Ешь и кайфуй в «Сладости Las-Venturas». | "..biz_loc
    elseif str:find("Глюкозы нехватка") then
      return "Глюкозы нехватка? У Лилки в магазе Pinkово как сладко! | "..biz_loc
    elseif str:find("Сытный белковый десерт") then
      return "Сытный белковый десерт только в «Сладости Las-Venturas». "..biz_loc
    elseif str:find("Шоколадка Lilka") then
      return "Шоколадка Lilka, батончик PinkyWay! Для родных и детей! "..biz_loc
    elseif str:find("Надоела диета") then
      return "Надоела диета? Хочешь мясистую попу? Сладости LV ждут! "..biz_loc
    elseif str:find("Самые сладкие булочки") then
      return "Самые сладкие булочки в «Сладости Las-Venturas». "..biz_loc
    elseif str:find("Порадуй свою булочку") then
      return "Порадуй свою булочку сладкими булочками по "..biz_loc
    elseif str:find("Погрузись в мир сладких") then
      return "Погрузись в мир сладких булочек в «Сладости LV». "..biz_loc
    elseif str:find("своей булочке сладкую булочку") then
      return "Купи своей булочке сладкую булочку в «Сладости LV». "..biz_loc
    elseif str:find("Шоколадные пончики") then
      return "Шоколадные пончики только в «Сладости LV». "..biz_loc
    elseif str:find("Шоколадные к[ур][ур]асаны") then
      return "Шоколадные круасаны только в «Сладости LV». "..biz_loc
    elseif str:find("вкусные пончики") then
      return "Самые вкусные пончики у нас | Price 7-19"
    end
  elseif str:find("[Pp]rice%s7%s?%p%s?1111111") or str:find("%s?8%s?%p%s?25") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 7-19"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-25"
    end

    if str:find("Утоли голод") then
      return "Утоли голод в «Магазине сладостей ЛС» - Десерты от 695$. "..biz_loc

    end

  elseif str:find("[Pp]rice%p?%s?3%s?%p%s?54") then
    if str:find("Лучшие напитки и закуски %s?в Кафе") then
      return "Лучшие напитки и закуски в Кафе-Бар «Черника». | Price 3-54"
    elseif str:find("Еще по одной") then
      return "Еще по одной? Кафе-бар «Черника». Мы работаем 24/7 | Price 3-54"
    elseif str:find("Субботние скидки") then
      return "Субботние скидки в Баре «Черника». Работаем 24/7. | Price 3-54"
    elseif str:find("Черная пятница") then
      return "Черная пятница! Кафе-Бар «Черника»! Мы за заводом! | Price 3-54"
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?2$") then
    if str:find("Заходите к нам на ланч") then
      return "Заходите к нам на ланч в «Ресторан» ш. Los Santos. | Price 2-2"
    elseif str:find("Изысканные ланчи только") then
      return "Изысканные ланчи только у нас в «Ресторане Los Santos» | Price 2-2"
    elseif str:find("Лучшие ланчи только") then
      return "Лучшие ланчи только у нас в «Ресторане Los Santos» | Price 2-2"
    end

  elseif str:find("[Pp]rice%p?%s?16%s?%p?%s?2$") then
    if str:find("Хочешь стать клоуном") then
      return "Хочешь стать клоуном? Купи у нас форму для веселья! | Price 16-2"
    elseif str:find("Хочешь весело провести") then
      return "Хочешь весело провести время? Тебе в развл. центр! | Price 16-2"
    elseif str:find("Хочешь заразить участок") then
      return "Хочешь заразить участок друга? Тебе в РЦ «Игра»! | Price 16-2"
    elseif str:find("Зелья по скидке ты") then
      return "Зелья по скидке ты найдешь в ценре развлечений «Игра». Price 16-2"
    elseif str:find("Любой костюм на выбор") then
      return "Любой костюм на выбор за 1000$ в центре развлечений. Price 16-2"
    end
  elseif str:find("[Pp]rice%p?%s?16%s?%p%s?3$") then
    if str:find("Стань Пугачевой в Развлекательном") then
      return "Стань Пугачевой в Развлекательном центре «Отдых». | Price 16-3"
    end

  elseif str:find("[Pp]rice%p?%s?16%s?%p%s?4$") then
    if str:find("Познай чудо преображения") then
      return "Познай чудо преображения в Развлекательном центре LS | Price 16-4"
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?17")  or str:find("%s?8%s?%p%s?105") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 2-17"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-105"
    end
    if str:find("ткрылась центральная закусочная") then
      return "Открылась центральная закусочная в ш. San Fierro. | "..biz_loc
    elseif str:find("ерекуси в центральной") then
      return "Перекуси в центральной закусочной San Fierro. | "..biz_loc
    elseif str:find("Закуски по 90") then
      return "Закуски по 90$ и хорошее вино в ресторане «Сан-Фиеро». "..biz_loc
    elseif str:find("Удиви даму сердца дорогим") then
      return "Удиви даму сердца дорогим вином ресторана «Сан-Фиеро». "..biz_loc
    elseif str:find("Широкий выбор изысканных") then
      return "Широкий выбор изысканных блюд, в ресторане «Сан-Фиеро». "..biz_loc
    elseif str:find("кулинарный шедевр") then
      return "Каждое блюдо - кулинарный шедевр! Ресторан «Сан-Фиеро». "..biz_loc
    elseif str:find("Не знаешь где провести") then
      return "Не знаешь где провести вечер? Ресторан «Сан-Фиеро». "..biz_loc
    elseif str:find("Фирменное блюдо от шефа") then
      return "Фирменное блюдо от шефа, только в ресторане «Сан-Фиеро» "..biz_loc
    elseif str:find("Идеальное сочетание комф") then
      return "Идеальное сочетание комфорта и стиля. Ресторан «СФ» "..biz_loc
    elseif str:find("Идеальное сочетание ую") then
      return "Идеальное сочетание уюта и стиля. Ресторан «СФ» "..biz_loc
    elseif str:find("Сомелье рекомендуют") then
      return "Сомелье рекомендуют! Винный сет в ресторане Сан-Фиерро "..biz_loc
    elseif str:find("Забронируй столик прямо сейчас") then
      return "Забронируй столик прямо сейчас! Ресторан Сан-Фиерро "..biz_loc
    elseif str:find("Приятная музыка и уютная") then
      return "Приятная музыка и уютная атмосфера в «Ресторане СФ» | "..biz_loc
    elseif str:find("Приятная музыка и уютный") then
      return "Приятная музыка и уютный дизайн в «Ресторане СФ» | "..biz_loc
    elseif str:find("Эксклюзивная барная") then
      return "Эксклюзивная барная карта в «Ресторане СФ» | "..biz_loc
    elseif str:find("Насладитесь коллекцией вин") then
      return "Насладитесь коллекцией вин в «Ресторане СФ» | "..biz_loc
    elseif str:find("Сочные блюда") then
      return "Сочные блюда от Шефа ждут вас в «Ресторане СФ» | "..biz_loc
    elseif str:find("Идеальный вечер") then
      return "Идеальный вечер в уютном «Ресторане Сан-Фиерро» | "..biz_loc
    elseif str:find("Не пропустите") then
      return "Не пропустите фирм. блюдо в «Ресторане Сан-Фиерро» | "..biz_loc
    elseif str:find("идеальное место") then
      return "Ресторан Сан-Фиерро» – идеальное место для встреч! "..biz_loc
    elseif str:find("для себя гастрономию") then
      return "Откройте для себя гастрономию в «Ресторане Сан-Фиерро»! "..biz_loc
    elseif str:find("всего за") then
      return "Фирменное блюдо в «Ресторане Сан-Фиерро» всего за 300$! "..biz_loc
    elseif str:find("ужин ждет вас") then
      return "Романтический ужин ждет вас в «Ресторане Сан-Фиерро»! "..biz_loc
    elseif str:find("Уютные вечера") then
      return "Уютные вечера и нежные блюда в «Ресторане Сан-Фиерро» "..biz_loc

    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?18") then
    if str:find("Вкус, который пленит") then
      return "Вкус, который пленит - наш ресторан «San Fierro»! | Price 2-18"
    elseif str:find("Проведи романтическое свидание") then
      return "Проведи романтическое свидание в ресторане «Сан-Фиеро» Price 2-18"
    elseif str:find("Закуски по 90") then
      return "Закуски по 90$ и хорошее вино в ресторане «Сан-Фиеро». Price 2-18"
    elseif str:find("Удиви даму сердца дорогим") then
      return "Удиви даму сердца дорогим вином ресторана «Сан-Фиеро». Price 2-18"
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?25") then
    if str:find("Вкусная куриная ножка") then
      return "Вкусная куриная ножка в «Закусочной Fort Carson»! | Price 2-25"
    end

  elseif str:find("[Pp]rice%p?%s?555%s?%p%s?11") or str:find("%s?8%s?%p%s?74") then
    if str:find("[Pp]rice333") then
      biz_loc = "Price 255-11"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-74"
    end
    if str:find("Жена пилит мозги") then
      return "Жена пилит мозги? Негде отдохнуть? Ждем тебя в баре по "..biz_loc
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?11") or str:find("%s?8%s?%p%s?75") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 2-11"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-75"
    end
    if str:find("Приезжай в нашу закусочную") then
      return "Приезжай в нашу закусочную. Вкусная еда и низкие цены! "..biz_loc
    elseif str:find("Приходи в наше кафе") then
      return "Приходи в наше кафе «El Gran Burrito». Цены от 300$. "..biz_loc
    elseif str:find("Вкусная еда и низкие цены") then
      return "Вкусная еда и низкие цены в кафе «El Gran Burrito». "..biz_loc
    elseif str:find("Голоден%p Не беда") then
      return "Голоден? Не беда! «Закусочная в гетто» накормит тебя. "..biz_loc
    end
    
  elseif str:find("%s?8%s?%p%s?42") then --str:find("[Pp]rice%p?%s?2%s?%p%s?11")
    if str:find("[Pp]rice") then
      biz_loc = "Price 2-11"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-42"
    end
    if str:find("Хочешь быть как Григорий Лепс") then
      return "Хочешь быть как Григорий Лепс? Тебе в РЦ «Забава». "..biz_loc
    elseif str:find("Хочешь модный наряд") then
      return "Хочешь модный наряд? Тебе в РЦ «Забава» за БЛС | "..biz_loc
    elseif str:find("Самые выгодные цены") then
      return "Самые выгодные цены в РЦ «Забава» за БЛС | "..biz_loc
    elseif str:find("[Пп]родам") then
      if str:find("GPS") then
        return "Продам бизнес РЦ «Забава» по GPS 8-42. "..get_price(str, trade_type(str))
      end
      return "Продам РЦ «Забава» в ш. Los Santos. "..get_price(str, trade_type(str))
    end
  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?19") or str:find("PRICE%p2%p19%p") then
    if str:find("организм отменными блюдами") then
      return "Урчит живот? Порадуй свой организм отменными блюдами! Price 2-19"
    elseif str:find("Самые дешевые бургеры") then
      return "Дешевые бургеры в «Закусочная Burger Shot СФ №1»! Price 2-19"
    elseif str:find("Вкусный бургер") then
      return "Вкусный бургер в «Burger Shot SF №1»! | Price 2-19"
    elseif str:find("Сочный бургер") then
      return "Сочный бургер в «Burger Shot SF №1»! | Price 2-19"
    elseif str:find("Самые сочные бургеры") then
      return "Самые сочные бургеры в «Burger Shot SF №1»! | Price 2-19"
    elseif str:find("Самые вкусные [ис] сочные") then
      return "Самые вкусные и сочные бургеры в «Burger Shot SF №1» | Price 2-19"
    end
  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?34") then
    if str:find("Смешные цены на еду") then
      return "Смешные цены на еду в честь открытия BurgerShot LV №3. Price 2-34"
    end
  elseif str:find("Price 2 %p Закусочная в гетто") or str:find("[Pp]rice%p?%s?2%p?$") and str:find("[Ee]ast [Ll][Ss]") then
    if str:find("Самые низкие цены только в нашей") then
      return "Самые низкие цены в нашей закусочной в р. East LS. Price 2-9"
    elseif str:find("Самые низкие цены на еду") then
      return "Самые низкие цены на еду. Район East LS. Price 2-9"
    end
  elseif str:find("[Pp]rice%p?%s?3%s?%p%s?2") or str:find("%s?8%s?%p%s?4[(%p)|($)|(%s)]") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 3-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-4"
    end
    if str:find("Лучшие закуски в") then
      return "Лучшие закуски в Баре «10 Зеленых бутылок» р. Ganton! | "..biz_loc
    elseif str:find("Отдохни в легендарном баре") then 
      return "Отдохни в легендарном баре «10 зеленых бутылок». "..biz_loc
    elseif str:find("Легендарный бар") then 
      return "Легендарный бар «10 зеленых бутылок» вновь открыт! | "..biz_loc
    elseif str:find("Вкусная шаурма") then 
      return "Вкусная шаурма в баре «10 зелёных бутылок»! | "..biz_loc
    elseif str:find("для рывка") then 
      return "Выпей пивка - для рывка! Бар «10 Бутылок» | "..biz_loc.." | Ждём!"
    elseif str:find("Открой сезон пива") then 
      return "Открой сезон пива! Бар «10 Бутылок» | "..biz_loc.." | Ждём!"
    elseif str:find("У жажды нет шансов") then 
      return "У жажды нет шансов! Бар «10 Бутылок» | "..biz_loc.." | Ждём!"
    elseif str:find("Бар Большой %p всегда с душой") then 
      return "Бар большой - всегда с душой! Бар «10 Бутылок» | "..biz_loc.." | Ждём!"
    elseif str:find("Cуперменю для супертебя") then 
      return "Cуперменю для супертебя! Бар «10 Бутылок» | "..biz_loc.." | Ждём!"
    elseif str:find("получи леща") then 
      return "Выпей пива - получи леща от жены! Бар «10 Бутылок» | "..biz_loc
    end
    
  elseif str:find("[Pp]rice%p?%s?7%s?%p%s?1%p?$") or str:find("%s?8%s?%p%s?9$") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 7-1"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-9"
    end
    
    if str:find("вкусные сладости в кондит") then
      return "Самые вкусные сладости в кондитерской «Пончик» | "..biz_loc
    elseif str:find("вкусный пончик в") then
      return "Купи вкусный пончик в «Пончике» | "..biz_loc
    elseif str:find("хрустящая глазурь") then
      return "«Мягкое тесто, хрустящая глазурь» - в «Пончик ЛС» | "..biz_loc
    elseif str:find("интерферончик") then
      return "«Скушай пончик - получи интерферончик» - в «Пончик ЛС». | "..biz_loc
    elseif str:find("дешевые сладости в") then
      return "Самые дешевые сладости в «Пончике» за больницей ш. LS | "..biz_loc
    elseif str:find("Пончики с белой начинкой") then
      return "Пончики с белой начинкой в ш. Los Santos | "..biz_loc
    elseif str:find("Пончики с шоколадной начинкой") then
      return "Пончики с шоколадной начинкой в ш. Los Santos | "..biz_loc
    elseif str:find("Возьми пончик другу") then
      return "Возьми пончик другу, найдёшь одинокую подругу за БЛС | "..biz_loc
    elseif str:find("Перекуси в [кК]ондитерской") then
      return "Перекуси в кондитерской «Пончик» за больницей LS | "..biz_loc
    end
  
  
  elseif str:find("[Pp]rice%s12%s?%p%s?2") then
    if str:find("Самые красивые") then
      return "Самые красивые фейерверки на «Огненное небо»! | Price 12-2"
    end
  elseif str:find("[Pp]rice%s12%s?%p%s?5") then
    if str:find("ВЗРЫВ ЭМОЦИЙ") then
      return "Магазин «ВЗРЫВ ЭМОЦИЙ» - приди и взорви! | Мы здесь: Price 12-5"
    end
  elseif str:find("[Pp]rice%p?%s12%s?%p%s?6") then
    if str:find("Прода[мю]") then
      return "Продам пиротехнику «Северное сияние» в LV. "..get_price(str, trade_type(str))
  
    elseif str:find("Самые яркие фейверки") then
      return "Самые яркие фейверки в «Северном сиянии». | Мы в Price 12-6"
    elseif str:find("под знаком качества") then
      return "Пиротехника «Северное сияние» под знаком качества. | Price 12-6"
    elseif str:find("Самые низкие цены") then
      return "Самые низкие цены в Пиротехнике «Северное сияние». | Price 12-6"
    end
  elseif str:find("[Pp]rice%s5%s?%p%s?3%s?%p%s?3") then
    if str:find("Топовый лук в магазине") then
      return "Топовый лук в магазине одежды «Didier-Sachs» | Мы в Price 5-3-3"
    end
    
  elseif str:find("GPS%p?%s?7%s?%p%s?3") then
    if str:find("Курочка KFC") then
      return "Курочка KFC в «Cluckin Bell ЛС №2» в Ghetto! Мы напротив GPS: 7-3"
    elseif str:find("Низкие цены и бесплатный") then
      return "Низкие цены и бесплатный вход в Cluckin Bell №2. Напротив GPS 7-3"
    elseif str:find("Мед. помощь в Cluckin") then
      return "Мед. помощь в Cluckin Bell №2 в опасном районе.  Напротив GPS 7-3"
    elseif str:find("Красивые официантки") then
      return "Красивые официантки в Cluckin Bell №2 в опасном районе. У GPS 7-3"
      
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?162") then
    if str:find("Обновите гардероб в магазине") then
      return "Обновите гардероб в магазине одежды «Binco» у БЛВ. | GPS 8-162"
    elseif str:find("Стильная одежда") then
      return "Стильная одежда от 7.000$ в магазине «Binco» у БЛВ. | GPS 8-162"
    elseif str:find("Лучшая и оригинальная") then
      return "Лучшая и оригинальная одежда в «Binco» у Больницы LV | GPS 8-162"
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?45") then
    if str:find("вибор блюд в ресторане") then
      return "Шикарный выбор блюд в ресторане на Алее звёзд в LS | GPS 8-45"
    elseif str:find("Стильная одежда") then
      return "Стильная одежда от 7.000$ в магазине «Binco» у БЛВ. | GPS 8-162"
    end
  elseif str:find("[Бб]ургеры") and str:find("%p?%s?8%s?%p%s?163") then
    if str:find("Лучшие бургеры") then
      return "Лучшие бургеры Федерации в «Burger Shot ЛВ №1» | GPS 8-163"
    end
  elseif str:find("[Gg][Pp][Ss]%p?%s?8%s?%p%s?16%p?$") or str:find("[Gg][Pp][Ss]%s8%s16%p?$") then
    if str:find("Будешь сыт и смел") then
      return "Будешь сыт и смел, пообедав в «Ресторане Лос-Сантос» | GPS 8-16"
    elseif str:find("Тут интересно и вкусно") then
      return "Посети «Ресторан Лос-Сантос». Тут интересно и вкусно! | GPS 8-16"
    elseif str:find("ый винный сет") then
      return "Купи дегустационный винный сет в «Ресторане Лос-Сантос»! GPS 8-16"
    elseif str:find("обуй винный сет") then
      return "Попробуй винный сет в «Ресторане Лос-Сантос»! GPS 8-16"
    elseif str:find("обуй дорогой винный сет") then
      return "Попробуй дорогой винный сет в «Ресторане Лос-Сантос»! GPS 8-16"
    elseif str:find("Попробуй элитный алкоголь") then
      return "Попробуй элитный алкоголь в «Ресторане Лос-Сантос». | GPS 8-16"
    elseif str:find("Romanee Conti") then
      return "Захотелось бутылочки Romanee Conti 1945 года? Она у нас! GPS 8-16"
    elseif str:find("хорошая музыка в Ресторане") then
      return "Уютная атмосфера, хорошая музыка в Ресторане Лос-Сантос! GPS 8-16"
    elseif str:find("Хочешь не дорого поесть") then
      return "Хочешь не дорого поесть? Тебе в «Ресторан» за мэрией LS! GPS 8-16"
    elseif str:find("Лучшие ланчи у нас") then
      return "Лучшие ланчи у нас в «Ресторане» за мэрией ш.Los Santos! GPS 8-16"
    elseif str:find("[Пп]рода") then
      return "Продам бизнес «Ресторан» за мэрией ш. Los Santos. "..get_price(str, trade_type(str))
    end

    
  elseif str:find("GPS%p?%s?8%s?%p%s?44") then
    if str:find("риелторском агенстве 1 свободный") then
      return "В «Риелторском агенстве» свободные дома от 525.000$ | GPS 8-44"
    end
  elseif str:find("%p?%s?3%s?%p%s?16") then
    if str:find("Вкусные закуски") then
      return "Вкусные закуски в «Закусочной Cluckin Bell SF». Мы у gps 3-16."
    end
  elseif str:find("GPS%p?%s?2%s?%p%s?10") then
    if str:find("ты скоро дома") then
      return "«Прокат у Космодрома» - ты скоро дома! | Рядом с GPS 2-10"
    elseif str:find("самые дешёвые автомобили") then
      return "В «Прокате у Космодрома» самые дешёвые автомобили! | GPS 2-10"
    elseif str:find("Сделали аренду дешевле") then
      return "Сделали аренду дешевле - «Прокат у Космодрома»! | GPS 2-10"
    elseif str:find("Faggio за") then
      return "«Прокат у Космодрома» - Faggio за 4.999$! | GPS 2-10"
    elseif str:find("и кайфуй") then
      return "Возьми «Faggio» и кайфуй, в «Прокат у Космодрома» | GPS 2-10"
    end
    
  elseif str:find("GPS%p?%s?8%s?%p%s?258") then
    if str:find("Дешевая аренда авто только в прокате") then
      return "Дешевая аренда авто только в прокате у Больницы LV. | GPS 8-258"
    elseif str:find("Доступные цены в прокате авто") then
      return "Доступные цены в прокате авто у Больницы LV! | GPS 8-258"
    end
  elseif str:find("наруж") and str:find("LV") then
    return "Услуги наружной рекламы в «Рекламном агентстве» ш. LV | GPS 8-234"
  elseif str:find("GPS%p?%s?1%s?%p%s?4") or str:find("%pПиццерии%p возле Мерии LV") then
    if str:find("Отведай пиццу в") then
      return "Отведай пиццу в «Пиццерии у Мэрии LV». | Мы около GPS: 1-4"
    elseif str:find("Самые девшевые прод[ук][ук]ты") then
      return "Самые девшевые продукты в «Пиццерии» возле Мерии LV. Ждем Вас!"
    end
  elseif str:find("Лучшие кондитерские изделия") and str:find("[Мм]эрии [ЛлLl][СсSs]") then
    return "Лучшие кондитерские изделия в кондитерской у Мэрии LS. Ждем вас!"

  --===========================
  elseif str:find("Низкокалорийные") then 
    return "Низкокалорийные десерты в «Магазине Сладостей LS» | Price 7-3"
  elseif str:find("[Pp]rice%s7%s?%p%s?3") then
    if str:find("рай сластен") then
      return "В «Магазине сладостей LS» рай сластен, вкус на любой вкус! Price 7-3"
    end
  --===========================

  elseif str:find("[Пп]иц") and str:find("%s?8%s?%p%s?196") then 
    return "Самая дешевая пицца в «Пиццерии» у Мэрии Los Santos. | Мы в GPS 8-196"
  elseif str:find("[Bb]ell") and str:find("%s?8%s?%p%s?173") then 
    if str:find("Лучшая жирная") then
      return "Лучшая жирная курица в «Clukin Bell №1» в LV. Напротив GPS 8-173"
    elseif str:find("Жиренькая курочка") then
      return "Жиренькая курочка в Clukin Bell №1 в LV. Напротив GPS 8-173"
    end

  elseif str:find("[Pp]rice%s?3%p53") then 
    if str:find("Лучший клуб") then
      return "Лучший клуб «Last Drop» в д. Montgomery. | Мы в Price 3-53"
    end

  elseif str:find("скучно и од[и]?ноко") and str:find("%s?8%s?%p%s?102") then 
    return "Скучно и одиноко? Тебе к нам! | GPS 8-102"
  elseif str:find("[Пп]рибрежный клуб") and str:find("%s?8%s?%p%s?35") then 
    return "«Прибрежный клуб» Los Santos пргиглашает всех желающих | GPS 8-35"
  elseif str:find("%s?8%s?%p%s?24%p?$") then 
    if str:find("Топ аксессуары") then
      return "Топ аксессуары по минимальным ценам в салоне Президент | GPS 8-24"
    elseif str:find("Эксклюзивные аксессуары") then
      return "Эксклюз. аксессуары по низким ценам в салоне Президент | GPS 8-24"
    elseif str:find("Широкий выбор аксессуаров") then
      return "Широкий выбор аксессуаров по низким ценам в салоне Президент. GPS 8-24"

    elseif str:find("Купить аксессуар %pЖилетка%p") then
      return "Купить аксессуар «Жилетка» можно только в салоне у АП | GPS 8-24"
    elseif str:find("Купить аксессуар %pЧасы%p") then
      return "Купить аксессуар «Часы» можно только в салоне у АП | GPS 8-24"
    elseif str:find("завезли новые товары") then
      return "В Парикмахерскую «Президент» завезли новые товары. Мы в GPS 8-24."
    elseif str:find("[Пп]родам") then
      return "Продам парикмахерскую у администр. президента LS. "..get_price(str, trade_type(str))
    end  
  elseif str:find("%s?8%s?%p%s?60%p?$") then 
    if str:find("Лучшие аксессуары") then
      return "Лучшие аксессуары у нас - «Восточная парикмахерская» | GPS 8-60"
    elseif str:find("Эксклюзивные аксессуары") then
      return " | GPS 8-60"

    end  

  elseif str:find("[Pp]rice%p? 4%p5") or str:find("[Pp]rice%p? 4%p1%p5") or str:find("[Пп]арик") and str:find("%s?8%s?%p%s?50") or str:find("%s?8%s?%p%s?51") then 
    if str:find("%s?8%s?%p%s?50") then
      biz_loc = "Мы у GPS 8-50"
    elseif str:find("%s?8%s?%p%s?51") then
      biz_loc = "GPS 8-51"
    elseif str:find("%s?4%s?%p%s?5") then
      biz_loc = "Price 4-5"
    elseif str:find("%s?4%s?%p%s?1%s?%p%s?5") then
      biz_loc = "Price 4-1-5"
    end
    if str:find("Заходите") then
      return "Заходите в парикмахерскую «Головорез». | "..biz_loc
    elseif str:find("завели маски кроша") then
      return "В парикмахерскую «Головорез» завели маски кроша. "..biz_loc
    elseif str:find("парикмахерскую завезли") then
      return "В парикмахерскую завезли «Сигары» | "..biz_loc
    elseif str:find("Стань стильным вместе") then
      return "Стань стильным вместе с парикмахерской «Головорез» | "..biz_loc
    elseif str:find("Эксклюзивные аксессуары только") then
      return "Эксклюзивные аксессуары в парикмахерской «Головорез» | "..biz_loc
    elseif str:find("Стань самым модным на районе") then
      return "Стань самым модным на районе с парикмах. «Головорез» | "..biz_loc
    elseif str:find("Топовые аксессуары только") then
      return "Топовые аксессуары только в парикмахерской «Головорез» | "..biz_loc
    elseif str:find("Маска CJ") then
      return "Купить аксессуар «Маска CJ» можно в салоне «Головорез» | "..biz_loc
    elseif str:find("Пугай всех своими") then
      return "Пугай всех своими «Крыльями дьявола» из «Головореза» | "..biz_loc
    elseif str:find("Экзоскелет") then
      return "Купить себе «Экзоскелет» можно только в «Головорезе» | "..biz_loc
    elseif str:find("Маска черта") then
      return "Топ аксессуар «Маска черта» только в «Головорезе» | "..biz_loc
    elseif str:find("Дешёвые аксессуары в парикмахерской") then
      return "Дешёвые аксессуары в парикмахерской «Головорез».  | "..biz_loc
    elseif str:find("Лучшие цены в Парикмахерской") then
      return "Лучшие цены в парикмах. «Головорез» в опасном районе  | "..biz_loc
    elseif str:find("Аксессуары от 3000") then
      return "Аксессуары от 3000$ в Парикмахерской «Головорез»! | "..biz_loc
    elseif str:find("Редкие аксессуары только") then
      return "Редкие аксессуары только в парикмахерской «Головорез»! | "..biz_loc
    elseif str:find("Новые акссесуары в") then
      return "Новые акссесуары в парикмахерской  «Головорез»! | "..biz_loc
    elseif str:find("Снизили цены на аксессуары") then
      return "Снизили цены на аксессуары! Спеши к нам! | "..biz_loc
    elseif str:find("Экзоскелет и любые маски") then
      return "Экзоскелет и любые маски по низким ценам! | "..biz_loc
    elseif str:find("[Пп]родам") then
      return "Продам парикмах. «Головорез» в опасном районе. "..get_price(str, trade_type(str))
    end -- Аксессуары от 3000$ в Парикмахерской "Головорез"! Price: 4-1-5!
  
  elseif str:find("[Pp]rice%s?4%s?%p%s?13") then 
    if str:find("%s?4%s?%p%s?13") then
      biz_loc = "Price 4-13"
    end
    if str:find("Fort Carson низкие цены") then
      return "Салон «Деревенский стиль» в Fort Carson - низкие цены. "..biz_loc
    end
  elseif str:find("[Pp]rice%p?%s?4%s?%p%s?1%s?%p%s?10") then 
    if str:find("%s?4%s?%p%s?1%s?%p%s?10") then
      biz_loc = "Price 4-1-10"
    end
    if str:find("Смени имидж") then
      return "Смени имидж в «Парикмахерской El Quebrados» | "..biz_loc
    end
  
  elseif str:find("[Pp]rice%p?%s?4%s?%p%s?16") or str:find("GPS%p?%s?6%s?%p%s?3") and not str:find("[Бб]анк") then 

    if str:find("%s?4%s?%p%s?16") then
      biz_loc = "Price 4-16"
    else
      biz_loc = "Мы у GPS 6-3"
    end
    if str:find("Лучшие цены на аксессуары в салоне") then
      return "Лучшие цены на аксессуары в салоне «Little Lady». "..biz_loc
    elseif str:find("Измени свой прикид") then
      return "Измени свой прикид в салоне красоты «Little Lady». "..biz_loc
    end
    --Price 4 > 1 > 3.
    
  elseif str:find("[Pp]rice%s?4%s?%p%s?1%s?%p%s?5")  then 
    if str:find("%s?8%s?%p%s?50") then
      biz_loc = "Мы у GPS 8-50"
    elseif str:find("%s?8%s?%p%s?51") then
      biz_loc = "GPS 8-51"
    elseif str:find("rice%s?4%s?%p%s?1%s?%p%s?5") then
      biz_loc = "Price 4-1-5"
    end
    if str:find("в салон красоты %p[Сс]тиль") then
      return "В салон красоты «Стиль» завезли «Жилетку». | "..biz_loc
    elseif str:find("завели маски кроша") then
      return "В парикмахерскую «Головорез» завели маски кроша. "..biz_loc
    end
    
  elseif str:find("[Pp]rice%s?4%s?%p%s?4%s?%p%s?3") then
    if str:find("rice%s?4%s?%p%s?4%s?%p%s?3") then
      biz_loc = "Price 4-4-3"
    end
    if str:find("Купи портфель") then
      return "Купи портфель на 1 сентября в салоне красоты «Стиль». "..biz_loc
    elseif str:find("Купи парик") then
      return "Лысеешь? Купи парик в салоне красоты «Стиль» | "..biz_loc
    elseif str:find("Праздничные аксессуары") then
      return "Праздничные аксессуары в салоне красоты «Стиль» | "..biz_loc
    elseif str:find("Праздничные скидки в салоне") then
      return "Праздничные скидки в салоне красоты «Стиль» | "..biz_loc
    elseif str:find("Лучшие аксессуары в ") then
      return "Лучшие аксессуары в салоне красоты «Стиль» | "..biz_loc
    elseif str:find("Будь стильным вместе") then
      return "Будь стильным вместе с салоном красоты «Стиль» | "..biz_loc
    elseif str:find("Большие скидки") then
      return "Большие скидки в салоне красоты «Стиль» | "..biz_loc
    end
  elseif str:find("[Pp]rice%s?4%s?%p%s?1%s?%p%s?3") or str:find("%s?8%s?%p%s?30") then 
    if str:find("%s?%p?8%s?%p%s?30") then
      biz_loc = "GPS 8-30"
    elseif str:find("rice%s?4%s?%p%s?1%s?%p%s?3") then
      biz_loc = "Price 4-1-3"
    end
    if str:find("в салон красоты %p[Сс]тиль") then
      return "В салон красоты «Стиль» завезли «Жилетку» | "..biz_loc
    elseif str:find("Купи крутые усы") then
      return "Купи крутые усы в парикмахерской «Стиль» | "..biz_loc
    elseif str:find("Будь крутым ковбоем") then
      return "Будь крутым ковбоем, купи шляпу в салоне «Стиль». "..biz_loc
    elseif str:find("Измени стиль в магазине") then
      return "Измени стиль в магазине «Стиль» | "..biz_loc
    end
  elseif str:find("%s?8%s?%p%s?129") then 
    if str:find("%s?%p?8%s?%p%s?129") then
      biz_loc = "GPS 8-129"
    elseif str:find("rice%s?4%s?%p%s?1%s?%p%s?3") then
      biz_loc = ""
    end
    if str:find("Выгодные цены") then
      return "Выгодные цены в нашем салоне красоты | "..biz_loc
    end
  elseif str:find("%s?8%s?%p%s?240") then
    if str:find("Обнови интерьер дома у нас") then
      return "Обнови интерьер дома у нас! Всем скидки! | GPS 8-240"
    elseif str:find("Сделай себе ремонт") then
      return "Сделай себе ремонт! Купи стройматериалы у нас! | GPS 8-240"
    elseif str:find("Хватит жить в развалинах") then
      return "Хватит жить в развалинах! Сделай ремонт со скидкой! | GPS 8-240"
    end  

  elseif str:find("[Сс]тройматер") and str:find("%s?8%s?%p%s?242") then
    if str:find("В стройматер[еИ]ал[ыа][х]? [бп]ыло понижение цен") then
      return "В «Стройматериалах LV» понижение цен. Убедитесь сами. GPS 8-242"
    end  

  elseif str:find("[Сс]тройматер") and str:find("%s?1%s?%p%s?20") or str:find("[Pp]rice%p?%s?18%p2%p1") then -- or str:find("%s?8%p241") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 18-2-1"
    elseif str:find("[Gg][Pp][Ss]") then
      if str:find("241") then
        biz_loc = "Price 18-2-1"
      end
    end
    if str:find("Выгодные цены в ") then
      return "Выгодные цены в «Стройматериалах Los Santos». "..biz_loc
    elseif str:find("качественные м[еа]териали") then
      return "Покупай лучшие материалы в «Стройматериалах LS». "..biz_loc
    elseif str:find("Выгодно и качественно") then
      return "Выгодно и качественно — «Стройматериалы ЛС»! "..biz_loc
    end  

  elseif str:find("[Сс]тройма[т]?ер") and str:find("%s?1%s?%p%s?20") or str:find("[Pp]rice%p?%s?18%p2%p2") or str:find("%s?8%p241") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 18-2-2"
    elseif str:find("[Gg][Pp][Ss]") then
      if str:find("241") then
        biz_loc = "GPS 8-241"
      else
        biz_loc = "Мы у GPS 1-20"
      end
    end
    if str:find("Распродажа в Стройматериалах") then
      return "Распродажа в «Стройматериалах» San Fierro. "..biz_loc
    elseif str:find("Низкие цены для ремонта") then
      return "Низкие цены для ремонта в «Стройматериалах» SF. "..biz_loc
    elseif str:find("Очень дёшево, вход") then
      return "Очень дёшево, вход - 0$. В «Стройматериалах» SF. "..biz_loc
    elseif str:find("Обнови интерьер дома") then
      return "Обнови интерьер дома в «Cтройматериалах» SF! | "..biz_loc
    elseif str:find("Сделай шикарный ремонт") then
      return "Сделай шикарный ремонт в «Стройматериалах» SF! | "..biz_loc
    elseif str:find("ash") then
      return "Оформи «Cash-Back» в «Стройматериалах SF» | "..biz_loc
    elseif str:find("Хочешь красивый дом") then
      return "Хочешь красивый дом? Сделай его в «Стройматериалах SF»! "..biz_loc
    elseif str:find("сделай дворец своими") then
      return "«Стройматериалы SF» - сделай дворец своими руками! | "..biz_loc
    elseif str:find("Построй дом мечты") then
      return "Построй дом мечты в «Стройматериалах СФ». | "..biz_loc
    elseif str:find("Сияй в сво[её]м") then
      return "Сияй в своём новом доме со «Стройматериалами СФ» | "..biz_loc
    end  

  elseif str:find("[Мм]ебель") and str:find("%s?8%s?%p%s?239") or str:find("%s?1%s?%p%s?21") then
    if str:find("239") then
      biz_loc = "GPS 8-239"
    else
      biz_loc = "GPS 1-21"
    end
    if str:find("Лучшая мебель в [Мм]ебельном") then
      return "Лучшая мебель в «Мебельном салоне LV»! "..biz_loc
    elseif str:find("Самые низкие цены на") then
      return "Самые низкие цены на все товары в Мебельном салоне ЛВ. "..biz_loc
    elseif str:find("Минимальные цены на весь") then
      return "Минимальные цены на весь товар в Мебельном салоне ЛВ. "..biz_loc
    elseif str:find("Обустрой дом своей") then
      return "Обустрой дом своей мечты с «Мебельным салоном ЛВ» | "..biz_loc
    end  

  
  elseif str:find("[Сс]алон[е]? [Сс]антехники") and str:find("%s?8%s?%p%s?50") or str:find("%s?8%s?%p%s?243") or str:find("%s?18%p3%p1") or str:find("GPS%p Порт LS") then 
    if str:find("Золотые туалеты и прочее") then
      return "Золотые туалеты и прочее, в «Салоне сантехники» ш. LS! GPS: 8-243"
    elseif str:find("[Уу]крась свою ванну") then
      return "Укрась свою ванную команту в «Салоне сантехники LS» | GPS 8-243"
    elseif str:find("Купи ванну из черного") then
      return "Купи ванну из черного мрамора в «Сантехнике LS» | GPS 8-243"
    elseif str:find("Работаем без наценки") then
      return "Работаем без наценки в «Салоне сантехники LS» | GPS 8-243"
    elseif str:find("Мрамор или золото") then
      return "Мрамор или золото? Большой выбор в «Cантехникe LS» | GPS 8-243"
    elseif str:find("Принеси удачу в дом") then
      return "Принеси удачу в дом! Статуи в «Cантехникe LS» | GPS 8-243"
    elseif str:find("Хочешь [Зз]олотой [Тт]уалет") then
      return "Хочешь золотой туалет? Тебе в «Салон Сантехники LS». Price 18-3-1"
    elseif str:find("Хочешь [Зз]олотой [Уу]нитаз") then
      return "Хочешь золотой унитаз? Тебе в «Салон Сантехники LS». Price 18-3-1"
    elseif str:find("Хочешь [Зз]олотой [Сс]анузел") then
      return "Хочешь золотой санузел? Ждем тебя: «Сантехника LS» | Price 18-3-1"
    elseif str:find("Купи золотой унитаз") then
      return "Купи золотой унитаз в «Сантехнике LS» | Price 18-3-1"
    elseif str:find("лучшее для вашего комфорта") then
      return "Магазин сантехники - лучшее для вашего комфорта! | GPS: Порт LS."
    end

    
    
  elseif str:find("[Pp]rice%s?18%p3%p2") or str:find("%s?8%s?%p%s?244") or str:find("[Сс]антехник[ае]") and str:find("SF") or str:find("[Сс]ан [Фф]иерро") then 
    if str:find("[Сс]делай ремонт") then
      return "Купил дом? Сделай ремонт! Сантехника SF ждет Вас! | GPS 8-244"
    elseif str:find("золотой унитаз") then
      return "Хочешь себе золотой унитаз? Тогда тебе к нам! | GPS 8-244"
    elseif str:find("завезли новы[йе] товар") then
      return "В «Салон сантехники СФ» завезли новый товар! Успейте! | GPS 8-244"
    elseif str:find("сегодня большие скидки") then
      return "В «Салоне сантехники СФ» сегодня большие скидки! | GPS 8-244"
    elseif str:find("[Рр]абота[е]?т [Сс]алон") then
      return "Работает «Салон сантехники» в San Fierro | Мы по Price 18-3-2"
    elseif str:find("[Оо]ткрылся [Сс]алон") then
      return "Открылся «Салон сантехники» в San Fierro | Мы по Price 18-3-2"
    elseif str:find("вход 72") then
      return "В «Салоне сантехники» в SF вход - 72$! | Мы по Price 18-3-2"
    elseif str:find("вход в салон сантехники") then
      return "Вход в «Салон сантехники» в San Fiero - 72$ | Мы по Price 18-3-2"
    elseif str:find("Лучшие скидки сантехнике в") then
      return "Лучшие скидки в «Салоне сантехники» SF! Ждём вас! | Price 18-3-2"
    end

  elseif str:find("[Pp]rice%s?20%p3") then -- or str:find("%s?8%s?%p%s?244") or str:find("[Сс]антехника") and str:find("SF") then 
    if str:find("Создай%p%s?") then
      return "Создавай, покупай проекты в «Архитектурном бюро LV» | Price 20-3"
    elseif str:find("Любишь проектировать") then
      return "Любишь проектировать? Бюро в Лас-Вентурас открыто! | Price 20-3"
    elseif str:find("Хочешь интерьер от Лилки") then
      return "Хочешь интерьер от Лилки Пинк? Тебе в «Арх. бюро LV» | Price 20-3"
    elseif str:find("от PinkiWay") then
      return "Хочешь интерьер от PinkiWay? Тебе в «Арх. бюро LV» | Price 20-3"
    end

  elseif str:find("отелях «Biffin%pBridge» & «San%pFierro»") then
    return "VIP-номера в отелях «Biffin-Bridge» & «San-Fierro», "..get_hotel_price(str).."$/сутки!"
  elseif (str:find("[ОоHh][тo][еt][eл][lье]") or str:find("[Гг]остин")) and str:find("[Пп]ират") then -- LS | В гостинице «Пират» есть свободные номера! Мы напротив GPS: 7>19
    if str:find("233") then
      biz_loc = "GPS 8-233"
    else
      biz_loc = "Price 9-9"
    end
    if str:find("есть свободные номера") then
      return "В гостинице «Пират» есть свободные номера! | "..biz_loc
    elseif str:find("Свободные номера и низкие цены") then
      return "Свободные номера и низкие цены в «Пиратском отеле LV» | "..biz_loc
    elseif str:find("Свободные VIP%pномера на 16 этаже") then
      return "Свободные VIP-номера на 16 этаже в «Пиратском отеле»! | "..biz_loc
    elseif str:find("Свободные VIP%pномера") then
      return "Свободные VIP-номера в «Пиратском отеле LV». | "..biz_loc
    elseif str:find("Свободные и уютные VIP%pномера") then
      return "Свободные и уютные VIP-номера в «Пиратском отеле LV». | "..biz_loc
    elseif str:find("номера на 16 этаже") then
      return "Уютные VIP-номера на 16 этаже в «Пиратском отеле LV». | "..biz_loc
    elseif str:find("Самые лучшие VIP номера") then
      return "Самые лучшие VIP номера только в Пиратской гостинице. | "..biz_loc
    elseif str:find("Лучшие VIP номера") then
      return "Лучшие VIP номера только в Пиратской гостинице. | "..biz_loc
    
    end
  elseif str:find("[ОоHh][тo][еt][eл][lье]") and str:find("Океан") or str:find("[Oo]cean") or str:find("Океан") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 9-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-54"
    end
    debug("OKEAN BLA"..str, 1)
    if str:find("[Пп]родам") then
      return "Продам гостинницу «Ocean» в ш. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("экономный") then
      return "Самый экономный отель №1 в ш.Los-Santos «Океан» | "..biz_loc
    elseif str:find("бандитов") then
      return "Отель «Океан» ждет своих бандитов! "..get_hotel_price(str).."$/сутки | "..biz_loc
    elseif str:find("Проживание в отеле") then
      return "Проживание в отеле «Океан» всего лишь "..get_hotel_price(str).."$/сутки | Ждем в "..biz_loc
    elseif str:find("открытa для всех") then
      return "Гостиница «Океан» открытa для всех. Проживание "..get_hotel_price(str).."$/сутки "..biz_loc
    elseif str:find("ера в Hotel") then
      return "Доступные VIP-номера в «Ocean Hotel» LS - "..get_hotel_price(str).."$/ночь! | "..biz_loc
    elseif str:find("Самые выгодные") then
      return "Самые выгодные «VIP» номера в гостинице «Океан»! | "..biz_loc
    end
  elseif str:find("етрах") then
    return "Приобрети новогодние ёлки в «Сад. центрах LS/LV» | GPS 8-271/272"
  elseif str:find("[Сс][Аа]д") and str:find("[LlЛл][SsСс]") and str:find("[LlЛл][VvВв]") then
    if str:find("риобрети") then
      return "Приобрети новогодние ёлки в «Сад. центрах LS & LV». GPS 8-271/272"
    elseif str:find("овогод") then
      return "Купи новогоднюю ёлку в «Садовых центрах LS & LV». GPS 8-271/272"
    end
    return "Безоплатный вход в «Садовых центрах LS & LV». GPS 8-271/272"
  elseif str:find("Садовых центрах") or str:find("GPS [78]%p27[12]%p27[21]%p99") then
    if str:find("годняя [ёе]лк") then
      return "Новогодняя ёлка за 12.500$ в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("годние [ёе]лк") then
      return "Новогодние ёлки - 12.500$ в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("Обработка растений") then
      return "Обработка растений от 270$ в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("се для украшения дома") then
      return "Все для украшения дома в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("Минимальные цены") then
      return "Минимальные цены в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("для вашего участка в") then
      return "Все для вашего участка в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("[Нн]овогодние ёлочки") then
      return "Новогодние ёлочки в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("[Уу]крась дом растениями") then
      return "Укрась дом растениями. Купи в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("[Уу]добрение растений от") then
      return "Удобрение растений от 270$ в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("Все для вашего огорода") then
      return "Все для вашего огорода в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("и новогоднюю ёлку") then
      return "Купи новогоднюю ёлку в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("и новогодние ёлочки") then
      return "Купи новогодние ёлочки в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("поставить [ёе]лочку") then
      return "Успей поставить ёлочку в дом. Новый год с нами. GPS 8-271/272/99"
    elseif str:find("[ёе]лочку для дома") then
      return "Купи ёлочку для дома в «Садовых центрах». GPS 8-271/272/99"
    elseif str:find("Успейте пост[ао]вить") then
      return "Успейте поставить «Новогоднюю ёлочку» в доме. GPS 8-271/272/99"
    elseif str:find("Уход за участком вместе") then
      return "Уход за участком вместе с «Садовыми центрами». GPS 8-271/272/99"
    elseif str:find("Уход за участками вместе") then
      return "Уход за участками вместе c «Садовыми центрами». GPS 8-271/272/99"
    elseif str:find("Л[ёе]гкий заработок вместе") then
      return "Лёгкий заработок вместе c «Садовыми центрами». GPS 8-271/272/99"
    elseif str:find("Купи участок и заработай") then
      return "Купи участок и заработай c «Садовыми центрами». GPS 8-271/272/99"
    elseif str:find("Купи участок,%s?зараб[оа]т[аы](.+)й") then
      return "Купи участок, зарабатывай с «Садовыми центрами». GPS 8-271/272/99"
    elseif str:find("Зарабатывай вместе с") then
      return "Зарабатывай вместе с «Садовыми центрами»! | GPS 8-271/272/99"
    elseif str:find("Зарабатывай по крупн[ыо]му") then
      return "Зарабатывай по крупному с «Садовыми центрами». GPS 8-271/272/99"
    elseif str:find("Акции и скидки вместе") then
      return "Акции и скидки вместе с «Садовыми центрами». GPS 8-271/272/99"
    elseif str:find("Лучшие сорта растений") then
      return "Лучшие сорта растений у нас в «Садовых центрах». GPS 8-271/272/99"
    end
  elseif str:find("[Aa]ttica") then
    return "Заходи в \"Attica Bar\". У нас вкусная закуска! Мы по GPS 8-65"
  elseif str:find("[Dd][Ss]") and str:find("[Тт][Цц][Лл][Сс]") then
    if str:find("лакшери") then
      return "Большие скидки на лакшери одежду в «DS» ТЦЛС. GPS 8-39"
    elseif str:find("Лакшери одежда только") then
      return "Лакшери одежда только в «DS» ТЦЛС. GPS 8-39. Скидки!"
    elseif str:find("на одежду LUX") then
      return "Скидки на одежду LUX в «DS ТЦЛС» | GPS 8-39"
    elseif str:find("Скидки на lux") then
      return "Скидки на LUX-одежду в «DS ТЦЛС» | GPS: 8-39"
    end
    
  elseif str:find("GPS 8 > 10 АКЦИЯ") then
    return "В магазине «Spacey» акция! 10-й клиент получит 100.000$. GPS 8-10"
  elseif str:find("[Ss]pacey") then
    if str:find("машинки") then --str:find("[Bb][Mm][Ww]") then
      return "В магазин игрушек «Spacey» завезли новые машинки | Мы в GPS 8-10"
    elseif str:find("и[г]?рушки для%s?[своего]? дома") then
      if str:find("нового[дж]ние") then
        return "Купи новогодние игрушки для дома в «Spacey» | Мы в GPS 8-10"
      end
      return "Купи игрушки для своего дома в магазине игрушек «Spacey» GPS 8-10"
    elseif str:find("BMW") then
      return "В магазин игрушек «Spacey» завезли мини «BMW M5» | Мы в GPS 8-10"
    elseif str:find("игрушки") then
      return "В магазин игрушек «Spacey» завезли новые игрушки | Мы в GPS 8-10"
    elseif str:find("получает") then
      return "В магазине «Spacey» акция! 10-й клиент получит 100.000$. GPS 8-10"
    elseif str:find("Хочешь летать") then
      return "Хочешь летать? Купи «RC Baron» в магазине «Spacey»! GPS 8-10"
    elseif str:find("Обрадуй близких подарк") then
      return "Обрадуй близких подарками из магазина игрушек «Spacey»! GPS 8-10"
    elseif str:find("родам") then
      if str:find("[Бб][Лл][Сс]") or str:find("[Бб]оль") then
        return "Продам магазин игрушек «Spacey» у больницы LS. "..get_price(str, trade_type(str))
      end
      return "Продам магазин игрушек «Spacey» GPS 8-10. "..get_price(str, trade_type(str))
    end
    
  elseif str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4") or str:find("8%s?%p?%s?270$") or str:find("[Нн]омерн(.-) [Зз]наки") or str:find("номера только в СФ") or str:find("очешь круты[е]? номера") or str:find("уникальные номера") or str:find("[Нн]омера на машину") then
    --debug("+", 5)
    if str:find("[Pp]rice") then
      biz_loc = "Price 9-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-270"
    end
    if str:find("[Пп]родам") then
      return "Продам бизнес «Номерные знаки» в ш. San Fierro. "..get_price(str, trade_type(str))
    elseif str:find("себе крутые номерные") then
      return "Хочешь себе крутые номерные знаки? Тогда тебе к нам! "..biz_loc
    elseif str:find("низкие цены на") then
      return "Самые низкие цены на номерные знаки только у нас! "..biz_loc
    elseif str:find("номера только в СФ") then
      return "Самые уникальные номера только в «Номерных знаках SF». "..biz_loc
    elseif str:find("свои уникальные номера") then
      return "Сделай свои уникальные номера! Всего за 3000$. | "..biz_loc
    elseif str:find("уникальные номера") then
      return "Поставь уникальные номера в San Fierro! | "..biz_loc
    elseif str:find("на машину всего за") then
      return "Новые номера на машину всего за 3000$? | Только в "..biz_loc
    elseif str:find("Номера по демократичным ценам") then
      return "Номера по демократичным ценам в Price 11-4. Вход - 0$!"
    elseif str:find("Козырной номер для") then
      return "Козырной номер для ласточки в «Номерных знаках SF». | "..biz_loc
    elseif str:find("Aдекватные цены на номера") then
      return "Aдекватные цены на номера в «Номерных знаках SF». | "..biz_loc
    elseif str:find("Цветные номера") then
      return "Цветные номера на авто в «Номерных знаках SF». | "..biz_loc
    elseif str:find("Сделай красивый номер в") then
      return "Сделай красивый номер в «Номерных знаках SF». | "..biz_loc
    elseif str:find("Пусть знают чья лошадка") then
      return "Пусть знают чья лошадка! «Номерные знаки SF». | "..biz_loc
    elseif str:find("очешь круты[е]? номера?") then
      if str:find("церкв") then
        return "Хочешь крутые номера? Тебе в номерные знаки SF! Мы рядом с церквью SF"
      end
      return "Хочешь крутые номера? 3000$ и они твои! | "..biz_loc
    end  
  elseif str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4") or str:find("8%s?%p?%s?197") or str:find("[Нн]омерн(.-) [Зз]наки") or str:find("номера только в ЛВ") then
    --debug("+", 5)
    if str:find("[Pp]rice") then
      biz_loc = "Price 11-3"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-197"
    end
    if str:find("[Пп]родам") then
      return "Продам бизнес «Номерные знаки» в ш. Las Venturas. "..get_price(str, trade_type(str))
    elseif str:find("изгот[т]?овим уникальный номер на ваш авто") then
      return "Изготовим уникальные номера на ваш автомобиль! | "..biz_loc
    elseif str:find("[Уу]становим уникальный номер на ваш авто") then
      return "Установим уникальные номера на ваш автомобиль! | "..biz_loc
    elseif str:find("блатные номера тогда") then
      return "Хочешь блатные номера? Тогда тебе в "..biz_loc.."! Сегодня скидки!"
    end  
  elseif str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4222") or str:find("8%s?%p?%s?192") then
    --debug("+", 5)
    if str:find("[Pp]rice") then
      biz_loc = "Price 11-3"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-192"
    end
    if str:find("[Пп]родам") then
      return "Продам бар «The Crew Bar» в ш. Las Venturas. "..get_price(str, trade_type(str))
    elseif str:find("закуска только") then
      return "Выпивка, закуска только у нас - «The Crew Bar» | "..biz_loc

    end  
  elseif str:find("[Аа]втомастерск[ауо][яюй] [ЛL][VВ]") and str:find("%s?8%s?%p%s?235") then 
    if str:find("Хочешь .+ быстрый") then
      return "Хочешь быстрый автомобиль? Тебе в «Автомастерскую LV» | GPS 8-235"
    elseif str:find("Улучши дв[иа]гатель") then
      return "Улучши двигатель своего авто в «Автомастерской LV» | GPS 8-235"
    end
    
  elseif str:find("%s?1%s?%p%s?18") then
    if str:find("Прокачай свое авто") then
      return "Прокачай свое авто у нас качественно. Вход бесплатный! | GPS 1-18"
    elseif str:find("Снаряди своего железного") then
      return "Снаряди своего железного коня в «Автомастерской» LV. | GPS 1-18"
    elseif str:find("Выжми максимум из своей") then
      return "Выжми максимум из своей тачки в «Автомастерской» LV. | GPS 1-18"
    elseif str:find("Любишь острые ощущения") then
      return "Любишь острые ощущения? Заезжай в «Автомастерскую» LV. | GPS 1-18"
    end
  elseif str:find("Автомастерской у Таможни ЛВ") then
    -- Прокачай свой Clover в Автомастерской у Таможни ЛВ. Ждем вас
    if str:find("Прокачай свой Clover") then
      return "Прокачай свой Clover в «Автомастерской» у Таможни LV. Ждем вас!"
    end
  elseif str:find("%s?5%s?%p%s?6") or str:find("%s?8%s?%p%s?433333") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 5-6"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-43"
    end
    if str:find("низкие цены") then
      return "В магазине одежды «Sub Urban» в LS низкие цены | "..biz_loc
    elseif str:find("Большие розовые аксессуары") then
      return "Большие розовые аксессуары в «Sex Shop №2» за БЛС | "..biz_loc
    end
  elseif str:find("%s?10%s?%p%s?4") then
    if str:find("Игрушки с тест") then
      return "Игрушки с тест-драйвом в примерочной в «Sex Shop SF» | Price 10-4"
    end
    
  elseif str:find("%s?8%s?%p%s?283") then
    if str:find("Хочешь жить в уюте") then
      return "Хочешь жить в уюте? Выбирай «Awayuki Holding»! GPS 8-283"
    -- elseif str:find("Большие розовые аксессуары") then
    --   return "Большие розовые аксессуары в «Sex Shop №2» за БЛС | Price 10-2"

    end
  elseif str:find("nvestical") and str:find("roup") then
    return "Компания «Investical Group» ищет новых сотрудников | GPS 4-7"
  elseif str:find("[(PRICE)|(Price)|(price)]%s8%s?%p%s?5") then
    -- debug("ZERO", 2)
    if str:find("%s?8%s?%p%s?5[(%p)|($)]") then
      biz_loc = "Price 8-5"
    end
    if str:find("лучший магазин игрушек") then
      return "Zero RC - лучший магазин игрушек в СФ! | Мы в "..biz_loc
    elseif str:find("Купи радиоуправляемую машинку и удиви друга") then
      return "Купи радиоуправляемую машинку и удиви друга! Zero RC - "..biz_loc
    end
  elseif str:find("[(PRICE)|(Price)|(price)]%s8%s?%p%s?2") then
    -- debug("ZERO", 2)
    if str:find("[Pp]rice") then
      biz_loc = "Price 8-2"
    -- elseif str:find("[Gg][Pp][Ss]") then
    --   biz_loc = "GPS 8-118"
    end
    if str:find("Хочешь танк") then
      return "Хочешь танк? Тогда тебе в магазин игрушек «Toy Corner». "..biz_loc
    end
  -- elseif str:find("агаз") and str:find("груш") then
  --   if str:find("[Бб][Лл][Сс]") then
  --     return "Хочешь танк? Купи его в «Магазине игрушек» за БЛС | GPS 8-10"
  --   end
    -- Zero RC - лучший магазин игрушек в СФ! Мы в PRICE 8-5!
  elseif str:find("[Vv]isage") or str:find("VISAGE") then
    if str:find("доступны VIP") then
      return "В Отеле «Visage» доступны VIP номера. Цена: "..get_hotel_price(str).."$/д. | GPS 8-232"
    elseif str:find("сногш") then
      return "В отеле «Visage» сногшибательная цена на номер - "..get_hotel_price(str).."$ | GPS 8-232"
    elseif str:find("Твой номер уже ждет тебя") then
      return "Твой номер уже ждет тебя! Гост-чный. комплекс Visage. | GPS 8-232"
    elseif str:find("Топовые VIP номера") then
      return "Топовые VIP номера за "..get_hotel_price(str).."$ в сутки | Отель VISAGE | GPS 8-232"
    elseif str:find("Твой VIP номер") and not str:find("сутки") then
      return "Твой VIP номер уже ждет тебя! Гост. Комплекс Visage | GPS 8-232"
    elseif str:find("Hotel Visage") and str:find("%pсутки") then
      return "Твой VIP номер ждет тебя! "..get_hotel_price(str).."$/сутки. Hotel Visage | GPS 8-232"
    elseif str:find("Отель Visage") and str:find("%pсутки") then
      return "Твой VIP номер ждет тебя! "..get_hotel_price(str).."$/сутки. Отель Visage | GPS 8-232"
    elseif str:find("«Отель VISAGE»") and str:find("%pсутки") then
      return "Твой VIP номер ждет тебя! "..get_hotel_price(str).."$/сутки. «Отель VISAGE» | GPS 8-232"
    elseif str:find("Лучшие VIP номера") then
      return "Лучшие VIP номера за "..get_hotel_price(str).."$ только в ОТЕЛЕ VISAGE | GPS 8-232"
    end
  elseif str:find("[Pp]rice%s%p?%s?9%s?%p%s?3") or str:find("%s?8%s?%p%s?118")  then
    if str:find("[Pp]rice") then
      biz_loc = "Price 9-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-118"
    end
    if str:find("любовни") then
      return "Отель «Сан-Фиерро» - порадуй себя и свою любовницу | "..biz_loc
    elseif str:find("новогодние скидки") then
      return "В Отеле «Сан-Фиерро» новогодние скидки - 333$/сутки | "..biz_loc
    elseif str:find("[Уу]ютные номера ждут тебя") then
      return "Уютные номера ждут тебя в отеле «Сан-Фиерро» | "..biz_loc
    elseif str:find("Свободные номера всего") then
      return "Свободные номера всего по 350$ в отеле «Сан-Фиерро» | "..biz_loc
    elseif str:find("Президентский LUXE") then
      return "Президентский LUXE-номер в Отеле «San Fierro» за "..get_hotel_price(str).."$ | "..biz_loc
    elseif str:find("Номера по") then
      return "Номера по "..get_hotel_price(str).."$ только в «Отеле San Fierro» | "..biz_loc
    else
      return "В Отеле «Сан-Фиерро» номера от "..get_hotel_price(str).."$/сутки. Ждём тебя | "..biz_loc
    end
  elseif str:find("[Pp]rice%s8%s?%p%s?3$") or str:find("lexande") and str:find("[Tt]oys") then
    if str:find("адиоуправляемый вертолет") then
      return "Купи радиоуправляемый вертолет в «Alexander's Toys» | Price 8-3"
    elseif str:find("BMW") then
      return "Магазин «Alexander's Toys» закупил мини «BMW M5» | Price 8-3"
    elseif str:find("Скучно?") then
      return "Тебе скучно? Мини-машинки в «Аlexanders Toys» | Price 8-3"
    elseif str:find("Самые низкие цены на игрушки") then
      return "Самые низкие цены на игрушки в «Аlexanders Toys» | Price 8-3"
    elseif str:find("Летай на самолётах") then
      return "Летай на самолётах, громи на танке в магаз. игрушек ЛС! Price 8-3"

    end
    
  elseif str:find("Binco %p?Grove%p?") or str:find("8%s?%p?%s?6%p?$") and str:find("[Gg][Pp][Ss]") then
    if str:find("Самая дешевая брендовая") then
      return "Самая дешевая брендовая одежда только в «Binco Grove». | GPS 8-6"
    elseif str:find("рендовая одежда") then
      return "Брендовая одежда от 7.000$ в магазине «Binco Grove». Мы в GPS 8-6"
    elseif str:find("Скидки на брендовую одежду") then
      return "Скидки на брендовую одежду в магазине «Binco Grove LS» | GPS 8-6"
    elseif str:find("Обновите гардероб в магазине") then
      return "Обновите гардероб в магазине одежды «Binco Grove LS» | GPS 8-6"
    elseif str:find("Сам[ыа][ея] низкие цены") then
      return "Самые низкие цены на брендовую одежду в «Binco Grove LS». GPS 8-6"
    elseif str:find("премиального качества") then
      return "Одежда премиального качества в «Binco Grove» | GPS 8-6"
    elseif str:find("Бешеные скидки на одежду") then
      return "Бешеные скидки на одежду только в «Binco Grove» | GPS 8-6"
    elseif str:find("Бешеные скидки на любую") then
      return "Бешеные скидки на любую одежду в «Binco Grove» | GPS 8-6"
    elseif str:find("Rollerskater") then
      return "Одежда «Rollerskater» всего за 500.000$ в «Binco Grove» | GPS 8-6"
    elseif str:find("магазине одежды «Binco»") then
      return "Одежда от 7.500$ в магазине одежды «Binco»! | GPS 8-6"
    elseif str:find("В «Binco» в опасном") then
      return "В «Binco» в опасном районе низкие цены на одежду! | GPS 8-6"
    elseif str:find("Хочешь быть одетым модно") then
      return "Хочешь быть одетым модно? «Binco Grove» тебе в подмогу! | GPS 8-6"
    end
  elseif str:find("8%s?%p?%s?69$") and str:find("[Gg][Pp][Ss]") then
    if str:find("Хочешь стать клоуном") then
      return "Хочешь стать клоуном? Купи у нас форму для веселья!  | GPS 8-69"
    elseif str:find("рендовая одежда") then
      return "Брендовая одежда от 7.000$ в магазине «Binco Grove». Мы в GPS 8-6"
    end
    
  elseif str:find("8%s?%p?%s?79[($)|(!)]") and str:find("[Gg][Pp][Ss]") then

    if str:find("ультрамодная коллекция") then
      return "Новая ультрамодная коллекция ассортимента в Sub Urban. GPS 8-79"
    elseif str:find("удивить своих") then
      return "Хочешь удивить своих братков? Заходи в Sub Urban. GPS 8-79"
    elseif str:find("смелых и ярких") then
      return "Sub Urban - стиль для смелых и ярких! GPS 8-79"
    elseif str:find("одевайтесь с душой") then
      return "Sub Urban - одевайтесь с душой! GPS 8-79"
    elseif str:find("уникальный стиль для") then
      return "Sub Urban - уникальный стиль для городской жизни! GPS 8-79"
    elseif str:find("Только сегодня") then
      return "Только сегодня! Скидки на одежду в Sub Urban. GPS 8-79"
    elseif str:find("[Пп]родам") then
      return "Продам «Sub Urban» в ш. Los Santos по GPS 8-79. "..get_price(str, trade_type(str))
    elseif str:find("Большие скидки") then
      return "Большие скидки на одежду от владельца. GPS 8-79"
    elseif str:find("Брендовая одежда") then
      return "Брендовая одежда в «Sub Urban». Стиль это наше! | GPS 8-79"
    elseif str:find("Обновите свой гардероб") then
      return "Обновите свой гардероб в магазине «Sub Urban» в LS. | GPS 8-79"
    elseif str:find("Одежда всего от") then
      return "Одежда всего от 7.000$ в магазине «Sub Urban» в LS. | GPS 8-79"
    end
  -- elseif str:find("Sub Urban") or str:find("5%s?%p?%s?16[($)|(!)]") and str:find("[Pp]rice") then
  --   if str:find("Низкие цены в магазине") then
  --     return "Низкие цены в магазине одежды Sub Urban «Palomino» | Price 5-16"
  --   elseif str:find("удивить своих") then
  --     return "Хочешь удивить своих братков? Заходи в Sub Urban. GPS 8-79"
  --   end
    
  elseif str:find("8%s?%p?%s?111") and str:find("[Gg][Pp][Ss]") then
    if str:find("Стильная одежда") then
      return "Стильная одежда от 7.000$ в «Binco» г.San Fierro | Ждем в GPS 8-111"
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?149") then
    if str:find("Продукты в Fort") then
      return "Продукты в Fort Carson - отличные цены и расположение! GPS 8-149"
    end
  elseif str:find("8%s?%p?%s?14") and str:find("[GgГгдД][жЖ]?[PpПп][SsСс]") or str:find("[Нн]авигация") then
    if str:find("Самая деш[её]вая одежда") or str:find("самая дешева%s?я одежда") then
      return "Самая дешёвая одежда в магазине «DS» | Мы в GPS 8-14"
    elseif str:find("Почув[в]?ствуй себя богатым") and not str:find("[Нн]авигация") then
      return "Почувствуй себя богатым в одежде магазина «DS» | GPS 8-14"
    elseif str:find("Tv [Сс]амая деш[ёе]вая одежда") then
      return "Самая дешёвая одежда в нашем прекрасном магазине «DS» | GPS 8-14"
    elseif str:find("Почувствуй себя богатым") then
      return "Почувствуй себя богатым в одежде от «DS». Навигация: GPS 8-14"
    elseif str:find("Почувствуй стиль в") then
      return "Почувствуй стиль в одежде от «DS». Навигация: GPS 8-14"
    elseif str:find("[Оо]бнови гардероб в магазине") then
      return "Обнови гардероб в магазине «DS» в Los-Santos | GPS 8-14"
    end
    
  elseif str:find("[Аа]гробирже") and str:find("%s8%s?%p?%s?247") or str:find("%s8%s?%p?%s?273") then
    if str:find("%s?8%s?%p%s?247") then
      biz_loc = "Мы у GPS 8-247"
    elseif str:find("%s?8%s?%p%s?273") or str:find("GPS 8 273") then
      biz_loc = "GPS 8-273"
    end
    if str:find("Cвободные%s?%sучастки в Агробирже") then
      return "Cвободные участки в «Агробирже» ш. San Fierro! | "..biz_loc
    elseif str:find("[Уу]частки по гос.стоимости") then
      return "Участки по гос.стоимости в «Агробирже» у SFFM! | "..biz_loc
    elseif str:find("Более 20 свободных участков") then
      return "Более 20 свободных участков в «Агробирже» San-Fierro! | "..biz_loc
    elseif str:find("в Агробирже более 20") then
      return "В «Агробирже» San Fierro более 20 свободных участков | "..biz_loc
    elseif str:find("появились свободные участки") then
      return "В «Агробирже» San-Fierro появились свободные участки | "..biz_loc
    elseif str:find("[Вв]ыбери себе земельный участок") then
      return "Выбери себе земельный участок в «Агробирже» San Fierro | "..biz_loc
    elseif str:find("[Сс]вободные земельные участки") then
      return "Свободные земельные участки в «Агробирже» San Fierro | "..biz_loc
    elseif str:find("Хочешь начать фермерский бизнес") then
      return "Хочешь начать фермерский бизнес? Тебе в «Агробиржу» San Fierro | "..biz_loc
    elseif str:find("Купи участок по душе") then
      return "Купи участок в «Агробирже» SF и начни зарабатывать! | "..biz_loc
    elseif str:find("Хочешь земельный участок? Тебе к н") then
      return "Хочешь земельный участок? Тебе к нам в «Агробиржу» SF | "..biz_loc
    elseif str:find("Хочешь купить земельный") then
      return "Хочешь купить земельный участок? Купи его у нас! | "..biz_loc
    elseif str:find("Покупай тут") then
      return "Хочешь земельный участок? Покупай тут: "..biz_loc
    end
    
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?247") then
    if str:find("[Сс]охраним транспорт") then
      return "Cохраним ваш транспорт на время переезда всего за 699$! GPS 8-247"
    elseif str:find("[Хх]ранение транспорта,в") then
      return "Хранение вашего транспорта всего за 699$! | Мы в GPS 8-247"
    elseif str:find("авто на время переезда") then
      return "Храним Ваше авто на время переезда всего за 699$ | GPS 8-247"
    elseif str:find("Гони свою ласточку") then
      return "Гони свою ласточку в «Хранение SF», цена 699$/1д! GPS 8-247"
    elseif str:find("Хранение транспорта San Fierro") then
      return "Хранение транспорта San Fierro, цена 1-го дня от 699$! | GPS 8-247"
    elseif str:find("Храним бережно") then
      return "Храним бережно Ваш транспорт, цена 1-го дня от 699$ | GPS 8-247"
    elseif str:find("Бережно сохраним") then
      return "Бережно сохраним Ваш транспорт, цена 1-го дня от 699$! GPS 8-247"
    elseif str:find("Сохраним бережно") then
      return "Сохраним бережно Ваш транспорт на время переезда! | GPS 8-247"
    elseif str:find("Сохраним%pВаш транспорт%p") then
      return "Сохраним Ваш транспорт на время переезда! | GPS 8-247"
    elseif str:find("Хранение транспорта SF, цена ") then
      return "Хранение транспорта SF, цена 1-го дня 1500$ | GPS 8-247"
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?246") then
    return "Оставь свою ласточку в «Хранении транспорта LS». | GPS 8-246"
  elseif not str:find("[Пп]родам") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?144") then
    if str:find("аксессуары на любой кoшелек") then
      return "Новые аксессуары на любой кошелек, вкус и цвет! Заходи: GPS 8-144"
    end
  

  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?267") then
    if str:find("Хочешь быть гангстером") then
      return "Хочешь быть гангстером? Тебе в «Оружейный магазин LV» | GPS 8-267"
    end

  -- elseif not str:find("врач") and not str:find("[Аа]ук") and not str:find("[Мм]ед%s?карты") and not str:find("[Пп]о[н]?чик") and str:find("[(бинко)|(Binco)|(Bicno)]") and str:find("[(лв)|(LV)|(ЛВ)]") or str:find("%p?%s?8%s?%p%s?162") then
  --   if str:find("дешевая одежда") then
  --     return "Самая дешевая одежда в «Binco» возле больницы ш. LV | GPS 3-14"
  --   elseif str:find("при покупке одежды") then
  --     return "Cash-back при покупке одежды в Binco возле больницы ш.LV | GPS 3-14"
  --   elseif str:find("дикие скидки") then
  --     return "Только сегодня дикие скидки в Binco у больницы ш. LV | GPS 3-14"
  --   elseif str:find("Стильная одежда от") then
  --     return "Стильная одежда от 7.000$ в магазине «Binco» у БЛВ. | GPS 8-162"
  --   elseif str:find("Обновите гардероб в магазине") then
  --     return "Обновите гардероб в магазине одежды «Binco» у БЛВ. | GPS 8-162"
      
  --   end

  elseif str:find("Binco") and str:find("%p?%s?8%s?%p%s?122") then
    if str:find("дешевая одежда") then
      return "Самая дешевая одежда в «Binco» | GPS 8-122"
    elseif str:find("от покупки в магазине одежды") then
      return "Получи Cash-Back от покупки в магазине одежды «Binco» | GPS 8-122"
    elseif str:find("дикие скидки") then
      return "Только сегодня дикие скидки в Binco | GPS 8-122"
    elseif str:find("Стильная одежда от") then
      return "Стильная одежда от 7.000$ в магазине «Binco». | GPS 8-122"
    elseif str:find("Обновите гардероб в магазине") then
      return "Обновите гардероб в магазине одежды «Binco». | GPS 8-122"
    end

  elseif str:find("Binco в Blueberry") or str:find("Binco Blueberry") then -- Одевайся модно и недорого в магазине одежды Binco в Blueberry.
    if str:find("Одевайся модно и недорого") then
      return "Одевайся модно и недорого в магазине одежды «Binco» в Blueberry."
    elseif str:find("Скидки на всю одежду") then
      return "Скидки на всю одежду в Binco Blueberry, поспеши! Мы за заводом!"
    end
  elseif str:find("АММО") and str:find("%p?%s?8%s?%p%s?267") or str:find("[Gg][Pp][Ss]%s?%p?%s?267") then
    if str:find("Стреляешься с МВД") then
      return "Стреляешься с МВД? Купи обрезы и броник в «АММО LV»! | GPS - 267"
    elseif str:find("Стреляешься с ПД") then
      return "Стреляешься с ПД? Купи обрезы и броник в «АММО ЛВ»! | GPS - 267"
    end

  elseif str:find("[Бб]ургеры") and str:find("%p?%s?8%s?%p%s?122") then
    if str:find("Попробуй лучшие бургеры") then
      return "Попробуй лучшие бургеры в штате у нас! Мы напротив GPS 8-122"
    end

  elseif not str:find("продукты только") and str:find("[Bb]i[cn][cn]o") and str:find("[Тт][Цц][Лл][Вв]") or str:find("Binco%sLV") then
    
    if str:find("от покупки одежды") then
      return "Получи Cash-Back от покупки одежды в «Binco» ТЦЛВ! GPS 8-180"
    elseif str:find("низкие цены на брендовый лук") then
      return "Самые низкие цены на брендовый лук в Binco у ЛВФМ. GPS 8-180"
    elseif str:find("брендовую одежду") then
      return "Самые низкие цены на брендовую одежду в Binco у ЛВФМ. GPS 8-180"
    elseif str:find("Стильно, модно, молодёжно") then
      return "Стильно, модно, молодёжно - одежда «Binco LV» | Мы в GPS 8-180"
    elseif str:find("Одежда на любой вкус") then
      return "Одежда на любой вкус в «Binco ТЦЛВ» | Мы в GPS 8-180"
    end
    
  elseif str:find("[Pp]ro[Ll]aps") and str:find("[Gg][Pp][Ss]") and str:find("3%s?%p?%s?10") then
    if str:find("магазине одежды ProLaps") then
      return "В магазине одежды «ProLaps» в д. Bayside скидки | GPS 3-10"
    elseif str:find("Костюмы от 7000") then
      return "Костюмы от 7000$ в магазине «ProLaps» в д. Bayside! Мы у GPS 3-10"
    end

  elseif str:find("[Pp]ro[Ll]aps") and str:find("[Pp]rice %p?%p? 5") then
    if str:find("еделя скидок в") then
      return "Неделя скидок в магазине одежды «ProLaps» у ВМФ | Price 5-1-11"
    elseif str:find("Костюмы от 7000") then
      return "Костюмы от 7000$ в магазине «ProLaps» в д. Bayside! Мы у GPS 3-10"
    end
    
    --В магазине одежды ProLaps что у ВМФ действуют скидки gps 3-10
  elseif str:find("Mad Dogs") and str:find("%s8%s?%p%s?153%p?%s?") then
    if str:find("[Оо]тдохни и выпей пивка") then
      return "Посети бар «Mad Dogs MC»! Отдохни и выпей пивка! | GPS 8-153"
    elseif str:find("Холодное пиво") then
      return "Холодное пиво в «Пивнушке» в д. Fort Carson. | Мы в GPS 8-153"
    end
  elseif str:find("[Пп]ивнуш") and str:find("[Фф]орт") and str:find("%s8%s?%p%s?154%p?%s?") then
    if str:find("[Зз]аходите в") then
      return "Заходите в «Пивнушку» в д. Fort Carson. | Мы в GPS 8-154"
    elseif str:find("Холодное пиво") then
      return "Холодное пиво в «Пивнушке» в д. Fort Carson. | Мы в GPS 8-154"
    end
  elseif str:find("[Vv][Ii][Cc][Tt][Ii][Mm]") and str:find("[GgГг][PpПп][SsСс]") and str:find("%s8%s?%p%s?15%p?%s?") then
    if str:find("ировые бренды одежды в мага") then
      return "Мировые бренды одежды в магазине «Victim» ш. Los Santos | GPS 8-15"
    elseif str:find("Не будь чушпаном[%s%p]одевайся") then
      return "Не будь чушпаном, одевайся в магазине «Victim» ш.Los Santos | GPS 8-15"
    elseif str:find("сегодня распродажа") then
      return "Только сегодня распродажа в магазине «VICTIM» | GPS 8-15"
    elseif str:find("громные скидки") then
      return "Cегодня огромные скидки в магазине «VICTIM»! Ждем вас! | GPS 8-15"
    elseif str:find("Смени стиль с магазином") then
      return "Смени стиль с магазином одежды «Victim» LS | GPS 8-15"
    elseif str:find("Примерь деловой стиль") then
      return "Примерь деловой стиль в магазине одежды «Victim» LS. GPS 8-15"
    elseif str:find("Самые доступные цены") then
      return "Самые доступные цены в магазине одежды «Victim» LS. GPS 8-15"
    end
    
  elseif str:find("%s?8%s?%p%s?177%p?%s?") then
    if str:find("дешёвая одежда в магазине") then
      return "Самая дешёвая одежда в магазине одежды «ZIP» в ТЦЛВ. | GPS 8-177"
    elseif str:find("от 7%p000%$ в") then
      return "Одежда от 7.000$ в магазине одежды «ZIP» в ТЦЛВ. | GPS 8-177"
    elseif str:find("Стильная одежда только") then
      return "Стильная одежда только в магазине «ZIP LV». | GPS 8-177"
    elseif str:find("подберет [Вв]ам правильный") then
      return "Только магазин «ZIP LV» подберет Вам правильный костюм! GPS 8-177"
    elseif str:find("Доступные цены и разнообразная") then
      return "Доступные цены и разнообразная одежда в «ZIP LV» | GPS 8-177"
    elseif str:find("Бешеные скидки на одежду") then
      return "Бешеные скидки на одежду только в «ZIP LV» | GPS 8-177"
    elseif str:find("Самая дешевая топовая") then
      return "Самая дешевая топовая одежда только в «ZIP LV» | GPS 8-177"
    elseif str:find("Низкие цены") then
      return "Низкие цены на одежду в магазине «ZIP LV» | GPS 8-177"
    end
  
  elseif str:find("%s?8%s?%p%s?178%p?%s?") then
    if str:find("дешёвая одежда в магазине") then
      return "Самая дешёвая одежда в магазине одежды «ZIP» в ТЦЛВ. | GPS 8-178"
    elseif str:find("Rollerskater") and str:find("500") then
      return "Одежда «Rollerskater» за 500.000$ только в «ZIP ТЦЛВ» | GPS 8-178"
    elseif str:find("Одежда по самым низким ") then
      return "Одежда по самым низким ценам только в «ZIP ТЦЛВ» | GPS 8-178"
    elseif str:find("Брендовая одежда от 7") then
      return "Брендовая одежда от 7.000$ только в «ZIP ТЦЛВ» | GPS 8-178"
    elseif str:find("Бешенные скидки") then
      return "Бешенные скидки на одежду только в «ZIP ТЦЛВ» | GPS 8-178"
    elseif str:find("Большие скидки") then
      return "Большие скидки в магазине одежды «ZIP ТЦЛВ» | GPS 8-178"
    elseif str:find("Скидки в [Мм]агазине") then
      return "Скидки в магазине одежды «ZIP» у ТЦЛВ | GPS 8-178"
    elseif str:find("Самая дешевая топовая") then
      return "Самая дешевая топовая одежда в «ZIP ТЦЛВ» | Мы рядом с GPS 8-178"
    end
    

  elseif str:find("только в японском стиле") and str:find("[Gg][Pp][Ss]") and str:find("%s4%s?%p%s?8%p?%s?") then
    return "Лучшая одежда только в японском стиле. Мы рядом с GPS 4-8"
    --- Самые низкие цены в магазине продуктов "Гастроном". GPS 8-189
  elseif not str:find("центов") and  str:find("[Гг]астроном") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p%s?189%p?%s?") then
    if str:find("[Сс][ав]мые низкие цены") then
      return "Самые низкие цены в магазине продуктов «Гастроном» | GPS 8-189"
    elseif str:find("Экономь с") then
      return "Экономь с «Гастроном»! Самые низкие цены ждут тебя | GPS 8-189"
    end
  elseif str:find("%s?8%s?%p?%s?181") then
    if str:find("Самые низкие цены в штате") then
      return "Самые низкие цены в штате в нашем «24/7» | GPS 8-181"
    elseif str:find("Большие скидки на все") then
      return "Большие скидки на все в «Восточном 24/7» у Yakuza | GPS 8-181"
    elseif str:find("Скидки на все") then
      return "Скидки на все в магазине «24/7» у Yakuza | GPS 8-181"
    end
  
  elseif str:find("24%p7") or str:find("24%p7") or str:find("24%s7") or str:find("24%s?[Нн][Аа]%s?7") or str:find("Мы у АЗС [(ЛВПД)|(LVPD)]") or str:find("98 центов") or str:find("[Сс]упермаркет") or str:find("[Пп]родам закуп") then
    -- debug("magaz", 3)
    
    if str:find("[Пп]родам") then
      
      if str:find("Лас[ -]Вентурас") then
        return "Продам бизнес «24/7» в ш. Las Venturas. "..get_price(str, trade_type(str))

      elseif str:find("[Лл]ос[ -][Сс]антос") then
        if str:find("[Мм]эр[и]?ей") and str:find("[ЛлLl][ОоOo]?[СсSs]") then
          return "Продам бизнес «24/7» за мэрией ш. Los Santos. "..get_price(str, trade_type(str))
        end
        return "Продам бизнес «24/7» в ш. Los Santos. "..get_price(str, trade_type(str))
      elseif str:find("[Dd]il[l]?i[o]?more") or str:find("[Дд]иллиморе") then
        if str:find("[Gg][Pp][Ss]") then
          return "Продам бизнес «24/7» в д.Dillimore: GPS 8-230 | "..get_price(str, trade_type(str))
        end
        return "Продам бизнес «24/7» в д. Dillimore. "..get_price(str, trade_type(str))
      elseif str:find("[Bb]ayside") or str:find("[Вв][Мм][Фф]") then
        return "Продам бизнес «24/7» в д. Bayside у базы ВМФ. "..get_price(str, trade_type(str))
      elseif str:find("[Сс]упермаркет") and str:find("[LlЛл][VvВв]") then
        return "Продам «Супермаркет»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("8%p160") then
        return "Продам бизнес «24/7» по GPS 8-160. "..get_price(str, trade_type(str))
      else
        return "Продам бизнес «24/7»"..get_location(str)..". "..get_price(str, trade_type(str))
      end
    elseif str:find("[Кк]у[рп]лю") then
      return "Куплю бизнес «24/7»"..get_location(str)..". "..get_price(str, trade_type(str))
    end
    
    if str:find("lvfm") or str:find("LVFM") or str:find("ЛВФМ") then

      if str:find("джекпот") then
        return "Сорви джекпот купив лотерейный билет в «24/7» у LVFM | GPS 8-178"
      elseif str:find("куш") then
        return "Сорви куш с лотерейным билетиком из «24/7» у LVFM | GPS 8-178"
      elseif str:find("%sдешевые%sсим") then
        return "Самые дешевые сим-карты в «24/7» LVFM | GPS 8-178"
      elseif str:find("[Pp]ric[er]%s1%p28") or str:find("PRICE%s%p%s№28") then
        if str:find("Лучшие цены на продукты") then
          return "Лучшие цены на продукты только в «24/7» у ЛВФМ | Price 1-28"
        end
      end
    elseif str:find("[Dd]il[l]?i[o]?more") or str:find("дилимуре") and str:find("[Gg][Pp][Ss]") then
      if str:find("в дилимуре") then
        return "В магазине «24/7 Dillimore» дешевые цены! Заходите: GPS 8-230"
      elseif str:find("доступными ценами") then
        return "24/7 «Dilimore» - лучший магазин с доступными ценами | Fuel 2"
      end
    elseif str:find("[Vv]ine[Ww]ood") and str:find("[Gg][Pp][Ss]") then
      if str:find("купи лотерейный билет") then
        return "Выиграй 50.000$ купи лотерейный билет в 24/7 VineWood | GPS: 8-19"
      -- elseif str:find("Обнови SIM") then
      --   return "Обнови SIM-карту по низким ценам в 24/7 «Dillimore». Price 1-2"
      end
    elseif str:find("[Тт]очка") and str:find("[Мм]олочка") then
      if str:find("Ремкомплекты по 1200") then
        return "Ремкомплекты по 1200$ в «24/7 Точка-Молочка» напротив GPS 6-2!"
      end
    elseif str:find("АЗС LVPD") or str:find("АЗС ЛВПД") then
      if str:find("ремкомплекты и маски") or str:find("маски и ремкомплекты") then
        return "Низкие цены на ремкомплекты и маски только у нас! Мы у АЗС ЛВПД"
      elseif str:find("маски и ремкомплекты") then
        return "Низкие цены на маски и ремкомплекты в нашем 24/7. Мы у АЗС ЛВПД"
      elseif str:find("низкие цены на ремкомплекты") then
        return "Низкие цены на ремкомплекты только в нашем «24/7»! Мы у АЗС LVPD"
      elseif str:find("низкие цены на аптечки и маски") then
        return "Низкие цены на аптечки и маски только в нашем «24/7» у АЗС ЛВПД"
      end
      
    elseif str:find("98 центов") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 1-15"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-83"
      end
      if str:find("[Пп]рода[мю]") then
        return "Продам магазин 24/7 «98 центов» за Админ. ЛС. "..get_price(str, trade_type(str))
      elseif str:find("Самые низкие цены") then
        return "Самые низкие цены в мини-маркете «98 центов». "..biz_loc
      elseif str:find("Самые дешёвые цены") then
        return "Самые дешёвые цены в мини-маркете «98 центов» за Мэрией ЛС"
      elseif str:find("дешёвые цены в мини%pмаркете 98 центов") then
        return "Дешёвые цены в мини-маркете «98 центов» за Мэрией LS | "..biz_loc
      elseif str:find("[Нн]изкие цены в мини") then
        return "Низкие цены в мини-маркете «98 центов» за Мэрией LS | "..biz_loc
      --дешёвые цены в мини-маркете 98 центов за Мэрией ЛС price 1-15
      end
    elseif str:find("[Тт][Цц][Лл][Сс]") then
      if str:find("[Пп]рода[мю]") then
        return "Продам магазин «24/7» в ТЦЛС. "..get_price(str, trade_type(str))
      elseif str:find("[Gg][Pp][Ss]") then
        if str:find("[Сс]амые низкие цены в") then
          return "Самые низкие цены в «24/7 ТЦЛС». Мы в GPS 8-38"
        elseif str:find("самые низкие цены.%s?Мы") then
          return "В магазине «24/7 ТЦЛС» самые низкие цены. | GPS 8-38 | Ждем тебя!"
        end
      elseif str:find("Самые выгодные цены") then
        return "Самые выгодные цены только в нашем «24/7» в ТЦЛС. Ждем Вас!"
      end
      
    elseif str:find("%s8%s?%p%s?211") or str:find("[Pp]rice%s1%p1%p38") or str:find("[Pp]rice%s1%p38") then
      --debug("+", 2)
      if str:find("низкие цены") then
        return "В магазине продуктов «24/7» низкие цены. Ждём тебя | GPS 8-211"
      elseif str:find("Аптечки и дешевые ремкомплекты") then
        return "Аптечки и дешевые ремкомплекты в «24/7» Montgomery | GPS 8-211"
      elseif str:find("Недорогие маски и аптечки") then
        return "Недорогие маски и аптечки в «24/7» Montgomery | GPS 8-211"
      elseif str:find("Аптечки и недорогие ремкомплекты") then
        return "Аптечки и недорогие ремкомплекты в «24/7» Montgomery | GPS 8-211"
      end

    elseif str:find("%s8%s?%p%s?21$") then
      if str:find("Самые лучшие продукты только") then
        return "Самые лучшие продукты только в магазине «24/7» у АП | GPS 8-21"
      elseif str:find("Сам[ыv]е лучшие цены") or str:find("ЛУЧШИЕ ЦЕНЫ") then
        return "Самые лучшие цены в магазине «24/7» у АП | GPS 8-21"
      elseif str:find("Низкие цены на товар") then
        return "Низкие цены на товар в магазине «24/7» у АП | GPS 8-21"
      end
    
    elseif str:find("GPS%p?%s?1%p2") or str:find("за мэрией Los") then
      if str:find("[Нн]изкие цены") then
        return "Низкие цены в «Мини-маркете 24/7» за мэрией LS | GPS 1-2"
      elseif str:find("[Бб]ольшие скидки в") then
        return "Большие скидки в «Мини-маркете 24/7» за мэрией LS | GPS 1-2"
      end
    elseif str:find("[Pp]ric[er]%s1%p25") then
      if str:find("Сухопутных Войск завезли новые рем") then
        return "В «24/7» у сухопутных войск завезли новые ремкомпл. | Price 1-25"
      end
    end

  elseif str:find("%s8%s?%p%s?21$") then
    -- debug("+", 2) -- Низкие цены на товар у Адм.Президента. GPS 8-21
    if str:find("Самые лучшие продукты только") then
      return "Самые лучшие продукты только в магазине «24/7» у АП | GPS 8-21"
    elseif str:find("Сам[ыv]е лучшие цены") or str:find("ЛУЧШИЕ ЦЕНЫ") then
      return "Самые лучшие цены в магазине «24/7» у АП | GPS 8-21"
    elseif str:find("Низкие цены на товар") then
      return "Низкие цены на товар в магазине «24/7» у АП | GPS 8-21"
    end  
  
  elseif str:find("[Хх]лопушка") or str:find("[Pp]rice[(%s)|(%p)]12$") or str:find("[Pp]rice%s12%p7") then
    --debug("+", 2)
    if str:find("Магазин пиротехники") then
      if str:find("[Пп]родам") then
        return "Продам пиротехнику «Хлопушка» - Price 12-7 | "..get_price(str, trade_type(str))
      end
      return "Магазин пиротехники «Хлопушка» в Palomino Creek! Price 12-7"
    elseif str:find("Красочные салюты только в") then
      return "Красочные салюты только в пиротехнике Palomino Creek | Price 12-7"
    end 

  elseif str:find("[Pp]rice[(%s)|(%p)]12%p3$") then
    --debug("+", 2)
    if str:find("У тебя свадьба") then
      return "У тебя свадьба? Сделай её ярче с «Пиротехникой СФ». Price 12-3"
    elseif str:find("Самые низкие цены в пиротехнике") then
      return "Самые низкие цены в пиротехнике SF «Вспышка». | Price 12-3"
    elseif str:find("Купи красочный фейверк") then
      return "Купи красочный фейверк в пиротехнике «Вспышка» | Price 12-3"
    end 
  elseif str:find("[Bb]if") and str:find("[Bb]rid") then
    if str:find("233") then
      biz_loc = "GPS 8-233"
    else
      biz_loc = "Price 9-5"
    end
    if str:find("ГОРЯЧИЕ") then
      if srt:find("ГОРЯЧИЕ") then hot_bb = "ГОРЯЧИЕ" else hot_bb = "" end
        return "В отеле «Biffin Bridge» "..hot_bb.." номера за "..get_hotel_price(str).."$/сутки! | "..biz_loc
    elseif str:find("привести любовницу") then
      return "Некуда привести любовницу? Вам в Отель «Biffin Bridge»! GPS 8-158"
    elseif str:find("Элитные тайские") then
      return "Элитные тайские масажистки в Отеле «Biffin Bridge» | GPS 8-158"
    elseif str:find("VIP%pномера") then
      return "VIP-номера в Hotel «Biffin Bridge» SF - "..get_hotel_price(str).."$/ночь! | "..biz_loc
    elseif str:find("свободные места") then
      return "В отеле «Biffin Bridge» есть свободные места | "..biz_loc
    end
    
  elseif str:find("[Пп]иро") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p%s?73%p?%s?") then -- GPS 8-73
    if str:find("Пальцы на месте") then
      return "Пальцы на месте, не выбитый глаз? Пиротехника ждет Вас | GPS 8-73"
    elseif str:find("А я сейчас") then
      return "А я сейчас вам покажу, где приобрести пиротехнику | GPS 8-73"
    elseif str:find("обугляться") then
      return "Кожа не лопнет, не обугляться кости, заходи в гости! | GPS 8-73"
    end
    return "Ни разу не покупал пиротехнику? Фатальная ошибка | GPS 8-73"

    
  -- elseif not str:find("[кК]расот") and str:find("[Бб]анк") then -- GPS 8-73
    
  --   if str:find("[BbбБ][aа][rр]") then
  --     if str:find("самая низкая комиссия") then
  --       return "Банк «Las Barrancas»: самая низкая комиссия на переводы | GPS 6-5"
  --     -- elseif str:find("льная комиссия 0.7") then
  --     --   return "Быстрые и выгодные переводы в банке «Las Barrancas» | GPS 6-5"
  --     elseif str:find("Быстрые и выгодные переводы") then
  --       return "Быстрые и выгодные переводы в банке «Las Barrancas» | GPS 6-5"
  --     elseif str:find("Самая низкая комиссия") then
  --       return "Самая низкая комиссия на переводы в банке Las Barrancas | GPS 6-5"
  --     end
  --   elseif str:find("[Pp]al") and str:find("[Gg][Pp][Ss]") or str:find("банке Palomino Creek") then
  --     if str:find("переводы 0.8") then
  --       return "Комиссия на переводы 0.8# только в Банке Palomino Creek | GPS 6-3"
  --     elseif str:find("Комиссия 0.8 процента") then
  --       return "Комиссия 0.8 процента в банке в д. Palomino Creek | GPS 6-3"
  --     elseif str:find("маленький про[ц]?ент на переводы") then
  --       return "Низкий процент на переводы в банке в д. Palomino Creek | GPS 6-3"
  --     elseif str:find("%pбесплатный вход") then
  --       return "В банке Palomino Creek низкий процент и безплатный вход | GPS 6-3"
  --     elseif str:find("[Вв]ыгодные условия мале[н]?ький") then
  --       return "Выгодные условия, низкий процент в банке Palomino Creek | GPS 6-3"
  --     elseif str:find("над[ёе]жность и выгода") then
  --       return "Банк Palomino Creek: надёжные и выгодные переводы | GPS 6-3"
  --     end
  --   elseif str:find("[Aa]ngel") and str:find("[Gg][Pp][Ss]") then
  --     if str:find("Самые низкие комиссии") then
  --       return "Самые низкие комиссии на переводы в банке Angel Pine! | GPS 6-4"
  --     end
  --   else
  --     print("{cc0000}ERROR 2:{b2b2b2}", str)
  --     result = "ERROR"
  --   end
  --   return result

    -- ВЫБОРЫ и ПАРТИИ

  elseif str:find("Izquierdo") then
    if str:find("Рождество с Либералами Справедливости") then
      return "Рождество с Либералами Справедливости. Кандидат: Lyle Izquierdo"
    elseif str:find("16 декабря! Кандидат") then
      return "16 декабря! Кандидат: Lyle Izquierdo! Либеральная Справедливость!"
    elseif str:find("на президентских выборах") then
      return "Голосуйте на президентских выборах 16-го декабря за Lyle Izquierdo."
    elseif str:find("16 декабря. Справедливость") then
      return "16 декабря! Справедливость и Развитие! Кандидат: Lyle Izquierdo"
    end
  elseif str:find("Francois") then
    if str:find("декабря голосуй за Союз правых сил") then
      return "16 декабря голосуй за Союз правых сил. Кандидат: Noah Francois."
    elseif str:find("мы разберёмся") then
      return "Нас 25 тысяч и мы разберёмся. Голосуй за Noah Francois"
    elseif str:find("и мы идём голосовать") then
      return "Нас 25 тысяч и мы идём голосовать! Кандидат: Noah Francois"
    elseif str:find("олосуй или проиграешь") then
      return "Голосуй или проиграешь. Кандидат от правых сил: Noah Francois"
    elseif str:find("Поддержи Союз правых сил") then
      return "Поддержи Союз правых сил и старую гвардию. Кандидат: Noah Francois"
    end
  elseif str:find("Smart Piratov") then
    if str:find("путь реформ вместе") then
      if str:find("16 дек") then
        return "Продолжим путь реформ вместе? Голосуй за Smart Piratov 16 декабря"
      else
        return "Продолжим путь реформ вместе? Голосуй за Smart Piratov!"
      end
    end
  elseif not str:find("[Сс][им][ми] [Кк]арту") and not str:find("у моря") and not str:find("sim") and not str:find("[Сс][иИ][Мм]") and not str:find("S[Ii][Mm]") and str:find("[^(мед)]карт") or str:find("Cart") or str:find("Kart") or str:find("cart") or str:find("kart") then
    -- debug("Kart eb...", 4)
    return vechicles(str, trade_type(str), "автомобиль", "Kart")
  elseif str:find("с[у]?[им][им]ку") or str:find("[Сс][иИ][Мм][(%p)|(карту)]") or str:find("[Сс][Мм][Ии] [Кк]арту") or str:find("[Ss][Iil]m") or str:find("%s[Сс]им%s") or str:find("SIM") or str:find("смку") or str:find("одам номер") or str:find("4 значный номер") then -- ДРУГОЕ
    --формата "XY-XXXX".
    if str:find("[Кк][у]?п[а]?л[д]?ю") and str:find("[Кк]расив") then
      return "Куплю SIM-карту красивого формата. "..get_price(str, trade_type(str))
    elseif str:find("4 значный номер") or str:find("4%p[чх]%s?%p?значного") then
      return "Куплю SIM-карту 4-х значного формата. Цена договорная."
    end
    sim_format = get_simcard_fmt(str)
    if sim_format == nil then
      result = "(AD_SIM_0): {BF4E8D}Мне не удалось определить сим-карту, пиши сам в поле:"
    else
      result = "Продам SIM-карту формата «"..sim_format:upper().."». "..get_price(str, trade_type(str))
    -- ДРУГОЕ
    end
    return result
    
  elseif str:find("[АаAa][Зз][СсCc]") or str:find("[Aa][Zz][Ss]") or str:find("заправочную станцию") then
    if str:find("[Цц]ентр") and str:find("[ЛлLl][ВвVv]") then
      if str:find("[Ff]uel 17") then
        if str:find("Вин Дизель рекомендует") then
          return "Вин Дизель рекомендует АЗС «Центральная LV» 1л. - 25$ | Fuel 17"
        elseif str:find("топливо по 5%$") then
          return "На АЗС №17 \"Центральная ЛВ\" топливо по 5$/1л. | Fuel 17"
        elseif str:find("лей ей полный ба") then
          return "Залей ей полный бак на АЗС «Центральная LV». | Fuel 17"
        end
        return "На АЗС №17 \"Центральная ЛВ\" дизель по 25$ за 1л. | Fuel 17"
      else
        return "Продам АЗС «Центральная ЛВ». "..get_price(str, trade_type(str))
      end
    
    elseif str:find("[Сс]е[р]?вер") and str:find("[(ЛВ)|(Вентурас)]") and str:find("%№1") then
      if str:find("[Пп]родам") then
        return "Продам «Северную АЗС ЛВ №1» в ш. Las Venturas. "..get_price(str, trade_type(str))
      elseif str:find("Заправь авто качественным топливом") then
        return "Заправься качественным топливом на «Северной АЗС ЛВ №1» | Fuel 13"
      elseif str:find("Лучшее топливо") then
        return "Лучшее топливо в Федерации на «Северной АЗС ЛВ №1» | Fuel 13"
      elseif str:find("Самое качeственное топливо за 5") then
        return "Самое качeственное топливо за 5$ на «Северной АЗС LV №1». Fuel 13"
      end
    elseif str:find("[Сс]ухопут") then
      if str:find("[Пп]родам") then
        return "Продам Западную АЗС ЛВ» в ш. Las Venturas. "..get_price(str, trade_type(str))
      elseif str:find("Заправь малышке полный бак") then
        return "Заправь малышке полный бак на АЗС у сухопутных войск! | Fuel - 11"
      end
    elseif str:find("Северной АЗС СФ") or str:find("АЗС Северная СФ") then
      if str:find("[Пп]родам") then
        return "Продам «Северную АЗС СФ» в ш. San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("Лучшее топливо в [Фф]") then
        return "Лучшее топливо в Федерации на «Северной АЗС СФ» | Fuel - 6"
      elseif str:find("Лучшее топливо только") then
        return "Лучшее топливо только на «АЗС Северная СФ» | Fuel - 6"
      end
      -- Продам "Северную АЗС ЛВ №1" в ш. Лас-Вентурас. Цена: договорная
    elseif str:find("ontgomery") and str:find("[Ff]uel") then
      if str:find("лучшее топливо") then
        return "Самое лучшее топливо на АЗС «Montgomery» | Мы около GPS 5-6"
      elseif str:find("Лучшее топливо") then
        return "Лучшее топливо на АЗС «Flint County» 1 литр - 50$! GPS 8-66!"
      end
    elseif str:find("[Ff]lint") then
      if str:find("топливо всего за") then
        return "На АЗС №9 в о. Flint County топливо всего за $5 за 1 литр! Fuel 9"
      elseif str:find("[Пп]родам") then
        return "Продам «АЗС Flint County» в о. Flint. "..get_price(str, trade_type(str))
      end
    elseif str:find("[Ee]l [Qq]ueb") then
      if str:find("[Дд]ешевое и [Кк]ачественное топливо") then
        return "АЗС «El Quebrados» - дешевое и качественное топливо! | Fuel - 8"
      elseif str:find("[Лл]учшее топливо в [фФ]едерации") then
        return "АЗС «El Quebrados» - лучшее топливо в федерации! | Fuel - 8"
      end
    elseif str:find("Заводская") then
      if str:find("Заправься быстро и качественно") then
        return "Заправься быстро и качественно на АЗС «Заводская» | GPS 5-4"
      end
    elseif str:find("Южная") or str:find("Южном") then
      if str:find("у нас лучша") then
        return "Лучшее топливо в АЗС «Южная» - у нас лучшая цена | Fuel - 4"
      elseif str:find("Заправь авто качественным") then
        return "Заправь авто качественным топливом в АЗС «Южная» | Fuel - 4"
      elseif str:find("Заправь свой трактор") then
        return "Заправь свой трактор на АЗС «Южная» | Fuel - 4"
      elseif str:find("Хочешь гонять как Vin Dizel") then
        return "Хочешь гонять как Vin Dizel? Заправляйся на АЗС «Южная»: Fuel - 4"
      end
    elseif str:find("[fF]uel 13") then
      if str:find("Покупаем, заливаем") then
        return "Топливо по 5$ за литр на АЗС ЛВПД. Покупаем, заливаем! | Fuel 13"
      end
    elseif str:find("[Пп]рези[н]?дента") then
      if str:find("10л") then
        return "Лучшее топливо на АЗС у Админ. Президента! | 10л-50$ | Fuel 1"
      elseif str:find("1л%p?(.-)%s?%p%s?5%$") then
        return "Лучшее топливо на АЗС у Администрации Президента | 1л-5$ | Fuel-1"
      elseif str:find("[Пп]родам") then
        return "Продам АЗС возле Администрации Президента. "..get_price(str, trade_type(str))
      end
      return "Лучшее топливо только на АЗС у Администрации Президента: 1л.-5$"
    elseif str:find("[Кк][Уу][Пп][Лл][Юю]") then
      return string.format("Куплю автозаправочную станцию%s. %s", get_location(str), get_price(str, trade_type(str)))
    end

    
  elseif str:find("инко") and str:find("[Тт][Цц][Лл][Вв]") and str:find("одам") then
    return action[trade_type(str)].."магазин одежды \"Binco\" в ТЦЛВ. "..get_price(str, trade_type(str))
  elseif str:find("мебел") then
    w_location = location(str, "мебель", "n", "n")
    return w_location
    -- ==аксессуары== --
  elseif str:find("[^аА][КкK][оoСс][сcОо][с]?[уyаa]") or str:find("%sкос$") or str:find("КОС[УА]") then
    return action[trade_type(str)].."аксессуар «Коса». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]лазм") and str:find("[Щщ]ит") then
    return action[trade_type(str)].."аксессуар «Плазменный щит». "..get_price(str, trade_type(str))
  elseif str:find("[Щщ]ит") then
    return action[trade_type(str)].."аксессуар «Щит». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]олни[яию]") then
    return action[trade_type(str)].."аксессуар «Молния Зевса». "..get_price(str, trade_type(str))
  elseif str:find("[Нн]ун") and str:find("[Чч]аки") then
    return action[trade_type(str)].."аксессуар «Нунчаки». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]ира") and str:find("[Сс]унд") then
    return action[trade_type(str)].."аксессуар «Пиратский сундук». "..get_price(str, trade_type(str))
  elseif str:find("[кК]аме") and str:find("[Пп]леч") then
    return action[trade_type(str)].."аксессуар «Камера на плече». "..get_price(str, trade_type(str))
  elseif str:find("[Лл]ук") then
    return action[trade_type(str)].."аксессуар «Лук». "..get_price(str, trade_type(str))
  elseif str:find("[чЧ]ереп") then
    return action[trade_type(str)].."аксессуар «Горящий череп». "..get_price(str, trade_type(str))
  elseif str:find("[Зз]л[ао][яйе]") and str:find("[Пп][еЕ]чен") then
    return action[trade_type(str)].."аксессуар «Злая печенька». "..get_price(str, trade_type(str))
  elseif str:find("[Бб]омб") and str:find("[Фф][еи]т[ие]") then
    return action[trade_type(str)].."аксессуар «Большая бомба с фитилём». "..get_price(str, trade_type(str))
  elseif str:find("[Гг]ол[л]?а") and str:find("[Шш]турв") then
    return action[trade_type(str)].."аксессуар «Голландский штурвал». "..get_price(str, trade_type(str))
  elseif str:find("[Дд]окт") and str:find("[Сс]тр[эе]") or str:find("[Пп]лащ") then
    return action[trade_type(str)].."аксессуар «Плащ Доктора Стрэнджа». "..get_price(str, trade_type(str))
  elseif str:find("[Лл]азер") and str:find("[Нн]аруч") then
    return action[trade_type(str)].."аксессуар «Наручные лазерные резаки». "..get_price(str, trade_type(str))
  elseif str:find("[Лл]азер") then
    return action[trade_type(str)].."аксессуар «Лазер». "..get_price(str, trade_type(str))
  elseif str:find("[Пп][ОАоа][пП][Уу][Гг]") then
    return action[trade_type(str)].."аксессуар «Попугай». "..get_price(str, trade_type(str))
  elseif str:find("[Тт]ыкв[ау]") then
    return action[trade_type(str)].."аксессуар «Тыква». "..get_price(str, trade_type(str))
  elseif str:find("[Тт]епловиз") then
    return action[trade_type(str)].."аксессуар «Тепловизор». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]огти") then
    return action[trade_type(str)].."аксессуар «Когти». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]а[ск][кс][ау] [ЕеЁё]жика") then
    return action[trade_type(str)].."аксессуар «Маска ёжика». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]ч[её]л[к]?а") then
    return action[trade_type(str)].."аксессуар «Пчела». "..get_price(str, trade_type(str))
  elseif str:find("[бБ]ел[уа][яю] [Гг]итар[ау]") then
    return action[trade_type(str)].."аксессуар «Белая гитара». "..get_price(str, trade_type(str))
  elseif str:find("[чЧ][её]рн[уа][яю] [Гг]итар[ау]") then
    return action[trade_type(str)].."аксессуар «Чёрная гитара». "..get_price(str, trade_type(str))
  elseif str:find("[чЧ][её]рн[уа][яю] [Кк]епк[ау]") then
    return action[trade_type(str)].."аксессуар «Чёрная кепка». "..get_price(str, trade_type(str))
  elseif str:find("[Гг]итар[ау]") then
    return action[trade_type(str)].."аксессуар «Гитара». "..get_price(str, trade_type(str))
  elseif str:find("[Рр][эе]мбо") then
    return action[trade_type(str)].."аксессуар «Рэмбо». "..get_price(str, trade_type(str))
  elseif str:find("[Нн]имб") then
    return action[trade_type(str)].."аксессуар «Нимб». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]юкза[кг]") and str:find("[Рр]адио%s?модул") or str:find("[Рр]адиомодуль") then
    return action[trade_type(str)].."аксессуар «Рюкзак с радиомодулем». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]юкза[кг]") and str:find("[GgГг][TtТт][AaАа]") then
    return action[trade_type(str)].."аксессуар «Рюкзак из GTA III». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]адиоакт") and (str:find("[Рр]анец") or str:find("[Рр]юкзак")) then
    return action[trade_type(str)].."аксессуар «Радиоактивный ранец». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]юкзак") and str:find("[Сс]кан") then
    return action[trade_type(str)].."аксессуар «Рюкзак с модулем сканирования». "..get_price(str, trade_type(str))
  elseif str:find("[Сс]ет") and str:find("[Кк]лоу") then
    return action[trade_type(str)].."аксессуар «Сет клоуна». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]ортат") and str:find("[Кк][оа]лон") or str:find("[Кк]олонк[уа]") then
    return action[trade_type(str)].."аксессуар «Портативная колонка на плече». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]юкзак") and str:find("[Нн]ано") then
    return action[trade_type(str)].."аксессуар «Рюкзак с нано-ускорителем». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]юкзак") and str:find("[Кк]расно%p?%s?[Бб]елый") then
    return action[trade_type(str)].."аксессуар «Красно-белый рюкзак». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]юкзак") and str:find("[дД]жинс") then
    return action[trade_type(str)].."аксессуар «Джинсовый рюкзак». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]юкзак") and str:find("[Чч][ёе]рно%p?%s?[Бб]елый") then
    return action[trade_type(str)].."аксессуар «Чёрно-белый рюкзак». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]иниган") then
    return action[trade_type(str)].."аксессуар «Миниган». "..get_price(str, trade_type(str))
  elseif str:find("[Вв]олк") and str:find("[Сс]трит") then
    return action[trade_type(str)].."аксессуар «Волк с Уолл-стрит». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]рылья [Дд]ьявола") or str:find("[Кк]рылья [Дд]емона") then
    return action[trade_type(str)].."аксессуар «Крылья дьявола». "..get_price(str, trade_type(str))
  elseif str:find("[Тт]урбо%s?[кК]рылья") then
    return action[trade_type(str)].."аксессуар «Турбо-крылья с вентилятором». "..get_price(str, trade_type(str))
  elseif str:find("[Оо]гнен") or str:find("[Шш]ар") then
    return action[trade_type(str)].."аксессуар «Рога с огненным шаром». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]р[ыи]лья [Фф]е") then
    return action[trade_type(str)].."аксессуар «Крылья Феи». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]остюм [Аа]нг") or str:find("[Кк]рылья [Аа]нг") or str:find("[Аа]нгельский [кК]остюм") then
    return action[trade_type(str)].."аксессуар «Костюм Ангела». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]остюм [Дд]ья") then
    return action[trade_type(str)].."аксессуар «Костюм Дьявола». "..get_price(str, trade_type(str))
  elseif str:find("[Зз]аячьи [Уу]ш[к]?и") or str:find("[Уу]ши [Зз]айца") or str:find("[Уу]шки [Зз]айки") then
    return action[trade_type(str)].."аксессуар «Заячьи уши». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]орон[ао]вирус") then
    return action[trade_type(str)].."аксессуар «Коронавирус». "..get_price(str, trade_type(str))
  elseif str:find("[Аа]рб[ао]лет") then
    return action[trade_type(str)].."аксессуар «Арбалет». "..get_price(str, trade_type(str))
  elseif str:find("[Шш]ляп[ау]") and str:find("[Аа]втобусника") then
    return action[trade_type(str)].."аксессуар «Шляпа автобусника». "..get_price(str, trade_type(str))
  elseif str:find("[ЭэЕе]кз") and str:find("[Рр]ук") then
    return action[trade_type(str)].."аксессуар «Экзо-рука». "..get_price(str, trade_type(str))
  elseif not str:find("[Pp]rice") and str:find("[ЕеЭэ]кзо") and str:find("[Сс]к[еи]лет") then
    return action[trade_type(str)].."аксессуар «Экзоскелет». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]одмиг") and str:find("[Сс]май") then
    return action[trade_type(str)].."аксессуар «Подмигивающий смайлик». "..get_price(str, trade_type(str))
  elseif str:find("[Пп][Нн][Вв]") then
    return action[trade_type(str)].."аксессуар «Прибор ночного видения». "..get_price(str, trade_type(str))
  elseif str:find("[Бб]ургер") and str:find("[Аа]кс") then
    return action[trade_type(str)].."аксессуар «Бургер». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]ояс") and str:find("[Ии]нстр") then
    return action[trade_type(str)].."аксессуар «Пояс с инструментами». "..get_price(str, trade_type(str))
  elseif str:find("[Тт]орт%sна%sголов") then
    return action[trade_type(str)].."аксессуар «Торт на голову». "..get_price(str, trade_type(str))
  elseif str:find("[Шш]айб") then
    return action[trade_type(str)].."аксессуар «Маска-Шайба». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]опь[её]") then
    return action[trade_type(str)].."аксессуар «Копьё». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]вадр[оа][кп]о[п]?тер") then
    return action[trade_type(str)].."аксессуар «Квадрокоптер». "..get_price(str, trade_type(str))
  elseif str:find("[Аа][Кк][Кк]?умулятор") then
    return action[trade_type(str)].."аксессуар «Аккумулятор». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]остюм [Фф]еи") then
    return action[trade_type(str)].."аксессуар «Костюм феи». "..get_price(str, trade_type(str))
  elseif str:find("[Вв]олш") and str:find("[Пп]ал") then
    return action[trade_type(str)].."аксессуар «Волшебная палочка». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]остюм [Дд]ем") then
    return action[trade_type(str)].."аксессуар «Костюм демона». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]рест") then
    return action[trade_type(str)].."аксессуар «Крест». "..get_price(str, trade_type(str))
  elseif str:find("[ОоАа]г[н]?[еи]м[её]т") or str:find("огнет") then
    return action[trade_type(str)].."аксессуар «Огнемет». "..get_price(str, trade_type(str))
  elseif not str:find("резин") and str:find("[Уу]див") or str:find("[Вв]згл") then
    return action[trade_type(str)].."аксессуар «Удивлённый взгляд». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]осм") and str:find("[Рр]ю[кд]зак") then
    return action[trade_type(str)].."аксессуар «Космический рюкзак». "..get_price(str, trade_type(str))
  elseif str:find("[Аа]рмейский") and str:find("[Рр]ю[кд]зак") then
    return action[trade_type(str)].."аксессуар «Армейский рюкзак». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]ил[АаУу]") then
    return action[trade_type(str)].."аксессуар «Пила». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]олюч(.+)%s[Бб]ит") then
    return action[trade_type(str)].."аксессуар «Бита с гвоздями». "..get_price(str, trade_type(str))
  elseif str:find("[Шш]урупо") then
    return action[trade_type(str)].."аксессуар «Шуруповёрт». "..get_price(str, trade_type(str))
  elseif str:find("[Сс]кейт") then
    return action[trade_type(str)].."аксессуар «Скейт». "..get_price(str, trade_type(str))
  elseif str:find("[Рр]ефлектор") then
    return action[trade_type(str)].."аксессуар «Рефлектор». "..get_price(str, trade_type(str))
  elseif str:find("[Гг]олов[АаУу]") and str:find("[Пп]ришель") then
    return action[trade_type(str)].."аксессуар «Голова пришельца». "..get_price(str, trade_type(str))
  elseif str:find("[Пп]ротивови") and str:find("[Мм]аск") then
    return action[trade_type(str)].."аксессуар «Противовирусная маска». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]аск") and str:find("[Ии]нопл") then
    return action[trade_type(str)].."аксессуар «Маска инопланетянина». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]ас") and str:find("[Мм]арс") then
    return action[trade_type(str)].."аксессуар «Маска марсианина». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]ас") and str:find("[Сс]вар") then
    return action[trade_type(str)].."аксессуар «Маска сварщика». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]атан") then
    return action[trade_type(str)].."аксессуар «Катана». "..get_price(str, trade_type(str))
  elseif str:find("[Мм]еч[^т]") and not str:find("роймат") and not str:find("аген") and not str:find("[gG][pP][sS]")  then
    return action[trade_type(str)].."аксессуар «Меч». "..get_price(str, trade_type(str))
  elseif str:find("[Бб]анан") or str:find("[Bb]anan") then
    return action[trade_type(str)].."аксессуар «Банан». "..get_price(str, trade_type(str))
  elseif str:find("[Ии]нопл") and str:find("[Кк]рист") then
    return action[trade_type(str)].."аксессуар «Инопланет. кристалл-хамелеон». "..get_price(str, trade_type(str))
  elseif str:find("[ЕеЁё]лк") and str:find("[Сс]пин") then
    return action[trade_type(str)].."аксессуар «Ёлка на спину». "..get_price(str, trade_type(str))
  elseif str:find("[Нн]ового") and str:find("[ЕЁеё]лк") then
    return action[trade_type(str)].."аксессуар «Новогодняя ёлка». "..get_price(str, trade_type(str))
  elseif str:find("[Нн]ового") and str:find("[Шш]ап") or str:find("[Шш]апку нг") then
    return action[trade_type(str)].."аксессуар «Новогодняя шапка». "..get_price(str, trade_type(str))
  elseif not str:find("[Оо]руж") and str:find("[БбРр][рб]он") and not str:find("[Ss]moke") and not str:find("[AaАа][MmМм][MmМм][OoUuОоУу]") then
    return action[trade_type(str)].."аксессуар «Бронежилет». "..get_price(str, trade_type(str))
  elseif not str:find("[Оо]руж") and not str:find("салон") and str:find("[Жж][ие]л[кд]?[д]?ет") or str:find("[Жж]иет") then
    return action[trade_type(str)].."аксессуар «Жилетка». "..get_price(str, trade_type(str))
  elseif not str:find("[Cc]lub") and str:find("[Сс]иг") or str:find("[Сс]иа[г]?ру") or str:find("[Сс]егару") then
    return action[trade_type(str)].."аксессуар «Сигарета». "..get_price(str, trade_type(str))
  elseif str:find("[Сс]абл[юя]") then
    return action[trade_type(str)].."аксессуар «Сабля». "..get_price(str, trade_type(str))
  elseif str:find("[Чч]ас[иы]") and str:find("[Рр]озов") or str:find("[Бб][оа][рд][др]?ов[ыи]е") then
    return action[trade_type(str)].."аксессуар «Бордовые часы». "..get_price(str, trade_type(str))
  elseif str:find("[Чч]ас[иы]") and str:find("[Сс][е]?р[еє]б") or str:find("[Сс]ебердняыйе") or str:find("часы цвет серые") then
    return action[trade_type(str)].."аксессуар «Серебряные часы». "..get_price(str, trade_type(str))
  elseif str:find("[Чч]ас[иы]") then
    return action[trade_type(str)].."аксессуар «Часы». "..get_price(str, trade_type(str))
  elseif str:find("[Зз]омбоя[щш]и") then
    return action[trade_type(str)].."аксессуар «Зомбоящик». "..get_price(str, trade_type(str))
  elseif str:find("[Кк]рош") then
    return action[trade_type(str)].."аксессуар «Маска Кроша». "..get_price(str, trade_type(str))
  elseif str:find("[Нн]асос") then
    return action[trade_type(str)].."аксессуар «Насос». "..get_price(str, trade_type(str))
  elseif str:find("[Зз]олот") and str:find("[Кк]увал") then
    return action[trade_type(str)].."аксессуар «Золотая кувалда». "..get_price(str, trade_type(str))
  elseif str:find("[Лл]унтик") then
    return action[trade_type(str)].."аксессуар «Маска Лунтика». "..get_price(str, trade_type(str))
  -- ==другое==
  
  elseif str:find("муж[чщ]и") or str:find("парн[яе][м]?") or str:find("мужа") or str:find("мужем") then
    if str:find("%sсо$") then
      return "Ищу мужчину для серьёзных отношений. Жду звонков."
    elseif str:find("создания семьи") then
      return "Познакомлюсь с хорошим мужчиной для создания семьи. Звоните!"
    elseif str:find("будущим мужем") then
      return "Познакомлюсь с будущим мужем. Звоните!"
    elseif str:find("парня для серь[её]з") then
      return "Позналюсь с парнем для серьёзных отношений. Позвони мне!"
    elseif str:find("[Пп]ознакомлюсь с парнем") then
      return "Познакомлюсь с парнем. "..get_about_ys(str)
    elseif str:find("с богатым") then
      if str:find("исключительно") then
        return "Познакомлюсь исключительно с богатым мужчиной. Звоните."
      end
      return "Познакомлюсь с богатым мужчиной. Жду звонков."
    end
    return "Познакомлюсь с мужчиной. "..get_about_ys(str) --Вступлю в Семью
  elseif str:find("[Ff]am[ia]ly") or str:find("[Сс]ем[ь]?[яью]") or str:find("[^%p][Cc]lan") and not str:find("[Вв]ступлю") or str:find("поисках дальн") then
    if str:find("[Gg]oldberg") then
      if str:find("дальних") then
        return "Семья Goldberg Family ищет дальних родственников."
      else
        return "Мечтаешь быть крутым и богатым? Семья Goldberg поможет!"
      end
    elseif str:find("[Gg]odless") then
      if str:find("елочная работа") then
        return "Мелочная работа за большие деньги. Вступай в «Godless Clan»."
      elseif str:find("забудешь о бедности") then
        return "Вступив в «Godless Clan», ты забудешь о бедности и одиночестве."
      elseif str:find("Хочешь жить в бедности") then
        return "Хочешь жить в бедности? Фатальная ошибка! Вступай: «Godless Clan»"
      end
    elseif str:find("[Gg]oldic") then
      if str:find("дальних") then
        return "Семья «Goldic Family» ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("[Cc]uadrado") then
      if str:find("Ищем родственников только") then
        return "Ищем родственников только в «Cuadrado Family». Звоните."
      end
    elseif str:find("[Ss]ilantev") then
      if str:find("дальних") then
        return "Семья «Silantev» ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("Kane") then
      if str:find("дальних") then
        return "Семья Kane ищет дальних родственников. Ждём звонков!"
      elseif str:find("Хочешь иметь много денег") then
        return "Хочешь иметь много денег? Тогда тебе в семью Kane!"
      end
    elseif str:find("[Tt]empest") then
      if str:find("дальних") then
        return "Семья Tempest Family ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("Atlas") or str:find("ATLAS") then
      if str:find("дальних") then
        return "Семья Atlas ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("Bazile") then
      if str:find("дальних") then
        return "Семья Bazile ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("Insolent") then
      if str:find("дальних") then
        return "Семья Insolent ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("Capone") then
      if str:find("дальни[хз]") then
        return "Семья Capone ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("York") then
      if str:find("дальних") then
        return "Семья York ищет дальних родственников. Ждём звонков!"
      elseif str:find("шь прописку в LS") then
        return "Нужны деньги? Хочешь прописку в LS? Семья York поможет. Звони!"
      elseif str:find("Идет набор в семью") then
        return "Идет набор в семью York! Мы ждем тебя!"
      end
    elseif str:find("Caution") then
      if str:find("дальних") then
        return "Семья Caution ищет дальних родственников. Ждём звонков!"
      end
    elseif str:find("[Tt]aties") then
      if str:find("дальних") then
        return "Семья Taties ищет дальних родственников! Звоните!"
      end
    elseif str:find("[Pp]lanchik") then
      if str:find("дорогие машины") then
        return "Хочешь дорогие машины? Много денег? Вступай в «Planchik Family»"
      elseif str:find("крутые машины") then
        return "Хочешь крутые машины? Большие премии? Тебе в «Planchik Family»"
      end
    elseif str:find("[Bb]lack") then
      return "Хочешь иметь стабильный заработок? Семья Black ждет именно тебя!"
    elseif str:find("[Ss]offord") then
      if str:find("[Хх]очешь заработать") then
        return "Хочешь заработать? Тогда тебе к нам в семью Sofford."
      elseif str:find("реально крутую") then
        return "Хочешь в реально крутую семью? Тебя ждут в Sofford."
      elseif str:find("очешь любви и ласки") then
        return "Хочешь любви и ласки? Тогда тебе в семью сказки Sofford!"
      end
    elseif str:find("[Ии]щ[ую] семью$") or str:find("[Вв]ступлю в .+ семью") or str:find("[Вв]ступлю в семью") or str:find("вступить в семью") or str:find("Ищу семью.") or str:find("поисках дальн") then
      return "Ищу дальних родственников. Позвоните мне!"
    end
  elseif str:find("дв[а]?[о]?кат") then
    if str:find("[LlЛл][VvВв]") then
      return "От мэрии ш. Las Venturas работает опытный адвокат. Звоните."
    end
    return "От мэрии "..get_location(str):gsub(" в ", "").." работет опытный адвокат. Звоните."
  elseif str:find("ц[еи]нз[её]р") or str:find("ЦЕНЗ[ЕЁ]Р") then
    return "От мэрии "..get_location(str):gsub(" в ", "").." работет лицензёр. Звоните."
  elseif str:find("[Вв]рач") then
    if str:find("[LlЛл][VvВв]") or str:find("[LlЛл][AaАа][SsСс]") then
      return "От больницы ш. Las Venturas работает опытный врач. Звоните!"
    elseif str:find("[LlЛл][SsСс]") or str:find("[LlЛл][OoОо][SsСс]") then
      return "От больницы ш. Los Santos работает опытный врач. Звоните!"
    elseif str:find("[СсSs][ФфFf]") or str:find("[СсSs][АаAa][НнNn]") then
      return "От больницы ш. San Fierro работает опытный врач. Звоните!"
    end
  elseif str:find("[Мм]ед%s?карты") then
    if str:find("[LlЛл][VvВв]") or str:find("[LlЛл][AaАа][SsСс]") then
      return "Больница LV круглосуточно выдает медкарты. GPS 3-14"
    elseif str:find("[LlЛл][SsСс]") or str:find("[LlЛл][OoОо][SsСс]") then
      return "Больница LS круглосуточно выдает медкарты. GPS 3-12"
    elseif str:find("[СсSs][ФфFf]") or str:find("[СсSs][АаAa][НнNn]") then
      return "Больница SF круглосуточно выдает медкарты. GPS 3-13"
    end  
  elseif str:find("портзал") or str:find("СПОРТЗАЛ") or str:find("боев") or str:find("зале") or str:find("отпор") or str:find("искусс") or str:find("бокс") or str:find("абонементы") or str:find("тзал") or str:find("стиль боя") or str:find("спорт") or str:find("Джеки Чан") or str:find("[Пп]одкач") or str:find("качаться") or str:find("%s[Зз]ал%p?%s") or str:find("[Кк]ачалк") then
    return location(str, "спортзал", "n", "n")
  
  elseif str:find("[Пп]родам%s%d+%s[(цена)|(свата)]") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%sи%s%d+") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%p%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%p%d+%p%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам %d+ %d%p%dкк") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%sза") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%s%d+кк$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп][рР][оО]дам%s%d+%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп][рР][оО]дам%s%d+%p%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%s%W$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам %d+ %d+ цена") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам %d+ %d+ %d+%p?$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам %d+ %d+ %d+%s%W") then
    return clothes(str, trade_type(str))
  elseif str:find("%d+%ssell$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Ss]ell %d+ %W-$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Кк]у[п]?л[юб]%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("^%d+%s%d+%sкуплю$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Кк]упл[юб]%s%d+%s") then
    return clothes(str, trade_type(str))
  elseif str:find("[Кк]упл[юб]%s%d+%p") then
    return clothes(str, trade_type(str))
  elseif str:find("[Bb]uy%s%d+") then
    return clothes(str, trade_type(str))
  elseif str:find("[Пп]родам%s%d+%s[^(по)|^(скин)|^(скины)]") and #str:match("[Пп]родам%s(%d+)%s") > 3 then
    if #str:match("[Пп]родам%s(%d+)%s") > 3 then
      return "Продам SIM-карту формата «"..get_simcard_fmt(str):upper().."». "..get_price(str, trade_type(str))
    end
  elseif str:find("[Кк]упл[д]?[юб]%s%d+%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Кк]упл[юб]%s%d+,%d+,%d+") then
    return clothes(str, trade_type(str))
  elseif not str:find("[Мм][а]?газ") and not str:find("скидки") and not str:find("[Бб]из") and not str:find("[Нн]авигац") and str:find("[Оо]д[еж]?[еж][д]?") or str:find("[СсCc][КкИи][Рр]?[ИиКк][Нн]") or str:find("%sски %d+") or str:find("skin") or str:find("костюм[ы]? [^(тел)]") or str:find("по[ш]?[иіi][вф]") or str:find("ПОШИВ") or str:find("бир[ко]") or str:find("шмот") or str:find("[Вв]уз[з]?и") or str:find("[рР]айдер") or str:find("[Бб]иг [Сс]мо") or str:find("[Bb]ig [Ss]mo") or str:find("[Шш]ахт[её]ра") or str:find("[Дд]жиз[з]?и") or str:find("[Мм]ясн") then
    debug("Раздел: Продажа скинов\n"..str, 2)
    if str:find("[Кк]лоун") then
      return action[trade_type(str)].."одежду с биркой №264. "..get_price(str, trade_type(str))
    elseif str:find("[Дд]жиз[з]?и") then
      return action[trade_type(str)].."одежду с биркой №296. "..get_price(str, trade_type(str)) 
    elseif str:find("[Сс]вит") then
      return action[trade_type(str)].."одежду с биркой №270. "..get_price(str, trade_type(str))
    elseif str:find("[Мм]ясник") then
      return action[trade_type(str)].."одежду с биркой №168 «Мясник». "..get_price(str, trade_type(str))
    elseif str:find("[Jj]izzy") then
      return action[trade_type(str)].."одежду с биркой №296. "..get_price(str, trade_type(str))
    elseif not str:find("[Бб]рон") and str:find("[Бб]иг [Сс]мо") or str:find("[Bb]ig [Ss]mo") then
      return action[trade_type(str)].."одежду с биркой №269. "..get_price(str, trade_type(str))
    elseif str:find("[Бб]иг [Сс]мо") and ("[Бб]рон") or str:find("[Bb]ig [Ss]mo") and ("[Бб]рон") then
      return action[trade_type(str)].."одежду с биркой №149. "..get_price(str, trade_type(str))
    elseif str:find("[Вв]уз[з]?и") then
      return action[trade_type(str)].."одежду с биркой №294. "..get_price(str, trade_type(str))
    elseif str:find("[Сс]ват") then
      return action[trade_type(str)].."одежду с биркой №285. "..get_price(str, trade_type(str))
    elseif str:find("[Рр]оллер") then
      return action[trade_type(str)].."одежду с биркой №99. "..get_price(str, trade_type(str))
    elseif str:find("[Шш]ахт[её]ра") then
      return action[trade_type(str)].."одежду с биркой №16. "..get_price(str, trade_type(str))
    -- elseif str:find("[Рр]айдер") and str:find("[Кк]епк") then
    --   return action[trade_type(str)].."одежду с биркой №271. "..get_price(str, trade_type(str))
    elseif str:find("[Рр]айдер") then
      return action[trade_type(str)].."одежду с биркой №271. "..get_price(str, trade_type(str))
    end
    return clothes(str, trade_type(str))
  elseif str:find("девуш") or str:find("дам[оу]") or str:find("женщину") or str:find("жен[уо]") then
    if str:find("создания семьи") then
      return "Ищу женщину для создания семьи. "..get_about_ys(str)
    elseif str:find("будущей женой") then
      return "Познакомлюсь с будущей женой. Звоните!. "..get_about_ys(str)
    elseif str:find("девуш") or str:find("дам") then
      if str:find("[зщ]ных отнош") or str:find("%sс%pо") then
        return "Познакомлюсь с девушкой для серьёзных отношений. "..get_about_ys(str)
      elseif str:find("своего сердца") then
        return "Ищу даму своего сердца. "..get_about_ys(str)
      else
        return "Познакомлюсь с девушкой. "..get_about_ys(str)
      end
    elseif str:find("жену") or str:find("женщину") then
      return "Ищу женщину для серьёзных отношений. О себе: при встрече"
    end
  elseif str:find("муж[чщ]и") or str:find("парня") or str:find("мужа") then
    if str:find("%sсо$") then
      return "Ищу мужчину для серьёзных отношений. Жду звонков."
    elseif str:find("создания семьи") then
      return "Познакомлюсь с хорошим мужчиной для создания семьи. Звоните!"
    end
    return "Познакомлюсь с мужчиной. "..get_about_ys(str) --Вступлю в Семью

  elseif str:find("ищ[ую][^т]") or str:find("И[щш][ую][^т]") or str:find("[Вв]ступлю в [Сс]емью") or str:find("[Вв]ступлю в фаму") or str:find("позвони мне") or str:find("еловек по имени") or str:find("[Вв] поисках") then
    -- debug("FIND:"..str, 1)
    if str:find("_") then str = str:gsub("_", " ") end
    if str:find("[ч]?елове[к]?[а]?") or str:find("игрока") or (str:find("позвони мне") and not str:find("альних")) or str:find("[Ии][шщ][ую]%s%w+%s%w+$") then
      debug(str, 1)
      if str:find("имен[(ем)|(и)]%s(%w+)%s(%w+)$") then
        first, last = str:match("имен.+%s(.+)%s(.+)$")
        print(first, last)
        -- debug("Find human, Pattern 1", 1)--\nFirst: "..first.."\nLast: "..last, 1)
        first, last = name_upper(first, last)
      elseif str:find("^%w+%s%w+%s") then
        first, last = str:match("^(%w+)%s(%w+)%s")
        -- debug("Find human, Pattern 2", 1)--\nFirst: "..first.."\nLast: "..last)
      elseif str:find("[(имени)|(ником)|(именем)|(імені)|(игрока)]%s%p?(%w+)%s(%w+)%p?%s?%p?") then
        -- debug("Find human, Pattern 3", 1)--\nFirst: "..first.."\nLast: "..last)
        if str:find("%w+%s[Пп]озв") then
          debug("P2, ID - 1", 1)
          first, last = str:match("[иі]мен[иі] (.+) (.+)%s[Пп]оз")
          if str:find("человека %w+") then
            first, last = str:match("человека (%w+) (%w+)")
          end
          
        elseif str:find("[иі]мен[иі] (%w+) (%w+)%sнапиши") then
          first, last = str:match("[иі]мен[иі] (%w+) (%w+)%sнапиши")
          debug("P2, ID - 2", 1)
        elseif str:find("[иі]мен[иі] (%w+) (%w+)%s[Сс]вяж") then
          first, last = str:match("[иі]мен[иі] (%w+) (%w+)%s[Сс]вяж")
          debug("P2, ID - 3", 1)
        elseif str:find("[иі]мен[иі] (%w+) (%w+)%p?%s[Пп]рос") then
          first, last = str:match("[иі]мен[иі] (%w+) (%w+)%p?%s[Пп]рос")
          debug("P2, ID - 4", 1)
        elseif str:find("именем%s%w+%s%w+.%sПозвони") then
          debug("P2, ID - 5", 1)
          first, last = str:match("именем (%w+)%s(%w+).%sПозвони")
        elseif str:find("%w+%p%sПозв") then
          debug("P2, ID - 6", 1)
          first, last = str:match("имени (%w+) (%w+)%p%s?Поз")
          
        elseif str:find("%w+%p%W+") then
          debug("P2, ID - 7", 1)
          first, last = str:match("[(игрока)|(человека)|(ником)|(имени)] %p?(%w+) (%w+)%p?%p%W+")
          print(string.format("Find player | ID: 7 - %s %s", first, last))
        elseif str:find("[(игрока)|(человека)|(ником)] %w+ %w+$") then
          debug("P2, ID - 8", 1)
          first, last = str:match("[(игрока)|(человека)] (.+) (.+)$")
        elseif str:find("%w+$") then
          debug("P2, ID - 9", 1)
          first, last = str:match("имен[ие][м]? (.+) (.+)$")
        elseif str:find("%p%w+%s%w+%p") then
          debug("P2, ID - 10", 1)
          first, last = str:match("%p(%w+)%s(%w+)%p")
        elseif str:find("%W+%s%w+%s%w+%p$") then
          debug("P2, ID - 11", 1)
          first, last = str:match("%W+%s(%w+)%s(%w+)%p$")
        elseif str:find("именем%s%w+%s%w+%sпозвони") then
          debug("P2, ID - 12", 1)
          first, last = str:match("именем (%w+)%s(%w+)%sпозвони")
        elseif str:find("человека%s%w+%s%w+%p%s%W+") then
          debug("P2, ID - 13", 1)
          first, last = str:match("человека%s(%w+)%s(%w+)%p%s%W+")
        end
        debug("Find human, Pattern 3", 1)--\nFirst: "..first.."\nLast: "..last)
        print(first, last)
      elseif str:find("^(%w+) (%w+)%p%sпозвони мне") then
        debug(str.." | Pattern 4", 1)
        first, last = str:match("^(%w+)%s(%w+)%p%sпоз")
        print(first, last)
      elseif str:find("[иі]мен[иі] \"(.+) (.+)\"%p?") then
        debug(str.." | Pattern 5", 1)
        first, last = str:match("[иі]мен[иі] \"(.+) (.+)\"%p?")
        print(first, last)
      elseif str:find("овек[а]?%s%w+%s%w+%p?") then
        debug(str.." | Pattern 6", 1)
        first, last = str:match("овек[а]?%s(%w+)%s(%w+)%p?")
        print(first, last)
      elseif str:find("[щш]у (%w+) (%w+)") then
        debug(str.." | Pattern 7", 1)
        first, last = str:match("[щш]у%s(%w+)%s(%w+)%p?")
        print(first, last)
      elseif str:find("щу (%w+) (%w+)") then
        --щу Dmitriy Forost.
        debug(str.."Pattern 8", 1)
        first, last = str:match("щу%s(%w+)%s(%w+)%p")
        print(first, last)
      elseif str:find("^[Чч]еловек по имени (.+) (.+)%p") then
        first, last = str:match("имени%s(%w+)%s(%w+)%p")
        print(first, last)
      end
      print(str)
      if last == nil or first == nil then
        print("{cc0000}ERROR 4:{b2b2b2}", str)
        return "ERROR"
      end
      first, last = capitalize_nick(first, last)
      return "Ищу человека по имени "..first:gsub("\"", "").." "..last:gsub("\"", "")..". Позвони мне!"
    elseif str:find("родс[т]?[т]?в[уи]?[ен][ен]") or str:find("[Сс]емью") or str:find("фаму") then
      return "Ищу дальних родственников. Позвоните мне!"
    else
      if str:find("щу (.+) (.+)") then
        --щу Dmitriy Forost.
        debug(str.."FOUND14", 1)
        first, last = str:match("щу%s(%w+)%s(%w+)")
        print(first, last)
      end
      if last == nil or first == nil then
        print("{cc0000}ERROR 5:{b2b2b2}", str)
        return "ERROR"
      end
      return "Ищу человека по имени "..first.." "..last..". Позвони мне!"
    end

  elseif not str:find("сантех") and str:find("[Сс]алон [Сс]вязи") then
    return "Продажа симок до 5.000.000$. Поспешите! Мы в \"Салоне связи\" | GPS 8-280"
  elseif str:find("[Оо]руж") or str:find("ый [Мм]агаз") and str:find("[Gg][Pp][Ss]") or str:find("AMMO") then
    --locate, gps = location(str, "ammo", nil, nil)
    h_string = location(str, "ammo", nil, nil)
    return h_string
  elseif str:find("(.-)о[дж][ам][ма]") or str:find("[Ss]ell") or str:find("[Пп]роадм") or str:find("(.-)родаю") or str:find("одат") or str:find("продам") or str:find("[Аа]ук") then
    --debug(str, 5)
    if str:find("[Сс]порт%s?[Зз]ал") then
      if str:find("[Пп]риб[е]?режный") then
        return "Продам спортзал «Прибрежный» в р. Marina, LS. "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Спортзал»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]антех") then
      return "Продам «Салон Сантехники»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Аа]рхит") or str:find("[Аа]рх [Бб]юро") then
      return "Продам бизнес «Архитектурное бюро»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Аа]гробирж") then
      return "Продам бизнес «Агробиржа» San Fierro. "..get_price(str, trade_type(str))
    elseif str:find("[Мм]ебель") then
      return "Продам «Мебельный салон»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]троймат") then
      return "Продам бизнес «Стройматериалы»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Уу]прав") and str:find("[Сс]татис") then
      return "Продам «Управление статистики»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]трип") then
      if str:find("[Ll]ast [Dd]rop") then
        return "Продам стрип-клуб «Last Drop» в д. Montgomery. "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Стрип-клуб»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Ss]ex") or str:find("[Сс]екс") then
      if str:find("Sex Shop ЛВ %№2") then
        return "Продам бизнес «Sex-Shop LV» в р.Roca Escalante. "..get_price(str, trade_type(str))
      elseif str:find("hop LS") and str:find("%№1") or str:find("[Ss]ex[Ss]hop №1") or str:find("секс шоп №1") then
        return "Продам бизнес «Sex-Shop №1»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Сс]екс [Шш]оп[( лв)]? 2") or str:find("[Ss]ex%p?%s?[Ss]hop 2") then
        return "Продам бизнес «Sex-Shop №2»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("Sex Shop ЛС %№2") or str:find("Sex Shop %№2 в р.Marina") then
        return "Продам бизнес «Sex-Shop LS №2»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("Sex Shop%p за БЛС") then
        return "Продам бизнес «Sex-Shop»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("номер 1") then
        return "Продам Sex-Shop №1"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return string.format("Продам Sex-Shop%s. %s", get_location(str), get_price(str, trade_type(str)))
    elseif str:find("[Нн]очной [Кк]луб") then
      return "Продам бизнес «Ночной клуб»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Aa]dvance [Cc]lub") or str:find("[аА]дванс [Кк]л[уа]б") then
      return "Продам бизнес «Advance Club» в ш. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("клуб %pМон[т]?гомери%p") or str:find("клуб %pМон[т]?гомери%p") then
      return "Продам клуб «Montgomery» в д. Montgomery. "..get_price(str, trade_type(str))
    elseif str:find("клуб [Bb]ig [Ss]pre[a]?d") or str:find("клуб %pМон[т]?гомери%p") then
      return "Продам клуб «Big Spread Ranch» в о. Bone. "..get_price(str, trade_type(str))
    elseif str:find("[Gg]aydar [Ss]tation") then
      return "Продам клуб «Gaydar Station»"..get_location(str)..". "..get_price(str, trade_type(str))
    
    elseif str:find("[Кк]луб") then
      if str:find("[Тт]реке") then
        return "Продам клуб с GPS-трекером"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "Продам клуб"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Оо]тель") or str:find("[Гг]остин") then
      if str:find("B[r]?iffin%p?%s?Bridge") then
        return "Продам отель «Biffin Bridge» в ш. San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("тель [Сс]ан%p?%s?[Фф]иерро") or str:find("[Оо]тель [Сс][Фф]") then
        return "Продам бизнес «Отель Сан-Фиерро». "..get_price(str, trade_type(str))
      elseif str:find("тель %p?Las%p?%s?Venturas%p?") then
        return "Продам бизнес «Отель Las-Venturas». в ш. LV. "..get_price(str, trade_type(str))
      elseif str:find("[пП]ират") and str:find("[Гг]ост") then
        return "Продам бизнес «Пиратская гостинница». в ш. LV. "..get_price(str, trade_type(str))
      elseif str:find("[Oo][kc]ean") and str:find("[Оо]кеан") then
        return "Продам бизнес «Отель Ocean». в ш. LS. "..get_price(str, trade_type(str))
      end
    elseif str:find("ес [Аа]ксесуары") or str:find("[Мм]агазин [Аа]ксе[с]?суар[оы]") then
      return "Продам «Магазин Аксессуаров»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Цц]ентр") and str:find("[Оо]тдых") then
      if str:find("[Gg][Pp][Ss]") then
        return "Продам бизнес РЦ «Забава» по GPS 8-76. "..get_price(str, trade_type(str))
      end
      return "Продам РЦ «Отдых» в ш. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[Зз]абава") then
      if str:find("GPS") then
        return "Продам бизнес РЦ «Забава» по GPS 8-42. "..get_price(str, trade_type(str))
      end
      return "Продам РЦ «Забава» в ш. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[Рр]азвлекательный [Цц]ентр") or str:find("[Рр]аз[в]? [Цц]ентр") then
      if str:find("[Ии]гр[ау]") then
        return "Продам развл. центр «Игра»"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "Продам «Развлекательный центр»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Рр]азвлекательный [Цц]ентр") then
      return "Продам «Развлекательный центр»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Мм]агазин [Сс]ладостей") or str:find("[Сс]ладости") then
      return "Продам бизнес «Магазин сладостей»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("Реклама Лас%p?%s?Вентурас") then
      return "Продам бизнес «Рекламное агентство»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Кк]ондитер") or str:find("кондирск") or str:find("[Пп]о[н]?чик") and str:find("[Бб]ольн") then
      if str:find("поничк") or str:find("по[н]?чик") then
        return "Продам кондитерскую «Пончик»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("аукционе кондитерская") then
        return "На аукцион выставлена кондитерская «Пончик» за больницей ш. LS."
      elseif str:find("по [Gg][Pp][Ss] 8%p147") then
        return "Продам бизнес «Кондитерская» по GPS 8-147. "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Кондитерская»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]ладости") and str:find("[Aa]ngel") then
      if str:find("Сладости") then
        return "Продам «Сладости Angel Pine» в д. Angel Pine. "..get_price(str, trade_type(str))
      end
    elseif str:find("[Cc]lu[c]?k[iae]n [Bb]ell") or str:find("[Кк]лак[ие]н [Бб]ел[л]?") then
      if str:find("[СсSs][FfФф][FfФф][MmМм]") then
        return "Продам «Cluckin Bell» у радиоцентра San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("[GgГг][PpПп][SsСс]%s4%p?%s?8") then
        return "Продам «Cluckin Bell» по GPS 4-8. "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Cluckin Bell»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]ар[ие][кхм]?[х]?[мк]а[к]?[хк]ерс") or str:find("%s[Пп]арик%s") then
      if str:find("[Аа]ук") then
        return "Парикмахерская"..get_location(str).." выставлена на аукцион."
      end
      if str:find("[Гг]олов[о]?рез") then
        return "Продам парикмахерскую «Головорез»"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Парикмахерская»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Мм]агазин [Пп]иро") or str:find("[Пп]иротехник[ау]") then
      if str:find("Северное сияни") then
        return "Продам магазин пиротехники «Северное синяие» в LV. "..get_price(str, trade_type(str))
      end
      return "Продам магазин пиротехники"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Мм]агазин [Ии]груш") then
      return "Продам «Магазин игрушек»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]ри(.-) [Сс]тав(.-)") then
      return "Продам «Приём ставок»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]алон [Кк]расоты") then
      return "Продам «Салон красоты»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Дд]еревенск") then
      return "Продам салон «Деревенский стиль» в д.Fort Carson. "..get_price(str, trade_type(str))
    elseif str:find("[Сс]алон") and str:find("[Сс]редневе") then
      if str:find("[Аа]ук") then
        return "Салон «Средневековье» в Las Barrancas на аукционе | Price 4-1-11"
      end
      return "Продам салон «Средневековье» в д. Las Barrancas. "..get_price(str, trade_type(str))
    elseif str:find("[Мм]агаз") and str:find("[Аа]ксессуаров") then
      if str:find("[Пп]резидент") then
        return "Продам магазин аксессуаров «Президент» в ш. Los Santos. "..get_price(str, trade_type(str))
      end
      return "Продам магазин аксессуаров"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Кк]луб [Пп]арашютистов") then
      return "Продам бизнес «Клуб Парашютистов» у аэропорта LS. "..get_price(str, trade_type(str))
    elseif str:find("[Зз]ак[у]?сочн") or str:find("[Зз]акуск[уа]") or str:find("[Пп]ончик") or str:find("Burger%s?Shot") or str:find("[Бб]у[рг][гре][ег][о]?%s?[шШ]от") or str:find("[Бб]ур[гш]ер [Шш]от") then
      if str:find("[Пп]ончик") then
        return "Продам бизнес «Закусочная-Пончик»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("аукционе кондитерская") then
        return "На аукционе кондитерская «Пончик» за больницей ш. LS. Цена: 45.000.000$"
      elseif str:find("[(шот)|(Shot)|(shot)]") and str:find("номер 1") or str:find("№1") then
          return "Продам бизнес «Burger Shot №1»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[СсSs][FfФф][FfФф][MmМм]") then
        return "Продам закусочную у радиоцентра San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("Центр") then
        return "Продам «Центральную закусочную» в ш. San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("Закусочная Burger Shot") then
        return "Продам бизнес «Закусочная Burger Shot №1» "..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Бб]у[рг][гре][ег][о]?шот") or str:find("бизнес") and str:find("Burger%s?Shot") or str:find("[Бб]ур[гш]ер [Шш]от")  then
        return "Продам бизнес «Burger Shot»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Яя]пон[с]?к") then
        if str:find("[Gg][Pp][Ss]") then
          return "Продам «Японскую закусочную» по GPS 8-184. "..get_price(str, trade_type(str))
        end
        return "Продам «Японскую закусочную» в ш. Las Venturas. "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Закусочная»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Бб]укме") then
      return "Продам «Букмекерскую контору»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Кк]азино") and str:find("[ЛлLl][ОоOo][СсsS]") then
      return "Продам бизнес «Казино Лос-Сантос». "..get_price(str, trade_type(str))
    elseif str:find("[Кк]азино") and str:find("[ЛлLl][АаAa][СсsS]") or str:find("[Кк]азино [ЛлLl][ВвVv]") then
      if str:find("[Чч]астное") then
        return "Продам частное «Казино Las Venturas». "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Казино Las Venturas». "..get_price(str, trade_type(str))
    elseif str:find("[Кк]аз[(ино)]?") and str:find("[Вв]осточное") or str:find("[Вв]осточн[ыо][ей] [Кк]аз") then
      return "Продам бизнес «Восточное казино» в LV. "..get_price(str, trade_type(str))

    elseif str:find("[Пп]ридорожный [Бб]ар") then
      return "Продам бизнес «Придорожный бар»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Гг]ангстер") and str:find("[Бб]ар") then
      return "Продам бар «Гангстер»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Tt]he [Cc][Rr][AaEe][Ww]") then
      return "Продам бар «The Craw Bar»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Дд]ерев(.-) [Пп]ивн(.-)") then
      return "Продам «Деревенскую пивнушку» в д. Fort Carson. "..get_price(str, trade_type(str))
    elseif str:find("[Хх]ранение") then
      return string.format("Продам «Хранение транспорта»%s. %s", get_location(str), get_price(str, trade_type(str)))
    elseif str:find("10 [Зз]ел(.-) [Бб]уты[к]?л[д]?ок") or str:find("10 [Бб]утылок") then
      return "Продам бар «10 зелёных бутылок» в ш. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[Бб]ар[^а]") then
      if str:find("[Чч]ерника") then
        return "Продам кафе-бар «Черника»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Бб]ар [Мм]он[т]?гомери") then
        return "Продам бар «Montgomery»"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      if str:find("[Аа]ук") and str:find("Бар Кафе") then
        return "На аукцион выставлен бизнес «Кафе-Бар» "..get_location(str)..". "
      end

      return "Продам бизнес «Бар»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Бб]ургер") or str:find("[Bb]urger") then
      if str:find("[(шот)|(Shot)|(shot)]") and str:find("номер 1") or str:find("№1") then
        return "Продам бизнес «Burger Shot №1»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Шш]от") or str:find("кинг") or str:find("king") then
        return "Продам бизнес «Burger Shot»"..get_location(str)..". "..get_price(str, trade_type(str))
      end
    elseif str:find("%s%p?[Тт]ир%p?%s") then
      return "Продам бизнес «Тир»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]рокат [Аа]вто") then
      return "Продам бизнес «Прокат автомобилей»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("секс%s?[гш]оп") or str:find("[Ss]e[Xx]%p?%s?[Ss]hop") then
      if str:find("№1") or str:find("номер 1") then
        return "Продам бизнес «Sex Shop №1»"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Sex Shop»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("ammo") or str:find("аммо") or str:find("аммунаци[яю]") then
      return "Продам бизнес «Ammunation»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]иц[ц]?[ц]?[еа]р[и]?[юя]") then
      if str:find("[Аа]ук") then
        return "На аукцион выставлен бизнес «Пиццерия»"..get_location(str)
      end
      return "Продам бизнес «Пиццерия»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]рода[мю]") and str:find("[Бб]анк") then
      return "Продам банк"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Мм][а]?гази[нг] [Оо]дежды") or str:find("магаз одежды") or str:find("биз одежда") or str:find("%s[DД][SСC]") then
      -- debug("Продажа: магазин одежды\n"..str, 3)
      if str:find("[Аа]укц") then
        if str:find("[Ss]ub [Uu]rban") or str:find("[Сс][уа]б [Уу]рбан") then
          return "На аукцион выставлен магазин одежды «Sub Urban»"..get_location(str)
        end
      end
      
      if str:find("[Яя]понский [Сс]тиль") then
        return "Продам магазин одежды «Японский стиль» в LV. "..get_price(str, trade_type(str)):gsub("договорная.", "договорная")
      elseif str:find("[Рр]иф") then
        return "Продам магазин одежды в опасном районе. Цена договорная"
      elseif str:find("[Pp]ro[Ll]aps") then
        return "Продам магазин одежды «ProLaps»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[DД][SСC]") then
        return "Продам магазин одежды «DS»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Zz][Ii][Pp]") then
        return "Продам магазин одежды «ZIP»"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Ss]ub [Uu]rban") or str:find("[Сс][уа]б [Уу]рбан") then
        return "Продам магазин «Sub Urban»"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "Продам «Магазин одежды»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Рр]есторан") then
      if str:find("[Пп]рез[ие]ден") then
        return "Продам «Президентский ресторан» в ш. Los Santos. "..get_price(str, trade_type(str))
      end
      return "Продам бизнес «Ресторан»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]толов[уао][юя]") then
      return "Продам бизнес «Столовая»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]рибрежный [Кк]луб") then
      return "Продам бизнес «Прибрежный клуб»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("zip тцлв") then
      return "Продам магазин одежды «ZIP» в ТЦЛВ. "..get_price(str, trade_type(str))
    elseif str:find("[Нн]омерн(.+) знаки") and str:find("[(SF)|(СФ)|[сф]]") then
      return "Продам бизнес «Номерные знаки в SF». "..get_price(str, trade_type(str))
    elseif str:find("[Пп]родам магазин в районе") then
      return string.format("Продам магазин «24/7» %s. %s", get_location(str), get_price(str, trade_type(str)))
    --elseif str:find("")
    else
      print("{cc0000}ERROR 6:{b2b2b2}", str)
      return "ERROR"
    end
  elseif str:find("[Рр][Аа]бо[ат]") and str:find("[Мм]ехан") then
    return "По фередации работает опытный автомеханик. Звоните."
  elseif str:find("[Рр][Аа]бо[ат]") and str:find("[Тт]акси") or str:find("TAXI") then
    if str:find("[СсSs][ФфFf]") or str:find("[Сс]ан [Фф]иерро") or str:find("[Ss]an [Ff]ierro") then
      taxi_loc = "штату SF"
    elseif str:find("[ЛлLl][СсSs]%s[^|]") or str:find("[Лл]ос [Сс]анто") then
      taxi_loc = "штату LS"
    elseif str:find("[ЛлLl][ВвVV]") then
      taxi_loc = "штату LV"
    else
      taxi_loc = "федерации"
    end
    if str:find("%s[Мм][Оо]%s") then
      taxi_info = "Для МО безоплатно!"
    else
      taxi_info = "Звоните!"
    end
    if str:find("самое быстрое такси") then
      return "По "..taxi_loc.." работает самое быстрое такси. "..taxi_info
    elseif str:find("элитное такси") then
      return "По "..taxi_loc.." работает элитное такси. "..taxi_info
    elseif str:find("работает такси$") then
      return "По "..taxi_loc.." работает такси. Звоните."
    else
      taxi_name = get_taxi_name(str)
    end
    return "По "..taxi_loc.." работает такси"..taxi_name..". "..taxi_info
  elseif str:find("(.-)у[ап][л]?ю") or str:find("(.-)пл[дб]?ю") or str:find("улю") or str:find("(.-)ПЛЮ") or str:find("[Bb]uy") or str:find("[kK][uy]pl[y]?u") then
    if str:find("[Бб]ар") then
      return "Куплю бизнес «Бар»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]трип") then
      return "Куплю бизнес «Стрип-клуб»"..". "..get_price(str, trade_type(str))
    elseif str:find("[Кк]луб") then
      return "Куплю бизнес «Клуб»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]иротех") then
      return "Куплю бизнес «Пиротехника»"..". "..get_price(str, trade_type(str))
    elseif str:find("[Хх]ран") and str:find("[Аа]кс") then
      return "Куплю бизнес «Хранение аксессуаров» в ш. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[Зз]акус") then
      return "Куплю бизнес «Закусочная»"..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]екс%p?%s?[Шш]оп") or str:find("[Ss]ex%s?%p?[Ss]hop") then
      return "Куплю бизнес «Sex-Shop»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Кк]азино") then
      return "Куплю казино"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Рр]есторан") and str:find("[Лл]иберти") then
      return "Куплю ресторан в стиле «Либерти-сити» в SF. "..get_price(str, trade_type(str))
    elseif str:find("[Рр]есторан") then
      return "Куплю бизнес «Ресторан»"..". "..get_price(str, trade_type(str))
    elseif str:find("[Пп]рокат [Аа]вто") then
      return "Куплю бизнес «Прокат автомобилей»"..". "..get_price(str, trade_type(str))
      
    elseif str:find("[Оо]руж") and str:find("[Мм]агаз") then
      return "Куплю оружейный магазин «Ammunation»"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("%s[БбЮю][Юю]?из%s?") or str:find("%sбиз%s") or str:find("БИЗНЕС") or str:find("[Пп]редп[р]?и") or str:find("[Bb][iI][zZ]") or str:find("[Bb]us[s]?in") then
      if str:find("приб") then
        return action[trade_type(str)].."прибыльный бизнес"..get_location(str)..". "..get_price(str, trade_type(str))
      else
        return action[trade_type(str)].."бизнес"..get_location(str)..". "..get_price(str, trade_type(str))
      end
    end
  elseif str:find("[Гг]олосуй") or str:find("[Кк][ао]нди[дт]ат") or str:find("[Пп]арти[йюя]") or str:find("[Зз]а %w+ %w+%p") then
    chatDebug("Попалася ботва!")
    str = str:gsub("\"", "«", 1):gsub("\"", "»"):gsub("!!!", "!"):gsub("%w%w | ", "")
    return str
  elseif str:find("%s[Бб][Кк]%s") then
    if str:find("[Rr]ifa") then
      return "Идёт набор в БК «The Rifa» | GPS 4-4 | Ждём!"
    end
  elseif str:find("Cluckin Bell в СФ") then
    if str:find("Хотите кушать") then
      return "Хотите кушать? Ждем в «Cluckin Bell в СФ» недалеко от SFFM!"
    end
  elseif str:find("Приёме ставок в Montgomery") then
    if str:find("Измени свою жизнь") then
      return "Измени свою жизнь - поставь ставку в «Приёме ставок в Montgomery»"
    end
  elseif str:find("в салоне красоты [Пп]аломино") then
    if str:find("[Ии]змени свой стиль") then
      return "Измени свой стиль в «Cалоне красоты» д. Palomino Creek."
    elseif str:find("лучшие цены на акс") then
      return "Лучшие цены на аксессуары в «Cалоне красоты» д. Palomino Creek."
    end

  else
    print("{cc0000}ERROR 7 (1):{b2b2b2}", str)
    return "ERROR"
  end
  print("{cc0000}ERROR 7 (2):{b2b2b2}", str)
  return "ERROR"
end

function trade_type(str)
  if str:find("(.-)[УуyY][цЦ]?[плИи][а]?[лп][дб]?ю") or str:find("[Кк]упл.") or str:find("[kK][uy]pl[y]?u") or str:find("[Кк]упить") or str:find("[Пп]риобре") or str:find("^[Кк]пю") or str:find("(.-)[Уу][Пп][лЛДд][юЮБб]") or str:find("kyply") or str:find("[Кк]у[а]?лю") or str:find("[Bb]uy") or str:find("[Кк]алю") or str:find("[Кк]упю") then
    print(str)
    return "buy"
  elseif str:find("(.-)[оoл][дd][aав][мm]") or str:find("[Пп]ро[ак]дм") or str:find("[Пп]Р[Р]?[ОЛ]Д[Ж]?[Аа][мМ]") or str:find("^[Пп]ро[дД]") or str:find("[Pp]rodam") or str:find("(.-)родаю") or str:find("(.*)ро(.*)[ап]м") or str:find("одат") or str:find("рдам") or str:find("родм") or str:find ("[Пп]родма") or str:find ("[Пп][рР][Оо]да") or str:find("(.-)ell") or str:find("^[Сс][Ее][Лл][Лл]") or str:find("[Gg]hjlfv") then
    return "sell"
  elseif str:find("[Аа]укц[ие]он") or str:find("[Аа]ук") or str:find("[Нн]а аук[е]?") or str:find("[Аа]ууционе") then
    return "auction"
  elseif str:find("[Оо]бм[н]?е") then
    if str:find("мо[йея][й]? [(дп)|(доплата)|(доплатой)|(ДП)]") or str:find("моей дп") then
      return "my_change"
    elseif str:find("вашей д[о]?п") or str:find("ваша д[о]?п") or str:find("[Вв]аш(.-)%s[Дд][Оо]?[Пп]") then
      return "ur_change"
    elseif str:find("с [Дд][Пп]$") then
      return "d_change"
    else
      return "change"
    end
  elseif str:find("рынок") or str:find("р[ыи]н[ку]е") then
    return "carmarket"
  else
    return ""
  end
end

function get_taxi_name(str)
  if str:find("вианосец [Чч][Сс]") then
    taxi_n = " «Авианосец-ЧС»"
  elseif str:find("такси \".*\"") then
    taxi_n = str:match("такси \"%s?(.*)\"")
  elseif str:find("работает \".*\"") then
    taxi_n = str:match("работает \"%s?(.*)\"")
  elseif str:find("работает .+ такси[.]?") then
    taxi_n = str:match("работает (.+) такси[.]?")
  elseif str:find("такси .+") then
    taxi_n = str:match("такси (.+) [сж]")
  else
    taxi_n = ""
  end
  sampAddChatMessage(string.format("Название такси: %s", taxi_n or "error"), 0xAFBB77)
  return string.format(" «%s»", taxi_n or "error")
end

--=================[SIM-CARD]=================--

function get_simcard_fmt(str)
  --debug("SIM", 2)
  --продам сим 990999 1kk
  str = str:gsub("«", ""):gsub("»", "")
  if str:find("[Фф][о]?рма[т]?[еао]?[йа]? \".+\"") then
    print("SIM FORMAT ID 1")
    format = str:match("[Фф][о]?рма[т]?[еао]?[ай]? \"(.+)\"")

  elseif str:find("[Фф][о]?рма[т]?[еа]?[а]? .-[,.]%s%W+") then
    print("SIM FORMAT ID 2")
    format = str:match("[Фф][о]?рма[т]?[еа]?[а]? (.-)[,.]")
    
  elseif str:find("[Фф][о]?рма[т]?[еа]?[а]? ''(.+)''%p[Цц]?.+$") then
    print("SIM FORMAT ID 3")
    format = str:match("[Фф][о]?рма[т]?[еа]?[а]? ''(.+)''%p[Цц]?.+$")

  elseif str:find("[Фф][о]?рма[т]?[еа]?[а]? (.+) [цЦ]?.+$") then
    print("SIM FORMAT ID 4")
    format = str:match("[Фф][о]?рма[т]?[еа]?[а]? (.+) [цЦ]?.+$")

  elseif str:find("[Фф][о]?рма[т]?[еа]?[а]? (.-)%s") then
    print("SIM FORMAT ID 5")
    format = str:match("[Фф][о]?рма[т]?[еа]?[а]? (.-)%s")

  elseif str:find("[Фф][о]?рма[т]?[еа]?[а]? (.-)$") then
    print("SIM FORMAT ID 6")
    format = str:match("[Фф][о]?рма[т]?[еа]?[а]? (.-)$")
  elseif str:find("[Фф][о]?рма[т]?[еа]?[а]?%p (.-)[.,]") then
    format = str:match("[Фф][о]?рма[т]?[еа]?[а]?%p (.-)[.,]")
    
  elseif str:find("[Фф][о]?рма[т]?ом (.-)$") then
    format = str:match("[Фф][о]?рма[т]?ом (.-)$")
  elseif str:find("с[у]?[им][им]к[уа]%s%W+%s%W+%s%W+%sцена") then
    format = str:match("с[у]?[им][им]к[уа]%s(%W+%s%W+%s%W+)%sцена"):gsub(" ", "")
  elseif str:find("с[у]?[им][им]к[уа] .-[,.]?%s") then
    format = str:match("с[у]?[им][им]к[уа] (.-)[,.]?%s")

  elseif str:find("с[у]?[им][им]к[уа] .-[,.]") then
    debug("SIM3", 2)

    format = str:match("с[у]?[им][им]к[уа] (.-)[,.]")
  elseif str:find("с[у]?[им][им]к[уа] %d+%s") then
    format = str:match("с[у]?[им][им]к[уа] (%d+)%s")
  elseif str:find("с[у]?[им][им]%s?к[уа] %d+$") then
    debug("SIM2", 2)
    format = str:match("с[у]?[им][им]%s?к[уа] (%d+)$")
    --if format:find("%p") then debug("DELETE SYMBOL", 4) format:gsub("-", "") end
  elseif str:find("с[у]?[им][им]к[уа]%s.-[,.]?%s") then
    debug("SIM", 2)
    format = str:match("с[у]?[им][им]к[уа]%s(.-)[,.]?%s"):upper()
  elseif str:find("с[у]?[им][им]к[уа] .-$") then
    format = str:match("с[у]?[им][им]к[уа] %s?(.+)$")
    debug("3333", 2)
  elseif str:find("[CcСс][aа][rр][dт] .+[,.]") then --Куплю Sim-card xxx-xxx
    format = str:match("[CcсС][aа][rр][dт] (.+)[,.]")
  elseif str:find("[CcСс][aа][rр][dт] %d+$") then
    format = str:match("[CcСс][aа][rр][dт] (%d+)$")
  elseif str:find("[CcСс][aа][rр][dт] (.-)$") then
    format = str:match("[CcСс][aа][rр][dт] (.-)$")
    -- debug(format, 1)

  elseif str:find("[CcСс][aа][rр][dт]%s.+%s") then
    format = str:match("[CcСс][aа][rр][dт]%s(.+)%s"):upper()
  elseif str:find("карту%s[^(Номер)].-%s") then
    format = str:match("карту%s(.-)%s"):upper():gsub("%p", "")
    debug(format, 1)
  elseif str:find("карту%s[^(Номер)].+$") then
    format = str:match("карту%s(.-)$"):upper()
    
  elseif str:find("формата .+%sц") then
    format = str:match("формата (.+)%sц")
  elseif str:find("формата .+$") then
    format = str:match("формата (.+)$")
  elseif str:find("номер \".+\"") then
    format = str:match("номер \"(.+)\"")
  elseif str:find("[Нн]омер%s.+%sц") then
    format = str:match("[Нн]омер%s(.+)%sц")
  elseif str:find("номер .+%p") then
    format = str:match("номер (.-)%p")
  elseif str:find("номер .+%s") then
    format = str:match("номер (.+)%s")
  elseif str:find("номер .+$") then
    format = str:match("номер (.+)$")
  elseif str:find("[Ss][Ii][Mm][k]?%s.+%s") then
    format = str:match("[Ss][Ii][Mm][k]?%s(.+)%s")
  elseif str:find("[Ss][Ii][Mm][k]?%s.+$") then
    format = str:match("[Ss][Ii][Mm][k]?%s(.+)$")
  elseif str:find("%s%d+%sсимк[уа]$") then
    format = str:match("%s(%d+)%sсимк[уа]$")
  elseif str:find("[Пп]родам%s%d+%s") then
    format = str:match("[Пп]родам%s(%d+)%s")
  -- elseif str:find("сим%s.-%p?%s") then
  --   format = str:match("сим%s(.-)%p?%s")
  elseif str:find("[Сс]им .-,") then --Куплю Sim-card xxx-xxx
    format = str:match("[Сс]им (.-),") print("сим 1")
  elseif str:find("[Сс]им %d+$") then
    format = str:match("[Сс]им (%d+)$")  print("сим 2")
  elseif str:find("[Сс]им (.-)%s") then
    format = str:match("[Сс]им (.-)%s")  print("сим 3")
  elseif str:find("[Сс]им (.-)$") then
    format = str:match("[Сс]им (.-)$")  print("сим 4")
  elseif str:find("[Сс]им (.-) (.-)$") then
    format = str:match("[Сс]им (.-) (.-)$")  print("сим 5")
  elseif str:find("[Сс]им%s.-%s") then
  else
    format = nil
  end
  if format ~= nil then 
    if format:find("цена") then format = format:gsub(" цена", "") end
  end
  if format ~= nil and format:find("[0-9]") then
    if format:find("%-") then chatDebug("РИСКА") format = format:gsub("%-", "") end
    print(format)
    format = replace_numbers(format)
  end
  return format:gsub("<<", ""):gsub(">>", ""):gsub("х", "X"):gsub("у", "Y"):gsub("о", "O"):gsub(" ", ""):gsub("Цена", ""):gsub("цена", "")
end

function replace_numbers(str)
  letters = {}
  letters[0] = "O"
  letters[1] = "A"
  letters[2] = "B"
  letters[3] = "C"
  letters[4] = "D"
  letters[5] = "E"
  letters[6] = "F"
  letters[7] = "G"
  replaced = {}
  lsf_table = {}
  letter_sim_format = ""
  nums_tab = str_to_tab(str)
  unique_numbers = del_ident_nums(str_to_tab(str))
    for i = 1, #unique_numbers do
      if unique_numbers[i] == "0" then
          print(unique_numbers[i], type(unique_numbers[i]))
        replaced[unique_numbers[i]] = letters[0]
      else
        replaced[unique_numbers[i]] = letters[i]
      end
    end
    for i = 1, #nums_tab do
      lsf_table[i] = replaced[nums_tab[i]]
    end
    for k, v in pairs(lsf_table) do
      letter_sim_format = letter_sim_format..v
    end
    return letter_sim_format
end

function str_to_tab(str)
  numbers_tab = {}
  for i = 1, #str do
    table.insert(numbers_tab, str:sub(i,i))
  end
  return numbers_tab
end

function del_ident_nums(tab)
  for i = 1, #tab do
    for u = i + 1, #tab do
        if tab[i] == tab[u] then
            table.remove(tab, u)
            u = u - 1
        end
    end
  end
  return tab
end

--=================[OTHER]=================--

function get_hotel_price(str)
  if str:find("%s%d+%p%d+%$") then
    hpr_one, hpr_two = str:match("%s(%d+)%p(%d+)%$")
    hotel_price = hpr_one.."."..hpr_two
    return hotel_price
  elseif str:find("%s(%d+)%$") then
    hotel_price = str:match("%s(%d+)%$")
    return hotel_price
  elseif str:find("%s(%d+)%p") then
    hotel_price = str:match("%s(%d+)%p")
    return hotel_price
  else
    return ""
  end
end

function get_about_ys(str)
  if str:find("[Оо]%sсебе%p?%s?") then
    text = str:match("[Оо]%sсебе%p?%s?(.*)[.]?")
    return "О себе: "..text
  elseif str:find("[Оо]%sсебе%s") then
    text = str:match("[Оо]%sсебе%s(.+)"):gsub(".", "")
    return "О себе: "..text
  else
    return "Позвони мне!"
  end
end

function location(str, type, act, house_type)
  if type == "ammo" then
    --debug("AMMO", 2)
    if str:find("Fier") or str:find("fier") or str:find("(%s?)11(%s?)-(%s?)6(%s?)") then
      return ammunations_strings[math.random(1,2)]
    elseif str:find("Оружейном магазине ЛС №1") then
      if str:find("Большие скидки") then
        return "Большие скидки в «Оружейном магазине ЛС №1». Ждём Вас! GPS 11-1"
      -- elseif str:find("Надёжные бронежилеты") then
      --   return "Надёжные бронежилеты в «Оружейном магазине Angel Pine» | GPS 11-3"
      end
    elseif str:find("ngel") and str:find("ine") then
      if str:find("ие пушки") then
        return "Большие пушки, низкие цены - «AMMO Angel Pine» | GPS 11-3"
      elseif str:find("Надёжные бронежилеты") then
        return "Надёжные бронежилеты в «Оружейном магазине Angel Pine» | GPS 11-3"
      elseif str:find("[Пп]рода[юм]") then
        return "Продам магазин оружия «AMMO Angel Pine». Цена: договорная"
      else
        return "Самые низкие цены на оружие в «АММО Angel Pine» | GPS 11-3"
      end
    elseif str:find("[FfФф][oо][rр][tт]") and str:find("[CcКк][aа][rр][sс]") then
      if str:find("Самые адекватные цены") then
        return "Адекватные цены на холодное оружие в «AMMO Fort Carson» GPS 8-268"
      elseif str:find("большие скидки") then
        return "В «Оружейном магазине Fort Carson» большие скидки! | GPS 11-5"
      elseif str:find("Амуниция от 750") then
        return "Амуниция от 750$ в «Оружейном магазине Fort Carson» | GPS 11-5"
      end
    elseif str:find("(.-)[Уу][пл][а]?[лп][д]?ю") or str:find("(.-)[Уу][Пп][лЛ][юЮБб]") or str:find("kyply") or str:find("[Кк]у[а]?лю") or str:find("[Bb]uy") or str:find("[Кк]алю") or str:find("[Кк]упю") then
      return "Куплю оружейный магазин «Ammunation»"..get_location(str)..". "..get_price(str, trade_type(str))
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
    if str:find("родам") or str:find("уплю") then
      if str:find("[Вв]зл[её]т") then
        return "Продам спортзал «Взлет» по GPS 8-57 | "..get_price(str, trade_type(str))
      elseif str:find("GPS%s8[-]57") then
        return "Продам бизнес «Спортзал» в ш. Los Santos - GPS: 8-57. "..get_price(str, trade_type(str))
      elseif str:find("ал боевых искус[с]?тв") then
        return "Продам зал боевых искусств"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Пп]риб[е]?режный") then
        return "Продам спортзал «Прибрежный» в р. Marina, LS. "..get_price(str, trade_type(str))
      end
      return action[trade_type(str)].."спортзал"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Сс]анта [Мм]ария") or str:find("Marin[ae]") or str:find("[Pp]rice%p?%s%p?6%s?%p%s?4") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 6-4"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-85"
      end
      if str:find("очешь бицепс мужика") then
        return "Хочешь бицепс мужика? Поднимай тогда веса! | Спортзал в р. Marina"
      elseif str:find("Надоело быть дрыщем") then
        return "Надоело быть дрыщем? Приходи в спортзал дружок! Мы в р.Marina."
      elseif str:find("Изучи стиль боя в (.+) [Сс]портзале") then
        return "Изучи стиль боя в «Прибрежном» спортзале | "..biz_loc
      elseif str:find("Изучи стиль боя Кунг") then
        return "Изучи стиль боя Кунг-фу «Прибрежном» спортзале | "..biz_loc
      elseif str:find("ера как у Майк[л]?а Тайсона") then
        return "Карьера как у Майкла Тайсона ждет тебя в Спортзале LS | "..biz_loc
      elseif str:find("Стиль боя как у Майк[л]?а Тайсона") then
        return "Стиль боя как у Майка Тайсона ждет тебе в Спортзале LS! "..biz_loc
      elseif str:find("добивайся целей") then
        return "Тренируйся, добивайся целей в спортзале в р. Marina | "..biz_loc
      end 
    elseif str:find("Лос Сантос") or str:find("ЖД%s?ЛС") then
      if str:find("GPS%p?%s8%s?%p?%s?57") then
        if str:find("рокачай свою силу в нашем") then
          return "Прокачай свою силу в нашем «Спортзале Лос Сантоса» | GPS 8-57"
        elseif str:find("Увеличивай силу") then
          return "Увеличивай силу в спортзале у ЖДЛС | GPS 8-57"
        end
      end
    elseif str:find("Лас") and str:find("Вентурас") then
      if str:find("рокачай силу в спортзале") then
        return "Прокачай силу в спортзале у больницы Las Venturas. Низкие цены!"
      end
    elseif str:find("8-28") or str:find("-(%s?)28") or str:find("[Pp]rice%s?%p?6%s?%p%s?2") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 6-2"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-28"
      end
      if str:find("Подкачайся в зале") then
        return "Подкачайся в зале боевых искусств в ш. Los Santos. "..biz_loc
      elseif str:find("Тренеры мирового уровня") then
        return "Тренеры мирового уровня в «Зале боевых искусств LS». "..biz_loc
      elseif str:find("Изучи стиль Брюса Ли") then
        return "Изучи стиль Брюса Ли в «Зале боевых искусств в LS». "..biz_loc
      elseif str:find("Изучи стиль боя Брюса") then
        return "Изучи стиль боя Брюса Ли в «Зале боевых искусств LS». "..biz_loc
      elseif str:find("Изучи стиль бокса") then
        return "Изучи стиль бокса в «Зале боевых искусств» в LS. "..biz_loc
      elseif str:find("[Хх]очешь драться как Брюс") then
        return "Хочешь драться как Брюс Ли? «Зал боевых искусств в ЛС». "..biz_loc
      elseif str:find("Хочешь научиться драться") then
        return "Хочешь научиться драться? Тебе в Зал боевых искусств LS. "..biz_loc
      elseif str:find("Хочешь быть как Питер Пол") then
        return "Хочешь быть как Питер Пол? Иди в Зал боевых искусств LS. "..biz_loc
      elseif str:find("Изучи стиль") and str:find("Тигр") then
        return "Изучи стиль «Тигра» в «Зале боевых искусств LS». "..biz_loc
      elseif str:find("Получи Cash Back за стили") then
        return "Получи Cash Back за стили в «Зале боевых искусств LS». "..biz_loc
      elseif str:find("Бьют в школе") then
        return "Бьют в школе? Иди в «Зал боевых искусств LS» учить бокс. "..biz_loc
      elseif str:find("Хочешь драться как [тТ]айсон") then
        return "Хочешь драться как Тайсон? Иди в Зал боевых искусств ЛС. "..biz_loc
      elseif str:find("Стань самым сильным") then
        return "Стань самым сильным в «Зале боевых искусств ЛС». "..biz_loc
      elseif str:find("Хочешь быть сильным") then
        return "Хочешь быть сильным? Тебе в «Зал боевых искусств ЛС». "..biz_loc
      elseif str:find("заработай денег") then
        return "Приходи в «Зал боевых искусств ЛС» и заработай денег. "..biz_loc
      end

    elseif str:find("[Gg][Pp][Ss]%s8%s?[>-]%s?57") then
      if str:find("Новый стиль боя") then
        return "Новый стиль боя в нашей качалке «Взлёт» Los Santos | GPS 8-57"
      elseif str:find("свои мышцы и силу") then
        return "Прокачай свои мышцы и силу в качалке «Взлет» | GPS 8-57"
      elseif str:find("мощный бицепс") then
        return "Хочешь мощный бицепс? Качалка «Взлёт» тебе поможет! | GPS 8-57"
      elseif str:find("Изучай стиль бокс") then
        return "Изучай стиль боя «Бокс» в спортзале у ЖДЛС | GPS 8-57"
      elseif str:find("Покупай абон[ие]мент") then
        return "Покупай абонемент в спортзал у ЖДЛС | GPS 8-57"
      end
    elseif str:find("[Gg][Pp][Ss]%p?%s?8%s?[>-]%s?7") then
      if str:find("Изучи стиль боя Джеки") then -- Изучи стиль боя Джеки Чана в "Спортзале в гетто".GPS:8-7.
        return "Изучи стиль боя Джеки Чана в «Спортзале Гетто». GPS 8-7"
      elseif str:find("Обучим Боксу, Кунг%pФу, Тхэквондо") then
        return "Обучим Боксу, Кунг-Фу, Тхэквондо в «Спортзале Гетто». GPS 8-7"
      elseif str:find("Абонементы по 400") then
        return "Абонементы по 400$ только в «Спортзале Гетто» | GPS 8-7"
      elseif str:find("Бьют на улице") then
        return "Бьют на улице? Изучи Кунг-Фу у нас в зале! | GPS 8-7"
      elseif str:find("ходи по улицам бесстрашным") then
        return "Изучи Кунг-Фу в нашем зале и ходи по улицам бесстрашным. GPS 8-7"
      end
    elseif str:find("[Pp]rice%s?%p?6%s?%p%s?3") then
      if str:find("Джеки Чан") then
        return "Хочешь драться как Джеки Чан? Изучай стиль боя у нас! | Price 6-3"
      elseif str:find("Cамый лучший тренер у нас") then
        return "Cамый лучший тренер Качалка «Взлёт». Мы у Аэропорта LS! Price 6-3"
      end
    elseif str:find("[Pp]rice%s6%s?[>-]%s?8") or str:find("[Gg][Pp][Ss]%s8%s?[>-]%s?262") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 6-8"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-262"
      end
      if str:find("Устал быть унижен[иы]м") then
        return "Устал быть униженым? Зал боевых искусств поможет тебе! "..biz_loc
      elseif str:find("Прокачай навыки в зале") then
        return "Прокачай навыки в зале боевых искусств | "..biz_loc
      elseif str:find("Изучи стиль") then
        return "Изучи стиль «Кунг-фу» в зале боевых искусств в LV. "..biz_loc
      elseif str:find("Прокачайся в зале боевых") then
        return "Прокачайся в зале боевых искусств в LV. | "..biz_loc
      elseif str:find("Изучи боксерский стиль") then
        return "Изучи боксерский стиль в зале боевых искусств в LV. |"..biz_loc
      elseif str:find("качаться с нами в зале") then
        return "Хватит отдыхать, давай качаться с нами в зале. | "..biz_loc
      elseif str:find("набирать силу") then
        return "Скорее в зал боевых искусств набирать силу. | "..biz_loc
      elseif str:find("Прокачай свои мыщцы и ягодицы") then
        return "Прокачай свои мыщцы и ягодицы: Зал боевых искусств LV | "..biz_loc
      elseif str:find("П[ро][од]качай свои ягодицы в") then
        return "Прокачай свои ягодицы в зале боевых искусств в LV. | "..biz_loc
      elseif str:find("Прокачай свои мыщцы в зале боевых искусств") then
        return "Прокачай свои мыщцы в зале боевых искусств в LV. | "..biz_loc
      elseif str:find("Хватит отдыхать, пора качаться") then
        return "Хватит отдыхать, пора в зал боевых искусств LV. | "..biz_loc
      elseif str:find("Давай бегом в зал") then
        return "Давай бегом в зал, хватит раслабляться, у нас круто. | "..biz_loc
      elseif str:find("Самые низкие цены на абонементы") then
        return "Самые низкие цены на абонементы в зале LV. | "..biz_loc
      elseif str:find("Обижа[е]?ют[,%?] приходи к нам") then
        return "Обижают? Приходи к нам научим тебя боксу, дашь отпор. | "..biz_loc
      elseif str:find("научим давать отпор") then
        return "Обижают? Давай к нам - научим давать отпор. Мы в LV "..biz_loc
      elseif str:find("Хочешь быть накаченым") then
        return "Хочешь быть накаченым? Скорее в зал - подкачаемся. | "..biz_loc
      elseif str:find("Хочешь быть подкаченным") then
        return "Хочешь быть подкаченным? Давай к нам в зал - подкачаем! "..biz_loc
      elseif str:find("Давай к нам подкачаемся") then
        return "Хочешь быть подкаченным? Давай к нам - подкачаемся. | "..biz_loc
      end

    elseif str:find("ort") and str:find("arson") then
      if str:find("с удара") then
        return "Хочешь вырубать всех с удара? Тебе в спортзал в д. Fort Carson!"
      elseif str:find("вход") then
        return "Бесплатный вход только в спорт-зале в д. Fort Carson. Ждем Вас!"
      end
    end
  end
end

function clothes(str, act)
  debug("Одежда: "..str, 1)
  --3 скина
  --продам скины 272 208 99
  if str:find('%d+%p%s%d+%p%s%d+%p') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)%p", 3, 31)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%s%d+%p%s%d+%s') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)%s", 3, 31)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%s(%d+)$", 3, 320)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%s%d+%p%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)$", 3, 319)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[^(бюджет)]%s%d+%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%s(%d+)$", 3, 32)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%p%d+%p%d+%s') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%s", 3, 33)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    --куплю одежду 240, 294, 295 договор
  elseif str:find('пошива%s%d+%p%d+%p%d+%p?$') then    --куплю одежду пошива 303,304,305
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p?$", 3, 34)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(бюджет)]%s%s%d+%p?%s%d+%p?%s%d+%p?%s?') then
    --toast.Show(u8'3', toast.TYPE.WARN, 5)
    clothes_ids = get_clothes_id(str, "%s(%d+)%p?%s(%d+)%p?%s(%d+)%p?%s?", 3, 35)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    --куплю скин 109, 115 и 114
  elseif str:find('%s%d+%p?%s%d+%s[и&]%s%d+%s?') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p?%s(%d+)%s[и&]%s(%d+)%s?', 3, 36)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    --пошива%s\"%d+\"%s\"%d+\"%s\"%d+\"%
    -- бирок "102, 116, 309".
  elseif str:find('%s\"%d+%p%s%d+%p%s%d+\"%p') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)%p%s(%d+)%p%s(%d+)\"%p", 3, 360)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s\"%d+\"%s\"%d+\"%s\"%d+\"%p?') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)\"%s\"(%d+)\"%s\"(%d+)\"%p?", 3, 37)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s\"%d+\"%p%s\"%d+\"%p%s\"%d+\"%p') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)\"%p%s\"(%d+)\"%p%s\"(%d+)\"%p", 3, 311)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%d+%p%d+%p^[%$]') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p^[%$]", 3, 38)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('№%d+%s№%d+%s№%d+') then
    clothes_ids = get_clothes_id(str, "№(%d+)%s№(%d+)%s№(%d+)", 3, 38)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('№%d+%p%s№%d+%s[и&]%s№%d+') then
    clothes_ids = get_clothes_id(str, "№(%d+)%p%s№(%d+)%s[и&]%s№(%d+)", 3, 384)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%s%d+%s%d+%sскины') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%s(%d+)%sскины", 3, 38)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(ена)|(ена:)]%s%d+%p%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)$", 3, 39)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(ена)|(ена:)]%s%d+%p%d+%p%d+%s[(пошив)]') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)", 3, 310)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(ена)|(ена:)]%s%d+%p%d+%p%d+%p[^%$]') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p", 3, 311)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%s%d+[,]%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%p(%d+)$", 3, 312)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('^%W-%s%d+%s%d+%s%d+%s%W-$') then
    clothes_ids = get_clothes_id(str, '^%W-%s(%d+)%s(%d+)%s(%d+)%s%W-$', 3, 313)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%s%d+%p%s%d+%s%p%s%d+') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p%s(%d+)%s%p%s(%d+)', 3, 314)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  --[WORD EXPRESSIONS]
  elseif str:find('[(одежду)|(биркой)]%s%d+%p%s%d+%p%s%d+') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p%s(%d+)%p%s(%d+)', 3, 315)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(одежду)|(биркой)]%s№%d+%p%s№%d+%p%s№%d+') then
    clothes_ids = get_clothes_id(str, '%s№(%d+)%p%s№(%d+)%p%s№(%d+)', 3, 316)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(биркой)]%s%d+%s?%s%d+%s?%s%d+$') then
    clothes_ids = get_clothes_id(str, '[(биркой)]%s(%d+)%s?%s(%d+)%s?%s(%d+)$', 3, 317)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('\"%d+%s?%p%s?%d+%s?%p%s?%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%s?%p%s?(%d+)%s?%p%s?(%d+)\"", 3, 318)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    -- Продам скины 116 125 126 тел 1991
  elseif str:find('[(пошив)|(бирками)|(биркой)|(скины)|(одежду)]%s%d+%s%d+%s%d+') then
    clothes_ids = get_clothes_id(str, "[(пошив)|(бирками)|(биркой)|(скины)|(одежду)]%s(%d+)%s(%d+)%s(%d+)", 3, 318)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[Кк]упл[юб]%s%d+%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "[Кк]упл[юб]%s(%d+)%s(%d+)%s(%d+)$", 3, 318)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('скины %d+, %d+, %d+$') then
    -- продам скины 104, 110, 286
    clothes_ids = get_clothes_id(str, "скины (%d+), (%d+), (%d+)$", 3, 321)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('биркой №%d+ ,№%d+ и №%d+.') then
    -- Продам одежду с биркой №188 ,№189 и №299. Цена договорная.
    clothes_ids = get_clothes_id(str, "биркой №(%d+) ,№(%d+) и №(%d+).", 3, 322)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%W+ одежду %d+, %d+ ,%d+ %W+$') then
    -- куплю одежду 240, 294 ,295 договор
    clothes_ids = get_clothes_id(str, "%W+ одежду (%d+), (%d+) ,(%d+) %W+$", 3, 323)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('одежду %d+%s%p%s%d+%sи%s%d+$') then
    clothes_ids = get_clothes_id(str, "одежду (%d+)%s%p%s(%d+)%sи%s(%d+)$", 3, 324)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('бирки %p%d+%p%d+%p%d+%p') then
    clothes_ids = get_clothes_id(str, "бирки %p(%d+)%p(%d+)%p(%d+)%p", 3, 325)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('№%d+%p %d+ и %d+') then
    clothes_ids = get_clothes_id(str, "№(%d+)%p (%d+) и (%d+)", 3, 326)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act) 
    
    --[Кк]упл[юб]%s%d+%s%d+%s%d+$
  --2 скина

  elseif str:find('скины%s%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "скины%s(%d+)%p(%d+)$", 2, 21)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(пошива)|(биркой)]^[Цена]%s%d+%p%s?%d+%s?') then
    clothes_ids = get_clothes_id(str, "[(пошива)|(биркой)]^[Цена]%s(%d+)%p%s?(%d+)%s?", 2, 22)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[Пп]родам%s%d+%sи%s%d+$') then
    clothes_ids = get_clothes_id(str, "[Пп]родам%s(%d+)%sи%s(%d+)$", 2, 23)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('^%d+%s%d+%sкуплю$') then
    clothes_ids = get_clothes_id(str, '^(%d+)%s(%d+)%sкуплю$', 2, 23)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)

  elseif str:find('у%s%d+%p%s%d+%sб') then
    clothes_ids = get_clothes_id(str, "у%s(%d+)%p%s(%d+)%sб", 2, 25)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('пошива%s%d+%s%d+%s') then
    clothes_ids = get_clothes_id(str, "пошива%s(%d+)%s(%d+)%s", 2, 26)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  -- продам скин 107 103
  -- Продам скин 107,86
  elseif str:find('^%W+%sскин%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "^%W+%sскин%s(%d+)%s(%d+)$", 2, 2700)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('^%W+%sскин%s%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "^%W+%sскин%s(%d+)%p(%d+)$", 2, 2700)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('с%s%W-%s№%d+%p%s%d+%p%s?%W+') then -- Продам одежду с бирками №124, 126. Цена: Договорная.
    clothes_ids = get_clothes_id(str, "с%s%W-%s№(%d+)%p%s(%d+)%p%s?%W+", 2, 2700)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
    -- 306 пошив и 309
  elseif str:find('%s%d+%s%W+%sи%s%d+%s') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%s%W+%sи%s(%d+)%s', 2, 2700)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%sили%s%d+%s') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%sили%s(%d+)%s', 2, 27)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+%p%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%p(%d+)\"", 2, 28)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+%s%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%s(%d+)\"", 2, 281)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%s\"(%d+)\"", 2, 29)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%p%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%p%s\"(%d+)\"", 2, 291)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s%d+%sскин$') then 
    clothes_ids = get_clothes_id(str, "%s(%d+)%s(%d+)%sскин$", 2, 210)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%s[иИ]%s%d+$?') then
    clothes_ids = get_clothes_id(str, "(%d+)%s[иИ]%s(%d+)", 2, 211)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[^(цена)]%s%d+%p+%d+%s[^(кк)]") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+(%d+)%s", 2, 212)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[^(бюджет)]%s%d+%s+%d+%s") then
    clothes_ids = get_clothes_id(str, "(%d+)%s+(%d+)%s", 2, 213)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("^[(ц)|(Ц)ена]%s%d+%p+%s?%d+$") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+%s?(%d+)$", 2, 214)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+%p+%s?%d+%p%s?Ц") then
    clothes_ids = get_clothes_id(str, "%s(%d+)%p+%s?(%d+)%p", 2, 215)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("№%d+%p+%s?%d+$") then
    clothes_ids = get_clothes_id(str, "№(%d+)%p+%s?(%d+)$", 2, 216)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("№%d+%sи%s№%d+$?") then
    clothes_ids = get_clothes_id(str, "№(%d+)%sи%s№(%d+)$?", 2, 217)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("№%d+%p№%d+$?") then
    clothes_ids = get_clothes_id(str, "№(%d+)%p№(%d+)$?", 2, 217)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%sи%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%sи%s\"(%d+)\"", 2, 218)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("скин%s%d+%p%s%d+[^(кк)]") then
    clothes_ids = get_clothes_id(str, "скин%s(%d+)%p%s(%d+)", 2, 219)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+, %d+$") then
    clothes_ids = get_clothes_id(str, "(%d+), (%d+)$", 2, 220)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+, %d+%s?[^%p|(kk)]$") then
    clothes_ids = get_clothes_id(str, "(%d+), (%d+)%s?[^%p]", 2, 221)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[Пп]родам%s%d+%s%d+$") then
    clothes_ids = get_clothes_id(str, "[Пп]родам%s(%d+)%s(%d+)$", 2, 229)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("одежду%s%d+[.] %d+$") then
    clothes_ids = get_clothes_id(str, "(%d+)[.] (%d+)$", 2, 222)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("№%d+%p?%s№%d+$?") then
    clothes_ids = get_clothes_id(str, "№(%d+)%p?%s№(%d+)$?", 2, 223)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[(одежду)]%s%d+%p%d+$") then
    clothes_ids = get_clothes_id(str, "[(одежду)]%s(%d+)%p(%d+)$", 2, 224)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(бирки)|(бирками)|(биркой)]%d+%s[-]%s%d+$?') then
    clothes_ids = get_clothes_id(str, "[(бирки)|(бирками)|(биркой)](%d+)%s[-]%s(%d+)", 2, 227)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(бирки)|(бирками)|(биркой)]%s%d+,%d+$') then
    clothes_ids = get_clothes_id(str, "[(бирки)|(бирками)|(биркой)]%s(%d+),(%d+)$", 2, 225)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(пошив)|(бирками)|(биркой)|(скины)|(одежду)][^(Цена)]%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "[(пошив)|(бирками)|(биркой)|(скины)|(одежду)][^(Цена)]%s(%d+)%s(%d+)$", 2, 226)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s%d+%s[(пошив)|(скини)]') then
    clothes_ids = get_clothes_id(str, "%s(%d+)%s(%d+)%s[(пошив)|(скини)]", 2, 226)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%W+ №%d+ & №%d+.') then
    clothes_ids = get_clothes_id(str, "%W+ №(%d+) & №(%d+).", 2, 226)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(бирки)|(бирками)|(биркой)]%s\"%d+,%s?%d+\"%p') then
    clothes_ids = get_clothes_id(str, "[(бирки)|(бирками)|(биркой)]%s\"(%d+),%s?(%d+)\"%p", 2, 228)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
  elseif str:find('^%w+ skin %d+ %d+$') then
    clothes_ids = get_clothes_id(str, '^%w+ skin (%d+) (%d+)$', 2, 229)
    h_string = action[act].."одежду с бирками "..clothes_ids..". "..get_price(str, act)
    --debug(h_string, 2)
  --elseif str:find("%d+ за") or str:find("%d+ цена") then
    --h_string = action[act].."одежду с биркой "..get_price(str)
  --1 скин
  elseif str:find("[Пп]родам%s%d+$") then skin_id = str:match("[Пп]родам%s(%d+)$")
   --"Clothe: 1", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("[Пп]родам%s%d+%s%d+кк$") then skin_id = str:match("[Пп]родам%s(%d+)%s%d+кк$")
    --"Clothe: 1", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("[Кк]у[п]?л[юб]%s%d+$") then skin_id = str:match("[Кк]у[п]?л[юб]%s(%d+)$")
    --debug("Clothe: 2", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("одежд[уы] %d+%s?") then skin_id = str:match("%s(%d+)")
    --debug("Clothe: 3", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("одежд[уы]%s(%d+)%sпо[д]?шив") then skin_id = str:match("%s(%d+)%s")
    --debug("Clothe: 4", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("[№N]%s?%d+") then skin_id = str:match("[№N]%s?(%d+)")
    --debug("Clothe: 5", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%sбирку") then skin_id = str:match("%s(%d+)%s")
    --debug("Clothe: 6", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("с[ки][ки]н%s%d+%s") then skin_id = str:match("с[ки][ки]н%s(%d+)%s")
   --debug("Clothe: 7", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("скин%d+%s") then skin_id = str:match("скин(%d+)%s")
    --debug("Clothe: 7.1", 4)
     h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%d+%s%sскин") then skin_id = str:match("(%d+)%s%sскин")
      --debug("Clothe: 7.1", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%sскин") then skin_id = str:match("%s(%d+)%s")
   --debug("Clothe: 7", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%scкин") then skin_id = str:match("%s(%d+)%s")
    --debug("Clothe: 7", 4)
     h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("№%s?\"%d+\"") then skin_id = str:match("№%s?\"(%d+)\"")
   --debug("Clothe: 8", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s?\"%s%d+%s\"") then skin_id = str:match("%s?\"%s(%d+)%s\"")
    --debug("Clothe: 8", 4)
     h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("№%s?%d+") then skin_id = str:match("№%s?(%d+)")
   --debug("Clothe: 9", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+(%s|$)") then skin_id = str:match("%s(%d+)(%s|$)")
   debug("Clothe: 10", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("[^(юджет)]%s%d+%s?%s?[(СКИН)|(скин)|(cкин)|(цена)|(пошив)|(ПОШИВ)|(одежду)|(костюм)|(шмот)][^(кк)|(млн)]") then skin_id = str:match("%s(%d+)%s?%s?[(СКИН)|(скин)|(cкин)|(цена)|(пошив)|(ПОШИВ)|(одежду)|(костюм)|(шмот)]")
   debug("Clothe: 11", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s[(биркой)|(Биркой)|(бирка)|(бирку)|(пошив)|(пошива)|(пошивлм)|(подшивы)|(скин)|(костюм)|(одежду)|(id)]+%s%s?%p?%d+%p?%s?") then skin_id = str:match("%s[(биркой)|(Биркой)|(бирка)|(бирку)|(пошив)|(пошива)|(пошивлм)|(подшивы)|(скин)|(костюм)|(одежду)|(id)]+%s%s?%p?(%d+)%p?%s?")
   debug("Clothe: 12", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s[сc]кин%s%d+%s") then skin_id = str:match("%s[сc]кин%s(%d+)%s")
   debug("Clothe: 13", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+%sid%sskin") then skin_id = str:match("%s(%d+)%sid%sskin")
   debug("Clothe: 14", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("[Пп]родам%s%d+%sцена") then skin_id = str:match("[Пп]родам%s(%d+)%sцена")
   debug("Clothe: 15", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+%ssell$") then skin_id = str:match("(%d+)%ssell$")
   debug("Clothe: 16", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+%sскин") then skin_id = str:match("(%d+)%s")
   debug("Clothe: 17", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act) --new
  elseif str:find("sell%s%d+%sskin") then skin_id = str:match("sell%s(%d+)%sskin")
   debug("Clothe: 18", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("skin%s%d+%s") then skin_id = str:match("skin%s(%d+)%s")
   debug("Clothe: 18", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("skin%s%d+$") then skin_id = str:match("skin%s(%d+)$")
    debug("Clothe: 18", 4)
     h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+ %d+.%dкк") then skin_id = str:match("(%d+) %d+.%dкк")
   debug("Clothe: 19", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W+%s%d+%sк$") then skin_id = str:match("^%W+%s(%d+)%sк$")
   debug("Clothe: 20", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W+%s%d+%p%W+$") then skin_id = str:match("^%W+%s(%d+)%p%W+$")
    debug("Clothe: 21", 4)
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("№%s?%p%d+%p") then skin_id = str:match("№%s?%p(%d+)%p")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("[Bb]uy %d+ %w-$") then skin_id = str:match("[Bb]uy (%d+) %w-$")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+%pй скин%p") then skin_id = str:match("(%d+)%pй скин%p")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W- %d+ %W-$") then skin_id = str:match("^%W- (%d+) %W-$")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W- ски %d+") then skin_id = str:match("^%W- ски (%d+)")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find("продам %d+ за") then skin_id = str:match("продам (%d+) за")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  elseif str:find(": %d+. [Цц]ен") then skin_id = str:match(": (%d+). [Цц]ен")
    h_string = action[act].."одежду с биркой №"..skin_id..". "..get_price(str, act)
  else
    print("{cc0000}ERROR 8 (clothes):{b2b2b2}", str)
    h_string = "ERROR"
  end
  --debug(h_string, 2)
  return h_string
end

function get_clothes_id(str, pattern, count, pattern_id)
  debug(str.." | ID: "..pattern_id, 2)

  local results = string.match(str, "(%d+)%p%s(%d+)%p%s(%d+)")
  if count == 2 then
    num1, num2 = str:match(pattern)
    withn = num1:gsub(num1, "№"..num1)..' и '..num2:gsub(num2, "№"..num2)
    return withn
  elseif count == 3 then
    num1, num2, num3 = str:match(pattern)
    withn = num1:gsub(num1, "№"..num1)..', '..num2:gsub(num2, "№"..num2)..' и '..num3:gsub(num3, "№"..num3)
    return withn
    
  else print("{cc0000}ERROR 8 (clothes numbers):{b2b2b2}", str) return "Error..."
  end
end

function name_upper(f, l)
  f = f:gsub(f:sub(0, 1), f:sub(0, 1):upper())
  l = l:gsub(l:sub(0, 1), l:sub(0, 1):upper())
  return f, l
end

function change_vehicle_type(name)
  if name:find("Stuntplane") then
    short_type = "с"
  elseif name:find("Maverick") then
    short_type = "в"
  else
    short_type = "а"
  end
  return short_type
end

function vechicles(str, trade, v_type, model)
  print("{18c860}VEHICLES:{B2B2B2}", str, trade)
  if str:find("рынок") or str:find("р[ыи]нке") or str:find("укци") or str:find("[Вв]ы[с]?%p?тавл[ея]н") then
    return "На авторынке выставлен "..v_type.." марки «"..model.."»"..car_tuning(str).." "..get_price(str, trade_type(str))
  elseif trade == "my_change" or trade == "ur_change" or trade == "change" or trade == "d_change" then
    print(tableToString({v_type, model, car_tuning(str), car_exchange(str), get_price(str, trade_type(str))}))
    left_part, right_part = car_exchange(str)
    print(tableToString({action[trade], left_part, right_part, get_price(str, trade)}))
    short_type_left = change_vehicle_type(left_part)
    short_type_right = change_vehicle_type(right_part)
    if right_part:find("ваш транспорт") then
      right_part_full = "ваш транспорт"
    else
      right_part_full = short_type_right.."/м "..right_part
    end
    car_exch_str = action[trade]..short_type_left.."/м "..left_part.." на "..right_part_full..". "..get_price(str, trade)
    print(car_exch_str)
    return car_exch_str
  end
  print(action[trade], v_type, model, car_tuning(str), get_price(str, trade))
  a = get_price(str, trade)
  print("{AC41BF}"..a)
  return action[trade]..v_type.." марки «"..model.."»"..car_tuning(str)..". "..get_price(str, trade)
end

function car_exchange(str)
  split_string = {}
  split_string["left"], split_string["right"] = str:match("(.+)%sна%s(.+)")
  print(split_string["left"], split_string["right"])
  if split_string["right"]:find("ваш т%p?с") or split_string["right"]:find("ваше авто") then
    print(12341)
    return car_names(split_string["left"])..car_tuning(split_string["left"]), "ваш транспорт"
  end
  print("{BAF25E}2: "..car_names(split_string["left"]).."{F2E25E}"..split_string["right"])
  if str:find("на%s.+[(%s)|(%p)]") and not str:find("мотоцикл") then
    car_name = str:match("на%s(.+)[(%s)|(%p)]")
  -- elseif str:find("на%s.+[(%s)|(%p)]") and not str:find("мотоцикл") then
  --   car_name = str:match("на%s(.+)[(%s)|(%p)]")
  elseif str:find("мотоцикл (.+) на авто") then
    return "ваш автомобиль"
  end
  return car_names(split_string["left"])..car_tuning(split_string["left"]), car_names(split_string["right"])..car_tuning(split_string["right"])
end

function car_names(str)
  if str:find("[Nn][Rr][Gg]") or str:find("[Нн][Рр][Гг]") or str:find("NRG") then -- ПРОДАЖА ТРАНСПОРТА
    car_name = "«NRG-500»"
  elseif str:find("[Ff][Cc][Rr]") or str:find("[Фф][СсКк][Рр]") then -- ПРОДАЖА ТРАНСПОРТА
    car_name = "«FCR-900»"
  elseif str:find("[Ff]reeway") or str:find("[Фф]ривей") then -- ПРОДАЖА ТРАНСПОРТА
    car_name = "«Freeway»"
  elseif str:find("GT") or str:find("гт[^а]") or str:find("супер гт»") or str:find("Super GT") or str:find("[(super)|(супер)] gt") then
    car_name = "«Super GT»"
  elseif str:find("султ[(ан)]?") or str:find("s[uy]ltan") or str:find("[Сс]у[л]?тан") or str:find("S[uy]ltan") or str:find("S[YU]LTAN") or str:find("[Сс]улик") then 
    car_name = "«Sultan»"
  elseif str:find("[Bb][Ff]") or str:find("[Ii]njection") or str:find("[Бб][Фф]") then 
    car_name = "«BF Injection»"
  elseif str:find("м[еа]в[ае]р") or str:find("маврик") or str:find("averi[c]?k") or str:find("мавик") or str:find("mavik") or str:find("аве[р]?ик") or str:find("averiс") then 
    car_name = "«Maverick»"
  elseif str:find("zrx") or str:find("zrx 350") or str:find("zrx-350") or str:find("ZRX") or str:find("[Zz][Rr]") or str:find("ZRX-350") or str:find("ZRX 350") then 
    car_name = "«ZRX-350»"
  elseif str:find("ul[l]?et") or str:find("[Бб]улк[уа]") or str:find("[Бб]ул[реи]т") or str:find("[Бб]улл[л]?ет") then
    car_name = "«Bullet»"
  elseif str:find("[Pp]remier") or str:find("PREMIER") or str:find("[Пп]ремьер") then
    car_name = "«Premier»"
  elseif str:find("[Ee]legant") or str:find("[ЕеЭэ]легант") then
    car_name = "«Elegant»"
  elseif str:find("[Ss][ea]nti[n]?el") or str:find("[Сс]ентинел") then
    car_name = "«Sentinel»"
  elseif str:find("(.*)an%s?(.*)ing") or str:find("(.*)[аэе]н[дг]?%s?ин[у]?г") or str:find("[Сс]андКинг") or str:find("[Сс][аэ]ндин[г]?") or str:find("%s[СSs][КKk]%s") or str:find("(%s)ск(%s)") or str:find("(%s)ск$") or str:find("sek ft") or str:find("(%s)с[аэ]нд(%s)") or str:find("(%s)САНД КИНГ") or str:find("SANDKING") then
    car_name = "«Sandking»"
  elseif str:find("tre[ts]ch") or str:find("сретч") or str:find("стретч") or str:find("[Ss]tr[ae][t]?ch") or str:find("[Лл]имуз[и]?н") then
    car_name = "«Stretch»"
  elseif str:find("легию") or str:find("легия") or str:find("[Ee]leg[yu]") or str:find("legy") or str:find("enegy") or str:find("[ЭэЕе]леги") or str:find("[ЭэЕе]ле[дж][жд]и") or str:find("[Ее]лег") then
    car_name = "«Elegy»"
  elseif str:find("риот %+") or str:find("РИОТ %+") or str:find("riot %+") or str:find("RIOT %+") or str:find("роит %+") or str:find("патрик %+") or str:find("хам[м]?ер %+") then
    car_name = "«Patriot +»"
  elseif str:find("РИОТ") or str:find("риот") or str:find("riot") or str:find("RIOT") or str:find("роит") or str:find("патрик") or str:find("хам[м]?ер") then
    car_name = "«Patriot»"
  elseif str:find("[Mm]onster") or str:find("[Мм]онст[е]?р") or str:find("MONSTER") or str:find("МОНСТ[Е]?Р") then
    car_name = "«Monster A»"
  elseif str:find("[Пп]ревион") or str:find("[Pp]revion") then
    car_name = "«Previon»"
  elseif str:find("[Хх]от%p?[Дд]ог") or str:find("[Hh]ot%p?[Dd]og") then
    car_name = "«Hotdog»"
  elseif str:find("[Аа]дмирал") or str:find("[Aa]dmiral") then
    car_name = "«Admiral»"
  elseif str:find("х[ае]нтли") or str:find("[Hh]unt[le][el]y") or str:find("[ае]нтли") or str:find("untly") or str:find("ХАНТЛИ") then
    car_name = "«Huntley»"
  elseif str:find("[Тт][Цц]?[Уу][Рр][Ии][Кк]") or str:find("[Тт]уризм[ао]") or str:find("[Tt][Uu]rismo") then
    car_name = "«Turismo»"
  elseif str:find("[Cc]adrona") or str:find("[Кк]адрона") then
    car_name = "«Cadrona»"
  elseif str:find("[^(имени%s)][Aa]lpha") or str:find("[Аа]льфа") then
    car_name = "«Alpha"
  elseif str:find("[Uu]ranus") or str:find("[Уу]ранус") then
    car_name = "«Uranus»"
  elseif str:find("[Jj]ester") or str:find("[Дд]жестер") then
    car_name = "«Jester»"
  elseif str:find("[Bb]uffalo") or str:find("[Бб]уф[ф]?ал[л]?о") then
    car_name = "«Buffalo»"
  elseif str:find("[Pp]hoenix") or str:find("[Фф]еникс") then
    car_name = "«Phoenix"
  elseif str:find("[Hh]otk[hn]ife") or str:find("[Хх]откнайф") then
    car_name = "«Hotknife»"
  elseif str:find("[Mm]esa") or str:find("[Мм]ес[ау]") then
    car_name = "«Mesa»"
  elseif str:find("[Oo]ceanic") or str:find("[Оо]кеаник") then
    car_name = "«Oceanic»"
  elseif str:find("[Bb]ansh") or str:find("[Бб]ан[ь]?ш") then
    car_name = "«Banshee»"
  elseif str:find("[Ss]avan") or str:find("[Сс]аван") then
    car_name = "«Savanna»"
  elseif str:find("[Pp]eren[n]?i[ea]l") or str:find("[Пп]ерениал") then
    car_name = "«Perennial»"
  elseif str:find("[Bb]roadway") or str:find("[Бб]родв[эе]й") then
    car_name = "«Broadway»"
  elseif str:find("[Yy]osemite") or str:find("[Йй]осемит") then
    car_name = "«Yosemite»"
  elseif str:find("[Rr]ancher") or str:find("[Рр]анчер") then
    car_name = "«Rancher»"
  elseif str:find("[Cc]lover") or str:find("[КкСс]ловер") then
    car_name = "«Clover»"
  elseif str:find("[Mm]anana") or str:find("[Мм]анан[ау]") then
    car_name = "«Manana»"
  elseif str:find("[Ss]abre") or str:find("[Сс]ейбр") then
    car_name = "«Sabre»"
  elseif str:find("[Кк]омет") or str:find("[CcСс]omet") then
    car_name = "«Comet»"
  elseif str:find("[Сс]тратум") or str:find("[Ss]tratum") then
    car_name = "«Stratum»"
  elseif str:find("[Bb]andit") or str:find("[Бб]агги") or str:find("[Бб]андито") and not str:find("кеан") then
    car_name = "«Bandito»"
  elseif str:find("шамал") or str:find("hamal") or str:find("шаман") or str:find("shaman") then
    car_name = "«Shamal»"
  elseif str:find("[Bb]eagle") or str:find("[Бб]игл") then
    car_name = "«Beagle»"
  elseif str:find("[Cc]ropduster") then
    car_name = "«Cropduster»"
  elseif str:find("[Dd]odo") or str:find("[Дд]одо") then
    car_name = "«Dodo»"
  elseif str:find("t[au]n(.*)[Pp]la[(ne)|(y)]") or str:find("tun[t]?[Pp]la[(ne)|(y)]") or str:find("станпле[й]?н") or str:find("СТАНТПЛАН") or str:find("[Сс]тант[Пп]лан") then
    car_name = "«Stuntplane»"
  elseif str:find("сперроу") or str:find("спароу") or str:find("arrow") or str:find("сперов") or str:find("спаров") then
    car_name = "«Sparrow»"
  elseif str:find("[Rr]ain[e]?dance") or str:find("[Рр]ейнда") then
    car_name = "«Raindance»"
  elseif str:find("[Ll]eviathan") or str:find("[Лл]евиа[тф]ан") then
    car_name = "«Leviathan»"
  elseif str:find("arquis") or str:find("маркиз") or str:find("маркис") then
    car_name = "«Marquis»"
  elseif str:find("[Vv]ortex") or str:find("[Вв]ортекс") then
    car_name = "«Vortex»"
  elseif str:find("heetah") or str:find("читах") or str:find("итах") or str:find("читу") or str:find("чейтах") then
    car_name = "«Cheetah»"
  elseif not str:find("человека") and str:find("nf[er][er]nus") or str:find("н[ф]?ернус") or str:find("инф[ау]") or str:find("[Ii]nf[eu]") or str:find("[иИ][Нн][Фф][Ее][Рр]") or str:find("инф[р]?енус") or str:find("INFERNUS") or str:find("infa") then
    car_name = "«Infernus»"
  elseif str:find("от%s?ринг б") or str:find("otring [BbВв]") or str:find("otring B") or str:find("[Хх]отринг [БбBbВв]") or str:find("acer [BbВв]") or str:find("acer B") or str:find("[Рр]ейсер [Бб]") then
    car_name = "«Hotring Racer B»"
  elseif str:find("отринг [AaАа]") or str:find("otring a") or str:find("ot[Rr]ing A") or str:find("[Хх]отринг А") or str:find("acer a") or str:find("acer A") or str:find("ейсер А") then
    car_name = "«Hotring Racer A»"
  elseif str:find("отринг") or str:find("otring") or str:find("хотрин[Гг]") or str:find("acer") then
    car_name = "«Hotring Racer»"
  end
  return car_name
end

function car_tuning(str)
  if str:find("ft") or str:find("[Фф][п]?т") or str:find("[Ff][Tt]") or str:find("[ФфТт][ТтФф]") or str:find("[Фф]ул") or str:find("%s[Ээ]?[ФфFf]%s[TtТт][Ии]?$") then
    return " [FT]"
  elseif str:find("[^(S.W.A)]%pT%p") or str:find("%sT%s") or str:find("%sT%p") or str:find("тюн[еи]ный") or str:find("[^(бе)]з тюни") or str:find("с тюнингом") then
    return " [T]"
  else
    return ""
  end
end
--цена 1.5 млн 
function get_price(str, act)
  -- debug(str, 2)
  -- debug(act, 5)
  str = str:gsub("+торг", "")
  if str:find("[Дд][о]?[вш]?го[рво]") or str:find("[Дд]о[во][гв][о]?рная") or str:find("[Цц]ена%p%p%p") or str:find("[Жж]огворная") or str:find("Д[Оо]гов") or str:find("дловр") or str:find("[^%p][Дд]ог") or str:find("цена любая") or str:find("цена дг") or str:find("[Юю]огоо") or str:find("[Сс]в[о]?б[ю]?о") or str:find("[Сс]овбо") or str:find("огов") or str:find("[Цц]ена дг$") or str:find("[Жж]огвоораня") or str:find("[Жж]огвррная") or str:find("джет[:]?%s[(неогр)|(Большо)]") then
    -- debug(str.." "..act, 3)
    return "Цена договорная"
    --куплю одежду пошива 303,304,305
  elseif str:find("[Сс]тавка") and str:find("гос") then
    
    return "Ставка по гос. цене"
  elseif str:find("[цй]ен[ае]") or str:find ("за %d") or str:find("%d+кк") or str:find("%d КК$") or str:find("[Кк][Кк][^Сс]") or str:find("Цена") or str:find("ю[дт]жет") or str:find("%d[кk]$") or str:find("[^ea][kr][kr]") and not str:find("договорная") or act == "surcharge" then
    debug(string.format("%s\n%s", "With price type", str), 2)
    if str:find("%d%p%dкк%s") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("кк%s")-1).."00.000$" k = 0
    elseif str:find("%W-%s%d%p%d%dкк$") then price = ''..str:sub(str:find("%s%d+%p%d%dк")+1, str:find("кк")-1).."0.000$" k = 1
    elseif str:find("%W-%s%d%p%dкк$") then price = ''..str:sub(str:find("%s%d+%p%dк")+1, str:find("кк")-1).."00.000$" k = 2321
    elseif str:find("%W-%s%d%p%d+к$") then price = ''..str:sub(str:find("%s%d+%p%d+к")+1, str:find("к")-1)..".000$" k = 2156
    elseif str:find("%d%p%dккк$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("ккк$")-1).."00.000.000$" k = 3
    elseif str:find("%d+ккк$") then price = ''..str:sub(str:find("%s%d+к")+1, str:find("ккк$")-1)..".000.000.000$" k = 4
    elseif str:find("%d+kk%+торг") then price = ''..str:sub(str:find("%d+kk"), str:find("k")-1)..".000.000$ + торг" k = 0098
    elseif str:find("%d+%s?млр[д]?$") then price = ''..str:sub(str:find("%s%d+%s?мл")+1, str:find("%s?млр[д]?$")-1)..".000.000.000$" k = 5
    elseif str:find("%d+[.,]%dkk") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("kk")-1).."00.000$" k = 6
    elseif str:find("%d+[.,]%dкк") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("кк")-1).."00.000$" k = 7
    elseif str:find("%d+[.,]%dк$") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("%dк")).."00$" k = 7
    elseif str:find("%d[.,]%d%sбюджет") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("%sбюджет")-1).."00.000$" k = 8
    elseif str:find("%s%d+kk$") then price = ''..str:sub(str:find("%s%d+k")+1, str:find("kk$")-1)..".000.000$" k = 9
    elseif str:find("%W%p%d+kk$") then price = ''..str:sub(str:find("%W%p%d+k")+2, str:find("kk$")-1)..".000.000$" k = 91
    elseif str:find("%s%d+[кr][кr]$") then price = ''..str:sub(str:find("%s%d+[кr]")+1, str:find("[кr][кr]$")-1)..".000.000$" k = 10
    elseif str:find("%s%d+%sмлн") then price = ''..str:sub(str:find("%s%d+%sм")+1, str:find("%sмлн")-1)..".000.000$" k = 11
    elseif str:find("%s%d+млн") then price = ''..str:sub(str:find("%s%d+м")+1, str:find("млн")-1)..".000.000$" k = 12
    elseif str:find("%s%d+лямов") then price = ''..str:sub(str:find("%s%d+л")+1, str:find("лямов")-1)..".000.000$" k = 12
    elseif str:find("%W%p%d+кк$") then price = ''..str:sub(str:find("%p%d+к")+1, str:find("кк$")-1)..".000.000$" k = 131
    elseif str:find("%s%d+kk%s") then price = ''..str:sub(str:find("%s%d+k")+1, str:find("kk%s")-1)..".000.000$" k = 14
    elseif str:find("%s%d+%pOOO%pOOO") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%pOOO")-1)..".000.000$" k = 15
    elseif str:find("%s%d+OO%pOOO%pOOO") then price = ''..str:sub(str:find("%s%d")+1, str:find("%dO")).."00.000.000$" k = 15
    elseif str:find("%d%p%d[OО][ОO]%p[ОO][ОO][ОO]") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%p%d[ОO][ОO]")+1).."00.000$" k = 15
    elseif str:find("а%p%d+%pOOO%pOOO") then price = ''..str:sub(str:find("а%p%d+")+2, str:find("%pOOO")-1)..".000.000$" k = 16
    elseif str:find("а%p%d+кк$") then price = ''..str:sub(str:find("%p%d+")+1, str:find("кк$")-1)..".000.000$" k = 17
    elseif str:find("%d%p%dkk") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("kk")-1):gsub("/", "."):gsub("\"", ".").."00.000$" k = 18
    elseif str:find("%d%p%dкк") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("кк")-1):gsub("/", "."):gsub("\"", ".").."00.000$" k = 19
    elseif str:find("%d%p%dКК") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("КК")-1):gsub("/", "."):gsub("\"", ".").."00.000$" k = 19
    elseif str:find("%d+%sКК$") then price = ''..str:sub(str:find("%s%d+%s")+1, str:find("КК")-1):gsub("/", "."):gsub("\"", "."):gsub(" ", "")..".000.000$" k = 19
    elseif str:find("%d%p%d%skk") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%skk)")-1).."00.000$" k = 20
    elseif str:find("%d%p%d%sкк") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%sкк")-1).."00.000$" k = 20
    elseif str:find("%d%p%d%s?млн") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%s?млн")-1).."00.000$" k = 41
    elseif str:find("%s%d%sмлн") then price = ''..str:sub(str:find("%s%d+"), str:find("%sмлн")-1)..".000.000$" k = 42
    elseif str:find("%s%d+%s[Мм][Лл][Нн]") then price = ''..str:sub(str:find("%s%d+")+1, str:find("[Мм][Лл][Нн]")-1):gsub(" ", "")..".000.000$" k = 42
    elseif str:find("%s%d%sлям") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%sлям")-1)..".000.000$" k = 43
    elseif str:find("%s%d%sмилли") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%sмилли")-1)..".000.000$" k = 44
    elseif str:find("%d%sляма") then price = ''..str:sub(str:find("%s%d")+1, str:find("%sл")-1)..".000.000$" k = 23
    elseif str:find("%s%d+%p%d+%$.") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")) k = 18
    elseif str:find("%s%$%d+%p%d+%p%d+.") then price = ''..str:sub(str:find("%$%d+")+1, str:find("%p$")-1) k = 18
    elseif str:find("%s%d%p%d$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")).."00.000$" k = 188
    elseif str:find("[^(тел.)]%s%d+%p%d+$") then price = ''..str:sub(str:find("%s%d+%p%d+")+1, str:find("$")):gsub("$", "").."$" k = 191
    elseif str:find("%d%p%d$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")-1).."00.000$" k = 3
    elseif str:find("%s%d+%p%d+kk$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("kk$")-1):gsub(",", ".")..".000$" k = 30
    elseif str:find("%s%d+%p%d+кк$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("кк$")-1):gsub(",", ".")..".000$" k = 30
    elseif str:find("%s%d+%p%d+%s%sкк$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s%sкк$")-1):gsub(",", ".")..".000$" k = 30
    elseif str:find(".%d00%p00%$$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%d%$")).."0$" k = 81
    elseif str:find("[:]?%s%d+%p%d+%p%d+[(%$)|(;)|(#)]") then price = ''..str:sub(str:find('[:]?%s%d+%p%d+%p%d+')+1, str:find("%d[(%$)|(;)|(#)]")):gsub(" ", "").."$" k = 4
    elseif str:find("[:]?%s%d+%p%d+%p%d+р") then price = ''..str:sub(str:find('%d+%p%d+%p%d+'), str:find("%dр")).."$" k = 34
    elseif str:find("[:]%s?%d+%p%d%d%d%p%d+%s?%$") then price = ''..str:sub(str:find('%d+[,.]%d'), str:find("%d%s?%$")).."$" k = 12
    elseif str:find("%s%d%d%d%p%d+%p%d+%s") then price = ''..str:sub(str:find('%s%d%d%d%p'), str:find("%d%s")).."$" k = 13
    elseif str:find("%s%d+%s%d+%s%d+%$") then price = ''..str:sub(str:find('%d+%s'), str:find("%$")-1):gsub(" ", ".").."$" k = 132
    elseif str:find("[^(скины)]%s%d+%s%d+%s%d+%s?") then price = ''..str:sub(str:find('%s%d')+1, str:find("%p?$")-1):gsub(" ", ".").."$" k = 14
    elseif str:find("[:]%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('[:]%s%d+%p')+2, str:find("%d$")).."$" k = 5
    elseif str:find("%s%d+%s?[Кк][Кк]") then price = ''..str:sub(str:find("%s%d+%s?[Кк]")+1, str:find("[Кк][Кк]")-1):gsub(" ", "")..".000.000$" k = 6
    elseif str:find("а:%d+%s?[Кк][Кк]") then price = ''..str:sub(str:find('а:%d+%s?[Кк]')+2, str:find("%s?[Кк][Кк]")-1)..".000.000$" k = 19
    elseif str:find("%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('%s%d+%p%d+')+1, str:find("$")).."$" k = 16
    elseif str:find("%s%d+%p%d+%p%d+%$%p$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."" k = 15
    elseif str:find(":%d+.%d+%$") then price = ''..str:sub(str:find(":%d+%p")+1, str:find("%$")-1).."$" k = 7 
    elseif str:find("%W-%s%d+%p%d+%p") then price = ''..str:sub(str:find("%s%d+%p%d+")+1, str:find("[%$]?%p$")-1).."$" k = 71 
    elseif str:find(":%d+.%d+.%d+$") then price = ''..str:sub(str:find(":%d+%p")+1, str:find("$")-1).."$" k = 129
    elseif str:find("%s%d+[кk]$") then price = ''..str:sub(str:find("%s%d+[кk]")+1, str:find("[кk]$")-1):gsub(" ", "")..".000$" k = 9
    elseif str:find("[Цц]ена%s%d+%s%d+$") then price = ''..str:sub(str:find("ена%s%d+%s")+4, str:find("$")-1):gsub(" ", ".").."$" k = 38
    elseif str:find("ена%s%d+%s%d+$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("$")):gsub(" ", ".").."$" k = 9
    elseif str:find("[Цц]ена%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("а%d+")+1, str:find("%$")) k = 92
    elseif str:find("[Цц]ена%p%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("а%p%d+")+2, str:find("%$")) k = 92
    elseif str:find("%s%d%p%d+$") then price = ''..str:sub(str:find("ена%s%d")+4, str:find("%d+$")+2)..".000$" k = 10
    elseif str:find("%s%d+%p%d+%p%d+%p%d+%s") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s$")):gsub(" ", "") k = 22
    elseif str:find("%s%d+%p%d+%p%d+%p%d+%s?") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d%$")).."$" k = 12
    elseif str:find("%p%d+%p%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("%p%d")+1, str:find("%d+%$")+2).."$" k = 126
    elseif str:find("%s%d+%p%d00%p00%s?") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d+$")+2).."0$" k = 11
    elseif str:find("%s%d+%p%d%s?кк$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("кк$")-1):gsub(" ", "").."00.000$" k = 21
    elseif str:find("%s%d+%sтысяч$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("тысяч$")-2)..".000$" k = 20
    elseif str:find("%s%d+тис$") then price = ''..str:sub(str:find("%s%d+т")+1, str:find("тис$")-1)..".000$" k = 27
    elseif str:find("%s%d+%sмил[л]?иард") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%sмил")-1)..".000.000.000$" k = 31
    elseif str:find("%s%d+%sк$") then price = ''..str:sub(str:find("%s%d+%sк")+1, str:find("%sк$")-1)..".000$" k = 28
    elseif str:find("%s%d+к%s") then price = ''..str:sub(str:find("%s%d+к")+1, str:find("к%s")-1)..".000$" k = 34
    elseif str:find("%W%s%d0000000$") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1).."0.000.000$" k = 399
    elseif str:find("%W%s%d%d000000$") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1)..".000.000$" k = 39
    elseif str:find("%s%d+%p%d+%$$") then price = ''..str:sub(str:find("%s%d+%p%d+")+1, str:find("%$$")) k=17
    elseif str:find("%s%d+%pкк") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%pкк")-1)..".000.000$"
    elseif str:find("%s%d%d0000%$%s") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1).."0.000$" k = 300
    elseif str:find("%s%d%d0[Кк]") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1).."0.000$" k = 300
    elseif str:find("за %d%d$") then price = ""..str:sub(str:find("за %d")+3, str:find("$"))..".000.000$" k = 1203
    elseif str:find("%p%s%d%d0000%$") then price = str:sub(str:find("%s%d%d00")+1, str:find("0"))..".000$" k = 1200
    elseif str:find("%s%d%d%d%p000$") then price = str:sub(str:find("%s%d%d%d.")+1, str:find("%d.")+2)..".000$" k = 1201
    -- elseif str:find("%s%d%d%d.000%$$") then price = str:sub(str:find("%s%d%d%d.")+1, str:find("%d.")+2)..".000$" k = 1201
    elseif str:find("%p%s%d%d0%p000%s%$") then price = str:sub(str:find("%s%d%d0%p")+1, str:find("%p0")-1)..".000$" k = 1200
    elseif str:find(":%d+%p000%p000%s%$") then price = str:sub(str:find(":%d+")+1, str:find("0")-1).."000.000$" k = 43332
    elseif str:find("%s%d000000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1)..".000.000$" k = 430
    elseif str:find("%s%d00000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1).."00.000$" k = 4301
    elseif str:find("%s%d%d00000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1):gsub(("(%d)"):rep(2), "%1.%2").."00.000$" k = 431
    elseif str:find("%s%d%d0000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1).."0.000$" k = 4311
    elseif str:find("[Цц]ена%p?%s%d000") then price = str:sub(str:find("%s%d000")+1, str:find("000$")-1)..".000$" k = 4312
    elseif str:find("%s%d%d%d000$") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1)..".000$" k = 4313
    elseif str:find(":%d%d%dк") then price = str:sub(str:find(":%d")+1, str:find("%dк"))..".000$" k = 4314
    elseif str:find("%d%d00%s000") then price = str:sub(str:find("%d%d00"), str:find("%d%d00")).."."..str:sub(str:find("%d00%s000"), str:find("00%s000")+1)..".000$" k = 9998
    elseif str:find("%s%d%d00000$") then part = str:sub(str:find("%s%d+")+1, str:find("0")-1) price = ''..part:sub(0, 1).."."..part:sub(2,2).."00.000$" k = 1209
    elseif str:find("%s%d%d%d%d0000$") then part = str:sub(str:find("%s%d+")+1, str:find("%s%d+")+4) price = ''..part:sub(0, 2).."."..part:sub(3,4).."0.000$" k = 1209
    elseif str:find("%s%d%d%d%d%d%d%d%d%d$") then part = str:sub(str:find("%s%d")+1, str:find("%s%d")+9) price = ''..part:sub(0, 3).."."..part:sub(4,6).."."..part:sub(7,9).."$" k = 1209 print(part:sub(0, 2))
    elseif str:find("%d%dО.ООО.ООО%$") then price = str:sub(str:find("%d%dО"), str:find("%$")):gsub("О", "0") k = 775
    -- цена 31. 000 000
    elseif str:find("%d+.%s000%s000$") then price = str:sub(str:find("%d+%."), str:find("$")):gsub(" ", "%."):gsub("%.%.", "%.").."$" k = 775
    else price="unknown" k="a" -- сф за 750к или пре
    end
    if price:find("24.7%s") then price = price:gsub("24.7 ", "") end
    -- debug(str.." - "..price.." | "..k, 4)
    --debug(act, 2)
    if act == "surcharge" then
      return price
    else
      -- debug(string.format( "%s | %s",str,k))
      return (act_text[act] or "{2785D6}<TextError> ")..price:gsub(",", "."):gsub("  ", " ")
    end

    debug(string.format("%s\n%s", "With OUT price type", str), 4)
    elseif str:find("%d+[.,]%d$") and not str:find("[Pp]rice") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."00.000$" return act_text[act]..price --debug(str.." - "..price.." | 7684", 4)
    elseif str:find("%s%d%p%d+%p%d+$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")-1).."$"  return act_text[act]..price --debug(str.." - "..price.." | 7684", 4)
    elseif str:find("%s%d[,.]%d%d$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")).."0.000$"  return act_text[act]..price --debug(str.." - "..price.." | 9933", 4)
    elseif str:find("[^(скин)]%s%d+%p%d+%$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%$")-1).."$" return act_text[act]..price 
    elseif str:find("[^(бирки)|(бирку)|(скин)|(одам)|(rice)]%s%d+[,.]%d+$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."$" return act_text[act]..price --debug(str.." - "..price.." | 9933", 4)
    elseif str:find("[^(скины)]%s%d+[.]%d+[.]%d+$") then price = ''..str:sub(str:find("%s%d+[.]")+1, str:find("$")-1).."$"  return act_text[act]..price --debug(str.." - "..price.." | 8648", 4)
    elseif str:find("%s%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("%s%d+%p%d+%p")+1, str:find("%$"))   return act_text[act]..price --debug(str.." - "..price.." | 4366", 4)
    elseif str:find("[^(бирки)|(бирку)|(скин)|(одам)]%s%d+%p%d+%p%d+;") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find(";")-1).."$"  return act_text[act]..price --debug(str.." - "..price.." | 4366", 4)
    elseif str:find("%s%d+%p%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$"))  return act_text[act]..price --debug(str.." - "..price.." | 4466", 4)
    elseif str:find("%s%d+[Кк]%s") then price = ''..str:sub(str:find("%W%s%d+")+2, str:find("[Кк]%s%W")-1)..".000$"  return act_text[act]..price --debug(str.." - "..price.." | 2134", 4)
    elseif str:find("%d+%s%d+[Кк]$") then price = ''..str:sub(str:find("%d%s%d+")+2, str:find("[Кк]$")-1)..".000$"  return act_text[act]..price --debug(str.." - "..price.." | 2134", 4)
    elseif str:find("%W%s%d%p%d+%p%d+%p%d+$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")).."$"  return act_text[act]..price --debug(str.." - "..price.." | 1114", 4)
    elseif str:find("%W%s%d000000$") then price = ''..str:sub(str:find("%s%d0")+1, str:find("0")-1)..".000.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0000", 4)
    elseif str:find("%W%s%d0000000$") then price = ''..str:sub(str:find("%s%d0")+1, str:find("0")-1).."0.000.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0001", 4)
    elseif str:find("%s%d%d00000$") then part = str:sub(str:find("%s%d+")+1, str:find("0")-1) price = ''..part:sub(0, 1).."."..part:sub(2,2).."00.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0002", 4)
    elseif str:find("%s%d%d0000$") then part = str:sub(str:find("%s%d+")+1, str:find("0")-1) price = ''..part:sub(0,2).."0.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0002", 4)
    elseif str:find("%s%d+%pOOO%pOOO") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%pOOO")-1)..".000.000$" return act_text[act]..price --debug(str.." - "..price.." | 1600", 4)
    elseif str:find("%s%d+%p%dOO%pOOO") then price = ''..str:sub(str:find("%s%d+")+1, str:find("O")-1).."00.000$"  return act_text[act]..price --debug(str.." - "..price.." | 1601", 4)
    elseif str:find("[^(бирки)|(бирку)|(пошиво)|(одам)]%s%d%d%p%d%d%d%p%d%d%d$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("$")-1).."$"  return act_text[act]..price --debug(str.." - "..price.." | 1601", 4)
    elseif str:find("%s%d+[Kk][Kk]") then price = ''..str:sub(str:find("%s%d+[Kk]")+1, str:find("[Kk][Kk]")-1)..".000.000$"  return act_text[act]..price --debug(str.." - "..price.." | 5138", 4)
    elseif str:find("%s%d00000$") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1).."00.000$" return act_text[act]..price
    elseif str:find("%s%d00[кr]") then price = str:sub(str:find("%s%d00[кr]")+1, str:find("00[кr]")-1).."00.000$" return act_text[act]..price
    elseif str:find("%s%d+%sк$") then price = ''..str:sub(str:find("%s%d+%sк")+1, str:find("%sк$")-1)..".000.000$" return act_text[act]..price
    elseif str:find("%s%d+%sкк$") then price = ''..str:sub(str:find("%s%d+%sкк")+1, str:find("%sкк$")-1)..".000.000$" return act_text[act]..price
    elseif str:find("%s%d%d%d00000") then part = str:sub(str:find("%s%d+")+1, str:find("%d0")) price = ''..part:sub(0, 2).."."..part:sub(3,3).."00.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0003", 4)
    elseif str:find("%s%d+%p%d%sкк$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%sкк$")-1).."00.000$" k = 21 return act_text[act]..price
    elseif str:find("%W+%s%d+%p%d+%s%sкк$") then price = ''..str:sub(str:find("%s%d+%p%d%s%s")+1, str:find("%s%sкк$")-1):gsub(",", ".").."00.000$" k = 30 return act_text[act]..price
      -- фт 4.8
    elseif str:find("%d%p%d$") and not str:find("[Pp]rice") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."00.000$" return act_text[act]..price --debug(str.." - "..price.." | 7684", 4)
      -- 12 500 000
  elseif act == "" or act == "carmarket" then
    -- debug(str, 1)
    return ""
  else
    -- debug(str, 1)
    if act ~= "my_change" and act ~= "ur_change" and act ~= "change" and act ~= "d_change" then
      return "Цена договорная"
    else
      surcharge_pay = get_price(str, "surcharge")
      if price == "unknown" then
        if act == "ur_change" then
          return "С вашей ДП."
        elseif act == "my_change" then
          return "С моей ДП."
        elseif act == "d_change" then
          return "С доплатой."
        elseif act == "change" then
          return "С доплатой."
        else
          return "..."
        end
      else
        return act_text[act]..get_price(str, "surcharge")
      end
    end
  end
end

function capitalize_nick(fn, ln)
  fn = fn:sub(1, 1):upper()..fn:sub(2, -1)
  ln = ln:sub(1, 1):upper()..ln:sub(2, -1)
  print(fn, ln)
  return fn, ln
end
