//*********************************************************************************
//**   Copyright (C) 2017  Shin Ingen
//**
//**   This program is free software: you can redistribute it and/or modify
//**   it under the terms of the GNU Affero General Public License as
//**   published by the Free Software Foundation, either version 3 of the
//**   License, or (at your option) any later version.
//**
//**   This program is distributed in the hope that it will be useful,
//**   but WITHOUT ANY WARRANTY; without even the implied warranty of
//**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//**   GNU Affero General Public License for more details.
//**
//**   You should have received a copy of the GNU Affero General Public License
//**   along with this program.  If not, see <https://www.gnu.org/licenses/>
//
//** XTEA encryption by Fred Beckhusen
//*********************************************************************************
// pseudo random Constants for link message channels, must match in all programs that use this module
integer XTEAENCRYPT = 13475896;
integer XTEADECRYPT = 4690862;
integer XTEADECRYPTED = 3450924;
integer appID = 20171105;  // Required to be this number for compatibility for all Ruths. Do NOT change the above as it makes it incompatible with Ruth and the license.

integer r2chan;
integer keyapp2chan()
{
	return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}

default
{
	state_entry()
	{
		r2chan = keyapp2chan();
		llListen(r2chan,"","","");
	}

	on_rez(integer param)
	{
		llResetScript();
	}

	listen(integer channel,string name,key id,string message){
		llMessageLinked(LINK_SET,XTEADECRYPT,message,"");
	}

	link_message(integer sender_number, integer number, string message, key id) {

		if (number == XTEADECRYPTED)
		{
			list msglist = llParseString2List(message, [","], []);
			string command = llToUpper(llList2String(msglist, 0));

			if (command == "TEXTURE")
			{
				string descflag = llStringTrim(llToUpper(llList2String(msglist, 1)), STRING_TRIM);
				string textureid = llList2String(msglist, 2);
				integer i;
				integer x = llGetNumberOfPrims()+1;
				for (; i < x; ++i)
				{
					list paramlist = llGetObjectDetails(llGetLinkKey(i), [OBJECT_DESC,OBJECT_NAME]);
					string objdesc = llToUpper(llList2String(paramlist,0));
					string objname = llList2String(paramlist,1);
					if (objdesc == descflag)
					{
						//llOwnerSay("I heard your message:"+descflag+" "+objdesc+" "+textureid);
						llSetLinkPrimitiveParamsFast(i, [PRIM_TEXTURE, ALL_SIDES, textureid, <1,1,0>, <0,0,0>, 0]);
						//llOwnerSay("Changed " + objname + " texture.");
					}
				}
			} else if (command == "ALPHA") {
					string prim2change = llStringTrim(llToUpper(llList2String(msglist, 1)), STRING_TRIM);
				integer face2change = llList2Integer(msglist, 2);
				integer alphaval = llList2Integer(msglist, 3);
				integer i;
				integer x = llGetNumberOfPrims()+1;

				for (; i < x; ++i)
				{
					list paramlist = llGetObjectDetails(llGetLinkKey(i), [OBJECT_DESC,OBJECT_NAME]);
					string objdesc = llToUpper(llList2String(paramlist,0));
					string objname = llToUpper(llList2String(paramlist,1));
					if (objname == prim2change)
					{
						llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, face2change, <1.0,1.0,1.0>, alphaval]);
						//llOwnerSay("Alpha for " + objname + " changed.");
					}
				}
				//llSay(0,"I heard your ALPHA command.");
			}
		}
	}
}

