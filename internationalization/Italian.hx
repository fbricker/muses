package internationalization;


class Italian extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Riprodurre");
		setText("stop","Fermare");
		setText("ioError","Errore di rete");
		setText("loadComplete","Erreur: Completo carico");
		setText("soundComplete","Errore: Audio completo");
		setText("volume","Volume");
		setText("securityError","Errore di Sicurezza");
		setText("about","Circa FFMP3...");		
		setText("version","Versione");
	}
}