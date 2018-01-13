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

//*
//** Additional changes to remove link ordering requirements by Mike Dickson/Mike Chase @ IW
//** Released under same license as above.
//*
    
integer r2chan;
integer appID = 20171105;

vector alphaOnColor =   <0.000, 0.000, 0.000>;
vector alphaOffColor =  <1.000, 1.000, 1.000>;

vector buttonOnColor =  <0.000, 1.000, 0.000>;
vector buttonOffColor = <1.000, 1.000, 1.000>;

integer BUTTON_OFF =    0;
integer BUTTON_ON =     1;

integer INVISIBLE =     0;
integer VISIBLE =       1;

list commandButtonList = [
    "chest::chest::-1",
    "breasts::breastleft::-1",
    "breasts::breastright::-1",
    "belly::belly::-1",
    "backupper::backupper::-1",
    "backlower::backlower::-1",
    "armsupper::armleft::0",
    "armsupper::armleft::1",
    "armsupper::armleft::2",
    "armsupper::armleft::3",
    "armsupper::armright::0",
    "armsupper::armright::1",
    "armsupper::armright::2",
    "armsupper::armright::3",
    "armslower::armleft::4",
    "armslower::armleft::5",
    "armslower::armleft::6",
    "armslower::armleft::7",
    "armslower::armright::4",
    "armslower::armright::5",
    "armslower::armright::6",
    "armslower::armright::7",
    "armsfull::armleft::-1",
    "armsfull::armright::-1",
    "butt::pelvisback::5",
    "crotch::pelvisfront::5",
    "crotch::pelvisfront::6",
    "pelvis::pelvisback::-1",
    "pelvis::pelvisfront::-1",
    "legsupper::legright1::-1",
    "legsupper::legright2::-1",
    "legsupper::legright3::-1",
    "legsupper::legleft1::-1",
    "legsupper::legleft2::-1",
    "legsupper::legleft3::-1",
    "knees::legright4::-1",
    "knees::legright5::-1",
    "knees::legleft4::-1",
    "knees::legleft5::-1",
    "legslower::legright6::-1",
    "legslower::legright7::-1",
    "legslower::legright8::-1",
    "legslower::legleft6::-1",
    "legslower::legleft7::-1",
    "legslower::legleft8::-1",
    "legsfull::legright1::-1",
    "legsfull::legright2::-1",
    "legsfull::legright3::-1",
    "legsfull::legright4::-1",
    "legsfull::legright5::-1",
    "legsfull::legright6::-1",
    "legsfull::legright7::-1",
    "legsfull::legright8::-1",
    "legsfull::legleft1::-1",
    "legsfull::legleft2::-1",
    "legsfull::legleft3::-1",
    "legsfull::legleft4::-1",
    "legsfull::legleft5::-1",
    "legsfull::legleft6::-1",
    "legsfull::legleft7::-1",
    "legsfull::legleft8::-1"
    ];

/*  buttonbar::command::face   */
list buttonList = [
    "buttonbar5::reset::0",
    "buttonbar5::chest::1",
    "buttonbar5::breasts::2",
    "buttonbar5::belly::3",
    "buttonbar5::backupper::4",
    "buttonbar5::backlower::5",
    "buttonbar5::armsupper::6",
    "buttonbar5::armslower::7",
    
    "buttonbar8::reset::0",
    "buttonbar8::chest::1",
    "buttonbar8::breasts::2",
    "buttonbar8::belly::3",
    "buttonbar8::backupper::4",
    "buttonbar8::backlower::5",
    "buttonbar8::armsupper::6",
    "buttonbar8::armslower::7",
        
    "buttonbar4::armsfull::0",
    "buttonbar4::butt::1",
    "buttonbar4::crotch::2",
    "buttonbar4::pelvis::3",
    "buttonbar4::legsupper::4",
    "buttonbar4::knees::5",
    "buttonbar4::legslower::6",
    "buttonbar4::legsfull::7",
    
    "buttonbar7::armsfull::0",
    "buttonbar7::butt::1",
    "buttonbar7::crotch::2",
    "buttonbar7::pelvis::3",
    "buttonbar7::legsupper::4",
    "buttonbar7::knees::5",
    "buttonbar7::legslower::6",
    "buttonbar7::legsfull::7",
    
    "buttonbar3::savealpha::0",
    "buttonbar3::loadalpha::1",
    
    "buttonbar6::savealpha::0",                            
    "buttonbar6::loadalpha::1"
    ];


//Returns the number of prims in the object
integer getNumberOfPrims()
{
    return llGetObjectPrimCount(llGetKey()); //ignores avatars
}

integer lookupLinkNumberByName(string name)
{
    integer maxprims = getNumberOfPrims();
    
    if (maxprims == 1)
    {
        if (name == llGetLinkName(0))
            return (0);
    }
    else
    {
        integer index;
    
        for (index = 1; index <= maxprims; index++)
        {
            if (name == llGetLinkName(index))
                return (index);
        }
    }
    
    return (-1);
}

integer keyapp2chan() 
{
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}
    
