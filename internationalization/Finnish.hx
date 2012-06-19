package internationalization;


class Finnish extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Toista");
		setText("stop","Pysäytä");
		setText("ioError","Verkkoyhteysvirhe");
		setText("loadComplete","Lataaminen päättyi");
		setText("soundComplete","Äänentoisto päättyi");
		setText("volume","Äänenvoimakkuus");
		setText("securityError","Tietoturvavirhe");
		setText("about","Tietoja FFMp3:sta...");
		setText("version","Versio");
	}
}