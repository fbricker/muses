package internationalization;


class French extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Jouer");
		setText("stop","Arrêter");
		setText("ioError","Erreur réseau");
		setText("loadComplete","Erreur: Chargement complet");
		setText("soundComplete","Erreur: Son complet");
		setText("volume","Volume");
		setText("securityError","Erreur de sécurité");
		setText("about","A propos de FFMP3...");		
		setText("version","Version");
	}
}