package internationalization;


class Swedish extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Spelar");
		setText("stop","Stoppad");
		setText("ioError", "Nätverksfel");
		setText("loadComplete","Fel: Laddning komplett");
		setText("soundComplete","Fel: Ljud komplett");
		setText("volume","Volym");
		setText("securityError","Säkerhetsfel");
		setText("about","Om FFMp3...");
		setText("version", "Version");
		setText("intro","Intro");
	}
}