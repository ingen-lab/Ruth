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

// ss-a 29Dec2018 <seriesumei@avimail.org> - Make alpha hud link-order independent
// ss-b 30Dec2018 <seriesumei@avimail.org> - Auto-adjust position on attach
// ss-c 31Dec2018 <seriesumei@avimail.org> - Combined HUD
// ss-d 03Jan2019 <seriesumei@avimail.org> - Add skin panel
// ss-d.2 06Jan2019 <seriesumei@avimail.org> - Fix OpenSim compatibility


integer r2chan;
integer appID = 20181024;
integer keyapp2chan()
{
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}
vector            alphaOnColor =     <0.000, 0.000, 0.000>;
vector            buttonOnColor =     <0.000, 1.000, 0.000>;
vector            offColor =         <1.000, 1.000, 1.000>;

vector tglOnColor = <0.000, 1.000, 0.000>;
vector tglOffColor = <1.000, 1.000, 1.000>;

// The command button list is:
//  <button-name> :: <prim-name> :: <link-number> :: <face-number>
// <link-number> is no longer used, replaced with the index in
// prim_map that is built at script startup, thus relieving us
// of the perils of not liking the HUD in the right order

list              commandButtonList =    [
"reset",

"backupper::backupper::30::-1",
"backlower::backlower::31::-1",

"chest::chest::32::-1",
"breasts::breastright::33::-1",
"breasts::breastleft::34::-1",
"nipples::breastright::33::0",
"nipples::breastleft::34::0",
"belly::belly::35::-1",

"armsupper::armright::36::0",
"armsupper::armright::36::1",
"armsupper::armright::36::2",
"armsupper::armright::36::3",
"armsupper::armleft::37::0",
"armsupper::armleft::37::1",
"armsupper::armleft::37::2",
"armsupper::armleft::37::3",

"armslower::armright::36::4",
"armslower::armright::36::5",
"armslower::armright::36::6",
"armslower::armright::36::7",
"armslower::armleft::37::4",
"armslower::armleft::37::5",
"armslower::armleft::37::6",
"armslower::armleft::37::7",

"armsfull::armright::36::-1",
"armsfull::armleft::37::-1",

"hands::hands::38::-1",

"buttcrotch::pelvisback::11::7",
"buttcrotch::pelvisfront::12::5",
"buttcrotch::pelvisfront::12::6",
"buttcrotch::pelvisfront::12::7",
"pelvis::pelvisback::11::-1",
"pelvis::pelvisfront::12::-1",

"legsupper::legright1::13::-1",
"legsupper::legright2::14::-1",
"legsupper::legright3::15::-1",
"legsupper::legleft1::21::-1",
"legsupper::legleft2::22::-1",
"legsupper::legleft3::23::-1",

"knees::legright4::16::-1",
"knees::legright5::17::-1",
"knees::legleft4::24::-1",
"knees::legleft5::25::-1",

"legslower::legright6::18::-1",
"legslower::legright7::19::-1",
"legslower::legright8::20::-1",
"legslower::legleft6::26::-1",
"legslower::legleft7::27::-1",
"legslower::legleft8::28::-1",

"legsfull::legright1::13::-1",
"legsfull::legright2::14::-1",
"legsfull::legright3::15::-1",
"legsfull::legright4::16::-1",
"legsfull::legright5::17::-1",
"legsfull::legright6::18::-1",
"legsfull::legright7::19::-1",
"legsfull::legright8::20::-1",
"legsfull::legleft1::21::-1",
"legsfull::legleft2::22::-1",
"legsfull::legleft3::23::-1",
"legsfull::legleft4::24::-1",
"legsfull::legleft5::25::-1",
"legsfull::legleft6::26::-1",
"legsfull::legleft7::27::-1",
"legsfull::legleft8::28::-1",

"feet::feet::29::-1",
"ankles::feet::29::0",
"bridges::feet::29::1",
"bridges::feet::29::2",
"toecleavages::feet::29::3",
"toes::feet::29::4",
"soles::feet::29::5",
"heels::feet::29::6"
    ];

// Keep a mapping of link number to prim name
list prim_map = [];

