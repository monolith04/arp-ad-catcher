mss_ads_sv = "0.2.9"

local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')
local mssf_ok, mssf = pcall(import, 'lib\\imgui_functions.lua')


local skin_names = {'������', '�����', '����'}
action = {}
act_text = {}
action["sell"] = "������ "
action["buy"] = "����� "
action["change"] = "������� "
action["my_change"] = "������� "
action["ur_change"] = "������� "
action["d_change"] = "������� "
action[""] = "..."
act_text["sell"] = "����: "
act_text["buy"] = "������: "
act_text["auction"] = "������ �� "
act_text["my_change"] = "��� �������: "
act_text["ur_change"] = "���� �������: "
act_text["d_change"] = "� ��������."
act_text["carmarket"] = "�� "
action["n"] = 'nil'

ammunations_strings = {}
ammunations_strings[1] = "� �������� ������ �. San-Fierro ������ ����! | GPS: 11-6"
ammunations_strings[2] = "������ �� ����� ������ ����� � �����! ��������� San-Fierro! GPS:11-6"

sf_bank_strings = {}
sf_bank_strings[1] = "�������� ������ � ����! �������� 0.7# � ����� �. SF. GPS 6-2"
sf_bank_strings[2] = "�������� �� ������� 0.7# � ����� �. SF. ����: 0$. | GPS 6-2"
sf_bank_strings[3] = "����� ����������� ������� �� ������� � ����� �. SF 0.6# | GPS 6-2"



function home_string(str, t_type, h_type, h_class, h_repair, h_number, h_location)
 --debug(t_type, 4)
  if t_type == "my_change" or t_type == "ur_change" or t_type == "change" then
    if str:find(".- �� .+, �� ��� .+") then
      str_1, str_2 = str:match(".- �� (.+), �� ��� (.+)")
      print("����� (������ 1): ", get_location(str_1), home_changer(str_2))
      return action[t_type]..h_type..h_class..h_repair..get_location(str_1)..home_changer(str_2).." "..get_price(str, t_type)
    elseif str:find(" �� ") then
      str_1, str_2 = str:match("(.+) �� (.+)")
      print("����� (������ 2): ", get_location(str_1), home_changer(str_2))
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
  if str:find("��� [�]?%s?[��][��]") then
    return " �� ��� � �. Las Venturas."
  elseif str:find("��� � Los Santos") then
    return " �� ��� � �. Los Santos"
  elseif str:find("��� �� ��") then
    return " �� ��� �� �. VineWood"
  elseif str:find("��� � ���") then
    return " �� ��� � �. Bayside"
  elseif str:find("� �����") then
    return " �� ��� � ������� ������."
  elseif str:find("� [�S][�F]") then
    return " �� ��� � �. San Fierro"
  elseif str:find("� .+ [Ll]os%p?%s?[Ss]antos") then
    return " �� ��� � LS."
  elseif str:find("[Tt][ea]mple") or str:find("[��][��]�[��][��][�]?") or str:find("�����") then
    return " �� ��� � �. Temple"
  elseif str:find("[��Pp][Kk��]") or str:find("[��][��]�[�]?[��]�[��][��][��]") or str:find("(.+)[ao]lo[nm]ino%p?%s?(.+)re[ea]k") then
    return " �� ��� � �. Palomino Creek."
  else
    return " �� ��� ���."
  end
end

function get_house_type(str)
  if str:find("���[��]�") then
    home_type = "����� ���"
  elseif str:find("[��]�������") or str:find("��������") then
    home_type = "�������� ���"
  elseif str:find("[��]����") then
    home_type = "�����"
  elseif str:find("[��]�� [��]�����") then
    home_type = "��� �������"
  elseif str:find("[��]���������") then
    home_type = "�������� ���������� ���"
  elseif str:find("[��][��]���") then
    home_type = "��������"
  elseif str:find("[��]���(.-) [��]����(.-)") then
    home_type = "������� ����������"
  elseif str:find("[��]�����") then
    home_type = "������"
  elseif str:find("[��]���") then
    home_type = "������"
  elseif str:find("[��]���%p���") or str:find("���� ���") then
    home_type = "����-���"
  elseif str:find("[��]��[��][��]�[���]?") then
    home_type = "�������"
  elseif str:find("[��][��]���������") then
    home_type = "�����������"
  elseif str:find("����") then
    home_type = "�������"
  elseif str:find("[��]������� � �����") then
    home_type = "�������� � �����"
  elseif str:find("[��]���") and str:find("[��]���[�]?��") then
    home_type = "�������� ��� � ��������"
  elseif str:find("��� � ������") and (str:find("��������") or str:find("�������")) then
    home_type = "�������� ��� � ������"
  elseif str:find("[��]���[��]") then
    if str:find("� ����") then
      home_type = "������� � ����"
    else
      home_type = "�������"
    end
  elseif str:find("[��]���") or str:find("[��]����") then
    if str:find("��������� �������") then
      home_type = "��������� �������"
    elseif str:find("����%p?%s?�������") then
      home_type = "����-�������"
    else
      home_type = "�������"
    end
  elseif str:find("[��]���") or str:find("����[�]?����") or str:find("��������") or str:find("���������") or str:find("vremenoe jilie")  then
    home_type = "��������� �����"
  elseif str:find("���") or str:find("[��][��][��]") or str:find("���") or str:find("�����") then
    home_type = "���"
  elseif str:find("[��]�[��]��") or str:find("�������") or str:find("[��]��[��]") or str:find("%s��%s") or str:find("��������") then
    if str:find("[����]��[�]?�") then
      if str:find("[��]��") then
        home_type = "������� ��������"
      else
        home_type = "������� ��������"
      end
    else
      home_type = "��������"
    end
  elseif str:find("[��]����") then
    home_type = "�����"
  elseif str:find("[��]����") then
    home_type = "�����"
  else
    home_type = "���"
  end
  return home_type
end

function get_house_class(str)
  if str:find("[��Cc][����]?[��][��][��]") or str:find("�������") or str:find("[��]������") or str:find("��.%s?��") then
    house_class = " �������� ������"
  elseif str:find("[����]�[��]") or str:find("�������") then
    house_class = " ������ ������"
  elseif str:find("[��]����") then
    house_class = " ������� ������"
  elseif str:find("[��]��[^(��)]") or str:find("��������") or str:find("�������") or str:find("[��]������") then
    house_class = " �������� ������"
  elseif str:find("[������][��][��][��]") and not str:find("[��]������") then
    if str:find("[��]���") then
      if str:find("�����") then
        house_class = " �������"
      else
        house_class = " �������"
      end
    elseif str:find("������") then
      house_class = ""
    else
      house_class = " �������� ������"
    end
  elseif str:find("[��]�����������") then
    house_class = " ������������"
  elseif str:find("[��]�����") then
    house_class = " ���������"
  else
    house_class = ""
  end
  return house_class
end

function get_house_repair(str)
  if str:find("[����]���%s?%p?[��][��][��][��]�") or str:find("�������") then
    house_repair = " � ������������"
  elseif str:find("���[��][��]�") or str:find("�����") or str:find("����") or str:find("�����") or str:find("����������") then
    house_repair = " � ��������"
    if str:find("��������") then
      house_repair = " � �������� ��������"
    elseif str:find("������������") then
      house_repair = " � ������������ ��������"
    end
  elseif str:find("����%s?������[��]") or str:find("�����������") then
    house_repair = " � �����������"
  elseif str:find("���[�]?�����") then
    house_repair = " � ���������"
  else
    house_repair = ""
  end
  return house_repair
end

function get_location(str)
  if str:find("��[��][��]?[��]?��[���]") or str:find("[��][��][�]?�[�]?[�]?[��]") or str:find("�����") or str:find("[��]���") or str:find("[Gg][h]?et[t]?o") or str:find("%s�[��]��%s") or str:find("�����[��]") or str:find("�� �") or str:find("�������") then
    if str:find("����") or str:find("%s[����][����]%s") then
      obj_location = " � ������� ������ � ����"
    elseif str:find("[IiLl]dl[e]?wood") then
      obj_location = " � ������� �. Idlewood"
    elseif str:find("�����") then
      obj_location = " � ������ �������� ������"
    elseif str:find("�� ������") or str:find("����[�]?�[��] ����") then
      obj_location = " �� ������ �. Ganton"
    elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("[��]��� [��]����") or str:find("[Gg]anton") or str:find("[��][��]����") or str:find("[Gg]roove") then
      obj_location = " � ������� ������ Ganton"
    elseif str:find("[Gg]len [Pp]ark") or str:find("[��]��� [��]���") then
      obj_location = " � ������� �. Glen Park"
    else
      obj_location = " � ������� ������"
    end
  elseif str:find("[����][��]�[�]?�") then
    obj_location = " �� ������� � �. Las Venturas"
  elseif str:find("� [��][��]") then
    obj_location = " � �� � LS"
  elseif str:find("[Rr]ocksh[oe]r") and str:find("[Ww]est") then
    obj_location = " � �. Rockshore West �. LV"
  elseif str:find("�� ��� ��") or str:find("� �� ��� � ��") then
    obj_location = " � �. Los Santos ��� �. Las Venturas"
  elseif str:find("[��]��%s?%p?[��]��[�]?�����") or str:find("Las-Barancas") or str:find("���[�]?�[��]") or str:find("arran") or str:find("���[�]?���") or str:find("aran") or str:find("�.LB") then
    obj_location = " � �. Las Barrancas"
  elseif str:find("�����") or str:find("(.*)anta") or str:find("(.*)aria") or str:find("[��]����") then
    obj_location = " � �. Santa Maria"
  elseif str:find("[Mm]arina") or str:find("[��]����[��]") or str:find("[��]� [��]���[��]") then
    obj_location = " � �. Marina"
  elseif str:find("��%s?��") or str:find("��%s?��") then
    obj_location = " � ����"
  elseif str:find("� ��$") or str:find("� ��� ����������") or str:find("[��]��. [��]���������") or str:find("[��]������������ [��]���������") then
    obj_location = " � �� � LS"
  elseif str:find("[��]�") or str:find("��") or str:find("���") or str:find("���") or str:find("�.LS") or str:find("%s[Ll][Ss]") or str:find("LS%s?^[|]") or str:find("Los") or str:find("los") then
    if str:find("[��][��][��][��]") or str:find("%s[����][����]%s")  then
      obj_location = " � �. Los Santos �� ��"
    elseif str:find("�� ���� �����") or str:find("[��]��[��] [��]����") or str:find("� ������ [Vv]agos") or str:find("[��]��[��]����� [��]����") then
      obj_location = " � ������� �. Los Flores"
    elseif str:find("� [��]���[��]") or str:find("[��][��][��]") then
      obj_location = " � �������� LS"
    elseif str:find("[Mm]ulhol[l]?and") then
      obj_location = " � �. Mulholland, �. LS"
    elseif str:find("����[��]") or str:find("[��][��][��]") then
      obj_location = " � LS �� ���������"
    elseif str:find("� [��][��]") then
      obj_location = " � LS � ��"
    elseif str:find("� [��]������") then
      obj_location = " � ���������� LS"
    elseif str:find("[��] [��]������� [��]�����") then
      obj_location = " � �� �. Los Santos"
    elseif str:find("[Ee]ast [Bb]each") then
      obj_location = " � �. East Beach, �. LS"
    elseif str:find("[Ee]l [Cc]orona") then
      obj_location = " � LS, �. El Corona"
    elseif str:find("������� ��� � Palomino") then
      obj_location = " � �. Palomino Creek"
    elseif str:find("�� ������") or str:find("����[�]?�[��] ����") then
      obj_location = " �� ������ �. Ganton"
    elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("����[�]?�[��] [(����)|(Grove)|(grove)]") or str:find("[��]��� [��]����") or str:find("[Gg]anton") or str:find("[��][��]����") or str:find("[Gg]roove") then
      obj_location = " � ������� ������ Ganton"
    elseif str:find("��������[(��)|(�)]") or str:find("��������[(��)|(�)]") then
      obj_location = " � LS �� ����������"
    elseif str:find("[��]�� [��]�������") or str:find("[Ll]os [Vv]enturas") then
      obj_location = " � �. Las Venturas"
    elseif str:find("��%s?��") or str:find("��%s?��") then
      obj_location = " � ����"
    elseif str:find("�������") then
      obj_location = " � ��������� Los Santos"
    else
      obj_location = " � �. Los Santos"
    end
  elseif not str:find("������") and str:find("[��l][B��v]") or str:find("%s���") or str:find("���") or str:find("�.L%p?V") or str:find("%sL.V.") or str:find("%sLV") or str:find("LV[($)|(.)]") or str:find("LVPD") or str:find("enturas") or str:find("������") then
    if str:find("[��]��[�]?[��]") or str:find("[��][��][��]") then
      obj_location = " � �������� �. LV"
    elseif str:find("����") or str:find("%s[��][��]%s[��Ll][Vv��]") then
      obj_location = " �� ����"
    elseif str:find("[Bb][r]?u[jg]as") or str:find("[��][�]?�[�]?���") then
      obj_location = " � �. Las Brujas"
    elseif str:find("[��][��][��]") or str:find("[Ll]a [Cc]osa [Nn]ostra") then
      obj_location = " � �. Las Venturas, �. Prickle Pine"
    elseif str:find("[(���)|(�)|(����)|(����� �)] [��][��][��]") or str:find("[Pp]ay[a]?sad[aeo]") or str:find("[��]�����") or str:find("[��]�[�]?[��]�����") then
      obj_location = " � �. Las Payasadas"
    elseif str:find("[��]����") then
      obj_location = " � ������� �. Las Venturas"
    elseif str:find("[(�����)|(��������)] �[��]���") or str:find("[(�)|(�����)] �[��]���") or str:find("��������") or str:find("%s�����%s") then
      chatDebug(str)
      obj_location = " � �. Las Venturas ����� �����"
    elseif str:find("����") or str:find("LVPD") then
      obj_location = " � ����"
    elseif str:find("[Ww][ht]ite%s?[Ww]ood [Ee]st") or str:find("� [��P][M��]") then
      obj_location = " � LV, �. Whitewood Estates"
    elseif str:find("[Rr]e[d]?sands") then
      obj_location = " � LV, �. Redsands West"
    elseif str:find("[Pp]rickle") or str:find("[��]��[�]?[�]?�") or str:find("[Ll]a [Cc]osa [Nn]ostra") or str:find("%s[��]�����%s[��]����") or str:find("[��]������") or str:find("���� ����") or str:find("%s����%s") or str:find("[Pp][r]?i[n]?[c]?[k]?le") or str:find("[��][��][��]") or str:find("[Ll][CckK][Nn]") or str:find("[��]���") and ("[��]���������") then
      obj_location = " � �. Prickle Pine"  
    elseif str:find("� �������") then
      obj_location = " � ��������� ���� LV"
    elseif str:find("���%s?�������") then
      obj_location = " � �. Los Santos"
    else
      obj_location = " � �. Las Venturas"
    end
  elseif str:find("[Oo]cean [Ff]lats") then
    obj_location = " � SF, �. Ocean Flats"
  elseif str:find("[Bb][r]?u[jg]as") or str:find("[��][�]?�[�]?���") then
    obj_location = " � �. Las Brujas"
  elseif str:find("�� ������") then
    obj_location = " �� ������ � �. Los Santos"
  elseif not str:find("[Rr]e[d]?sands") and str:find("[��Cc][��]") or str:find("���") or str:find("��� %p ����[�]?�") or str:find("[�C][�a]�") or str:find("������") or str:find("[��].SF") or str:find("%sSF") or str:find("sf") or str:find("SF%s^[|]") or str:find("San") or str:find("san") then
    if str:find("[(��)|(�)] ����[��]") then
      obj_location = " � �. San Fierro �� ���������"
    elseif str:find("����") then
      obj_location = " � �. San Fierro � ����"
    elseif str:find("%s[��]���") then
      obj_location = " � �. San Fierro � ����"
    elseif str:find("%s[��]�����[(%s)|(%p)]") then
      obj_location = " � �. San Fierro � ������"
    elseif str:find("�[��]�") and str:find("����") then
      obj_location = " � �. Tierra Robada"
    elseif str:find("[��]������� [��]��[�]?��") or str:find("Juniper Hollow") then
      obj_location = " � �. Juniper Hollow, �. SF"
    elseif str:find("����") or str:find("[(�)|(�����)] �����") or str:find("SF%s?FM") then
      obj_location = " � ����������� SF"
    elseif str:find("����� [��][��][��]") then
      obj_location = " � �. Bayside"
    else
      obj_location = " � �. San Fierro"
    end
  elseif str:find("� [��]��������") then
    obj_location = " � �. SF � ���������"
  elseif str:find("[Dd][ei]l[l]?imor[e]?") or str:find("[��][��]�[�]?[��]�[��]�") then
    obj_location = " � �. Dillimore"
  elseif str:find("[(���)|(�)|(����)|(����� �)] [��][��][��]") or str:find("[Pp]ay[a]?[sl]ad[aeo]") or str:find("[��]�����") or str:find("[��]�[�][��]�����") then
    obj_location = " � �. Las Payasadas"
  elseif str:find("[��][��]?[��]?[���][��][�]?[��][^�]") or str:find("[Tt]ier[r]?[oa]") or str:find("[Tt]iro [Rr]obada") or str:find("%s[��][��]%s") or str:find("[T�]%s[(������)|Robada]") then
    obj_location = " � �. Tierra Robada"
  elseif str:find("[��B][��B][^�]") or str:find("��[^�]") or str:find("�� ���� ��") or str:find("�� [�]?%p?[��][��]$") or str:find("[wW][Ww]") or str:find("(.+)ine(.+)ood") or str:find("(.+)�[��][�]?(%s?)(.+)�[�]?�") then
    obj_location = " �� �. VineWood"
  elseif str:find("[��]������� [��]��[�]?��") or str:find("Juniper Hollow") then
    obj_location = " � �. Juniper Hollow, �. SF"
  elseif str:find("[Ee]ast [Bb]each") then
    obj_location = " � �. East Beach, �. LS"
  elseif str:find("�������") or str:find("[Mm]on[tg][h]?[tg][oe]m[eo]r[ey]") or str:find("���[�]?������") or str:find("M[ao]ntogomery") or str:find("����.+%s���") or str:find("[��]�[�]?[�?][�]?�[���]�[��]��") or str:find("����������") or str:find("mogomtery") or str:find("[��]��������") or str:find("����������") or str:find("[Mm]on[t]?go") then
    obj_location = " � �. Montgomery"
  elseif str:find("[Rr]ed") and str:find("[Cc]ount[r]?y") or str:find("RedCount[r]?y") or str:find("[��]��%s?[��][��][�]?����") or str:find("�.Red") or str:find("[��]����[�]? [��]��") then
    obj_location = " � �. Red"
  elseif str:find("[Ff]lint") and str:find("[Cc]ount[r]?y") or str:find("[��]����") or str:find("�.Flint") or str:find("�%sFC%p") then
    obj_location = " � �. Flint"
  elseif str:find("�� [��]����") then
    obj_location = " � �. Flint"
  elseif str:find("[iI]ntersect") then
    obj_location = " � �. Flint Intersection"
  elseif str:find("[Bb]one") or str:find("[��]�[��][��]? [��][��][�]?[�]?�[�]?[��]") or str:find("[��]�����") then
    obj_location = " � �. Bone"
  elseif str:find("%s[��][��][(%s)|(%p)]") or str:find("����� [��]������ �����") or str:find("[Ww][ht]ite%s?[Ww]ood [Ee]st") or str:find("� [��Pp][M��]") then
    obj_location = " � �. Whitewood Estates"
  elseif str:find("[IiLl]dl[e]?wood") then
    obj_location = " � ������� �. Idlewood"
  elseif str:find("[Pp]ri[n]?[c]?kl[e]?") or str:find("[��]��[��]?[��]?�") or str:find("[��]������") or str:find("%s[��]�����%s[��]����") or str:find("%s����%s") or str:find("[Pp][r]?i[n]?[c]?[k]?le") or str:find("[��][��][��]") or str:find("[Ll][CcKk][Nn]") or str:find("[��]���") and ("[��]���������") then
    obj_location = " � �. Prickle Pine"  
  elseif str:find("[Ee]l [Cc]orona") then
    obj_location = " � LS, �. El Corona"
  elseif str:find("� ����������") then
    obj_location = " � ���������a � �. LS"
  elseif str:find("[��Bb][��Mm��][����]") or str:find("[au]ys[ia][di][ed]") or str:find("[����][��]?��[�]?�") or str:find("[��]�������") then
    obj_location = " � �. Bayside"  
  elseif str:find("[Ww]hetstone") or str:find("[����]�������") then
    obj_location = " � �. Whetstone"
  elseif str:find("[Qq]u[ea][a]?[br]") or str:find("[��][���]?[��]?[���]?[��]���[��]�") or str:find("[��][���]?[��]?������") or str:find("[��]�������") or str:find("[��]������")then
    obj_location = " � �. El Quebrados"  
  elseif str:find("[Tt][ea]mple") or str:find("[��][��]�[��][��][�]?") or str:find("�����") then
    obj_location = " � �. Temple" 
  elseif str:find("(.-)����") or str:find("[��]��[�]?[�]?� [��][�]?�") or str:find("[��]�����") or str:find("[��]���� [��][����][��][��]") or str:find("(.+)[Nnh]gel%p?%s?(.+)[ie][ni][en]") or str:find("(.+)ngel%p?(.+)ain")or str:find("[��]�����[��] �� [��]�����") then
    obj_location = " � �. Angel Pine"
  elseif str:find("[��Pp][Kk��]") or str:find("[��][��]�[�]?[��]�[��][��][��]") or str:find("(.+)[ao]lo[nm]ino%p?%s?(.+)r[ei][eac]k") then
    obj_location = " � �. Palomino Creek"
  elseif str:find("[��][��]") or str:find("[��]���") or str:find("[��][�][�]?����") or str:find("[��]������") or str:find("(.+)or[td]%p?%s?%s?(.+)arso[n]?") then
    obj_location = " � �. Fort Carson"
  elseif str:find("�� ������") or str:find("����[�]?�[��] ����") then
    obj_location = " �� ������ � �. Ganton"
  elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("����[�]?�[��] [(����)|(Grove)|(grove)]") or str:find("[��]��� [��]����") or str:find("[Gg]anton") or str:find("[��][��]����") or str:find("[Gg]roove") then
    obj_location = " � ������� ������ Ganton"
  elseif str:find("[��]�[��]") or str:find("[Bb]lu[ed]?[Bb]e[r]?ry") or str:find("[(�����)|(�����)|(�)] ������") then
    if str:find("[(�����)|(�����)|(�)] ������") then
      obj_location = " � �. Blueberry"
    else
      obj_location = " � �. Blueberry"
    end
  elseif str:find("[Gg]ro[o]?ve [Ss]tre[e]?t") or str:find("[��]��� [��]����") or str:find("[Gg]anton") or str:find("[Gg]roove") then
    obj_location = " � �. Ganton, �. Los Santos"
  elseif str:find("�� ���� �����") or str:find("���� �����") or str:find("[��]��[��]����� [��]����") or str:find("[��]���� [��]����")  then
    obj_location = " � ������� �. Los Flores"
  elseif str:find("[��]��") and str:find("[��]����") then
    obj_location = " � ����������� ������"
  elseif str:find("�� ����(.-)") and (str:find("[Bb]al[l]?as") or str:find("[��]��[�]?��")) then
    obj_location = " � ������� �. Glen Park"
  elseif str:find("[Ll]as [Cc]olinas") or str:find("[��]�� [��]������") then
    obj_location = " � ������� �. Las Colinas"
  elseif str:find("[Gg]len [Pp]ark") or str:find("[��]��� [��]���") then
    obj_location = " � ������� �. Glen Park"
  elseif str:find("����� ���") or str:find("� ����") then
    obj_location = " � ������� �. Playa de Seville"
  elseif str:find("[��]���[��] [��]����") or str:find("� [��]����") then
    obj_location = " � ������� �. Las Colinas"
  elseif str:find("[Ee]l [Cc]asti") then
    obj_location = " � �. El Castillo del Diablo"
  elseif str:find("[Gg][Pp][Ss]%s4%s?%p?%s?8") then
    obj_location = " � �. Las Venturas"
  else
    obj_location = ""
  end
  return obj_location
end

function house_number(str)
  if str:find("�%s?%d+%s") then
    h_number = " �"..str:match("�%s?(%d+)%s?")
  elseif str:find("�%s?%d+%p") then
    h_number = " �"..str:match("�%s?(%d+)%p?")
  elseif str:find("��� �%d+$") then
    h_number = " �"..str:match("��� �(%d+)$")
  elseif str:find("[��]�� N %d+") then
    h_number = " �"..str:match("[��]�� N (%d+)")
  elseif str:find("�����%s%d+%p?%s") then
    h_number = " �"..str:match("�����%s(%d+)%p?%s")
  elseif str:find("����[�c]� %d+ �����") then
    h_number = " �"..str:match("����[�c]� (%d+) �����")
  elseif str:find("�������%s%d+%p?%s") then
    h_number = " �"..str:match("�������%s(%d+)%p?%s")
  elseif str:find("�������%s%d+!") then
    h_number = " �"..str:match("�������%s(%d+)!")
  elseif str:find("�������%s%d+$") then
    h_number = " �"..str:match("�������%s(%d+)$")
  elseif str:find("%W+%s%d+%s�������$") then
    h_number = " �"..str:match("%W+%s(%d+)%s�������$")
  elseif str:find("#%d+%p?%s") then
    h_number = " �"..str:match("#(%d+)%p?%s")
  elseif str:find("[��]��%s%s?%d+%s[^( ��)]") then
    h_number = " �"..str:match("[��]��%s%s?(%d+)%s")
  elseif str:find("��������� ��� %d+, �") then
    h_number = " �"..str:match("��������� ��� (%d+), �")
  elseif str:find("[��]� ������� ��������� ��� %d+$") then
    h_number = " �"..str:match("[��]� ������� ��������� ��� (%d+)$")
  elseif str:find("[��]��%s%W+%s?%d+%s[^( ��)]") and str:find("[��]��") then
    h_number = " �"..str:match("[��]��%s%W+(%d+)%s")
  elseif str:find("�� ������� %d+") then
    h_number = " ������� �"..str:match("�� ������� (%d+)")
  else h_number = "" end
  return h_number
end

function auction(str)
  house_type = get_house_type(str)
  debug("AUCTION | "..str, 3)
  if str:find("[��]���") or str:find("[��]�����") or str:find("%s��%s") and str:find("%$") then
    word = auction_word(str)
    auction_string = "�� ������� "..word.." "..house_type..get_house_class(str)..house_number(str)..get_location(str)..". "..get_price(str, trade_type(str))
    return auction_shortener(auction_string)
  end
  print(get_house_type(str))
  word = auction_word(str)
  return "�� ������� "..word..get_house_class(str).." "..house_type..house_number(str)..get_location(str)..". �����!"
end

function auction_shortener(str)
  if str:find("��������") then
    str = str:gsub("�������� ������", "����.")
  elseif str:find("��������") or str:find("[��]���") then
    str = str:gsub("�������� ������", "����."):gsub("����", "����.")
  elseif str:find("��[��]���") then
    str = str:gsub("������ ������", "����.")
  elseif str:find("��������") then
    str = str:gsub("�������� ������", "���. ��.")
  end
  return str
end

function auction_word(str)
  if house_type:find("�������[��]") then
    word = "����������"
    house_type = "��������"
  else
    word = "���������"
  end
  return word
end

