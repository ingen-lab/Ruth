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
	
integer     	TextureChan = 20171105;
vector     	Tgloncolor = <0.000, 1.000, 0.000>;
vector    	Tgloffcolor = <1.000, 1.000, 1.000>;

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
					llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, ALL_SIDES, Tgloffcolor, 1.0]);
                }
            }
        }
}
default
{

    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
			integer i = llGetLinkNumber() + 1; //1 is always the rootprim of a linkset
			integer x = llGetNumberOfPrims() - 1; //number of iterations
			integer l = llDetectedLinkNumber(0);
			list linkParamList = llGetLinkPrimitiveParams(l,[PRIM_NAME, PRIM_DESC, PRIM_TEXTURE,-1]);
			string primName = llList2String(linkParamList,0);
			string primDesc = llList2String(linkParamList,1);
			string primTexture = llList2String(linkParamList,2);

			if (l!=1)
			{
				llSetLinkPrimitiveParamsFast(l, [PRIM_COLOR, ALL_SIDES, Tgloncolor, 1.0]);
				ToggleOff(i,x,l,primDesc);
				string message = primDesc  + "," + primTexture;
				llSay(TextureChan,message);
				//llSay(0,"Link number clicked: " + (string)l + " " + primName + " " + primDesc + " " + primTexture);  
			}
		}
    }
}