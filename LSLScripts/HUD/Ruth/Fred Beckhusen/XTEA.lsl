// Note: XTEA algorithm is BSD Licensed. BSD Code included in AGPL code is compatible with AGPL.
//This code is based on original code from Xundra Snowpaw which was licensed on a new BSD License: http://www.opensource.org/licenses/bsd-license.php

// NonXundra code is licensed by Fred Beckhusen under CC-0 and does not have to be made public.


//A FreeBSD license of this type must remain with the original code and allows modifications and relicensing provided that the original authors license is included.
//Copyright (c) 2010, Xundra Snowpaw
//All rights reserved.

//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentationand/or other materials provided with the distribution.
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
//THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
//BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.




integer ENCRYPT = 1; // set to 0 to not encrypt, just  use plain text only

// DON'T CHANGE THE FOLLOWING! (Unless you know what you are doing!)
// Copytight by Xundra Snowpaw.

integer XTEA_DELTA      = 0x9E3779B9; // (sqrt(5) - 1) * 2^31
integer xtea_num_rounds = 6;
list    xtea_key        = [0, 0, 0, 0];

integer hex2int(string hex) {
	if(llGetSubString(hex,0,1) == "0x")
		return (integer)hex;
	if(llGetSubString(hex,0,0) == "x")
		return (integer)("0"+hex);
	return(integer)("0x"+hex);
}


// Convers any string to a 32 char MD5 string and then to a list of
// 4 * 32 bit integers = 128 bit Key. MD5 ensures always a specific
// 128 bit key is generated for any string passed.
list xtea_key_from_string( string str )
{
	str = llMD5String(str,0); // Use Nonce = 0
	return [    hex2int(llGetSubString(  str,  0,  7)),
		hex2int(llGetSubString(  str,  8,  15)),
		hex2int(llGetSubString(  str,  16,  23)),
		hex2int(llGetSubString(  str,  24,  31))];
}

// Encipher two integers and return the result as a 12-byte string
// containing two base64-encoded integers.
string xtea_encipher( integer v0, integer v1 )
{
	integer num_rounds = xtea_num_rounds;
	integer sum = 0;
	do {
		// LSL does not have unsigned integers, so when shifting right we
		// have to mask out sign-extension bits.
		v0  += (((v1 << 4) ^ ((v1 >> 5) & 0x07FFFFFF)) + v1) ^ (sum + llList2Integer(xtea_key, sum & 3));
		sum +=  XTEA_DELTA;
		v1  += (((v0 << 4) ^ ((v0 >> 5) & 0x07FFFFFF)) + v0) ^ (sum + llList2Integer(xtea_key, (sum >> 11) & 3));

	} while( num_rounds = ~-num_rounds );
	//return only first 6 chars to remove "=="'s and compact encrypted text.
	return llGetSubString(llIntegerToBase64(v0),0,5) +
		llGetSubString(llIntegerToBase64(v1),0,5);
}

// Decipher two base64-encoded integers and return the FIRST 30 BITS of
// each as one 10-byte base64-encoded string.
string xtea_decipher( integer v0, integer v1 )
{
	integer num_rounds = xtea_num_rounds;
	integer sum = XTEA_DELTA*xtea_num_rounds;
	do {
		// LSL does not have unsigned integers, so when shifting right we
		// have to mask out sign-extension bits.
		v1  -= (((v0 << 4) ^ ((v0 >> 5) & 0x07FFFFFF)) + v0) ^ (sum + llList2Integer(xtea_key, (sum>>11) & 3));
		sum -= XTEA_DELTA;
		v0  -= (((v1 << 4) ^ ((v1 >> 5) & 0x07FFFFFF)) + v1) ^ (sum + llList2Integer(xtea_key, sum  & 3));
	} while ( num_rounds = ~-num_rounds );

	return llGetSubString(llIntegerToBase64(v0), 0, 4) +
		llGetSubString(llIntegerToBase64(v1), 0, 4);
}

