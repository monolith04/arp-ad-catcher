mss_ads_sv = "0.1.2"

local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')
local mssf_ok, mssf = pcall(import, 'lib\\imgui_functions.lua')


local skin_names = {'������', '�����', '����'}
action = {}
act_text = {}
action["sell"] = "������ "
action["buy"] = "����� "
action["change"] = "�������..."
action[""] = "..."
act_text["sell"] = "����: "
act_text["buy"] = "������: "
action["n"] = 'nil'

ammunations_strings = {}
ammunations_strings[1] = "� �������� ������ �. San-Fierro ������ ����! | GPS: 11-6"
ammunations_strings[2] = "������ �� ����� ������ ����� � �����! ��������� San-Fierro! GPS:11-6"

sf_bank_strings = {}
sf_bank_strings[1] = "�������� ������ � ����! �������� 0.7# � ����� �. SF. GPS 6-2"
sf_bank_strings[2] = "�������� �� ������� 0.7# � ����� �. SF. ����: 0$. | GPS 6-2"
sf_bank_strings[3] = "����� ����������� ������� �� ������� � ����� �. SF 0.6# | GPS 6-2"

binco_groove = {}
binco_groove[1] = "����� �� ������? ��������� ������ � �Binco Grove�. GPS 8-6"
binco_groove[2] = "������ ������������ �������� � �Binco Grove� | GPS 8-6."

gym_sf = {}
gym_sf[1] = "�������� ���� ���� � ��������� San Fierro | GPS 8-108"
gym_sf[2] = "����� ����� ��� � ����� ���������! ���� ������ ���� | GPS 8 > 108"

--������
av = {}
av[1] = "\"������ ����\" � ������ �� ����. ������ 15 ������. Anti Vote!"
av[2] = "������ ������� ��� �����������. �� \"������ ����\", Anti Vote!"
av[3] = "��� ��������� � ����������, 15 ������ �� \"������ ����\". Anti Vote"
av[4] = "��������� � ������. 15 ������ �� \"������ ����\". Anti Vote!"


function home_string(str, t_type, h_type, h_class, h_location)
    --print(str.." | "..t_type, h_type, h_class, h_location)
  return action[t_type]..h_type..h_class..h_location..". "..get_price(str, t_type)
end

function get_house_type(str)
  if str:find("���[��]�") then
    home_type = "����� ���"
  elseif str:find("���") or str:find("[��][��][��]") or str:find("���") or str:find("�����") then
    home_type = "���"
  elseif str:find("[��]���") or str:find("����") or str:find("�����") or str:find("���������")  then
    home_type = "��������� �����"
  elseif str:find("[��]����") or str:find("[��]���") or str:find("%s��%s") then
    home_type = "��������"
  elseif str:find("[��]����") then
    home_type = "��������"
  elseif str:find("�����") then
    home_type = "�����"
  else
    home_type = "���"
  end
  return home_type
end

function get_house_class(str)
  if str:find("[��]���") then
    house_class = " �������� ������"
  elseif str:find("[��]��") then
    house_class = " ������ ������"
  elseif str:find("[��]��") then
    house_class = " �������� ������"
  elseif str:find("[��]���") then
    house_class = " �������� ������"
  else
    house_class = ""
  end
  return house_class
end

function get_location(str)
  if str:find("������") or str:find("�����") or str:find("�����[��]") or str:find("�� �") then
    obj_location = " � ������� ������"
  elseif str:find("�����") then
    obj_location = " �� ������ � �. Las Venturas"
  elseif str:find("�����") or str:find("arran") or str:find("�����") or str:find("aran") then
    obj_location = " � �. Las Barrancas"
  elseif str:find("�����") or str:find("(.*)anta") or str:find("(.*)aria") or str:find("(.)����") then
    obj_location = " � �. Santa Maria"
  elseif str:find("��") or str:find("��") or str:find("���") or str:find("���") or str:find("%s[Ll][Ss]") or str:find("LS%s?^[|]") or str:find("Los") or str:find("los") then
    if str:find("[��][��][��][��]") then
      obj_location = " � �. Los Santos �� ��"
    else
      obj_location = " � �. Los Santos"
    end
  elseif str:find("[��][��]") or str:find("%s���") or str:find("���") or str:find("lv") or str:find("LV%s^[|]") or str:find("enturas") or str:find("������") then
    if str:find("�����") then
      obj_location = " � �������� � �. Las Venturas"
    else
      obj_location = " � �. Las Venturas"
    end
  elseif str:find("��") or str:find("��") or str:find("���") or str:find("���") or str:find("������") or str:find("sf") or str:find("SF%s^[|]") or str:find("San") or str:find("san") then
    if str:find("�� �����") then
      obj_location = " � �. San Fierro �� ���������"
    else
      obj_location = " � �. San Fierro"
    end
  elseif str:find("���") or str:find("���") then
    obj_location = " � �. Bayside"
  elseif str:find("��� [��][��][��]") then
    obj_location = " � �. Las Payasadas"
  elseif str:find("��") or str:find("��") or str:find("ww") or str:find("(.+)ine(.+)ood") or str:find("(.+)�[��]�(%s?)(.+)��") then
    obj_location = " �� �. VineWood"
  elseif str:find("�������") or str:find("���������") then
    obj_location = " � �. Montgomery"
  elseif str:find("[Rr]ed") and str:find("[Cc]ounty") then
    obj_location = " � �. Red County"
  elseif str:find("prickle") or str:find("����") or str:find("prikle") or str:find("[��][��][��]") then
    obj_location = " � �. Prickle Pine"  
  elseif str:find("[��][��][��]") or str:find("ayside") or str:find("[��]�����") then
    obj_location = " � �. Bayside"  
  elseif str:find("[Qq]ueb") or str:find("[��][���]?[��]?������") or str:find("[��][���]?[��]?������") then
    obj_location = " � �. El Quebrados"  
  elseif str:find("[Tt]emple") or str:find("[��]����") then
    obj_location = " � �. Temple" 
  elseif str:find("(.-)����") or str:find("[��]�����") or str:find("[��]���� [��]���") or str:find("(.+)ngel%p?(.+)ine") then
    obj_location = " � �. Angel Pine"
  elseif str:find("[��][��]") or str:find("[��]�������") or str:find("(.+)alomino%p?%s?(.+)reek") then
    obj_location = " � �. Palomino Creek"
  elseif str:find("[��][��]") or str:find("[��]���") or str:find("[��]�����") or str:find("(.+)ort%p?%s?(.+)arson") then
    obj_location = " � �. Fort Carson"
  elseif str:find("[��]��") or str:find("[Bb]lue[Bb]erry") then
    obj_location = " � �. Blueberry"
  else
    obj_location = ""
  end
  return obj_location
