package internationalization;

class AbstractLanguage {
	private var byText:Hash<String>;
	
	public function new(){
		byText=new Hash<String>();
	}
	
	public function getText(key:String):String{
		return byText.get(key);
	}
	
	public function getTextByStatus(status:FFMp3PlayerStatus):String{
		return getText(Type.enumConstructor(status));
		
	}
	
	function setText(key,text:String){
		byText.set(key,text);
	}
}