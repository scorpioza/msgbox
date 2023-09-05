require "timer"
require "xkeyboard"
require "dbg"
require 'theme'
loadmod "decor"
--[[
Создание декоратора:
D { "имя декоратора", "тип декоратора", параметры ... }
Удаление декоратора:
D { "имя декоратора" }

Получение декоратора, для изменения его параметров:
D"имя декоратора"

Пересоздание декоратора:
D(D"имя декоратора")

Общие аргументы декораторов:
x, y - позиции на сцене
xc, yc - точка центра декоратора (по умолчанию 0, 0 -- левый верхний угол)
xc и yc могут принимать значение true - тогда xc и/или yc расчитаются самостоятельно как центр картинки
w, h - ширина и высотра. Если не заданы, в результате создания декоратора будут вычислены самостоятельно
z - слой. Чем больше - тем дальше от нас. Отрицательные значения - ПЕРЕД слоем текста, положительные - ПОСЛЕ.
click -- если равен true - то клики по этому объекту будут доставляться в here():ondecor() или game:ondecor()

Например:
function game:ondecor(name, press, x, y, btn)
name - имя декоратора
press - нажато или отжато
x, y -- координаты относительно декоратора (с учетом xc, yc)
btn - кнопка

hidden -- если равен true - то декоратор не видим

Если вы используете анимацию, или подсветку ссылок в текстовом декораторе нужно включить таймер на желаемую частоту,
например:
timer:set(50)

Типы декораторов:

"img" - картинка или анимация
Параметры:
сначала идет графический файл, из которого будет создан декоратор.
Вместо файла можно задать declared функцию, возвращающую спрайт.
frames = число -- если это анимация. В анимации кадры записаны в одном полотне. Размер каждого кадра задается w и h.
delay = число мс -- задержка анимации.
background - если true, этот спрайт считается фоном и просто копируется (быстро). Для фонов ставьте z побольше.

fx, fy - числа - если рисуем картинку из полотна, можно указать позицию в котором она находится

Пример:
	D {"cat", "img", "anim.png", x = -64, y = 48, frames = 3, w = 64, h = 54, delay = 100, click = true }
	D {"title", "img", "title.png", x = 400, y = 300, xc = true, yc = true } -- по центру, если тема 800x600


"txt" - текстовое поле
В текстовом поле создается текст с требуемым шрифтом.
В тексте могут быть переводы строк '\n' и ссылки {ссылка|текст}.
Параметры:
font - файл шрифта. Если не указан, берется из темы
size - размер шрифта. Если не указан, берется из темы
interval - интервал. Если не указан, берется из темы
style - число Если не указано, то 0 (обычный)
color - цвет, если не указано, берется из темы
color_link, color_alink - цвет ссылки/подсвеченной ссылки (если не указано, берется из темы)

Ссылки обрабатываются как у декораторов. Например:

function game:ondecor(name, press, x, y, btn, act, ...)
press - нажатие или отжатие (для текстовых декораторов приходит только отжатие
x, y -- координаты ОТНОСИТЕЛЬНО декоратора
name -- имя декоратора
act и ... -- ссылка и ее аргументы
Например {walk 'main'|Ссылка}

function game:ondecor(name, press, x, y, btn, act, where)
act будет равен 'walk'
where будет равно 'main'

T('параметр темы', значение) -- смена параметров темы, которые попадут в save
]]--

xkeyboard.alt_xlat = true -- включаем русскую раскладку


declare {
	w = theme.scr.w(), -- ширина игрового окна
	h = theme.scr.h(), -- высота игрового окна

	yy = 65, -- отступ окна сверху
	ww = 260, -- ширина окна
	hh = 165, -- высота текста окна
	heading_h = 30 -- высота заголовка окна
 }
 
local xx = w/2

local bg_colors = {
    bg = "white", -- фон окна
    heading = "#CCCCCC" -- заголовок окна
}

declare 'box_bg' (function (v)
    return sprite.new("box:"..std.tostr(v.w).."x"..std.tostr(v.h)..","..bg_colors[v.name])
end)


function game:ondecor(name, press, x, y, btn, act, a, b)
	-- обработчик кликов декораторов (кроме котика, который обработан в main)

	if name == 'msgtext' and not act then
		D'msgtext':next_page()
		return false

	elseif act == 'close' then
		stead.call(_'@msgbox', 'hide');
	    return
	elseif act == '@kbdinput' then

		local res = xkeyboard:act(a)

		DU('msginput')
		DU('msgtext')

        if a == 'cancel' then
            stead.call(_'@msgbox', 'hide');
            return
        end
        if a == 'return' then
            stead.call(_'@msgbox', 'hide');
			return std.call(std.here(), 'onmsg', res, std.unpack(_'@msgbox'.args))
        end
    end
	return false
end


local update_msg = false

obj {
	nam = '@msgbox';
    title = 'Заголовок окна';
	opened = false;
    args = {};

    msg_input = function(s)
        return xkeyboard:show_input()
    end;

    msg_text = function(s)
        return xkeyboard:show_keys()
    end;

    act =  function(s, w, ...)
		s.args = { ... }
		s.show(s, w)
	end;

	show = function(s, title)

        if s.opened then
            return
        end
        if title then
		    s.title = title
        end        
    
        xkeyboard:enter(s)
    
        D {"heading", "img", box_bg, xc = true, yc = false, x = xx, w = ww+20, y = yy, h = heading_h, z = -1  }
        D {"bg", "img", box_bg, xc = true, yc = false, x = xx, w = ww+20, y = yy+heading_h, h = hh+30, z = -1  }
    
        D {"closetext", "txt", [[{close|X}]], xc = true, yc = false, x = xx, w = ww, y = yy+5, align = 'right', hidden = false, h = heading_h,  z =-2 }
        D {"headingtext", "txt", s.title, xc = true, yc = false, x = xx, w = ww, y = yy+5, align = 'center', hidden = false, h = heading_h,  z =-2 }
        D {"msginput", "txt", s.msg_input, xc = true, yc = false, x = xx, w = ww, y = yy+heading_h+15, align = 'left', hidden = false, h = 30,  z =-1 }
        D {"msgtext", "txt", s.msg_text, xc = true, yc = false, x = xx, w = ww, y = yy+heading_h+30+15, align = 'center', hidden = false, h = hh,  z =-1 }
    
        s.opened = true        

	end;
    hide = function(s)

        if not s.opened then
            return
        end

        DR('heading')
        DR('bg')
        DR('msginput')
        DR('msgtext')
        DR('closetext')
        DR('headingtext')
        
        s.opened = false
    
        xkeyboard:exit()
    end;
    update = function(s, command, data, text)

        if command == "act" and data == 'escape' then
            s.hide(s)
        elseif command == "act" and  data == 'return' then
            s.hide(s)
            update_msg = text
        else
            DU('msginput')
            DU('msgtext')
        end

    end
    
}



function game:timer()
    if update_msg then
        local r = std.call(std.here(), 'onmsg', update_msg, std.unpack(_'@msgbox'.args))
        pr(r)
        update_msg = false
        return true
    end

	return false
end

std.mod_init(function(s)
    timer:set(50)
end)
std.mod_start(function(load)
	_'@msgbox'.opened = false
end)


std.mod_done(function(load)
    _'@msgbox':hide()
end)


msgbox = _'@msgbox'