script_name("MS-Ad Catcher")
script_version("0.4")
script_author("monolith04")
script_description("Ловля объявлений для СМИ Advance RP")

OLD_VERSIONS = "06/01/24 [0.3.2]\
- Список коммерции [BETA] (добавлять нужно вручную через меню)\
\
31/12/23 [0.3.1]\
- Мелкие исправления\
- Обновлено окно тестирования шаблонов\
- Добавлен автоматический сбор и сохранение статистики провереных объявлений и полученых за это денег\
- Отображение статистики за текущий день в окне редактирования\
- Добавлена команда /ads для вывода статистики за текущий день\
\
25/12/23 [0.3]\
- Полностью переработан интерфейс окна публикации объявления\
- Стандартное диалоговое окно \"Публикация объявления\" заменено на скриптовое\
- Отправка объявления нажатием клавиши ENTER\
- Добавлено множество новых шаблонов\
- Исправлено отображение окна при проверке объявления другим сотрудников\
- Добавлено определение сим-карт и конвертация численного формата в литеральный\
\
18/12/23 [0.2.x]\
- Добавлена кнопка для вставки и отправки текста сразу\
\
16/12/23 [0.2.x]\
- Автосокращение названий городов при длине строки больше 70 символов (BETA)\
- Новый цвет окон\
"

-- ПОДКЛЮЧЕНИЕ БИБЛИОТЕК
require "lib.moonloader"
local sampev = require 'lib.samp.events'
local lsg, sf = pcall(require, 'sampfuncs')
local keys = require 'vkeys'
local rkeys = require 'rkeys_old'
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local encoding = require 'encoding'
local mssa = require 'mssa.mss_addons'
local requests = require 'requests'
local as_action = require('moonloader').audiostream_state
local dlstatus = require('moonloader').download_status
-- local toast_ok, toast = pcall(import, 'lib\\mimtoasts.lua')

-- ПЕРЕМЕННЫЕ
imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey

local fa = require 'fAwesome5'
local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({fa.min_range, fa.max_range})

encoding.default = 'CP1251'
u8 = encoding.UTF8

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 14.0,
            font_config, fa_glyph_ranges)
    end
end

-- INI
local inipath = 'msac.ini'
local mainIni = inicfg.load({
    main = {
        ad_fishing = 1,
        tag = "",
        ad_notify_sound = false,
        sound_volume_float = 2.5,
        separator = 0
    },
    colors = {
        imgui_style_number = 1,
        imgui_style_selected_id = 0
    },
    hotkey = {
        ad_fish_key = "[18,79]"
    }
}, inipath)

local msp = "msac_stats.ini"
local msac_stats = inicfg.load({
    data = {
        checked_ad_count = 0,
        earned_money = 0,
        up_money = 0,
        date = os.date("%d.%m.%y")
    }
}, msp)

ads_base = msjson("ads_base")

ads_table = ads_base:Load({})

-- print(ads_table)

function save_ad(raw, edited)
    --к=LV • К  edited:find("%W%=[(LS)|(SF)|(LV)|(TV)|(MM)|(ММ)|(%*%*)]%s[|•]")
    if edited:find("%w%w%s[|•]%s=%w%w%s[|•]") then
        -- print("Section 1", edited)
        left, right = edited:match("(.+)=(.+)")
        --edited = edited:gsub(edited:sub(7, 8), "%%s"):gsub(edited:sub(10, 10), "%%s")
        right = right:gsub(right:find("•") and "•" or right:sub(4, 4), "%%s"):gsub(right:sub(1,2), "%%s")
    
        edited = string.format("%s=%s", left, right)
    elseif edited:find("%W=[%w%W][%w%W]%s[|•~]") then
        -- print("Section 2", edited)
        edited = edited:gsub(edited:sub(3, 4), "%%s"):gsub(edited:find("•") and "•" or edited:sub(4, 4), "%%s")
    elseif edited:find("^[%w%W][%w%W]%s[|•~]") then
        -- print("Section 3", edited)
        edited = edited:gsub(edited:sub(1, 5), "")
    end
    -- print(edited)
    ads_table[raw] = edited

    ads_base:Save(ads_table)

end

function find_base(raw)
    print(string.format("function {0c98ff}find_base{b2b2b2}: {ffa30c}raw {b2b2b2}= {0cfffb}%s", raw))
    return ads_table[raw] or "nf_error"
end


function stats_save()
    inicfg.save(msac_stats, msp)
end

function msac_clear_stats()
    if msac_stats.data.checked_ad_count ~= 0 then
        file = io.open(getWorkingDirectory() .. "\\resource\\msac_stats.txt", "a")
        file:write(msac_stats.data.date .. "\t" .. msac_stats.data.checked_ad_count .. "\t" ..
                       msac_stats.data.earned_money .. "\t" .. msac_stats.data.up_money .. "\t" ..
                       msac_stats.data.up_money + msac_stats.data.earned_money .. "\n")
        file:close()
        sampAddChatMessage("Статистика за {F97B23}" .. msac_stats.data.date ..
                               " {B2B2B2}сохранена | Новая сессия за: {F97B23}" ..
                               os.date("%d.%m.%y"), 0xB2B2B2)
    else
        sampAddChatMessage("Новая сессия за: {F97B23}" .. os.date("%d.%m.%y"), 0xB2B2B2)
    end
    msac_stats.data.checked_ad_count = 0
    msac_stats.data.earned_money = 0
    msac_stats.data.up_money = 0
    msac_stats.data.date = os.date("%d.%m.%y")
    stats_save()
end

-- ДЛЯ IMGUI
local sw, sh = getScreenResolution()
local tLastKeys = {}
local v_ad_fish_key = {
    v = decodeJson(mainIni.hotkey.ad_fish_key)
}

msac_settings = imgui.ImBool(false)
msac_stats_w = imgui.ImBool(false)
msac_news_w = imgui.ImBool(false)
msac_state = imgui.ImBool(false)
msac_checked_w = imgui.ImBool(false)
msac_reedit_w = imgui.ImBool(false)
ad_editor = imgui.ImBool(false)
ad_notify_s = imgui.ImBool(false)
ad_notify_s.v = mainIni.main.ad_notify_sound
separator_id = imgui.ImInt(mainIni.main.separator)
sound_volume = imgui.ImFloat(mainIni.main.sound_volume_float)
ad_buffer = imgui.ImBuffer(256)
reedit_buffer = imgui.ImBuffer(256)
ad_fish_val = imgui.ImInt(2)
ad_fish_val.v = mainIni.main.ad_fishing
tag = imgui.ImBuffer(256)
tag.v = mainIni.main.tag

