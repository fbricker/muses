package internationalization;


class Russian extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Воспроизвести");
		setText("stop","Остановить");
		setText("ioError","Ошибка подключения");
		setText("loadComplete","Ошибка: Загрузка завершена");
		setText("soundComplete","Ошибка: Ошибка воспроизведения");
		setText("volume","Уровень звука");
		setText("securityError","Использование запрещено");
		setText("about","Подробнее о FFMp3...");
		setText("version","Версия");
	}
}