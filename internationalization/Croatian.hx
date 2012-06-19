package internationalization;


class Croatian extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Pokreni");
		setText("stop","Zaustavi");
		setText("ioError","Greška u mreži");
		setText("loadComplete","Greška: Učitavanje završeno");
		setText("soundComplete","Greška: Zvuk završen");
		setText("volume","Glasnoća");
		setText("securityError","Sigurnosna greška");
		setText("about","O FFMp3...");
		setText("version","Verzija");
	}
}