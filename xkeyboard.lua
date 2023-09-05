require "fmt"
require "noinv"
require "keys"
local std = stead

local input = std.ref '@input'

local keyb = {
	{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", },
	{ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", },
	{ "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", },
	{ "z", "x", "c", "v", "b", "n", "m", ",", ".", "`", "/", },
}

local kbden = {
	shifted = {
	["1"] = "!",
	["2"] = "@",
	["3"] = "#",
	["4"] = "$",
	["5"] = "%",
	["6"] = "^",
	["7"] = "&",
	["8"] = "*",
	["9"] = "(",
	["0"] = ")",
	["-"] = "_",
	["="] = "+",
	["["] = "[",
	["]"] = "]",
	["\\"] = "|",
	[";"] = ":",
	["'"] = "\"",
	[","] = "<",
	["."] = ">",
	["/"] = "?",
	}
}

local kbdru = {
	["q"] = "й",
	["w"] = "ц",
	["e"] = "у",
	["r"] = "к",
	["t"] = "е",
	["y"] = "н",
	["u"] = "г",
	["i"] = "ш",
	["o"] = "щ",
	["p"] = "з",
	["["] = "х",
	["]"] = "ъ",
	["a"] = "ф",
	["s"] = "ы",
	["d"] = "в",
	["f"] = "а",
	["g"] = "п",
	["h"] = "р",
	["j"] = "о",
	["k"] = "л",
	["l"] = "д",
	[";"] = "ж",
	["'"] = "э",
	["z"] = "я",
	["x"] = "ч",
	["c"] = "с",
	["v"] = "м",
	["b"] = "и",
	["n"] = "т",
	["m"] = "ь",
	[","] = "б",
	["."] = "ю",
	["`"] = "ё",
	["/"] = ".",
	shifted = {
	["q"] = "Й",
	["w"] = "Ц",
	["e"] = "У",
	["r"] = "К",
	["t"] = "Е",
	["y"] = "Н",
	["u"] = "Г",
	["i"] = "Ш",
	["o"] = "Щ",
	["p"] = "З",
	["["] = "Х",
	["]"] = "Ъ",
	["a"] = "Ф",
	["s"] = "Ы",
	["d"] = "В",
	["f"] = "А",
	["g"] = "П",
	["h"] = "Р",
	["j"] = "О",
	["k"] = "Л",
	["l"] = "Д",
	[";"] = "Ж",
	["'"] = "Э",
	["z"] = "Я",
	["x"] = "Ч",
	["c"] = "С",
	["v"] = "М",
	["b"] = "И",
	["n"] = "Т",
	["m"] = "Ь",
	[","] = "Б",
	["."] = "Ю",
	["`"] = "Ё",
	["1"] = "!",
	["2"] = "@",
	["3"] = "#",
	["4"] = ";",
	["5"] = "%",
	["6"] = ":",
	["7"] = "?",
	["8"] = "*",
	["9"] = "(",
	["0"] = ")",
	["-"] = "_",
	["="] = "+",
	["/"] = ",",
	}
}
local kbdlower = {
	['А'] = 'а',
	['Б'] = 'б',
	['В'] = 'в',
	['Г'] = 'г',
	['Д'] = 'д',
	['Е'] = 'е',
	['Ё'] = 'ё',
	['Ж'] = 'ж',
	['З'] = 'з',
	['И'] = 'и',
	['Й'] = 'й',
	['К'] = 'к',
	['Л'] = 'л',
	['М'] = 'м',
	['Н'] = 'н',
	['О'] = 'о',
	['П'] = 'п',
	['Р'] = 'р',
	['С'] = 'с',
	['Т'] = 'т',
	['У'] = 'у',
	['Ф'] = 'ф',
	['Х'] = 'х',
	['Ц'] = 'ц',
	['Ч'] = 'ч',
	['Ш'] = 'ш',
	['Щ'] = 'щ',
	['Ъ'] = 'ъ',
	['Э'] = 'э',
	['Ь'] = 'ь',
	['Ы'] = 'ы',
	['Ю'] = 'ю',
	['Я'] = 'я',
}

local function use_text_event(key)
	if key == "return" or key == "space" or key == "backspace" then
		return false
	end
	return instead.text_input and instead.text_input()
end

local function tolow(s)
	if not s then
		return
	end
	s = s:lower();
	local xlat = kbdlower
	if xlat then
		local k,v
		for k,v in pairs(xlat) do
			s = s:gsub(k,v);
		end
	end
	return s;
end

local function kbdxlat(s, k)
	local kbd

	if k:len() > 1 then
		return
	end

	if s.alt_xlat and
		(game.codepage == 'UTF-8' or game.codepage == 'utf-8') then
		kbd = kbdru;
	else
		kbd = kbden
	end

	if kbd and s.shift then
		kbd = kbd.shifted;
	end

	if not kbd[k] then
		if s.shift then
			return k:upper();
		end
		return k;
	end
	return kbd[k]
end

local hook_keys = {
	['a'] = true, ['b'] = true, ['c'] = true, ['d'] = true, ['e'] = true, ['f'] = true,
	['g'] = true, ['h'] = true, ['i'] = true, ['j'] = true, ['k'] = true, ['l'] = true,
	['m'] = true, ['n'] = true, ['o'] = true, ['p'] = true, ['q'] = true, ['r'] = true,
	['s'] = true, ['t'] = true, ['u'] = true, ['v'] = true, ['w'] = true, ['x'] = true,
	['y'] = true, ['z'] = true, ['1'] = true, ['2'] = true, ['3'] = true, ['4'] = true,
	['5'] = true, ['6'] = true, ['7'] = true, ['8'] = true, ['9'] = true, ['0'] = true,
	["-"] = true, ["="] = true, ["["] = true, ["]"] = true, ["\\"] = true, [";"] = true,
	["'"] = true, [","] = true, ["."] = true, ["/"] = true, ['space'] = true, ['backspace'] = true, ['`'] = true,
	['left alt'] = true, ['right alt'] = true, ['alt'] = true, ['left shift'] = true,
	['right shift'] = true, ['shift'] = true, ['return'] = true,
}

obj {
	nam = '@xkeyboard';
	text = '';
	alt = false;
	numeric = false;
	shift = false;
	alt_xlat = false;
	noinv = true;
	cursor = '|';
	title = false;
	argz = {};
	msg = '> ';
	my = false; -- обратная ссылка на msgbox

	ini = function(s, load)
		s.alt = false
		if load and std.here() == s then
			s.__flt = instead.mouse_filter(0)
		end
	end;
	enter = function(s, my)
		s.text = '';
		s.alt = false
		s.shift = false
		s.__flt = instead.mouse_filter(0)
		s.__oldquotes = fmt.quotes
		fmt.quotes = false
		s.my = my
	end;
	exit = function(s)
		instead.mouse_filter(s.__flt)
		fmt.quotes = s.__oldquotes
		s.my = false
	end;
	onkey = function(s, press, key)
		if not use_text_event() then
			if key:find("alt") then
				s.alt = press
				if not press then
					s.alt_xlat = not s.alt_xlat
				end
				s:decor()
				return false
			end
			if s.alt then
				return false
			end
			if key:find("shift") then
				s.shift = press
				return true
			end
		end
		if not press then
			return false
		end
		if s.alt then
			return false
		end
		if not use_text_event(key) then
			return std.call(_'@kbdinput', 'act', key);
		end
		return false
	end;
	show_input = function(s)
		return s.msg..s.text..s.cursor
	end;
	show_keys = function(s)
		local ppp = ''
		local k,v
		for k, v in ipairs(keyb) do
			local kk, vv
			local row = ''
			for kk, vv in ipairs(v) do
				if s.numeric and not std.tonum(vv) then
					break
				end
				local a = kbdxlat(s, vv)
				if vv == ',' then
					vv = 'comma'
				elseif vv == '\\' then
					vv = 'bsl'
				end
				row = row.."{@kbdinput \""..vv.."\"|"..(a).."}".. "  ";
			end
			ppp = ppp..(row).."\n"
			if s.numeric then
				break
			end
		end
		if s.numeric then
			ppp = ppp.."\n"..([[{@kbdinput cancel|«Отмена»}    {@kbdinput backspace|«Забой»}    {@kbdinput return|«Ввод»}]]).."\n";
		else
			ppp = ppp.."\n"..([[{@kbdinput alt|«Alt»}    {@kbdinput shift|«Shift»}    {@kbdinput space|«Пробел»}    {@kbdinput cancel|«Отмена»}    {@kbdinput backspace|«Забой»}    {@kbdinput return|«Ввод»}]]).."\n";
		end
		return ppp;
	end;
	update = function(s, command, data)

		if s.my then
			if command == "act" then
				s.act(s, data);
			end;
			if command == "write" then
				s.write(s, data);
			end;			

			s.my.update(s.my, command, data, s.text)
		end
	end;
	write = function(s, w)

		s.text = s.text..w;
	end;
	act = function(s, w)

		if w == 'comma' then
			w = ','
		elseif w == 'bsl' then
			w = '\\'
		end
		if w:find("alt") then
			s.alt_xlat = not s.alt_xlat
			return true
		end

		if w:find("shift") then
			s.shift = not s.shift
			return true
		end

		if w == 'space' then
			w = ' '
		end
		if w == 'backspace' then

			if not s.text or s.text == '' then
				return
			end
			if s.text:byte(s.text:len()) >= 128 then
				s.text = s.text:sub(1, s.text:len() - 2);
			else
				s.text = s.text:sub(1, s.text:len() - 1);
			end

		elseif w == 'cancel' or w == 'escape' then
			s.text = '';
		elseif w == 'return' then
			return s.text
		else
			w = kbdxlat(s, w)
			s.text = s.text..w;
		end

	end;

}

local hooked
local orig_filter, orig_text

std.mod_start(function(load)

	if not hooked then
		hooked = true
		orig_filter = std.rawget(keys, 'filter')
		std.rawset(keys, 'filter', std.hook(keys.filter,
		function(f, s, press, key)
				if _'@xkeyboard'.my then
					if _'@xkeyboard'.numeric and not std.tonum(key) and key ~= 'backspace' and key ~= 'return' then
						return false
					end
					-- dprint("KEYPRESS 1", key, f, s, press)
					if press then
						if  key == 'space' or key == 'backspace' or key == 'return' or key == 'escape' then
							_'@xkeyboard':update("act", key)
						end
					end
					return hook_keys[key]
				end
				-- dprint("KEYPRESS 2", f, s, press, key)
				return f(s, press, key)
		end))
		orig_text = std.rawget(input, 'text')
		std.rawset(input, 'text', std.hook(input.text,
		function(f, s, text, ...)
				if _'@xkeyboard'.my and text ~= " " and  use_text_event() then
					-- dprint("KEYPRESS 3", text)
					return _'@xkeyboard':update("write", text)
				end
				-- dprint("KEYPRESS 4", f, s, text)
			return f(s, text, ...)
		end))
	end
end)


std.mod_done(function(load)
	hooked = false
	std.rawset(keys, 'filter', orig_filter)
end)

xkeyboard = _'@xkeyboard'