package internationalization;

/**
 * FFMp3 LanguageFactory Class
 * @link http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
 * @author Federico Bricker
 */

class LanguageFactory {
	private function new() { }
	
	static public function factory(lang:String):AbstractLanguage {
		switch(lang) {
			case "es":  return new Spanish(); // Retrocompatibility
			case "sp":  return new Spanish();
			case "it":  return new Italian();
			case "fr":  return new French();
			case "ger": return new German(); // Retrocompatibility
			case "de":  return new German();
			case "nb":  return new Norwegian(); // Norwegian Bokmål
			case "nn":  return new Norwegian(); // Norwegian Nynorsk
			case "nw":  return new Norwegian(); // Retrocompatibility
			case "pt":  return new Portuguese();
			case "tr":  return new Turkish();
			case "uk":  return new Ukrainian();
			case "ru":  return new Russian();
			case "nl":  return new Dutch();
			case "hu":  return new Hungarian();
			case "pl":  return new Polish();
			case "hr":  return new Croatian();
			case "fi":  return new Finnish();
			case "el":  return new Greek();
			case "bg":  return new Bulgarian();
			case "sv":  return new Swedish();
		}
		return new English();
	}
}