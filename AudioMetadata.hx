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
		return  '{"title":"'+StringTools.replace(title,'"',"'")
				+'","artist":"'+StringTools.replace(artist,'"',"'")
				+'","album":"'+StringTools.replace(album,'"',"'")
				+'","genre":"'+StringTools.replace(genre,'"',"'")
				+'","comment":"'+StringTools.replace(comment,'"',"'")
				+'","encoder":"'+StringTools.replace(encoder,'"',"'")
				+'","year":"'+StringTools.replace(year,'"',"'")+'"}';
	}
}