ad_fishing = mainIni.main.ad_fishing

separators = {}
separators[0] = "|"
separators[1] = "~"
separators[2] = "•"

separator_s = separators[separator_id.v]

ad_sound_url = "https://drive.google.com/uc?export=download&id=19xX_tOl7rUIqu8CaW-eITsDgOIwxjPYB"
ad_sound_dir = getWorkingDirectory() .. "\\resource\\mss\\ad_sound.wav"

function downloader(url, dir)

    downloadUrlToFile(url, dir, download_handler)
end
function download_handler(id, status, p1, p2)
    if stop_downloading then
        stop_downloading = false
        download_id = nil
        print('Загрузка отменена.')
        return false -- прервать загрузку
    end
    if status == dlstatus.STATUS_DOWNLOADINGDATA then
        print(string.format('Загружено %d из %d.', p1, p2))
    elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
        print('Загрузка завершена.')
        thisScript():reload()
    end
end

if doesFileExist(getWorkingDirectory() .. "\\resource\\mss\\ad_sound.wav") == false then
    print("File ad_sound.wav not exists. Downloading...")
    downloader(ad_sound_url, ad_sound_dir)

end

function get_checked_ads()
    gca = true
    sampSendChat("/team " .. getUserId())
end

function check_updates()
    -- ПРОВЕРКА ОБНОВЛЕНИЙ
    sendChatMessage('Проверка обновлений...')
    uv_url = requests.get("https://raw.githubusercontent.com/monolith04/arp-ad-catcher/main/msac_update.json")
    jsn = decodeJson(uv_url.text)
    -- sampAddChatMessage("{F97B23}[MS-AC]: {B2B2B2}Проверка обновлений скрипта...", 0xB2B2B2)
    -- print(jsn["msac_templates"], mss_ads_sv)
    if jsn["msac_version"] > thisScript().version then
        sendChatMessage("{00CC00}Обновление скрипта...")
        url = jsn["msac_url"]
        -- print(dir)
        dir = thisScript().path
        sampAddChatMessage("{F97B23}[MS-AC]: {B2B2B2}Скрипт обновлен до версии: {F97B23}"..jsn["msac_version"], 0xB2B2B2)
        downloader(url, dir)
    elseif jsn["msac_templates"] > mss_ads_sv then
        sendChatMessage("{00CC00}Обновление шаблонов...")
        url = jsn["msac_t_url"]
        dir = getWorkingDirectory() .. "\\lib\\mssa\\mss_ads.lua"
        sampAddChatMessage("{F97B23}[MS-AC]: {B2B2B2}Шаблоны обновлены до версии: {F97B23}"..jsn["msac_templates"], 0xB2B2B2)
        downloader(url, dir)
    end
    return true
end

function goupdate()
    -- print(thisScript().path)
    wait(300)
    downloadUrlToFile(url, dir, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
        if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
            print("{F97B23}[MS-AD] {B2B2B2}Updated!")
        end
    end)
end

require "lib.mssa.mss_ads"
ad_fishing_state = "Stop"
SwitchColorTheme = function()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec2 = imgui.ImVec2
    local ImVec4 = imgui.ImVec4

    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 5
    style.ChildWindowRounding = 5
    style.FramePadding = ImVec2(5, 2)
    style.FrameRounding = 3.0
    style.TouchExtraPadding = ImVec2(0, 0)
    style.IndentSpacing = 6.0
    style.ScrollbarSize = 12.0
    style.ScrollbarRounding = 16.0
    style.GrabMinSize = 20.0
    style.GrabRounding = 2.0

    style.WindowTitleAlign = ImVec2(0.5, 0.5)

    colors[clr.Text] = ImVec4(0.90, 0.90, 0.90, 1.00);
    colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00);
    colors[clr.WindowBg] = ImVec4(0.00, 0.00, 0.00, 0.93);
    colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.93);
    colors[clr.PopupBg] = ImVec4(0.11, 0.11, 0.11, 0.90);
    colors[clr.Border] = ImVec4(0.70, 0.70, 0.70, 0.40);
    colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00);
    colors[clr.FrameBg] = ImVec4(0.80, 0.80, 0.80, 0.30);
    colors[clr.FrameBgHovered] = ImVec4(0.90, 0.90, 0.90, 0.40);
    colors[clr.FrameBgActive] = ImVec4(0.90, 0.90, 0.90, 0.45);
    colors[clr.TitleBg] = ImVec4(0.20, 0.20, 0.20, 0.83);
    colors[clr.TitleBgActive] = ImVec4(0.30, 0.30, 0.30, 0.87);
    colors[clr.TitleBgCollapsed] = ImVec4(0.45, 0.45, 0.45, 0.30);
    colors[clr.MenuBarBg] = ImVec4(0.55, 0.55, 0.55, 0.80);
    colors[clr.ScrollbarBg] = ImVec4(0.30, 0.30, 0.30, 0.60);
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.80, 0.30);
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.80, 0.80, 0.80, 0.40);
    colors[clr.ScrollbarGrabActive] = ImVec4(0.80, 0.80, 0.80, 0.40);
    colors[clr.ComboBg] = ImVec4(0.20, 0.20, 0.20, 0.99);
    colors[clr.CheckMark] = ImVec4(0.90, 0.90, 0.90, 0.50);
    colors[clr.SliderGrab] = ImVec4(1.00, 1.00, 1.00, 0.30);
    colors[clr.SliderGrabActive] = ImVec4(0.80, 0.80, 0.80, 1.00);
    colors[clr.Button] = ImVec4(0.67, 0.67, 0.67, 0.60);
    colors[clr.ButtonHovered] = ImVec4(0.67, 0.67, 0.67, 1.00);
    colors[clr.ButtonActive] = ImVec4(0.80, 0.80, 0.80, 1.00);
    colors[clr.Header] = ImVec4(0.90, 0.90, 0.90, 0.45);
    colors[clr.HeaderHovered] = ImVec4(0.90, 0.90, 0.90, 0.80);
    colors[clr.HeaderActive] = ImVec4(0.87, 0.87, 0.87, 0.80);
    colors[clr.Separator] = ImVec4(0.50, 0.50, 0.50, 1.00);
    colors[clr.SeparatorHovered] = ImVec4(0.70, 0.70, 0.70, 1.00);
    colors[clr.SeparatorActive] = ImVec4(0.90, 0.90, 0.90, 1.00);
    colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30);
    colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60);
    colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90);
    colors[clr.CloseButton] = ImVec4(0.90, 0.90, 0.90, 0.50);
    colors[clr.CloseButtonHovered] = ImVec4(0.90, 0.90, 0.90, 0.60);
    colors[clr.CloseButtonActive] = ImVec4(0.70, 0.70, 0.70, 1.00);
    colors[clr.PlotLines] = ImVec4(1.00, 1.00, 1.00, 1.00);
    colors[clr.PlotLinesHovered] = ImVec4(0.90, 0.42, 0.00, 1.00);
    colors[clr.PlotHistogram] = ImVec4(0.85, 0.40, 0.00, 1.00);
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.47, 0.00, 1.00);
    colors[clr.TextSelectedBg] = ImVec4(0.90, 0.42, 0.00, 1.00);
    colors[clr.ModalWindowDarkening] = ImVec4(0.20, 0.20, 0.20, 0.35);