function ad_handler(str)
 --debug(str, 2)
  if str:find("[��Cc][��]?���[��][��]%s?�") or str:find("[��]�������") or str:find("[��]������") or str:find("[^(��������)]%s[��]���[��][�����]") or str:find("�����") or str:find("[��]�[��]����[��]") or str:find("[��]�[��]���") or str:find("[��]������ �����") or str:find("[��]������ �����") then
    -- debug("CATCHED", 3)
    if str:find("[��]��") then
       return auction(str)
    end
    return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_house_repair(str), house_number(str), get_location(str))
  
  elseif not str:find("pacey") and not str:find("[��]����") and not str:find("24%p7") and not str:find("������") and not str:find("[Gg][Pp][Ss]") and not str:find("������") and not str:find("[��]����") and not str:find("[��]���") and not str:find("GPS 8%p2") and not str:find("�����") and str:find("%s[��][;��]?[������][������]") or str:find("^[��]��%s") or str:find("^%W- ���$") or str:find("[��]����� %p���") or str:find("%W+%p���%s") or str:find("��� �� �") or str:find("������") or str:find("�����") or str:find("%shouse") or str:find("�������") or str:find("[��]����") or str:find("%shome") or str:find("[��]����") or str:find("dom") or str:find("[��]����") or str:find("[��]�����") or str:find("%s��%s") or str:find("[��]���(.-) [��]����(.-)") or str:find("[��]����") or str:find("[��]���%p���") or str:find("[��][��]��[�]?��[��]") or str:find("����[�]?����") or str:find("�������") or str:find("���������") or str:find("[��]���[��]�") or str:find("[��][��][����][��]?[��]") or str:find("%s���") or str:find("[��][��]������") or str:find("%s����") or str:find("[��]����") or str:find("�����") or str:find("����%p?%s?���") or str:find("��� ���") or str:find("��� [��]����������") or str:find("[��]������� � �����") or str:find("vremenoe jilie") or str:find("[��]��[��][��]�[���]?") or str:find("[��]����[��]") or str:find("[��]���[��][��]�") or str:find("����") or str:find("[��]�����") then
    --debug("HATA", 5)
    if str:find("[��]��") or str:find("[��]� ���[�]?") or str:find("[��]�������") then
      house_type = get_house_type(str)
      
      --debug("AUCTION | "..str, 3)
      if str:find("[��]���") or str:find("[��]�����") or str:find("%s��%s") and str:find("%$") then
        word = auction_word(str)
        auction_string = "�� ������� "..word.." "..house_type..get_house_class(str)..house_number(str)..get_location(str)..". "..get_price(str, trade_type(str))
        return auction_shortener(auction_string)
      end
      print(get_house_type(str))
      word = auction_word(str)
      return "�� ������� "..word..get_house_class(str).." "..house_type..house_number(str)..get_location(str)..". �����!"
    else
      return home_string(str, trade_type(str), get_house_type(str), get_house_class(str), get_house_repair(str), house_number(str), get_location(str))
    end
  elseif not str:find("����") and not str:find("8%p273") and not str:find("[Pp]rice") and not str:find("[��]����") and str:find("[��][�]?����[��][��]") or str:find("������[(%s)|($)]") or str:find("������ ������%s") or str:find("��������� �������") then
    tt = trade_type(str)
    return action[tt].."��������� �������"..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("����") then
    if str:find("������ ��� �����") then
      return "����� ������ ��� ����� ������ � �������� ������� ����� GPS 8-127"
    elseif str:find("[��]����%p[��]�����") then
      return "���������� �����-������ ������ � �������� �� GPS 8-127"
    elseif str:find("������") then
      return "������ ����� ����������? ����� ���� � ������� ����� | GPS 8-127"
    elseif str:find("[��][�e]�[x�]") then
      --debug("+++", 1)
      if str:find("[(���������)|(������)] ���� �� �����") then
        return "��������� ���� �� ����� ������ � �������� ����� | GPS 8-127"
      elseif str:find("����� [��]���� �") then
        return "������ ����� ������ � ��������-����� | �� � GPS: 8-127"
      elseif str:find("[��]������ �������") then
        return "������� ������� ���� ������ � �e�����-�����! �� � GPS 8-127"
      elseif str:find("[��]����� �������") then
        return "������ ������� ���� ������ � ��������-�����! | �� � GPS 8-127"
      elseif str:find("Hippy%pCar") then
        return "���������� �Hippy Car� ������ � ��������-�����! �� � GPS 8-127"
      else
        return "������ ������ �������� ����� � �. San Fierro. "..get_price(str, trade_type(str))
      end
    end
    return "������ ������ \"������ �����\""..get_location(str)..". "..get_price(str, trade_type(str))
  elseif str:find("[��]��[��][��] [��]���[��]") or str:find("[��]���� [��]���������%s?%p?$") or str:find("[��]��[��][��] [Ff��][Tt��]") or str:find("[Ff��][Tt��] ����������") or str:find("����� ����") or str:find("[��]���� ����%p") or str:find("[��]���� [��]��[��]�[��]%p?$") or str:find("[��]���� [��]��[��]�� [��]��") or str:find("�������%.") or str:find("�����[�]� �����") then
    if str:find("[��]���") or str:find("������") or str:find("�������%.") then
      return "����� ������� ����� �����. "..get_price(str, trade_type(str))
    elseif str:find("[��]����") and str:find("[��]��") then
      return "����� ������ ����� �����. "..get_price(str, trade_type(str))
    end
    return "����� ���������� ����� �����"..car_tuning(str)..". "..get_price(str, trade_type(str))
  elseif str:find("[Nn][RrGg][GRrg]") or str:find("[��][����][����]") or str:find("NRG") then -- ������� ����������
    return vechicles(str, trade_type(str), "��������", "NRG-500")
  elseif str:find("[Ff][Cc][Rr]") or str:find("[��][����][��]") then -- ������� ����������
    return vechicles(str, trade_type(str), "��������", "FCR-900")
  elseif str:find("[Pp][Cc][Jj]") or str:find("[��][��][��]") then -- ������� ����������
    return vechicles(str, trade_type(str), "��������", "PCJ-600")
  elseif str:find("[Ss]anchez") or str:find("[��]�����") then -- ������� ����������
    return vechicles(str, trade_type(str), "��������", "Sanchez")
  elseif str:find("[Ff]reeway") or str:find("[��]�����") then -- ������� ����������
    return vechicles(str, trade_type(str), "��������", "Freeway")
  elseif str:find("[Bb][Mm][Xx]") then -- ������� ����������
    return vechicles(str, trade_type(str), "���������", "BMX")
    elseif str:find("[mM]o[vw]er[(%p)|($)|(%s)]") or str:find("[��][��]���[(%p)|($)]") then
    return vechicles(str, trade_type(str), "�������������", "Mower")
  elseif str:find("GT[^A]") or str:find("%s��[^�]") or str:find("����� [��][��]") or str:find("Super GT") or str:find("[(super)|(�����)] gt") then
    return vechicles(str, trade_type(str), "����������", "Super GT")
  elseif str:find("��[��][��][(��)]?") or str:find("s[uy]ltan") or str:find("[��][��][���]?[��][��]?�") or str:find("S[uy]l[l]?tan") or str:find("S[YU]LTAN") or str:find("[��]����") then 
    return vechicles(str, trade_type(str), "����������", "Sultan")
  elseif str:find("[Bb][Ff]") or str:find("[Ii]njection") or str:find("[��][��]") then 
    return vechicles(str, trade_type(str), "����������", "BF Injection")
  elseif str:find("[��][���]�[��]�") or str:find("������") or str:find("aver[r]?i[c]?[kc]") or str:find("�����") or str:find("mavik") or str:find("��[��][�]?��") or str:find("averi�") then 
    return vechicles(str, trade_type(str), "�������", "Maverick")
  elseif str:find("zrx") or str:find("zrx 350") or str:find("zrx-350") or str:find("ZRX") or str:find("[Zz][Rr]") or str:find("ZRX-350") or str:find("ZRX 350") then 
    return vechicles(str, trade_type(str), "����������", "ZRX-350")
  elseif str:find("ul[l]?et") or str:find("[��]���[��]") or str:find("[��]��[���]�") or str:find("[��]���[�]?[��]�") then
    return vechicles(str, trade_type(str), "����������", "Bullet")
  elseif str:find("[Pp]remier") or str:find("PREMIER") or str:find("[��]�[��]�[��][��][��]") then
    return vechicles(str, trade_type(str), "����������", "Premier")
  elseif str:find("[Ee]legant") or str:find("[����]������") then
    return vechicles(str, trade_type(str), "����������", "Elegant")
  elseif str:find("[Rr]emington") or str:find("[��]����[�]?���") then
    return vechicles(str, trade_type(str), "����������", "Remington")
  elseif str:find("[Ww]il[l]?ard") or str:find("[����]��[�]?���") then
    return vechicles(str, trade_type(str), "����������", "Willard")
  elseif str:find("[Ss][ea]nti[n]?el") or str:find("[��]�������") then
    return vechicles(str, trade_type(str), "����������", "Sentinel")
  elseif str:find("(.*)an%s?(.*)in[gd]") or str:find("[��]���[��]���") or str:find("�������") or str:find("(.*)[���]�[��]?%s?[�]?��[�]?�") or str:find("sek ft") or str:find("%s[�Ss][�Kk]%s") or str:find("(%s)[��][��](%s)") or str:find("(%s)[��][��]$") or str:find("(%s)�[��]�[��](%s)") or str:find("(%s)���� ����") or str:find("SANDKING") or str:find("��������") then
    return vechicles(str, trade_type(str), "����������", "Sandking")
  elseif str:find("tre[tsn]ch") or str:find("�����") or str:find("[��]�����") or str:find("[Ss]tr[ae][t]?[cs]h") or str:find("[��][��]?[��]���[�]?�") or str:find("[��]����[��] �����") then
    return vechicles(str, trade_type(str), "����������", "Stretch")
  elseif str:find("�����") or str:find("�����") or str:find("[Ee]leg[yu]") or str:find("legy") or str:find("enegy") or str:find("[����]����") or str:find("[����]��[��][��]�") or str:find("[��]���") then
    return vechicles(str, trade_type(str), "����������", "Elegy")
  elseif str:find("[��Rr][��Ii][��Oo][��Tt]%s?%+") or str:find("[rt]iot%s?%+") or str:find("���� %+") or str:find("[��]��[��][��]� %+") or str:find("[��]����� %+") or str:find("[Pp]atrik %+") or str:find("���[�]?�� %+") or str:find("[��]������ [��]���") then
    return vechicles(str, trade_type(str), "����������", "Patriot +")
  elseif str:find("��[�]?��") or str:find("riot") or str:find("[^(��)]����") or str:find("[��]��[��][��]�") or str:find("[��]�����") or str:find("[Pp]atrik") or str:find("���[�]?��") then
    return vechicles(str, trade_type(str), "����������", "Patriot")
  elseif str:find("[��]������") or str:find("[Pp]revion") then
    return vechicles(str, trade_type(str), "����������", "Previon")
  elseif str:find("[��]��%p?%s?[��]��") or str:find("[Hh]ot%p?%s?[Dd]og") then
    return vechicles(str, trade_type(str), "����������", "Hotdog")
  elseif str:find("[��]������") or str:find("[Aa]dmiral") then
    return vechicles(str, trade_type(str), "����������", "Admiral")
  elseif str:find("�[��]����") or str:find("[Hh]unt[le][el][yt]") or str:find("[��]����") or str:find("untly") or str:find("������") then
    return vechicles(str, trade_type(str), "����������", "Huntley")
  elseif str:find("[Ll]andstalker") or str:find("[��][��]�[�]?�������") then
    return vechicles(str, trade_type(str), "����������", "Landstalker")
  elseif str:find("[��][��]?[��][��][��][��]") or str:find("[��]���[��]�[��]") or str:find("[Tt][UuYy]ri[sz]mo") then
    return vechicles(str, trade_type(str), "����������", "Turismo")
  elseif str:find("[Cc]adrona") or str:find("[��]������") then
    return vechicles(str, trade_type(str), "����������", "Cadrona")
  elseif str:find("[��]���[��]") and (str:find("[��]���") or str:find("[��]��")) then
    return vechicles(str, trade_type(str), "����������", "�����")
  elseif str:find("[��]����") or str:find("[Mm]erit") then
    return vechicles(str, trade_type(str), "����������", "Merit")
  elseif str:find("[^(�����%s)][Aa]lpha") or str:find("[(�����)] Alpha") or str:find("[��]���[��]") then
    return vechicles(str, trade_type(str), "����������", "Alpha")
  elseif str:find("[Uu]ranus") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����������", "Uranus")
  elseif str:find("[Jj]ester") or str:find("[��]������") then
    return vechicles(str, trade_type(str), "����������", "Jester")
  elseif str:find("[Bb]uffalo") or str:find("[��]��[�]?��[�]?�") then
    return vechicles(str, trade_type(str), "����������", "Buffalo")
  elseif str:find("[Pp]hoenix") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����������", "Phoenix")
  elseif str:find("[Hh]ot%s?[Kk][hn]ife") or str:find("[��]��[�]?����") then
    return vechicles(str, trade_type(str), "����������", "Hotknife")
  elseif str:find("[Mm]esa") or str:find("[��]��[��]") then
    return vechicles(str, trade_type(str), "����������", "Mesa")
  elseif str:find("[Oo]ceanic") or str:find("[��]������") then
    return vechicles(str, trade_type(str), "����������", "Oceanic")
  elseif str:find("[Bb]ansh") or str:find("[��]��[�]?�") then
    return vechicles(str, trade_type(str), "����������", "Banshee")
  elseif str:find("[Ss]unri[sc]e") or str:find("[��][��]����[��]") then
    return vechicles(str, trade_type(str), "����������", "Sunrise")
  elseif str:find("����� %p?%p?[Ss��]%p?[Ww��]%p?[Aa��]%p?[Tt��]") or str:find("S.W.A.T") or str:find("S[Ww][Aa][Tt]") or str:find("[��][��][��][��]") then
    return vechicles(str, trade_type(str), "����������", "S.W.A.T")
  elseif str:find("[Ee]uros") or str:find("[����][��]���") then
    return vechicles(str, trade_type(str), "����������", "Euros")
  elseif str:find("[Ss]avan") or str:find("[��]����") then
    return vechicles(str, trade_type(str), "����������", "Savanna")
  elseif str:find("[Ff]ortune") or str:find("[Ff]ORTUNE") or str:find("[��]���") and not str:find("[Pp]rice") then
    return vechicles(str, trade_type(str), "����������", "Fortune")
  elseif str:find("[Dd]un[ea]") or str:find("[��]��[��]?") then
    return vechicles(str, trade_type(str), "����������", "Dune")
  elseif str:find("[Dd][eo]lor[ei][a]?n") or str:find("[��][��]���[��]��") then
    return vechicles(str, trade_type(str), "����������", "Delorean")
  elseif str:find("[Bb]lade") or str:find("[��]�[���]��") then
    return vechicles(str, trade_type(str), "����������", "Blade")
  elseif str:find("[Vv]oodoo") or str:find("[��]���") then
    return vechicles(str, trade_type(str), "����������", "Voodoo")
  elseif str:find("[Mm]onster") or str:find("[��]%s?����[��]?[�]?") or str:find("MONSTER") or str:find("�����[�]?�") then
    return vechicles(str, trade_type(str), "����������", "Monster A")
  elseif str:find("[Ss]lamvan") or str:find("[��]�[���]��[���]�") then
    return vechicles(str, trade_type(str), "����������", "Slamvan")
  elseif str:find("[Mm]oonbe") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����������", "Moonbeam")
  elseif str:find("[Rr][ua][mnp][mp]o") or str:find("[��][��][��]��") then
    return vechicles(str, trade_type(str), "����������", "Rumpo")
  elseif str:find("[Rr]omero") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����������", "Romero")
  elseif str:find("[WwVv]indsor") or str:find("[��]���[��]��") then
    return vechicles(str, trade_type(str), "����������", "Windsor")
  elseif str:find("[Jj]ourney") then
    return vechicles(str, trade_type(str), "����������", "Journey")
  elseif str:find("[Bb]uccaneer") then
    return vechicles(str, trade_type(str), "����������", "Buccaneer")
  elseif str:find("[Bb]lista [Cc]ompact") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����������", "Blista Compact")
  elseif str:find("[Pp]eren[n]?i[ea]l") or str:find("[��]�������") then
    return vechicles(str, trade_type(str), "����������", "Perennial")
  elseif str:find("[Bb]roadway") or str:find("[��]����[��]�") then
    return vechicles(str, trade_type(str), "����������", "Broadway")
  elseif str:find("[Ss]taf[f]?ord") or str:find("[Cc��]�[��]�[�]?���") then
    return vechicles(str, trade_type(str), "����������", "Stafford")
  elseif str:find("[Yy]osemite") or str:find("[��]������") then
    return vechicles(str, trade_type(str), "����������", "Yosemite")
  elseif str:find("[Gg]lendale") or str:find("[��]�������") then
    return vechicles(str, trade_type(str), "����������", "Glendale")
  elseif str:find("[Ff][BbIi][BbIiRr]%s?%p?[Rr][n]?a[cn][ncs]?[hn]e[rl]") or str:find("F[BI][BRI] RANCHER") or str:find("��[��] ���[�]?[��]��") or str:find("�[��][����] [��][��]?[��]?�[�]?[��]") or str:find("[��][��]�[��]�� [��][��][����]") then
    return vechicles(str, trade_type(str), "����������", "FBI Rancher")
  elseif str:find("[Ff][BbIi][BbIiRr]%s?%p?[Tt]r[ua]ck") or str:find("[��][����][������] [��]�[��][�]?") then
    return vechicles(str, trade_type(str), "����������", "FBI Truck")
  elseif str:find("[Rr]an[cs][hn]e[rl]") or str:find("[��]�[�]?�[��]��") then
    return vechicles(str, trade_type(str), "����������", "Rancher")
  elseif str:find("[Ww]ashington") or str:find("[��]��������") then
    return vechicles(str, trade_type(str), "����������", "Washington")
  elseif str:find("[��]������") then
    return vechicles(str, trade_type(str), "����������", "�������")
  elseif not str:find("������") and str:find("[Cc]lover") or str:find("[����]�����") and not str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����������", "Clover")
  elseif str:find("[Mm]anana") or str:find("[��]����[��]") then
    return vechicles(str, trade_type(str), "����������", "Manana")
  elseif str:find("[Ss]t[ae]l[l]?ion") or str:find("[��]�[���]�[�]?���") then
    return vechicles(str, trade_type(str), "����������", "Stallion")
  elseif str:find("[Ss]abre") or str:find("[��]����") or str:find("[��]����") then
    return vechicles(str, trade_type(str), "����������", "Sabre")
  elseif str:find("[Ff]l[ae]sh") or str:find("[��]�[��]�") then
    return vechicles(str, trade_type(str), "����������", "Flash")
  elseif str:find("[��]����") or str:find("[Cc��]omet") then
    return vechicles(str, trade_type(str), "����������", "Comet")
  elseif str:find("[��]������") or str:find("[Ss]tratum") then
    return vechicles(str, trade_type(str), "����������", "Stratum")
  elseif str:find("[Bb]andit") or str:find("[��]����") or str:find("[��]�����[�]?�") and not str:find("����") then
    return vechicles(str, trade_type(str), "����������", "Bandito")
  elseif str:find("[��]����") or str:find("hamal") or str:find("�����") or str:find("[Ss]hama[nl]") then
    return vechicles(str, trade_type(str), "������", "Shamal")
  elseif str:find("[Nn]evad[ae]") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "������", "Nevada")
  elseif str:find("[Rr]ustler") or str:find("[��][��]�[�]?���") then
    return vechicles(str, trade_type(str), "������", "Rustler")
  elseif str:find("[Aa]ndrom[ae]da") or str:find("[��]���[��]�[���]�[��]") then
    return vechicles(str, trade_type(str), "������", "Andromada")
  elseif str:find("[Bb]eagle") or str:find("[��][��][�]?��") then
    return vechicles(str, trade_type(str), "������", "Beagle")
  elseif str:find("[Cc]ropduster") then
    return vechicles(str, trade_type(str), "���������", "Cropduster")
  elseif str:find("[Dd]odo") or str:find("[��]���") then
    return vechicles(str, trade_type(str), "������", "Dodo")
  elseif str:find("t[au]n(.*)%s?[Pp]la[(ne)|(y)]") or str:find("tun[t]?%s?[Pp]la[(ne)|(y)]") or str:find("������%s?�(.+)�") or str:find("[��]���[��]%s?[��]�(.+)") then
    return vechicles(str, trade_type(str), "������", "Stuntplane")
  elseif str:find("�������") or str:find("������") or str:find("a[r]?row") or str:find("[Ss]appraw") or str:find("������") or str:find("����[�]?��") or str:find("����[�]?��") then
    return vechicles(str, trade_type(str), "�������", "Sparrow")
  elseif str:find("[Rr]ain[e]?dance") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "�������", "Raindance")
  elseif str:find("[Ll]ev[ie]athan") or str:find("[��]����[��]��") then
    return vechicles(str, trade_type(str), "�������", "Leviathan")
  elseif str:find("arq[ui][ie]s") or str:find("������") or str:find("������") then
    return vechicles(str, trade_type(str), "����", "Marquis")
  elseif str:find("[Tt]ropic") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "����", "Tropic")
  elseif str:find("[Vv]ortex") or str:find("[��]������") then
    return vechicles(str, trade_type(str), "�����", "Vortex")
  elseif str:find("[Ss]peader") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "�����", "Speader")
  elseif str:find("[Rr]e[ae]fer") or str:find("[��]����") then
    return vechicles(str, trade_type(str), "�����", "Reefer")
  elseif str:find("[Dd]ingh[iy]") or str:find("[��]����") then
    return vechicles(str, trade_type(str), "�����", "Dinghy")
  elseif str:find("[Jj]etmax") or str:find("[��]�������") then
    return vechicles(str, trade_type(str), "�����", "Jetmax")
  elseif str:find("[Ss]qual[l]?o") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "�����", "Squallo")
  elseif str:find("[Ss]pe[e]?der") or str:find("[��]�����") then
    return vechicles(str, trade_type(str), "�����", "Speeder")
  elseif str:find("heetah") or str:find("�����") or str:find("����") or str:find("����") or str:find("������") then
    return vechicles(str, trade_type(str), "����������", "Cheetah")
  elseif str:find("nf[er][er]nus") or str:find("�[�]?�[��][��][��]�") or str:find("���[��]") or str:find("[Ii]nf[eu](.-)s") or str:find("[��][��][��][��][��]") or str:find("���[�]?����") or str:find("INFERNUS") or str:find("%s����%s") or str:find("infa") then
    return vechicles(str, trade_type(str), "����������", "Infernus")
  elseif str:find("��%s?��[�]?� [����bB]") or str:find("o[r]?t[r]?ing [��Bb��]") or str:find("otring B") or str:find("[��]���[(���)]? [��Bb��]") or str:find("[a�][c�][e�][r�] [Bb����]") or str:find("acer B") or str:find("[��]����� [��]") then
    return vechicles(str, trade_type(str), "����������", "Hotring Racer B")
  elseif str:find("�[��][���][��][�]?�[�]? [Aa��]") or str:find("o[r]?t[r]?ing a") or str:find("ot[Rr]ing A") or str:find("[��]���[(���)]? [��Aa]") or str:find("[a�A�][c�C�][e�E�][r��R] [��Aa]") or str:find("acer %p?A%p?") or str:find("���[��][��](.-) [��]") then
    return vechicles(str, trade_type(str), "����������", "Hotring Racer A")
  elseif str:find("������") or str:find("o[r]?t[r]?ing") or str:find("������[��]") or str:find("acer") then
    return vechicles(str, trade_type(str), "����������", "Hotring Racer")
  elseif str:find("[Bb]l[o]?odring [Bb]anger") or str:find("BLOODRING BANGER") or str:find("[��]�������") then
    return vechicles(str, trade_type(str), "����������", "Bloodring Banger")
  elseif not str:find("[��]�����") and str:find("��������") or str:find("[��]���������[(��)|(��)]") or str:find("%s[��][��]%s?") or str:find("���������") or str:find("%s��%s") and not str:find("�����") then
    if str:find("��� ��������") or str:find("[��]�� ���������") then
      return "��� ��������� ��� ����������� ����� � ������. ��������. �������!"
    end
    return "��� ������ � ������������ ��������. ��� �������."
  elseif str:find("[��]���[��][��](.-) [��]������") then
    return "������������ ������ ������� ��������. �������."
  
  elseif str:find("[Gg][Pp][Ss]") and str:find("[Ss]%p?%s?4%s?%p%s?7") and not str:find("[��]������") then
    if str:find("[Pp]rada") then -- �������� ������������� � ������� �hiesa GPS 4-7.
      --debug("������", 3)
      if str:find("[��]�[�]� ������������") or str:find("�������������") then
        return "���� ������������� � ��������� �������� �Prada�! ����: GPS 4-7"
      elseif str:find("[��]�������") then
        return "�������� ������������� � �� �Prada� | ���������: GPS 4-7"
      end
    elseif str:find("[Cc]hiesa")then
      if str:find("[��]������� �������������") then
        return "�������� ������������� � �������. �������� �Chiesa� | GPS 4-7"
      end
    end
    
  elseif str:find("[Gg][Pp][Ss]") and str:find("4%s?%p%s?9") then
    if str:find("�������� ����� �") and str:find("[��]�����") then
      return "�������� ����� � ���� ������� ����������. | �� � GPS 4-9"
    end

  elseif str:find("[Gg][Pp][Ss]") and str:find("4%s?%p%s?4") then
    if str:find("�������� ����� �") then
      return "�������� ����� � ����-���� �DRIFA�. | GPS 4-4 | ���!"
    end

  elseif str:find("���� �����") then    -- ������� --
    return "��������� ���� ����� ���-����. ������� ��������� ���� | GPS 8-280"
  elseif str:find("[��]���[��][��]�(.+) [��]���(.+)") and str:find("[Ll��][Vv��]") then
    if str:find("������� ������ �����") then
      return "������� ������ ������� ������ � ��������� �������� �� | GPS 8-234"
    elseif str:find("������� [��]������") then
      return "������� ������� � ���������� �������� LV� | GPS 8-234"
    elseif str:find("��������� [��]������") then
      return "��������� �������� � ���������� �������� LV� | GPS 8-234"
    elseif str:find("������������ �[�]?�������") then
      return "� ���������� �������� LV� ������������ ��������� | GPS 8-234"
    end
  elseif str:find("[��]�������� [��]�������") and str:find("8%s?%p?%s?84") then
    if str:find("�������� LS ��������� ��������") then
      return "� ���������� �������� LS� ��������� ��������. GPS 8-84."
    end
  elseif str:find("[��]���") and str:find("[��]�����������") then
    if str:find("������ ���������") then
      return "������ ��������� ������� � ������ ������������. GPS 8-55"
    elseif str:find("������ ������ ��������") then
      return "������ ������ ��������? ���� � ���� ������������! �� � �����. LS!"
    elseif str:find("������ �������� �������") then
      return "������ �������� �������? ���� ������������ ���� ���! | GPS 8-55"
    end

  elseif str:find("[Gg]aydar [Ss]tation") then
    if str:find("����� �� ������") then
      return "����� �� ������? �������� � ����� �Gaydar Station�. | Price 3-29"
    elseif str:find("[��]�����") then
      return "������ ���� �Gaydar Station�"..get_location(str)..". "..get_price(str, trade_type(str))
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("7%s?%p%s?1") then
    if str:find("�� �����%p%s?��") then
      return "�� �����? �� � �����? ����� ���� � �Advance Club�. | �� � GPS 7-1"
    elseif str:find("����� ������������ ������") then
      return "����� ������������ ������ ������ � �Advance Club�. GPS 7-1"
    elseif str:find("������ ���������") then
      return "������ ��������� � ����� �Advance Club� | GPS 7-1"
    elseif str:find("������ ������� ������") then
      return "������ ������� ������ � �Advance Club�. GPS 7-1! ������� �����!"
    elseif str:find("������ �������") then
      return "������ �������! �������� ������! ������ � �Advance Club�! GPS 7-1"
    end
  elseif str:find("[��]���") and str:find("7%s?%p%s?2") or str:find("8%s?%p%s?281") then
    if str:find("���� ����� ��[��][��]����") then
      return "�������� ���� ����� �������� � ����� �. San Fierro | GPS 7-2"
    elseif str:find("����� ���������") then
      return "����� ���������? ������ ������ �������� � ���� SF�! | GPS 8-281"
    end
    
  elseif str:find("[��]��������[���] [��]��������[��][�]?") and str:find("8%s?%p%s?46") then
    if str:find("���") then
      return "� ����������� ���������� ��� �� ���. ���� | GPS 8-46"
    elseif str:find("[��]������") then
      return "� ����������� ���������� ������� �� 125.000$ | GPS 8-46"
    elseif str:find("������ ������") then
      return "������ ������? ����� ���� � ����������� ���������� | GPS 8-46"
    elseif str:find("������ ������ �������") then
      return "������ ������ ������� � ����������� ����������! | GPS 8-46"
      --� "���������� �����������" ������ ������-�������! GPS 8 > 46.
    elseif str:find("���������[��][�]?%p ������ ������%p?�������") then
      return "� ����������� ���������� ������ ������-������� | GPS 8-46"
    end
  elseif str:find("[��]�������") and str:find("8%s?%p%s?46") then
    if str:find("���� ���� ���") then
      return "�������� �� ���� ���� ��� ����! | �� �������� GPS 8-46"
    end
  
  elseif str:find("[��]���[��]�") and not str:find("[��]���") and not str:find("[��]����") then
    if str:find("����� ������� �����") then
      return "������ ������� �����? � ������� LS� ������ �� 300.000$ | GPS 8-22"
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?20") then
      if str:find("�������� � ������ ���%p�������") then
        return "��������� � ������� ���-�������. | ����� ��� �� GPS 7-20"
      elseif str:find("� �������") then
        return "� ������� ������� Los Santos� ������ �� ������� ������ | GPS 7-20"
      elseif str:find("������ �� �������") then
        return "� ������� LS� ������ �� ������� ������! | �� � GPS 7-20"
      elseif str:find("������� � ����") then
        return "������ ������� � ���� � ������� Los Santos� | ���������: GPS 7-20"
      elseif str:find("������� �������� � ������") then
        return "����� ������� �������� � ������ �. ��� ������! | GPS 7-20"
      elseif str:find("������ ������� �����") then
        return "������ ������� �����? ���� ������� � ������� LS� | GPS 7-20"
      elseif str:find("������� � ������") then
        return "������ ������� � ������ � �K����� Los Santos�. | GPS 7-20"
      elseif str:find("������� ���� �����") then
        return "������� ���� ����� � ������ � ������� Los Santos�. | GPS 7-20"
      end
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?22") then
      if str:find("������ �������� ���") then
        return "������ �������� ���? ����� ���� � ���������� ������ | GPS 7-22"
      elseif str:find("� ������� ����[��]�") then
        return "� ������� ������ ���������� ������ �� ������� ������! | GPS 7-22"
      end
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?21") then
      if str:find("������� � [��]��������") then
        return "������� � ��������� � ������� ������� ���-��������� | GPS 7-21"
      elseif str:find("�������� [��]���") then
        return "�������� ����? ������� � ������� ������ ���-���������. GPS 7-21"
      end
    elseif str:find("[Gg][Pp][Ss]") and str:find("%p?%s?7%s?%p%s?18") then
      if str:find("������ �� ������� �����") then
        return "� ������ �4 ������� ������ �� ������� �����! | GPS 7-18"
      end
    else
      print("{cc0000}ERROR 1:{b2b2b2}", str)
      return "ERROR"
    end
  
  elseif str:find("[Pp]rice%s7%s?%p%s?10") then
    if str:find("������ �������?") then
      return "������ �������? ���� ���������� ���� ������������! Price 7-10"
    elseif str:find("������ ���� ����") then 
      return "������ ���� ���� � ���������� Angel Pine�! | Price 7-10"
    elseif str:find("������") then
      return "7 ��� ������, 1 ��� ������ - �������� Angel Pine�. Price 7-10"
    end
  elseif str:find("%s?8%s?%p%s?147") then
    if str:find("������� ������������") then
      return "������� ������������ ����������� ������� �� GPS 8-147!"
    elseif str:find("��������� ������ ���") then
      return "��������� ������ ��� ����� ����� �� ����� �� GPS 8-147!"
    elseif str:find("������ � ������������") then
      return "������ � ������������ Fort Carson �� GPS 8-147!"
    end

  elseif str:find("%s?8%s?%p%s?193") then --  
    if str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-193"
    end

    if str:find("����� ������ ���� �� ���") then
      return "����� ������ ���� �� ��� � �Burger Shot �3� � LV | "..biz_loc
    elseif str:find("������� �������") then
      return "C���� ������� ������� � ��� | "..biz_loc
    end  
  elseif str:find("[Pp]rice%s7%s?%p%s?19") or str:find("%s?8%s?%p%s?195") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 7-19"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-195"
    end

    if str:find("����� ������� ������") then
      return "����� ������� ������ ������ � ��������� Las-Venturas�. "..biz_loc
    elseif str:find("������ � ��� �������") then
      return "������ � ��� ������� � ��������� Las-Venturas� | "..biz_loc
    elseif str:find("��� � ������") then
      return "��� � ������ � ��������� Las-Venturas�. | "..biz_loc
    elseif str:find("������� ��������") then
      return "������� ��������? � ����� � ������ Pink��� ��� ������! | "..biz_loc
    elseif str:find("������ �������� ������") then
      return "������ �������� ������ ������ � ��������� Las-Venturas�. "..biz_loc
    elseif str:find("��������� Lilka") then
      return "��������� Lilka, �������� PinkyWay! ��� ������ � �����! "..biz_loc
    elseif str:find("������� �����") then
      return "������� �����? ������ �������� ����? �������� LV ����! "..biz_loc
    elseif str:find("����� ������� �������") then
      return "����� ������� ������� � ��������� Las-Venturas�. "..biz_loc
    elseif str:find("������� ���� �������") then
      return "������� ���� ������� �������� ��������� �� "..biz_loc
    elseif str:find("��������� � ��� �������") then
      return "��������� � ��� ������� ������� � ��������� LV�. "..biz_loc
    elseif str:find("����� ������� ������� �������") then
      return "���� ����� ������� ������� ������� � ��������� LV�. "..biz_loc
    elseif str:find("���������� �������") then
      return "���������� ������� ������ � ��������� LV�. "..biz_loc
    elseif str:find("���������� �[��][��]�����") then
      return "���������� �������� ������ � ��������� LV�. "..biz_loc
    elseif str:find("������� �������") then
      return "����� ������� ������� � ��� | Price 7-19"
    end
  elseif str:find("[Pp]rice%s7%s?%p%s?1111111") or str:find("%s?8%s?%p%s?25") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 7-19"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-25"
    end

    if str:find("����� �����") then
      return "����� ����� � ��������� ��������� �ѻ - ������� �� 695$. "..biz_loc

    end

  elseif str:find("[Pp]rice%p?%s?3%s?%p%s?54") then
    if str:find("������ ������� � ������� %s?� ����") then
      return "������ ������� � ������� � ����-��� ��������. | Price 3-54"
    elseif str:find("��� �� �����") then
      return "��� �� �����? ����-��� ��������. �� �������� 24/7 | Price 3-54"
    elseif str:find("��������� ������") then
      return "��������� ������ � ���� ��������. �������� 24/7. | Price 3-54"
    elseif str:find("������ �������") then
      return "������ �������! ����-��� ��������! �� �� �������! | Price 3-54"
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?2$") then
    if str:find("�������� � ��� �� ����") then
      return "�������� � ��� �� ���� � ��������� �. Los Santos. | Price 2-2"
    elseif str:find("���������� ����� ������") then
      return "���������� ����� ������ � ��� � ���������� Los Santos� | Price 2-2"
    elseif str:find("������ ����� ������") then
      return "������ ����� ������ � ��� � ���������� Los Santos� | Price 2-2"
    end

  elseif str:find("[Pp]rice%p?%s?16%s?%p?%s?2$") then
    if str:find("������ ����� �������") then
      return "������ ����� �������? ���� � ��� ����� ��� �������! | Price 16-2"
    elseif str:find("������ ������ ��������") then
      return "������ ������ �������� �����? ���� � �����. �����! | Price 16-2"
    elseif str:find("������ �������� �������") then
      return "������ �������� ������� �����? ���� � �� �����! | Price 16-2"
    elseif str:find("����� �� ������ ��") then
      return "����� �� ������ �� ������� � ����� ����������� �����. Price 16-2"
    elseif str:find("����� ������ �� �����") then
      return "����� ������ �� ����� �� 1000$ � ������ �����������. Price 16-2"
    end
  elseif str:find("[Pp]rice%p?%s?16%s?%p%s?3$") then
    if str:find("����� ��������� � ���������������") then
      return "����� ��������� � ��������������� ������ �������. | Price 16-3"
    end

  elseif str:find("[Pp]rice%p?%s?16%s?%p%s?4$") then
    if str:find("������ ���� ������������") then
      return "������ ���� ������������ � ��������������� ������ LS | Price 16-4"
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?17")  or str:find("%s?8%s?%p%s?105") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 2-17"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-105"
    end
    if str:find("�������� ����������� ����������") then
      return "��������� ����������� ���������� � �. San Fierro. | "..biz_loc
    elseif str:find("������� � �����������") then
      return "�������� � ����������� ���������� San Fierro. | "..biz_loc
    elseif str:find("������� �� 90") then
      return "������� �� 90$ � ������� ���� � ��������� ����-�����. "..biz_loc
    elseif str:find("����� ���� ������ �������") then
      return "����� ���� ������ ������� ����� ��������� ����-�����. "..biz_loc
    elseif str:find("������� ����� ����������") then
      return "������� ����� ���������� ����, � ��������� ����-�����. "..biz_loc
    elseif str:find("���������� ������") then
      return "������ ����� - ���������� ������! �������� ����-�����. "..biz_loc
    elseif str:find("�� ������ ��� ��������") then
      return "�� ������ ��� �������� �����? �������� ����-�����. "..biz_loc
    elseif str:find("��������� ����� �� ����") then
      return "��������� ����� �� ����, ������ � ��������� ����-����� "..biz_loc
    elseif str:find("��������� ��������� ����") then
      return "��������� ��������� �������� � �����. �������� ��Ի "..biz_loc
    elseif str:find("��������� ��������� ��") then
      return "��������� ��������� ���� � �����. �������� ��Ի "..biz_loc
    elseif str:find("������� �����������") then
      return "������� �����������! ������ ��� � ��������� ���-������ "..biz_loc
    elseif str:find("���������� ������ ����� ������") then
      return "���������� ������ ����� ������! �������� ���-������ "..biz_loc
    elseif str:find("�������� ������ � ������") then
      return "�������� ������ � ������ ��������� � ���������� �Ի | "..biz_loc
    elseif str:find("�������� ������ � ������") then
      return "�������� ������ � ������ ������ � ���������� �Ի | "..biz_loc
    elseif str:find("������������ ������") then
      return "������������ ������ ����� � ���������� �Ի | "..biz_loc
    elseif str:find("����������� ���������� ���") then
      return "����������� ���������� ��� � ���������� �Ի | "..biz_loc
    elseif str:find("������ �����") then
      return "������ ����� �� ���� ���� ��� � ���������� �Ի | "..biz_loc
    elseif str:find("��������� �����") then
      return "��������� ����� � ������ ���������� ���-������ | "..biz_loc
    elseif str:find("�� ����������") then
      return "�� ���������� ����. ����� � ���������� ���-������ | "..biz_loc
    elseif str:find("��������� �����") then
      return "�������� ���-������ � ��������� ����� ��� ������! "..biz_loc
    elseif str:find("��� ���� �����������") then
      return "�������� ��� ���� ����������� � ���������� ���-������! "..biz_loc
    elseif str:find("����� ��") then
      return "��������� ����� � ���������� ���-������ ����� �� 300$! "..biz_loc
    elseif str:find("���� ���� ���") then
      return "������������� ���� ���� ��� � ���������� ���-������! "..biz_loc
    elseif str:find("������ ������") then
      return "������ ������ � ������ ����� � ���������� ���-������ "..biz_loc

    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?18") then
    if str:find("����, ������� ������") then
      return "����, ������� ������ - ��� �������� �San Fierro�! | Price 2-18"
    elseif str:find("������� ������������� ��������") then
      return "������� ������������� �������� � ��������� ����-����� Price 2-18"
    elseif str:find("������� �� 90") then
      return "������� �� 90$ � ������� ���� � ��������� ����-�����. Price 2-18"
    elseif str:find("����� ���� ������ �������") then
      return "����� ���� ������ ������� ����� ��������� ����-�����. Price 2-18"
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?25") then
    if str:find("������� ������� �����") then
      return "������� ������� ����� � ����������� Fort Carson�! | Price 2-25"
    end

  elseif str:find("[Pp]rice%p?%s?555%s?%p%s?11") or str:find("%s?8%s?%p%s?74") then
    if str:find("[Pp]rice333") then
      biz_loc = "Price 255-11"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-74"
    end
    if str:find("���� ����� �����") then
      return "���� ����� �����? ����� ���������? ���� ���� � ���� �� "..biz_loc
    end

  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?11") or str:find("%s?8%s?%p%s?75") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 2-11"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-75"
    end
    if str:find("�������� � ���� ����������") then
      return "�������� � ���� ����������. ������� ��� � ������ ����! "..biz_loc
    elseif str:find("������� � ���� ����") then
      return "������� � ���� ���� �El Gran Burrito�. ���� �� 300$. "..biz_loc
    elseif str:find("������� ��� � ������ ����") then
      return "������� ��� � ������ ���� � ���� �El Gran Burrito�. "..biz_loc
    elseif str:find("�������%p �� ����") then
      return "�������? �� ����! ����������� � ����� �������� ����. "..biz_loc
    end
    
  elseif str:find("%s?8%s?%p%s?42") then --str:find("[Pp]rice%p?%s?2%s?%p%s?11")
    if str:find("[Pp]rice") then
      biz_loc = "Price 2-11"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-42"
    end
    if str:find("������ ���� ��� �������� ����") then
      return "������ ���� ��� �������� ����? ���� � �� �������. "..biz_loc
    elseif str:find("������ ������ �����") then
      return "������ ������ �����? ���� � �� ������� �� ��� | "..biz_loc
    elseif str:find("����� �������� ����") then
      return "����� �������� ���� � �� ������� �� ��� | "..biz_loc
    elseif str:find("[��]�����") then
      if str:find("GPS") then
        return "������ ������ �� ������� �� GPS 8-42. "..get_price(str, trade_type(str))
      end
      return "������ �� ������� � �. Los Santos. "..get_price(str, trade_type(str))
    end
  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?19") or str:find("PRICE%p2%p19%p") then
    if str:find("�������� ��������� �������") then
      return "����� �����? ������� ���� �������� ��������� �������! Price 2-19"
    elseif str:find("����� ������� �������") then
      return "������� ������� � ����������� Burger Shot �� �1�! Price 2-19"
    elseif str:find("������� ������") then
      return "������� ������ � �Burger Shot SF �1�! | Price 2-19"
    elseif str:find("������ ������") then
      return "������ ������ � �Burger Shot SF �1�! | Price 2-19"
    elseif str:find("����� ������ �������") then
      return "����� ������ ������� � �Burger Shot SF �1�! | Price 2-19"
    elseif str:find("����� ������� [��] ������") then
      return "����� ������� � ������ ������� � �Burger Shot SF �1� | Price 2-19"
    end
  elseif str:find("[Pp]rice%p?%s?2%s?%p%s?34") then
    if str:find("������� ���� �� ���") then
      return "������� ���� �� ��� � ����� �������� BurgerShot LV �3. Price 2-34"
    end
  elseif str:find("Price 2 %p ���������� � �����") or str:find("[Pp]rice%p?%s?2%p?$") and str:find("[Ee]ast [Ll][Ss]") then
    if str:find("����� ������ ���� ������ � �����") then
      return "����� ������ ���� � ����� ���������� � �. East LS. Price 2-9"
    elseif str:find("����� ������ ���� �� ���") then
      return "����� ������ ���� �� ���. ����� East LS. Price 2-9"
    end
  elseif str:find("[Pp]rice%p?%s?3%s?%p%s?2") or str:find("%s?8%s?%p%s?4[(%p)|($)|(%s)]") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 3-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-4"
    end
    if str:find("������ ������� �") then
      return "������ ������� � ���� �10 ������� ������� �. Ganton! | "..biz_loc
    elseif str:find("������� � ����������� ����") then 
      return "������� � ����������� ���� �10 ������� �������. "..biz_loc
    elseif str:find("����������� ���") then 
      return "����������� ��� �10 ������� ������� ����� ������! | "..biz_loc
    elseif str:find("������� ������") then 
      return "������� ������ � ���� �10 ������ �������! | "..biz_loc
    elseif str:find("��� �����") then 
      return "����� ����� - ��� �����! ��� �10 ������� | "..biz_loc.." | ���!"
    elseif str:find("������ ����� ����") then 
      return "������ ����� ����! ��� �10 ������� | "..biz_loc.." | ���!"
    elseif str:find("� ����� ��� ������") then 
      return "� ����� ��� ������! ��� �10 ������� | "..biz_loc.." | ���!"
    elseif str:find("��� ������� %p ������ � �����") then 
      return "��� ������� - ������ � �����! ��� �10 ������� | "..biz_loc.." | ���!"
    elseif str:find("C�������� ��� ���������") then 
      return "C�������� ��� ���������! ��� �10 ������� | "..biz_loc.." | ���!"
    elseif str:find("������ ����") then 
      return "����� ���� - ������ ���� �� ����! ��� �10 ������� | "..biz_loc
    end
    
  elseif str:find("[Pp]rice%p?%s?7%s?%p%s?1%p?$") or str:find("%s?8%s?%p%s?9$") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 7-1"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-9"
    end
    
    if str:find("������� �������� � ������") then
      return "����� ������� �������� � ������������ ������� | "..biz_loc
    elseif str:find("������� ������ �") then
      return "���� ������� ������ � �������� | "..biz_loc
    elseif str:find("��������� �������") then
      return "������� �����, ��������� �������� - � ������� �ѻ | "..biz_loc
    elseif str:find("�������������") then
      return "������� ������ - ������ ������������� - � ������� �ѻ. | "..biz_loc
    elseif str:find("������� �������� �") then
      return "����� ������� �������� � �������� �� ��������� �. LS | "..biz_loc
    elseif str:find("������� � ����� ��������") then
      return "������� � ����� �������� � �. Los Santos | "..biz_loc
    elseif str:find("������� � ���������� ��������") then
      return "������� � ���������� �������� � �. Los Santos | "..biz_loc
    elseif str:find("������ ������ �����") then
      return "������ ������ �����, ������ �������� ������� �� ��� | "..biz_loc
    elseif str:find("�������� � [��]�����������") then
      return "�������� � ������������ ������� �� ��������� LS | "..biz_loc
    end
  
  
  elseif str:find("[Pp]rice%s12%s?%p%s?2") then
    if str:find("����� ��������") then
      return "����� �������� ���������� �� ��������� ����! | Price 12-2"
    end
  elseif str:find("[Pp]rice%s12%s?%p%s?5") then
    if str:find("����� ������") then
      return "������� ������ �����ɻ - ����� � ������! | �� �����: Price 12-5"
    end
  elseif str:find("[Pp]rice%p?%s12%s?%p%s?6") then
    if str:find("�����[��]") then
      return "������ ����������� ��������� ������ � LV. "..get_price(str, trade_type(str))
  
    elseif str:find("����� ����� ��������") then
      return "����� ����� �������� � ��������� ������. | �� � Price 12-6"
    elseif str:find("��� ������ ��������") then
      return "����������� ��������� ������ ��� ������ ��������. | Price 12-6"
    elseif str:find("����� ������ ����") then
      return "����� ������ ���� � ����������� ��������� ������. | Price 12-6"
    end
  elseif str:find("[Pp]rice%s5%s?%p%s?3%s?%p%s?3") then
    if str:find("������� ��� � ��������") then
      return "������� ��� � �������� ������ �Didier-Sachs� | �� � Price 5-3-3"
    end
    
  elseif str:find("GPS%p?%s?7%s?%p%s?3") then
    if str:find("������� KFC") then
      return "������� KFC � �Cluckin Bell �� �2� � Ghetto! �� �������� GPS: 7-3"
    elseif str:find("������ ���� � ����������") then
      return "������ ���� � ���������� ���� � Cluckin Bell �2. �������� GPS 7-3"
    elseif str:find("���. ������ � Cluckin") then
      return "���. ������ � Cluckin Bell �2 � ������� ������.  �������� GPS 7-3"
    elseif str:find("�������� ����������") then
      return "�������� ���������� � Cluckin Bell �2 � ������� ������. � GPS 7-3"
      
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?162") then
    if str:find("�������� �������� � ��������") then
      return "�������� �������� � �������� ������ �Binco� � ���. | GPS 8-162"
    elseif str:find("�������� ������") then
      return "�������� ������ �� 7.000$ � �������� �Binco� � ���. | GPS 8-162"
    elseif str:find("������ � ������������") then
      return "������ � ������������ ������ � �Binco� � �������� LV | GPS 8-162"
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?45") then
    if str:find("����� ���� � ���������") then
      return "�������� ����� ���� � ��������� �� ���� ���� � LS | GPS 8-45"
    elseif str:find("�������� ������") then
      return "�������� ������ �� 7.000$ � �������� �Binco� � ���. | GPS 8-162"
    end
  elseif str:find("[��]������") and str:find("%p?%s?8%s?%p%s?163") then
    if str:find("������ �������") then
      return "������ ������� ��������� � �Burger Shot �� �1� | GPS 8-163"
    end
  elseif str:find("[Gg][Pp][Ss]%p?%s?8%s?%p%s?16%p?$") or str:find("[Gg][Pp][Ss]%s8%s16%p?$") then
    if str:find("������ ��� � ����") then
      return "������ ��� � ����, �������� � ���������� ���-������ | GPS 8-16"
    elseif str:find("��� ��������� � ������") then
      return "������ ��������� ���-������. ��� ��������� � ������! | GPS 8-16"
    elseif str:find("�� ������ ���") then
      return "���� �������������� ������ ��� � ���������� ���-������! GPS 8-16"
    elseif str:find("���� ������ ���") then
      return "�������� ������ ��� � ���������� ���-������! GPS 8-16"
    elseif str:find("���� ������� ������ ���") then
      return "�������� ������� ������ ��� � ���������� ���-������! GPS 8-16"
    elseif str:find("�������� ������� ��������") then
      return "�������� ������� �������� � ���������� ���-������. | GPS 8-16"
    elseif str:find("Romanee Conti") then
      return "���������� ��������� Romanee Conti 1945 ����? ��� � ���! GPS 8-16"
    elseif str:find("������� ������ � ���������") then
      return "������ ���������, ������� ������ � ��������� ���-������! GPS 8-16"
    elseif str:find("������ �� ������ ������") then
      return "������ �� ������ ������? ���� � ��������� �� ������ LS! GPS 8-16"
    elseif str:find("������ ����� � ���") then
      return "������ ����� � ��� � ���������� �� ������ �.Los Santos! GPS 8-16"
    elseif str:find("[��]����") then
      return "������ ������ ��������� �� ������ �. Los Santos. "..get_price(str, trade_type(str))
    end

    
  elseif str:find("GPS%p?%s?8%s?%p%s?44") then
    if str:find("����������� �������� 1 ���������") then
      return "� ������������ �������� ��������� ���� �� 525.000$ | GPS 8-44"
    end
  elseif str:find("%p?%s?3%s?%p%s?16") then
    if str:find("������� �������") then
      return "������� ������� � ����������� Cluckin Bell SF�. �� � gps 3-16."
    end
  elseif str:find("GPS%p?%s?2%s?%p%s?10") then
    if str:find("�� ����� ����") then
      return "������� � ���������� - �� ����� ����! | ����� � GPS 2-10"
    elseif str:find("����� ������� ����������") then
      return "� �������� � ���������� ����� ������� ����������! | GPS 2-10"
    elseif str:find("������� ������ �������") then
      return "������� ������ ������� - ������� � ����������! | GPS 2-10"
    elseif str:find("Faggio ��") then
      return "������� � ���������� - Faggio �� 4.999$! | GPS 2-10"
    elseif str:find("� ������") then
      return "������ �Faggio� � ������, � ������� � ���������� | GPS 2-10"
    end
    
  elseif str:find("GPS%p?%s?8%s?%p%s?258") then
    if str:find("������� ������ ���� ������ � �������") then
      return "������� ������ ���� ������ � ������� � �������� LV. | GPS 8-258"
    elseif str:find("��������� ���� � ������� ����") then
      return "��������� ���� � ������� ���� � �������� LV! | GPS 8-258"
    end
  elseif str:find("�����") and str:find("LV") then
    return "������ �������� ������� � ���������� ��������� �. LV | GPS 8-234"
  elseif str:find("GPS%p?%s?1%s?%p%s?4") or str:find("%p��������%p ����� ����� LV") then
    if str:find("������� ����� �") then
      return "������� ����� � ��������� � ����� LV�. | �� ����� GPS: 1-4"
    elseif str:find("����� �������� ����[��][��]��") then
      return "����� �������� �������� � ��������� ����� ����� LV. ���� ���!"
    end
  elseif str:find("������ ������������ �������") and str:find("[��]���� [��Ll][��Ss]") then
    return "������ ������������ ������� � ������������ � ����� LS. ���� ���!"

  --===========================
  elseif str:find("���������������") then 
    return "��������������� ������� � ��������� ��������� LS� | Price 7-3"
  elseif str:find("[Pp]rice%s7%s?%p%s?3") then
    if str:find("��� �������") then
      return "� ��������� ��������� LS� ��� �������, ���� �� ����� ����! Price 7-3"
    end
  --===========================

  elseif str:find("[��]��") and str:find("%s?8%s?%p%s?196") then 
    return "����� ������� ����� � ��������� � ����� Los Santos. | �� � GPS 8-196"
  elseif str:find("[Bb]ell") and str:find("%s?8%s?%p%s?173") then 
    if str:find("������ ������") then
      return "������ ������ ������ � �Clukin Bell �1� � LV. �������� GPS 8-173"
    elseif str:find("��������� �������") then
      return "��������� ������� � Clukin Bell �1 � LV. �������� GPS 8-173"
    end

  elseif str:find("[Pp]rice%s?3%p53") then 
    if str:find("������ ����") then
      return "������ ���� �Last Drop� � �. Montgomery. | �� � Price 3-53"
    end

  elseif str:find("������ � ��[�]?����") and str:find("%s?8%s?%p%s?102") then 
    return "������ � �������? ���� � ���! | GPS 8-102"
  elseif str:find("[��]��������� ����") and str:find("%s?8%s?%p%s?35") then 
    return "����������� ���� Los Santos ����������� ���� �������� | GPS 8-35"
  elseif str:find("%s?8%s?%p%s?24%p?$") then 
    if str:find("��� ����������") then
      return "��� ���������� �� ����������� ����� � ������ ��������� | GPS 8-24"
    elseif str:find("������������ ����������") then
      return "�������. ���������� �� ������ ����� � ������ ��������� | GPS 8-24"
    elseif str:find("������� ����� �����������") then
      return "������� ����� ����������� �� ������ ����� � ������ ���������. GPS 8-24"

    elseif str:find("������ ��������� %p�������%p") then
      return "������ ��������� �������� ����� ������ � ������ � �� | GPS 8-24"
    elseif str:find("������ ��������� %p����%p") then
      return "������ ��������� ������ ����� ������ � ������ � �� | GPS 8-24"
    elseif str:find("������� ����� ������") then
      return "� �������������� ���������� ������� ����� ������. �� � GPS 8-24."
    elseif str:find("[��]�����") then
      return "������ �������������� � ���������. ���������� LS. "..get_price(str, trade_type(str))
    end  
  elseif str:find("%s?8%s?%p%s?60%p?$") then 
    if str:find("������ ����������") then
      return "������ ���������� � ��� - ���������� ��������������� | GPS 8-60"
    elseif str:find("������������ ����������") then
      return " | GPS 8-60"

    end  

  elseif str:find("[Pp]rice%p? 4%p5") or str:find("[Pp]rice%p? 4%p1%p5") or str:find("[��]����") and str:find("%s?8%s?%p%s?50") or str:find("%s?8%s?%p%s?51") then 
    if str:find("%s?8%s?%p%s?50") then
      biz_loc = "�� � GPS 8-50"
    elseif str:find("%s?8%s?%p%s?51") then
      biz_loc = "GPS 8-51"
    elseif str:find("%s?4%s?%p%s?5") then
      biz_loc = "Price 4-5"
    elseif str:find("%s?4%s?%p%s?1%s?%p%s?5") then
      biz_loc = "Price 4-1-5"
    end
    if str:find("��������") then
      return "�������� � �������������� ����������. | "..biz_loc
    elseif str:find("������ ����� �����") then
      return "� �������������� ���������� ������ ����� �����. "..biz_loc
    elseif str:find("�������������� �������") then
      return "� �������������� ������� �������� | "..biz_loc
    elseif str:find("����� �������� ������") then
      return "����� �������� ������ � �������������� ���������� | "..biz_loc
    elseif str:find("������������ ���������� ������") then
      return "������������ ���������� � �������������� ���������� | "..biz_loc
    elseif str:find("����� ����� ������ �� ������") then
      return "����� ����� ������ �� ������ � ��������. ���������� | "..biz_loc
    elseif str:find("������� ���������� ������") then
      return "������� ���������� ������ � �������������� ���������� | "..biz_loc
    elseif str:find("����� CJ") then
      return "������ ��������� ������ CJ� ����� � ������ ���������� | "..biz_loc
    elseif str:find("����� ���� ������") then
      return "����� ���� ������ ��������� ������� �� ����������� | "..biz_loc
    elseif str:find("����������") then
      return "������ ���� ����������� ����� ������ � ����������� | "..biz_loc
    elseif str:find("����� �����") then
      return "��� ��������� ������ ����� ������ � ����������� | "..biz_loc
    elseif str:find("������� ���������� � ��������������") then
      return "������� ���������� � �������������� ����������.  | "..biz_loc
    elseif str:find("������ ���� � ��������������") then
      return "������ ���� � ��������. ���������� � ������� ������  | "..biz_loc
    elseif str:find("���������� �� 3000") then
      return "���������� �� 3000$ � �������������� ����������! | "..biz_loc
    elseif str:find("������ ���������� ������") then
      return "������ ���������� ������ � �������������� ����������! | "..biz_loc
    elseif str:find("����� ���������� �") then
      return "����� ���������� � ��������������  ����������! | "..biz_loc
    elseif str:find("������� ���� �� ����������") then
      return "������� ���� �� ����������! ����� � ���! | "..biz_loc
    elseif str:find("���������� � ����� �����") then
      return "���������� � ����� ����� �� ������ �����! | "..biz_loc
    elseif str:find("[��]�����") then
      return "������ ��������. ���������� � ������� ������. "..get_price(str, trade_type(str))
    end -- ���������� �� 3000$ � �������������� "���������"! Price: 4-1-5!
  
  elseif str:find("[Pp]rice%s?4%s?%p%s?13") then 
    if str:find("%s?4%s?%p%s?13") then
      biz_loc = "Price 4-13"
    end
    if str:find("Fort Carson ������ ����") then
      return "����� ������������ ������ � Fort Carson - ������ ����. "..biz_loc
    end
  elseif str:find("[Pp]rice%p?%s?4%s?%p%s?1%s?%p%s?10") then 
    if str:find("%s?4%s?%p%s?1%s?%p%s?10") then
      biz_loc = "Price 4-1-10"
    end
    if str:find("����� �����") then
      return "����� ����� � ��������������� El Quebrados� | "..biz_loc
    end
  
  elseif str:find("[Pp]rice%p?%s?4%s?%p%s?16") or str:find("GPS%p?%s?6%s?%p%s?3") and not str:find("[��]���") then 

    if str:find("%s?4%s?%p%s?16") then
      biz_loc = "Price 4-16"
    else
      biz_loc = "�� � GPS 6-3"
    end
    if str:find("������ ���� �� ���������� � ������") then
      return "������ ���� �� ���������� � ������ �Little Lady�. "..biz_loc
    elseif str:find("������ ���� ������") then
      return "������ ���� ������ � ������ ������� �Little Lady�. "..biz_loc
    end
    --Price 4 > 1 > 3.
    
  elseif str:find("[Pp]rice%s?4%s?%p%s?1%s?%p%s?5")  then 
    if str:find("%s?8%s?%p%s?50") then
      biz_loc = "�� � GPS 8-50"
    elseif str:find("%s?8%s?%p%s?51") then
      biz_loc = "GPS 8-51"
    elseif str:find("rice%s?4%s?%p%s?1%s?%p%s?5") then
      biz_loc = "Price 4-1-5"
    end
    if str:find("� ����� ������� %p[��]����") then
      return "� ����� ������� ������� ������� ��������. | "..biz_loc
    elseif str:find("������ ����� �����") then
      return "� �������������� ���������� ������ ����� �����. "..biz_loc
    end
    
  elseif str:find("[Pp]rice%s?4%s?%p%s?4%s?%p%s?3") then
    if str:find("rice%s?4%s?%p%s?4%s?%p%s?3") then
      biz_loc = "Price 4-4-3"
    end
    if str:find("���� ��������") then
      return "���� �������� �� 1 �������� � ������ ������� �������. "..biz_loc
    elseif str:find("���� �����") then
      return "�������? ���� ����� � ������ ������� ������� | "..biz_loc
    elseif str:find("����������� ����������") then
      return "����������� ���������� � ������ ������� ������� | "..biz_loc
    elseif str:find("����������� ������ � ������") then
      return "����������� ������ � ������ ������� ������� | "..biz_loc
    elseif str:find("������ ���������� � ") then
      return "������ ���������� � ������ ������� ������� | "..biz_loc
    elseif str:find("���� �������� ������") then
      return "���� �������� ������ � ������� ������� ������� | "..biz_loc
    elseif str:find("������� ������") then
      return "������� ������ � ������ ������� ������� | "..biz_loc
    end
  elseif str:find("[Pp]rice%s?4%s?%p%s?1%s?%p%s?3") or str:find("%s?8%s?%p%s?30") then 
    if str:find("%s?%p?8%s?%p%s?30") then
      biz_loc = "GPS 8-30"
    elseif str:find("rice%s?4%s?%p%s?1%s?%p%s?3") then
      biz_loc = "Price 4-1-3"
    end
    if str:find("� ����� ������� %p[��]����") then
      return "� ����� ������� ������� ������� �������� | "..biz_loc
    elseif str:find("���� ������ ���") then
      return "���� ������ ��� � �������������� ������� | "..biz_loc
    elseif str:find("���� ������ �������") then
      return "���� ������ �������, ���� ����� � ������ �������. "..biz_loc
    elseif str:find("������ ����� � ��������") then
      return "������ ����� � �������� ������� | "..biz_loc
    end
  elseif str:find("%s?8%s?%p%s?129") then 
    if str:find("%s?%p?8%s?%p%s?129") then
      biz_loc = "GPS 8-129"
    elseif str:find("rice%s?4%s?%p%s?1%s?%p%s?3") then
      biz_loc = ""
    end
    if str:find("�������� ����") then
      return "�������� ���� � ����� ������ ������� | "..biz_loc
    end
  elseif str:find("%s?8%s?%p%s?240") then
    if str:find("������ �������� ���� � ���") then
      return "������ �������� ���� � ���! ���� ������! | GPS 8-240"
    elseif str:find("������ ���� ������") then
      return "������ ���� ������! ���� �������������� � ���! | GPS 8-240"
    elseif str:find("������ ���� � ����������") then
      return "������ ���� � ����������! ������ ������ �� �������! | GPS 8-240"
    end  

  elseif str:find("[��]���������") and str:find("%s?8%s?%p%s?242") then
    if str:find("� ����������[��]��[��][�]? [��]��� ��������� ���") then
      return "� ���������������� LV� ��������� ���. ��������� ����. GPS 8-242"
    end  

  elseif str:find("[��]���������") and str:find("%s?1%s?%p%s?20") or str:find("[Pp]rice%p?%s?18%p2%p1") then -- or str:find("%s?8%p241") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 18-2-1"
    elseif str:find("[Gg][Pp][Ss]") then
      if str:find("241") then
        biz_loc = "Price 18-2-1"
      end
    end
    if str:find("�������� ���� � ") then
      return "�������� ���� � ���������������� Los Santos�. "..biz_loc
    elseif str:find("������������ �[��]�������") then
      return "������� ������ ��������� � ���������������� LS�. "..biz_loc
    elseif str:find("������� � �����������") then
      return "������� � ����������� � ��������������� �ѻ! "..biz_loc
    end  

  elseif str:find("[��]������[�]?��") and str:find("%s?1%s?%p%s?20") or str:find("[Pp]rice%p?%s?18%p2%p2") or str:find("%s?8%p241") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 18-2-2"
    elseif str:find("[Gg][Pp][Ss]") then
      if str:find("241") then
        biz_loc = "GPS 8-241"
      else
        biz_loc = "�� � GPS 1-20"
      end
    end
    if str:find("���������� � ���������������") then
      return "���������� � ����������������� San Fierro. "..biz_loc
    elseif str:find("������ ���� ��� �������") then
      return "������ ���� ��� ������� � ����������������� SF. "..biz_loc
    elseif str:find("����� �����, ����") then
      return "����� �����, ���� - 0$. � ����������������� SF. "..biz_loc
    elseif str:find("������ �������� ����") then
      return "������ �������� ���� � �C��������������� SF! | "..biz_loc
    elseif str:find("������ �������� ������") then
      return "������ �������� ������ � ����������������� SF! | "..biz_loc
    elseif str:find("ash") then
      return "������ �Cash-Back� � ���������������� SF� | "..biz_loc
    elseif str:find("������ �������� ���") then
      return "������ �������� ���? ������ ��� � ���������������� SF�! "..biz_loc
    elseif str:find("������ ������ ������") then
      return "��������������� SF� - ������ ������ ������ ������! | "..biz_loc
    elseif str:find("������� ��� �����") then
      return "������� ��� ����� � ���������������� �Ի. | "..biz_loc
    elseif str:find("���� � ���[�]�") then
      return "���� � ���� ����� ���� �� ����������������� �Ի | "..biz_loc
    end  

  elseif str:find("[��]�����") and str:find("%s?8%s?%p%s?239") or str:find("%s?1%s?%p%s?21") then
    if str:find("239") then
      biz_loc = "GPS 8-239"
    else
      biz_loc = "GPS 1-21"
    end
    if str:find("������ ������ � [��]��������") then
      return "������ ������ � ���������� ������ LV�! "..biz_loc
    elseif str:find("����� ������ ���� ��") then
      return "����� ������ ���� �� ��� ������ � ��������� ������ ��. "..biz_loc
    elseif str:find("����������� ���� �� ����") then
      return "����������� ���� �� ���� ����� � ��������� ������ ��. "..biz_loc
    elseif str:find("�������� ��� �����") then
      return "�������� ��� ����� ����� � ���������� ������� �» | "..biz_loc
    end  

  
  elseif str:find("[��]����[�]? [��]���������") and str:find("%s?8%s?%p%s?50") or str:find("%s?8%s?%p%s?243") or str:find("%s?18%p3%p1") or str:find("GPS%p ���� LS") then 
    if str:find("������� ������� � ������") then
      return "������� ������� � ������, � ������� ���������� �. LS! GPS: 8-243"
    elseif str:find("[��]����� ���� �����") then
      return "������ ���� ������ ������� � ������� ���������� LS� | GPS 8-243"
    elseif str:find("���� ����� �� �������") then
      return "���� ����� �� ������� ������� � ����������� LS� | GPS 8-243"
    elseif str:find("�������� ��� �������") then
      return "�������� ��� ������� � ������� ���������� LS� | GPS 8-243"
    elseif str:find("������ ��� ������") then
      return "������ ��� ������? ������� ����� � �C��������e LS� | GPS 8-243"
    elseif str:find("������� ����� � ���") then
      return "������� ����� � ���! ������ � �C��������e LS� | GPS 8-243"
    elseif str:find("������ [��]������ [��]�����") then
      return "������ ������� ������? ���� � ������ ���������� LS�. Price 18-3-1"
    elseif str:find("������ [��]������ [��]�����") then
      return "������ ������� ������? ���� � ������ ���������� LS�. Price 18-3-1"
    elseif str:find("������ [��]������ [��]������") then
      return "������ ������� �������? ���� ����: ����������� LS� | Price 18-3-1"
    elseif str:find("���� ������� ������") then
      return "���� ������� ������ � ����������� LS� | Price 18-3-1"
    elseif str:find("������ ��� ������ ��������") then
      return "������� ���������� - ������ ��� ������ ��������! | GPS: ���� LS."
    end

    
    
  elseif str:find("[Pp]rice%s?18%p3%p2") or str:find("%s?8%s?%p%s?244") or str:find("[��]��������[��]") and str:find("SF") or str:find("[��]�� [��]�����") then 
    if str:find("[��]����� ������") then
      return "����� ���? ������ ������! ���������� SF ���� ���! | GPS 8-244"
    elseif str:find("������� ������") then
      return "������ ���� ������� ������? ����� ���� � ���! | GPS 8-244"
    elseif str:find("������� ����[��] �����") then
      return "� ������ ���������� �Ի ������� ����� �����! �������! | GPS 8-244"
    elseif str:find("������� ������� ������") then
      return "� ������� ���������� �Ի ������� ������� ������! | GPS 8-244"
    elseif str:find("[��]�����[�]?� [��]����") then
      return "�������� ������ ���������� � San Fierro | �� �� Price 18-3-2"
    elseif str:find("[��]������� [��]����") then
      return "�������� ������ ���������� � San Fierro | �� �� Price 18-3-2"
    elseif str:find("���� 72") then
      return "� ������� ���������� � SF ���� - 72$! | �� �� Price 18-3-2"
    elseif str:find("���� � ����� ����������") then
      return "���� � ������ ���������� � San Fiero - 72$ | �� �� Price 18-3-2"
    elseif str:find("������ ������ ���������� �") then
      return "������ ������ � ������� ���������� SF! ��� ���! | Price 18-3-2"
    end

  elseif str:find("[Pp]rice%s?20%p3") then -- or str:find("%s?8%s?%p%s?244") or str:find("[��]���������") and str:find("SF") then 
    if str:find("������%p%s?") then
      return "��������, ������� ������� � �������������� ���� LV� | Price 20-3"
    elseif str:find("������ �������������") then
      return "������ �������������? ���� � ���-�������� �������! | Price 20-3"
    elseif str:find("������ �������� �� �����") then
      return "������ �������� �� ����� ����? ���� � ����. ���� LV� | Price 20-3"
    elseif str:find("�� PinkiWay") then
      return "������ �������� �� PinkiWay? ���� � ����. ���� LV� | Price 20-3"
    end

  elseif str:find("������ �Biffin%pBridge� & �San%pFierro�") then
    return "VIP-������ � ������ �Biffin-Bridge� & �San-Fierro�, "..get_hotel_price(str).."$/�����!"
  elseif (str:find("[��Hh][�o][�t][e�][l��]") or str:find("[��]�����")) and str:find("[��]����") then -- LS | � ��������� ������ ���� ��������� ������! �� �������� GPS: 7>19
    if str:find("233") then
      biz_loc = "GPS 8-233"
    else
      biz_loc = "Price 9-9"
    end
    if str:find("���� ��������� ������") then
      return "� ��������� ������ ���� ��������� ������! | "..biz_loc
    elseif str:find("��������� ������ � ������ ����") then
      return "��������� ������ � ������ ���� � ���������� ����� LV� | "..biz_loc
    elseif str:find("��������� VIP%p������ �� 16 �����") then
      return "��������� VIP-������ �� 16 ����� � ���������� �����! | "..biz_loc
    elseif str:find("��������� VIP%p������") then
      return "��������� VIP-������ � ���������� ����� LV�. | "..biz_loc
    elseif str:find("��������� � ������ VIP%p������") then
      return "��������� � ������ VIP-������ � ���������� ����� LV�. | "..biz_loc
    elseif str:find("������ �� 16 �����") then
      return "������ VIP-������ �� 16 ����� � ���������� ����� LV�. | "..biz_loc
    elseif str:find("����� ������ VIP ������") then
      return "����� ������ VIP ������ ������ � ��������� ���������. | "..biz_loc
    elseif str:find("������ VIP ������") then
      return "������ VIP ������ ������ � ��������� ���������. | "..biz_loc
    
    end
  elseif str:find("[��Hh][�o][�t][e�][l��]") and str:find("�����") or str:find("[Oo]cean") or str:find("�����") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 9-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-54"
    end
    debug("OKEAN BLA"..str, 1)
    if str:find("[��]�����") then
      return "������ ���������� �Ocean� � �. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("���������") then
      return "����� ��������� ����� �1 � �.Los-Santos ������ | "..biz_loc
    elseif str:find("��������") then
      return "����� ������ ���� ����� ��������! "..get_hotel_price(str).."$/����� | "..biz_loc
    elseif str:find("���������� � �����") then
      return "���������� � ����� ������ ����� ���� "..get_hotel_price(str).."$/����� | ���� � "..biz_loc
    elseif str:find("������a ��� ����") then
      return "��������� ������ ������a ��� ����. ���������� "..get_hotel_price(str).."$/����� "..biz_loc
    elseif str:find("��� � Hotel") then
      return "��������� VIP-������ � �Ocean Hotel� LS - "..get_hotel_price(str).."$/����! | "..biz_loc
    elseif str:find("����� ��������") then
      return "����� �������� �VIP� ������ � ��������� ������! | "..biz_loc
    end
  elseif str:find("�����") then
    return "��������� ���������� ���� � ����. ������� LS/LV� | GPS 8-271/272"
  elseif str:find("[��][��]�") and str:find("[Ll��][Ss��]") and str:find("[Ll��][Vv��]") then
    if str:find("��������") then
      return "��������� ���������� ���� � ����. ������� LS & LV�. GPS 8-271/272"
    elseif str:find("������") then
      return "���� ���������� ���� � �������� ������� LS & LV�. GPS 8-271/272"
    end
    return "����������� ���� � �������� ������� LS & LV�. GPS 8-271/272"
  elseif str:find("������� �������") or str:find("GPS [78]%p27[12]%p27[21]%p99") then
    if str:find("������ [��]��") then
      return "���������� ���� �� 12.500$ � �������� ��������. GPS 8-271/272/99"
    elseif str:find("������ [��]��") then
      return "���������� ���� - 12.500$ � �������� ��������. GPS 8-271/272/99"
    elseif str:find("��������� ��������") then
      return "��������� �������� �� 270$ � �������� ��������. GPS 8-271/272/99"
    elseif str:find("�� ��� ��������� ����") then
      return "��� ��� ��������� ���� � �������� ��������. GPS 8-271/272/99"
    elseif str:find("����������� ����") then
      return "����������� ���� � �������� ��������. GPS 8-271/272/99"
    elseif str:find("��� ������ ������� �") then
      return "��� ��� ������ ������� � �������� ��������. GPS 8-271/272/99"
    elseif str:find("[��]��������� ������") then
      return "���������� ������ � �������� ��������. GPS 8-271/272/99"
    elseif str:find("[��]����� ��� ����������") then
      return "������ ��� ����������. ���� � �������� ��������. GPS 8-271/272/99"
    elseif str:find("[��]�������� �������� ��") then
      return "��������� �������� �� 270$ � �������� ��������. GPS 8-271/272/99"
    elseif str:find("��� ��� ������ �������") then
      return "��� ��� ������ ������� � �������� ��������. GPS 8-271/272/99"
    elseif str:find("� ���������� ����") then
      return "���� ���������� ���� � �������� ��������. GPS 8-271/272/99"
    elseif str:find("� ���������� ������") then
      return "���� ���������� ������ � �������� ��������. GPS 8-271/272/99"
    elseif str:find("��������� [��]�����") then
      return "����� ��������� ������ � ���. ����� ��� � ����. GPS 8-271/272/99"
    elseif str:find("[��]����� ��� ����") then
      return "���� ������ ��� ���� � �������� ��������. GPS 8-271/272/99"
    elseif str:find("������� ����[��]����") then
      return "������� ��������� ����������� ������ � ����. GPS 8-271/272/99"
    elseif str:find("���� �� �������� ������") then
      return "���� �� �������� ������ � ��������� ��������. GPS 8-271/272/99"
    elseif str:find("���� �� ��������� ������") then
      return "���� �� ��������� ������ c ��������� ��������. GPS 8-271/272/99"
    elseif str:find("�[��]���� ��������� ������") then
      return "˸���� ��������� ������ c ��������� ��������. GPS 8-271/272/99"
    elseif str:find("���� ������� � ���������") then
      return "���� ������� � ��������� c ��������� ��������. GPS 8-271/272/99"
    elseif str:find("���� �������,%s?�����[��]�[��](.+)�") then
      return "���� �������, ����������� � ��������� ��������. GPS 8-271/272/99"
    elseif str:find("����������� ������ �") then
      return "����������� ������ � ��������� ��������! | GPS 8-271/272/99"
    elseif str:find("����������� �� �����[��]��") then
      return "����������� �� �������� � ��������� ��������. GPS 8-271/272/99"
    elseif str:find("����� � ������ ������") then
      return "����� � ������ ������ � ��������� ��������. GPS 8-271/272/99"
    elseif str:find("������ ����� ��������") then
      return "������ ����� �������� � ��� � �������� ��������. GPS 8-271/272/99"
    end
  elseif str:find("[Aa]ttica") then
    return "������ � \"Attica Bar\". � ��� ������� �������! �� �� GPS 8-65"
  elseif str:find("[Dd][Ss]") and str:find("[��][��][��][��]") then
    if str:find("�������") then
      return "������� ������ �� ������� ������ � �DS� ����. GPS 8-39"
    elseif str:find("������� ������ ������") then
      return "������� ������ ������ � �DS� ����. GPS 8-39. ������!"
    elseif str:find("�� ������ LUX") then
      return "������ �� ������ LUX � �DS ���ѻ | GPS 8-39"
    elseif str:find("������ �� lux") then
      return "������ �� LUX-������ � �DS ���ѻ | GPS: 8-39"
    end
    
  elseif str:find("GPS 8 > 10 �����") then
    return "� �������� �Spacey� �����! 10-� ������ ������� 100.000$. GPS 8-10"
  elseif str:find("[Ss]pacey") then
    if str:find("�������") then --str:find("[Bb][Mm][Ww]") then
      return "� ������� ������� �Spacey� ������� ����� ������� | �� � GPS 8-10"
    elseif str:find("�[�]?����� ���%s?[������]? ����") then
      if str:find("������[��]���") then
        return "���� ���������� ������� ��� ���� � �Spacey� | �� � GPS 8-10"
      end
      return "���� ������� ��� ������ ���� � �������� ������� �Spacey� GPS 8-10"
    elseif str:find("BMW") then
      return "� ������� ������� �Spacey� ������� ���� �BMW M5� | �� � GPS 8-10"
    elseif str:find("�������") then
      return "� ������� ������� �Spacey� ������� ����� ������� | �� � GPS 8-10"
    elseif str:find("��������") then
      return "� �������� �Spacey� �����! 10-� ������ ������� 100.000$. GPS 8-10"
    elseif str:find("������ ������") then
      return "������ ������? ���� �RC Baron� � �������� �Spacey�! GPS 8-10"
    elseif str:find("������� ������� ������") then
      return "������� ������� ��������� �� �������� ������� �Spacey�! GPS 8-10"
    elseif str:find("�����") then
      if str:find("[��][��][��]") or str:find("[��]���") then
        return "������ ������� ������� �Spacey� � �������� LS. "..get_price(str, trade_type(str))
      end
      return "������ ������� ������� �Spacey� GPS 8-10. "..get_price(str, trade_type(str))
    end
    
  elseif str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4") or str:find("8%s?%p?%s?270$") or str:find("[��]�����(.-) [��]����") or str:find("������ ������ � ��") or str:find("����� �����[�]? ������") or str:find("���������� ������") or str:find("[��]����� �� ������") then
    --debug("+", 5)
    if str:find("[Pp]rice") then
      biz_loc = "Price 9-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-270"
    end
    if str:find("[��]�����") then
      return "������ ������ ��������� ����� � �. San Fierro. "..get_price(str, trade_type(str))
    elseif str:find("���� ������ ��������") then
      return "������ ���� ������ �������� �����? ����� ���� � ���! "..biz_loc
    elseif str:find("������ ���� ��") then
      return "����� ������ ���� �� �������� ����� ������ � ���! "..biz_loc
    elseif str:find("������ ������ � ��") then
      return "����� ���������� ������ ������ � ��������� ������ SF�. "..biz_loc
    elseif str:find("���� ���������� ������") then
      return "������ ���� ���������� ������! ����� �� 3000$. | "..biz_loc
    elseif str:find("���������� ������") then
      return "������� ���������� ������ � San Fierro! | "..biz_loc
    elseif str:find("�� ������ ����� ��") then
      return "����� ������ �� ������ ����� �� 3000$? | ������ � "..biz_loc
    elseif str:find("������ �� ������������� �����") then
      return "������ �� ������������� ����� � Price 11-4. ���� - 0$!"
    elseif str:find("�������� ����� ���") then
      return "�������� ����� ��� �������� � ��������� ������ SF�. | "..biz_loc
    elseif str:find("A��������� ���� �� ������") then
      return "A��������� ���� �� ������ � ��������� ������ SF�. | "..biz_loc
    elseif str:find("������� ������") then
      return "������� ������ �� ���� � ��������� ������ SF�. | "..biz_loc
    elseif str:find("������ �������� ����� �") then
      return "������ �������� ����� � ��������� ������ SF�. | "..biz_loc
    elseif str:find("����� ����� ��� �������") then
      return "����� ����� ��� �������! ��������� ����� SF�. | "..biz_loc
    elseif str:find("����� �����[�]? ������?") then
      if str:find("�����") then
        return "������ ������ ������? ���� � �������� ����� SF! �� ����� � ������� SF"
      end
      return "������ ������ ������? 3000$ � ��� ����! | "..biz_loc
    end  
  elseif str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4") or str:find("8%s?%p?%s?197") or str:find("[��]�����(.-) [��]����") or str:find("������ ������ � ��") then
    --debug("+", 5)
    if str:find("[Pp]rice") then
      biz_loc = "Price 11-3"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-197"
    end
    if str:find("[��]�����") then
      return "������ ������ ��������� ����� � �. Las Venturas. "..get_price(str, trade_type(str))
    elseif str:find("�����[�]?���� ���������� ����� �� ��� ����") then
      return "��������� ���������� ������ �� ��� ����������! | "..biz_loc
    elseif str:find("[��]�������� ���������� ����� �� ��� ����") then
      return "��������� ���������� ������ �� ��� ����������! | "..biz_loc
    elseif str:find("������� ������ �����") then
      return "������ ������� ������? ����� ���� � "..biz_loc.."! ������� ������!"
    end  
  elseif str:find("[Pp]rice") and str:find("%s?11%s?%p%s?4222") or str:find("8%s?%p?%s?192") then
    --debug("+", 5)
    if str:find("[Pp]rice") then
      biz_loc = "Price 11-3"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-192"
    end
    if str:find("[��]�����") then
      return "������ ��� �The Crew Bar� � �. Las Venturas. "..get_price(str, trade_type(str))
    elseif str:find("������� ������") then
      return "�������, ������� ������ � ��� - �The Crew Bar� | "..biz_loc

    end  
  elseif str:find("[��]�����������[���][���] [�L][V�]") and str:find("%s?8%s?%p%s?235") then 
    if str:find("������ .+ �������") then
      return "������ ������� ����������? ���� � ��������������� LV� | GPS 8-235"
    elseif str:find("������ ��[��]������") then
      return "������ ��������� ������ ���� � ��������������� LV� | GPS 8-235"
    end
    
  elseif str:find("%s?1%s?%p%s?18") then
    if str:find("�������� ���� ����") then
      return "�������� ���� ���� � ��� �����������. ���� ����������! | GPS 1-18"
    elseif str:find("������� ������ ���������") then
      return "������� ������ ��������� ���� � ��������������� LV. | GPS 1-18"
    elseif str:find("����� �������� �� �����") then
      return "����� �������� �� ����� ����� � ��������������� LV. | GPS 1-18"
    elseif str:find("������ ������ ��������") then
      return "������ ������ ��������? ������� � ���������������� LV. | GPS 1-18"
    end
  elseif str:find("�������������� � ������� ��") then
    -- �������� ���� Clover � �������������� � ������� ��. ���� ���
    if str:find("�������� ���� Clover") then
      return "�������� ���� Clover � ��������������� � ������� LV. ���� ���!"
    end
  elseif str:find("%s?5%s?%p%s?6") or str:find("%s?8%s?%p%s?433333") then
    if str:find("[Pp]rice") then
      biz_loc = "Price 5-6"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-43"
    end
    if str:find("������ ����") then
      return "� �������� ������ �Sub Urban� � LS ������ ���� | "..biz_loc
    elseif str:find("������� ������� ����������") then
      return "������� ������� ���������� � �Sex Shop �2� �� ��� | "..biz_loc
    end
  elseif str:find("%s?10%s?%p%s?4") then
    if str:find("������� � ����") then
      return "������� � ����-������� � ����������� � �Sex Shop SF� | Price 10-4"
    end
    
  elseif str:find("%s?8%s?%p%s?283") then
    if str:find("������ ���� � ����") then
      return "������ ���� � ����? ������� �Awayuki Holding�! GPS 8-283"
    -- elseif str:find("������� ������� ����������") then
    --   return "������� ������� ���������� � �Sex Shop �2� �� ��� | Price 10-2"

    end
  elseif str:find("nvestical") and str:find("roup") then
    return "�������� �Investical Group� ���� ����� ����������� | GPS 4-7"
  elseif str:find("[(PRICE)|(Price)|(price)]%s8%s?%p%s?5") then
    -- debug("ZERO", 2)
    if str:find("%s?8%s?%p%s?5[(%p)|($)]") then
      biz_loc = "Price 8-5"
    end
    if str:find("������ ������� �������") then
      return "Zero RC - ������ ������� ������� � ��! | �� � "..biz_loc
    elseif str:find("���� ���������������� ������� � ����� �����") then
      return "���� ���������������� ������� � ����� �����! Zero RC - "..biz_loc
    end
  elseif str:find("[(PRICE)|(Price)|(price)]%s8%s?%p%s?2") then
    -- debug("ZERO", 2)
    if str:find("[Pp]rice") then
      biz_loc = "Price 8-2"
    -- elseif str:find("[Gg][Pp][Ss]") then
    --   biz_loc = "GPS 8-118"
    end
    if str:find("������ ����") then
      return "������ ����? ����� ���� � ������� ������� �Toy Corner�. "..biz_loc
    end
  -- elseif str:find("����") and str:find("����") then
  --   if str:find("[��][��][��]") then
  --     return "������ ����? ���� ��� � ��������� ������� �� ��� | GPS 8-10"
  --   end
    -- Zero RC - ������ ������� ������� � ��! �� � PRICE 8-5!
  elseif str:find("[Vv]isage") or str:find("VISAGE") then
    if str:find("�������� VIP") then
      return "� ����� �Visage� �������� VIP ������. ����: "..get_hotel_price(str).."$/�. | GPS 8-232"
    elseif str:find("�����") then
      return "� ����� �Visage� ��������������� ���� �� ����� - "..get_hotel_price(str).."$ | GPS 8-232"
    elseif str:find("���� ����� ��� ���� ����") then
      return "���� ����� ��� ���� ����! ����-����. �������� Visage. | GPS 8-232"
    elseif str:find("������� VIP ������") then
      return "������� VIP ������ �� "..get_hotel_price(str).."$ � ����� | ����� VISAGE | GPS 8-232"
    elseif str:find("���� VIP �����") and not str:find("�����") then
      return "���� VIP ����� ��� ���� ����! ����. �������� Visage | GPS 8-232"
    elseif str:find("Hotel Visage") and str:find("%p�����") then
      return "���� VIP ����� ���� ����! "..get_hotel_price(str).."$/�����. Hotel Visage | GPS 8-232"
    elseif str:find("����� Visage") and str:find("%p�����") then
      return "���� VIP ����� ���� ����! "..get_hotel_price(str).."$/�����. ����� Visage | GPS 8-232"
    elseif str:find("������ VISAGE�") and str:find("%p�����") then
      return "���� VIP ����� ���� ����! "..get_hotel_price(str).."$/�����. ������ VISAGE� | GPS 8-232"
    elseif str:find("������ VIP ������") then
      return "������ VIP ������ �� "..get_hotel_price(str).."$ ������ � ����� VISAGE | GPS 8-232"
    end
  elseif str:find("[Pp]rice%s%p?%s?9%s?%p%s?3") or str:find("%s?8%s?%p%s?118")  then
    if str:find("[Pp]rice") then
      biz_loc = "Price 9-2"
    elseif str:find("[Gg][Pp][Ss]") then
      biz_loc = "GPS 8-118"
    end
    if str:find("�������") then
      return "����� ����-������ - ������� ���� � ���� ��������� | "..biz_loc
    elseif str:find("���������� ������") then
      return "� ����� ����-������ ���������� ������ - 333$/����� | "..biz_loc
    elseif str:find("[��]����� ������ ���� ����") then
      return "������ ������ ���� ���� � ����� ����-������ | "..biz_loc
    elseif str:find("��������� ������ �����") then
      return "��������� ������ ����� �� 350$ � ����� ����-������ | "..biz_loc
    elseif str:find("������������� LUXE") then
      return "������������� LUXE-����� � ����� �San Fierro� �� "..get_hotel_price(str).."$ | "..biz_loc
    elseif str:find("������ ��") then
      return "������ �� "..get_hotel_price(str).."$ ������ � ������ San Fierro� | "..biz_loc
    else
      return "� ����� ����-������ ������ �� "..get_hotel_price(str).."$/�����. ��� ���� | "..biz_loc
    end
  elseif str:find("[Pp]rice%s8%s?%p%s?3$") or str:find("lexande") and str:find("[Tt]oys") then
    if str:find("��������������� ��������") then
      return "���� ���������������� �������� � �Alexander's Toys� | Price 8-3"
    elseif str:find("BMW") then
      return "������� �Alexander's Toys� ������� ���� �BMW M5� | Price 8-3"
    elseif str:find("������?") then
      return "���� ������? ����-������� � ��lexanders Toys� | Price 8-3"
    elseif str:find("����� ������ ���� �� �������") then
      return "����� ������ ���� �� ������� � ��lexanders Toys� | Price 8-3"
    elseif str:find("����� �� ��������") then
      return "����� �� ��������, ����� �� ����� � �����. ������� ��! Price 8-3"

    end
    
  elseif str:find("Binco %p?Grove%p?") or str:find("8%s?%p?%s?6%p?$") and str:find("[Gg][Pp][Ss]") then
    if str:find("����� ������� ���������") then
      return "����� ������� ��������� ������ ������ � �Binco Grove�. | GPS 8-6"
    elseif str:find("�������� ������") then
      return "��������� ������ �� 7.000$ � �������� �Binco Grove�. �� � GPS 8-6"
    elseif str:find("������ �� ��������� ������") then
      return "������ �� ��������� ������ � �������� �Binco Grove LS� | GPS 8-6"
    elseif str:find("�������� �������� � ��������") then
      return "�������� �������� � �������� ������ �Binco Grove LS� | GPS 8-6"
    elseif str:find("���[��][��] ������ ����") then
      return "����� ������ ���� �� ��������� ������ � �Binco Grove LS�. GPS 8-6"
    elseif str:find("������������ ��������") then
      return "������ ������������ �������� � �Binco Grove� | GPS 8-6"
    elseif str:find("������� ������ �� ������") then
      return "������� ������ �� ������ ������ � �Binco Grove� | GPS 8-6"
    elseif str:find("������� ������ �� �����") then
      return "������� ������ �� ����� ������ � �Binco Grove� | GPS 8-6"
    elseif str:find("Rollerskater") then
      return "������ �Rollerskater� ����� �� 500.000$ � �Binco Grove� | GPS 8-6"
    elseif str:find("�������� ������ �Binco�") then
      return "������ �� 7.500$ � �������� ������ �Binco�! | GPS 8-6"
    elseif str:find("� �Binco� � �������") then
      return "� �Binco� � ������� ������ ������ ���� �� ������! | GPS 8-6"
    elseif str:find("������ ���� ������ �����") then
      return "������ ���� ������ �����? �Binco Grove� ���� � �������! | GPS 8-6"
    end
  elseif str:find("8%s?%p?%s?69$") and str:find("[Gg][Pp][Ss]") then
    if str:find("������ ����� �������") then
      return "������ ����� �������? ���� � ��� ����� ��� �������!  | GPS 8-69"
    elseif str:find("�������� ������") then
      return "��������� ������ �� 7.000$ � �������� �Binco Grove�. �� � GPS 8-6"
    end
    
  elseif str:find("8%s?%p?%s?79[($)|(!)]") and str:find("[Gg][Pp][Ss]") then

    if str:find("������������ ���������") then
      return "����� ������������ ��������� ������������ � Sub Urban. GPS 8-79"
    elseif str:find("������� �����") then
      return "������ ������� ����� �������? ������ � Sub Urban. GPS 8-79"
    elseif str:find("������ � �����") then
      return "Sub Urban - ����� ��� ������ � �����! GPS 8-79"
    elseif str:find("���������� � �����") then
      return "Sub Urban - ���������� � �����! GPS 8-79"
    elseif str:find("���������� ����� ���") then
      return "Sub Urban - ���������� ����� ��� ��������� �����! GPS 8-79"
    elseif str:find("������ �������") then
      return "������ �������! ������ �� ������ � Sub Urban. GPS 8-79"
    elseif str:find("[��]�����") then
      return "������ �Sub Urban� � �. Los Santos �� GPS 8-79. "..get_price(str, trade_type(str))
    elseif str:find("������� ������") then
      return "������� ������ �� ������ �� ���������. GPS 8-79"
    elseif str:find("��������� ������") then
      return "��������� ������ � �Sub Urban�. ����� ��� ����! | GPS 8-79"
    elseif str:find("�������� ���� ��������") then
      return "�������� ���� �������� � �������� �Sub Urban� � LS. | GPS 8-79"
    elseif str:find("������ ����� ��") then
      return "������ ����� �� 7.000$ � �������� �Sub Urban� � LS. | GPS 8-79"
    end
  -- elseif str:find("Sub Urban") or str:find("5%s?%p?%s?16[($)|(!)]") and str:find("[Pp]rice") then
  --   if str:find("������ ���� � ��������") then
  --     return "������ ���� � �������� ������ Sub Urban �Palomino� | Price 5-16"
  --   elseif str:find("������� �����") then
  --     return "������ ������� ����� �������? ������ � Sub Urban. GPS 8-79"
  --   end
    
  elseif str:find("8%s?%p?%s?111") and str:find("[Gg][Pp][Ss]") then
    if str:find("�������� ������") then
      return "�������� ������ �� 7.000$ � �Binco� �.San Fierro | ���� � GPS 8-111"
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?149") then
    if str:find("�������� � Fort") then
      return "�������� � Fort Carson - �������� ���� � ������������! GPS 8-149"
    end
  elseif str:find("8%s?%p?%s?14") and str:find("[Gg����][��]?[Pp��][Ss��]") or str:find("[��]��������") then
    if str:find("����� ���[�]��� ������") or str:find("����� ������%s?� ������") then
      return "����� ������� ������ � �������� �DS� | �� � GPS 8-14"
    elseif str:find("�����[�]?����� ���� �������") and not str:find("[��]��������") then
      return "���������� ���� ������� � ������ �������� �DS� | GPS 8-14"
    elseif str:find("Tv [��]���� ���[��]��� ������") then
      return "����� ������� ������ � ����� ���������� �������� �DS� | GPS 8-14"
    elseif str:find("���������� ���� �������") then
      return "���������� ���� ������� � ������ �� �DS�. ���������: GPS 8-14"
    elseif str:find("���������� ����� �") then
      return "���������� ����� � ������ �� �DS�. ���������: GPS 8-14"
    elseif str:find("[��]����� �������� � ��������") then
      return "������ �������� � �������� �DS� � Los-Santos | GPS 8-14"
    end
    
  elseif str:find("[��]��������") and str:find("%s8%s?%p?%s?247") or str:find("%s8%s?%p?%s?273") then
    if str:find("%s?8%s?%p%s?247") then
      biz_loc = "�� � GPS 8-247"
    elseif str:find("%s?8%s?%p%s?273") or str:find("GPS 8 273") then
      biz_loc = "GPS 8-273"
    end
    if str:find("C��������%s?%s������� � ���������") then
      return "C�������� ������� � ���������� �. San Fierro! | "..biz_loc
    elseif str:find("[��]������ �� ���.���������") then
      return "������� �� ���.��������� � ���������� � SFFM! | "..biz_loc
    elseif str:find("����� 20 ��������� ��������") then
      return "����� 20 ��������� �������� � ���������� San-Fierro! | "..biz_loc
    elseif str:find("� ��������� ����� 20") then
      return "� ���������� San Fierro ����� 20 ��������� �������� | "..biz_loc
    elseif str:find("��������� ��������� �������") then
      return "� ���������� San-Fierro ��������� ��������� ������� | "..biz_loc
    elseif str:find("[��]����� ���� ��������� �������") then
      return "������ ���� ��������� ������� � ���������� San Fierro | "..biz_loc
    elseif str:find("[��]�������� ��������� �������") then
      return "��������� ��������� ������� � ���������� San Fierro | "..biz_loc
    elseif str:find("������ ������ ���������� ������") then
      return "������ ������ ���������� ������? ���� � ���������� San Fierro | "..biz_loc
    elseif str:find("���� ������� �� ����") then
      return "���� ������� � ���������� SF � ����� ������������! | "..biz_loc
    elseif str:find("������ ��������� �������? ���� � �") then
      return "������ ��������� �������? ���� � ��� � ���������� SF | "..biz_loc
    elseif str:find("������ ������ ���������") then
      return "������ ������ ��������� �������? ���� ��� � ���! | "..biz_loc
    elseif str:find("������� ���") then
      return "������ ��������� �������? ������� ���: "..biz_loc
    end
    
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?247") then
    if str:find("[��]������� ���������") then
      return "C������� ��� ��������� �� ����� �������� ����� �� 699$! GPS 8-247"
    elseif str:find("[��]������� ����������,�") then
      return "�������� ������ ���������� ����� �� 699$! | �� � GPS 8-247"
    elseif str:find("���� �� ����� ��������") then
      return "������ ���� ���� �� ����� �������� ����� �� 699$ | GPS 8-247"
    elseif str:find("���� ���� ��������") then
      return "���� ���� �������� � ��������� SF�, ���� 699$/1�! GPS 8-247"
    elseif str:find("�������� ���������� San Fierro") then
      return "�������� ���������� San Fierro, ���� 1-�� ��� �� 699$! | GPS 8-247"
    elseif str:find("������ �������") then
      return "������ ������� ��� ���������, ���� 1-�� ��� �� 699$ | GPS 8-247"
    elseif str:find("������� ��������") then
      return "������� �������� ��� ���������, ���� 1-�� ��� �� 699$! GPS 8-247"
    elseif str:find("�������� �������") then
      return "�������� ������� ��� ��������� �� ����� ��������! | GPS 8-247"
    elseif str:find("��������%p��� ���������%p") then
      return "�������� ��� ��������� �� ����� ��������! | GPS 8-247"
    elseif str:find("�������� ���������� SF, ���� ") then
      return "�������� ���������� SF, ���� 1-�� ��� 1500$ | GPS 8-247"
    end
  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?246") then
    return "������ ���� �������� � ��������� ���������� LS�. | GPS 8-246"
  elseif not str:find("[��]�����") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?144") then
    if str:find("���������� �� ����� �o�����") then
      return "����� ���������� �� ����� �������, ���� � ����! ������: GPS 8-144"
    end
  

  elseif str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p?%s?267") then
    if str:find("������ ���� ����������") then
      return "������ ���� ����������? ���� � ���������� ������� LV� | GPS 8-267"
    end

  -- elseif not str:find("����") and not str:find("[��]��") and not str:find("[��]��%s?�����") and not str:find("[��]�[�]?���") and str:find("[(�����)|(Binco)|(Bicno)]") and str:find("[(��)|(LV)|(��)]") or str:find("%p?%s?8%s?%p%s?162") then
  --   if str:find("������� ������") then
  --     return "����� ������� ������ � �Binco� ����� �������� �. LV | GPS 3-14"
  --   elseif str:find("��� ������� ������") then
  --     return "Cash-back ��� ������� ������ � Binco ����� �������� �.LV | GPS 3-14"
  --   elseif str:find("����� ������") then
  --     return "������ ������� ����� ������ � Binco � �������� �. LV | GPS 3-14"
  --   elseif str:find("�������� ������ ��") then
  --     return "�������� ������ �� 7.000$ � �������� �Binco� � ���. | GPS 8-162"
  --   elseif str:find("�������� �������� � ��������") then
  --     return "�������� �������� � �������� ������ �Binco� � ���. | GPS 8-162"
      
  --   end

  elseif str:find("Binco") and str:find("%p?%s?8%s?%p%s?122") then
    if str:find("������� ������") then
      return "����� ������� ������ � �Binco� | GPS 8-122"
    elseif str:find("�� ������� � �������� ������") then
      return "������ Cash-Back �� ������� � �������� ������ �Binco� | GPS 8-122"
    elseif str:find("����� ������") then
      return "������ ������� ����� ������ � Binco | GPS 8-122"
    elseif str:find("�������� ������ ��") then
      return "�������� ������ �� 7.000$ � �������� �Binco�. | GPS 8-122"
    elseif str:find("�������� �������� � ��������") then
      return "�������� �������� � �������� ������ �Binco�. | GPS 8-122"
    end

  elseif str:find("Binco � Blueberry") or str:find("Binco Blueberry") then -- �������� ����� � �������� � �������� ������ Binco � Blueberry.
    if str:find("�������� ����� � ��������") then
      return "�������� ����� � �������� � �������� ������ �Binco� � Blueberry."
    elseif str:find("������ �� ��� ������") then
      return "������ �� ��� ������ � Binco Blueberry, �������! �� �� �������!"
    end
  elseif str:find("����") and str:find("%p?%s?8%s?%p%s?267") or str:find("[Gg][Pp][Ss]%s?%p?%s?267") then
    if str:find("����������� � ���") then
      return "����������� � ���? ���� ������ � ������ � ����� LV�! | GPS - 267"
    elseif str:find("����������� � ��") then
      return "����������� � ��? ���� ������ � ������ � ����� �»! | GPS - 267"
    end

  elseif str:find("[��]������") and str:find("%p?%s?8%s?%p%s?122") then
    if str:find("�������� ������ �������") then
      return "�������� ������ ������� � ����� � ���! �� �������� GPS 8-122"
    end

  elseif not str:find("�������� ������") and str:find("[Bb]i[cn][cn]o") and str:find("[��][��][��][��]") or str:find("Binco%sLV") then
    
    if str:find("�� ������� ������") then
      return "������ Cash-Back �� ������� ������ � �Binco� ����! GPS 8-180"
    elseif str:find("������ ���� �� ��������� ���") then
      return "����� ������ ���� �� ��������� ��� � Binco � ����. GPS 8-180"
    elseif str:find("��������� ������") then
      return "����� ������ ���� �� ��������� ������ � Binco � ����. GPS 8-180"
    elseif str:find("�������, �����, ��������") then
      return "�������, �����, �������� - ������ �Binco LV� | �� � GPS 8-180"
    elseif str:find("������ �� ����� ����") then
      return "������ �� ����� ���� � �Binco ���» | �� � GPS 8-180"
    end
    
  elseif str:find("[Pp]ro[Ll]aps") and str:find("[Gg][Pp][Ss]") and str:find("3%s?%p?%s?10") then
    if str:find("�������� ������ ProLaps") then
      return "� �������� ������ �ProLaps� � �. Bayside ������ | GPS 3-10"
    elseif str:find("������� �� 7000") then
      return "������� �� 7000$ � �������� �ProLaps� � �. Bayside! �� � GPS 3-10"
    end

  elseif str:find("[Pp]ro[Ll]aps") and str:find("[Pp]rice %p?%p? 5") then
    if str:find("����� ������ �") then
      return "������ ������ � �������� ������ �ProLaps� � ��� | Price 5-1-11"
    elseif str:find("������� �� 7000") then
      return "������� �� 7000$ � �������� �ProLaps� � �. Bayside! �� � GPS 3-10"
    end
    
    --� �������� ������ ProLaps ��� � ��� ��������� ������ gps 3-10
  elseif str:find("Mad Dogs") and str:find("%s8%s?%p%s?153%p?%s?") then
    if str:find("[��]������ � ����� �����") then
      return "������ ��� �Mad Dogs MC�! ������� � ����� �����! | GPS 8-153"
    elseif str:find("�������� ����") then
      return "�������� ���� � ��������� � �. Fort Carson. | �� � GPS 8-153"
    end
  elseif str:find("[��]�����") and str:find("[��]���") and str:find("%s8%s?%p%s?154%p?%s?") then
    if str:find("[��]������� �") then
      return "�������� � ��������� � �. Fort Carson. | �� � GPS 8-154"
    elseif str:find("�������� ����") then
      return "�������� ���� � ��������� � �. Fort Carson. | �� � GPS 8-154"
    end
  elseif str:find("[Vv][Ii][Cc][Tt][Ii][Mm]") and str:find("[Gg��][Pp��][Ss��]") and str:find("%s8%s?%p%s?15%p?%s?") then
    if str:find("������ ������ ������ � ����") then
      return "������� ������ ������ � �������� �Victim� �. Los Santos | GPS 8-15"
    elseif str:find("�� ���� ��������[%s%p]��������") then
      return "�� ���� ��������, �������� � �������� �Victim� �.Los Santos | GPS 8-15"
    elseif str:find("������� ����������") then
      return "������ ������� ���������� � �������� �VICTIM� | GPS 8-15"
    elseif str:find("������� ������") then
      return "C������ �������� ������ � �������� �VICTIM�! ���� ���! | GPS 8-15"
    elseif str:find("����� ����� � ���������") then
      return "����� ����� � ��������� ������ �Victim� LS | GPS 8-15"
    elseif str:find("������� ������� �����") then
      return "������� ������� ����� � �������� ������ �Victim� LS. GPS 8-15"
    elseif str:find("����� ��������� ����") then
      return "����� ��������� ���� � �������� ������ �Victim� LS. GPS 8-15"
    end
    
  elseif str:find("%s?8%s?%p%s?177%p?%s?") then
    if str:find("������� ������ � ��������") then
      return "����� ������� ������ � �������� ������ �ZIP� � ����. | GPS 8-177"
    elseif str:find("�� 7%p000%$ �") then
      return "������ �� 7.000$ � �������� ������ �ZIP� � ����. | GPS 8-177"
    elseif str:find("�������� ������ ������") then
      return "�������� ������ ������ � �������� �ZIP LV�. | GPS 8-177"
    elseif str:find("�������� [��]�� ����������") then
      return "������ ������� �ZIP LV� �������� ��� ���������� ������! GPS 8-177"
    elseif str:find("��������� ���� � �������������") then
      return "��������� ���� � ������������� ������ � �ZIP LV� | GPS 8-177"
    elseif str:find("������� ������ �� ������") then
      return "������� ������ �� ������ ������ � �ZIP LV� | GPS 8-177"
    elseif str:find("����� ������� �������") then
      return "����� ������� ������� ������ ������ � �ZIP LV� | GPS 8-177"
    elseif str:find("������ ����") then
      return "������ ���� �� ������ � �������� �ZIP LV� | GPS 8-177"
    end
  
  elseif str:find("%s?8%s?%p%s?178%p?%s?") then
    if str:find("������� ������ � ��������") then
      return "����� ������� ������ � �������� ������ �ZIP� � ����. | GPS 8-178"
    elseif str:find("Rollerskater") and str:find("500") then
      return "������ �Rollerskater� �� 500.000$ ������ � �ZIP ���» | GPS 8-178"
    elseif str:find("������ �� ����� ������ ") then
      return "������ �� ����� ������ ����� ������ � �ZIP ���» | GPS 8-178"
    elseif str:find("��������� ������ �� 7") then
      return "��������� ������ �� 7.000$ ������ � �ZIP ���» | GPS 8-178"
    elseif str:find("�������� ������") then
      return "�������� ������ �� ������ ������ � �ZIP ���» | GPS 8-178"
    elseif str:find("������� ������") then
      return "������� ������ � �������� ������ �ZIP ���» | GPS 8-178"
    elseif str:find("������ � [��]�������") then
      return "������ � �������� ������ �ZIP� � ���� | GPS 8-178"
    elseif str:find("����� ������� �������") then
      return "����� ������� ������� ������ � �ZIP ���» | �� ����� � GPS 8-178"
    end
    

  elseif str:find("������ � �������� �����") and str:find("[Gg][Pp][Ss]") and str:find("%s4%s?%p%s?8%p?%s?") then
    return "������ ������ ������ � �������� �����. �� ����� � GPS 4-8"
    --- ����� ������ ���� � �������� ��������� "���������". GPS 8-189
  elseif not str:find("������") and  str:find("[��]��������") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p%s?189%p?%s?") then
    if str:find("[��][��]��� ������ ����") then
      return "����� ������ ���� � �������� ��������� ���������� | GPS 8-189"
    elseif str:find("������� �") then
      return "������� � ����������! ����� ������ ���� ���� ���� | GPS 8-189"
    end
  elseif str:find("%s?8%s?%p?%s?181") then
    if str:find("����� ������ ���� � �����") then
      return "����� ������ ���� � ����� � ����� �24/7� | GPS 8-181"
    elseif str:find("������� ������ �� ���") then
      return "������� ������ �� ��� � ���������� 24/7� � Yakuza | GPS 8-181"
    elseif str:find("������ �� ���") then
      return "������ �� ��� � �������� �24/7� � Yakuza | GPS 8-181"
    end
  
  elseif str:find("24%p7") or str:find("24%p7") or str:find("24%s7") or str:find("24%s?[��][��]%s?7") or str:find("�� � ��� [(����)|(LVPD)]") or str:find("98 ������") or str:find("[��]����������") or str:find("[��]����� �����") then
    -- debug("magaz", 3)
    
    if str:find("[��]�����") then
      
      if str:find("���[ -]��������") then
        return "������ ������ �24/7� � �. Las Venturas. "..get_price(str, trade_type(str))

      elseif str:find("[��]��[ -][��]�����") then
        if str:find("[��]��[�]?��") and str:find("[��Ll][��Oo]?[��Ss]") then
          return "������ ������ �24/7� �� ������ �. Los Santos. "..get_price(str, trade_type(str))
        end
        return "������ ������ �24/7� � �. Los Santos. "..get_price(str, trade_type(str))
      elseif str:find("[Dd]il[l]?i[o]?more") or str:find("[��]��������") then
        if str:find("[Gg][Pp][Ss]") then
          return "������ ������ �24/7� � �.Dillimore: GPS 8-230 | "..get_price(str, trade_type(str))
        end
        return "������ ������ �24/7� � �. Dillimore. "..get_price(str, trade_type(str))
      elseif str:find("[Bb]ayside") or str:find("[��][��][��]") then
        return "������ ������ �24/7� � �. Bayside � ���� ���. "..get_price(str, trade_type(str))
      elseif str:find("[��]����������") and str:find("[Ll��][Vv��]") then
        return "������ ������������"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("8%p160") then
        return "������ ������ �24/7� �� GPS 8-160. "..get_price(str, trade_type(str))
      else
        return "������ ������ �24/7�"..get_location(str)..". "..get_price(str, trade_type(str))
      end
    elseif str:find("[��]�[��]��") then
      return "����� ������ �24/7�"..get_location(str)..". "..get_price(str, trade_type(str))
    end
    
    if str:find("lvfm") or str:find("LVFM") or str:find("����") then

      if str:find("�������") then
        return "����� ������� ����� ���������� ����� � �24/7� � LVFM | GPS 8-178"
      elseif str:find("���") then
        return "����� ��� � ���������� ��������� �� �24/7� � LVFM | GPS 8-178"
      elseif str:find("%s�������%s���") then
        return "����� ������� ���-����� � �24/7� LVFM | GPS 8-178"
      elseif str:find("[Pp]ric[er]%s1%p28") or str:find("PRICE%s%p%s�28") then
        if str:find("������ ���� �� ��������") then
          return "������ ���� �� �������� ������ � �24/7� � ���� | Price 1-28"
        end
      end
    elseif str:find("[Dd]il[l]?i[o]?more") or str:find("��������") and str:find("[Gg][Pp][Ss]") then
      if str:find("� ��������") then
        return "� �������� �24/7 Dillimore� ������� ����! ��������: GPS 8-230"
      elseif str:find("���������� ������") then
        return "24/7 �Dilimore� - ������ ������� � ���������� ������ | Fuel 2"
      end
    elseif str:find("[Vv]ine[Ww]ood") and str:find("[Gg][Pp][Ss]") then
      if str:find("���� ���������� �����") then
        return "������� 50.000$ ���� ���������� ����� � 24/7 VineWood | GPS: 8-19"
      -- elseif str:find("������ SIM") then
      --   return "������ SIM-����� �� ������ ����� � 24/7 �Dillimore�. Price 1-2"
      end
    elseif str:find("[��]����") and str:find("[��]������") then
      if str:find("������������ �� 1200") then
        return "������������ �� 1200$ � �24/7 �����-������� �������� GPS 6-2!"
      end
    elseif str:find("��� LVPD") or str:find("��� ����") then
      if str:find("������������ � �����") or str:find("����� � ������������") then
        return "������ ���� �� ������������ � ����� ������ � ���! �� � ��� ����"
      elseif str:find("����� � ������������") then
        return "������ ���� �� ����� � ������������ � ����� 24/7. �� � ��� ����"
      elseif str:find("������ ���� �� ������������") then
        return "������ ���� �� ������������ ������ � ����� �24/7�! �� � ��� LVPD"
      elseif str:find("������ ���� �� ������� � �����") then
        return "������ ���� �� ������� � ����� ������ � ����� �24/7� � ��� ����"
      end
      
    elseif str:find("98 ������") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 1-15"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-83"
      end
      if str:find("[��]����[��]") then
        return "������ ������� 24/7 �98 ������ �� �����. ��. "..get_price(str, trade_type(str))
      elseif str:find("����� ������ ����") then
        return "����� ������ ���� � ����-������� �98 ������. "..biz_loc
      elseif str:find("����� ������� ����") then
        return "����� ������� ���� � ����-������� �98 ������ �� ������ ��"
      elseif str:find("������� ���� � ����%p������� 98 ������") then
        return "������� ���� � ����-������� �98 ������ �� ������ LS | "..biz_loc
      elseif str:find("[��]����� ���� � ����") then
        return "������ ���� � ����-������� �98 ������ �� ������ LS | "..biz_loc
      --������� ���� � ����-������� 98 ������ �� ������ �� price 1-15
      end
    elseif str:find("[��][��][��][��]") then
      if str:find("[��]����[��]") then
        return "������ ������� �24/7� � ����. "..get_price(str, trade_type(str))
      elseif str:find("[Gg][Pp][Ss]") then
        if str:find("[��]���� ������ ���� �") then
          return "����� ������ ���� � �24/7 ���ѻ. �� � GPS 8-38"
        elseif str:find("����� ������ ����.%s?��") then
          return "� �������� �24/7 ���ѻ ����� ������ ����. | GPS 8-38 | ���� ����!"
        end
      elseif str:find("����� �������� ����") then
        return "����� �������� ���� ������ � ����� �24/7� � ����. ���� ���!"
      end
      
    elseif str:find("%s8%s?%p%s?211") or str:find("[Pp]rice%s1%p1%p38") or str:find("[Pp]rice%s1%p38") then
      --debug("+", 2)
      if str:find("������ ����") then
        return "� �������� ��������� �24/7� ������ ����. ��� ���� | GPS 8-211"
      elseif str:find("������� � ������� ������������") then
        return "������� � ������� ������������ � �24/7� Montgomery | GPS 8-211"
      elseif str:find("��������� ����� � �������") then
        return "��������� ����� � ������� � �24/7� Montgomery | GPS 8-211"
      elseif str:find("������� � ��������� ������������") then
        return "������� � ��������� ������������ � �24/7� Montgomery | GPS 8-211"
      end

    elseif str:find("%s8%s?%p%s?21$") then
      if str:find("����� ������ �������� ������") then
        return "����� ������ �������� ������ � �������� �24/7� � �� | GPS 8-21"
      elseif str:find("���[�v]� ������ ����") or str:find("������ ����") then
        return "����� ������ ���� � �������� �24/7� � �� | GPS 8-21"
      elseif str:find("������ ���� �� �����") then
        return "������ ���� �� ����� � �������� �24/7� � �� | GPS 8-21"
      end
    
    elseif str:find("GPS%p?%s?1%p2") or str:find("�� ������ Los") then
      if str:find("[��]����� ����") then
        return "������ ���� � �����-������� 24/7� �� ������ LS | GPS 1-2"
      elseif str:find("[��]������ ������ �") then
        return "������� ������ � �����-������� 24/7� �� ������ LS | GPS 1-2"
      end
    elseif str:find("[Pp]ric[er]%s1%p25") then
      if str:find("���������� ����� ������� ����� ���") then
        return "� �24/7� � ���������� ����� ������� ����� ��������. | Price 1-25"
      end
    end

  elseif str:find("%s8%s?%p%s?21$") then
    -- debug("+", 2) -- ������ ���� �� ����� � ���.����������. GPS 8-21
    if str:find("����� ������ �������� ������") then
      return "����� ������ �������� ������ � �������� �24/7� � �� | GPS 8-21"
    elseif str:find("���[�v]� ������ ����") or str:find("������ ����") then
      return "����� ������ ���� � �������� �24/7� � �� | GPS 8-21"
    elseif str:find("������ ���� �� �����") then
      return "������ ���� �� ����� � �������� �24/7� � �� | GPS 8-21"
    end  
  
  elseif str:find("[��]�������") or str:find("[Pp]rice[(%s)|(%p)]12$") or str:find("[Pp]rice%s12%p7") then
    --debug("+", 2)
    if str:find("������� �����������") then
      if str:find("[��]�����") then
        return "������ ����������� ��������� - Price 12-7 | "..get_price(str, trade_type(str))
      end
      return "������� ����������� ��������� � Palomino Creek! Price 12-7"
    elseif str:find("��������� ������ ������ �") then
      return "��������� ������ ������ � ����������� Palomino Creek | Price 12-7"
    end 

  elseif str:find("[Pp]rice[(%s)|(%p)]12%p3$") then
    --debug("+", 2)
    if str:find("� ���� �������") then
      return "� ���� �������? ������ � ���� � ������������� �Ի. Price 12-3"
    elseif str:find("����� ������ ���� � �����������") then
      return "����� ������ ���� � ����������� SF ��������. | Price 12-3"
    elseif str:find("���� ��������� �������") then
      return "���� ��������� ������� � ����������� �������� | Price 12-3"
    end 
  elseif str:find("[Bb]if") and str:find("[Bb]rid") then
    if str:find("233") then
      biz_loc = "GPS 8-233"
    else
      biz_loc = "Price 9-5"
    end
    if str:find("�������") then
      if srt:find("�������") then hot_bb = "�������" else hot_bb = "" end
        return "� ����� �Biffin Bridge� "..hot_bb.." ������ �� "..get_hotel_price(str).."$/�����! | "..biz_loc
    elseif str:find("�������� ���������") then
      return "������ �������� ���������? ��� � ����� �Biffin Bridge�! GPS 8-158"
    elseif str:find("������� �������") then
      return "������� ������� ���������� � ����� �Biffin Bridge� | GPS 8-158"
    elseif str:find("VIP%p������") then
      return "VIP-������ � Hotel �Biffin Bridge� SF - "..get_hotel_price(str).."$/����! | "..biz_loc
    elseif str:find("��������� �����") then
      return "� ����� �Biffin Bridge� ���� ��������� ����� | "..biz_loc
    end
    
  elseif str:find("[��]���") and str:find("[Gg][Pp][Ss]") and str:find("%s8%s?%p%s?73%p?%s?") then -- GPS 8-73
    if str:find("������ �� �����") then
      return "������ �� �����, �� ������� ����? ����������� ���� ��� | GPS 8-73"
    elseif str:find("� � ������") then
      return "� � ������ ��� ������, ��� ���������� ����������� | GPS 8-73"
    elseif str:find("����������") then
      return "���� �� ������, �� ���������� �����, ������ � �����! | GPS 8-73"
    end
    return "�� ���� �� ������� �����������? ��������� ������ | GPS 8-73"

    
  -- elseif not str:find("[��]�����") and str:find("[��]���") then -- GPS 8-73
    
  --   if str:find("[Bb��][a�][r�]") then
  --     if str:find("����� ������ ��������") then
  --       return "���� �Las Barrancas�: ����� ������ �������� �� �������� | GPS 6-5"
  --     -- elseif str:find("����� �������� 0.7") then
  --     --   return "������� � �������� �������� � ����� �Las Barrancas� | GPS 6-5"
  --     elseif str:find("������� � �������� ��������") then
  --       return "������� � �������� �������� � ����� �Las Barrancas� | GPS 6-5"
  --     elseif str:find("����� ������ ��������") then
  --       return "����� ������ �������� �� �������� � ����� Las Barrancas | GPS 6-5"
  --     end
  --   elseif str:find("[Pp]al") and str:find("[Gg][Pp][Ss]") or str:find("����� Palomino Creek") then
  --     if str:find("�������� 0.8") then
  --       return "�������� �� �������� 0.8# ������ � ����� Palomino Creek | GPS 6-3"
  --     elseif str:find("�������� 0.8 ��������") then
  --       return "�������� 0.8 �������� � ����� � �. Palomino Creek | GPS 6-3"
  --     elseif str:find("��������� ���[�]?��� �� ��������") then
  --       return "������ ������� �� �������� � ����� � �. Palomino Creek | GPS 6-3"
  --     elseif str:find("%p���������� ����") then
  --       return "� ����� Palomino Creek ������ ������� � ���������� ���� | GPS 6-3"
  --     elseif str:find("[��]������� ������� ����[�]?����") then
  --       return "�������� �������, ������ ������� � ����� Palomino Creek | GPS 6-3"
  --     elseif str:find("���[��]������ � ������") then
  --       return "���� Palomino Creek: ������� � �������� �������� | GPS 6-3"
  --     end
  --   elseif str:find("[Aa]ngel") and str:find("[Gg][Pp][Ss]") then
  --     if str:find("����� ������ ��������") then
  --       return "����� ������ �������� �� �������� � ����� Angel Pine! | GPS 6-4"
  --     end
  --   else
  --     print("{cc0000}ERROR 2:{b2b2b2}", str)
  --     result = "ERROR"
  --   end
  --   return result

    -- ������ � ������

  elseif str:find("Izquierdo") then
    if str:find("��������� � ���������� ��������������") then
      return "��������� � ���������� ��������������. ��������: Lyle Izquierdo"
    elseif str:find("16 �������! ��������") then
      return "16 �������! ��������: Lyle Izquierdo! ����������� ��������������!"
    elseif str:find("�� ������������� �������") then
      return "��������� �� ������������� ������� 16-�� ������� �� Lyle Izquierdo."
    elseif str:find("16 �������. ��������������") then
      return "16 �������! �������������� � ��������! ��������: Lyle Izquierdo"
    end
  elseif str:find("Francois") then
    if str:find("������� ������� �� ���� ������ ���") then
      return "16 ������� ������� �� ���� ������ ���. ��������: Noah Francois."
    elseif str:find("�� ���������") then
      return "��� 25 ����� � �� ���������. ������� �� Noah Francois"
    elseif str:find("� �� ��� ����������") then
      return "��� 25 ����� � �� ��� ����������! ��������: Noah Francois"
    elseif str:find("������ ��� ����������") then
      return "������� ��� ����������. �������� �� ������ ���: Noah Francois"
    elseif str:find("�������� ���� ������ ���") then
      return "�������� ���� ������ ��� � ������ �������. ��������: Noah Francois"
    end
  elseif str:find("Smart Piratov") then
    if str:find("���� ������ ������") then
      if str:find("16 ���") then
        return "��������� ���� ������ ������? ������� �� Smart Piratov 16 �������"
      else
        return "��������� ���� ������ ������? ������� �� Smart Piratov!"
      end
    end
  elseif not str:find("[��][��][��] [��]����") and not str:find("� ����") and not str:find("sim") and not str:find("[��][��][��]") and not str:find("S[Ii][Mm]") and str:find("[^(���)]����") or str:find("Cart") or str:find("Kart") or str:find("cart") or str:find("kart") then
    -- debug("Kart eb...", 4)
    return vechicles(str, trade_type(str), "����������", "Kart")
  elseif str:find("�[�]?[��][��]��") or str:find("[��][��][��][(%p)|(�����)]") or str:find("[��][��][��] [��]����") or str:find("[Ss][Iil]m") or str:find("%s[��]��%s") or str:find("SIM") or str:find("����") or str:find("���� �����") or str:find("4 ������� �����") then -- ������
    --������� "XY-XXXX".
    if str:find("[��][�]?�[�]?�[�]?�") and str:find("[��]�����") then
      return "����� SIM-����� ��������� �������. "..get_price(str, trade_type(str))
    elseif str:find("4 ������� �����") or str:find("4%p[��]%s?%p?��������") then
      return "����� SIM-����� 4-� �������� �������. ���� ����������."
    end
    sim_format = get_simcard_fmt(str)
    if sim_format == nil then
      result = "(AD_SIM_0): {BF4E8D}��� �� ������� ���������� ���-�����, ���� ��� � ����:"
    else
      result = "������ SIM-����� ������� �"..sim_format:upper().."�. "..get_price(str, trade_type(str))
    -- ������
    end
    return result
    
  elseif str:find("[��Aa][��][��Cc]") or str:find("[Aa][Zz][Ss]") or str:find("����������� �������") then
    if str:find("[��]����") and str:find("[��Ll][��Vv]") then
      if str:find("[Ff]uel 17") then
        if str:find("��� ������ �����������") then
          return "��� ������ ����������� ��� ������������ LV� 1�. - 25$ | Fuel 17"
        elseif str:find("������� �� 5%$") then
          return "�� ��� �17 \"����������� ��\" ������� �� 5$/1�. | Fuel 17"
        elseif str:find("��� �� ������ ��") then
          return "����� �� ������ ��� �� ��� ������������ LV�. | Fuel 17"
        end
        return "�� ��� �17 \"����������� ��\" ������ �� 25$ �� 1�. | Fuel 17"
      else
        return "������ ��� ������������ �». "..get_price(str, trade_type(str))
      end
    
    elseif str:find("[��]�[�]?���") and str:find("[(��)|(��������)]") and str:find("%�1") then
      if str:find("[��]�����") then
        return "������ ��������� ��� �� �1� � �. Las Venturas. "..get_price(str, trade_type(str))
      elseif str:find("������� ���� ������������ ��������") then
        return "��������� ������������ �������� �� ��������� ��� �� �1� | Fuel 13"
      elseif str:find("������ �������") then
        return "������ ������� � ��������� �� ��������� ��� �� �1� | Fuel 13"
      elseif str:find("����� ���e�������� ������� �� 5") then
        return "����� ���e�������� ������� �� 5$ �� ��������� ��� LV �1�. Fuel 13"
      end
    elseif str:find("[��]������") then
      if str:find("[��]�����") then
        return "������ �������� ��� �» � �. Las Venturas. "..get_price(str, trade_type(str))
      elseif str:find("������� ������� ������ ���") then
        return "������� ������� ������ ��� �� ��� � ���������� �����! | Fuel - 11"
      end
    elseif str:find("�������� ��� ��") or str:find("��� �������� ��") then
      if str:find("[��]�����") then
        return "������ ��������� ��� �Ի � �. San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("������ ������� � [��]") then
        return "������ ������� � ��������� �� ��������� ��� �Ի | Fuel - 6"
      elseif str:find("������ ������� ������") then
        return "������ ������� ������ �� ���� �������� �Ի | Fuel - 6"
      end
      -- ������ "�������� ��� �� �1" � �. ���-��������. ����: ����������
    elseif str:find("ontgomery") and str:find("[Ff]uel") then
      if str:find("������ �������") then
        return "����� ������ ������� �� ��� �Montgomery� | �� ����� GPS 5-6"
      elseif str:find("������ �������") then
        return "������ ������� �� ��� �Flint County� 1 ���� - 50$! GPS 8-66!"
      end
    elseif str:find("[Ff]lint") then
      if str:find("������� ����� ��") then
        return "�� ��� �9 � �. Flint County ������� ����� �� $5 �� 1 ����! Fuel 9"
      elseif str:find("[��]�����") then
        return "������ ���� Flint County� � �. Flint. "..get_price(str, trade_type(str))
      end
    elseif str:find("[Ee]l [Qq]ueb") then
      if str:find("[��]������ � [��]����������� �������") then
        return "��� �El Quebrados� - ������� � ������������ �������! | Fuel - 8"
      elseif str:find("[��]����� ������� � [��]��������") then
        return "��� �El Quebrados� - ������ ������� � ���������! | Fuel - 8"
      end
    elseif str:find("���������") then
      if str:find("��������� ������ � �����������") then
        return "��������� ������ � ����������� �� ��� ����������� | GPS 5-4"
      end
    elseif str:find("�����") or str:find("�����") then
      if str:find("� ��� �����") then
        return "������ ������� � ��� ������� - � ��� ������ ���� | Fuel - 4"
      elseif str:find("������� ���� ������������") then
        return "������� ���� ������������ �������� � ��� ������� | Fuel - 4"
      elseif str:find("������� ���� �������") then
        return "������� ���� ������� �� ��� ������� | Fuel - 4"
      elseif str:find("������ ������ ��� Vin Dizel") then
        return "������ ������ ��� Vin Dizel? ����������� �� ��� �������: Fuel - 4"
      end
    elseif str:find("[fF]uel 13") then
      if str:find("��������, ��������") then
        return "������� �� 5$ �� ���� �� ��� ����. ��������, ��������! | Fuel 13"
      end
    elseif str:find("[��]����[�]?�����") then
      if str:find("10�") then
        return "������ ������� �� ��� � �����. ����������! | 10�-50$ | Fuel 1"
      elseif str:find("1�%p?(.-)%s?%p%s?5%$") then
        return "������ ������� �� ��� � ������������� ���������� | 1�-5$ | Fuel-1"
      elseif str:find("[��]�����") then
        return "������ ��� ����� ������������� ����������. "..get_price(str, trade_type(str))
      end
      return "������ ������� ������ �� ��� � ������������� ����������: 1�.-5$"
    elseif str:find("[��][��][��][��][��]") then
      return string.format("����� ��������������� �������%s. %s", get_location(str), get_price(str, trade_type(str)))
    end

    
  elseif str:find("����") and str:find("[��][��][��][��]") and str:find("����") then
    return action[trade_type(str)].."������� ������ \"Binco\" � ����. "..get_price(str, trade_type(str))
  elseif str:find("�����") then
    w_location = location(str, "������", "n", "n")
    return w_location
    -- ==����������== --
  elseif str:find("[^��][��K][�o��][�c��][�]?[�y�a]") or str:find("%s���$") or str:find("���[��]") then
    return action[trade_type(str)].."��������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") and str:find("[��]��") then
    return action[trade_type(str)].."��������� ����������� ���. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") then
    return action[trade_type(str)].."��������� ����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[���]") then
    return action[trade_type(str)].."��������� ������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ���������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ������� �� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") then
    return action[trade_type(str)].."��������� ����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� �������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]�[��][���]") and str:find("[��][��]���") then
    return action[trade_type(str)].."��������� ����� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��][��]�[��]") then
    return action[trade_type(str)].."��������� �������� ����� � ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[�]?�") and str:find("[��]����") then
    return action[trade_type(str)].."��������� ������������ �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]��[��]") or str:find("[��]���") then
    return action[trade_type(str)].."��������� ����� ������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") and str:find("[��]����") then
    return action[trade_type(str)].."��������� ��������� �������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��][����][��][��][��]") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���[��]") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�������") then
    return action[trade_type(str)].."��������� �����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�[��][��][��] [�娸]����") then
    return action[trade_type(str)].."��������� ������ �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]�[�]�[�]?�") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[��][��] [��]����[��]") then
    return action[trade_type(str)].."��������� ������ ������. "..get_price(str, trade_type(str))
  elseif str:find("[��][�]��[��][��] [��]����[��]") then
    return action[trade_type(str)].."��������� �׸���� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��][�]��[��][��] [��]���[��]") then
    return action[trade_type(str)].."��������� �׸���� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[��]") then
    return action[trade_type(str)].."��������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��][��]���") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") then
    return action[trade_type(str)].."��������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[��]") and str:find("[��]����%s?�����") or str:find("[��]����������") then
    return action[trade_type(str)].."��������� ������� � ������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[��]") and str:find("[Gg��][Tt��][Aa��]") then
    return action[trade_type(str)].."��������� ������� �� GTA III�. "..get_price(str, trade_type(str))
  elseif str:find("[��]�������") and (str:find("[��]����") or str:find("[��]�����")) then
    return action[trade_type(str)].."��������� �������������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ������� � ������� �������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ���� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��][��]���") or str:find("[��]�����[��]") then
    return action[trade_type(str)].."��������� ������������ ������� �� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ������� � ����-�����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��]�����%p?%s?[��]����") then
    return action[trade_type(str)].."��������� �������-����� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��]����") then
    return action[trade_type(str)].."��������� ���������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��][��]���%p?%s?[��]����") then
    return action[trade_type(str)].."��������� �׸���-����� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]������") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]����") then
    return action[trade_type(str)].."��������� ����� � ����-�����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����� [��]������") or str:find("[��]����� [��]�����") then
    return action[trade_type(str)].."��������� ������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����%s?[��]�����") then
    return action[trade_type(str)].."��������� ������-������ � ������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") or str:find("[��]��") then
    return action[trade_type(str)].."��������� ����� � �������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]�[��]��� [��]�") then
    return action[trade_type(str)].."��������� ������� ���. "..get_price(str, trade_type(str))
  elseif str:find("[��]����� [��]��") or str:find("[��]����� [��]��") or str:find("[��]��������� [��]�����") then
    return action[trade_type(str)].."��������� ������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����� [��]��") then
    return action[trade_type(str)].."��������� ������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����� [��]�[�]?�") or str:find("[��]�� [��]����") or str:find("[��]��� [��]����") then
    return action[trade_type(str)].."��������� ������� ���. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[��]�����") then
    return action[trade_type(str)].."��������� ������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[��]���") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���[��]") and str:find("[��]����������") then
    return action[trade_type(str)].."��������� ������ �����������. "..get_price(str, trade_type(str))
  elseif str:find("[����]��") and str:find("[��]��") then
    return action[trade_type(str)].."��������� �����-����. "..get_price(str, trade_type(str))
  elseif not str:find("[Pp]rice") and str:find("[����]���") and str:find("[��]�[��]���") then
    return action[trade_type(str)].."��������� �����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��]���") then
    return action[trade_type(str)].."��������� �������������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��][��][��]") then
    return action[trade_type(str)].."��������� ������� ������� ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��]��") then
    return action[trade_type(str)].."��������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]����") then
    return action[trade_type(str)].."��������� ����� � �������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���%s��%s�����") then
    return action[trade_type(str)].."��������� ����� �� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") then
    return action[trade_type(str)].."��������� ������-�����. "..get_price(str, trade_type(str))
  elseif str:find("[��]���[�]") then
    return action[trade_type(str)].."��������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[��][��]�[�]?���") then
    return action[trade_type(str)].."��������� �������������. "..get_price(str, trade_type(str))
  elseif str:find("[��][��][��]?��������") then
    return action[trade_type(str)].."��������� ������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����� [��]��") then
    return action[trade_type(str)].."��������� ������� ���. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]��") then
    return action[trade_type(str)].."��������� ���������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����� [��]��") then
    return action[trade_type(str)].."��������� ������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[����]�[�]?[��]�[�]�") or str:find("�����") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif not str:find("�����") and str:find("[��]���") or str:find("[��]���") then
    return action[trade_type(str)].."��������� ���������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]�[��]���") then
    return action[trade_type(str)].."��������� ������������ ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��������") and str:find("[��]�[��]���") then
    return action[trade_type(str)].."��������� ���������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[����]") then
    return action[trade_type(str)].."��������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����(.+)%s[��]��") then
    return action[trade_type(str)].."��������� ����� � ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") then
    return action[trade_type(str)].."��������� ����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��������") then
    return action[trade_type(str)].."��������� ����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����[����]") and str:find("[��]������") then
    return action[trade_type(str)].."��������� ������� ���������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��������") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ���������������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") and str:find("[��]����") then
    return action[trade_type(str)].."��������� ������ ��������������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ������ ����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ������ ��������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[^�]") and not str:find("������") and not str:find("����") and not str:find("[gG][pP][sS]")  then
    return action[trade_type(str)].."��������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") or str:find("[Bb]anan") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") and str:find("[��]����") then
    return action[trade_type(str)].."��������� ����������. ��������-��������. "..get_price(str, trade_type(str))
  elseif str:find("[�娸]��") and str:find("[��]���") then
    return action[trade_type(str)].."��������� ����� �� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[Ũ�]��") then
    return action[trade_type(str)].."��������� ����������� ����. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") and str:find("[��]��") or str:find("[��]���� ��") then
    return action[trade_type(str)].."��������� ����������� �����. "..get_price(str, trade_type(str))
  elseif not str:find("[��]���") and str:find("[����][��]��") and not str:find("[Ss]moke") and not str:find("[Aa��][Mm��][Mm��][OoUu����]") then
    return action[trade_type(str)].."��������� �����������. "..get_price(str, trade_type(str))
  elseif not str:find("[��]���") and not str:find("�����") and str:find("[��][��]�[��]?[�]?��") or str:find("[��]���") then
    return action[trade_type(str)].."��������� ��������. "..get_price(str, trade_type(str))
  elseif not str:find("[Cc]lub") and str:find("[��]��") or str:find("[��]��[�]?��") or str:find("[��]�����") then
    return action[trade_type(str)].."��������� ���������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���[��]") then
    return action[trade_type(str)].."��������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[��]") and str:find("[��]����") or str:find("[��][��][��][��]?��[��]�") then
    return action[trade_type(str)].."��������� ��������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[��]") and str:find("[��][�]?�[�]�") or str:find("[��]����������") or str:find("���� ���� �����") then
    return action[trade_type(str)].."��������� ����������� �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]��[��]") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����[��]�") then
    return action[trade_type(str)].."��������� ����������. "..get_price(str, trade_type(str))
  elseif str:find("[��]���") then
    return action[trade_type(str)].."��������� ������ �����. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") then
    return action[trade_type(str)].."��������� ������. "..get_price(str, trade_type(str))
  elseif str:find("[��]����") and str:find("[��]����") then
    return action[trade_type(str)].."��������� �������� �������. "..get_price(str, trade_type(str))
  elseif str:find("[��]�����") then
    return action[trade_type(str)].."��������� ������ �������. "..get_price(str, trade_type(str))
  -- ==������==
  
  elseif str:find("���[��]�") or str:find("����[��][�]?") or str:find("����") or str:find("�����") then
    if str:find("%s��$") then
      return "��� ������� ��� ��������� ���������. ��� �������."
    elseif str:find("�������� �����") then
      return "������������ � ������� �������� ��� �������� �����. �������!"
    elseif str:find("������� �����") then
      return "������������ � ������� �����. �������!"
    elseif str:find("����� ��� ����[�]�") then
      return "��������� � ������ ��� ��������� ���������. ������� ���!"
    elseif str:find("[��]����������� � ������") then
      return "������������ � ������. "..get_about_ys(str)
    elseif str:find("� �������") then
      if str:find("�������������") then
        return "������������ ������������� � ������� ��������. �������."
      end
      return "������������ � ������� ��������. ��� �������."
    end
    return "������������ � ��������. "..get_about_ys(str) --������� � �����
  elseif str:find("[Ff]am[ia]ly") or str:find("[��]��[�]?[���]") or str:find("[^%p][Cc]lan") and not str:find("[��]������") or str:find("������� �����") then
    if str:find("[Gg]oldberg") then
      if str:find("�������") then
        return "����� Goldberg Family ���� ������� �������������."
      else
        return "�������� ���� ������ � �������? ����� Goldberg �������!"
      end
    elseif str:find("[Gg]odless") then
      if str:find("������� ������") then
        return "�������� ������ �� ������� ������. ������� � �Godless Clan�."
      elseif str:find("�������� � ��������") then
        return "������� � �Godless Clan�, �� �������� � �������� � �����������."
      elseif str:find("������ ���� � ��������") then
        return "������ ���� � ��������? ��������� ������! �������: �Godless Clan�"
      end
    elseif str:find("[Gg]oldic") then
      if str:find("�������") then
        return "����� �Goldic Family� ���� ������� �������������. ��� �������!"
      end
    elseif str:find("[Cc]uadrado") then
      if str:find("���� ������������� ������") then
        return "���� ������������� ������ � �Cuadrado Family�. �������."
      end
    elseif str:find("[Ss]ilantev") then
      if str:find("�������") then
        return "����� �Silantev� ���� ������� �������������. ��� �������!"
      end
    elseif str:find("Kane") then
      if str:find("�������") then
        return "����� Kane ���� ������� �������������. ��� �������!"
      elseif str:find("������ ����� ����� �����") then
        return "������ ����� ����� �����? ����� ���� � ����� Kane!"
      end
    elseif str:find("[Tt]empest") then
      if str:find("�������") then
        return "����� Tempest Family ���� ������� �������������. ��� �������!"
      end
    elseif str:find("Atlas") or str:find("ATLAS") then
      if str:find("�������") then
        return "����� Atlas ���� ������� �������������. ��� �������!"
      end
    elseif str:find("Bazile") then
      if str:find("�������") then
        return "����� Bazile ���� ������� �������������. ��� �������!"
      end
    elseif str:find("Insolent") then
      if str:find("�������") then
        return "����� Insolent ���� ������� �������������. ��� �������!"
      end
    elseif str:find("Capone") then
      if str:find("������[��]") then
        return "����� Capone ���� ������� �������������. ��� �������!"
      end
    elseif str:find("York") then
      if str:find("�������") then
        return "����� York ���� ������� �������������. ��� �������!"
      elseif str:find("�� �������� � LS") then
        return "����� ������? ������ �������� � LS? ����� York �������. �����!"
      elseif str:find("���� ����� � �����") then
        return "���� ����� � ����� York! �� ���� ����!"
      end
    elseif str:find("Caution") then
      if str:find("�������") then
        return "����� Caution ���� ������� �������������. ��� �������!"
      end
    elseif str:find("[Tt]aties") then
      if str:find("�������") then
        return "����� Taties ���� ������� �������������! �������!"
      end
    elseif str:find("[Pp]lanchik") then
      if str:find("������� ������") then
        return "������ ������� ������? ����� �����? ������� � �Planchik Family�"
      elseif str:find("������ ������") then
        return "������ ������ ������? ������� ������? ���� � �Planchik Family�"
      end
    elseif str:find("[Bb]lack") then
      return "������ ����� ���������� ���������? ����� Black ���� ������ ����!"
    elseif str:find("[Ss]offord") then
      if str:find("[��]����� ����������") then
        return "������ ����������? ����� ���� � ��� � ����� Sofford."
      elseif str:find("������� ������") then
        return "������ � ������� ������ �����? ���� ���� � Sofford."
      elseif str:find("����� ����� � �����") then
        return "������ ����� � �����? ����� ���� � ����� ������ Sofford!"
      end
    elseif str:find("[��]�[��] �����$") or str:find("[��]������ � .+ �����") or str:find("[��]������ � �����") or str:find("�������� � �����") or str:find("��� �����.") or str:find("������� �����") then
      return "��� ������� �������������. ��������� ���!"
    end
  elseif str:find("��[�]?[�]?���") then
    if str:find("[Ll��][Vv��]") then
      return "�� ����� �. Las Venturas �������� ������� �������. �������."
    end
    return "�� ����� "..get_location(str):gsub(" � ", "").." ������� ������� �������. �������."
  elseif str:find("�[��]��[�]�") or str:find("����[Ũ]�") then
    return "�� ����� "..get_location(str):gsub(" � ", "").." ������� �������. �������."
  elseif str:find("[��]���") then
    if str:find("[Ll��][Vv��]") or str:find("[Ll��][Aa��][Ss��]") then
      return "�� �������� �. Las Venturas �������� ������� ����. �������!"
    elseif str:find("[Ll��][Ss��]") or str:find("[Ll��][Oo��][Ss��]") then
      return "�� �������� �. Los Santos �������� ������� ����. �������!"
    elseif str:find("[��Ss][��Ff]") or str:find("[��Ss][��Aa][��Nn]") then
      return "�� �������� �. San Fierro �������� ������� ����. �������!"
    end
  elseif str:find("[��]��%s?�����") then
    if str:find("[Ll��][Vv��]") or str:find("[Ll��][Aa��][Ss��]") then
      return "�������� LV ������������� ������ ��������. GPS 3-14"
    elseif str:find("[Ll��][Ss��]") or str:find("[Ll��][Oo��][Ss��]") then
      return "�������� LS ������������� ������ ��������. GPS 3-12"
    elseif str:find("[��Ss][��Ff]") or str:find("[��Ss][��Aa][��Nn]") then
      return "�������� SF ������������� ������ ��������. GPS 3-13"
    end  
  elseif str:find("�������") or str:find("��������") or str:find("����") or str:find("����") or str:find("�����") or str:find("������") or str:find("����") or str:find("����������") or str:find("����") or str:find("����� ���") or str:find("�����") or str:find("����� ���") or str:find("[��]�����") or str:find("��������") or str:find("%s[��]��%p?%s") or str:find("[��]�����") then
    return location(str, "��������", "n", "n")
  
  elseif str:find("[��]�����%s%d+%s[(����)|(�����)]") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%s�%s%d+") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%p%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%p%d+%p%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]����� %d+ %d%p%d��") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%s��") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%s%d+��$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��][��][��]���%s%d+%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��][��][��]���%s%d+%p%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%s%W$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]����� %d+ %d+ ����") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]����� %d+ %d+ %d+%p?$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]����� %d+ %d+ %d+%s%W") then
    return clothes(str, trade_type(str))
  elseif str:find("%d+%ssell$") then
    return clothes(str, trade_type(str))
  elseif str:find("[Ss]ell %d+ %W-$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�[�]?�[��]%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("^%d+%s%d+%s�����$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]���[��]%s%d+%s") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]���[��]%s%d+%p") then
    return clothes(str, trade_type(str))
  elseif str:find("[Bb]uy%s%d+") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]�����%s%d+%s[^(��)|^(����)|^(�����)]") and #str:match("[��]�����%s(%d+)%s") > 3 then
    if #str:match("[��]�����%s(%d+)%s") > 3 then
      return "������ SIM-����� ������� �"..get_simcard_fmt(str):upper().."�. "..get_price(str, trade_type(str))
    end
  elseif str:find("[��]���[�]?[��]%s%d+%s%d+$") then
    return clothes(str, trade_type(str))
  elseif str:find("[��]���[��]%s%d+,%d+,%d+") then
    return clothes(str, trade_type(str))
  elseif not str:find("[��][�]?���") and not str:find("������") and not str:find("[��]��") and not str:find("[��]������") and str:find("[��]�[��]?[��][�]?") or str:find("[��Cc][����][��]?[����][��]") or str:find("%s��� %d+") or str:find("skin") or str:find("������[�]? [^(���)]") or str:find("��[�]?[�i][��]") or str:find("�����") or str:find("���[��]") or str:find("����") or str:find("[��]��[�]?�") or str:find("[��]�����") or str:find("[��]�� [��]��") or str:find("[Bb]ig [Ss]mo") or str:find("[��]���[�]��") or str:find("[��]���[�]?�") or str:find("[��]���") then
    debug("������: ������� ������\n"..str, 2)
    if str:find("[��]����") then
      return action[trade_type(str)].."������ � ������ �264. "..get_price(str, trade_type(str))
    elseif str:find("[��]���[�]?�") then
      return action[trade_type(str)].."������ � ������ �296. "..get_price(str, trade_type(str)) 
    elseif str:find("[��]���") then
      return action[trade_type(str)].."������ � ������ �270. "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") then
      return action[trade_type(str)].."������ � ������ �168 �������. "..get_price(str, trade_type(str))
    elseif str:find("[Jj]izzy") then
      return action[trade_type(str)].."������ � ������ �296. "..get_price(str, trade_type(str))
    elseif not str:find("[��]���") and str:find("[��]�� [��]��") or str:find("[Bb]ig [Ss]mo") then
      return action[trade_type(str)].."������ � ������ �269. "..get_price(str, trade_type(str))
    elseif str:find("[��]�� [��]��") and ("[��]���") or str:find("[Bb]ig [Ss]mo") and ("[��]���") then
      return action[trade_type(str)].."������ � ������ �149. "..get_price(str, trade_type(str))
    elseif str:find("[��]��[�]?�") then
      return action[trade_type(str)].."������ � ������ �294. "..get_price(str, trade_type(str))
    elseif str:find("[��]���") then
      return action[trade_type(str)].."������ � ������ �285. "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") then
      return action[trade_type(str)].."������ � ������ �99. "..get_price(str, trade_type(str))
    elseif str:find("[��]���[�]��") then
      return action[trade_type(str)].."������ � ������ �16. "..get_price(str, trade_type(str))
    -- elseif str:find("[��]�����") and str:find("[��]���") then
    --   return action[trade_type(str)].."������ � ������ �271. "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") then
      return action[trade_type(str)].."������ � ������ �271. "..get_price(str, trade_type(str))
    end
    return clothes(str, trade_type(str))
  elseif str:find("�����") or str:find("���[��]") or str:find("�������") or str:find("���[��]") then
    if str:find("�������� �����") then
      return "��� ������� ��� �������� �����. "..get_about_ys(str)
    elseif str:find("������� �����") then
      return "������������ � ������� �����. �������!. "..get_about_ys(str)
    elseif str:find("�����") or str:find("���") then
      if str:find("[��]��� �����") or str:find("%s�%p�") then
        return "������������ � �������� ��� ��������� ���������. "..get_about_ys(str)
      elseif str:find("������ ������") then
        return "��� ���� ������ ������. "..get_about_ys(str)
      else
        return "������������ � ��������. "..get_about_ys(str)
      end
    elseif str:find("����") or str:find("�������") then
      return "��� ������� ��� ��������� ���������. � ����: ��� �������"
    end
  elseif str:find("���[��]�") or str:find("�����") or str:find("����") then
    if str:find("%s��$") then
      return "��� ������� ��� ��������� ���������. ��� �������."
    elseif str:find("�������� �����") then
      return "������������ � ������� �������� ��� �������� �����. �������!"
    end
    return "������������ � ��������. "..get_about_ys(str) --������� � �����

  elseif str:find("��[��][^�]") or str:find("�[��][��][^�]") or str:find("[��]������ � [��]����") or str:find("[��]������ � ����") or str:find("������� ���") or str:find("������ �� �����") or str:find("[��] �������") then
    -- debug("FIND:"..str, 1)
    if str:find("_") then str = str:gsub("_", " ") end
    if str:find("[�]?�����[�]?[�]?") or str:find("������") or (str:find("������� ���") and not str:find("������")) or str:find("[��][��][��]%s%w+%s%w+$") then
      debug(str, 1)
      if str:find("����[(��)|(�)]%s(%w+)%s(%w+)$") then
        first, last = str:match("����.+%s(.+)%s(.+)$")
        print(first, last)
        -- debug("Find human, Pattern 1", 1)--\nFirst: "..first.."\nLast: "..last, 1)
        first, last = name_upper(first, last)
      elseif str:find("^%w+%s%w+%s") then
        first, last = str:match("^(%w+)%s(%w+)%s")
        -- debug("Find human, Pattern 2", 1)--\nFirst: "..first.."\nLast: "..last)
      elseif str:find("[(�����)|(�����)|(������)|(����)|(������)]%s%p?(%w+)%s(%w+)%p?%s?%p?") then
        -- debug("Find human, Pattern 3", 1)--\nFirst: "..first.."\nLast: "..last)
        if str:find("%w+%s[��]���") then
          debug("P2, ID - 1", 1)
          first, last = str:match("[�]���[�] (.+) (.+)%s[��]��")
          if str:find("�������� %w+") then
            first, last = str:match("�������� (%w+) (%w+)")
          end
          
        elseif str:find("[�]���[�] (%w+) (%w+)%s������") then
          first, last = str:match("[�]���[�] (%w+) (%w+)%s������")
          debug("P2, ID - 2", 1)
        elseif str:find("[�]���[�] (%w+) (%w+)%s[��]���") then
          first, last = str:match("[�]���[�] (%w+) (%w+)%s[��]���")
          debug("P2, ID - 3", 1)
        elseif str:find("[�]���[�] (%w+) (%w+)%p?%s[��]���") then
          first, last = str:match("[�]���[�] (%w+) (%w+)%p?%s[��]���")
          debug("P2, ID - 4", 1)
        elseif str:find("������%s%w+%s%w+.%s�������") then
          debug("P2, ID - 5", 1)
          first, last = str:match("������ (%w+)%s(%w+).%s�������")
        elseif str:find("%w+%p%s����") then
          debug("P2, ID - 6", 1)
          first, last = str:match("����� (%w+) (%w+)%p%s?���")
          
        elseif str:find("%w+%p%W+") then
          debug("P2, ID - 7", 1)
          first, last = str:match("[(������)|(��������)|(�����)|(�����)] %p?(%w+) (%w+)%p?%p%W+")
          print(string.format("Find player | ID: 7 - %s %s", first, last))
        elseif str:find("[(������)|(��������)|(�����)] %w+ %w+$") then
          debug("P2, ID - 8", 1)
          first, last = str:match("[(������)|(��������)] (.+) (.+)$")
        elseif str:find("%w+$") then
          debug("P2, ID - 9", 1)
          first, last = str:match("����[��][�]? (.+) (.+)$")
        elseif str:find("%p%w+%s%w+%p") then
          debug("P2, ID - 10", 1)
          first, last = str:match("%p(%w+)%s(%w+)%p")
        elseif str:find("%W+%s%w+%s%w+%p$") then
          debug("P2, ID - 11", 1)
          first, last = str:match("%W+%s(%w+)%s(%w+)%p$")
        elseif str:find("������%s%w+%s%w+%s�������") then
          debug("P2, ID - 12", 1)
          first, last = str:match("������ (%w+)%s(%w+)%s�������")
        elseif str:find("��������%s%w+%s%w+%p%s%W+") then
          debug("P2, ID - 13", 1)
          first, last = str:match("��������%s(%w+)%s(%w+)%p%s%W+")
        end
        debug("Find human, Pattern 3", 1)--\nFirst: "..first.."\nLast: "..last)
        print(first, last)
      elseif str:find("^(%w+) (%w+)%p%s������� ���") then
        debug(str.." | Pattern 4", 1)
        first, last = str:match("^(%w+)%s(%w+)%p%s���")
        print(first, last)
      elseif str:find("[�]���[�] \"(.+) (.+)\"%p?") then
        debug(str.." | Pattern 5", 1)
        first, last = str:match("[�]���[�] \"(.+) (.+)\"%p?")
        print(first, last)
      elseif str:find("����[�]?%s%w+%s%w+%p?") then
        debug(str.." | Pattern 6", 1)
        first, last = str:match("����[�]?%s(%w+)%s(%w+)%p?")
        print(first, last)
      elseif str:find("[��]� (%w+) (%w+)") then
        debug(str.." | Pattern 7", 1)
        first, last = str:match("[��]�%s(%w+)%s(%w+)%p?")
        print(first, last)
      elseif str:find("�� (%w+) (%w+)") then
        --�� Dmitriy Forost.
        debug(str.."Pattern 8", 1)
        first, last = str:match("��%s(%w+)%s(%w+)%p")
        print(first, last)
      elseif str:find("^[��]������ �� ����� (.+) (.+)%p") then
        first, last = str:match("�����%s(%w+)%s(%w+)%p")
        print(first, last)
      end
      print(str)
      if last == nil or first == nil then
        print("{cc0000}ERROR 4:{b2b2b2}", str)
        return "ERROR"
      end
      first, last = capitalize_nick(first, last)
      return "��� �������� �� ����� "..first:gsub("\"", "").." "..last:gsub("\"", "")..". ������� ���!"
    elseif str:find("����[�]?[�]?�[��]?[��][��]") or str:find("[��]����") or str:find("����") then
      return "��� ������� �������������. ��������� ���!"
    else
      if str:find("�� (.+) (.+)") then
        --�� Dmitriy Forost.
        debug(str.."FOUND14", 1)
        first, last = str:match("��%s(%w+)%s(%w+)")
        print(first, last)
      end
      if last == nil or first == nil then
        print("{cc0000}ERROR 5:{b2b2b2}", str)
        return "ERROR"
      end
      return "��� �������� �� ����� "..first.." "..last..". ������� ���!"
    end

  elseif not str:find("������") and str:find("[��]���� [��]����") then
    return "������� ����� �� 5.000.000$. ���������! �� � \"������ �����\" | GPS 8-280"
  elseif str:find("[��]���") or str:find("�� [��]����") and str:find("[Gg][Pp][Ss]") or str:find("AMMO") then
    --locate, gps = location(str, "ammo", nil, nil)
    h_string = location(str, "ammo", nil, nil)
    return h_string
  elseif str:find("(.-)�[��][��][��]") or str:find("[Ss]ell") or str:find("[��]�����") or str:find("(.-)�����") or str:find("����") or str:find("������") or str:find("[��]��") then
    --debug(str, 5)
    if str:find("[��]����%s?[��]��") then
      if str:find("[��]���[�]?������") then
        return "������ �������� ����������� � �. Marina, LS. "..get_price(str, trade_type(str))
      end
      return "������ ������ ���������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") then
      return "������ ������ ����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����") or str:find("[��]�� [��]���") then
      return "������ ������ �������������� ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") then
      return "������ ������ ���������� San Fierro. "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") then
      return "������ ���������� �����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") then
      return "������ ������ ����������������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����") and str:find("[��]�����") then
      return "������ ����������� ����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����") then
      if str:find("[Ll]ast [Dd]rop") then
        return "������ �����-���� �Last Drop� � �. Montgomery. "..get_price(str, trade_type(str))
      end
      return "������ ������ ������-����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Ss]ex") or str:find("[��]���") then
      if str:find("Sex Shop �� %�2") then
        return "������ ������ �Sex-Shop LV� � �.Roca Escalante. "..get_price(str, trade_type(str))
      elseif str:find("hop LS") and str:find("%�1") or str:find("[Ss]ex[Ss]hop �1") or str:find("���� ��� �1") then
        return "������ ������ �Sex-Shop �1�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[��]��� [��]��[( ��)]? 2") or str:find("[Ss]ex%p?%s?[Ss]hop 2") then
        return "������ ������ �Sex-Shop �2�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("Sex Shop �� %�2") or str:find("Sex Shop %�2 � �.Marina") then
        return "������ ������ �Sex-Shop LS �2�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("Sex Shop%p �� ���") then
        return "������ ������ �Sex-Shop�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("����� 1") then
        return "������ Sex-Shop �1"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return string.format("������ Sex-Shop%s. %s", get_location(str), get_price(str, trade_type(str)))
    elseif str:find("[��]����� [��]���") then
      return "������ ������ ������� ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Aa]dvance [Cc]lub") or str:find("[��]����� [��]�[��]�") then
      return "������ ������ �Advance Club� � �. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("���� %p���[�]?������%p") or str:find("���� %p���[�]?������%p") then
      return "������ ���� �Montgomery� � �. Montgomery. "..get_price(str, trade_type(str))
    elseif str:find("���� [Bb]ig [Ss]pre[a]?d") or str:find("���� %p���[�]?������%p") then
      return "������ ���� �Big Spread Ranch� � �. Bone. "..get_price(str, trade_type(str))
    elseif str:find("[Gg]aydar [Ss]tation") then
      return "������ ���� �Gaydar Station�"..get_location(str)..". "..get_price(str, trade_type(str))
    
    elseif str:find("[��]���") then
      if str:find("[��]����") then
        return "������ ���� � GPS-��������"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "������ ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����") or str:find("[��]�����") then
      if str:find("B[r]?iffin%p?%s?Bridge") then
        return "������ ����� �Biffin Bridge� � �. San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("���� [��]��%p?%s?[��]�����") or str:find("[��]���� [��][��]") then
        return "������ ������ ������ ���-������. "..get_price(str, trade_type(str))
      elseif str:find("���� %p?Las%p?%s?Venturas%p?") then
        return "������ ������ ������ Las-Venturas�. � �. LV. "..get_price(str, trade_type(str))
      elseif str:find("[��]����") and str:find("[��]���") then
        return "������ ������ ���������� ����������. � �. LV. "..get_price(str, trade_type(str))
      elseif str:find("[Oo][kc]ean") and str:find("[��]����") then
        return "������ ������ ������ Ocean�. � �. LS. "..get_price(str, trade_type(str))
      end
    elseif str:find("�� [��]��������") or str:find("[��]������ [��]���[�]?����[��]") then
      return "������ �������� �����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����") and str:find("[��]����") then
      if str:find("[Gg][Pp][Ss]") then
        return "������ ������ �� ������� �� GPS 8-76. "..get_price(str, trade_type(str))
      end
      return "������ �� ������� � �. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") then
      if str:find("GPS") then
        return "������ ������ �� ������� �� GPS 8-42. "..get_price(str, trade_type(str))
      end
      return "������ �� ������� � �. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[��]�������������� [��]����") or str:find("[��]��[�]? [��]����") then
      if str:find("[��]��[��]") then
        return "������ �����. ����� �����"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "������ ���������������� �����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������������� [��]����") then
      return "������ ���������������� �����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]������ [��]��������") or str:find("[��]�������") then
      return "������ ������ �������� ���������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("������� ���%p?%s?��������") then
      return "������ ������ ���������� ���������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") or str:find("��������") or str:find("[��]�[�]?���") and str:find("[��]����") then
      if str:find("������") or str:find("��[�]?���") then
        return "������ ������������ �������"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("�������� ������������") then
        return "�� ������� ���������� ������������ ������� �� ��������� �. LS."
      elseif str:find("�� [Gg][Pp][Ss] 8%p147") then
        return "������ ������ �������������� �� GPS 8-147. "..get_price(str, trade_type(str))
      end
      return "������ ������ ��������������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") and str:find("[Aa]ngel") then
      if str:find("��������") then
        return "������ ��������� Angel Pine� � �. Angel Pine. "..get_price(str, trade_type(str))
      end
    elseif str:find("[Cc]lu[c]?k[iae]n [Bb]ell") or str:find("[��]���[��]� [��]��[�]?") then
      if str:find("[��Ss][Ff��][Ff��][Mm��]") then
        return "������ �Cluckin Bell� � ����������� San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("[Gg��][Pp��][Ss��]%s4%p?%s?8") then
        return "������ �Cluckin Bell� �� GPS 4-8. "..get_price(str, trade_type(str))
      end
      return "������ ������ �Cluckin Bell�"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]��[��][���]?[�]?[��]�[�]?[��]���") or str:find("%s[��]����%s") then
      if str:find("[��]��") then
        return "��������������"..get_location(str).." ���������� �� �������."
      end
      if str:find("[��]����[�]?���") then
        return "������ �������������� ����������"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "������ ������ ����������������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]������ [��]���") or str:find("[��]���������[��]") then
      if str:find("�������� �����") then
        return "������ ������� ����������� ��������� ������ � LV. "..get_price(str, trade_type(str))
      end
      return "������ ������� �����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]������ [��]����") then
      return "������ �������� �������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]��(.-) [��]���(.-)") then
      return "������ ����� ������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]���� [��]������") then
      return "������ ������ ��������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]��������") then
      return "������ ����� ������������ ������ � �.Fort Carson. "..get_price(str, trade_type(str))
    elseif str:find("[��]����") and str:find("[��]�������") then
      if str:find("[��]��") then
        return "����� �������������� � Las Barrancas �� �������� | Price 4-1-11"
      end
      return "������ ����� �������������� � �. Las Barrancas. "..get_price(str, trade_type(str))
    elseif str:find("[��]����") and str:find("[��]����������") then
      if str:find("[��]��������") then
        return "������ ������� ����������� ���������� � �. Los Santos. "..get_price(str, trade_type(str))
      end
      return "������ ������� �����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]��� [��]�����������") then
      return "������ ������ ����� ������������ � ��������� LS. "..get_price(str, trade_type(str))
    elseif str:find("[��]��[�]?����") or str:find("[��]�����[��]") or str:find("[��]�����") or str:find("Burger%s?Shot") or str:find("[��]�[��][���][��][�]?%s?[��]��") or str:find("[��]��[��]�� [��]��") then
      if str:find("[��]�����") then
        return "������ ������ �����������-������"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("�������� ������������") then
        return "�� �������� ������������ ������� �� ��������� �. LS. ����: 45.000.000$"
      elseif str:find("[(���)|(Shot)|(shot)]") and str:find("����� 1") or str:find("�1") then
          return "������ ������ �Burger Shot �1�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[��Ss][Ff��][Ff��][Mm��]") then
        return "������ ���������� � ����������� San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("�����") then
        return "������ ������������ ����������� � �. San Fierro. "..get_price(str, trade_type(str))
      elseif str:find("���������� Burger Shot") then
        return "������ ������ ����������� Burger Shot �1� "..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[��]�[��][���][��][�]?���") or str:find("������") and str:find("Burger%s?Shot") or str:find("[��]��[��]�� [��]��")  then
        return "������ ������ �Burger Shot�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[��]���[�]?�") then
        if str:find("[Gg][Pp][Ss]") then
          return "������ ��������� ����������� �� GPS 8-184. "..get_price(str, trade_type(str))
        end
        return "������ ��������� ����������� � �. Las Venturas. "..get_price(str, trade_type(str))
      end
      return "������ ������ ������������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����") then
      return "������ ������������� �������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") and str:find("[��Ll][��Oo][��sS]") then
      return "������ ������ ������� ���-������. "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") and str:find("[��Ll][��Aa][��sS]") or str:find("[��]����� [��Ll][��Vv]") then
      if str:find("[��]������") then
        return "������ ������� ������� Las Venturas�. "..get_price(str, trade_type(str))
      end
      return "������ ������ ������� Las Venturas�. "..get_price(str, trade_type(str))
    elseif str:find("[��]��[(���)]?") and str:find("[��]��������") or str:find("[��]������[��][��] [��]��") then
      return "������ ������ ���������� ������ � LV. "..get_price(str, trade_type(str))

    elseif str:find("[��]���������� [��]��") then
      return "������ ������ ������������ ���"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") and str:find("[��]��") then
      return "������ ��� ���������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[Tt]he [Cc][Rr][AaEe][Ww]") then
      return "������ ��� �The Craw Bar�"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����(.-) [��]���(.-)") then
      return "������ ������������ �������� � �. Fort Carson. "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") then
      return string.format("������ ��������� ����������%s. %s", get_location(str), get_price(str, trade_type(str)))
    elseif str:find("10 [��]��(.-) [��]���[�]?�[�]?��") or str:find("10 [��]������") then
      return "������ ��� �10 ������ ������� � �. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[��]��[^�]") then
      if str:find("[��]������") then
        return "������ ����-��� ��������"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[��]�� [��]��[�]?������") then
        return "������ ��� �Montgomery�"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      if str:find("[��]��") and str:find("��� ����") then
        return "�� ������� ��������� ������ �����-��� "..get_location(str)..". "
      end

      return "������ ������ ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") or str:find("[Bb]urger") then
      if str:find("[(���)|(Shot)|(shot)]") and str:find("����� 1") or str:find("�1") then
        return "������ ������ �Burger Shot �1�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[��]��") or str:find("����") or str:find("king") then
        return "������ ������ �Burger Shot�"..get_location(str)..". "..get_price(str, trade_type(str))
      end
    elseif str:find("%s%p?[��]��%p?%s") then
      return "������ ������ ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����� [��]���") then
      return "������ ������ ������� �����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("����%s?[��]��") or str:find("[Ss]e[Xx]%p?%s?[Ss]hop") then
      if str:find("�1") or str:find("����� 1") then
        return "������ ������ �Sex Shop �1�"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "������ ������ �Sex Shop�"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("ammo") or str:find("����") or str:find("��������[��]") then
      return "������ ������ �Ammunation�"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]��[�]?[�]?[��]�[�]?[��]") then
      if str:find("[��]��") then
        return "�� ������� ��������� ������ ����������"..get_location(str)
      end
      return "������ ������ ����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����[��]") and str:find("[��]���") then
      return "������ ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��][�]?����[��] [��]�����") or str:find("����� ������") or str:find("��� ������") or str:find("%s[D�][S�C]") then
      -- debug("�������: ������� ������\n"..str, 3)
      if str:find("[��]���") then
        if str:find("[Ss]ub [Uu]rban") or str:find("[��][��]� [��]����") then
          return "�� ������� ��������� ������� ������ �Sub Urban�"..get_location(str)
        end
      end
      
      if str:find("[��]������� [��]����") then
        return "������ ������� ������ ��������� ������ � LV. "..get_price(str, trade_type(str)):gsub("����������.", "����������")
      elseif str:find("[��]��") then
        return "������ ������� ������ � ������� ������. ���� ����������"
      elseif str:find("[Pp]ro[Ll]aps") then
        return "������ ������� ������ �ProLaps�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[D�][S�C]") then
        return "������ ������� ������ �DS�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Zz][Ii][Pp]") then
        return "������ ������� ������ �ZIP�"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[Ss]ub [Uu]rban") or str:find("[��][��]� [��]����") then
        return "������ ������� �Sub Urban�"..get_location(str)..". "..get_price(str, trade_type(str))
      end
      return "������ �������� �������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") then
      if str:find("[��]���[��]���") then
        return "������ �������������� �������� � �. Los Santos. "..get_price(str, trade_type(str))
      end
      return "������ ������ ���������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�����[���][��]") then
      return "������ ������ ����������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]��������� [��]���") then
      return "������ ������ ����������� ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("zip ����") then
      return "������ ������� ������ �ZIP� � ����. "..get_price(str, trade_type(str))
    elseif str:find("[��]�����(.+) �����") and str:find("[(SF)|(��)|[��]]") then
      return "������ ������ ��������� ����� � SF�. "..get_price(str, trade_type(str))
    elseif str:find("[��]����� ������� � ������") then
      return string.format("������ ������� �24/7� %s. %s", get_location(str), get_price(str, trade_type(str)))
    --elseif str:find("")
    else
      print("{cc0000}ERROR 6:{b2b2b2}", str)
      return "ERROR"
    end
  elseif str:find("[��][��]��[��]") and str:find("[��]����") then
    return "�� ��������� �������� ������� �����������. �������."
  elseif str:find("[��][��]��[��]") and str:find("[��]����") or str:find("TAXI") then
    if str:find("[��Ss][��Ff]") or str:find("[��]�� [��]�����") or str:find("[Ss]an [Ff]ierro") then
      taxi_loc = "����� SF"
    elseif str:find("[��Ll][��Ss]%s[^|]") or str:find("[��]�� [��]����") then
      taxi_loc = "����� LS"
    elseif str:find("[��Ll][��VV]") then
      taxi_loc = "����� LV"
    else
      taxi_loc = "���������"
    end
    if str:find("%s[��][��]%s") then
      taxi_info = "��� �� ����������!"
    else
      taxi_info = "�������!"
    end
    if str:find("����� ������� �����") then
      return "�� "..taxi_loc.." �������� ����� ������� �����. "..taxi_info
    elseif str:find("������� �����") then
      return "�� "..taxi_loc.." �������� ������� �����. "..taxi_info
    elseif str:find("�������� �����$") then
      return "�� "..taxi_loc.." �������� �����. �������."
    else
      taxi_name = get_taxi_name(str)
    end
    return "�� "..taxi_loc.." �������� �����"..taxi_name..". "..taxi_info
  elseif str:find("(.-)�[��][�]?�") or str:find("(.-)��[��]?�") or str:find("���") or str:find("(.-)���") or str:find("[Bb]uy") or str:find("[kK][uy]pl[y]?u") then
    if str:find("[��]��") then
      return "����� ������ ����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����") then
      return "����� ������ ������-����"..". "..get_price(str, trade_type(str))
    elseif str:find("[��]���") then
      return "����� ������ �����"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]������") then
      return "����� ������ ������������"..". "..get_price(str, trade_type(str))
    elseif str:find("[��]���") and str:find("[��]��") then
      return "����� ������ ��������� ����������� � �. Los Santos. "..get_price(str, trade_type(str))
    elseif str:find("[��]����") then
      return "����� ������ ������������"..". "..get_price(str, trade_type(str))
    elseif str:find("[��]���%p?%s?[��]��") or str:find("[Ss]ex%s?%p?[Ss]hop") then
      return "����� ������ �Sex-Shop�"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�����") then
      return "����� ������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") and str:find("[��]������") then
      return "����� �������� � ����� ��������-���� � SF. "..get_price(str, trade_type(str))
    elseif str:find("[��]�������") then
      return "����� ������ ���������"..". "..get_price(str, trade_type(str))
    elseif str:find("[��]����� [��]���") then
      return "����� ������ ������� �����������"..". "..get_price(str, trade_type(str))
      
    elseif str:find("[��]���") and str:find("[��]����") then
      return "����� ��������� ������� �Ammunation�"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("%s[����][��]?��%s?") or str:find("%s���%s") or str:find("������") or str:find("[��]����[�]?�") or str:find("[Bb][iI][zZ]") or str:find("[Bb]us[s]?in") then
      if str:find("����") then
        return action[trade_type(str)].."���������� ������"..get_location(str)..". "..get_price(str, trade_type(str))
      else
        return action[trade_type(str)].."������"..get_location(str)..". "..get_price(str, trade_type(str))
      end
    end
  elseif str:find("[��]������") or str:find("[��][��]���[��]��") or str:find("[��]����[���]") or str:find("[��]� %w+ %w+%p") then
    chatDebug("�������� �����!")
    str = str:gsub("\"", "�", 1):gsub("\"", "�"):gsub("!!!", "!"):gsub("%w%w | ", "")
    return str
  elseif str:find("%s[��][��]%s") then
    if str:find("[Rr]ifa") then
      return "��� ����� � �� �The Rifa� | GPS 4-4 | ���!"
    end
  elseif str:find("Cluckin Bell � ��") then
    if str:find("������ ������") then
      return "������ ������? ���� � �Cluckin Bell � �Ի �������� �� SFFM!"
    end
  elseif str:find("����� ������ � Montgomery") then
    if str:find("������ ���� �����") then
      return "������ ���� ����� - ������� ������ � ������ ������ � Montgomery�"
    end
  elseif str:find("� ������ ������� [��]�������") then
    if str:find("[��]����� ���� �����") then
      return "������ ���� ����� � �C����� �������� �. Palomino Creek."
    elseif str:find("������ ���� �� ���") then
      return "������ ���� �� ���������� � �C����� �������� �. Palomino Creek."
    end

  else
    print("{cc0000}ERROR 7 (1):{b2b2b2}", str)
    return "ERROR"
  end
  print("{cc0000}ERROR 7 (2):{b2b2b2}", str)
  return "ERROR"
