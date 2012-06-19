package internationalization;

class Portuguese extends AbstractLanguage {
	public function new(){
		super();
		setText("play","Tocar");
		setText("stop","Parar");
		setText("ioError","Erro de Rede");
		setText("loadComplete","Erro: terminou de carregar");
		setText("soundComplete","Erro: fim do áudio");
		setText("volume","Volume");
		setText("securityError","Erro de Segurança");
		setText("about","Sobre FFMP3...");
		setText("version","Versão");
	}
}