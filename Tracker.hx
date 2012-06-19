class Tracker {
	var enabled:Bool;
	var tracked:Hash<Bool>;
	
	public function new (enabled:Bool){
		this.enabled=enabled;
		tracked=new Hash<Bool>();
	}
	
	public function track(url:String,justOnce:Bool){
		// HERE IS THE CODE FOR TRACKING AT GOOGLE ANALYTICS
		// TRACKING CAN BE EASLITY DISABLED BY PASSING tracking=false WITH THE FLASHVARS
		// IF YOU WANT ACCESS TO TRACKING STATISTICS, JUST WRITE ME TO FBRCKER(AT)GMAIL.COM
		// AND I'LL GIVO YOU FULL ACCESS TO THIS STATISTICS :)
		
		if(enabled && (!justOnce || !tracked.get(url))){
			flash.Lib.getURL(new flash.net.URLRequest("javascript:
				function ffmp3_track_function(url,version){
				   ifrm = document.createElement('IFRAME');
				   ifrm.setAttribute('src', 'http://ffmp3.sourceforge.net/tracker/track.php?version='+version+'&url='+url);
				   ifrm.style.width = 1+'px';
				   ifrm.style.height = 1+'px';
				   ifrm.style.display = 'none';
				   document.body.appendChild(ifrm); 
				}
				ffmp3_track_function('"+url+"','"+FFMp3.VERSION+"');
				"),'_self');
			tracked.set(url,true);
		}
	}
}