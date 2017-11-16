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
    
integer         textureChan = 20171105;
vector         alphaOnColor = <0.000, 0.000, 0.000>;
vector        alphaOffColor = <1.000, 1.000, 1.000>;


default
{    
    touch_start(integer total_number)    
    {        
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        
        if(link == 1)
        {
            if(face == 1||face == 3||face == 5||face == 7)
            {
                rotation localRot = llList2Rot(llGetLinkPrimitiveParams(link,[PRIM_ROT_LOCAL]),0);        
                llSetLinkPrimitiveParamsFast(link,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,PI/2>)*localRot]);
                llSay(0,"ODD");
            }
                else
            {
                rotation localRot = llList2Rot(llGetLinkPrimitiveParams(link,[PRIM_ROT_LOCAL]),0);
                llSetLinkPrimitiveParamsFast(link,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,-PI/2>)*localRot]);
                llSay(0,"EVEN");
            }
        }
            else
        {
            list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
            string primName = llList2String(paramList,0);
            vector primColor = llList2Vector(paramList,1);
            integer alphaVal;
            if (primColor == alphaOffColor)
            {
                alphaVal=0;
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, alphaOnColor, 1.0]);
            }
                else
            {
                alphaVal=1;      
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, alphaOffColor, 1.0]);
            }
            
            string message = "ALPHA," + primName + "," + face + "," + alphaVal;
            llSay(textureChan,message);
            llSay(0,"Link:" + (string)link + " Bodypart:" + primName + " Face:" + (string)face + " Color:"+(string)primColor + " Alpha Value:" + (string)alphaVal);

        }
    }
}