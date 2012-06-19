package internationalization;


class Ukrainian extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Відтворити");
		setText("stop","Зупинити");
		setText("ioError","Помилка мережі");
		setText("loadComplete","Помилка: Завантаження завершено");
		setText("soundComplete","Помилка: Звук завершено");
		setText("volume","гучність");
		setText("securityError","Помилка доступу");
		setText("about","Про FFMP3...");
		setText("version", "Версія");
		setText("intro","Вступне вітання");
	}
}