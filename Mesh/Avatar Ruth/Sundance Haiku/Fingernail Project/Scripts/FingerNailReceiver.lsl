// NAME: Fingernail Receiver Script
// CATEGORY: Ruth 2.0 Scripts
// AUTHOR: Sundance Haiku (https://plus.google.com/u/0/114880810031398834985)
// VERSION: 1.02 - February, 2018
// DESCRIPTION:
//  This script is intended to be placed toenail mesh to change the coloring and specularity of the nails
//  It works in conjunction with the Fingernail HUD which sends the required coloring information
// MORE INFORMATION:
//  Ruth Discussion Forum: https://plus.google.com/communities/103360253120662433219
//  Ruth GitHub Site: https://github.com/Outworldz/Ruth
//
// COPYRIGHT:  Copyright 2018 Sundance Haiku. All rights reserved.  If you are using this original work in 
//		your personal projects which are not distributed to others, no permission is required.  However, 
//		if you distribute this work, or use this work in products which will be distributed to others, 
//		permission is required.  Two exceptions are allowed to the permission requirement.  The two 
//		exceptions are: 1) permission is not required for those individuals who have made major contributions
//		to the Ruth 2 project; and, 2) permission is not required if this work is distributed in free (no cost)
//		packages which include Ruth and Roth avatars and related items.  Unless otherwise warranted, use of this
// 		work for non-commercial purposes is granted without charge.  Fees may be charged if the work or 
//		derivatives of it are used in commercial products, except in the case of individuals making significant 
//		contributions to the Ruth 2 project whose use of this work is free of any cost.  
//
//	  	If permission is granted, typical requirements include:
//			1. Credit the author 
//      		2. Include author's web links
//			3. Drop the author a note if you make improvements. (I appreciate hearing 
//			   from you if you find ways of improving or making the code more efficient.)
//
// NOTE . . . WHEN RECOMPILING, USE THE MONO OPTION
//
//
// OPENSIM USERS
//    Currently, llSetLinkPrimitiveParams(0,[ PRIM_SPECULAR...] has a bug.  It will trigger
//   an error in the script if it tries to execute the function.  Setting the following
//   to TRUE allows the program to skip the function.  Set it to FALSE when the bug is fixed
integer glSkipSpecFunction = 1;

//Global Variables
integer gFChannelID = -2471717;  //fingernail channel ID
integer glNatural;
vector gSaveColor;

//Calculate the white-ish color for the free area of the fingernail or toenail
//There's probably a more elegant way to doing this, but . .  .
vector CalcFreeAreaColor (vector vColorInput)
{
    float R;
    float G;
    float B;
    //convert from SL color to RGB
    vector vColorRGB;    
    if (vColorInput.x > 1 || vColorInput.y > 1 || vColorInput.z > 1)    
    {
        //llOwnerSay("Error in Calculate Free Area:  "+(string)vColorRGB);
        vColorRGB = <0.0,0.0,0.0>;
    }
    else
    {
        R = llRound(vColorInput.x * 255);
        G = llRound(vColorInput.y * 255);
        B = llRound(vColorInput.z * 255);
        vColorRGB = <R,G,B>;
        float nTotRGB = R + G + B ;
        //float nTotRGB = 100 * gPreviewColorHSL.z ;  //next version - will use LUM for this
        //llOwnerSay("Color in Usual RGB BEFORE conversion:  "+(string)vColorRGB);
        //llOwnerSay("nTotRGB is: " + (string)nTotRGB);
        
        if (nTotRGB > 700)
        {        
            R = 255;                
            G = 255;        
            B = 250;
        }
        if (nTotRGB > 600 && nTotRGB < 701)
        {        
            R = 240;
            G = 240;    
            B = 235;
        }
        if (nTotRGB > 550 && nTotRGB < 601)
        {        
            R = 235;
            G = 235;    
            B = 230;
        }
        if (nTotRGB > 500 && nTotRGB < 551)
        {        
            R = 230;
            G = 230; 
            B = 225;
        }
        if (nTotRGB > 450 && nTotRGB < 501)
        {        
            R = 220;
            G = 220;    
            B = 215;
        }
        if (nTotRGB > 400 && nTotRGB < 451)
        {        
            R = 210;
            G = 210;
            B = 205;
        }
        if (nTotRGB > 350 && nTotRGB < 401)
        {        
            R = 200;
            G = 200;
            B = 195;
        }
        if (nTotRGB > 300 && nTotRGB < 351)
        {        
            R = 190;
            G = 190;
            B = 185;
        }
        if (nTotRGB > 250 && nTotRGB < 301)
        {        
            R = 175;
            G = 175;
            B = 165;
        }
        if (nTotRGB < 251)
        {        
            R = 165;
            G = 165;
            B = 160;
        }
        vColorRGB = <R,G,B>;
        //llOwnerSay("Color in Usual RGB AFTER conversion:  "+(string)vColorRGB);
        vColorRGB = vColorRGB / 255; //Convert back to SL's color type
    }        
    return vColorRGB;
}   