end

function house_number(str)
  if str:find("%d+") then
    h_number = str:match("%s%p?(%d+)%s?")
    if h_number then
      return "�"..h_number
  else 
    return ""
    end
  end
end

function ad_handler(str)
  debug(str, 2)
  if str:find("[��]������") or str:find("[��]�����") then
    return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_location(str))
  elseif not str:find("pacey") and str:find("[��][��][��]") or str:find("�����") or str:find("[��]����") or str:find("�����") or str:find("%s��%s") or str:find("��������") or str:find("���������") or str:find("[��]�����") or str:find("[��]���") or str:find("���") or str:find("����") or str:find("�����") or str:find("�����") then
    if str:find("[��]��") then
      return "�� ������� ��������� ��� "..house_number(str)..get_location(str)..". ����� ������!"
    else
      return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_location(str))
    end
  elseif str:find("�������") or str:find("������") then
    tt = trade_type(str)
    return action[tt].."��������� �������"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("����") then
    if str:find("������ ��� �����") then
      return "����� ������ ��� ����� ������ � �������� ������� ����� GPS 8-127"
    elseif str:find("������") then
      return "������ ����� ����������? ����� ���� � ������� ����� | GPS 8-127"
    end
    return "������ ������ \"������ �����\""..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("nrg") or str:find("[��][��][��]") or str:find("NRG") then -- ������� ����������
    return vechicles(str, trade_type(str), "��������", "NRG-500")
  elseif str:find("[Ff][Cc][Rr]") or str:find("[��][����][��]") then -- ������� ����������
    return vechicles(str, trade_type(str), "��������", "FCR-900")
  elseif str:find("GT") or str:find("��") or str:find("����� ��") or str:find("Super GT") or str:find("super gt") then
    return vechicles(str, trade_type(str), "����������", "Super GT")
  elseif str:find("������") or str:find("sultan") or str:find("������") or str:find("Sultan") then 
    return vechicles(str, trade_type(str), "����������", "Sultan")
  elseif str:find("[Bb][Ff]") or str:find("[Ii]njection") or str:find("[��][��]") then 
    return vechicles(str, trade_type(str), "����������", "BF Injection")
  elseif str:find("�����") or str:find("������") or str:find("averick") or str:find("�����") or str:find("mavik")or str:find("������") or str:find("averi�") then 
    return vechicles(str, trade_type(str), "�������", "Maverick")
  elseif str:find("zrx") or str:find("zrx 350") or str:find("zrx-350") or str:find("ZRX") or str:find("[Zz][Rr]") or str:find("ZRX-350") or str:find("ZRX 350") then 
    return vechicles(str, trade_type(str), "����������", "ZRX-350")
  elseif str:find("ullet") or str:find("[��]����") or str:find("[��]����") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����������", "Bullet")  
  elseif str:find("[Pp]remier") or str:find("[��]������") then
    return vechicles(str, trade_type(str), "����������", "Premier")  
  elseif str:find("(.*)an%s?(.*)ing") or str:find("(.*)[��]��%s?(.*)���") or str:find("(.*)[��]�(.*)���") or str:find("��") or str:find("(%s)��(%s)") then
    return vechicles(str, trade_type(str), "����������", "SandKing")
  elseif str:find("tretch") or str:find("�����") or str:find("������") or str:find("tratch") or str:find("������") then
    return vechicles(str, trade_type(str), "����������", "Stretch")
  elseif str:find("�����") or str:find("�����") or str:find("elegy") or str:find("legy") or str:find("enegy") then
    return vechicles(str, trade_type(str), "����������", "Elegy")
  elseif str:find("����") or str:find("riot") or str:find("����") then
    return vechicles(str, trade_type(str), "����������", "Patriot")
  elseif str:find("������") or str:find("Huntley") or str:find("�����") or str:find("untly") then
    return vechicles(str, trade_type(str), "����������", "Huntley")
  elseif str:find("[��]����") or str:find("[��]������") or str:find("[Tt]urismo") then
    return vechicles(str, trade_type(str), "����������", "Turismo")
  elseif str:find("[Bb]ansh") or str:find("[��]���") then
    return vechicles(str, trade_type(str), "����������", "Banshee")
  elseif str:find("[��]����") or str:find("[Cc]omet") then
    return vechicles(str, trade_type(str), "����������", "Comet")
  elseif str:find("[Bb]andit") or str:find("[��]������") then
    return vechicles(str, trade_type(str), "����������", "Bandito")
  elseif str:find("�����") or str:find("hamal") or str:find("�����") or str:find("shaman") then
    return vechicles(str, trade_type(str), "������", "Shamal")
  elseif str:find("[Dd]odo") or str:find("[��]���") then
    return vechicles(str, trade_type(str), "������", "Dodo")
  elseif str:find("tun(.*)plane") or str:find("tunplane") then
    return vechicles(str, trade_type(str), "������", "Stuntplane")
  elseif str:find("�������") or str:find("������") or str:find("arrow") or str:find("������") or str:find("������") then
    return vechicles(str, trade_type(str), "�������", "Sparrow")
  elseif str:find("arquis") or str:find("������") or str:find("������") then
    return vechicles(str, trade_type(str), "����", "Marquis")
  elseif str:find("heetah") or str:find("�����") or str:find("����") or str:find("����") then
    return vechicles(str, trade_type(str), "����������", "Cheetah")
  elseif str:find("nfernus") or str:find("�������") or str:find("���[��]") or str:find("infu") or str:find("�����") or str:find("�������") then
    return vechicles(str, trade_type(str), "����������", "Infernus")
  elseif str:find("������ �") or str:find("otring b") or str:find("otring B") or str:find("������� �") or str:find("acer b") or str:find("acer B") then
    return vechicles(str, trade_type(str), "����������", "Hotring Racer B")
  elseif str:find("������ �") or str:find("otring a") or str:find("otring A") or str:find("[��]������ �") or str:find("acer a") or str:find("acer A") then
    return vechicles(str, trade_type(str), "����������", "Hotring Racer A")
  elseif str:find("������") or str:find("otring") or str:find("�������") or str:find("acer") then
    return vechicles(str, trade_type(str), "����������", "Hotring Racer")
  elseif str:find("��������") or str:find("������������") or str:find("%s��%s?") or str:find("%s��%s") and not str:find("�����") then
    return "��� ������ � ������������ ��������. ��� �������."
  elseif str:find("���� �����") then    -- ������� --
    return "��������� ���� ����� ���-����. ������� ��������� ���� | GPS 8-280"
  elseif str:find("������") and str:find("LV") then
    return "�������� �� ����� ���� � ��������� ��������� �. LV | GPS 8-234"
  elseif str:find("[Pp]rice%s7%s?%p%s?10") then
    if str:find("������ �������?") then
      return "������ �������? ���� ���������� ���� ������������! Price 7-10"
    end
  elseif str:find("�����") and str:find("LV") then
    return "������ �������� ������� � ���������� ��������� �. LV | GPS 8-234"
  elseif str:find("���������������") then 
    return "��������������� ������� � ��������� ��������� LS� | Price 7 -> 3"
  elseif str:find("[��]����") and str:find("�����") then
    if str:find("���������") then
      return "����� ��������� ����� �1 � �.Los-Santos ������ | GPS 8-54"
    elseif str:find("��������") then
      return "����� ������ ���� ����� ��������! 1,000$/����� | GPS 8-54"
    end
  elseif str:find("�����") then
    return "��������� ���������� ���� � ����. ������� LS/LV� | GPS 8-271/272"
  elseif str:find("[��]��") and str:find("[Ll��][Ss��]") and str:find("[Ll��][Vv��]") then
    if str:find("��������") then
      return "��������� ���������� ���� � ����. ������� LS & LV�. GPS 8-271/272"
    elseif str:find("������") then
      return "���� ���������� ���� � �������� ������� LS & LV�. GPS 8-271/272"
    end
    return "����������� ���� � �������� ������� LS & LV�. GPS 8-271/272"
  elseif str:find("[Aa]ttica") then
    return "������ � \"Attica Bar\". � ��� ������� �������! �� �� GPS 8-65!"
  elseif str:find("[Dd][Ss]") and str:find("[��][��][��][��]") then
    if str:find("�������") then
      return "������� ������ �� ������� ������ � �DS� ����. GPS 8-39"
    end
  elseif str:find("GPS 8 > 10 �����") then
    return "� �������� �Spacey� �����! 10-� ������ ������� 100.000$. GPS 8>10"
  elseif str:find("[Ss]pacey") then
    if str:find("�������") then --str:find("[Bb][Mm][Ww]") then
      return "� ������� ������� �Spacey� ������� ����� ������� | �� � GPS 8-10"
    elseif str:find("������� ��� ������ ����") then
      return "���� ������� ��� ������ ���� � �������� ������� �Spacey� GPS 8>10"
    elseif str:find("BMW") then
      return "� ������� ������� �Spacey� ������� ���� �BMW M5� | �� � GPS 8-10"
    elseif str:find("�������") then
      return "� ������� ������� �Spacey� ������� ����� ������� | �� � GPS 8-10"
    elseif str:find("��������") then
      return "� �������� �Spacey� �����! 10-� ������ ������� 100.000$. GPS 8>10"
    elseif str:find("�����") then
      return "������ ������� ������� �Spacey� GPS 8 > 10. "..get_price(str, trade_type(str))
    end
  elseif str:find("[��]������� [��]����") and str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4") then
    return "����� ������ ���� �� �������� ����� ������ � ���! Price: 11 > 4."
  elseif str:find("[��]�����") and str:find("[��][��][��][��]") then
    if str:find("����") then
      return "�����, ��������, ������ � �������-������ � ����. GPS 8 - 113"
    end
    return "���������� ���� � ������-������ ���� | GPS: 8-113"
  elseif str:find("nvestical") and str:find("roup") then
    return "�������� �Investical Group� ���� ����� ����������� | GPS 4 > 7"
  elseif str:find("����") and str:find("����") then
    if str:find("[��][��][��]") then
      return "������ ����? ���� ��� � ��������� ������� �� ��� | GPS 8 -> 10"
    end
  elseif str:find("[Vv]isage") then
    return "� ����� �Visage� �������� VIP ������. ����: 500$/�. GPS: 8-232."
  elseif str:find("lexande") and str:find("[Tt]oys") then
    if str:find("��������������� ��������") then
      return "���� ���������������� �������� � �Alexander's Toys� | Price 8 > 3"
    elseif str:find("BMW") then
      return "������� �Alexander's Toys� ������� ���� �BMW M5� | Price 8 > 3"
    elseif str:find("������?") then
      return "���� ������? ����-������� � ��lexanders Toys� | Price 8 >3"
    else
      return "������� �Alexander's Toys� �������� �����������. �� � Price 8 > 3"
    end
  elseif str:find("Binco Grove") or str:find("8%s?%p?%s?6") and str:find("[Gg][Pp][Ss]") then
    return binco_groove[math.random(1, 2)]
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?247") then
    if str:find("�������� ���������") then
      return "C������� ��� ��������� �� ����� �������� ����� �� 699$ | GPS 8-247."
    end
  elseif str:find("�����") and str:find("������") and str:find("��") then
    return "� �������� ������ �Binco� ����� �������� LV ����� ������ ����!"
  elseif str:find("[Bb]inco") and str:find("[��][��][��][��]") and str:find("[Pp]rice") then
    return "������ ������ �� ����� ������ ���� � \"Binco\" ���� | Price 5-14!"
  elseif str:find("[��]���� ������ ����") and str:find("[Dd]illimore") and str:find("[Gg][Pp][Ss]") then
    return "����� ������ ���� � �������� �. Dillimore | GPS 8 -> 228."
  elseif str:find("24/7") or str:find("24-7") or str:find("24 7") then
    if str:find("[��]�����") then
      if str:find("���[ -]��������") then
        return "������ ������ �24/7� � �. Las Venturas. ����: ����������"
      end
    end
    if str:find("lvfm") or str:find("LVFM") or str:find("����") then
      if str:find("�������") then
        return "����� ������� ����� ���������� ����� � �24/7� � LVFM | GPS 8-178"
      elseif str:find("���") then
        return "����� ��� � ���������� ��������� �� �24/7� � LVFM | GPS 8-178"
      end
    end
  elseif str:find("[Bb]if") and str:find("[Bb]rid") and str:find("[Gg][Pp][Ss]") then
    return "� ����� \"Biffin Bridge\" ������ �� 500$/�����! | GPS 8-158"
  elseif str:find("[��]���") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?73%s?") then -- GPS 8-73
    if str:find("������ �� �����") then
      return "������ �� �����, �� ������� ����? ����������� ���� ��� | GPS 8-73"
    elseif str:find("� � ������") then
      return "� � ������ ��� ������, ��� ���������� ����������� | GPS 8-73."
    end
    return "�� ���� �� ������� �����������? ��������� ������ | GPS 8-73"
  elseif str:find("[��]���") and str:find("[Gg][Pp][Ss]") then -- GPS 8-73
    if str:find("[��Ss][Ff��]") or str:find("[Ff]ierro") then
      if str:find("[��]���� �����������") then
        result = sf_bank_strings[3]
      end
    elseif str:find("[Bb]ar") and str:find("[Gg][Pp][Ss]") then
      result = "����������� �������� 0.7# ������ � ����� Las-Barrancas! | GPS 6-5"
    elseif str:find("[Pp]al") and str:find("[Gg][Pp][Ss]") then
      result = "����������� �������� 0.7# � ����� Palomino Creek. | �� � GPS 6-3."
    else
      result = "ERROR"
    end
    return result
    -- ������ � ������
  elseif str:find("[Aa]nti [Vv]ote") then
    return av[math.random(1,4)]
  elseif str:find("[��]�������") then
    return "������ \"��������\". ��������� ������ - 15 ������. E.�astellano"
  elseif str:find("[��]������������� [��] [��]�������") then
    if str:find("����") then return "������ ����, �� ��������? ������ \"�������������� � ��������\"!" end
    return "������� �� ������ �������������� � ��������. �������� V.Granados"
    --������
  elseif not str:find("���") and not str:find("sim") and not str:find("���") and not str:find("SIM") and str:find("����") or str:find("Cart") or str:find("Kart") or str:find("����") or str:find("cart") or str:find("kart") then
    return vechicles(str, trade_type(str), "����������", "Kart")
  elseif str:find("�����") or str:find("[��]��") or str:find("[Ss][Iil]m") or str:find("SIM") or str:find("����") or str:find("���� �����") then -- ������
    print("{66B8F3}������� ���������� � �������/������� ���-�����!")
    sim_format = str:match("������� (%w+)$")
    result = "fdas"
    if sim_format == nil then
      result = "(AD_SIM_0): {BF4E8D}� �� ���� ��� ���������� ���-�����, ���� ��� � ����:"
    else
      result = "������ ���-����� �������\""..sim_format:upper().."\". "..get_price(str, nil)
    -- ������
    end
    return result
  elseif str:find("���") or str:find("���") or str:find("[Aa][Zz][Ss]") then
    if str:find("[��]����") and str:find("[��][��]") or str:find("[Ll][Vv]") then
      if str:find("[Ff]uel") then
        return "�� ��� �17 \"����������� ��\" ������ �� 25$ �� 1�. | Fuel 17"
      end
      fuel_name = "����������� ��"
    elseif str:find("ontgomery") and str:find("[Ff]uel") then
      return "����� ������� ������� �� \"��� Montgomery\" �� 10$ �� 1�. Fuel 10"
    else
      fuel_name = ""
    end
    return action[trade_type(str)].."\"��� "..fuel_name.."\". "..get_price(str, trade_type(str))
  elseif str:find("���������") then
    return action[trade_type(str)].."������� �����������"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("[��]���� [��]������") then
    return action[trade_type(str)].."����� �������"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("����") and str:find("[��][��][��][��]") and str:find("����") then
    return action[trade_type(str)].."������� ������ \"Binco\" � ����. "..get_price(str, trade_type(str))
  elseif str:find("[Ss]ex") or str:find("����") and str:find("����") and str:find("[��][��]") then
    return action[trade_type(str)].."����-��� �� ��������� �. Los Santos. "..get_price(str, trade_type(str))
  elseif str:find("[Ss]ex") or str:find("[��]���") and str:find("[��Ll][��Vv]") then
    return action[trade_type(str)].."����-��� � �. Las Venturas. "..get_price(str, trade_type(str))
  elseif str:find("[��]�������������� [��]����") then
    return action[trade_type(str)].."������ ���������������� ����� GPS 8-42. "..get_price(str, trade_type(str))
  elseif str:find("�����") then
    w_location = location(str, "������", "n", "n")
    return w_location
    -- ==����������== --
  elseif str:find("[��]��[��]") then
    return action[trade_type(str)].."��������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") then
    return action[trade_type(str)].."��������� ������-�����. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����������") then
    return action[trade_type(str)].."��������� �������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[����]��[��]���") or str:find("�����") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��������") or str:find("[��]�[��]���") then
    return action[trade_type(str)].."��������� ���������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[����]") then
    return action[trade_type(str)].."��������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[����]") and str:find("[��]������") then
    return action[trade_type(str)].."��������� ������� ���������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ������ ����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") then
    return action[trade_type(str)].."��������� �����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[�]?��") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") then
    return action[trade_type(str)].."��������� ���������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���[��]") then
    return action[trade_type(str)].."��������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") then
    return action[trade_type(str)].."��������� ����������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") then
    return action[trade_type(str)].."��������� ������ �����. "..get_price(str, trade_type(str))
  -- ==������==
  elseif str:find("[Ff]amily") or str:find("[��]����") then
    if str:find("[Gg]oldberg") then
      if str:find("�������") then
        return "����� Goldberg Family ���� ������� �������������."
      else
        return "�������� ���� ������ � �������? ����� Goldberg �������!"
      end
    end
    if str:find("[Bb]lack") then
      return "������ ����� ���������� ���������? ����� Black ���� ������ ����!"
    end
  elseif str:find("������") then
    return "�� ����� "..get_location(str):gsub(" � ", "").." ������� ������� �������. �������."
  elseif str:find("����[�]�") or str:find("����[Ũ]�") then
    return "�� ����� "..get_location(str):gsub(" � ", "").." ������� �������. �������."
  elseif str:find("����") then
    if str:find("[Ll��][Vv��]") or str:find("[Ll��][Aa��][Ss��]") then
      return "�� �������� �. Las Venturas �������� ������� ����. �������!"
    elseif str:find("[Ll��][Ss��]") or str:find("[Ll��][Oo��][Ss��]") then
      return "�� �������� �. Los Santos �������� ������� ����. �������!"
    end
  elseif str:find("�������") or str:find("����") or str:find("������") or str:find("����") or str:find("����� ���") or str:find("�����") then
    --print("�����!!!")
    if str:find("�����") or str:find("����") then
      return action[trade_type(str)].."�������� �"..get_location(str)..". "..get_price(str, trade_type(str))
    else
      return location(str, "��������", "n", "n")
    end

  elseif str:find("[��]�����%s%d+%s����") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%s�%s%d+") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]����%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("�����") or str:find("����") or str:find("skin") or str:find("������") or str:find("�����") or str:find("����") then
    result = clothes(str, trade_type(str))
    return result
  elseif str:find("�����") or str:find("���[��]") then
    return "������������ � �������� ��� ��������� ���������. ������� ���!"
  elseif str:find("�����") or str:find("�����") then
    return "������������ � ��������������� ��������. � ����: ��� �������."
  elseif str:find("��[��]") or str:find("��[��]") then
    if str:find("_") then str = str:gsub("_", " ") end
    if str:find("��������") or str:find("������") then
      if str:find("[(�����)|(�����)] (%w+) (%w+)$") then
        --debug(str.."FOUND2", 1)
        first, last = str:match("[(�����)|(�����)]%s(.+)%s(.+)$")
        print(first, last)
      elseif str:find("[(�����)|(�����)]%s(%w+)%s(%w+)%s?%p?") then
        --debug(str.."FOUND4", 1)
        first, last = str:match("�����%s(.+)%s(.+)%s���")
        print(first, last)
      elseif str:find("��� (.+) (.+)%p?") then
        --debug(str.."FOUND3", 1)
        first, last = str:match("���%s(.+)%s(.+)%p?")
        print(first, last)
      elseif str:find("�� (.+) (.+)") then
        --debug(str.."FOUND1", 1)
        first, last = str:match("��%s(%w)%s(%w)%p?")
        print(first, last)
      elseif str:find("�� (.+) (.+)") then
        --�� Dmitriy Forost.
        --debug(str.."FOUND14", 1)
        first, last = str:match("��%s(%w+)%s(%w+)%p")
        print(first, last)
      end
      if last == nil or first == nil then
        return "ERROR"
      end
      return "��� �������� �� ����� "..first.." "..last..". ������� ���!"
    elseif str:find("��������") then
      return "��� ������� �������������. ��������� ���!"
    else
      if str:find("�� (.+) (.+)") then
        --�� Dmitriy Forost.
        --debug(str.."FOUND14", 1)
        first, last = str:match("��%s(%w+)%s(%w+)")
        print(first, last)
      end
      if last == nil or first == nil then
        return "ERROR"
      end
      return "��� �������� �� ����� "..first.." "..last..". ������� ���!"
    end
  elseif str:find("[��]����") or str:find("[��]����") then
    return "������� ����� �� 5.000.000$. ���������! �� � \"������ �����\" | GPS 8-280"
  elseif str:find("[��]���") or str:find("�� [��]����") and str:find("[Gg][Pp][Ss]") or str:find("AMMO") then
    --locate, gps = location(str, "ammo", nil, nil)
    h_string = location(str, "ammo", nil, nil)
    return h_string
  elseif str:find("���") or str:find("�������") then
    if str:find("����") then
      return action[trade_type(str)].."���������� ������. "..get_price(str, trade_type(str))
    else
      return action[trade_type(str)].."������. "..get_price(str, trade_type(str))
    end
  elseif str:find("(.-)����") or str:find("(.-)�����") or str:find("����") then
    if str:find("�����[��]") or str:find("����") or str:find("skin") or str:find("������") or str:find("�����") then
      return
    end
  else
    return "ERROR"
  end
  return "ERROR"
