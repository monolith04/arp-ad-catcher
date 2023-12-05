script_name("MonolithSystemScript")
script_version("0.1")
script_author("monolith04")
script_description("Скрипт для Advance RP :)")
-- ПОДКЛЮЧЕНИЕ БИБЛИОТЕК
                        require "lib.moonloader"
                        require "lib.mssa.mss_ads"
local sampev          = require 'lib.samp.events'
local lsg, sf         = pcall(require, 'sampfuncs')
local keys            = require 'vkeys'
local rkeys           = require 'rkeys_old'
local inicfg          = require 'inicfg'
local imgui           = require 'imgui'
local encoding        = require 'encoding'
local mssa            = require 'mssa.mss_addons'

local themes          = import "resource/imgui_themes.lua"
local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')

-- ПЕРЕМЕННЫЕ
imgui.ToggleButton  = require('imgui_addons').ToggleButton
imgui.HotKey        = require('imgui_addons').HotKey

local fa            = require 'fAwesome5'
local fa_font       = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

encoding.default = 'CP1251'
u8 = encoding.UTF8

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

--INI
local inipath = 'msac.ini'
local mainIni = inicfg.load(
  {
      main =
      {
        ad_fishing = 1;
        tag = "";
        separator = 0
      },
      colors =
      {
        imgui_style_number = 1;
        imgui_style_selected_id = 0
      },
      hotkey =
      {
        ad_fish_key = "[18,79]"
      }
  }, inipath)


-- ДЛЯ IMGUI
local sw, sh = getScreenResolution()
local tLastKeys = {}
local v_ad_fish_key = {v = decodeJson(mainIni.hotkey.ad_fish_key)}

msac_settings = imgui.ImBool(false)
ad_editor     = imgui.ImBool(false)
separator_id  = imgui.ImInt(mainIni.main.separator)



--advance_servers_ip = {"54.37.142.72", "54.37.142.73", "54.37.142.74", "54.37.142.75"}
ad_fishing_state = "Stop"

-- ОСНОВНАЯ ФУНКЦИЯ
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end -- Проверка на загрузку сф и сампа
  while not isSampAvailable() do wait(100) end -- Если самп запущен - продолжаем


  --sampAddChatMessage(chat2_c.."Kolt-script ("..thisScript().version..')'..def_c.." работает только на серверах проекта Advance RP", 0xb2b2b2)
  --thisScript():unload()
  --for i=1, 4 do
    --if sampGetCurrentServerAddress() == advance_servers_ip[i] then
	sampAddChatMessage("{C1E812}MSS - Ad catcher {B2B2B2}("..thisScript().version..") загружен", 0xb2b2b2)
  toast.Show(u8'Скрипт загружен!', toast.TYPE.INFO, 5)

  imgui.Process = false
  imgui.SwitchContext()
  themes.SwitchColorTheme(6) -- стиль ImGUI
  sampSendClickTextdraw(tonumber(531))
  sampRegisterChatCommand("sett", function() 
     msac_settings.v = not msac_settings.v
     imgui.Process = msac_settings.v
  end) -- настройки скрипта
  sampRegisterChatCommand("codd", coders)
  sampRegisterChatCommand("test", tcode)
  sampRegisterChatCommand("fis", ad_fish)

  adfish_key = rkeys.registerHotKey(v_ad_fish_key.v, true, ad_fish) -- регистрация горячей клавиши ловли объявлений


  while true do -- безк. цикл
    wait(0)
    if isKeyDown (VK_SHIFT) and isKeyJustPressed (VK_U) then
      thisScript():reload()
    end
  end

end

-- SAMP EVENTS FUNCTIONS

function getPlayerNameByIdWO_(id)
  name = sampGetPlayerNickname(id):gsub("_", " ")
  return name
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text) -- обработка дилогов

  if title:find("Публикация объявления") then -- автонастройка скрипта: открытие статистики в меню
    car_speed_down()
    ad_fishing_state = "Pause"
    p_text = get_string(text)
    handled_s = ad_handler(p_text)
    if handled_s == nil then
      handled_s = "{F17C01}Системная ошибка."
    elseif handled_s == "ERROR" then
      handled_s = "{F7AB31}Ошибка обработки. Совпадений с шаблонами не найдено."
    else
      handled_s = "LV ~ "..handled_s
    end
    if handled_s:find("AD_SIM_0") then
      AD_SIM_0_FMT = true
    else
      AD_SIM_0_FMT = false
    end
    ad_editor.v = not ad_editor.v
    imgui.Process = ad_editor.v
  end
end

function sampev.onTextDrawSetString(id, text)
  if ad_fishing == 1 then
    if ad_fishing_f then
      ad_count = tonumber(text)
      if ad_count > 0 then
        sampSendChat("/edit")
      else 
        debug("Нет новых объявлений", 5)
      end
    end
  end
end

