class AudioMetadata {
	public var title:String;
	public var artist:String;
	public var album:String;
	public var genre:String;
	public var comment:String;
	public var encoder:String;
	public var year:String;
	
	public function new(){
		title=artist=album=genre=comment=encoder=year="";
	}
	
	public function set(attr:String,value:String){
		switch(attr.toLowerCase()){
			case 'title': title=value;
			case 'artist': artist=value;
			case 'album': album=value;
			case 'genre': genre=value;
			case 'encoder': encoder=value;
			case 'year': year=value;
		}
	}
	
	public function getJson():String{
		return  '{title:"'+StringTools.replace(title,'"',"'")
		     +'",artist:"'+StringTools.replace(artist,'"',"'")
		      +'",album:"'+StringTools.replace(album,'"',"'")
		      +'",genre:"'+StringTools.replace(genre,'"',"'")
		    +'",comment:"'+StringTools.replace(comment,'"',"'")
		    +'",encoder:"'+StringTools.replace(encoder,'"',"'")
		       +'",year:"'+StringTools.replace(year,'"',"'")+'"}';
	}
}