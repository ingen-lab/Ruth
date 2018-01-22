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
vector             alphaOnColor =     <0.000, 0.000, 0.000>;
vector            buttonOnColor =     <0.000, 1.000, 0.000>;
vector             offColor =         <1.000, 1.000, 1.000>;
list                commandButtonList =    [
    "chest::chest::30::-1",
    "breasts::breastleft::31::-1",
    "breasts::breastright::32::-1",
    "belly::belly::29::-1",
    "backupper::backupper::28::-1",
    "backlower::backlower::27::-1",
    "armsupper::armleft::33::0",
    "armsupper::armleft::33::1",
    "armsupper::armleft::33::2",
    "armsupper::armleft::33::3",
    "armsupper::armright::34::0",
    "armsupper::armright::34::1",
    "armsupper::armright::34::2",
    "armsupper::armright::34::3",
    "armslower::armleft::33::4",
    "armslower::armleft::33::5",
    "armslower::armleft::33::6",
    "armslower::armleft::33::7",
    "armslower::armright::34::4",
    "armslower::armright::34::5",
    "armslower::armright::34::6",
    "armslower::armright::34::7",
    "armsfull::armleft::33::-1",
    "armsfull::armright::34::-1",
    "butt::pelvisback::9::5",
    "crotch::pelvisfront::10::5",
    "crotch::pelvisfront::10::6",
    "pelvis::pelvisback::9::-1",
    "pelvis::pelvisfront::10::-1",
    "legsupper::legright1::11::-1",
    "legsupper::legright2::12::-1",
    "legsupper::legright3::13::-1",
    "legsupper::legleft1::19::-1",
    "legsupper::legleft2::20::-1",
    "legsupper::legleft3::21::-1",
    "knees::legright4::14::-1",
    "knees::legright5::15::-1",
    "knees::legleft4::22::-1",
    "knees::legleft5::23::-1",
    "legslower::legright6::16::-1",
    "legslower::legright7::17::-1",
    "legslower::legright8::18::-1",
    "legslower::legleft6::24::-1",
    "legslower::legleft7::25::-1",
    "legslower::legleft8::26::-1",
    "legsfull::legright1::11::-1",
    "legsfull::legright2::12::-1",
    "legsfull::legright3::13::-1",
    "legsfull::legright4::14::-1",
    "legsfull::legright5::15::-1",
    "legsfull::legright6::16::-1",
    "legsfull::legright7::17::-1",
    "legsfull::legright8::18::-1",
    "legsfull::legleft1::19::-1",
    "legsfull::legleft2::20::-1",
    "legsfull::legleft3::21::-1",
    "legsfull::legleft4::22::-1",
    "legsfull::legleft5::23::-1",
    "legsfull::legleft6::24::-1",
    "legsfull::legleft7::25::-1",
    "legsfull::legleft8::26::-1"
        ];

list lst_prim_name = [
    "pelvisback", "pelvisfront", "legright1", "legright2", "legright3",
    "legright4", "legright5", "legright6", "legright7", "legright8",
    "legleft1", "legleft2", "legleft3", "legleft4", "legleft5",
    "legleft6", "legleft7", "legleft8", "backlower", "backupper",
    "belly", "chest", "breastleft", "breastright", "armleft", "armright"
        ];

resetallalpha()
{
    integer i;
    integer x = llGetNumberOfPrims()+1;

    for (; i < x; ++i)
    {
        llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, -1, offColor, 1.0]);
        if(i>=9)
        {
            //list paramList = llGetLinkPrimitiveParams(i,[PRIM_NAME]);
            string primName = llList2String(lst_prim_name,i-9);//llList2String(paramList,0);
            string message = "ALPHA," + primName + "," + "-1" + "," + "1";
            llSay(r2chan,message);
        }
    }
    //llSay(0,"A reset all alpha event was raised.");
}

getAllAlpha(){
    list params = [];
    integer i = 0;
    for(;i<8; i++){
        params +=  [PRIM_COLOR, i];
    }
    list colors_prim = llGetLinkPrimitiveParams(LINK_SET,  params);//16 list items by prim in answer
    integer nb = llGetListLength(colors_prim);
    string serial = "";
    for(i=8*16; i < nb; i+=16){//first prim of doll is link set 9
        integer q = 0; // 4 bits
        string bin = "";
        for(; q<16; q+=2){//step of 2 because list is [<vector color>, float_alpha] for each face
            if(q == 8){//one quartet done; store in serial string
                serial +=  hexDigit(bin);
                bin = "";
            }
            vector col = llList2Vector(colors_prim, i + q);
            //little endian convention
            if((integer)col.x)//alphaOffColor
                bin = "0" + bin;
            else//alphaOnColor col.x = 0
                bin = "1" + bin;
        }
        //store second quartet for this prim
        serial +=  hexDigit(bin);
    }
    llOwnerSay(serial);
    llSetObjectDesc(serial); // TODO many stores to use several HUD prims, and not the root of course
}

retrieveAlphaStored(){
    string serial = llGetObjectDesc();
    integer nbq = llStringLength(serial);
    integer primLink = 9;
    integer i;
    for(;i<nbq; i++){
        string bin = hex2bool(llGetSubString(serial, i, i));
        integer b = 0;
        integer r = i%2;
        for(; b < 4; b++){
            string bit = llGetSubString(bin, -(b + 1), -(b + 1));//little endian : read right to left
            integer face = b + (r * 4); //faces 0 to 7
            if (bit == "0"){
                llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, face, offColor, 1.0]);
                llSay(r2chan, "ALPHA," + llList2String(lst_prim_name, primLink - 9) + "," + (string)face + ",1");
            }else{
                    llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, face, alphaOnColor, 1.0]);
                llSay(r2chan, "ALPHA," + llList2String(lst_prim_name, primLink - 9) + "," + (string)face + ",0");
            }
        }
        primLink += r;//r=0 the first pass (faces 0 to 3) and 1 the second pass -faces 4 to 7). Then time to next prim
    }
}