end

function trade_type(str)
  if str:find("(.-)[��yY][��]?[����][�]?[��][��]?�") or str:find("[��]���.") or str:find("[kK][uy]pl[y]?u") or str:find("[��]�����") or str:find("[��]������") or str:find("^[��]��") or str:find("(.-)[��][��][����][����]") or str:find("kyply") or str:find("[��]�[�]?��") or str:find("[Bb]uy") or str:find("[��]���") or str:find("[��]���") then
    print(str)
    return "buy"
  elseif str:find("(.-)[�o�][�d][a��][�m]") or str:find("[��]��[��]��") or str:find("[��]�[�]?[��]�[�]?[��][��]") or str:find("^[��]��[��]") or str:find("[Pp]rodam") or str:find("(.-)�����") or str:find("(.*)��(.*)[��]�") or str:find("����") or str:find("����") or str:find("����") or str:find ("[��]�����") or str:find ("[��][��][��]��") or str:find("(.-)ell") or str:find("^[��][��][��][��]") or str:find("[Gg]hjlfv") then
    return "sell"
  elseif str:find("[��]���[��]��") or str:find("[��]��") or str:find("[��]� ���[�]?") or str:find("[��]�������") then
    return "auction"
  elseif str:find("[��]��[�]?�") then
    if str:find("��[���][�]? [(��)|(�������)|(��������)|(��)]") or str:find("���� ��") then
      return "my_change"
    elseif str:find("����� �[�]?�") or str:find("���� �[�]?�") or str:find("[��]��(.-)%s[��][��]?[��]") then
      return "ur_change"
    elseif str:find("� [��][��]$") then
      return "d_change"
    else
      return "change"
    end
  elseif str:find("�����") or str:find("�[��]�[��]�") then
    return "carmarket"
  else
    return ""
  end