end
-- ОСНОВНАЯ ФУНКЦИЯ
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end -- Проверка на загрузку сф и сампа
    while not isSampAvailable() do
        wait(100)
    end -- Если самп запущен - продолжаем
    -- repeat wait(0) until sampIsLocalPlayerSpawned()
    -- wait(200)
    -- local color = ("%06X"):format(bit.band(sampGetPlayerColor(getUserId()), 0xFFFFFF))
    -- if color ~= "FF6600" then
    --   sampAddChatMessage("{F97B23}MSS - Ad Сatcher "..thisScript().version.." [BETA] {B2B2B2} | Скрипт предназначен только для сотрудников {F97B23}СМИ", 0xb2b2b2)
    --   thisScript():unload()
    -- end
    repeat wait(500) until check_updates()
    while true do
        wait(500)
        break
    end
    -- print(os.date())
    ad_notify = loadAudioStream(getWorkingDirectory() .. "/resource/mss/ad_sound.wav")
    setAudioStreamVolume(ad_notify, sound_volume.v)

    sampAddChatMessage("{F97B23}MSS - Ad Сatcher " .. thisScript().version ..
                           " {B2B2B2}загружен | Меню: {F97B23}/msas {B2B2B2}| Что нового: {F97B23}/ads_news",
        0xb2b2b2)
    if msac_stats.data.date ~= os.date("%d.%m.%y") then
        msac_clear_stats()
    end
    get_checked_ads()
    imgui.Process = false
    imgui.SwitchContext()
    SwitchColorTheme(7) -- стиль ImGUI
    sampSendClickTextdraw(tonumber(531))
    sampRegisterChatCommand("msas", function()
        msac_settings.v = not msac_settings.v
        imgui.Process = msac_settings.v
    end) -- настройки скрипта
    sampRegisterChatCommand("codd", coders)
    sampRegisterChatCommand("test", test_patterns)
    sampRegisterChatCommand("af", ad_fish)
    sampRegisterChatCommand("ads", function()
        sendChatMessage("{EE7C04}" .. msac_stats.data.date ..
                            " | {B2B2B2}Проверено объявлений: {EE7C04}" ..
                            msac_stats.data.checked_ad_count .. " {B2B2B2}| Заработано: {46D627}" ..
                            msac_stats.data.earned_money ..
                            "$ {B2B2B2}| За ускоренные публикации: {2785D6}" ..
                            msac_stats.data.up_money .. "$")
    end)
    sampRegisterChatCommand("ads_stats", show_msac_stats)
    sampRegisterChatCommand("ads_news", msac_news)

    adfish_key = rkeys.registerHotKey(v_ad_fish_key.v, true, ad_fish) -- регистрация горячей клавиши ловли объявлений

    while true do -- безк. цикл
        wait(0)
        if isKeyDown(VK_SHIFT) and isKeyJustPressed(VK_U) then
            thisScript():reload()
        elseif ad_editor.v and isKeyJustPressed(VK_RETURN) then
            sampSendDialogResponse(224, 1, 65535, u8:decode(ad_buffer.v))
        end
    end

end

-- SAMP EVENTS FUNCTIONS

function getPlayerNameByIdWO_(id)
    name = sampGetPlayerNickname(id):gsub("_", " ")
    return name
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text) -- обработка дилогов
    -- chatDebug(dialogId)
    if not title:find("Публикация объявления") and msac_state.v then
        ad_fishing_state = "Pause"
        msac_state_text =
            "{FE8009}Пауза | Для продолжения нажмите кнопку активации"
    end

    if title:find("Публикация объявления") then -- автонастройка скрипта: открытие статистики в меню
        resetIO()
        if ad_notify_s.v then
            setAudioStreamState(ad_notify, as_action.PLAY)
        end
        -- car_speed_down()
        ad_fishing_state = "Pause"
        msac_state_text = "{4180DC}Редактирование"
        ad_sender = text:match("{FFFFFF}Отправитель:		(.*)\nТекст")
        p_text = get_string(text)
        handled_s = ad_handler(p_text)
        string_nil = (handled_s == nil or handled_s:find("ERROR")) and true or false
        -- print(string_nil)
        if string_nil then
            print("PNF_ERROR | Check DB...")
            handled_s = find_base(p_text)
            if handled_s:find("%W=%ps%s%ps%s%W") or handled_s:find("%w%w%s[|•]%s=%%s%s%%s") then
                print("{AC4115}DB:", handled_s, tag.v, separator_s)
                handled_s = string.format(handled_s, tag.v, separator_s)
                print("{AC4115}DB:", handled_s)
            end
        end
        if handled_s == nil then
            handled_s = "{F17C01}Системная ошибка."
        elseif handled_s:find("ERROR") then
            handled_s =
                "{F7AB31}Ошибка обработки. Совпадений с шаблонами не найдено."
        elseif handled_s == "nf_error" then
            handled_s =
                "{F7AB31}Объявление не найдено в базе."
        else
            string_nil = false
            if #handled_s + 5 > 70 then
                handled_s = ad_shortener(handled_s)
            end
            if not handled_s:find("%W=%w%w%s[|•]%s%W") and not handled_s:find("%w%w%s[|•]%s=%w%w%s[|•]") then
                handled_s = tag.v .. " " .. separator_s .. " " .. handled_s
            else
                handled_s = handled_s
            end
        end
        if handled_s:find("AD_SIM_0") then
            handled_s = handled_s:gsub("(AD_SIM_0): ", "")
            AD_SIM_0_FMT = true
        else
            AD_SIM_0_FMT = false
        end
        if not string_nil then
            set_ad_buffer(handled_s)
        else
            set_ad_buffer("")
        end
        ad_editor.v = not ad_editor.v
        imgui.Process = ad_editor.v
        print(handled_s)
        return false
    elseif title:find("Очередь объявлений") then -- автонастройка скрипта: открытие статистики в меню
        if text:find("объявлений пуста") then
            chatDebug("Очередь объявлений пуста")
            return false
        end
    elseif title:find("Проверенные объявления") then
        checked_ads_dialog_id = dialogId
        local value_index = 0
        all_values = {}
        for a, b, c in text:gmatch("(.-)\t(.-)\t(.-)\n") do
            all_values[value_index] = {a, b, c}
            value_index = value_index + 1
        end
        -- msac_checked_w.v = not msac_checked_w.v
        -- imgui.Process = msac_checked_w.v
        -- return false
    elseif title:find("Повторное редактирование") then
        --[[{FFFFFF}Отправитель:		Theodore_Perez
    Проверил:		Rainer_Wetzel
    До редактир.:		{FFCC15}Лучшее топливо на АЗС у Администрации Президента! | 10л - 50$ | Fuel 1
    {FFFFFF}После редакт.:		{FFCC15}SF ~ Лучшее топливо на АЗС у Админ. Президента! | 10л-50$ | Fuel 1
    
    {FFFFFF}Введите новый текст или поставьте знак {FF8500}- {FFFFFF}для удаления этого объявления]]
        sender_name, checker_name, ad_before, ad_after = text:match(
            "%p\t\t(.-)\n.-%p\t\t(.-)\n.-%p\t\t{......}(.-)\n.-\t\t{......}(.-)\n")
        reedit_data = {sender_name, checker_name, ad_before, ad_after}
        reedit_buffer.v = u8(ad_after)
        msac_reedit_w.v = not msac_reedit_w.v
        imgui.Process = msac_reedit_w.v
        return false
        -- print(tableToString(all_values))
    elseif gca and title:find("Отчёт за сегодня") then
        checked_ads = text:match("\t(%d+)%s?шт")
        msac_stats.data.checked_ad_count = checked_ads
        msac_stats.data.earned_money = checked_ads * 60
        stats_save()
        gca = false
        return false
    end
