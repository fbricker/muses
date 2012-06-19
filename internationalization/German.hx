package internationalization;


class German extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Abspielen");
		setText("stop","Stop");
		setText("ioError","Netzwerk-Fehler");
		setText("loadComplete","Fehler: Full Load");
		setText("soundComplete","Fehler: Full Audio");
		setText("volume","Lautstärke");
		setText("securityError","Sicherheit Fehler");
		setText("about","Über FFMP3...");		
		setText("version","Version");
	}
}