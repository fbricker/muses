package internationalization;


class Spanish extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Reproducir");
		setText("stop","Detener");
		setText("ioError","Error de Red");
		setText("loadComplete","Error: Carga completa");
		setText("soundComplete","Error: Sonido completo");
		setText("volume","Volumen");
		setText("securityError","Error de Seguridad");
		setText("about","Acerca de FFMP3...");		
		setText("version", "Version");
		setText("intro","Intro");
	}
}