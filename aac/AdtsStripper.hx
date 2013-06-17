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
import flash.Vector;

enum AdtsStripperStatus
{
	WAITING_FOR_DATA;
	OK;
}
 
class AdtsStripper {

	var inputData : ByteArray;
	var status : AdtsStripperStatus;
	static inline var MAXIMUM_FRAME_SIZE : Int = 6144;	
	var bytesUntilNextFrame : Int;
	
	// ADTS header vars
	private var id : Bool;
	private var protectionAbsent : Bool;
	private var privateBit : Bool;
	private var copy : Bool;
	private var home : Bool;
	private var layer : Int;
	private var profile : Int;
	private var sampleFrequency : Int;
	private var channelConfiguration : Int;
	private var copyrightIDBit : Bool;
	private var copyrightIDStart : Bool;
	private var frameLength : Int;
	private var adtsBufferFullness : Int;
	private var rawDataBlockCount : Int;
	//error check
	private var rawDataBlockPosition : Vector<Int>;
	private var crcCheck : Int;
	
	private var lastAdtsHeader : ByteArray;
	
	public function new() {
		this.inputData = new ByteArray();
		this.status = AdtsStripperStatus.WAITING_FOR_DATA;
		this.lastAdtsHeader = null;
	}
	
	/**
	 * Reads a byte from data chunks buffer.
	 * @return The read byte
	 */
	function readByte() : Int {
		return inputData.readByte();
	}
	
	/**
	 * Reads an unsigned-byte from data chunks buffer.
	 * @param	inputData
	 */
	function readUnsignedByte() : Int{
		return inputData.readUnsignedByte();
	}
	
	/**
	 * Adds a data chunk to the internal buffer
	 * @param	inputData
	 */
	public function addData(inputData : ByteArray)	{
		//this.inputData.enqueue(inputData);
		var prevPosition = this.inputData.position;
		this.inputData.position = this.inputData.length;
		this.inputData.writeBytes(inputData);
		this.inputData.position = prevPosition;
		this.status = AdtsStripperStatus.OK;
	}
	
	public function bytesAvailable() : Int	{
		/*
		var bytesAvailable : Int = 0;
		for ( paquet in inputData )
		{
			bytesAvailable += paquet.bytesAvailable;
		}
		return bytesAvailable;
		*/
		return inputData.bytesAvailable;
	}
	
	/**
	 * Reads bytes until an ADTS header is found (0xFFF bit sequence)
	 * @return header found
	 */
	public function findNextFrame() : Bool {
		if ( this.inputData.bytesAvailable == 0 ) {		
			return false;
		}
		var left : Int = MAXIMUM_FRAME_SIZE;
		var i : Int;
		var prevPos : Int = inputData.position;
		while (left > 0){
			i = this.readUnsignedByte();
			left--;
			if (i == 0xFF){
				var prevPos : Int = inputData.position;
				i = this.readUnsignedByte();
				if (((i >> 4) & 0xF) == 0xF){
					inputData.position = prevPos - 1;
					return true;
				}
				inputData.position = prevPos;
			}
		}
		return false;
	}
	
	public function readBytes(count : Int) : ByteArray	{
		var ret : ByteArray = new ByteArray();
		for (i in 0...count)
		{
			ret.writeByte(this.readByte());
		}
		return ret;
	}
	
	public function getFrameLength() : Int	{
		return frameLength - 6;
	}
	
	public function getSampleFrequency() : Int	{
		return sampleFrequency;
	}
	
	public function getChannelConfiguration() : Int	{
		return channelConfiguration;
	}
	
	public function getProfile() : Int	{
		return profile;
	}
	
	function readHeaderUnsignedByte() : UInt	{
		var b : UInt = this.readUnsignedByte();
		lastAdtsHeader.writeByte(b);
		return b;
	}
	
	public function getLastAdtsHeader() : ByteArray	{
		return lastAdtsHeader;
	}
	
	public function parseADTSHeader()	{
		lastAdtsHeader = new ByteArray();
		
		//fixed header:
		//1 bit ID, 2 bits layer, 1 bit protection absent
		var i : Int = readHeaderUnsignedByte();	// 1 byte
		id = ((i>>3)&0x1)==1;
		layer = (i>>1)&0x3;
		protectionAbsent = (i&0x1)==1;
//		if(!protectionAbsent) trace("\t\tCRC!!!");

		//2 bits profile, 4 bits sample frequency, 1 bit private bit
		profile = ((readHeaderUnsignedByte() >> 6) & 0x3) + 1;
		//trace(profile);
		sampleFrequency = (i >> 2) & 0xF;
		//trace(sampleFrequency);
		privateBit = ((i>>1)&0x1)==1;

		//3 bits channel configuration, 1 bit copy, 1 bit home
		i = (i<<8)|readHeaderUnsignedByte();		// 3 byte
		channelConfiguration = ((i >> 6) & 0x7);
		//trace(channelConfiguration);
		copy = ((i>>5)&0x1)==1;
		home = ((i>>4)&0x1)==1;

		//variable header:
		//1 bit copyrightIDBit, 1 bit copyrightIDStart, 13 bits frame length,
		//11 bits adtsBufferFullness, 2 bits rawDataBlockCount
		copyrightIDBit = ((i>>3)&0x1)==1;
		copyrightIDStart = ((i >> 2) & 0x1) == 1;
		i = (i << 8) | readHeaderUnsignedByte();		// 4 byte
		i = (i << 8) | readHeaderUnsignedByte();		// 5 byte
		frameLength = (i >> 5) & 0x1FFF;
		i = (i<<8)|readHeaderUnsignedByte();			// 6 byte
		adtsBufferFullness = (i>>2)&0x7FF;
		rawDataBlockCount = i & 0x3;
		//trace("frame length en el header: " + (frameLength-6));
		
		//if(!protectionAbsent) trace("\t\tRaw data: " + rawDataBlockCount);
		if (!protectionAbsent) crcCheck = (readHeaderUnsignedByte() << 8) + (readHeaderUnsignedByte());
		if (rawDataBlockCount == 0)
		{
			//raw_data_block();
		}
		else
		{
			//header error check
			if (!protectionAbsent)
			{
				rawDataBlockPosition = new Vector<Int>(rawDataBlockCount);
				for (i in 0...rawDataBlockCount)
				{
					rawDataBlockPosition[i] = (readHeaderUnsignedByte()<<8) + (readHeaderUnsignedByte());
				}
				crcCheck = (readHeaderUnsignedByte()<<8) + (readHeaderUnsignedByte());
			}
			//raw data blocks
			for (i in 0...rawDataBlockCount)
			{
				//raw_data_block();
				if(!protectionAbsent) crcCheck = (readHeaderUnsignedByte()<<8) + (readHeaderUnsignedByte());
			}
		}
		
	}
	
	public function createDecoderSpecificInfo() : ByteArray	{
		//5 bits profile, 4 bits sample frequency, 4 bits channel configuration
		var info = new ByteArray();
		info.length = 2;
		info[0] = (profile<<3);
		info[0] |= (sampleFrequency>>1)&0x7;
		info[1] = ((sampleFrequency&0x1)<<7);
		info[1] |= (channelConfiguration<<3);
		/*1 bit frame length flag, 1 bit depends on core coder,
		1 bit extension flag (all three currently 0)*/
	
		return info;
	}
	
}