colorDoll(string commandFilter, integer alphaVal)
{
    integer i;
    integer x = llGetListLength(commandButtonList)+1;
    for (; i < x; ++i)
    {
        string dataString = llList2String(commandButtonList,i);
        list stringList = llParseString2List(dataString, ["::"], []);
        string command = llList2String(stringList,0);
        string primName = llList2String(stringList,1);
        integer primLink = llList2Integer(stringList,2);
        integer primFace = llList2Integer(stringList,3);
        string message = "ALPHA," + primName + "," + primFace + "," + alphaVal;

        if (command == commandFilter)
        {
            if (alphaVal == 0)
            {
                llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, primFace, alphaOnColor, 1.0]);
                llSay(r2chan,message);
            }
            else
            {
                llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, primFace, offColor, 1.0]);
                llSay(r2chan,message);
            }
        }
    }
    //llSay(0,"ColorDoll event for:" + commandFilter + ":" + alphaVal + " was raised.");
}

string hexDigit(string b4){//function to encode 4 bits in 1 hexadecimal digit
    if(llStringLength(b4) != 4) return "0";
    integer i;
    integer dec;
    for(;i<4;i++){//in first compute in decimal
        dec = (dec << 1) + (integer)llGetSubString(b4, i, i);
    }
    return llGetSubString("0123456789ABCDEF",dec, dec);
}

string hex2bool(string digit){//function to decode 1 hexadecimal digit in 4 bits
    integer val = (integer)("0x" + digit);
    string binary = (string)(val & 1);
    integer cnt = 0;
    for(val = ((val >> 1)); val; val = (val >> 1)){
        if (val & 1)
            binary = "1" + binary;
        else
            binary = "0" + binary;
        cnt++;
    }
    integer i;
    for(i=3; i > cnt; i--){
        binary = "0" + binary;
    }
    return binary;
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
            }
            else
            {
                rotation localRot = llList2Rot(llGetLinkPrimitiveParams(link,[PRIM_ROT_LOCAL]),0);
                llSetLinkPrimitiveParamsFast(link,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,-PI/2>)*localRot]);
            }
        }
        else if(link == 5 || link == 8)
        {
            list buttonList = [
                "reset",
                "chest",
                "breasts",
                "belly",
                "backupper",
                "backlower",
                "armsupper",
                "armslower"
                    ];
            if(face == 0)
            {
                resetallalpha();
            }
            else
            {
                string commandButton = llList2String(buttonList,face);
                list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
                string primName = llList2String(paramList,0);
                vector primColor = llList2Vector(paramList,1);
                integer alphaVal;
                if (primColor == offColor)
                {
                    alphaVal=0;
                    llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, face, buttonOnColor, 1.0]);
                    llSetLinkPrimitiveParamsFast(8, [PRIM_COLOR, face, buttonOnColor, 1.0]);
                }
                else
                {
                    alphaVal=1;
                    llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, face, offColor, 1.0]);
                    llSetLinkPrimitiveParamsFast(8, [PRIM_COLOR, face, offColor, 1.0]);
                }
                colorDoll(commandButton,alphaVal);
                //llSay(0,"Link:" + (string)link + " Button:" + commandButton);
            }
        }
        else if(link == 4 || link == 7)
        {
            list buttonList = [
                "armsfull",
                "butt",
                "crotch",
                "pelvis",
                "legsupper",
                "knees",
                "legslower",
                "legsfull"
                    ];
            string commandButton = llList2String(buttonList,face);
            list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
            string primName = llList2String(paramList,0);
            vector primColor = llList2Vector(paramList,1);
            integer alphaVal;

            if (primColor == offColor)
            {
                alphaVal=0;
                llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, face, buttonOnColor, 1.0]);
                llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, face, buttonOnColor, 1.0]);
            }
            else
            {
                alphaVal=1;
                llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, face, offColor, 1.0]);
                llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, face, offColor, 1.0]);
            }

            colorDoll(commandButton,alphaVal);
            //llSay(0,"Link:" + (string)link + " Button:" + commandButton);
        }
        else if(link == 3 || link == 6)
        {
            list buttonList = [
                "savealpha",
                "loadalpha"
                    ];
            string commandButton = llList2String(buttonList,face);
            if(commandButton == "savealpha"){
                getAllAlpha();
            }else{
                    retrieveAlphaStored();
            }
        }
        else if(link == 2)
        {
            //ignore click on backboard
        }
        else
        {
            list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
            string primName = llList2String(paramList,0);
            vector primColor = llList2Vector(paramList,1);
            integer alphaVal;

            if (primColor == offColor)
            {
                alphaVal=0;
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, alphaOnColor, 1.0]);
            }
            else
            {
                alphaVal=1;
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, offColor, 1.0]);
            }

            string message = "ALPHA," + primName + "," + face + "," + alphaVal;
            llSay(r2chan,message);
            llSay(0,"Link:" + (string)link + " Bodypart:" + primName + " Face:" + (string)face + " Alpha Value:" + (string)alphaVal);
        }
    }
}