end

function trade_type(str)
  if str:find("(.-)[��]�[�]?��") or str:find("(.-)����") or str:find("[��]���") or str:find("[Bb]uy") then
    return "buy"
  elseif str:find("(.-)����") or str:find("(.-)�����") or str:find("(.*)��(.*)��") or str:find("����") or str:find("����") or str:find("(.-)ell") then
    return "sell"
  elseif str:find("����") then
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
      if str:find("�� �����") then
        return "������� �����, ������ ���� - �AMMO Angel Pine� | GPS 11-3"
      else
        return "����� ������ ���� �� ������ � ����� Angel Pine� | GPS 11 -> 3"
      end
    end

  elseif type == "������" then
    if str:find("los") or str:find("��") or str:find("���") or str:find("Los") or str:find("���") or str:find("LS") or str:find("��") then
      if str:find("�������") then
        return "������ ������� ������ � '��������� ������' �. LS! Price 18-1"
      elseif str:find("������") or str:find("�����") then
        return "����� ������ ������ � \"��������� ������\" �. LS. Price 18-1"
      elseif str:find("��������") then
        return "��������� ������ � \"��������� ������\" �. LS. Price 18-1!"
      elseif str:find("����") then
        return "������� ������ ������ ���� � \"��������� ������\" �. LS. Price 18-1"
      end
    end
  elseif type == "��������" then
    if str:find("[��]���� [��]����") then
      return "����� ����� ����� ��� � ��������� � �. Santa Maria | Price 6-4"
    elseif str:find("san") or str:find("���") or str:find("sf") or str:find("���") or str:find("San") or str:find('8 > 108') or str:find("108") then
      if str:find("������") then
        return "������� ����� ��������� ����������� � ����� ���������! GPS 8>108"
      end
      return gym_sf[math.random(1, 2)]
    else if str:find("8-28") or str:find("-(%s?)28") then
      return "���������� � ���� ������ �������� � �. Los Santos. GPS 8-28"
    elseif str:find("[��]��[�]�") then
      return "������� ����� ��� � ������� ������ | GPS 8 - 57"
    else if str:find("����") or str:find("8-7") or str:find("-(%s?)7") then
      return "���� �������? ���������� � ��������� �������� ������ | GPS 8-7"
    elseif str:find("[Pp]rice%s6%s?[>-]%s?3") then
      return "������ ������� ��� ����� ���? ������ ����� ��� � ���! | Price 6-3"
    elseif str:find("ort") and str:find("arson") then
      if str:find("� �����") then
        return "������ �������� ���� � �����? ���� � �������� � �. Fort Carson!"
      elseif str:find("����") then
        return "���������� ���� ������ � �����-���� � �. Fort Carson. ���� ���!"
      end
    end
  end