integer num_links = 0;

// HUD Positioning offsets
float bottom_offset = 1.36;
float left_offset = -0.22;
float right_offset = 0.22;
float top_offset = 0.46;
integer last_attach = 0;

vector MIN_BAR = <0.0, 0.0, 0.0>;
vector ALPHA_HUD = <PI, 0.0, 0.0>;
vector SKIN_HUD = <PI_BY_TWO, 0.0, 0.0>;
vector alpha_rot;
vector last_rot;

integer VERBOSE = FALSE;

log(string msg) {
    if (VERBOSE == 1) {
        llOwnerSay(msg);
    }
}

vector get_size() {
    return llList2Vector(llGetPrimitiveParams([PRIM_SIZE]), 0);
}

adjust_pos() {
    integer current_attach = llGetAttached();

    // See if attachpoint has changed
    if ((current_attach > 0 && current_attach != last_attach) ||
            (last_attach == 0)) {
        vector size = get_size();

        // Nasty if else block
        if (current_attach == ATTACH_HUD_TOP_LEFT) {
            llSetPos(<0.0, left_offset - size.y / 2, top_offset - size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_TOP_CENTER) {
            llSetPos(<0.0, 0.0, top_offset - size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_TOP_RIGHT) {
            llSetPos(<0.0, right_offset + size.y / 2, top_offset - size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_BOTTOM_LEFT) {
            llSetPos(<0.0, left_offset - size.y / 2, bottom_offset + size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_BOTTOM) {
            llSetPos(<0.0, 0.0, bottom_offset + size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_BOTTOM_RIGHT) {
            llSetPos(<0.0, right_offset + size.y / 2, bottom_offset + size.z / 2>);
        }
        else if (current_attach == ATTACH_HUD_CENTER_1) {
        }
        else if (current_attach == ATTACH_HUD_CENTER_2) {
        }
        last_attach = current_attach;
    }
}

resetallalpha()
{
    integer i;

    for (; i < num_links; ++i)
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

        if (command == commandFilter)
        {
            string primName = llList2String(stringList,1);
            integer j;
            for (; j < num_links; ++j) {
                // Set color for all matching link nmaes
                if (llList2String(prim_map, j) == primName) {
                    integer primLink = j;
                    integer primFace = llList2Integer(stringList,3);
                    string message = "ALPHA," + (string)primName + "," + (string)primFace + "," + (string)alphaVal;

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
    }
}

doButtonPress(list buttons, integer link, integer face) {
    string commandButton = llList2String(buttons, face);
    list paramList = llGetLinkPrimitiveParams(link, [PRIM_NAME, PRIM_COLOR, face]);
    string primName = llList2String(paramList, 0);
    vector primColor = llList2Vector(paramList, 1);
    string name = llGetLinkName(link);

    integer alphaVal;
    integer i;
    log("doButtonPress(): "+primName+" "+(string)link+" "+(string)face);
    for (; i < num_links; ++i) {
        // Set color for all matching link nmaes
        if (llList2String(prim_map, i) == name) {
            if (primColor == offColor) {
                alphaVal = 0;
                llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, face, buttonOnColor, 1.0]);
            } else {
                alphaVal = 1;
                llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, face, offColor, 1.0]);
            }
        }
    }
    colorDoll(commandButton, alphaVal);
}

default
{
    state_entry()
    {
        r2chan = keyapp2chan();

        // Create map of all links to prim names
        integer i;
        num_links = llGetNumberOfPrims() + 1;
        for (; i < num_links; ++i) {
            list p = llGetLinkPrimitiveParams(i, [PRIM_NAME]);
            prim_map += [llList2String(p, 0)];
        }

        // Initialize attach state
        last_attach = llGetAttached();
        log("state_entry() attached="+(string)last_attach);

        alpha_rot = ALPHA_HUD;
        last_rot = MIN_BAR;
    }

    on_rez(integer param)
    {
//        llResetScript();
    }

    touch_start(integer total_number)
    {
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        vector pos = llDetectedTouchST(0);
        string name = llGetLinkName(link);
        string message;

        if (name == "rotatebar") {
            if(face == 1||face == 3||face == 5||face == 7)
            {
                rotation localRot = llList2Rot(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_ROT_LOCAL]),0);
                llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,-PI/2>)*localRot]);
            }
            else
            {
                rotation localRot = llList2Rot(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_ROT_LOCAL]),0);
                llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,PI/2>)*localRot]);
            }
            // Save current alpha rotation
            alpha_rot = llRot2Euler(llList2Rot(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_ROT_LOCAL]),0));
        }
        else if (name == "minbar" || name == "alphabar" || name == "skinbar") {
            integer bx = (integer)(pos.x * 10);
            integer by = (integer)(pos.y * 10);
            log("x,y="+(string)bx+","+(string)by);

            if (bx == 4 || bx == 5) {
                // skin
                llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_ROT_LOCAL,llEuler2Rot(SKIN_HUD)]);
            }
            else if (bx == 6 || bx == 7) {
                // alpha
                llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_ROT_LOCAL,llEuler2Rot(alpha_rot)]);
            }
            else if (bx == 8) {
                // min
                vector next_rot = MIN_BAR;

                if (last_rot == MIN_BAR) {
                    // Save current rotation for later
                    last_rot = llRot2Euler(llList2Rot(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_ROT_LOCAL]),0));
                } else {
                    // Restore last rotation
                    next_rot = last_rot;
                    last_rot = MIN_BAR;
                }
                llSetLinkPrimitiveParamsFast(LINK_ROOT,[PRIM_ROT_LOCAL,llEuler2Rot(next_rot)]);
            }
            else if (bx == 9) {
                log("DETACH!");
                llRequestPermissions(llDetectedKey(0), PERMISSION_ATTACH);
            }
        }
        else if (name == "buttonbar1" || name == "buttonbar5") {
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
                doButtonPress(buttonList, link, face);
            }
        }
        else if (name == "buttonbar2" || name == "buttonbar6") {
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
            doButtonPress(buttonList, link, face);
        }
        else if (name == "buttonbar3" || name == "buttonbar7") {
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
            doButtonPress(buttonList, link, face);
        }
        else if (name == "buttonbar4" || name == "buttonbar8") {
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
        else if(name == "backboard")
        {
            //ignore click on backboard
        }
        else
        {
            list paramList = llGetLinkPrimitiveParams(
                link, [
                    PRIM_NAME,
                    PRIM_DESC,
                    PRIM_COLOR, face,
                    PRIM_TEXTURE, face
                ]
            );
            string primName = llList2String(paramList, 0);
            string primDesc = llList2String(paramList, 1);
            vector primColor = llList2Vector(paramList, 2);
            string primTexture = llList2String(paramList, 4);
            integer alphaVal;

            if (primDesc == "head" || primDesc == "upper" || primDesc == "lower") {
                integer i;
                for (; i < num_links; ++i) {
                    if (i != link) {
                        list linkParamList = llGetLinkPrimitiveParams(i,[PRIM_DESC]);
                        string desc = llList2String(linkParamList,0);

                        if (desc == primDesc) {
                            llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, ALL_SIDES, tglOffColor, 1.0]);
                        }
                    }
                }
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, ALL_SIDES, tglOnColor, 1.0]);

                message = "TEXTURE," + primDesc  + "," + primTexture;
                llSay(r2chan,message);
                log("link=" + (string)link + " face=" + (string)face + " name=" + primName + " desc=" + primDesc + " tex=" + primTexture);
            }
            else if (primColor == offColor) {
                alphaVal=0;
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, alphaOnColor, 1.0]);
            }
            else
            {
                alphaVal=1;
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, offColor, 1.0]);
            }
            message = "ALPHA," + (string)primName + "," + (string)face + "," + (string)alphaVal;
            llSay(r2chan,message);
        }
    }

    run_time_permissions(integer perm) {
        if (perm & PERMISSION_ATTACH) {
            llDetachFromAvatar();
        }
    }

    attach(key id) {
        if (id == NULL_KEY) {
            // Nothing to do on detach?
        } else {
            // Fix up our location
            adjust_pos();
        }
    }
}