end

function get_taxi_name(str)
  if str:find("�������� [��][��]") then
    taxi_n = " ����������-�ѻ"
  elseif str:find("����� \".*\"") then
    taxi_n = str:match("����� \"%s?(.*)\"")
  elseif str:find("�������� \".*\"") then
    taxi_n = str:match("�������� \"%s?(.*)\"")
  elseif str:find("�������� .+ �����[.]?") then
    taxi_n = str:match("�������� (.+) �����[.]?")
  elseif str:find("����� .+") then
    taxi_n = str:match("����� (.+) [��]")
  else
    taxi_n = ""
  end
  sampAddChatMessage(string.format("�������� �����: %s", taxi_n or "error"), 0xAFBB77)
  return string.format(" �%s�", taxi_n or "error")
end

--=================[SIM-CARD]=================--

function get_simcard_fmt(str)
  --debug("SIM", 2)
  --������ ��� 990999 1kk
  str = str:gsub("�", ""):gsub("�", "")
  if str:find("[��][�]?���[�]?[���]?[��]? \".+\"") then
    print("SIM FORMAT ID 1")
    format = str:match("[��][�]?���[�]?[���]?[��]? \"(.+)\"")

  elseif str:find("[��][�]?���[�]?[��]?[�]? .-[,.]%s%W+") then
    print("SIM FORMAT ID 2")
    format = str:match("[��][�]?���[�]?[��]?[�]? (.-)[,.]")
    
  elseif str:find("[��][�]?���[�]?[��]?[�]? ''(.+)''%p[��]?.+$") then
    print("SIM FORMAT ID 3")
    format = str:match("[��][�]?���[�]?[��]?[�]? ''(.+)''%p[��]?.+$")

  elseif str:find("[��][�]?���[�]?[��]?[�]? (.+) [��]?.+$") then
    print("SIM FORMAT ID 4")
    format = str:match("[��][�]?���[�]?[��]?[�]? (.+) [��]?.+$")

  elseif str:find("[��][�]?���[�]?[��]?[�]? (.-)%s") then
    print("SIM FORMAT ID 5")
    format = str:match("[��][�]?���[�]?[��]?[�]? (.-)%s")

  elseif str:find("[��][�]?���[�]?[��]?[�]? (.-)$") then
    print("SIM FORMAT ID 6")
    format = str:match("[��][�]?���[�]?[��]?[�]? (.-)$")
  elseif str:find("[��][�]?���[�]?[��]?[�]?%p (.-)[.,]") then
    format = str:match("[��][�]?���[�]?[��]?[�]?%p (.-)[.,]")
    
  elseif str:find("[��][�]?���[�]?�� (.-)$") then
    format = str:match("[��][�]?���[�]?�� (.-)$")
  elseif str:find("�[�]?[��][��]�[��]%s%W+%s%W+%s%W+%s����") then
    format = str:match("�[�]?[��][��]�[��]%s(%W+%s%W+%s%W+)%s����"):gsub(" ", "")
  elseif str:find("�[�]?[��][��]�[��] .-[,.]?%s") then
    format = str:match("�[�]?[��][��]�[��] (.-)[,.]?%s")

  elseif str:find("�[�]?[��][��]�[��] .-[,.]") then
    debug("SIM3", 2)

    format = str:match("�[�]?[��][��]�[��] (.-)[,.]")
  elseif str:find("�[�]?[��][��]�[��] %d+%s") then
    format = str:match("�[�]?[��][��]�[��] (%d+)%s")
  elseif str:find("�[�]?[��][��]%s?�[��] %d+$") then
    debug("SIM2", 2)
    format = str:match("�[�]?[��][��]%s?�[��] (%d+)$")
    --if format:find("%p") then debug("DELETE SYMBOL", 4) format:gsub("-", "") end
  elseif str:find("�[�]?[��][��]�[��]%s.-[,.]?%s") then
    debug("SIM", 2)
    format = str:match("�[�]?[��][��]�[��]%s(.-)[,.]?%s"):upper()
  elseif str:find("�[�]?[��][��]�[��] .-$") then
    format = str:match("�[�]?[��][��]�[��] %s?(.+)$")
    debug("3333", 2)
  elseif str:find("[Cc��][a�][r�][d�] .+[,.]") then --����� Sim-card xxx-xxx
    format = str:match("[Cc��][a�][r�][d�] (.+)[,.]")
  elseif str:find("[Cc��][a�][r�][d�] %d+$") then
    format = str:match("[Cc��][a�][r�][d�] (%d+)$")
  elseif str:find("[Cc��][a�][r�][d�] (.-)$") then
    format = str:match("[Cc��][a�][r�][d�] (.-)$")
    -- debug(format, 1)

  elseif str:find("[Cc��][a�][r�][d�]%s.+%s") then
    format = str:match("[Cc��][a�][r�][d�]%s(.+)%s"):upper()
  elseif str:find("�����%s[^(�����)].-%s") then
    format = str:match("�����%s(.-)%s"):upper():gsub("%p", "")
    debug(format, 1)
  elseif str:find("�����%s[^(�����)].+$") then
    format = str:match("�����%s(.-)$"):upper()
    
  elseif str:find("������� .+%s�") then
    format = str:match("������� (.+)%s�")
  elseif str:find("������� .+$") then
    format = str:match("������� (.+)$")
  elseif str:find("����� \".+\"") then
    format = str:match("����� \"(.+)\"")
  elseif str:find("[��]����%s.+%s�") then
    format = str:match("[��]����%s(.+)%s�")
  elseif str:find("����� .+%p") then
    format = str:match("����� (.-)%p")
  elseif str:find("����� .+%s") then
    format = str:match("����� (.+)%s")
  elseif str:find("����� .+$") then
    format = str:match("����� (.+)$")
  elseif str:find("[Ss][Ii][Mm][k]?%s.+%s") then
    format = str:match("[Ss][Ii][Mm][k]?%s(.+)%s")
  elseif str:find("[Ss][Ii][Mm][k]?%s.+$") then
    format = str:match("[Ss][Ii][Mm][k]?%s(.+)$")
  elseif str:find("%s%d+%s����[��]$") then
    format = str:match("%s(%d+)%s����[��]$")
  elseif str:find("[��]�����%s%d+%s") then
    format = str:match("[��]�����%s(%d+)%s")
  -- elseif str:find("���%s.-%p?%s") then
  --   format = str:match("���%s(.-)%p?%s")
  elseif str:find("[��]�� .-,") then --����� Sim-card xxx-xxx
    format = str:match("[��]�� (.-),") print("��� 1")
  elseif str:find("[��]�� %d+$") then
    format = str:match("[��]�� (%d+)$")  print("��� 2")
  elseif str:find("[��]�� (.-)%s") then
    format = str:match("[��]�� (.-)%s")  print("��� 3")
  elseif str:find("[��]�� (.-)$") then
    format = str:match("[��]�� (.-)$")  print("��� 4")
  elseif str:find("[��]�� (.-) (.-)$") then
    format = str:match("[��]�� (.-) (.-)$")  print("��� 5")
  elseif str:find("[��]��%s.-%s") then
  else
    format = nil
  end
  if format ~= nil then 
    if format:find("����") then format = format:gsub(" ����", "") end
  end
  if format ~= nil and format:find("[0-9]") then
    if format:find("%-") then chatDebug("�����") format = format:gsub("%-", "") end
    print(format)
    format = replace_numbers(format)
  end
  return format:gsub("<<", ""):gsub(">>", ""):gsub("�", "X"):gsub("�", "Y"):gsub("�", "O"):gsub(" ", ""):gsub("����", ""):gsub("����", "")
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
  if str:find("[��]%s����%p?%s?") then
    text = str:match("[��]%s����%p?%s?(.*)[.]?")
    return "� ����: "..text
  elseif str:find("[��]%s����%s") then
    text = str:match("[��]%s����%s(.+)"):gsub(".", "")
    return "� ����: "..text
  else
    return "������� ���!"
  end
