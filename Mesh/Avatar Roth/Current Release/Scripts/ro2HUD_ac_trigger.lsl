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
integer appID = 20181106;
integer keyapp2chan()
{
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}
vector            alphaOnColor =     <0.000, 0.000, 0.000>;
vector            buttonOnColor =     <0.000, 1.000, 0.000>;
vector            offColor =         <1.000, 1.000, 1.000>;
list              commandButtonList =    [
"reset",

"backupper::backupper::28::-1",
"backlower::backlower::29::-1",

"chest::chest::30::-1",
"breasts::breasts::31::-1",
"belly::belly::32::-1",

"armsupper::armright::33::0",
"armsupper::armright::33::1",
"armsupper::armright::33::2",
"armsupper::armright::33::3",
"armsupper::armleft::34::0",
"armsupper::armleft::34::1",
"armsupper::armleft::34::2",
"armsupper::armleft::34::3",

"armslower::armright::33::4",
"armslower::armright::33::5",
"armslower::armright::33::6",
"armslower::armright::33::7",
"armslower::armleft::34::4",
"armslower::armleft::34::5",
"armslower::armleft::34::6",
"armslower::armleft::34::7",

"armsfull::armright::33::-1",
"armsfull::armleft::34::-1",

"hands::hands::35::-1",

"buttcrotch::pelvisback::11::5",
"buttcrotch::pelvisfront::12::7",

"pelvis::pelvisback::11::-1",
"pelvis::pelvisfront::12::-1",

"legsupper::legright1::13::-1",
"legsupper::legright2::14::-1",
"legsupper::legright3::15::-1",
"legsupper::legleft1::20::-1",
"legsupper::legleft2::21::-1",
"legsupper::legleft3::22::-1",

"knees::legright4::16::-1",
"knees::legleft4::23::-1",

"legslower::legright6::18::-1",
"legslower::legright7::19::-1",

"legslower::legleft6::25::-1",
"legslower::legleft7::26::-1",

"legsfull::legright1::13::-1",
"legsfull::legright2::14::-1",
"legsfull::legright3::15::-1",
"legsfull::legright4::16::-1",
"legsfull::legright5::17::-1",
"legsfull::legright6::18::-1",
"legsfull::legright7::19::-1",

"legsfull::legleft1::20::-1",
"legsfull::legleft2::21::-1",
"legsfull::legleft3::22::-1",
"legsfull::legleft4::23::-1",
"legsfull::legleft5::24::-1",
"legsfull::legleft6::25::-1",
"legsfull::legleft7::26::-1",

"feet::feet::27::-1",
"ankles::feet::27::0",
"bridges::feet::27::1",
"bridges::feet::27::2",
"toecleavages::feet::27::3",
"toes::feet::27::4",
"soles::feet::27::5",
"heels::feet::27::6"
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
            list paramList = llGetLinkPrimitiveParams(i,[PRIM_NAME]);
            string primName = llList2String(paramList,0);
            string message = "ALPHA," + (string)primName + "," + "-1" + "," + "1";
            llSay(r2chan,message);
        }
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
        string message = "ALPHA," + (string)primName + "," + (string)primFace + "," + (string)alphaVal;

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
        else if(link == 3 || link == 7)
        {
            list buttonList = [
                    "reset",
                    "chest",
                    "breasts",
                    "nipples",
                    "belly",
                    "backupper",
                    "backlower",
                    "armsupper"
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
                    llSetLinkPrimitiveParamsFast(3, [PRIM_COLOR, face, buttonOnColor, 1.0]);
                    llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, face, buttonOnColor, 1.0]);
                }
                else
                {
                    alphaVal=1;
                    llSetLinkPrimitiveParamsFast(3, [PRIM_COLOR, face, offColor, 1.0]);
                    llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, face, offColor, 1.0]);
                }
                colorDoll(commandButton,alphaVal);
                //llOwnerSay(0,"Link:" + (string)link + " Button:" + commandButton);
            }
        }
        else if(link == 4 || link == 8)
        {
            list buttonList = [
                    "armslower",
                    "armsfull",
                    "hands",
                    "buttcrotch",
                    "pelvis",
                    "legsupper",
                    "knees",
                    "legslower"
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
                llSetLinkPrimitiveParamsFast(8, [PRIM_COLOR, face, buttonOnColor, 1.0]);
            }
            else
            {
                alphaVal=1;
                llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, face, offColor, 1.0]);
                llSetLinkPrimitiveParamsFast(8, [PRIM_COLOR, face, offColor, 1.0]);
            }

            colorDoll(commandButton,alphaVal);
        }
        else if(link == 5 || link == 9)
        {
            list buttonList = [
                    "legsfull",
                    "feet",
                    "ankles",
                    "heels",
                    "bridges",
                    "toecleavages",
                    "toes",
                    "soles"
                    ];
            string commandButton = llList2String(buttonList,face);
            list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
            string primName = llList2String(paramList,0);
            vector primColor = llList2Vector(paramList,1);
            integer alphaVal;

            if (primColor == offColor)
            {
                alphaVal=0;
                llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, face, buttonOnColor, 1.0]);
                llSetLinkPrimitiveParamsFast(9, [PRIM_COLOR, face, buttonOnColor, 1.0]);
            }
            else
            {
                alphaVal=1;
                llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, face, offColor, 1.0]);
                llSetLinkPrimitiveParamsFast(9, [PRIM_COLOR, face, offColor, 1.0]);
            }
            colorDoll(commandButton,alphaVal);
        }
        else if(link == 6 || link == 10)
        {
            list buttonList = [
                    "--",
                    "--",
                    "--",
                    "--",
                    "--",
                    "--",
                    "savealpha",
                    "loadalpha"
                    ];
            string commandButton = llList2String(buttonList,face);
            llOwnerSay("Saving and loading alpha is not yet implemented!");
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
            string message = "ALPHA," + (string)primName + "," + (string)face + "," + (string)alphaVal;
            llSay(r2chan,message);
        }
    }
} 