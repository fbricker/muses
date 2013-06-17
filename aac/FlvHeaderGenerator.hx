////////////////////////////////////////////////////////////////////////////////
//
//  Muses Radio Player - Radio Streaming player written in Haxe.
//
//  Copyright (C) 2009-2013  Federico Bricker
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
/**
 * This AAC Library was developed by Daniel Uranga and modified for this project.
 * Special thanks to him for this!
 */

package aac;
import flash.utils.ByteArray;

class FlvHeaderGenerator 
{

	static var instance : FlvHeaderGenerator = null;
	var previousTagSize : Int;
	var timeStamp : UInt;
	var miliTimeStamp : UInt;
	
	public static function getInstance() : FlvHeaderGenerator
	{
		if ( instance == null )
		{
			instance = new FlvHeaderGenerator();
		}
		return instance;
	}
	
	private function new()
	{
		previousTagSize = 0;
		timeStamp = 0;
	}
	
	/**
	 * @return A ByteArray containing an audio-only FLV header
	 */
	public function getHeader() : ByteArray
	{
		// General FLV header
		var header = new ByteArray();
		header.writeByte(0x46);		// F
		header.writeByte(0x4c);		// L
		header.writeByte(0x56);		// V
		header.writeByte(0x1);		// Version 1
		// Flags
		header.writeByte(0xC);		// Audio only
		header.writeUnsignedInt(9);	// This header length
		
		// Metadata			
		var blob = [00, 00, 00, 00, 0x12, 00 , 00, 0xC0, 00, 00, 00, 00, 00, 00, 00, 02, 00,
					0xA, 0x6F, 0x6E, 0x4D, 0x65, 0x74, 0x61, 0x44, 0x61, 0x74, 0x61, 0x08, 0x00,
					0x00, 0x00, 0x07, 0x00, 0x08, 0x64, 0x75, 0x72, 0x61, 0x74, 0x69, 0x6F, 0x6E,
					0x00, 0x40, 0x52, 0x0D, 0xA1, 0xCA, 0xC0, 0x83, 0x12, 0x00, 0x0D, 0x61, 0x75,
					0x64, 0x69, 0x6F, 0x64, 0x61, 0x74, 0x61, 0x72, 0x61, 0x74, 0x65, 0x00, 0x00,
					0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x61, 0x75, 0x64, 0x69,
					0x6F, 0x73, 0x61, 0x6D, 0x70, 0x6C, 0x65, 0x72, 0x61, 0x74, 0x65, 0x00, 0x40,
					0xD5, 0x88, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x61, 0x75, 0x64, 0x69,
					0x6F, 0x73, 0x61, 0x6D, 0x70, 0x6C, 0x65, 0x73, 0x69, 0x7A, 0x65, 0x00, 0x40,
					0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0x73, 0x74, 0x65, 0x72,
					0x65, 0x6F, 0x01, 0x01, 0x00, 0x0C, 0x61, 0x75, 0x64, 0x69, 0x6F, 0x63, 0x6F,
					0x64, 0x65, 0x63, 0x69, 0x64, 0x00, 0x40, 0x24, 0x00, 0x00, 0x00, 0x00, 0x00,
					0x00, 0x00, 0x07, 0x65, 0x6E, 0x63, 0x6F, 0x64, 0x65, 0x72, 0x02, 0x00, 0x0C,
					0x4C, 0x61, 0x76, 0x66, 0x35, 0x32, 0x2E, 0x31, 0x30, 0x33, 0x2E, 0x30, 0x00,
					0x08, 0x66, 0x69, 0x6C, 0x65, 0x73, 0x69, 0x7A, 0x65, 0x00, 0x41, 0x22, 0x1E,
					0x28, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0xCB, 0x08,
					0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xAF, 0x00, 0x13,
					0x90];
		for ( b in blob )
		{
			header.writeByte(b);
		}
		previousTagSize = blob.length;
		return header;
	}
	
	/**
	 * @param	data
	 * @return data inside an flv tag
	 */
	public function genPaquet(aacData : ByteArray, decoderSpecificInfo : ByteArray) : ByteArray
	{
		var data = new ByteArray();
		
		// Tag size
		data.writeUnsignedInt(previousTagSize);
		// Tag type
		data.writeByte(0x08);
		// Data size
		var dataSize : Int = aacData.length+2;
		data.writeByte(dataSize>>16);
		data.writeByte(dataSize>>8);
		data.writeByte(dataSize);
		// Timestamp
		data.writeByte(timeStamp>>16);
		data.writeByte(timeStamp>>8);
		data.writeByte(timeStamp);
		// Timestamp extend
		data.writeByte(timeStamp >> 24);
		if ((aacData[1] >> 2) & 1 == 0)
		{
			timeStamp += Std.int(44100 / 1024);
			miliTimeStamp += Std.int(((44100 / 1024) * 1000000) % 1000000);
		}
		else
		{
			timeStamp += Std.int(44100 / 960);
			miliTimeStamp += Std.int(((44100 / 960) * 1000000) % 1000000);
		}
		while ( miliTimeStamp > 1000000 )
		{
			miliTimeStamp -= 1000000;
			timeStamp++;
		}
		// Streamid
		data.writeByte(0);
		data.writeByte(0);
		data.writeByte(0);
		
		// Audio tag header
		var soundFormat : Int = 10;		// Aac
		var soundRate : Int = 3;		// 44 khz
		var soundSize : Int = 1;		// 16-bit
		var soundType : Int = 1;		// Stereo
		var audioTagHeader : Int = (soundFormat << 4) | (soundRate << 2) | (soundSize << 1) | (soundType);
		data.writeByte(audioTagHeader);
		
		// AAC packet type
		data.writeByte(1);
		
		// AAC audio data
		//data.writeBytes(decoderSpecificInfo);
		
		data.writeBytes(aacData);
		
		previousTagSize = data.length - 4;		
		return data;
	}
	
}