resetallalpha()
{
    integer i = 0;
    integer x = llGetNumberOfPrims();

    for (; i <= x; ++i)
    {
        llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, -1, buttonOffColor, 1.0]);
        list paramList = llGetLinkPrimitiveParams(i,[PRIM_NAME]);
        string primName = llList2String(paramList,0);
        string message = "ALPHA," + (string)primName + "," + "-1" + "," + "1";
        llSay(r2chan,message);
    }
    // llSay(0,"A reset all alpha event was raised.");
}

/* Lookup a command name and state given a buttonbar and face */
list buttonBarCommand(string buttonbar, integer face)
{
    integer idx;
    integer count = llGetListLength(buttonList);
    
    for (idx = 0; idx < count; idx++)
    {
        string data = llList2String(buttonList,idx);
        list elements = llParseString2List(data, ["::"], []);
        string buttonname = llList2String(elements,0);
        string linkname = llList2String(elements,1);
        integer facenum = llList2Integer(elements,2);

        if ((buttonbar == buttonname) && (facenum == face))
        {
            // Figure out current state
            integer link = lookupLinkNumberByName(buttonname);
            list paramList = llGetLinkPrimitiveParams(link,[PRIM_COLOR,facenum]);
            vector primColor = llList2Vector(paramList,0);      

            integer buttonState = BUTTON_OFF;
            if (primColor == buttonOnColor)
                buttonState = BUTTON_ON;

            return [ linkname, buttonState ];
        }
    }
    
    return [ "undefined", BUTTON_OFF ];
}

buttonBar(string buttonbar, integer face)
{
    list elements = buttonBarCommand(buttonbar, face);
    string command = llList2String(elements, 0);
    integer buttonState = llList2Integer(elements, 1);
    integer alphaState;
    
    // Did we find a command to execute?
    if (command == "undefined")
        return;
 
    if (command == "reset")
    {   
        resetallalpha();
    }
    else if ((command == "savealpha") || (command == "loadalpha"))
    {               
        llSay(0,"Not Yet Implemented!");
    }
    else
    {   
        integer idx;
        integer count = llGetListLength(buttonList);

        // Toggle the state of all the buttons that implement this command
        if (buttonState == BUTTON_OFF)
        {
            buttonState = BUTTON_ON;
            alphaState = INVISIBLE;
        }
        else
        {
            buttonState = BUTTON_OFF;
            alphaState = VISIBLE;
        }
            
        colorDoll(command, alphaState);
        
        // Toggle the button color correctly
        for (idx = 0; idx < count; idx++)
        {
            string data = llList2String(buttonList,idx);
            list elements = llParseString2List(data, ["::"], []);
            
            string buttonname = llList2String(elements,0);
            string linkname = llList2String(elements,1);
            integer facenum = llList2Integer(elements,2);
            
            integer link = lookupLinkNumberByName(buttonname);
                 
            if (linkname == command)
            {
                if (buttonState == BUTTON_ON)
                    llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, buttonOnColor, 1.0]);
                else
                    llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, buttonOffColor, 1.0]);
            }
        }
    }
}

// Turn a part of the doll on or off
colorDoll(string commandFilter, integer alphaState)
{
    integer i;
    integer count = llGetListLength(commandButtonList);
    
    for (i = 0; i < count; ++i)
    {
        string dataString = llList2String(commandButtonList,i);
        list stringList = llParseString2List(dataString, ["::"], []);
        
        string command = llList2String(stringList,0);
        string primName = llList2String(stringList,1);
        integer primFace = llList2Integer(stringList,2);
        
        integer primLink = lookupLinkNumberByName(primName);        
        
        if ((command == "all") || (command == commandFilter))
        {
            string message = "ALPHA," + (string)primName + "," + (string)primFace + "," + (string)alphaState;
            llSay(r2chan,message);

            if (alphaState == VISIBLE)
                llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, primFace, alphaOffColor, 1.0]);
            else
                llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, primFace, alphaOnColor, 1.0]);
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
        string  linkname = llGetLinkName(link);     

        if (link == LINK_ROOT)
        {
            if(face == 1||face == 3||face == 5||face == 7)
            {
                rotation localRot = llList2Rot(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_ROT_LOCAL]),0);        
                llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,PI/2>)*localRot]);
            }
            else
            {
                rotation localRot = llList2Rot(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_ROT_LOCAL]),0);
                llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,-PI/2>)*localRot]);
            }
        }
        else if (linkname == "backboard")
        {
            // Ignore this
            return;
        }
        else if (~llSubStringIndex(linkname, "buttonbar"))
        {
            buttonBar(linkname, face);
        }
        else
        {
            list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
            string primName = llList2String(paramList,0);
            vector primColor = llList2Vector(paramList,1);
            integer alphaVal;

            if (primColor == alphaOffColor)
            {
                alphaVal = INVISIBLE;
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, alphaOnColor, 1.0]);
            }
                else
            {
                alphaVal = VISIBLE;      
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, alphaOffColor, 1.0]);
            }
            
            string message = "ALPHA," + (string)primName + "," + (string)face + "," + (string)alphaVal;
            llSay(r2chan,message);
            //llSay(0,"Link:" + (string)link + " Bodypart:" + primName + " Face:" + (string)face + " Alpha Value:" + (string)alphaVal);
        }
    }
}