end

function sampev.onSendDialogResponse(id, btn, lb, ti)
    -- print(tableToString({id, btn, ld, ti}))
end

function sampev.onTextDrawSetString(id, text)
    if id == 243 then
        if ad_fishing == 1 then
            if ad_fishing_f then
                ad_count = tonumber(text)
                if ad_count > 0 then
                    sampSendChat("/edit")
                else
                    chatDebug("Нет новых объявлений")
                end
            end
        end
    end
end

function sampev.onServerMessage(color, text)
    if text:find(
        "Объявление отредактировано и поставлено в очередь на публикацию") then
        msac_stats.data.checked_ad_count = msac_stats.data.checked_ad_count + 1
        msac_stats.data.earned_money = msac_stats.data.earned_money + 60
        stats_save()
        ad_editor.v = false
        ad_fishing_state = "Run"
        msac_state_text = "{46D627}Ловим объявления..."
    end
    if text:find("Вы получили 500$ за ускоренную публикацию") then
        msac_stats.data.up_money = msac_stats.data.up_money + 500
        stats_save()
    end
    if text:find("отклонил объявление") then
        if text:find(sampGetPlayerNickname(getUserId())) then
            ad_editor.v = false
            ad_fishing_state = "Run"
            msac_state_text = "{46D627}Ловим объявления..."
        end
    end
    if text:find("Объявление пропущено.") then
        ad_editor.v = false
        ad_fishing_state = "Run"
        msac_state_text = "{46D627}Ловим объявления..."
    end
    if text:find("Отредактированный текст слишком длинный") then
        ad_editor.v = false
        ad_fishing_state = "Run"
        msac_state_text = "{46D627}Ловим объявления..."
    end
    if text:find(
        "Редактируемое Вами объявление удалено, т.к. телефон отправителя вне зоны действия") then
        ad_editor.v = false
        ad_fishing_state = "Run"
        msac_state_text = "{46D627}Ловим объявления..."
    end
    if text:find(
        "Произошла ошибка. Это объявление было проверено другим сотрудником") then
        ad_editor.v = false
        ad_fishing_state = "Run"
        msac_state_text = "{46D627}Ловим объявления..."
    end
    if text:find("Нет новых объявлений") then
        -- addOneOffSound(0.0, 0.0, 0.0, 1074)
        -- debug("Нет новых объявлений", 5)
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

    if str:find("[(LS)|(SF)|(LV)|(TV)|(MM)|(ММ)|(%*%*)]%s[|•]") then
        first_letter = str:sub(0, 5)
        string = first_letter .. "=" .. tag.v .. " " .. separator_s .. " "
    else
        first_letter = str:sub(0, 1)
        string = first_letter .. "=" .. tag.v .. " " .. separator_s .. " " .. first_letter
    end
    return string
end

function ad_fish()
    if ad_fishing_state == "Pause" then
        ad_fishing_state = "Run"
        msac_state_text = "{46D627}Ловим объявления..."
        return
    end
    msac_state_text = "{46D627}Ловим объявления..."
    if mainIni.main.ad_fishing == 1 then
        ad_fishing_f = not ad_fishing_f

    elseif mainIni.main.ad_fishing == 2 then
        ad_fishing_f = not ad_fishing_f
        ad_fishing_state = "Run"
        start_ad_fishing()
    end
    if ad_fishing_f then
        msac_state.v = true
        imgui.Process = msac_state.v
        -- debug("Ловля запущена", 6)
    else
        msac_state.v = false
        -- debug("Ловля выключена", 5)
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
                if ad_fishing_state ~= "Pause" then
                    break
                end
            end
        end
    end)
end

function coders()
    p_text = "Комиссия 0.8 процента в банке в д.Palomino Creek.GPS:6-3."
    handled_s = ad_handler(p_text)
    ad_sender = "Rainer_Wetzel"
    if handled_s:find("AD_SIM_0") then
        handled_s = handled_s:gsub("(AD_SIM_0): ", "")
        AD_SIM_0_F = true
    else
        AD_SIM_0_F = true
    end
    handled_s = handled_s
    ad_editor.v = not ad_editor.v
    imgui.Process = ad_editor.v
    --[[boolresult, vehicle_car = sampGetCarHandleBySampVehicleId(int)
  primaryColor, secondaryColor = getCarColours(vehicle_car)
  print(primaryColor, secondaryColor)]]
end

