require "msgbox"

-- msgbox
--
-- Два способа открыть окно с вопросом:
-- 1) msgbox:show("Заголовок")
-- 2) Из текста: [[Текст моего {@msgbox "Заголовок окна"|вопроса}?]]
-- 
-- Закрыть программно:
-- msgbox:hide()
--
-- Получить результат:
-- В комнате добавляется обработчик onmsg = function(s, w). Результат в w

game.act = 'Не работает.';
game.use = 'Это не поможет.';
game.inv = 'Зачем мне это?';

obj {
    nam = 'kname';
    dsc = function(s)
		if std.here().name then
			pn ("Добрый день, ", std.here().name, ".")
		else
			pn [[Расскажи мне, как зовут твоего {кота} - второй вариант вызова окна]];
		end
	end;
    act = function()
		p [[Во всплывающем окне введите ваше имя или имя вашего котика.]];

		msgbox:show("Введи имя кота")
    end;
}

declare 'box' (function()
	return obj {
		nam = 'коробка с котом';
		dsc = [[Тут лежит {коробка}.]];
		tak = [[Я взял коробку.]];
	}
end)


obj {
	nam = 'gotoend';
	dsc = [[Прогуляйся в {конец}, словно уже ввёл правильный ответ]];
	act = function()
		walk 'theend'
		return
	end;		
}

room {
    nam = 'main';
    title = 'Демо MsgBox';
	pic = 'gfx/story.png';

	name = false;

	dsc = [[Как зовут твоего {@msgbox "Имя котика"|кота}? - первый вариант вызова окна]];

    obj = { 'kname', 'gotoend'};

	onmsg = function(s, w)

		if w == 'Барсик' then
			walk 'theend'
			return
		end
		s.name = w
		if s.name then
			dprint("Имя кота: ", s, s.name)
			pn ("Привет, ", s.name)
			local o = new (box);
			take(o);
		end

	end;
	onexit = function(s, t)
		msgbox:hide()
	end 
}

obj {
	nam = 'gotomain';
	dsc = [[Прогуляйся в {начало}]];
	act = function()
		walk 'main'
		return
	end;		
}

room {
	nam = 'theend';
	title = 'Конец';
	dsc = [[WOW! Вы назвали верное имя кота]];
	obj = { 'gotomain'};

}




