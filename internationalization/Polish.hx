package internationalization;


class Polish extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Odtwórz");
		setText("stop","Stop");
		setText("ioError","Błąd sieciowy");
		setText("loadComplete","Błąd: Ładowanie zakończone");
		setText("soundComplete","Błąd: Ładowanie audio zakończone");
		setText("volume","Głośność");
		setText("securityError","Błąd zabezpieczeń");
		setText("about","O FFmp3...");
		setText("version","Wersja");
	}
}