end

function location(str, type, act, house_type)
  if type == "ammo" then
    --debug("AMMO", 2)
    if str:find("Fier") or str:find("fier") or str:find("(%s?)11(%s?)-(%s?)6(%s?)") then
      return ammunations_strings[math.random(1,2)]
    elseif str:find("��������� �������� �� �1") then
      if str:find("������� ������") then
        return "������� ������ � ���������� �������� �� �1�. ��� ���! GPS 11-1"
      -- elseif str:find("������� �����������") then
      --   return "������� ����������� � ���������� �������� Angel Pine� | GPS 11-3"
      end
    elseif str:find("ngel") and str:find("ine") then
      if str:find("�� �����") then
        return "������� �����, ������ ���� - �AMMO Angel Pine� | GPS 11-3"
      elseif str:find("������� �����������") then
        return "������� ����������� � ���������� �������� Angel Pine� | GPS 11-3"
      elseif str:find("[��]����[��]") then
        return "������ ������� ������ �AMMO Angel Pine�. ����: ����������"
      else
        return "����� ������ ���� �� ������ � ����� Angel Pine� | GPS 11-3"
      end
    elseif str:find("[Ff��][o�][r�][t�]") and str:find("[Cc��][a�][r�][s�]") then
      if str:find("����� ���������� ����") then
        return "���������� ���� �� �������� ������ � �AMMO Fort Carson� GPS 8-268"
      elseif str:find("������� ������") then
        return "� ���������� �������� Fort Carson� ������� ������! | GPS 11-5"
      elseif str:find("�������� �� 750") then
        return "�������� �� 750$ � ���������� �������� Fort Carson� | GPS 11-5"
      end
    elseif str:find("(.-)[��][��][�]?[��][�]?�") or str:find("(.-)[��][��][��][����]") or str:find("kyply") or str:find("[��]�[�]?��") or str:find("[Bb]uy") or str:find("[��]���") or str:find("[��]���") then
      return "����� ��������� ������� �Ammunation�"..get_location(str)..". "..get_price(str, trade_type(str))
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
    if str:find("�����") or str:find("����") then
      if str:find("[��]��[�]�") then
        return "������ �������� ������ �� GPS 8-57 | "..get_price(str, trade_type(str))
      elseif str:find("GPS%s8[-]57") then
        return "������ ������ ��������� � �. Los Santos - GPS: 8-57. "..get_price(str, trade_type(str))
      elseif str:find("�� ������ �����[�]?��") then
        return "������ ��� ������ ��������"..get_location(str)..". "..get_price(str, trade_type(str))
      elseif str:find("[��]���[�]?������") then
        return "������ �������� ����������� � �. Marina, LS. "..get_price(str, trade_type(str))
      end
      return action[trade_type(str)].."��������"..get_location(str)..". "..get_price(str, trade_type(str))
    elseif str:find("[��]���� [��]����") or str:find("Marin[ae]") or str:find("[Pp]rice%p?%s%p?6%s?%p%s?4") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 6-4"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-85"
      end
      if str:find("����� ������ ������") then
        return "������ ������ ������? �������� ����� ����! | �������� � �. Marina"
      elseif str:find("������� ���� ������") then
        return "������� ���� ������? ������� � �������� ������! �� � �.Marina."
      elseif str:find("����� ����� ��� � (.+) [��]��������") then
        return "����� ����� ��� � ����������� ��������� | "..biz_loc
      elseif str:find("����� ����� ��� ����") then
        return "����� ����� ��� ����-�� ����������� ��������� | "..biz_loc
      elseif str:find("��� ��� � ����[�]?� �������") then
        return "������� ��� � ������ ������� ���� ���� � ��������� LS | "..biz_loc
      elseif str:find("����� ��� ��� � ����[�]?� �������") then
        return "����� ��� ��� � ����� ������� ���� ���� � ��������� LS! "..biz_loc
      elseif str:find("��������� �����") then
        return "����������, ��������� ����� � ��������� � �. Marina | "..biz_loc
      end 
    elseif str:find("��� ������") or str:find("��%s?��") then
      if str:find("GPS%p?%s8%s?%p?%s?57") then
        if str:find("������� ���� ���� � �����") then
          return "�������� ���� ���� � ����� ���������� ��� ������� | GPS 8-57"
        elseif str:find("���������� ����") then
          return "���������� ���� � ��������� � ���� | GPS 8-57"
        end
      end
    elseif str:find("���") and str:find("��������") then
      if str:find("������� ���� � ���������") then
        return "�������� ���� � ��������� � �������� Las Venturas. ������ ����!"
      end
    elseif str:find("8-28") or str:find("-(%s?)28") or str:find("[Pp]rice%s?%p?6%s?%p%s?2") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 6-2"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-28"
      end
      if str:find("���������� � ����") then
        return "���������� � ���� ������ �������� � �. Los Santos. "..biz_loc
      elseif str:find("������� �������� ������") then
        return "������� �������� ������ � ����� ������ �������� LS�. "..biz_loc
      elseif str:find("����� ����� ����� ��") then
        return "����� ����� ����� �� � ����� ������ �������� � LS�. "..biz_loc
      elseif str:find("����� ����� ��� �����") then
        return "����� ����� ��� ����� �� � ����� ������ �������� LS�. "..biz_loc
      elseif str:find("����� ����� �����") then
        return "����� ����� ����� � ����� ������ �������� � LS. "..biz_loc
      elseif str:find("[��]����� ������� ��� ����") then
        return "������ ������� ��� ���� ��? ���� ������ �������� � �ѻ. "..biz_loc
      elseif str:find("������ ��������� �������") then
        return "������ ��������� �������? ���� � ��� ������ �������� LS. "..biz_loc
      elseif str:find("������ ���� ��� ����� ���") then
        return "������ ���� ��� ����� ���? ��� � ��� ������ �������� LS. "..biz_loc
      elseif str:find("����� �����") and str:find("����") then
        return "����� ����� ������ � ����� ������ �������� LS�. "..biz_loc
      elseif str:find("������ Cash Back �� �����") then
        return "������ Cash Back �� ����� � ����� ������ �������� LS�. "..biz_loc
      elseif str:find("���� � �����") then
        return "���� � �����? ��� � ���� ������ �������� LS� ����� ����. "..biz_loc
      elseif str:find("������ ������� ��� [��]�����") then
        return "������ ������� ��� ������? ��� � ��� ������ �������� ��. "..biz_loc
      elseif str:find("����� ����� �������") then
        return "����� ����� ������� � ����� ������ �������� �ѻ. "..biz_loc
      elseif str:find("������ ���� �������") then
        return "������ ���� �������? ���� � ���� ������ �������� �ѻ. "..biz_loc
      elseif str:find("��������� �����") then
        return "������� � ���� ������ �������� �ѻ � ��������� �����. "..biz_loc
      end

    elseif str:find("[Gg][Pp][Ss]%s8%s?[>-]%s?57") then
      if str:find("����� ����� ���") then
        return "����� ����� ��� � ����� ������� ����� Los Santos | GPS 8-57"
      elseif str:find("���� ����� � ����") then
        return "�������� ���� ����� � ���� � ������� ������ | GPS 8-57"
      elseif str:find("������ ������") then
        return "������ ������ ������? ������� ����� ���� �������! | GPS 8-57"
      elseif str:find("������ ����� ����") then
        return "������ ����� ��� ����� � ��������� � ���� | GPS 8-57"
      elseif str:find("������� ����[��]����") then
        return "������� ��������� � �������� � ���� | GPS 8-57"
      end
    elseif str:find("[Gg][Pp][Ss]%p?%s?8%s?[>-]%s?7") then
      if str:find("����� ����� ��� �����") then -- ����� ����� ��� ����� ���� � "��������� � �����".GPS:8-7.
        return "����� ����� ��� ����� ���� � ���������� �����. GPS 8-7"
      elseif str:find("������ �����, ����%p��, ���������") then
        return "������ �����, ����-��, ��������� � ���������� �����. GPS 8-7"
      elseif str:find("���������� �� 400") then
        return "���������� �� 400$ ������ � ���������� ����� | GPS 8-7"
      elseif str:find("���� �� �����") then
        return "���� �� �����? ����� ����-�� � ��� � ����! | GPS 8-7"
      elseif str:find("���� �� ������ �����������") then
        return "����� ����-�� � ����� ���� � ���� �� ������ �����������. GPS 8-7"
      end
    elseif str:find("[Pp]rice%s?%p?6%s?%p%s?3") then
      if str:find("����� ���") then
        return "������ ������� ��� ����� ���? ������ ����� ��� � ���! | Price 6-3"
      elseif str:find("C���� ������ ������ � ���") then
        return "C���� ������ ������ ������� �����. �� � ��������� LS! Price 6-3"
      end
    elseif str:find("[Pp]rice%s6%s?[>-]%s?8") or str:find("[Gg][Pp][Ss]%s8%s?[>-]%s?262") then
      if str:find("[Pp]rice") then
        biz_loc = "Price 6-8"
      elseif str:find("[Gg][Pp][Ss]") then
        biz_loc = "GPS 8-262"
      end
      if str:find("����� ���� ������[��]�") then
        return "����� ���� ��������? ��� ������ �������� ������� ����! "..biz_loc
      elseif str:find("�������� ������ � ����") then
        return "�������� ������ � ���� ������ �������� | "..biz_loc
      elseif str:find("����� �����") then
        return "����� ����� �����-�� � ���� ������ �������� � LV. "..biz_loc
      elseif str:find("���������� � ���� ������") then
        return "���������� � ���� ������ �������� � LV. | "..biz_loc
      elseif str:find("����� ���������� �����") then
        return "����� ���������� ����� � ���� ������ �������� � LV. |"..biz_loc
      elseif str:find("�������� � ���� � ����") then
        return "������ ��������, ����� �������� � ���� � ����. | "..biz_loc
      elseif str:find("�������� ����") then
        return "������ � ��� ������ �������� �������� ����. | "..biz_loc
      elseif str:find("�������� ���� ����� � �������") then
        return "�������� ���� ����� � �������: ��� ������ �������� LV | "..biz_loc
      elseif str:find("�[��][��]����� ���� ������� �") then
        return "�������� ���� ������� � ���� ������ �������� � LV. | "..biz_loc
      elseif str:find("�������� ���� ����� � ���� ������ ��������") then
        return "�������� ���� ����� � ���� ������ �������� � LV. | "..biz_loc
      elseif str:find("������ ��������, ���� ��������") then
        return "������ ��������, ���� � ��� ������ �������� LV. | "..biz_loc
      elseif str:find("����� ����� � ���") then
        return "����� ����� � ���, ������ ������������, � ��� �����. | "..biz_loc
      elseif str:find("����� ������ ���� �� ����������") then
        return "����� ������ ���� �� ���������� � ���� LV. | "..biz_loc
      elseif str:find("�����[�]?��[,%?] ������� � ���") then
        return "�������? ������� � ��� ������ ���� �����, ���� �����. | "..biz_loc
      elseif str:find("������ ������ �����") then
        return "�������? ����� � ��� - ������ ������ �����. �� � LV "..biz_loc
      elseif str:find("������ ���� ���������") then
        return "������ ���� ���������? ������ � ��� - �����������. | "..biz_loc
      elseif str:find("������ ���� �����������") then
        return "������ ���� �����������? ����� � ��� � ��� - ���������! "..biz_loc
      elseif str:find("����� � ��� �����������") then
        return "������ ���� �����������? ����� � ��� - �����������. | "..biz_loc
      end

    elseif str:find("ort") and str:find("arson") then
      if str:find("� �����") then
        return "������ �������� ���� � �����? ���� � �������� � �. Fort Carson!"
      elseif str:find("����") then
        return "���������� ���� ������ � �����-���� � �. Fort Carson. ���� ���!"
      end
    end
  end
