//*********************************************************************************    
//**   Copyright (C) 2018  Fritigern Gothly
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

// The purpose of this script is to rename all the parts of the Ruth 2.0 mesh avatar.
// This script was developed on, and tested with the mesh body which was considered "current release" at June 8th, 2018.
// The filename of the mesh body before it was imported was r2BODY_UpperLower_ada1.9.dae
// This script is NOT guaranteed to work with any previous or subsequent releases or version of the Ruth 2.0 mesh body. 
// As always, WORK ON A COPY and keep a pristine copy of the body as a backup, in case something goes wrong.
// Good luck and enjoy your Ruth 2.0 body!
// =======================================
//
// VERSION HISTORY
// ---------------
// Version 1.1.1 Bugfix. "Finished" message was sent after each part was renamed.
// Version 1.1 Bugfix. Left/right breast and left/right legs were swapped
// Version 1.0 Initial release

integer numprims;
integer n;

list orgname = ["r2BODY_UpperLower_ada1.9", "r2BODY_UpperLower_ada1.9#1", "r2BODY_UpperLower_ada1.9#2", "r2BODY_UpperLower_ada1.9#3", "r2BODY_UpperLower_ada1.9#4", "r2BODY_UpperLower_ada1.9#5", "r2BODY_UpperLower_ada1.9#6", "r2BODY_UpperLower_ada1.9#7", "r2BODY_UpperLower_ada1.9#8", "r2BODY_UpperLower_ada1.9#9", "r2BODY_UpperLower_ada1.9#10", "r2BODY_UpperLower_ada1.9#11", "r2BODY_UpperLower_ada1.9#12", "r2BODY_UpperLower_ada1.9#13", "r2BODY_UpperLower_ada1.9#14", "r2BODY_UpperLower_ada1.9#15", "r2BODY_UpperLower_ada1.9#16", "r2BODY_UpperLower_ada1.9#17", "r2BODY_UpperLower_ada1.9#18", "r2BODY_UpperLower_ada1.9#19", "r2BODY_UpperLower_ada1.9#20", "r2BODY_UpperLower_ada1.9#21", "r2BODY_UpperLower_ada1.9#22", "r2BODY_UpperLower_ada1.9#23", "r2BODY_UpperLower_ada1.9#24", "r2BODY_UpperLower_ada1.9#25"];

list newname = ["legleft7", "legleft2", "legleft8", "legleft6", "legleft3", "legleft5", "legright1", "legright2", "legright3", "legright4", "legright5", "legleft4", "legright6", "legright7", "legright8", "pelvisfront", "pelvisback", "armleft", "chest", "breastright", "armright", "belly", "breastleft", "backupper", "backlower", "legleft1"];

list description = ["lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "lower", "upper", "upper", "upper", "upper", "upper", "upper", "upper", "upper", "lower"];

default
{
    state_entry()
    {
        numprims = llGetNumberOfPrims(); // Count the number of prims
        
        for(n=1;n<=numprims;++n) //Start at link #1 instead of 0.
        {
            string linkname = llGetLinkName(n); // Get the name of the link.            
            integer index = llListFindList(orgname, (list)linkname); // Find the name of the prim in the list of original names
            
            if (linkname == llList2String(newname, n)) // See if the prim has already been renamed or not.
            {
                llOwnerSay("This part does not have to be renamed."); // Avoid re-renaming links.
            } else {
                if (index >= 0) //Prevent renaming the root prim, if it's there.
                {
                    llOwnerSay("Renaming link number "+(string)n+" with the name ''"+linkname+"'' to the new name ''"+llList2String(newname, index)+"'' and giving it the description ''"+llList2String(description,index)+"''."); // Tell the user what's happening. This may be chatty, but can also be reassuring.
                    llSetLinkPrimitiveParamsFast(n, [PRIM_NAME, llList2String(newname, index), PRIM_DESC, llList2String(description,index)]); // Rename the prim and set the proper description for that prim.
                }
            }
        }
        llOwnerSay("Renaming finished. You may now delete the renaming script, or click on various parts to verify that they have the correct name");
    }
    
    touch_start(integer num)
    {
        integer linknum = llDetectedLinkNumber(0); // Find the part that was clicked on
        llOwnerSay("Touched link #"+(string)linknum+" ("+llGetLinkName(linknum)+")"); // tell the user a bit about the clicked part.
        
        llSetLinkPrimitiveParamsFast(linknum, [PRIM_COLOR, ALL_SIDES, <1,0,0>, 1]); // Make the link red
        llSleep(1); // I know, llSleep() is generaly a no-no, but it does what I need and does not get in the way of other things.
        llSetLinkPrimitiveParamsFast(linknum, [PRIM_COLOR, ALL_SIDES, <1,1,1>, 1]); // Make the link white.
    }
}