default
{
    state_entry()
    {
        //gOriginalColor = llGetColor(ALL_SIDES);
        integer nFChannel = 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ gFChannelID);
        llListen(nFChannel, "", "", "");
    }
    
     on_rez(integer param)
    {
        llResetScript();
    }
    
    
    listen(integer Channel, string Name, key ID, string Msg)
    {
        //Msg has the color and whether is a natural or colored nail
        //So, it looks like: [<.25,.34,.60>][1][51].  The first element of the list is
        //the color (element 0).  The second element is either natural=1 colored=0 (element 1).
        //The third element is the specularity setting (aligns with "glossiness" setting in
        //the edit dialog box:  EDIT >> Texture >> Shininess (specular).
        list MsgList = llParseString2List(Msg, [ "[","]" ], []);
        vector vColor = (vector)llList2String(MsgList,0); //extract color from the list
        string glNatural = llList2String(MsgList,1);   //extract whether it is a natural or colored nail
        integer nShinyValue = (integer)llList2String(MsgList,2); 
        //Unfortunately, we have to get all this information in order to use llSetLinkPrimitiveParamsFast function
        list ParamList = llGetLinkPrimitiveParams(0,[PRIM_TEXTURE,-1]);
        //ParamList is a list consisting of texture name, repeats, off-sets, etc.             
        string TextName = llList2String(ParamList,0);   
        string OldParams= llList2String(ParamList,1); //repeats
        vector Repeats = (vector)OldParams;
        string OldParams2 = llList2String(ParamList,2); //offsets
        vector OffSets = (vector)OldParams2;
        
        //llOwnerSay("vColor: "+(string)vColor);
        if (glNatural == "1")  //If it's a natural finger/toenail - we have two colors
        {
            //First set the color of the main part of the nail
            llSetLinkPrimitiveParamsFast(0, [PRIM_COLOR, 0, vColor, 1.0]);            
            //llOwnerSay("Color before free area conversion:  "+(string)ColorRGB);
            vector vFree = CalcFreeAreaColor (vColor); //calculates the white-ish free area of the nail
            //Set the color of the free area of the nail            
            llSetLinkPrimitiveParamsFast(0, [PRIM_COLOR, 1, vFree, 1.0]);            
            //[texture, vector repeats, vector offsets, float rot, vector specular_color, integer glossiness, integer environment ]
            if (! glSkipSpecFunction)
            {
                llSetLinkPrimitiveParamsFast(0,[ PRIM_SPECULAR, ALL_SIDES, TextName, Repeats, OffSets, 0.0, <1,1,1>, nShinyValue, 0]);
            }            
            //llOwnerSay("Fingernail Script - nShinyValue = " + (string) nShinyValue);
        }    
        else
        {
            llSetLinkPrimitiveParamsFast(0, [PRIM_COLOR, -1, vColor, 1.0]);
            if (! glSkipSpecFunction)
            {            
                //[texture, vector repeats, vector offsets, float rot, vector specular_color, integer glossiness, integer environment ]
                llSetLinkPrimitiveParamsFast(0,[ PRIM_SPECULAR, ALL_SIDES, TextName, Repeats, OffSets, 0.0, <1,1,1>, nShinyValue, 0]);  
            }
            //llOwnerSay("Fingernail Script - nShinyValue = " + (string) nShinyValue);
        } 
    }
}
