package org.xiph.system;

#if flash9
typedef Bytes = haxe.io.BytesData;
#else
typedef Bytes = Array<Int>;
#end