function sampev.onServerMessage(color, text)
  if text:find("Объявление отредактировано и поставлено в очередь на публикацию") then
    ad_editor.v = false
    ad_fishing_state = "Run"
  end
  if text:find("отклонил объявление") then
    if text:find(sampAddChatMessage(sampGetPlayerNickname(getUserId()))) then
      ad_editor.v = false
      ad_fishing_state = "Run"
    end
  end
  if text:find("Объявление пропущено.") then
    ad_editor.v = false
    ad_fishing_state = "Run"
  end
  if text:find("Отредактированный текст слишком длинный") then
    ad_editor.v = false
    ad_fishing_state = "Run"
  end
  if text:find("Редактируемое Вами объявление удалено, т.к. телефон отправителя вне зоны действия") then
    ad_editor.v = false
    ad_fishing_state = "Run"
  end
  if text:find("Нет новых объявлений") then
    addOneOffSound(0.0, 0.0, 0.0, 1074)
    debug("Нет новых объявлений", 5)
    return false
  end
end


function get_string(str)
 -- local pattern = 
  result = str:match("\t%{......%}(.*)\n\n")
  if result then
    return result
  end
  return "{DD0000}NIL"
end

function string_replacer(str)
  
  if str:find("[(LS)|(SF)|(LV)]%s|") then
    sampAddChatMessage("TAG")
    first_letter = str:sub(0, 5)
    string = first_letter.."=LV ~ "
  else
    sampAddChatMessage("LETTER")
    first_letter = str:sub(0, 1)
    string = first_letter.."=LV ~ "..first_letter
  end
  return string
end

function ad_fish() 
  if mainIni.main.ad_fishing == 1 then 
    ad_fishing_f = not ad_fishing_f

  elseif mainIni.main.ad_fishing==2 then 
    ad_fishing_f = not ad_fishing_f 
    ad_fishing_state="Run" 
    start_ad_fishing()
  end
  if ad_fishing_f then
    debug("Ловля запущена", 6)
  else
    debug("Ловля выключена", 5)
  end
end

function start_ad_fishing(state)
  lua_thread.create(function()
    while ad_fishing_f do
      if ad_fishing_state == "Run" then
        sampSendChat('/EDIT')
        wait(2000)
      elseif ad_fishing_state == "Pause" then
        wait(2000)
      elseif ad_fishing_state == "Stop" then
        break
      end
    end
  end)
end

function car_speed_down()
  lua_thread.create(function()
    wait(50)
    if isCharInAnyCar(PLAYER_PED) then
      speed = getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED))
      for sp = speed, 0, -1 do
        wait(50)
        setCarForwardSpeed(storeCarCharIsInNoSave(PLAYER_PED), sp)
      end
    end
  end)
end


function coders()
  p_text = "куплю симку 555555 цена 4кк"
  handled_s = ad_handler(p_text)
  
  if handled_s:find("AD_SIM_0") then
    AD_SIM_0_F = true
  else
    AD_SIM_0_F = true
  end
  ad_editor.v = not ad_editor.v
  imgui.Process = ad_editor.v
  --[[boolresult, vehicle_car = sampGetCarHandleBySampVehicleId(int)
  primaryColor, secondaryColor = getCarColours(vehicle_car)
  print(primaryColor, secondaryColor)]]
end

