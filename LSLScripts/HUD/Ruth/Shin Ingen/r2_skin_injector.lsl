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


//==============================================================
//=== REQUIRED: Drop your skin textures inside the injector
//=== and provide the following  skin texture information.
//=== IMPORTANT: Skin Textures must have FULL PERMiSSION
//==============================================================
string		skinName="Lilly Bronze Cleavage Red Lips";
string       headTextureName="Lily_head_512";
string       upperBodyTextureName="Lily_upper_512";
string       lowerBodyTextureName="Lily_lower_512";
//==============================================================	
integer r2chan;
integer appID = 20171105;
integer keyapp2chan() 
{
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}

default
{
    state_entry()
    {
		r2chan = keyapp2chan();
    }

    on_rez(integer param) 
	{
        llResetScript();
    }	

    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {

			string message4head = "TEXTURE," + "head"  + "," + (string)llGetInventoryKey(headTextureName);
			llSay(r2chan,message4head);

			string message4upper = "TEXTURE," + "upper"  + "," + (string)llGetInventoryKey(upperBodyTextureName);
			llSay(r2chan,message4upper);

			string message4lower = "TEXTURE," + "lower"  + "," + (string)llGetInventoryKey(lowerBodyTextureName);
			llSay(r2chan,message4lower);
				
			llOwnerSay(skinName + " ...injected");  
		}
    }
}