// Encrypt a full string using XTEA.
string xtea_encrypt_string( string str )
{
	if (! ENCRYPT)
		return str;
	// encode string
	str = llStringToBase64(str);
	// remove trailing =s so we can do our own 0 padding
	integer i = llSubStringIndex( str, "=" );
	if ( i != -1 )
		str = llDeleteSubString( str, i, -1 );

	// we don't want to process padding, so get length before adding it
	integer len = llStringLength(str);

	// zero pad
	str += "AAAAAAAAAA=";

	string result;
	i = 0;

	do {
		// encipher 30 (5*6) bits at a time.
		result += xtea_encipher(llBase64ToInteger(llGetSubString(str,   i, i + 4) + "A="), llBase64ToInteger(llGetSubString(str, i+5, i + 9) + "A="));
		i+=10;
	} while ( i < len );

	return result;
}

// Decrypt a full string using XTEA
string xtea_decrypt_string( string str ) {
	if (! ENCRYPT)
		return str;
	integer len = llStringLength(str);
	integer i=0;
	string result;
	//llOwnerSay(str);
	do {
		integer v0;
		integer v1;

		v0 = llBase64ToInteger(llGetSubString(str,   i, i + 5) + "==");
		i+= 6;
		v1 = llBase64ToInteger(llGetSubString(str,   i, i + 5) + "==");
		i+= 6;

		result += xtea_decipher(v0, v1);
	} while ( i < len );

	// Replace multiple trailing zeroes with a single one

	i = llStringLength(result) - 1;
	while ( llGetSubString(result, i - 1, i) == "AA" ){
		result = llDeleteSubString(result, i, i);
		i--;
	}
	i = llStringLength(result) - 1;
	//    while (llGetSubString(result, i, i + 1) == "A" ) {
	//        i--;
	//    }
	result = llGetSubString(result, 0, i+1);
	i = llStringLength(result);
	integer mod = i%4; //Depending on encoded length diffrent appends are needed
	if(mod == 1) result += "A==";
	else if(mod == 2 ) result += "==";
	else if(mod == 3) result += "=";

	return llBase64ToString(result);
}

string base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

// END XUNDRA SNOWPAW CODE

// The following  code is licened by Fred Beckhusen as CC-0.  You do not have to publish this code under AGPL.   You do not want this code to be set to modify in your product.
key notecardQueryId;
string secretkey = "";
string NOTECARD = "licensekey";   //  the name of a notecard which contains your secret for communicating between a HUD and Ruth
//pseudo random constants for link message channels, must match in all programs that use this module
integer XTEAENCRYPT = 13475896;
integer XTEADECRYPT = 4690862;
integer XTEADECRYPTED = 3450924;
integer notecardLine = 0;

default
{
	state_entry() {
		if (llGetInventoryKey(NOTECARD) == NULL_KEY)
		{
			llOwnerSay( "Notecard '" + NOTECARD + "' is missing or unwritten");
			return;
		}
		// llOwnerSay("reading notecard named '" + NOTECARD + "'.");
		notecardQueryId = llGetNotecardLine(NOTECARD, notecardLine);

	}
	dataserver(key query_id, string data)
	{
		if (query_id == notecardQueryId)
		{
			if (data != EOF) {
				secretkey += data;  // append the key, however long
				// bump line number for reporting purposes and in preparation for reading next line
				++notecardLine;
				//llOwnerSay( "Line: " + (string) notecardLine + " " + data);
				notecardQueryId = llGetNotecardLine(NOTECARD, notecardLine);
			} else {
				xtea_key = xtea_key_from_string(secretkey);	 // save the key from a notecard in the XTEA algorithm
			}
		}
	}

	link_message(integer sender_number, integer number, string message, key id)
	{
		// key id is a string version of the channel to speak on
		if (number == XTEAENCRYPT) {
			string channel = (string) id; // key can be a string, which in this case is a number of a channel
			llSay((integer) channel, xtea_encrypt_string(message));
		} else if (number == XTEADECRYPT) {
				llMessageLinked(LINK_ROOT,XTEADECRYPTED,xtea_decrypt_string(message),"");
		}
	}
}