function tcode()
  --local text = "Это строка с числами: 42 и 123.45, и еще 9876."

  --for number in text:gmatch("%d+%.?%d*") do
    --print(number)
  --end
  text = '{B2B2B2}'
  file = io.open(getWorkingDirectory().."\\resource\\ads_source.txt", "r")
  for line in file:lines() do
    
    handl = ad_handler(line)
    --debug(handl, 2)
    if (handl == nil) or (handl == "ERROR") then
      handl = "{F7AB31}Ошибка обработки. Совпадений с шаблонами не найдено."
      h_len = "{F7AB31} (ERROR"
    else
      h_len = "{7FC111} ("..tostring(#handl + 5).." сим."
    end
  
    text = text..line..'\n{F4ED13}'..handl..h_len..")\n\n{B2B2B2}"
  end
  sampShowDialog(3525, "{F4ED13}Handled ads", text, "Закрыть")
  removeSound(1076)
end

function offs()
  thisScript():unload()
end

function mss_reload()
  thisScript():reload()
end

local test_text_buffer = imgui.ImBuffer(256)
local ad_fish_val = imgui.ImInt(2) ad_fish_val.v = mainIni.main.ad_fishing


function imgui.OnDrawFrame() -- отрисовка ImGui окон (каждый кадр)
  if not msac_settings.v and not ad_editor.v then --and not test_menu.v then -- предотвращает загрузку ImGui окон сразу после запуска игры
    imgui.Process = false
  else
    imgui.Process = true
  end

  if msac_settings.v then
    imgui.SetNextWindowSize(imgui.ImVec2(415,140), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(fa.ICON_FA_AD..u8' Ловля объявлений', msac_settings, imgui.WindowFlags.NoResize) -- обратите внимание на u8 перед текстом, это и есть преобразование кодировки
    imgui.SetCursorPos(imgui.ImVec2(5, 25))
    imgui.BeginChild('##main', imgui.ImVec2(405, 110), true)
    imgui.PushItemWidth(100)
    if imgui.Combo(u8"Разделитель для тэга", separator_id, {u8"«Палка» (|)", u8"Тильда (~)", u8"Точка"}, 3) then
      sampAddChatMessage(separator_id.v, -1)
    end
      if imgui.HotKey("##ADF", v_ad_fish_key, tLastKeys, 100) then
        sampAddChatMessage("Новая кнопка: {00CAAF}"..tab_concat_acm(v_ad_fish_key.v), -1)
        rkeys.changeHotKey(adfish_key, v_ad_fish_key.v)
        mainIni.hotkey.ad_fish_key = encodeJson(v_ad_fish_key.v)
        inicfg.save(mainIni, inipath)
      end
      imgui.SameLine()
      imgui.TextColoredHex("Активация {cf03fc}ловли объявлений")
      imgui.Separator()
      imgui.CenterTextColoredRGB("{cf03fc}Ловля обьявлений")
      if imgui.CustomRadioButton("Lite", ad_fish_val, 1, imgui.ImVec2(imgui.GetWindowSize().x/2.1,20)) then mainIni.main.ad_fishing = ad_fish_val.v inicfg.save(mainIni, inipath) end
        imgui.SameLine()
      if imgui.CustomRadioButton("Brute Force", ad_fish_val, 2, imgui.ImVec2(imgui.GetWindowSize().x/2.1,20)) then mainIni.main.ad_fishing = ad_fish_val.v inicfg.save(mainIni, inipath) end
    imgui.EndChild()
    imgui.End()
  end

  if ad_editor.v then
    imgui.SetNextWindowSize(imgui.ImVec2(650, 240), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 1.2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(fa.ICON_FA_AD..u8" Редактор объявлений", nil, imgui.WindowFlags.NoResize)
    imgui.BeginChild("texts", imgui.ImVec2(-1,185), true, imgui.WindowFlags.NoScrollbar)
      imgui.CenterTextColoredRGB("Текст объявления:")
      imgui.CenterTextColoredRGB("{9264F1}"..p_text)
      imgui.Separator()
      imgui.CenterTextColoredRGB("Предоставляю вам следующую версию объявления {9264F1}("..#handled_s.." сим.){SSSSSS}:", true, imgui.GetWindowSize().x)
      imgui.CenterTextColoredRGB("{56DC53}"..handled_s)
      if imgui.Button(u8"Вставить текст", imgui.ImVec2(-1, 20)) then
        imgui.SetClipboardText(u8(handled_s))
        sampSetCurrentDialogEditboxText(handled_s)
        --print("SF ~ "..action[trade_type(p_text)].."сим-карту формата \"%s\". "..get_price(p_text, trade_type(p_text)), test_text_buffer.v, 1)
        --sampAddChatMessage("SF ~ "..action[trade_type(p_text)].."сим-карту формата \"%s\". "..get_price(p_text, trade_type(p_text)), test_text_buffer.v, -1)
        --sampSetCurrentDialogEditboxText("SF ~ "..u8(handled_s))--u8(getClipboardText()))
      end
      if imgui.Button(u8"Тэг", imgui.ImVec2(120, 20)) then
        sampSetCurrentDialogEditboxText("LV ~ ")
      end
      imgui.SameLine()
      if imgui.Button(u8"ПРО", imgui.ImVec2(120, 20)) then
        sampSetCurrentDialogEditboxText("LV ~ ПРО")
      end
      imgui.SameLine()
      if imgui.Button(u8"Пропустить", imgui.ImVec2(120, 20)) then
        sampSendChat("/adskip")
      end
      imgui.SameLine()
      if imgui.Button(u8"Замена 1-й буквы", imgui.ImVec2(120, 20)) then
        sampSetCurrentDialogEditboxText(string_replacer(p_text))
      end
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 1.00, 1.00, 0.65))
      imgui.ButtonClickable(false,fa.ICON_FA_INFO_CIRCLE..u8" Помощь", imgui.ImVec2(-1, 20))
      imgui.PopStyleColor(1)
      imgui.Tooltip(u8'Вставка тэга - вставит тэг с разделителем в поле.\nПРО - для отклонения объявления по ПРО\nПропустить объявление - и так понятно... \nЗамена 1-й буквы - замена первой буквы на ту же, но с тэгом\n')
      test_text_buffer.v=u8("")
      imgui.PushItemWidth(200)
      if imgui.InputText(u8"Формат сим-карты", test_text_buffer) then
        if AD_SIM_0_FMT then
          sampSetCurrentDialogEditboxText(string.format("LV ~ "..action[trade_type(p_text)].."сим-карту формата \"%s\". "..get_price(p_text, trade_type(p_text)), test_text_buffer.v), -1)
        end
      end
    imgui.EndChild()
    imgui.NextColumn()
    if sampGetPlayerNickname() then
      if imgui.Button(u8"Записать в файл") then
        file = io.open(getWorkingDirectory().."\\resource\\ads_source.txt", "a")
        file:write(p_text.."\n") 
        file:close()
      end
    end
    imgui.End()
  end
end

--- DEVELOPER ZONE ---

function tab_concat_acm(key_t)
  return table.concat(rkeys.getKeysName(key_t))
end
