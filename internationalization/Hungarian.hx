package internationalization;

class Hungarian extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Lejátszás");
		setText("stop","Stop");
		setText("ioError","Hlózati hiba");
		setText("loadComplete","Hiba: a letöltés befejezodött");
		setText("soundComplete","Hiba: a hang megszakadt");
		setText("volume","Hangero");
		setText("securityError","Biztonsági hiba");
		setText("about","Bovebben az FFMp3-ról...");		
		setText("version","Verzió");
	}
}