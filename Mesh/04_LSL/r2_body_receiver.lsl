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
//*********************************************************************************	

integer TextureChan = 20171105;

default
{
    state_entry()
    {
		llListen(TextureChan,"","",""); 
    }

	listen(integer channel,string name,key id,string message)
	{
		if (llGetOwnerKey(id) == llGetOwner()) 
		{
			if (channel == TextureChan)
			{
				
				list msglist = llParseString2List(message, [","], []);
				string descflag = llStringTrim(llToUpper(llList2String(msglist, 0)), STRING_TRIM);
				string textureid = llList2String(msglist, 1);
				integer i = llGetLinkNumber() != 0; //root prim is one of body piece
				integer x = llGetNumberOfPrims() + i; 

				for (; i < x; ++i)
				{
					list paramlist = llGetObjectDetails(llGetLinkKey(i), [OBJECT_DESC,OBJECT_NAME]);
					string objdesc = llToUpper(llList2String(paramlist,0));
					string objname = llList2String(paramlist,1);

					if (objdesc == descflag)
					{
						//llOwnerSay("I heard your message:"+descflag+" "+objdesc+" "+textureid);
						llSetLinkPrimitiveParamsFast(i, [PRIM_TEXTURE, ALL_SIDES, textureid, <1,1,0>, <0,0,0>, 0]);
						llOwnerSay("Changed " + objname + " texture.");
					}

				} 
			}
		}
	} 
}   