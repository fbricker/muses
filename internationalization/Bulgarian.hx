package internationalization;


class Bulgarian extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Включи");
		setText("stop","Изключи");
		setText("ioError","Грешка в свързването");
		setText("loadComplete","Грешка: Завършено зареждане");
		setText("soundComplete","Грешка: Завършено зареждане на звук");
		setText("volume","Сила на звука");
		setText("securityError","Грешка в сигурността");
		setText("about","За FFMp3...");		
		setText("version", "Версия ....");
		setText("intro","Интро");
	}
}