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
            integer f = 2;
            integer x = 4;
            integer l = llGetLinkNumber();
            
            for (; f <= x; ++f)
            {

                list linkParamList = llGetLinkPrimitiveParams(l,[PRIM_TEXTURE,f]);
                string primTexture = llList2String(linkParamList,0);
    
                if (f == 2)
                {
                    string message = "TEXTURE," + "head"  + "," + primTexture;
                    llRegionSayTo(llGetOwner(),r2chan,message);
                }
                if (f == 3)
                {
                    string message = "TEXTURE," + "upper"  + "," + primTexture;
                    llRegionSayTo(llGetOwner(),r2chan,message);
                } 
                if (f == 4)
                {
                    string message = "TEXTURE," + "lower"  + "," + primTexture;
                    llRegionSayTo(llGetOwner(),r2chan,message);
                }
            //llOwnerSay("face:"+(string)f + " " + primTexture);    
            }

            llOwnerSay("You should now be wearing your beautiful skin.");
        }
    }
}