end

function clothes(str, act)
  debug("������: "..str, 1)
  --3 �����
  --������ ����� 272 208 99
  if str:find('%d+%p%s%d+%p%s%d+%p') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)%p", 3, 31)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%s%d+%p%s%d+%s') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)%s", 3, 31)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%s(%d+)$", 3, 320)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%s%d+%p%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%p%s(%d+)%p%s(%d+)$", 3, 319)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[^(������)]%s%d+%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%s(%d+)$", 3, 32)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%p%d+%p%d+%s') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%s", 3, 33)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    --����� ������ 240, 294, 295 �������
  elseif str:find('������%s%d+%p%d+%p%d+%p?$') then    --����� ������ ������ 303,304,305
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p?$", 3, 34)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(������)]%s%s%d+%p?%s%d+%p?%s%d+%p?%s?') then
    --toast.Show(u8'3', toast.TYPE.WARN, 5)
    clothes_ids = get_clothes_id(str, "%s(%d+)%p?%s(%d+)%p?%s(%d+)%p?%s?", 3, 35)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    --����� ���� 109, 115 � 114
  elseif str:find('%s%d+%p?%s%d+%s[�&]%s%d+%s?') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p?%s(%d+)%s[�&]%s(%d+)%s?', 3, 36)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    --������%s\"%d+\"%s\"%d+\"%s\"%d+\"%
    -- ����� "102, 116, 309".
  elseif str:find('%s\"%d+%p%s%d+%p%s%d+\"%p') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)%p%s(%d+)%p%s(%d+)\"%p", 3, 360)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s\"%d+\"%s\"%d+\"%s\"%d+\"%p?') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)\"%s\"(%d+)\"%s\"(%d+)\"%p?", 3, 37)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s\"%d+\"%p%s\"%d+\"%p%s\"%d+\"%p') then
    clothes_ids = get_clothes_id(str, "%s\"(%d+)\"%p%s\"(%d+)\"%p%s\"(%d+)\"%p", 3, 311)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%p%d+%p%d+%p^[%$]') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p^[%$]", 3, 38)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('�%d+%s�%d+%s�%d+') then
    clothes_ids = get_clothes_id(str, "�(%d+)%s�(%d+)%s�(%d+)", 3, 38)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('�%d+%p%s�%d+%s[�&]%s�%d+') then
    clothes_ids = get_clothes_id(str, "�(%d+)%p%s�(%d+)%s[�&]%s�(%d+)", 3, 384)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%s%d+%s%d+%s�����') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%s(%d+)%s�����", 3, 38)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(���)|(���:)]%s%d+%p%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)$", 3, 39)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(���)|(���:)]%s%d+%p%d+%p%d+%s[(�����)]') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)", 3, 310)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[^(���)|(���:)]%s%d+%p%d+%p%d+%p[^%$]') then
    clothes_ids = get_clothes_id(str, "(%d+)%p(%d+)%p(%d+)%p", 3, 311)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%d+%s%d+[,]%d+$') then
    clothes_ids = get_clothes_id(str, "(%d+)%s(%d+)%p(%d+)$", 3, 312)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('^%W-%s%d+%s%d+%s%d+%s%W-$') then
    clothes_ids = get_clothes_id(str, '^%W-%s(%d+)%s(%d+)%s(%d+)%s%W-$', 3, 313)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%s%d+%p%s%d+%s%p%s%d+') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p%s(%d+)%s%p%s(%d+)', 3, 314)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  --[WORD EXPRESSIONS]
  elseif str:find('[(������)|(������)]%s%d+%p%s%d+%p%s%d+') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%p%s(%d+)%p%s(%d+)', 3, 315)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(������)|(������)]%s�%d+%p%s�%d+%p%s�%d+') then
    clothes_ids = get_clothes_id(str, '%s�(%d+)%p%s�(%d+)%p%s�(%d+)', 3, 316)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(������)]%s%d+%s?%s%d+%s?%s%d+$') then
    clothes_ids = get_clothes_id(str, '[(������)]%s(%d+)%s?%s(%d+)%s?%s(%d+)$', 3, 317)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('\"%d+%s?%p%s?%d+%s?%p%s?%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%s?%p%s?(%d+)%s?%p%s?(%d+)\"", 3, 318)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    -- ������ ����� 116 125 126 ��� 1991
  elseif str:find('[(�����)|(�������)|(������)|(�����)|(������)]%s%d+%s%d+%s%d+') then
    clothes_ids = get_clothes_id(str, "[(�����)|(�������)|(������)|(�����)|(������)]%s(%d+)%s(%d+)%s(%d+)", 3, 318)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('[��]���[��]%s%d+%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "[��]���[��]%s(%d+)%s(%d+)%s(%d+)$", 3, 318)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('����� %d+, %d+, %d+$') then
    -- ������ ����� 104, 110, 286
    clothes_ids = get_clothes_id(str, "����� (%d+), (%d+), (%d+)$", 3, 321)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('������ �%d+ ,�%d+ � �%d+.') then
    -- ������ ������ � ������ �188 ,�189 � �299. ���� ����������.
    clothes_ids = get_clothes_id(str, "������ �(%d+) ,�(%d+) � �(%d+).", 3, 322)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('%W+ ������ %d+, %d+ ,%d+ %W+$') then
    -- ����� ������ 240, 294 ,295 �������
    clothes_ids = get_clothes_id(str, "%W+ ������ (%d+), (%d+) ,(%d+) %W+$", 3, 323)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('������ %d+%s%p%s%d+%s�%s%d+$') then
    clothes_ids = get_clothes_id(str, "������ (%d+)%s%p%s(%d+)%s�%s(%d+)$", 3, 324)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('����� %p%d+%p%d+%p%d+%p') then
    clothes_ids = get_clothes_id(str, "����� %p(%d+)%p(%d+)%p(%d+)%p", 3, 325)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
  elseif str:find('�%d+%p %d+ � %d+') then
    clothes_ids = get_clothes_id(str, "�(%d+)%p (%d+) � (%d+)", 3, 326)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act) 
    
    --[��]���[��]%s%d+%s%d+%s%d+$
  --2 �����

  elseif str:find('�����%s%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "�����%s(%d+)%p(%d+)$", 2, 21)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(������)|(������)]^[����]%s%d+%p%s?%d+%s?') then
    clothes_ids = get_clothes_id(str, "[(������)|(������)]^[����]%s(%d+)%p%s?(%d+)%s?", 2, 22)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[��]�����%s%d+%s�%s%d+$') then
    clothes_ids = get_clothes_id(str, "[��]�����%s(%d+)%s�%s(%d+)$", 2, 23)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('^%d+%s%d+%s�����$') then
    clothes_ids = get_clothes_id(str, '^(%d+)%s(%d+)%s�����$', 2, 23)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)

  elseif str:find('�%s%d+%p%s%d+%s�') then
    clothes_ids = get_clothes_id(str, "�%s(%d+)%p%s(%d+)%s�", 2, 25)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('������%s%d+%s%d+%s') then
    clothes_ids = get_clothes_id(str, "������%s(%d+)%s(%d+)%s", 2, 26)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  -- ������ ���� 107 103
  -- ������ ���� 107,86
  elseif str:find('^%W+%s����%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "^%W+%s����%s(%d+)%s(%d+)$", 2, 2700)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('^%W+%s����%s%d+%p%d+$') then
    clothes_ids = get_clothes_id(str, "^%W+%s����%s(%d+)%p(%d+)$", 2, 2700)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('�%s%W-%s�%d+%p%s%d+%p%s?%W+') then -- ������ ������ � ������� �124, 126. ����: ����������.
    clothes_ids = get_clothes_id(str, "�%s%W-%s�(%d+)%p%s(%d+)%p%s?%W+", 2, 2700)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
    -- 306 ����� � 309
  elseif str:find('%s%d+%s%W+%s�%s%d+%s') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%s%W+%s�%s(%d+)%s', 2, 2700)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s���%s%d+%s') then
    clothes_ids = get_clothes_id(str, '%s(%d+)%s���%s(%d+)%s', 2, 27)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+%p%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%p(%d+)\"", 2, 28)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+%s%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)%s(%d+)\"", 2, 281)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%s\"(%d+)\"", 2, 29)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%p%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%p%s\"(%d+)\"", 2, 291)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s%d+%s����$') then 
    clothes_ids = get_clothes_id(str, "%s(%d+)%s(%d+)%s����$", 2, 210)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%d+%s[��]%s%d+$?') then
    clothes_ids = get_clothes_id(str, "(%d+)%s[��]%s(%d+)", 2, 211)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[^(����)]%s%d+%p+%d+%s[^(��)]") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+(%d+)%s", 2, 212)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[^(������)]%s%d+%s+%d+%s") then
    clothes_ids = get_clothes_id(str, "(%d+)%s+(%d+)%s", 2, 213)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("^[(�)|(�)���]%s%d+%p+%s?%d+$") then
    clothes_ids = get_clothes_id(str, "(%d+)%p+%s?(%d+)$", 2, 214)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+%p+%s?%d+%p%s?�") then
    clothes_ids = get_clothes_id(str, "%s(%d+)%p+%s?(%d+)%p", 2, 215)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("�%d+%p+%s?%d+$") then
    clothes_ids = get_clothes_id(str, "�(%d+)%p+%s?(%d+)$", 2, 216)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("�%d+%s�%s�%d+$?") then
    clothes_ids = get_clothes_id(str, "�(%d+)%s�%s�(%d+)$?", 2, 217)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("�%d+%p�%d+$?") then
    clothes_ids = get_clothes_id(str, "�(%d+)%p�(%d+)$?", 2, 217)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('\"%d+\"%s�%s\"%d+\"') then
    clothes_ids = get_clothes_id(str, "\"(%d+)\"%s�%s\"(%d+)\"", 2, 218)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("����%s%d+%p%s%d+[^(��)]") then
    clothes_ids = get_clothes_id(str, "����%s(%d+)%p%s(%d+)", 2, 219)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+, %d+$") then
    clothes_ids = get_clothes_id(str, "(%d+), (%d+)$", 2, 220)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("%s%d+, %d+%s?[^%p|(kk)]$") then
    clothes_ids = get_clothes_id(str, "(%d+), (%d+)%s?[^%p]", 2, 221)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[��]�����%s%d+%s%d+$") then
    clothes_ids = get_clothes_id(str, "[��]�����%s(%d+)%s(%d+)$", 2, 229)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("������%s%d+[.] %d+$") then
    clothes_ids = get_clothes_id(str, "(%d+)[.] (%d+)$", 2, 222)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("�%d+%p?%s�%d+$?") then
    clothes_ids = get_clothes_id(str, "�(%d+)%p?%s�(%d+)$?", 2, 223)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find("[(������)]%s%d+%p%d+$") then
    clothes_ids = get_clothes_id(str, "[(������)]%s(%d+)%p(%d+)$", 2, 224)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(�����)|(�������)|(������)]%d+%s[-]%s%d+$?') then
    clothes_ids = get_clothes_id(str, "[(�����)|(�������)|(������)](%d+)%s[-]%s(%d+)", 2, 227)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(�����)|(�������)|(������)]%s%d+,%d+$') then
    clothes_ids = get_clothes_id(str, "[(�����)|(�������)|(������)]%s(%d+),(%d+)$", 2, 225)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(�����)|(�������)|(������)|(�����)|(������)][^(����)]%s%d+%s%d+$') then
    clothes_ids = get_clothes_id(str, "[(�����)|(�������)|(������)|(�����)|(������)][^(����)]%s(%d+)%s(%d+)$", 2, 226)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%s%d+%s%d+%s[(�����)|(�����)]') then
    clothes_ids = get_clothes_id(str, "%s(%d+)%s(%d+)%s[(�����)|(�����)]", 2, 226)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('%W+ �%d+ & �%d+.') then
    clothes_ids = get_clothes_id(str, "%W+ �(%d+) & �(%d+).", 2, 226)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('[(�����)|(�������)|(������)]%s\"%d+,%s?%d+\"%p') then
    clothes_ids = get_clothes_id(str, "[(�����)|(�������)|(������)]%s\"(%d+),%s?(%d+)\"%p", 2, 228)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
  elseif str:find('^%w+ skin %d+ %d+$') then
    clothes_ids = get_clothes_id(str, '^%w+ skin (%d+) (%d+)$', 2, 229)
    h_string = action[act].."������ � ������� "..clothes_ids..". "..get_price(str, act)
    --debug(h_string, 2)
  --elseif str:find("%d+ ��") or str:find("%d+ ����") then
    --h_string = action[act].."������ � ������ "..get_price(str)
  --1 ����
  elseif str:find("[��]�����%s%d+$") then skin_id = str:match("[��]�����%s(%d+)$")
   --"Clothe: 1", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("[��]�����%s%d+%s%d+��$") then skin_id = str:match("[��]�����%s(%d+)%s%d+��$")
    --"Clothe: 1", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("[��]�[�]?�[��]%s%d+$") then skin_id = str:match("[��]�[�]?�[��]%s(%d+)$")
    --debug("Clothe: 2", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�����[��] %d+%s?") then skin_id = str:match("%s(%d+)")
    --debug("Clothe: 3", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�����[��]%s(%d+)%s��[�]?���") then skin_id = str:match("%s(%d+)%s")
    --debug("Clothe: 4", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("[�N]%s?%d+") then skin_id = str:match("[�N]%s?(%d+)")
    --debug("Clothe: 5", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%s�����") then skin_id = str:match("%s(%d+)%s")
    --debug("Clothe: 6", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("�[��][��]�%s%d+%s") then skin_id = str:match("�[��][��]�%s(%d+)%s")
   --debug("Clothe: 7", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("����%d+%s") then skin_id = str:match("����(%d+)%s")
    --debug("Clothe: 7.1", 4)
     h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%d+%s%s����") then skin_id = str:match("(%d+)%s%s����")
      --debug("Clothe: 7.1", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%s����") then skin_id = str:match("%s(%d+)%s")
   --debug("Clothe: 7", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("%s%d+%sc���") then skin_id = str:match("%s(%d+)%s")
    --debug("Clothe: 7", 4)
     h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("�%s?\"%d+\"") then skin_id = str:match("�%s?\"(%d+)\"")
   --debug("Clothe: 8", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s?\"%s%d+%s\"") then skin_id = str:match("%s?\"%s(%d+)%s\"")
    --debug("Clothe: 8", 4)
     h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�%s?%d+") then skin_id = str:match("�%s?(%d+)")
   --debug("Clothe: 9", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+(%s|$)") then skin_id = str:match("%s(%d+)(%s|$)")
   debug("Clothe: 10", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("[^(�����)]%s%d+%s?%s?[(����)|(����)|(c���)|(����)|(�����)|(�����)|(������)|(������)|(����)][^(��)|(���)]") then skin_id = str:match("%s(%d+)%s?%s?[(����)|(����)|(c���)|(����)|(�����)|(�����)|(������)|(������)|(����)]")
   debug("Clothe: 11", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s[(������)|(������)|(�����)|(�����)|(�����)|(������)|(�������)|(�������)|(����)|(������)|(������)|(id)]+%s%s?%p?%d+%p?%s?") then skin_id = str:match("%s[(������)|(������)|(�����)|(�����)|(�����)|(������)|(�������)|(�������)|(����)|(������)|(������)|(id)]+%s%s?%p?(%d+)%p?%s?")
   debug("Clothe: 12", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s[�c]���%s%d+%s") then skin_id = str:match("%s[�c]���%s(%d+)%s")
   debug("Clothe: 13", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%s%d+%sid%sskin") then skin_id = str:match("%s(%d+)%sid%sskin")
   debug("Clothe: 14", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("[��]�����%s%d+%s����") then skin_id = str:match("[��]�����%s(%d+)%s����")
   debug("Clothe: 15", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+%ssell$") then skin_id = str:match("(%d+)%ssell$")
   debug("Clothe: 16", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+%s����") then skin_id = str:match("(%d+)%s")
   debug("Clothe: 17", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act) --new
  elseif str:find("sell%s%d+%sskin") then skin_id = str:match("sell%s(%d+)%sskin")
   debug("Clothe: 18", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("skin%s%d+%s") then skin_id = str:match("skin%s(%d+)%s")
   debug("Clothe: 18", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("skin%s%d+$") then skin_id = str:match("skin%s(%d+)$")
    debug("Clothe: 18", 4)
     h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+ %d+.%d��") then skin_id = str:match("(%d+) %d+.%d��")
   debug("Clothe: 19", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W+%s%d+%s�$") then skin_id = str:match("^%W+%s(%d+)%s�$")
   debug("Clothe: 20", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W+%s%d+%p%W+$") then skin_id = str:match("^%W+%s(%d+)%p%W+$")
    debug("Clothe: 21", 4)
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("�%s?%p%d+%p") then skin_id = str:match("�%s?%p(%d+)%p")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("[Bb]uy %d+ %w-$") then skin_id = str:match("[Bb]uy (%d+) %w-$")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("%d+%p� ����%p") then skin_id = str:match("(%d+)%p� ����%p")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W- %d+ %W-$") then skin_id = str:match("^%W- (%d+) %W-$")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("^%W- ��� %d+") then skin_id = str:match("^%W- ��� (%d+)")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find("������ %d+ ��") then skin_id = str:match("������ (%d+) ��")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
  elseif str:find(": %d+. [��]��") then skin_id = str:match(": (%d+). [��]��")
    h_string = action[act].."������ � ������ �"..skin_id..". "..get_price(str, act)
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
    withn = num1:gsub(num1, "�"..num1)..' � '..num2:gsub(num2, "�"..num2)
    return withn
  elseif count == 3 then
    num1, num2, num3 = str:match(pattern)
    withn = num1:gsub(num1, "�"..num1)..', '..num2:gsub(num2, "�"..num2)..' � '..num3:gsub(num3, "�"..num3)
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
    short_type = "�"
  elseif name:find("Maverick") then
    short_type = "�"
  else
    short_type = "�"
  end
  return short_type
end

function vechicles(str, trade, v_type, model)
  print("{18c860}VEHICLES:{B2B2B2}", str, trade)
  if str:find("�����") or str:find("�[��]���") or str:find("����") or str:find("[��]�[�]?%p?����[��]�") then
    return "�� ��������� ��������� "..v_type.." ����� �"..model.."�"..car_tuning(str).." "..get_price(str, trade_type(str))
  elseif trade == "my_change" or trade == "ur_change" or trade == "change" or trade == "d_change" then
    print(tableToString({v_type, model, car_tuning(str), car_exchange(str), get_price(str, trade_type(str))}))
    left_part, right_part = car_exchange(str)
    print(tableToString({action[trade], left_part, right_part, get_price(str, trade)}))
    short_type_left = change_vehicle_type(left_part)
    short_type_right = change_vehicle_type(right_part)
    if right_part:find("��� ���������") then
      right_part_full = "��� ���������"
    else
      right_part_full = short_type_right.."/� "..right_part
    end
    car_exch_str = action[trade]..short_type_left.."/� "..left_part.." �� "..right_part_full..". "..get_price(str, trade)
    print(car_exch_str)
    return car_exch_str
  end
  print(action[trade], v_type, model, car_tuning(str), get_price(str, trade))
  a = get_price(str, trade)
  print("{AC41BF}"..a)
  return action[trade]..v_type.." ����� �"..model.."�"..car_tuning(str)..". "..get_price(str, trade)
end

function car_exchange(str)
  split_string = {}
  split_string["left"], split_string["right"] = str:match("(.+)%s��%s(.+)")
  print(split_string["left"], split_string["right"])
  if split_string["right"]:find("��� �%p?�") or split_string["right"]:find("���� ����") then
    print(12341)
    return car_names(split_string["left"])..car_tuning(split_string["left"]), "��� ���������"
  end
  print("{BAF25E}2: "..car_names(split_string["left"]).."{F2E25E}"..split_string["right"])
  if str:find("��%s.+[(%s)|(%p)]") and not str:find("��������") then
    car_name = str:match("��%s(.+)[(%s)|(%p)]")
  -- elseif str:find("��%s.+[(%s)|(%p)]") and not str:find("��������") then
  --   car_name = str:match("��%s(.+)[(%s)|(%p)]")
  elseif str:find("�������� (.+) �� ����") then
    return "��� ����������"
  end
  return car_names(split_string["left"])..car_tuning(split_string["left"]), car_names(split_string["right"])..car_tuning(split_string["right"])
end

function car_names(str)
  if str:find("[Nn][Rr][Gg]") or str:find("[��][��][��]") or str:find("NRG") then -- ������� ����������
    car_name = "�NRG-500�"
  elseif str:find("[Ff][Cc][Rr]") or str:find("[��][����][��]") then -- ������� ����������
    car_name = "�FCR-900�"
  elseif str:find("[Ff]reeway") or str:find("[��]�����") then -- ������� ����������
    car_name = "�Freeway�"
  elseif str:find("GT") or str:find("��[^�]") or str:find("����� ��") or str:find("Super GT") or str:find("[(super)|(�����)] gt") then
    car_name = "�Super GT�"
  elseif str:find("����[(��)]?") or str:find("s[uy]ltan") or str:find("[��]�[�]?���") or str:find("S[uy]ltan") or str:find("S[YU]LTAN") or str:find("[��]����") then 
    car_name = "�Sultan�"
  elseif str:find("[Bb][Ff]") or str:find("[Ii]njection") or str:find("[��][��]") then 
    car_name = "�BF Injection�"
  elseif str:find("�[��]�[��]�") or str:find("������") or str:find("averi[c]?k") or str:find("�����") or str:find("mavik") or str:find("���[�]?��") or str:find("averi�") then 
    car_name = "�Maverick�"
  elseif str:find("zrx") or str:find("zrx 350") or str:find("zrx-350") or str:find("ZRX") or str:find("[Zz][Rr]") or str:find("ZRX-350") or str:find("ZRX 350") then 
    car_name = "�ZRX-350�"
  elseif str:find("ul[l]?et") or str:find("[��]���[��]") or str:find("[��]��[���]�") or str:find("[��]���[�]?��") then
    car_name = "�Bullet�"
  elseif str:find("[Pp]remier") or str:find("PREMIER") or str:find("[��]������") then
    car_name = "�Premier�"
  elseif str:find("[Ee]legant") or str:find("[����]������") then
    car_name = "�Elegant�"
  elseif str:find("[Ss][ea]nti[n]?el") or str:find("[��]�������") then
    car_name = "�Sentinel�"
  elseif str:find("(.*)an%s?(.*)ing") or str:find("(.*)[���]�[��]?%s?��[�]?�") or str:find("[��]�������") or str:find("[��][��]����[�]?") or str:find("%s[�Ss][�Kk]%s") or str:find("(%s)��(%s)") or str:find("(%s)��$") or str:find("sek ft") or str:find("(%s)�[��]��(%s)") or str:find("(%s)���� ����") or str:find("SANDKING") then
    car_name = "�Sandking�"
  elseif str:find("tre[ts]ch") or str:find("�����") or str:find("������") or str:find("[Ss]tr[ae][t]?ch") or str:find("[��]����[�]?�") then
    car_name = "�Stretch�"
  elseif str:find("�����") or str:find("�����") or str:find("[Ee]leg[yu]") or str:find("legy") or str:find("enegy") or str:find("[����]����") or str:find("[����]��[��][��]�") or str:find("[��]���") then
    car_name = "�Elegy�"
  elseif str:find("���� %+") or str:find("���� %+") or str:find("riot %+") or str:find("RIOT %+") or str:find("���� %+") or str:find("������ %+") or str:find("���[�]?�� %+") then
    car_name = "�Patriot +�"
  elseif str:find("����") or str:find("����") or str:find("riot") or str:find("RIOT") or str:find("����") or str:find("������") or str:find("���[�]?��") then
    car_name = "�Patriot�"
  elseif str:find("[Mm]onster") or str:find("[��]����[�]?�") or str:find("MONSTER") or str:find("�����[�]?�") then
    car_name = "�Monster A�"
  elseif str:find("[��]������") or str:find("[Pp]revion") then
    car_name = "�Previon�"
  elseif str:find("[��]��%p?[��]��") or str:find("[Hh]ot%p?[Dd]og") then
    car_name = "�Hotdog�"
  elseif str:find("[��]������") or str:find("[Aa]dmiral") then
    car_name = "�Admiral�"
  elseif str:find("�[��]����") or str:find("[Hh]unt[le][el]y") or str:find("[��]����") or str:find("untly") or str:find("������") then
    car_name = "�Huntley�"
  elseif str:find("[��][��]?[��][��][��][��]") or str:find("[��]�����[��]") or str:find("[Tt][Uu]rismo") then
    car_name = "�Turismo�"
  elseif str:find("[Cc]adrona") or str:find("[��]������") then
    car_name = "�Cadrona�"
  elseif str:find("[^(�����%s)][Aa]lpha") or str:find("[��]����") then
    car_name = "�Alpha"
  elseif str:find("[Uu]ranus") or str:find("[��]�����") then
    car_name = "�Uranus�"
  elseif str:find("[Jj]ester") or str:find("[��]������") then
    car_name = "�Jester�"
  elseif str:find("[Bb]uffalo") or str:find("[��]��[�]?��[�]?�") then
    car_name = "�Buffalo�"
  elseif str:find("[Pp]hoenix") or str:find("[��]�����") then
    car_name = "�Phoenix"
  elseif str:find("[Hh]otk[hn]ife") or str:find("[��]�������") then
    car_name = "�Hotknife�"
  elseif str:find("[Mm]esa") or str:find("[��]��[��]") then
    car_name = "�Mesa�"
  elseif str:find("[Oo]ceanic") or str:find("[��]������") then
    car_name = "�Oceanic�"
  elseif str:find("[Bb]ansh") or str:find("[��]��[�]?�") then
    car_name = "�Banshee�"
  elseif str:find("[Ss]avan") or str:find("[��]����") then
    car_name = "�Savanna�"
  elseif str:find("[Pp]eren[n]?i[ea]l") or str:find("[��]�������") then
    car_name = "�Perennial�"
  elseif str:find("[Bb]roadway") or str:find("[��]����[��]�") then
    car_name = "�Broadway�"
  elseif str:find("[Yy]osemite") or str:find("[��]������") then
    car_name = "�Yosemite�"
  elseif str:find("[Rr]ancher") or str:find("[��]�����") then
    car_name = "�Rancher�"
  elseif str:find("[Cc]lover") or str:find("[����]�����") then
    car_name = "�Clover�"
  elseif str:find("[Mm]anana") or str:find("[��]����[��]") then
    car_name = "�Manana�"
  elseif str:find("[Ss]abre") or str:find("[��]����") then
    car_name = "�Sabre�"
  elseif str:find("[��]����") or str:find("[Cc��]omet") then
    car_name = "�Comet�"
  elseif str:find("[��]������") or str:find("[Ss]tratum") then
    car_name = "�Stratum�"
  elseif str:find("[Bb]andit") or str:find("[��]����") or str:find("[��]������") and not str:find("����") then
    car_name = "�Bandito�"
  elseif str:find("�����") or str:find("hamal") or str:find("�����") or str:find("shaman") then
    car_name = "�Shamal�"
  elseif str:find("[Bb]eagle") or str:find("[��]���") then
    car_name = "�Beagle�"
  elseif str:find("[Cc]ropduster") then
    car_name = "�Cropduster�"
  elseif str:find("[Dd]odo") or str:find("[��]���") then
    car_name = "�Dodo�"
  elseif str:find("t[au]n(.*)[Pp]la[(ne)|(y)]") or str:find("tun[t]?[Pp]la[(ne)|(y)]") or str:find("�������[�]?�") or str:find("���������") or str:find("[��]����[��]���") then
    car_name = "�Stuntplane�"
  elseif str:find("�������") or str:find("������") or str:find("arrow") or str:find("������") or str:find("������") then
    car_name = "�Sparrow�"
  elseif str:find("[Rr]ain[e]?dance") or str:find("[��]�����") then
    car_name = "�Raindance�"
  elseif str:find("[Ll]eviathan") or str:find("[��]����[��]��") then
    car_name = "�Leviathan�"
  elseif str:find("arquis") or str:find("������") or str:find("������") then
    car_name = "�Marquis�"
  elseif str:find("[Vv]ortex") or str:find("[��]������") then
    car_name = "�Vortex�"
  elseif str:find("heetah") or str:find("�����") or str:find("����") or str:find("����") or str:find("������") then
    car_name = "�Cheetah�"
  elseif not str:find("��������") and str:find("nf[er][er]nus") or str:find("�[�]?�����") or str:find("���[��]") or str:find("[Ii]nf[eu]") or str:find("[��][��][��][��][��]") or str:find("���[�]?����") or str:find("INFERNUS") or str:find("infa") then
    car_name = "�Infernus�"
  elseif str:find("��%s?���� �") or str:find("otring [Bb��]") or str:find("otring B") or str:find("[��]������ [��Bb��]") or str:find("acer [Bb��]") or str:find("acer B") or str:find("[��]����� [��]") then
    car_name = "�Hotring Racer B�"
  elseif str:find("������ [Aa��]") or str:find("otring a") or str:find("ot[Rr]ing A") or str:find("[��]������ �") or str:find("acer a") or str:find("acer A") or str:find("����� �") then
    car_name = "�Hotring Racer A�"
  elseif str:find("������") or str:find("otring") or str:find("������[��]") or str:find("acer") then
    car_name = "�Hotring Racer�"
  end
  return car_name
end

function car_tuning(str)
  if str:find("ft") or str:find("[��][�]?�") or str:find("[Ff][Tt]") or str:find("[����][����]") or str:find("[��]��") or str:find("%s[��]?[��Ff]%s[Tt��][��]?$") then
    return " [FT]"
  elseif str:find("[^(S.W.A)]%pT%p") or str:find("%sT%s") or str:find("%sT%p") or str:find("���[��]���") or str:find("[^(��)]� ����") or str:find("� ��������") then
    return " [T]"
  else
    return ""
  end
end
--���� 1.5 ��� 
function get_price(str, act)
  -- debug(str, 2)
  -- debug(act, 5)
  str = str:gsub("+����", "")
  if str:find("[��][�]?[��]?��[���]") or str:find("[��]�[��][��][�]?����") or str:find("[��]���%p%p%p") or str:find("[��]��������") or str:find("�[��]���") or str:find("�����") or str:find("[^%p][��]��") or str:find("���� �����") or str:find("���� ��") or str:find("[��]����") or str:find("[��]�[�]?�[�]?�") or str:find("[��]����") or str:find("����") or str:find("[��]��� ��$") or str:find("[��]���������") or str:find("[��]��������") or str:find("����[:]?%s[(�����)|(������)]") then
    -- debug(str.." "..act, 3)
    return "���� ����������"
    --����� ������ ������ 303,304,305
  elseif str:find("[��]�����") and str:find("���") then
    
    return "������ �� ���. ����"
  elseif str:find("[��]��[��]") or str:find ("�� %d") or str:find("%d+��") or str:find("%d ��$") or str:find("[��][��][^��]") or str:find("����") or str:find("�[��]���") or str:find("%d[�k]$") or str:find("[^ea][kr][kr]") and not str:find("����������") or act == "surcharge" then
    debug(string.format("%s\n%s", "With price type", str), 2)
    if str:find("%d%p%d��%s") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("��%s")-1).."00.000$" k = 0
    elseif str:find("%W-%s%d%p%d%d��$") then price = ''..str:sub(str:find("%s%d+%p%d%d�")+1, str:find("��")-1).."0.000$" k = 1
    elseif str:find("%W-%s%d%p%d��$") then price = ''..str:sub(str:find("%s%d+%p%d�")+1, str:find("��")-1).."00.000$" k = 2321
    elseif str:find("%W-%s%d%p%d+�$") then price = ''..str:sub(str:find("%s%d+%p%d+�")+1, str:find("�")-1)..".000$" k = 2156
    elseif str:find("%d%p%d���$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("���$")-1).."00.000.000$" k = 3
    elseif str:find("%d+���$") then price = ''..str:sub(str:find("%s%d+�")+1, str:find("���$")-1)..".000.000.000$" k = 4
    elseif str:find("%d+kk%+����") then price = ''..str:sub(str:find("%d+kk"), str:find("k")-1)..".000.000$ + ����" k = 0098
    elseif str:find("%d+%s?���[�]?$") then price = ''..str:sub(str:find("%s%d+%s?��")+1, str:find("%s?���[�]?$")-1)..".000.000.000$" k = 5
    elseif str:find("%d+[.,]%dkk") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("kk")-1).."00.000$" k = 6
    elseif str:find("%d+[.,]%d��") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("��")-1).."00.000$" k = 7
    elseif str:find("%d+[.,]%d�$") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("%d�")).."00$" k = 7
    elseif str:find("%d[.,]%d%s������") then price = ''..str:sub(str:find("%s%d+[.,]")+1, str:find("%s������")-1).."00.000$" k = 8
    elseif str:find("%s%d+kk$") then price = ''..str:sub(str:find("%s%d+k")+1, str:find("kk$")-1)..".000.000$" k = 9
    elseif str:find("%W%p%d+kk$") then price = ''..str:sub(str:find("%W%p%d+k")+2, str:find("kk$")-1)..".000.000$" k = 91
    elseif str:find("%s%d+[�r][�r]$") then price = ''..str:sub(str:find("%s%d+[�r]")+1, str:find("[�r][�r]$")-1)..".000.000$" k = 10
    elseif str:find("%s%d+%s���") then price = ''..str:sub(str:find("%s%d+%s�")+1, str:find("%s���")-1)..".000.000$" k = 11
    elseif str:find("%s%d+���") then price = ''..str:sub(str:find("%s%d+�")+1, str:find("���")-1)..".000.000$" k = 12
    elseif str:find("%s%d+�����") then price = ''..str:sub(str:find("%s%d+�")+1, str:find("�����")-1)..".000.000$" k = 12
    elseif str:find("%W%p%d+��$") then price = ''..str:sub(str:find("%p%d+�")+1, str:find("��$")-1)..".000.000$" k = 131
    elseif str:find("%s%d+kk%s") then price = ''..str:sub(str:find("%s%d+k")+1, str:find("kk%s")-1)..".000.000$" k = 14
    elseif str:find("%s%d+%pOOO%pOOO") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%pOOO")-1)..".000.000$" k = 15
    elseif str:find("%s%d+OO%pOOO%pOOO") then price = ''..str:sub(str:find("%s%d")+1, str:find("%dO")).."00.000.000$" k = 15
    elseif str:find("%d%p%d[O�][�O]%p[�O][�O][�O]") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%p%d[�O][�O]")+1).."00.000$" k = 15
    elseif str:find("�%p%d+%pOOO%pOOO") then price = ''..str:sub(str:find("�%p%d+")+2, str:find("%pOOO")-1)..".000.000$" k = 16
    elseif str:find("�%p%d+��$") then price = ''..str:sub(str:find("%p%d+")+1, str:find("��$")-1)..".000.000$" k = 17
    elseif str:find("%d%p%dkk") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("kk")-1):gsub("/", "."):gsub("\"", ".").."00.000$" k = 18
    elseif str:find("%d%p%d��") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("��")-1):gsub("/", "."):gsub("\"", ".").."00.000$" k = 19
    elseif str:find("%d%p%d��") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("��")-1):gsub("/", "."):gsub("\"", ".").."00.000$" k = 19
    elseif str:find("%d+%s��$") then price = ''..str:sub(str:find("%s%d+%s")+1, str:find("��")-1):gsub("/", "."):gsub("\"", "."):gsub(" ", "")..".000.000$" k = 19
    elseif str:find("%d%p%d%skk") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%skk)")-1).."00.000$" k = 20
    elseif str:find("%d%p%d%s��") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%s��")-1).."00.000$" k = 20
    elseif str:find("%d%p%d%s?���") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%s?���")-1).."00.000$" k = 41
    elseif str:find("%s%d%s���") then price = ''..str:sub(str:find("%s%d+"), str:find("%s���")-1)..".000.000$" k = 42
    elseif str:find("%s%d+%s[��][��][��]") then price = ''..str:sub(str:find("%s%d+")+1, str:find("[��][��][��]")-1):gsub(" ", "")..".000.000$" k = 42
    elseif str:find("%s%d%s���") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s���")-1)..".000.000$" k = 43
    elseif str:find("%s%d%s�����") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s�����")-1)..".000.000$" k = 44
    elseif str:find("%d%s����") then price = ''..str:sub(str:find("%s%d")+1, str:find("%s�")-1)..".000.000$" k = 23
    elseif str:find("%s%d+%p%d+%$.") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")) k = 18
    elseif str:find("%s%$%d+%p%d+%p%d+.") then price = ''..str:sub(str:find("%$%d+")+1, str:find("%p$")-1) k = 18
    elseif str:find("%s%d%p%d$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")).."00.000$" k = 188
    elseif str:find("[^(���.)]%s%d+%p%d+$") then price = ''..str:sub(str:find("%s%d+%p%d+")+1, str:find("$")):gsub("$", "").."$" k = 191
    elseif str:find("%d%p%d$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")-1).."00.000$" k = 3
    elseif str:find("%s%d+%p%d+kk$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("kk$")-1):gsub(",", ".")..".000$" k = 30
    elseif str:find("%s%d+%p%d+��$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("��$")-1):gsub(",", ".")..".000$" k = 30
    elseif str:find("%s%d+%p%d+%s%s��$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s%s��$")-1):gsub(",", ".")..".000$" k = 30
    elseif str:find(".%d00%p00%$$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%d%$")).."0$" k = 81
    elseif str:find("[:]?%s%d+%p%d+%p%d+[(%$)|(;)|(#)]") then price = ''..str:sub(str:find('[:]?%s%d+%p%d+%p%d+')+1, str:find("%d[(%$)|(;)|(#)]")):gsub(" ", "").."$" k = 4
    elseif str:find("[:]?%s%d+%p%d+%p%d+�") then price = ''..str:sub(str:find('%d+%p%d+%p%d+'), str:find("%d�")).."$" k = 34
    elseif str:find("[:]%s?%d+%p%d%d%d%p%d+%s?%$") then price = ''..str:sub(str:find('%d+[,.]%d'), str:find("%d%s?%$")).."$" k = 12
    elseif str:find("%s%d%d%d%p%d+%p%d+%s") then price = ''..str:sub(str:find('%s%d%d%d%p'), str:find("%d%s")).."$" k = 13
    elseif str:find("%s%d+%s%d+%s%d+%$") then price = ''..str:sub(str:find('%d+%s'), str:find("%$")-1):gsub(" ", ".").."$" k = 132
    elseif str:find("[^(�����)]%s%d+%s%d+%s%d+%s?") then price = ''..str:sub(str:find('%s%d')+1, str:find("%p?$")-1):gsub(" ", ".").."$" k = 14
    elseif str:find("[:]%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('[:]%s%d+%p')+2, str:find("%d$")).."$" k = 5
    elseif str:find("%s%d+%s?[��][��]") then price = ''..str:sub(str:find("%s%d+%s?[��]")+1, str:find("[��][��]")-1):gsub(" ", "")..".000.000$" k = 6
    elseif str:find("�:%d+%s?[��][��]") then price = ''..str:sub(str:find('�:%d+%s?[��]')+2, str:find("%s?[��][��]")-1)..".000.000$" k = 19
    elseif str:find("%s%d+%p%d+%p%d+$") then price = ''..str:sub(str:find('%s%d+%p%d+')+1, str:find("$")).."$" k = 16
    elseif str:find("%s%d+%p%d+%p%d+%$%p$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."" k = 15
    elseif str:find(":%d+.%d+%$") then price = ''..str:sub(str:find(":%d+%p")+1, str:find("%$")-1).."$" k = 7 
    elseif str:find("%W-%s%d+%p%d+%p") then price = ''..str:sub(str:find("%s%d+%p%d+")+1, str:find("[%$]?%p$")-1).."$" k = 71 
    elseif str:find(":%d+.%d+.%d+$") then price = ''..str:sub(str:find(":%d+%p")+1, str:find("$")-1).."$" k = 129
    elseif str:find("%s%d+[�k]$") then price = ''..str:sub(str:find("%s%d+[�k]")+1, str:find("[�k]$")-1):gsub(" ", "")..".000$" k = 9
    elseif str:find("[��]���%s%d+%s%d+$") then price = ''..str:sub(str:find("���%s%d+%s")+4, str:find("$")-1):gsub(" ", ".").."$" k = 38
    elseif str:find("���%s%d+%s%d+$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("$")):gsub(" ", ".").."$" k = 9
    elseif str:find("[��]���%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("�%d+")+1, str:find("%$")) k = 92
    elseif str:find("[��]���%p%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("�%p%d+")+2, str:find("%$")) k = 92
    elseif str:find("%s%d%p%d+$") then price = ''..str:sub(str:find("���%s%d")+4, str:find("%d+$")+2)..".000$" k = 10
    elseif str:find("%s%d+%p%d+%p%d+%p%d+%s") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s$")):gsub(" ", "") k = 22
    elseif str:find("%s%d+%p%d+%p%d+%p%d+%s?") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d%$")).."$" k = 12
    elseif str:find("%p%d+%p%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("%p%d")+1, str:find("%d+%$")+2).."$" k = 126
    elseif str:find("%s%d+%p%d00%p00%s?") then price = ''..str:sub(str:find("%s%d")+1, str:find("%d+$")+2).."0$" k = 11
    elseif str:find("%s%d+%p%d%s?��$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("��$")-1):gsub(" ", "").."00.000$" k = 21
    elseif str:find("%s%d+%s�����$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("�����$")-2)..".000$" k = 20
    elseif str:find("%s%d+���$") then price = ''..str:sub(str:find("%s%d+�")+1, str:find("���$")-1)..".000$" k = 27
    elseif str:find("%s%d+%s���[�]?����") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%s���")-1)..".000.000.000$" k = 31
    elseif str:find("%s%d+%s�$") then price = ''..str:sub(str:find("%s%d+%s�")+1, str:find("%s�$")-1)..".000$" k = 28
    elseif str:find("%s%d+�%s") then price = ''..str:sub(str:find("%s%d+�")+1, str:find("�%s")-1)..".000$" k = 34
    elseif str:find("%W%s%d0000000$") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1).."0.000.000$" k = 399
    elseif str:find("%W%s%d%d000000$") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1)..".000.000$" k = 39
    elseif str:find("%s%d+%p%d+%$$") then price = ''..str:sub(str:find("%s%d+%p%d+")+1, str:find("%$$")) k=17
    elseif str:find("%s%d+%p��") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%p��")-1)..".000.000$"
    elseif str:find("%s%d%d0000%$%s") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1).."0.000$" k = 300
    elseif str:find("%s%d%d0[��]") then price = ''..str:sub(str:find("%s%d%d0")+1, str:find("0")-1).."0.000$" k = 300
    elseif str:find("�� %d%d$") then price = ""..str:sub(str:find("�� %d")+3, str:find("$"))..".000.000$" k = 1203
    elseif str:find("%p%s%d%d0000%$") then price = str:sub(str:find("%s%d%d00")+1, str:find("0"))..".000$" k = 1200
    elseif str:find("%s%d%d%d%p000$") then price = str:sub(str:find("%s%d%d%d.")+1, str:find("%d.")+2)..".000$" k = 1201
    -- elseif str:find("%s%d%d%d.000%$$") then price = str:sub(str:find("%s%d%d%d.")+1, str:find("%d.")+2)..".000$" k = 1201
    elseif str:find("%p%s%d%d0%p000%s%$") then price = str:sub(str:find("%s%d%d0%p")+1, str:find("%p0")-1)..".000$" k = 1200
    elseif str:find(":%d+%p000%p000%s%$") then price = str:sub(str:find(":%d+")+1, str:find("0")-1).."000.000$" k = 43332
    elseif str:find("%s%d000000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1)..".000.000$" k = 430
    elseif str:find("%s%d00000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1).."00.000$" k = 4301
    elseif str:find("%s%d%d00000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1):gsub(("(%d)"):rep(2), "%1.%2").."00.000$" k = 431
    elseif str:find("%s%d%d0000") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1).."0.000$" k = 4311
    elseif str:find("[��]���%p?%s%d000") then price = str:sub(str:find("%s%d000")+1, str:find("000$")-1)..".000$" k = 4312
    elseif str:find("%s%d%d%d000$") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1)..".000$" k = 4313
    elseif str:find(":%d%d%d�") then price = str:sub(str:find(":%d")+1, str:find("%d�"))..".000$" k = 4314
    elseif str:find("%d%d00%s000") then price = str:sub(str:find("%d%d00"), str:find("%d%d00")).."."..str:sub(str:find("%d00%s000"), str:find("00%s000")+1)..".000$" k = 9998
    elseif str:find("%s%d%d00000$") then part = str:sub(str:find("%s%d+")+1, str:find("0")-1) price = ''..part:sub(0, 1).."."..part:sub(2,2).."00.000$" k = 1209
    elseif str:find("%s%d%d%d%d0000$") then part = str:sub(str:find("%s%d+")+1, str:find("%s%d+")+4) price = ''..part:sub(0, 2).."."..part:sub(3,4).."0.000$" k = 1209
    elseif str:find("%s%d%d%d%d%d%d%d%d%d$") then part = str:sub(str:find("%s%d")+1, str:find("%s%d")+9) price = ''..part:sub(0, 3).."."..part:sub(4,6).."."..part:sub(7,9).."$" k = 1209 print(part:sub(0, 2))
    elseif str:find("%d%d�.���.���%$") then price = str:sub(str:find("%d%d�"), str:find("%$")):gsub("�", "0") k = 775
    -- ���� 31. 000 000
    elseif str:find("%d+.%s000%s000$") then price = str:sub(str:find("%d+%."), str:find("$")):gsub(" ", "%."):gsub("%.%.", "%.").."$" k = 775
    else price="unknown" k="a" -- �� �� 750� ��� ���
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
    elseif str:find("[^(����)]%s%d+%p%d+%$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%$")-1).."$" return act_text[act]..price 
    elseif str:find("[^(�����)|(�����)|(����)|(����)|(rice)]%s%d+[,.]%d+$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."$" return act_text[act]..price --debug(str.." - "..price.." | 9933", 4)
    elseif str:find("[^(�����)]%s%d+[.]%d+[.]%d+$") then price = ''..str:sub(str:find("%s%d+[.]")+1, str:find("$")-1).."$"  return act_text[act]..price --debug(str.." - "..price.." | 8648", 4)
    elseif str:find("%s%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("%s%d+%p%d+%p")+1, str:find("%$"))   return act_text[act]..price --debug(str.." - "..price.." | 4366", 4)
    elseif str:find("[^(�����)|(�����)|(����)|(����)]%s%d+%p%d+%p%d+;") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find(";")-1).."$"  return act_text[act]..price --debug(str.." - "..price.." | 4366", 4)
    elseif str:find("%s%d+%p%d+%p%d+%p%d+%$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$"))  return act_text[act]..price --debug(str.." - "..price.." | 4466", 4)
    elseif str:find("%s%d+[��]%s") then price = ''..str:sub(str:find("%W%s%d+")+2, str:find("[��]%s%W")-1)..".000$"  return act_text[act]..price --debug(str.." - "..price.." | 2134", 4)
    elseif str:find("%d+%s%d+[��]$") then price = ''..str:sub(str:find("%d%s%d+")+2, str:find("[��]$")-1)..".000$"  return act_text[act]..price --debug(str.." - "..price.." | 2134", 4)
    elseif str:find("%W%s%d%p%d+%p%d+%p%d+$") then price = ''..str:sub(str:find("%s%d%p")+1, str:find("$")).."$"  return act_text[act]..price --debug(str.." - "..price.." | 1114", 4)
    elseif str:find("%W%s%d000000$") then price = ''..str:sub(str:find("%s%d0")+1, str:find("0")-1)..".000.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0000", 4)
    elseif str:find("%W%s%d0000000$") then price = ''..str:sub(str:find("%s%d0")+1, str:find("0")-1).."0.000.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0001", 4)
    elseif str:find("%s%d%d00000$") then part = str:sub(str:find("%s%d+")+1, str:find("0")-1) price = ''..part:sub(0, 1).."."..part:sub(2,2).."00.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0002", 4)
    elseif str:find("%s%d%d0000$") then part = str:sub(str:find("%s%d+")+1, str:find("0")-1) price = ''..part:sub(0,2).."0.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0002", 4)
    elseif str:find("%s%d+%pOOO%pOOO") then price = ''..str:sub(str:find("%s%d+")+1, str:find("%pOOO")-1)..".000.000$" return act_text[act]..price --debug(str.." - "..price.." | 1600", 4)
    elseif str:find("%s%d+%p%dOO%pOOO") then price = ''..str:sub(str:find("%s%d+")+1, str:find("O")-1).."00.000$"  return act_text[act]..price --debug(str.." - "..price.." | 1601", 4)
    elseif str:find("[^(�����)|(�����)|(������)|(����)]%s%d%d%p%d%d%d%p%d%d%d$") then price = ''..str:sub(str:find("%s%d+")+1, str:find("$")-1).."$"  return act_text[act]..price --debug(str.." - "..price.." | 1601", 4)
    elseif str:find("%s%d+[Kk][Kk]") then price = ''..str:sub(str:find("%s%d+[Kk]")+1, str:find("[Kk][Kk]")-1)..".000.000$"  return act_text[act]..price --debug(str.." - "..price.." | 5138", 4)
    elseif str:find("%s%d00000$") then price = str:sub(str:find("%s%d+")+1, str:find("0")-1).."00.000$" return act_text[act]..price
    elseif str:find("%s%d00[�r]") then price = str:sub(str:find("%s%d00[�r]")+1, str:find("00[�r]")-1).."00.000$" return act_text[act]..price
    elseif str:find("%s%d+%s�$") then price = ''..str:sub(str:find("%s%d+%s�")+1, str:find("%s�$")-1)..".000.000$" return act_text[act]..price
    elseif str:find("%s%d+%s��$") then price = ''..str:sub(str:find("%s%d+%s��")+1, str:find("%s��$")-1)..".000.000$" return act_text[act]..price
    elseif str:find("%s%d%d%d00000") then part = str:sub(str:find("%s%d+")+1, str:find("%d0")) price = ''..part:sub(0, 2).."."..part:sub(3,3).."00.000$"  return act_text[act]..price --debug(str.." - "..price.." | 0003", 4)
    elseif str:find("%s%d+%p%d%s��$") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("%s��$")-1).."00.000$" k = 21 return act_text[act]..price
    elseif str:find("%W+%s%d+%p%d+%s%s��$") then price = ''..str:sub(str:find("%s%d+%p%d%s%s")+1, str:find("%s%s��$")-1):gsub(",", ".").."00.000$" k = 30 return act_text[act]..price
      -- �� 4.8
    elseif str:find("%d%p%d$") and not str:find("[Pp]rice") then price = ''..str:sub(str:find("%s%d+%p")+1, str:find("$")).."00.000$" return act_text[act]..price --debug(str.." - "..price.." | 7684", 4)
      -- 12 500 000
  elseif act == "" or act == "carmarket" then
    -- debug(str, 1)
    return ""
  else
    -- debug(str, 1)
    if act ~= "my_change" and act ~= "ur_change" and act ~= "change" and act ~= "d_change" then
      return "���� ����������"
    else
      surcharge_pay = get_price(str, "surcharge")
      if price == "unknown" then
        if act == "ur_change" then
          return "� ����� ��."
        elseif act == "my_change" then
          return "� ���� ��."
        elseif act == "d_change" then
          return "� ��������."
        elseif act == "change" then
          return "� ��������."
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
