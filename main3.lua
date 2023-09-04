require "msgbox"

obj {
    nam = 'kname';
    dsc = [[Расскажи мне, как зовут твоего {кота} - второй вариант вызова окна]];
    act = function()
		p [[Во всплывающем окне введите ваше имя или имя вашего котика.]];

		msgbox:show("Введи имя кота")
    end;
}

obj {
	nam = 'gotoend';
	dsc = [[Прогуляйся в {конец}]];
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

	dsc = function(s)
		if s.name then
			p ("Привет, ", s.name)
		else
			p [[Как зовут твоего {@msgbox "Имя"|кота}? - первый вариант вызова окна]];
		end
	end;

    obj = { 'kname', 'gotoend' };

	onmsg = function(s, w)

		if w == 'Барсик' then
			walk 'theend'
			return
		end
		s.name = w
		if s.name then
			dprint("Имя кота: ", s, s.name)
			pn ("Привет, ", s.name)
		end

	end;
	onexit = function(s, t)
		msgbox:hide()
	end 
}

room {
	nam = 'theend';
	title = 'Конец';
	dsc = [[WOW! Вы назвали верное имя кота]];
}



