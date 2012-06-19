package internationalization;


class Dutch extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Afspelen");
		setText("stop","Stoppen");
		setText("ioError","Netwerkfout");
		setText("loadComplete","Fout: Laden afgelopen");
		setText("soundComplete","Fout: Geluid afgelopen");
		setText("volume","Volume");
		setText("securityError","Beveiligingsfout");
		setText("about","Over FFMp3...");		
		setText("version","Versie");
	}
}