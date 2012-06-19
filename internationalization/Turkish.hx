package internationalization;


class Turkish extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Çal");
		setText("stop","Durdur");
		setText("ioError","Ağ hatası");
		setText("loadComplete","Hata: Yüklenme Tamamlandı");
		setText("soundComplete","Hata: Yayın Tamamlandı");
		setText("volume","Ses");
		setText("securityError","Güvenlik Hatası");
		setText("about","FFMP3 Hakkında...");
		setText("version","Sürüm");
	}
}