function test_patterns()
    text = '{B2B2B2}'
    file = io.open(getWorkingDirectory() .. "\\resource\\ads_source.txt", "r")
    if file:read() == nil then
        text = "{B2B2B2}Файл с шаблонами пуст."
    else
        for line in file:lines() do
            -- debug(line, 5)
            if not line:find("***") then
                handl = ad_handler(line)
                -- print(line, handl)
                
                if (handl == nil) or (handl:find("ERROR")) then

                    shortened =
                        "{F7AB31}Ошибка обработки. Совпадений с шаблонами не найдено."
                    h_len = "{F7AB31} (ERROR)"
                    handl = find_base(line)
                    -- print(string_nil)
                    -- if string_nil then
                    --     print("PNF_ERROR | Check DB...")
                    --     handled_s = find_base(p_text)
                    --     if handled_s:find("%W=%ps%s%ps%s%W") or handled_s:find("%w%w%s[|•]%s=%w%w%s[|•]") then
                    --         print("{AC4115}DB:", handled_s, tag.v, separator_s)
                    --         handled_s = string.format(handled_s, tag.v, separator_s)
                    --         print("{AC4115}DB:", handled_s)
                    --     end
                    -- end
                    if handl == "nf_error" then
                        shortened = "{F7AB31}Ошибка обработки. В базе не найдено."
                    else
                        -- print("{AC4115}DB | Found:", string.format(handl, tag.v, separator_s))
                        if handl:find("%W=%ps%s%ps%s%W") or handl:find("%w%w%s[|•]%s=%%s%s%%s") then
                            -- print("{AC4115}DB:", string.format(handl, tag.v, separator_s))
                            shortened = string.format(handl, tag.v, separator_s)
                            h_len = "{2dafff} | (автозамена)"
                            
                        else
                            tp_ad_len, len_color, shortened = handl_ad_len(handl)
                            h_len = len_color .. " | (" .. tp_ad_len .. " сим.)"
                        end
                    end
                else
                    tp_ad_len, len_color, shortened = handl_ad_len(handl)
                    h_len = len_color .. " | (" .. tp_ad_len .. " сим.)"
                end
                text = text .. line .. '\n{6EE2BC}' .. shortened .. h_len .. "\n\n{B2B2B2}"
            end
        end
    end
    sampShowDialog(3525, "{6EE2BC}Тестирование шаблонов", text, "Закрыть")
end

function handl_ad_len(str)
    if #str + 5 > 70 then
        ad_str = ad_shortener(str)
        -- print(ad_str)
        if #ad_str + 5 > 70 then
            len_color = "{E26E6E}"
        else
            len_color = "{7CE26E}"
        end
        tp_ad_len = #ad_str
    else
        tp_ad_len = #str
        len_color = "{7CE26E}"
        ad_str = str
    end
    return tp_ad_len + 5, len_color, ad_str
end

function ad_shortener(str)

    if str:find("Las Venturas") then
        s_str = str:gsub("Las Venturas", "LV"):gsub("ш. ", "")
    elseif str:find("San Fierro") then
        s_str = str:gsub("San Fierro", "SF"):gsub("ш. ", "")
    elseif str:find("Los Santos") then
        s_str = str:gsub("Los Santos", "LS"):gsub("ш. ", "")
    elseif str:find("автомобиль марки") then
        s_str = str:gsub("автомобиль марки", "а/м")
    elseif str:find("мотоцикл марки") then
        s_str = str:gsub("мотоцикл марки", "мотоцикл")
    elseif str:find("серьёзных отношений") then
        s_str = str:gsub("серьёзных отношений", "c/о")
    elseif str:find("среднего класса") then
        s_str = str:gsub(" среднего класса", " сред. кл.")
    elseif str:find("эконом класса") then
        s_str = str:gsub("эконом класса", "эк. кл.")
    elseif str:find("временное жильё") then
        if str:find("евроремонтом") then
            s_str = str:gsub("временное жильё", "врем. жильё"):gsub("евроремонтом",
                "ремонтом")
        else
            s_str = str:gsub("временное жильё", "врем. жильё")
        end
    elseif str:find("евроремонтом") then
        s_str = str:gsub("евроремонтом", "ремонтом")
    elseif str:find("[Аа]укц") then
        if str:find("[Ээ]литного") or str:find("Элитный") then
            s_str = str:gsub("элитного класса", "элитный"):gsub("Э", "э")
        elseif str:find("аукцион выставлен") then
            s_str = str:gsub("аукцион выставлен", "аукционе")
        end
    elseif str:find("бизнес «Парикмахерская»") then
        s_str = str:gsub("бизнес «Парикмахерская»", "парикмахерскую")
    elseif str:find("С моей доплатой") then
        s_str = str:gsub("доплатой", "ДП")
    else
        s_str = str
    end
    -- print("{FF2233}Shortened: "..s_str)
    return s_str
end

function offs()
    thisScript():unload()
end

function mss_reload()
    thisScript():reload()
end

function show_msac_stats()
    line_number = 0
    msac_stats_data = {}
    file = io.open(getWorkingDirectory() .. "\\resource\\msac_stats.txt", "r")
    for i in file:lines() do
        s_date, s_ads, s_money, s_upmoney, s_total = i:match("(.+)\t(%d+)\t(%d+)\t(%d+)\t(%d+)")
        msac_stats_data[line_number] = {s_date, s_ads, s_money, s_upmoney, s_total}
        line_number = line_number + 1
    end
    file:close()
    msac_stats_w.v = not msac_stats_w.v
    imgui.Process = msac_stats_w.v
end

function msac_news()
    msac_news_w.v = not msac_news_w.v
    imgui.Process = msac_news_w.v
end

