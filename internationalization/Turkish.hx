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
		setText("about","Muses Radio Player Hakkında...");
		setText("version","Sürüm");
	}
}