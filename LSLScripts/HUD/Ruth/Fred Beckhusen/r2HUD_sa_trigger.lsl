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
vector     	tglOnColor = <0.000, 1.000, 0.000>;
vector    	tglOffColor = <1.000, 1.000, 1.000>;

ToggleOff(integer i,integer x,integer l,string flagDesc)
{
	for (; i < x; ++i)
	{
		if (i != l)
		{
			list linkParamList = llGetLinkPrimitiveParams(i,[PRIM_DESC]);
			string primDesc = llList2String(linkParamList,0);

			if (primDesc == flagDesc)
			{
				llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, ALL_SIDES, tglOffColor, 1.0]);
			}
		}
	}
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
			integer i; //1 is always the rootprim of a linkset
			integer x = llGetNumberOfPrims() + 1; //number of iterations
			integer l = llDetectedLinkNumber(0);
			list linkParamList = llGetLinkPrimitiveParams(l,[PRIM_NAME, PRIM_DESC, PRIM_TEXTURE,-1]);
			string primName = llList2String(linkParamList,0);
			string primDesc = llList2String(linkParamList,1);
			string primTexture = llList2String(linkParamList,2);

			if (l!=1)
			{
				llSetLinkPrimitiveParamsFast(l, [PRIM_COLOR, ALL_SIDES, tglOnColor, 1.0]);
				ToggleOff(i,x,l,primDesc);
				string message = "TEXTURE," + primDesc  + "," + primTexture;
				llSay(r2chan,message);
				llMessageLinked(LINK_SET,XTEAENCRYPT,message,(string)r2chan);

				//llSay(0,"Link number clicked: " + (string)l + " " + primName + " " + primDesc + " " + primTexture);
			}
		}
	}
}