function imgui.OnDrawFrame() -- отрисовка ImGui окон (каждый кадр)
    imgui.SetMouseCursor(imgui.MouseCursor.None)
    imgui.ShowCursor = false
    if not msac_settings.v and not ad_editor.v and not msac_stats_w.v and not msac_state.v and not msac_news_w.v and
        not msac_checked_w.v and not msac_reedit_w.v then -- and not test_menu.v then -- предотвращает загрузку ImGui окон сразу после запуска игры
        imgui.Process = false
    else
        imgui.Process = true
    end

    if msac_settings.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(415, 325), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.ICON_FA_AD .. u8 ' Ловля объявлений', msac_settings, imgui.WindowFlags.NoResize) -- обратите внимание на u8 перед текстом, это и есть преобразование кодировки
        imgui.SetCursorPos(imgui.ImVec2(5, 25))
        imgui.BeginChild('##main', imgui.ImVec2(405, 295), true)
        imgui.PushItemWidth(100)
        if imgui.Combo(u8 "Разделитель для тэга", separator_id,
            {u8 "«Палка» (|)", u8 "Тильда (~)", u8 "Точка"}, 3) then
            separator_s = separators[separator_id.v]
            mainIni.main.separator = separator_id.v
            inicfg.save(mainIni, inipath)
        end
        imgui.Tooltip(
            u8 "Разделитель используется для разделения тэга и текста объявления.\nПример («палка»): [ТЭГ] | [Текст объявления]\nLS | Куплю дом. Цена договорная.")
        imgui.InputText(u8 "Тэг", tag)
        if imgui.HotKey("##ADF", v_ad_fish_key, tLastKeys, 100) then
            sampAddChatMessage("Новая клавиша для запуска ловли: {F97B23}" ..
                                   tab_concat_acm(v_ad_fish_key.v), 0xB2B2B2)
            rkeys.changeHotKey(adfish_key, v_ad_fish_key.v)
            mainIni.hotkey.ad_fish_key = encodeJson(v_ad_fish_key.v, true)
            inicfg.save(mainIni, inipath)
        end
        imgui.SameLine()
        imgui.TextColoredHex("Активация {F97B23}ловли объявлений")
        imgui.Separator()
        imgui.CenterTextColoredRGB("{F97B23}Ловля обьявлений")
        if imgui.CustomRadioButton("Lite", ad_fish_val, 1, imgui.ImVec2(imgui.GetWindowSize().x / 2.1, 20)) then
            mainIni.main.ad_fishing = ad_fish_val.v
            inicfg.save(mainIni, inipath)
        end
        imgui.Tooltip(
            u8 'Вводит комманду /edit при наличии объявлений.\nПроверяет наличие с текстдрава возле радара.\nВызывается раз в 26 секунд.')
        imgui.SameLine()
        if imgui.CustomRadioButton("Brute Force", ad_fish_val, 2, imgui.ImVec2(imgui.GetWindowSize().x / 2.15, 20)) then
            mainIni.main.ad_fishing = ad_fish_val.v
            inicfg.save(mainIni, inipath)
        end
        imgui.Tooltip(u8 'Усиленная ловля - отправляет /edit каждые 2 секунды.')
        imgui.CenterTextColoredRGB("{F97B23}Команды")
        imgui.Columns(2, "commands", false)
        imgui.TextColoredHex("{SSSSSS}Окно с настройками")
        imgui.TextColoredHex("{SSSSSS}Ловля объявлений")
        imgui.TextColoredHex("{SSSSSS}Вывод статистики за сегодня")
        imgui.TextColoredHex("{SSSSSS}Вывод общей статистики")
        imgui.NextColumn()
        imgui.TextColoredHex("{F97B23}/msas")
        imgui.TextColoredHex("{F97B23}/af")
        imgui.TextColoredHex("{F97B23}/ads")
        imgui.TextColoredHex("{F97B23}/ads_stats")
        imgui.Columns()
        imgui.Separator()
        if imgui.ToggleButton(u8 "Ad Sound", ad_notify_s) then
            mainIni.main.ad_notify_sound = ad_notify_s.v
            inicfg.save(mainIni, inipath)
        end
        imgui.Tooltip(
            u8 "При появлении окна редактирования объявления проигрывается звук.")
        imgui.SameLine()
        imgui.Text(u8 "Звуковое оповещение пойманого объявления")
        if imgui.SliderFloat(u8 "Громкость", sound_volume, 0.0, 5.0, "%.1f") then
            setAudioStreamVolume(ad_notify, sound_volume.v)
        end
        imgui.SameLine()
        if imgui.Button(u8 "Проверить", imgui.ImVec2(-1, 20)) then
            setAudioStreamState(ad_notify, as_action.PLAY)
        end
        if imgui.Button(u8 "Сохранить", imgui.ImVec2(-1, 20)) then
            mainIni.main.sound_volume_float = sound_volume.v
            mainIni.main.tag = tag.v
            inicfg.save(mainIni, inipath)
        end

        imgui.EndChild()
        imgui.End()
    end

    if ad_editor.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(650, 320), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.ICON_FA_AD .. u8 " Редактор объявлений", nil, imgui.WindowFlags.NoResize)
        imgui.BeginChild("texts", imgui.ImVec2(-1, 265), true, imgui.WindowFlags.NoScrollbar)

        imgui.CenterTextColoredRGB("Отправитель: {F97B23}" .. ad_sender)
        imgui.CenterTextColoredRGB("Текст объявления:")
        imgui.CenterTextColoredRGB("{F97B23}" .. p_text)
        imgui.Separator()
        imgui.CenterTextColoredRGB(
            "Отредактированное объявление {F97B23}(" ..
                #handled_s .. " сим.){SSSSSS}:", true, imgui.GetWindowSize().x)
        imgui.CenterTextColoredRGB("{56DC53}" .. handled_s)
        imgui.PushItemWidth(570)
        imgui.InputText("", ad_buffer)
        imgui.SameLine()
        ad_len = #u8:decode(ad_buffer.v)
        if ad_len > 70 then
            ad_len_color = "{F74545}"
        else
            ad_len_color = "{SSSSSS}"
        end
        imgui.TextColoredHex(ad_len_color .. "(" .. ad_len .. "/70)")
        if imgui.Button(fa.ICON_FA_PASTE .. u8 " Вставить текст", imgui.ImVec2(-1, 20)) then
            set_ad_buffer(handled_s)
        end
        if imgui.Button(fa.ICON_FA_FONT.. u8 " Тэг", imgui.ImVec2(120, 20)) then
            set_ad_buffer(tag.v .. " " .. separator_s .. " ")
        end
        imgui.SameLine()
        if imgui.Button( fa.ICON_FA_BOOK_OPEN ..u8 " ПРО", imgui.ImVec2(120, 20)) then
            set_ad_buffer(tag.v .. " " .. separator_s .. " ПРО")
        end
        imgui.SameLine()
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1, 0.62, 0.00, 0.75))
        -- imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.88, 0.65, 0.35, 0.65))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1, 0.50, 0.0, 0.75))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1, 0.40, 0.0, 0.75))
        if imgui.Button(fa.ICON_FA_LONG_ARROW_ALT_RIGHT .. u8 " Пропустить", imgui.ImVec2(120, 20)) then
            ad_fishing_state = "Stop"
            ad_fishing_f = false
            msac_state.v = false
            ad_editor.v = false
            sampSendDialogResponse(224, 1, 65535, "=")

        end
        imgui.PopStyleColor(3)
        imgui.SameLine()
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.1, 0.7, 0.05, 1))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.1, 0.6, 0.05, 1))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.05, 1))
        if imgui.Button(fa.ICON_FA_EXCHANGE_ALT .. u8 " Автозамена", imgui.ImVec2(100, 20)) then
            ad_buffer.v = u8(string_replacer(p_text))
        end
        imgui.PopStyleColor(3)
        imgui.SameLine()
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.45, 0.25, 0.98, 0.65))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.65, 0.45, 0.98, 0.65))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.85, 0.65, 0.98, 0.65))
        if imgui.Button(fa.ICON_FA_SAVE .. u8 " Записать в файл", imgui.ImVec2(-1, 20)) then
            sampAddChatMessage("Текст объявления: {8F45F7}\"" .. p_text ..
                                   "\" {B2B2B2}записан в файл {8F45F7}ads_source.txt", 0xB2B2B2)
            file = io.open(getWorkingDirectory() .. "\\resource\\ads_source.txt", "a")
            file:write(p_text .. "\n")
            file:close()
        end
        imgui.PopStyleColor(3)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.1, 0.7, 0.05, 1))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.1, 0.6, 0.05, 1))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.05, 1))
        if imgui.Button(fa.ICON_FA_CHECK_CIRCLE .. u8 " Отправить", imgui.ImVec2((imgui.GetWindowWidth() / 2) - 11, 35)) then
            if #ad_buffer.v ~= 0 then
                sampSendDialogResponse(224, 1, 65535, u8:decode(ad_buffer.v))
                ad_editor.v = false
                ad_fishing_state = "Run"
            else
                sendChatMessage(
                    "Введите текст объявления для отправки или {ffcc00}пропустите {B2B2B2}его.")
            end
        end
        imgui.PopStyleColor(3)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1, 0.1, 0.1, 1))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.8, 0.1, 0.1, 1))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.6, 0.1, 0.1, 1))
        imgui.SameLine()
        if imgui.Button(fa.ICON_FA_TIMES_CIRCLE .. u8 " Отклонить", imgui.ImVec2((imgui.GetWindowWidth() / 2) - 11, 35)) then
            sampSendDialogResponse(224, 0, 65535, u8:decode(ad_buffer.v))
            -- sampSetCurrentDialogEditboxText(handled_s)
        end
        imgui.PopStyleColor(3)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 1.00, 1.00, 0.65))

        imgui.ButtonClickable(false, fa.ICON_FA_INFO_CIRCLE .. u8 " Помощь", imgui.ImVec2(-1, 20))
        imgui.PopStyleColor(1)
        imgui.Tooltip(
            u8 'Вставка тэга - вставит тэг с разделителем в поле.\nПРО - для отклонения объявления по ПРО\nПропустить объявление - и так понятно... \n Автозамена - меняет начало объявления вставляя тэг\n')
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.45, 0.25, 0.98, 0.65))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.65, 0.45, 0.98, 0.65))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.85, 0.65, 0.98, 0.65))
        if imgui.Button(fa.ICON_FA_SAVE .. u8 " Сохранить в базу и отправить", imgui.ImVec2(-1, 20)) then
            chatDebug("Save & senD")
            if #ad_buffer.v ~= 0 then
                sampSendDialogResponse(224, 1, 65535, u8:decode(ad_buffer.v))
                ad_editor.v = false
                ad_fishing_state = "Run"
                save_ad(p_text, u8:decode(ad_buffer.v))
            else
                sendChatMessage(
                    "Введите текст объявления для отправки или {ffcc00}пропустите {B2B2B2}его.")
            end
        end
            imgui.PopStyleColor(3)
        imgui.EndChild()
        imgui.CenterTextColoredRGB("{EE7C04}" .. msac_stats.data.date ..
                                       " | {SSSSSS}Проверено объявлений: {EE7C04}" ..
                                       msac_stats.data.checked_ad_count .. " {SSSSSS}| Заработано: {46D627}" ..
                                       msac_stats.data.earned_money ..
                                       "$ {SSSSSS}| За ускоренные публикации: {2785D6}" ..
                                       msac_stats.data.up_money .. "$")
        imgui.End()
    end

    if msac_stats_w.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(600, 490), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.ICON_FA_AD .. u8 " Статистика редактирования", msac_stats_w,
            imgui.WindowFlags.NoResize)
        imgui.BeginChild('##commerce', imgui.ImVec2(-1, 430), true)
        imgui.Columns(5, "ComList", false)
        imgui.Text(u8 "Дата")
        imgui.SetColumnWidth(0, 110)
        imgui.NextColumn()
        imgui.Text(u8 "Проверено")
        imgui.SetColumnWidth(1, 110)
        imgui.NextColumn()
        imgui.Text(u8 "За публикацию")
        imgui.SetColumnWidth(2, 110)
        imgui.NextColumn()
        imgui.Text(u8 "Ускорение")
        imgui.SetColumnWidth(3, 110)
        imgui.NextColumn()
        imgui.Text(u8 "Всего")
        imgui.SetColumnWidth(4, 110)
        imgui.NextColumn()
        for k, v in pairs(msac_stats_data) do
            imgui.TextColoredHex("{EE7C04}" .. msac_stats_data[k][1])
            imgui.NextColumn()
            imgui.TextColoredHex("{EE7C04}" .. msac_stats_data[k][2])
            imgui.NextColumn()
            imgui.TextColoredHex("{46D627}" .. msac_stats_data[k][3] .. "$")
            imgui.NextColumn()
            imgui.TextColoredHex("{2785D6}" .. msac_stats_data[k][4] .. "$")
            imgui.NextColumn()
            imgui.TextColoredHex("{46D627}" .. msac_stats_data[k][5] .. "$")
            imgui.NextColumn()
        end
        imgui.Columns()
        imgui.EndChild()
        if imgui.Button(u8 "Закрыть", imgui.ImVec2(-1, 20)) then
            msac_stats_w.v = false
        end
        imgui.End()
    end

    if msac_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(600, 20), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 1.05), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.ICON_FA_AD .. u8 "Статус", msac_stats_w,
            imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
        imgui.CenterTextColoredRGB(msac_state_text)
        imgui.End()
    end

    if msac_news_w.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(600, 440), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.ICON_FA_AD .. u8 " История обновлений", msac_news_w, imgui.WindowFlags.NoResize)
        imgui.BeginChild("##UpdatesFrame", imgui.ImVec2(-1, 360), true)
        imgui.CenterTextColoredRGB("Последнее обновление: {EE7C04}MS - Ad Cather v" ..
                                       thisScript().version .. " | 12.03.24")
        imgui.BeginChild("##CurrentVersion", imgui.ImVec2(-1, 150), true)
        imgui.TextWrapped(u8 "- Удалена проверка договоров.\
- Добавлен просмотр статистики. Команда: /msac_stats\
- Убраны всплывающие оповещения ловли. Вместо них теперь отображается панель внизу.\
- Добавлены подсказки в настройках.\
- Другие небольшие исправления.\
- Добавлено окно со списком обновлений")
        imgui.EndChild()
        if imgui.CollapsingHeader(u8 "Прошлые версии", false) then
            imgui.BeginChild("##OldVersions", imgui.ImVec2(-1, 150), true)
            imgui.TextWrapped(u8(OLD_VERSIONS))
            imgui.EndChild()
        end
        imgui.EndChild()
        if imgui.Button(u8 "Закрыть", imgui.ImVec2(-1, 20)) then
            msac_news_w.v = false
        end

        imgui.Separator()
        imgui.CenterTextColoredRGB(
            "{EE7C04}monolith04 (c) 2024 {SSSSSS}| Написать разработичку: SMS - {EE7C04}8338 {SSSSSS}/ VK - {4180DC}vk.com/wetzel.family")
        imgui.End()
    end

    -- if msac_checked_w.v then
    --   imgui.ShowCursor = true
    --   imgui.SetNextWindowSize(imgui.ImVec2(600, 300), imgui.Cond.FirstUseEver)
    --   imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    --   imgui.Begin(fa.ICON_FA_AD..u8" Проверенные объявления", msac_checked_w, imgui.WindowFlags.NoResize)
    --   imgui.BeginChild('##CHECKED_ADS', imgui.ImVec2(-1, 240), true)
    --   imgui.Columns(4,"CHECKED_LIST", false)
    --   imgui.Text(u8(all_values[0][1])) imgui.SetColumnWidth(0, 70) imgui.NextColumn()
    --   imgui.Text(u8(all_values[0][2])) imgui.SetColumnWidth(1, 70) imgui.NextColumn()
    --   imgui.Text(u8(all_values[0][3])) imgui.SetColumnWidth(2, 280) imgui.NextColumn()
    --   imgui.Text(u8"Действие") imgui.NextColumn()
    --   for k, v in pairs(all_values) do
    --     print(tableToString(all_values))
    --     if k ~= 0 then
    --       imgui.TextColoredHex("{EE7C04}"..all_values[k][1])
    --       imgui.NextColumn()
    --       imgui.TextColoredHex("{EE7C04}"..all_values[k][2])
    --       imgui.NextColumn()
    --       imgui.TextColoredHex("{46D627}"..all_values[k][3])
    --       imgui.NextColumn()
    --       if imgui.Button(u8"Редакт.##"..all_values[k][2], imgui.ImVec2(-1, 20)) then
    --         sampSendDialogResponse(344, 1, _, all_values[k][1])
    --         --print(all_values[k][2])
    --         msac_checked_w.v = false
    --       end
    --       imgui.NextColumn()
    --     end
    --   end
    --   imgui.Columns()
    --   imgui.EndChild()
    --   if imgui.Button(u8"Закрыть", imgui.ImVec2(-1,20)) then
    --     msac_checked_w.v = false
    --   end
    --   imgui.End()
    -- end

    if msac_reedit_w.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowSize(imgui.ImVec2(600, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.ICON_FA_AD .. u8 " Повторное редактирование", msac_reedit_w,
            imgui.WindowFlags.NoResize)
        imgui.BeginChild('##RE_EDIT', imgui.ImVec2(-1, 240), true)
        imgui.CenterTextColoredRGB("Отправитель: {56DC53}" .. reedit_data[1])
        imgui.CenterTextColoredRGB("Проверил: {EE7C04}" .. reedit_data[2])
        imgui.Columns(2, "##REEDIT_CLMN", true)
        imgui.Separator()
        imgui.Text(u8 "До ред.:")
        imgui.SetColumnWidth(0, 80)
        imgui.NextColumn()
        imgui.TextColoredHex("{56DC53}" .. reedit_data[3])
        imgui.NextColumn()
        imgui.Separator()
        imgui.Text(u8 "После ред.:")
        imgui.NextColumn()
        imgui.TextColoredHex("{EE7C04}" .. reedit_data[4])
        imgui.Columns()
        imgui.Separator()
        imgui.PushItemWidth(-1)
        imgui.InputText("##REEDIT_INPUT", reedit_buffer)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.1, 0.7, 0.05, 1))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.1, 0.6, 0.05, 1))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.5, 0.05, 1))
        if imgui.Button(u8 "Сохранить", imgui.ImVec2(280.5, 30)) then
            sampSendDialogResponse(345, 1, 65535, u8:decode(reedit_buffer.v))
            msac_reedit_w.v = false
            sampSendChat("/all")
        end
        imgui.PopStyleColor(3)
        imgui.SameLine()
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1, 0.1, 0.1, 1))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.8, 0.1, 0.1, 1))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.6, 0.1, 0.1, 1))
        if imgui.Button(u8 "Удалить", imgui.ImVec2(280.5, 30)) then
            sampSendDialogResponse(345, 1, 65535, "-")
            msac_reedit_w.v = false
            sampSendChat("/all")
        end
        imgui.PopStyleColor(3)
        imgui.EndChild()

        if imgui.Button(u8 "Назад", imgui.ImVec2(-1, 20)) then
            msac_reedit_w.v = false
            sampSendChat("/all")
        end
        imgui.End()
    end
end

function set_ad_buffer(text)
    ad_buffer.v = u8(text)
end

--- DEVELOPER ZONE ---

function tab_concat_acm(key_t)
    return table.concat(rkeys.getKeysName(key_t))
end

function chatDebug(text)
    sampAddChatMessage("{EE7C04}[MSAC Debugger]: {B2B2B2}" .. text, 0xB2B2B2)
end

function sendChatMessage(text)
    sampAddChatMessage("{EE7C04}[MS-AC]: {B2B2B2}" .. text, 0xB2B2B2)
end

function resetIO()
    for i = 1, 512 do
        imgui:GetIO().KeysDown[i] = false
    end
    for i = 1, 5 do
        imgui:GetIO().MouseDown[i] = false
    end
    imgui:GetIO().KeyCtrl = false
    imgui:GetIO().KeyShift = false
    imgui:GetIO().KeyAlt = false
    imgui:GetIO().KeySuper = false
end
