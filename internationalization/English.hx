package internationalization;


class English extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Play");
		setText("stop","Stop");
		setText("ioError","Network Error");
		setText("loadComplete","Error: Load Complete");
		setText("soundComplete","Error: Sound Complete");
		setText("volume","Volume");
		setText("securityError","Security Error");
		setText("about","About FFMP3...");
		setText("version", "Version");
		setText("intro","Intro");
	}
}