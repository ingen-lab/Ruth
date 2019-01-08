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

// ss-a 07Jan2019 <seriesumei@avimail.org> - Streamline prim lookups

list prim_map = [];
list prim_desc = [];

integer r2chan;
integer appID = 20181024;
integer keyapp2chan()
{
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}

default
{
    state_entry()
    {
        // Create map of all links to prim names
        integer i;
        integer num_links = llGetNumberOfPrims() + 1;
        for (; i < num_links; ++i) {
            list p = llGetLinkPrimitiveParams(i, [PRIM_NAME, PRIM_DESC]);
            prim_map += [llToUpper(llList2String(p, 0))];
            prim_desc += [llToUpper(llList2String(p, 1))];
        }

        r2chan = keyapp2chan();
        llListen(r2chan,"","","");
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }

    on_rez(integer param)
    {
        llResetScript();
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llStopAnimation("bentohandrelaxedP1");
            llStartAnimation("bentohandrelaxedP1");
            llSetTimerEvent(3);
        }
    }

    timer()
    {
        llSetTimerEvent(0);
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }

    listen(integer channel,string name,key id,string message)
    {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            if (channel == r2chan)
            {
                list msglist = llParseString2List(message, [","], []);
                integer listLenght = llGetListLength(msglist);
                //llOwnerSay("message lenght:"+ (string)listLenght);
                if (listLenght >= 3)
                {
                    string command = llToUpper(llList2String(msglist, 0));

                    if (command == "TEXTURE")
                    {
                        string descflag = llStringTrim(llToUpper(llList2String(msglist, 1)), STRING_TRIM);
                        string textureid = llList2String(msglist, 2);
                        integer i;
                        integer x = llGetListLength(prim_desc);

                        for (; i < x; ++i)
                        {
                            string objdesc = llList2String(prim_desc, i);

                            if (objdesc == descflag)
                            {
                                //llOwnerSay("I heard your message:"+descflag+" "+objdesc+" "+textureid);
                                llSetLinkPrimitiveParamsFast(i, [PRIM_TEXTURE, ALL_SIDES, textureid, <1,1,0>, <0,0,0>, 0]);
                                //llOwnerSay("Changed " + objname + " texture.");
                            }

                        }
                    } else if (command == "ALPHA")
                    {
                        string prim2change = llStringTrim(llToUpper(llList2String(msglist, 1)), STRING_TRIM);
                        integer face2change = llList2Integer(msglist, 2);
                        integer alphaval = llList2Integer(msglist, 3);
                        integer prim = llListFindList(prim_map, [prim2change]);
                        if (prim > -1) {
                            llSetLinkPrimitiveParamsFast(prim, [PRIM_COLOR, face2change, <1.0,1.0,1.0>, alphaval]);
                        }
                        //llSay(0,"I heard your ALPHA command.");
                    }
                }
            }
        }
    }
}
