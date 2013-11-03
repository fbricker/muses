////////////////////////////////////////////////////////////////////////////////
//
//  Muses Radio Player - Radio Streaming player written in Haxe.
//
//  Copyright (C) 2009-2012  Federico Bricker
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  This Project was initially based on FOggPlayer by Bill Farmer. So 
//  my special thanks to him! :)
//
//  Federico Bricker  f bricker [at] gmail [dot] com.
//
////////////////////////////////////////////////////////////////////////////////
package internationalization;

/**
 * MusesRadioPlayer LanguageFactory Class
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
			case "sl":  return new Slovene();
			case "hy":  return new Armenian();
			case "tt":  return new Tatar();
			case "cs":	return new Czech();
			case "zh":	return new Chinese();
		}
		return new English();
	}
}