end
end
end

function clothes(str, act)
  --debug(str, 1)
  --3 �����
  --������ ����� 272 208 99
  if str:find('%d+%p%s%d+%p%s%d+%p') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)%p", 3)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%s(%d+)$", 3)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%p%d+%p%d+%s') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%s", 3)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    --����� ������ 240, 294, 295 �������
  elseif str:find('������%s%d+%p%d+%p%d+%p?$') then    --����� ������ ������ 303,304,305
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p?$", 3)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 

  elseif str:find('%s%d+%p?%s%d+%p?%s%d+%p?%s?') then
    --toast.Show(u8'3', toast.TYPE.WARN, 5)
    clothes_ids = get_clothes_id(str, "%s(%d+)%p?%s(%d+)%p?%s(%d+)%p?%s?", 3)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    --����� ���� 109, 115 � 114
  elseif str:find('%s%d+%p?%s%d+%s�%s%d+%s?') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p?%s(%d+)%s�%s(%d+)%s?', 3)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    --������%s\"%d+\"%s\"%d+\"%s\"%d+\"%p
  elseif str:find('%s\"%d+\"%s\"%d+\"%s\"%d+\"%p') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)\"%s\"(%d+)\"%s\"(%d+)\"%p", 3)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  --2 �����
  --����� ������� � ������� �286, 287. ������: ���������.
  --������ ������ ��� ������ 103 � 303 ���� ���������.
  --������ ������ ������ 271 ���� 3.3
  --������ ������ ������ 270,271
  --������ 295, 296
  elseif str:find('�����%s%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "�����%s(%d+)%p(%d+)$", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(������)|(������)]%s%d+%p%s?%d+%s?') then
    clothes_ids = get_clothes_id(str, "[(������)|(������)]%s(%d+)%p%s?(%d+)%s?", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[��]�����%s%d+%s�%s%d+$') then
    clothes_ids = get_clothes_id(str, "[��]�����%s(%d+)%s�%s(%d+)$", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
    --������ 124 240 
    --� 110, 102 �
  elseif str:find('�%s%d+%p%s%d+%s�') then
    clothes_ids = get_clothes_id(str, "�%s(%d+)%p%s(%d+)%s�", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('������%s%d+%s%d+%s') then
    clothes_ids = get_clothes_id(str, "������%s(%d+)%s(%d+)%s", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s���%s%d+%s') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%s���%s(%d+)%s', 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+%p%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%p(%d+)\"", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%s\"(%d+)\"", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s%d+%s����$') then
    clothes_ids = get_clothes_id(str, "%s(%d+)%s(%d+)%s����$", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%s�%s%d+$?') then
    clothes_ids = get_clothes_id(str, "(%d+)%s�%s(%d+)", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+%p+%d+%s") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+(%d+)%s", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+%s+%d+%s") then
    clothes_ids = get_clothes_id(str, "(%d+)%s+(%d+)%s", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("^[����]%s%d+%p+%s?%d+$") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+%s?(%d+)$", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
    --������ ������ ������ 70,267.
  elseif str:find("%s%d+%p+%s?%d+%p%s?�") then
    clothes_ids = get_clothes_id(str, "%s(%d+)%p+%s?(%d+)%p", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("�%d+%p+%s?%d+$?") then
    --debug("����", 2)
    clothes_ids = get_clothes_id(str, "�(%d+)%p+%s?(%d+)$?", 2)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
    --debug(h_string, 2)
  --elseif str:find("%d+ ��") or str:find("%d+ ����") then
    --h_string = action[act].."������ � ������ "..get_price(str)
  --1 ����
  "[��]�����%s%d+$"
  elseif str:find("[��]�����%s%d+$") then skin_id = str:match("[��]�����%s(%d+)$")
  h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
elseif str:find("[��]����%s%d+$") then skin_id = str:match("[��]����%s(%d+)$")
  h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�����[��] %d+%s?") then skin_id = str:match("%s(%d+)")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�����[��]%s(%d+)%s�����") then skin_id = str:match("%s(%d+)%s")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�%s?%d+") then skin_id = str:match("�%s?(%d+)")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%s�����") then skin_id = str:match("%s(%d+)%s")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%s����") then skin_id = str:match("%s(%d+)%s")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("�%s?\"%d+\"") then skin_id = str:match("�%s?\"(%d+)\"")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�%s?%d+") then skin_id = str:match("�%s?(%d+)")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+(%s|$)") then skin_id = str:match("%s(%d+)(%s|$)")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s[(������)|(�����)|(�����)|(�����)|(������)|(����)|(������)|(������)]+%s%p?%d+%p?%s?") then skin_id = str:match("%s[(������)|(�����)|(�����)|(�����)|(������)|(����)|(������)|(������)]+%s%p?(%d+)%p?%s?")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+%s?[(�����)|(������)]") then skin_id = str:match("%s(%d+)%s?[(�����)|(������)]")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s����%s%d+%s") then skin_id = str:match("%s����%s(%d+)%s")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("[��]�����%s%d+%s����") then skin_id = str:match("[��]�����%s(%d+)%s����")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
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
    withn = num1:gsub(num1, "�"..num1)..' � '..num2:gsub(num2, "�"..num2)
    return withn
  elseif count == 3 then
    num1, num2, num3 = str:match(pattern)
    withn = num1:gsub(num1, "�"..num1)..', '..num2:gsub(num2, "�"..num2)..' � '..num3:gsub(num3, "�"..num3)
    return withn
  else return "Error..."
  end
end

function vechicles(str, trade, v_type, model)
  if str:find("�����") or str:find("�����") or str:find("����") then
    return "�� ��������� ��������� "..v_type.." ����� �"..model.."� "..car_tuning(str)
  end
  --print(action[trade], v_type, model, car_tuning(str), get_price(str, trade))
  return action[trade]..v_type.." ����� �"..model.."�"..car_tuning(str)..". "..get_price(str, trade)
end

function car_tuning(str)
  if str:find("ft") or str:find("��") or str:find("FT") or str:find("��") then
    return " [FT]"
  else
    return ""
  end
end
--���� 1.5 ��� 
function get_price(str, act)
  --debug(str, 2)
  if str:find("�����") or str:find("�����") or str:find("���") or str:find("���") or str:find("[��]����") or str:find("[��]����") or str:find("����") then
    return "����: ����������."
    --����� ������ ������ 303,304,305
  elseif str:find("����") or str:find ("�� %d") or str:find("[��][��]") or str:find("����") or str:find("�����") or str:find("%d[�k]$") or str:find("kk") and not str:find("����������") then
    if str:find("%d%p%d��%s") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("��%s")-1).."00.000$" k = 0
      --12,500kk
    elseif str:find("%d%p%d[(��)|(kk)]") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("[(��)|(kk)]$")-2).."00.000$" k = 122
    elseif str:find("%d%p%d[(��)|(kk)]") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("[(��)|(kk)]")-1).."00.000$" k = 1
    elseif str:find("%d%p%d%s?���") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%s?���")-1).."00.000$" k = 2
    elseif str:find("%d%s?���") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s?���")-1)..".000.000$" k = 2
    elseif str:find("%d%s����") then price = ''..str:sub(str:find("%s%d")+1, str:find("%s�")-1)..".000.000$" k = 23
    elseif str:find("%s%d+%p%d+%$.") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")) k = 18
    elseif str:find("%d%p%d$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")-1).."00.000$" k = 3 --����:2.500.000$
    elseif str:find("%s%d+%p%d+kk$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("kk$")-1):gsub(",", ".")..".000$" k = 30 --����:2.500.000$
    elseif str:find(".%d00.00%$$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%d%$")).."0$" k = 8 
    elseif str:find("[:]?%s%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find('%d+%p%d+%p%d+'), str:find("%d%$")).."$" k = 4 --����: 35.000.000$
    elseif str:find("[:]%s?%d+%p%d%d%d%p%d+%$") then price = ''..str:sub(str:find('%d+%p'), str:find("%d%$")).."$" k = 12
    elseif str:find("%s%d+%p%d+%p%d+%s") then price = ''..str:sub(str:find('%d%p'), str:find("%d%s")).."0$" k = 13 --1.300.00$
    elseif str:find("%s%d+%s%d+%s%d+%s?") then price = ''..str:sub(str:find('%s%d')+1, str:find("%$")-1):gsub(" ", ".").."$" k = 14 --400 000 000$
    elseif str:find("%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('%d+%p'), str:find("%d$")).."$" k = 5 -- 8.000.000
    elseif str:find("%s%d+%s?[��][��]") then price = ''..str:sub(str:find('%s%d+%s?[��]')+1, str:find("%s?[��][��]")-1)..".000.000$" k = 6
    elseif str:find("�:%d+%s?[��][��]") then price = ''..str:sub(str:find('�:%d+%s?[��]')+2, str:find("%s?[��][��]")-1)..".000.000$" k = 19
    elseif str:find("%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('%s%d+%p')+1, str:find("$")).."$" k = 16
    elseif str:find("%s%d+%p%d+%p%d+%$%p$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."" k = 15
    elseif str:find(".00.000%$") then price = ''..str:sub(str:find("[:%s?]%d+%p")+1, str:find("%p%d")+4).."00.000$" k = 7 
    elseif str:find("%s%d+[�k]$") then price = ''..str:sub(str:find("%s%d+[�k]")+1, str:find("[�k]$")-1):gsub(" ", "")..".000$" k = 9 --������ ����� 888886 ���� 300�
    elseif str:find("%s%d%p%d+$") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d+$")+2)..".000$" k = 10 --����� ��� ������ 1.100.00 ��� 999779
    elseif str:find("%s%d+%p%d00%p00%s?") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d+$")+2).."0$" k = 11
    elseif str:find("%s%d+%p%d+%s?��$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("��$")-1)..".000$" k = 9 --������ ����� 888886 ���� 300�
      --������ ��������� "����� �����". ���� 611.111$
    elseif str:find("%s%d+%p%d+%$$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%$$")) k=17
      --���� 18.��
    elseif str:find("%s%d+%p��") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%p��")-1)..".000.000$"
    else price="UNKWN" k="a" -- �� �� 750� ��� ���
    end
    debug(str.."-"..k, 1)
    --debug(price, 2)
    return act_text[act]..price
  elseif str:find("%d%p%d$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")-1).."00.000$" return act_text[act]..price
  elseif str:find("%s%d%p%d+%p%d+$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")-1).."$" return act_text[act]..price
  else
    return "����: ����������."
  end
end

