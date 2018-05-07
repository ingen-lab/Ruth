// NAME: Fingernail/Toenail HUD Script
// AUTHOR: Sundance Haiku (https://plus.google.com/u/0/114880810031398834985)
// AUTHOR: Chimera Firecaster (https://plus.google.com/115549296923155647217 & https://chimerafire.wordpress.com/)
// VERSION: 1.04 - May, 2018
// DESCRIPTION:
//      This script is intended to be placed inside a HUD to change the coloring in finger/toe nails
//      Complete instructions on how to assemble the HUD and the use this script are found on the Ruth Github site (below)
//
// MORE INFORMATION:
//      Ruth Discussion Forum: https://plus.google.com/communities/103360253120662433219
//      Ruth GitHub Site: https://github.com/Outworldz/Ruth
//
// COPYRIGHT:
//   Copyright 2018 by Sundance Haiku and Chimera Firecaster
//   For: Fingernail HUD Script, Fingernail HUD, Fingernail/Toenail Receiving Scripts
//
//   Licensed under "The Virtual License: Open Source, Non-commercial," Version 1.0
//   (the "License"); you may not use this Work except in compliance with the License.  
//   If the License is not included this work, a copy is available at the following:
//      https://tinyurl.com/ycaom8g7
//   This is an open source work.  The source files are found at:  
//      https://github.com/Outworldz/Ruth
//   Subsidiary Creations (see License for more information): Fingernails & Toenails
//
//   Unless required by applicable law or agreed to in writing, the software distributed 
//   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
//   OR CONDITIONS OF ANY KIND, either express or implied.  
//
//   You may give this work to another person or share or distribute this work with 
//   other non-commercial work as long as it is provided FREE OF COST and the following 
//   is met:  (1) Include the above text.  (2) Include a copy of the License document 
//   including the "Plain Language Summary" and copy of the License.  If not 
//   reasonably possible to include to the License document, use the above hyperlink.)  
//   (3) Indicate if you have modified the work and where you modified it.  If 
//   modified and if sharing it, include either a "Modify, Transfer" version of the 
//   Work or provide a link to the modified source files.  Any modification made by 
//   you or others falls under the same License terms.  
//
//   See the License for the specific language governing the use of this Work and 
//   limitations under the License.
//
// CODE & KARMA
//  Note: this is a FREE script.  It is given generously to the virtual community without
//  the expectation of any financial return.  It may be distributed as long as you observe
//  the license requirements described above.  Please do not charge for it. That's bad form.
//  Besides dishonoring the kindness of others, it will most certainly bring you bad karma.
//
//
// MAJOR CONTRIBUTION:
//      A major part of this script is a color picker that was developed by Chimera Firecaster in 2014
//      Chimera's notes and remarks concerning the color picker have been included below.  
//
// INFORMATION ON CHIMERA'S COLOR PICKER
//      The color picker built into this HUD has been adapted from Chimera's Color Picker, ver 1, 2014
//      Chimera Firecaster provides this as a free, full permissions color picker kit at her store in Second Life
//
// COLOR PICKER - GENERAL DESCRIPTION
//      The color picker allows a user to select color from a palette and adjust the luminosity (brightness)
//      of the color on a luminosity slider.  Selection is done by clicking the mouse on the 
//      palette or the luminosity slider. The basic overall structure and lay-out resembles the Color
//      Picker dialog box in Second Life and Opensim.  The user's selected color and associated brightness appears 
//      in a "Current Color" swatch - which is also referred to as the "Preview" swatch.  
//
//      A "Plus Marker" moves to the touched location on the color palette so that the user has a visual
//      point of reference.  There's also a pointer on the luminosity slider providing a similar 
//      point of reference for the brightness scale.
//
// COLOR PICKER CREDITS & ADDITIONAL NOTES BY CHIMERA
//      This color picker is built upon the work of others.  It would not have been possible if a 
//      number of scripters had not worked around the edges coming up with innovative ideas and approaches.
//      The first individuals - of whom I'm aware - and who made code publicly available to us all include 
//      Aaron Edelweiss, Fox Stirling, Bjorn Nordlicht (and forgive me if I’ve left out someone).  They 
//      worked out methods by which a color could be selected (by clicking on it) from a palette.  I 
//      also used the RGB to HSL color conversation function found in the Second Life scripting library.  
//      The function was coded by Clematide Oyen (Laura Aastha Bondi) who in turn was inspired by a function 
//      written by Alec Thilenius.
//
//      One key problem in putting the Color Picker together was trying to come up with a method of 
//      marking where the user clicked in the color palette and luminosity slider.  When one is trying to 
//      get just the right color, it’s very helpful - almost critical - to have those two reference points.
//      Thankfully, Nova Convair came to the rescue by responding to my post on the scripting forum.  His
//      solution was unique and elegant.  He suggested - and provided some sample code - using
//      a transparent prim with a marker on it to overlay the color palette.  Here's the real genius in
//      his approach: moving the marker to the last clicked point was done not by using positioning 
//      coordinates (the usual approach), but rather by using texture off-sets.  You'll see that in the 
//      code, below, where llSetLinkPrimitiveParams moves the "Plus Marker" prim by off-sets.  The same 
//      solution worked for the luminosity slider.
//
//      I would be remiss not to mention Rolig Loon who is always generous with his time to help others on
//      the scripting forum.  Finally I would like to thank all of the Second Life scripters who freely
//      make their knowledge available by public postings of code samples and projects which benefit us all.
//
// COMPILING NOTE . . . WHEN RECOMPILING, USE THE MONO OPTION
//
//-----Do Not Remove Above Information
//
//

// OPENSIM USERS
//    Currently, llSetLinkPrimitiveParams(0,[ PRIM_SPECULAR...] has a bug.  It will trigger
//   an error in the script if it tries to execute the function.  Setting the following
//   to TRUE allows the program to skip the function.  Set it to FALSE when the bug is fixed
integer glSkipSpecFunction = 1;

//Channel to pass color values to a script in the object which is being colored
integer gFChannelID = -2471717;  //fingernail channel ID
integer gTChannelID = -2471718;  //toenail channel ID

//Global Initializations . . .
integer gLPointerNo; //Link # of Luminsity Pointer
integer gLSliderNo;  //Link # of Luminisity Slider
vector gLumSlider; //touch coordinate from Lum Slider
integer gLShinyPtNo;
integer gLShinySlideNo;
integer gnShinyValue = 0;
integer gnSaveShiny = 0;
integer gLPlusMarker; //Link # of Marker on Palette
integer gLPreview;  //Link # of Current Color (Preview) Swatch
//Variables and associated processes connected with RGB and HSL colors 
//can get confusing, So throughout the scripts, I've specifically indicate 
//which is which by including RGB & HSL in the variable names
vector gPreviewColorRGB; //RGB Value of Current Color (Preview) Swatch 
vector gPreviewColorHSL; //HSL Value of Current Color (Preview) Swatch 
integer gSaveColor1; //Link #'s of SaveColors
integer gSaveColor2; //1 through 5 are fingernail color saves
integer gSaveColor3; 
integer gSaveColor4; 
integer gSaveColor5; 
integer gSaveColor6; //6 through 10 are toenail color saves
integer gSaveColor7; 
integer gSaveColor8; 
integer gSaveColor9; 
integer gSaveColor10; 
integer gSaveButton; //the Save button prim
vector gSaveColorRGB1; //SaveColors in RGB
vector gSaveColorRGB2; //1 through 5 are fingernail color saves
vector gSaveColorRGB3;
vector gSaveColorRGB4; 
vector gSaveColorRGB5;
vector gSaveColorRGB6; //6 through 10 are toenail color saves
vector gSaveColorRGB7;
vector gSaveColorRGB8;
vector gSaveColorRGB9;
vector gSaveColorRGB10;
integer glFingerNails = 1; //User's choice: Fingernails or Toenails
vector gvONColor =  <1.000, 0.522, 0.106>;  //Orange color to indicate the button has been pressed
vector gvOFFColor = <1.0, 1.0, 1.0>;  //white color to indicate the button has not been pressed
integer glNatural = 0;  //Natural is False - Colored is True


//------------------------------------------------------------------------------
// User Defined Functions
//------------------------------------------------------------------------------



//Many thanks to Fox Stirling & Aaron Edelweiss who generously provided ideas and 
//code samples for the following four functions.  Their important contributions
//to SL scripting involved converting between coordinates on a color palette (and
//luminosity slider to HSL and RGB color values.

//This is used to tint the luminosity slider, coordinating it with 
//the "Current" (preview) color.  A fixed LUM of 0.70 is used for the tint.
TintLumSlider(float hue, float sat) 
{
    float R;
    float G;
    float B;
    float var_1;
    float var_2;
    float lum = 0.70;
    
    if ( sat == 0 )    //HSL from 0 to 1
    {
        R = lum * 255;  //RGB results from 0 to 255
        G = lum * 255;
        B = lum * 255;
    }
    else
    {
        if ( lum < 0.5 )
        {
            var_2 = lum * (1.0 + sat);
        }
        else if(lum >= 0.5)
        {
            var_2 = (lum + sat) - (lum * sat);
        }
        var_1 = 2 * lum - var_2;        
        
        R = Hue_2_RGB( var_1, var_2, (hue + (1.0/3.0)));
        G = Hue_2_RGB( var_1, var_2, hue);
        B = Hue_2_RGB( var_1, var_2, (hue - (1.0/3.0)));
    }
    //llOwnerSay("Color: "+(string)R+" "+(string)G+" "+(string)B);    
    //llSetLinkColor(gLSliderNo, <R,G,B>, ALL_SIDES);
    llSetLinkPrimitiveParamsFast(gLSliderNo, [PRIM_COLOR, -1, <R,G,B>, 1.0]);
}



//Calculates HSL (Hue & Sat) from the touch coordinates of the Palette
vector CalculateHueSat(vector Palette)  
{
    integer hue;
    integer sat; 
    //llOwnerSay("Calculate Hue & Sat Function - Start Palette.x: " +(string)Palette.x);
    //Note that we are dealing with touch coordinates - not offsets               
    float hPoint = Palette.x * 360;  //touch coordinates (0 to 1)from the Palette 
    float sPoint = Palette.y * 100;  //examples  .5 * 100 = 50    
    //calculate standard HSL hue scale 0 - 360
    if(hPoint > 359.5)
    {
        hue = llCeil(hPoint);  //359.5+ becomes 360
    }
    else if(hPoint < 0.5)    //.5 - becomes 0
    {
        hue = llFloor(hPoint);
    }
    else
    {
        hue = (integer)hPoint; //51.3 becomes 51
    }
    if(hue == -360)
    {
        hue = 0;
    }    
    //calculate standard HSL saturation scale 0 - 100
    if(sPoint > 99.5)
    {
        sat = llCeil(sPoint);  //99.5 becomes 100
    }
    else if(sPoint < 0.5)  // 0
    {
        sat = llFloor(sPoint);
    }
    else
    {
        sat = (integer)sPoint;
    }    
    if(sat == -100)
    {
        sat = 0;
    }
    //llOwnerSay("Hue: "+(string)hue + " Sat: " + (string)sat);     
    vector HSL = <hue,sat,0>;    
    HSL.x = (HSL.x * 1.0) / 360; //convert from standard HSL to SL's HSL
    HSL.y = (HSL.y * 1.0) / 100; //convert from standard HSL to SL's HSL 
    HSL.z = gPreviewColorHSL.z;  //Pick up Lum from preview
    //llOwnerSay("LUM is: " + (string)gPreviewColorHSL.z);
    return HSL;    
}   



//Sets the color in the CURRENT (preview) SWATCH
SetPreviewColor(vector HSL)
{    
    gPreviewColorHSL = HSL; //Save preview color in HSL 
    float R;
    float G;
    float B;
    float var_1;
    float var_2;
    if ( HSL.y == 0 )     //Saturation = 0
    {
        R = HSL.z * 255;  //RGB results from 0 to 255
        G = HSL.z * 255;
        B = HSL.z * 255;
        //This is handy if you need to see the actual values for RGB colors on the preview box
        //llOwnerSay("XXXX RGB Preview Color: "+ (string)R+" "+(string)G+" "+(string)B);
    }
    else
    {
        if ( HSL.z < 0.5 )
        {
            var_2 = HSL.z * (1.0 + HSL.y);
        }
        else if(HSL.z >= 0.5)
        {
            var_2 = (HSL.z + HSL.y) - (HSL.z * HSL.y);
        }
            var_1 = 2 * HSL.z - var_2;       
        
        R = Hue_2_RGB( var_1, var_2, (HSL.x + (1.0/3.0)));
        G = Hue_2_RGB( var_1, var_2, HSL.x);
        B = Hue_2_RGB( var_1, var_2, (HSL.x - (1.0/3.0)));
    }
    if (glNatural)  //If it's a natural finger/toenail - we have two colors
    {
        
        llSetLinkPrimitiveParamsFast(gLPreview, [PRIM_COLOR, 1, <R,G,B>, 1.0]);
        vector vFree = CalcFreeAreaColor (<R,G,B>); //calculates the white-ish free area of the nail        
        llSetLinkPrimitiveParamsFast(gLPreview, [PRIM_COLOR, 0, vFree, 1.0]);
        //llOwnerSay("Natural Routine");
        
    }    
    else
    {       
       llSetLinkPrimitiveParamsFast(gLPreview, [PRIM_COLOR, -1, <R,G,B>, 1.0]);
       //llOwnerSay("Solid Routine");
    }    
    vector vTemp = 255 * <R,G,B>;
    //llOwnerSay("Color in RGB: "+ (string)vTemp);
    gPreviewColorRGB = <R,G,B>;    
    TintLumSlider(HSL.x,HSL.y);  //tints the luminosity slider   
    SendColorInfo(); //Send the color values to a script in the object to be colored       
}


    
//Used to convert hue to RGB
float Hue_2_RGB( float v1, float v2, float vH ) 
{
    if ( vH < 0.0 )
    { 
        vH += 1.0;
    }
    if ( vH > 1.0 )
    { 
        vH -= 1.0;
    }
    if ( ( 6.0 * vH ) < 1.0 )
    {        
        return ( v1 + ( v2 - v1 ) * 6.0 * vH );
    }
    if ( ( 2.0 * vH ) < 1.0 )
    {         
        return ( v2 );
    }
    if ( ( 3.0 * vH ) < 2.0 ) 
    {        
        return ( v1 + ( v2 - v1 ) * ( ( 2.0 / 3.0 ) - vH ) * 6.0 );
    }
    else
    {        
        return ( v1 );
    }
}



// RGB to HSL conversion function. By Clematide Oyen (Laura Aastha Bondi). Inspired by 
// a function written by Alec Thilenius.  Available on the SL Script Library
vector RgbToHsl(vector rgb)
{
    float r = rgb.x;
    float g = rgb.y;
    float b = rgb.z;
    float h;
    float s;
    float l;
    float max;
    float min; 
    // Looking for the max value among r, g and b
    if (r > g && r > b) max= r;
    else if (g > b) max = g;
    else max = b; 
    // Looking for the min value among r, g and b
    if (r < g && r < b) min = r;
    else if (g < b) min = g;
    else min = b;
 
    l = (max + min) / 2.0;
 
    if (max == min)
    {
        h = 0.0;
        s = 0.0;
    }
    else
    {
        float d = max - min;
 
        if (l > 0.5) s = d / (2.0 - max - min);
        else s = d / (max + min);
 
        if (max == r) {
            if (g < b) h = (g - b) / d + 6.0;
            else h = (g - b) / d;
        }
        else if (max == g)
            h = (b - r) / d + 2.0;
        else
            h = (r - g) / d + 4.0;
        h /= 6.0;
    } 
    return <h, s, l>;
}



//This positions the Lum Pointer based on the color in the current (preview) swatch
MoveLumPointer(vector ColorHSL)
{    
     list ParamList = llGetLinkPrimitiveParams(gLPointerNo,[PRIM_TEXTURE,4]);
     //ParamList is a list consisting of texture name, repeats, off-sets, etc.
     string TextName = llList2String(ParamList,0);        
     string OldParams= llList2String(ParamList,1); //repeats
     vector Repeats = (vector)OldParams;
     string OldParams2 = llList2String(ParamList,2); //offsets
     vector OffSets = (vector)OldParams2;
     ColorHSL.x = OffSets.x;
     //Next is important: Luminosity is contained in ColorHSL.z (that's "z" not "y")
     ColorHSL.y = ColorHSL.z;
     ColorHSL.z = 0;     
     //Make sure the coordinates don't exceed the boundaries
     if (ColorHSL.y < .023913) 
     {                        
         ColorHSL.y = .023913;
     }   
     if (ColorHSL.y > .973882) 
     {                        
         ColorHSL.y = .973882;
     }  
     //Need the inverse
     if (ColorHSL.y == 0)
     {
         ColorHSL.y = 1;
     }
     else if (ColorHSL.y == 1)
     {
         ColorHSL.y = 0;   
     }
     else
     {
         ColorHSL.y = llFabs(1 - ColorHSL.y);
     }           
     ColorHSL.y = ColorHSL.y-.47;     
     //llOwnerSay("Moving Lum Pointer - Actual Offset: "+(string)ColorHSL.y);
     //llOwnerSay("TextName: "+TextName+"  ColorHSL: "+(string)ColorHSL);
     llSetLinkPrimitiveParamsFast(gLPointerNo, [PRIM_TEXTURE, 4, TextName, Repeats, ColorHSL, PI ]);
}



//This positions the Plus Marker based on the color in the current (preview) swatch
//Face #4 is hard coded.  If you change prims, you may need to change the face #
MovePlusMarker(vector ColorHSL)  
{   
    list ParamList = llGetLinkPrimitiveParams(gLPlusMarker,[PRIM_TEXTURE,4]);
    //ParamList is a list consisting of texture name, repeats, off-sets, etc.    
    string TextureName = llList2String(ParamList,0);       
    string OldParams= llList2String(ParamList,1); //repeats
    vector Repeats = (vector)OldParams;
    string OldParams2 = llList2String(ParamList,2); //offsets
    vector OffSets = (vector)OldParams2;    
    ColorHSL.x = ColorHSL.x - (ColorHSL.x * .05); //adjust for increased size of plus marker     
    ColorHSL.y = ColorHSL.y - (ColorHSL.y * .05); //adjust for increased size of plus marker     
    //llOwnerSay("HSL Color prior to conversion to offsets: "+(string)ColorHSL.x);
    //Slope-intercept formula correction - see note in "if (nLinkNo == gLPlusMarker)" below
    ColorHSL.x = ColorHSL.x + ((ColorHSL.x - 1.26163) / -23.48) ;   
    //Make sure we don't go beyond the palette boundaries
    if (ColorHSL.x > .95179) 
    {
         ColorHSL.x = .95179;  
    }
    if (ColorHSL.x < .04707 )
    {
         ColorHSL.x = .04707;
    }
    if (ColorHSL.y > .95060)
    {
         ColorHSL.y = .95060;
    }
    if (ColorHSL.y < .03623)
    {
         ColorHSL.y = .03623;
    }
    ColorHSL.x = ColorHSL.x - .5;  //.47 better for yellow and cyan
    ColorHSL.y = ColorHSL.y - .5;    
    //llOwnerSay("HSL converted to offsets: "+(string)ColorHSL);    
    ColorHSL.z = 0;
    //llOwnerSay("PLUS POINTER - Offsets to Move: "+(string) ColorHSL);
    //this positions the Plus Pointer based on color
    llSetLinkPrimitiveParamsFast(gLPlusMarker, [PRIM_TEXTURE, 4, 
                       TextureName, Repeats, ColorHSL, PI ]);
}


//Second routine which sets the color in "Current Color" (Preview)
//Swatch - It ALSO returns the color in HSL values   
vector SetPreviewColor2(vector ColorRGB)
{  
     if (glNatural)  //If it's a natural finger/toenail - we have two colors
    {
        //llSetLinkColor(gLPreview,ColorRGB,1);  //set main nail color
        llSetLinkPrimitiveParamsFast(gLPreview, [PRIM_COLOR, 1, ColorRGB, 1.0]);
        //llOwnerSay("Color before free area conversion:  "+(string)ColorRGB);
        vector vFree = CalcFreeAreaColor (ColorRGB); //calculates the white-ish free area of the nail        
        llSetLinkPrimitiveParamsFast(gLPreview, [PRIM_COLOR, 0, vFree, 1.0]);
        //llOwnerSay("Natural");
    }    
    else
    {
       //llSetLinkColor(gLPreview,ColorRGB,ALL_SIDES);
       llSetLinkPrimitiveParamsFast(gLPreview, [PRIM_COLOR, -1, ColorRGB, 1.0]);
       //llOwnerSay("Solid Color");
    }
    gPreviewColorRGB = ColorRGB;
    vector HSL2 = RgbToHsl(ColorRGB);
    //The following two lines are handy is you need the RGB values of the preview box
    vector vTemp = ColorRGB * 255;
    //llOwnerSay("XXX RGB Color: " + (string)vTemp);      
    //llOwnerSay("HSL2: "+(string)HSL2);    
    return HSL2;
}


//This is used by each of the Save Colors & the Small Swatches of Basic Web Colors
//It sets the "Current" preview color, tints the Lum Slider and moves the plus marker
//Although I could have included the lines below for each swatch, this saves
//quite a few lines of code.  Also note that RGB colors for the web colors need
//conversion to SL's system which is easily done by dividing by 255
ColorizeMoveMarkers(integer nType, integer nLinknum, vector ColorRGB)
{
    //llOwnerSay("RGB Values from bottom: "+ (string)ColorRGB);
    if (ColorRGB.x > 1 || ColorRGB.y > 1 || ColorRGB.z > 1)
    {
        ColorRGB = ColorRGB / 255;  
    } 
    // if nType = 0, the user has selected the color of one of the images
    // if nType is 1 to 5, user selected a Fingernail Saved Color AND 6 to 10 is Toenail Saved Color
    if (nType > 0) //Since user selected a saved color, we need to change glNatural based on that choice        
    {
        list PList  = llGetLinkPrimitiveParams(nLinknum,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)           
        vector vTopColor = llList2Vector(PList,0);                    
        if (vTopColor ==  <1.000, 1.000, 1.000>) // if top is white   
        {
            glNatural = 1;  //then it's a natural nail
        }
        else
        {
            glNatural = 0;    
        }
    }
    if (nType > 0 && nType < 6) //User selected a fingernail saved color
    {  //change the fingernail & toenail buttons according to that choice
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 1, gvONColor, 1.0]);
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 2, gvOFFColor, 1.0]);
        glFingerNails = 1;
    }
    else if (nType > 0) //User selected a toenail saved color
    {
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 1, gvOFFColor, 1.0]);
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 2, gvONColor, 1.0]);
        glFingerNails = 0;
    }
    if (glNatural)
    {   //highlight the word "natural"
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 3, gvONColor, 1.0]);
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 4, gvOFFColor, 1.0]);  
    }
    else
    {   //hightlight the word "colored"
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 3, gvOFFColor, 1.0]);
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 4, gvONColor, 1.0]);  
    }
    gPreviewColorHSL = SetPreviewColor2(ColorRGB); //set the preview color & return HSL 
    TintLumSlider(gPreviewColorHSL.x, gPreviewColorHSL.y);  //tint the Lum Slider                   
    MovePlusMarker(gPreviewColorHSL);  //move the Plus Marker based on HSL color values
    MoveLumPointer(gPreviewColorHSL);  //move the Lum Pointer based on HSL color values
    SendColorInfo(); //Send the color values to a script in the object to be colored
       
    
} 


//This sends the SL RGB color values to the object which will be colored
//WhichButton means which button has been pressed:  OK, Cancel or Continue (which means keep going)
SendColorInfo()
{
    if (glSkipSpecFunction == 2)  //2 means it is coming from a shiny button or slider
    {
        glSkipSpecFunction = 1;
        llPlaySound("4174f859-0d3d-c517-c424-72923dc21f65",1.0);
        llOwnerSay("Because of a bug with the specularity (shininess) function in OpenSim, this feature is currently not available. In the meantime, for your convenience, a moderate level of shininess has been pre-built into the finger and toe nail attachments.  (To see the shininess, you'll need to turn on Advanced Lighting in avatar preferences.)  If you wish to make adjustments or turn off shininess, you can do so by selecting either nail, choosing EDIT and making changes directly: Edit >> Texture >> Shininess.  Hopefully, the bug will be fixed soon and you'll be able to make all adjustments from the HUD.");                
    }
    
    string Msg = "["+"<" + (string)gPreviewColorRGB.x + "," + (string)gPreviewColorRGB.y + 
                  "," + (string)gPreviewColorRGB.z +">"+"]"+"["+(string)glNatural+"]"+"["+(string)gnShinyValue+"]";
    if (glFingerNails)
    {
        integer nFChannel = 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ gFChannelID);
        llSay(nFChannel, Msg); //send to fingernails
    }
    else
    {
        integer nTChannel = 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ gTChannelID);
        llSay(nTChannel, Msg); //send to toenails
    }
} 

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
                                                                                                          
//---------------------------------------------------------------------------  
// End of User Defined Functions                       
//---------------------------------------------------------------------------


default
{
    state_entry()
    {
        llSetText("", ZERO_VECTOR, 0);
        integer i = llGetNumberOfPrims();
        while (i)  //Start by getting the link numbers of each prim
        {
            if (llGetLinkName(i) == "LumPointer") // This is the Lumosity pointer link #
            {
                gLPointerNo = i;                
            }
            else if (llGetLinkName(i) == "LumSlider")  //This is Lumosity slider link #
            {
                gLSliderNo = i;
            }
            if (llGetLinkName(i) == "ShinyPointer") // This is the shininess pointer link #
            {
                gLShinyPtNo = i;                
            }
            else if (llGetLinkName(i) == "ShinySlider")  //This is shininess slider link #
            {
                gLShinySlideNo = i;
            }
            else if (llGetLinkName(i) == "PlusMarker")  //plus marker overlaying the palette link #
            {
                gLPlusMarker = i;
            }
            else if (llGetLinkName(i) == "PreviewBox")  //This is the preview link #
            {
                gLPreview = i;
            }    
            else if (llGetLinkName(i) == "SaveColor1")  //Save Color link #
            {
                gSaveColor1 = i;
            }        
            else if (llGetLinkName(i) == "SaveColor2")  //Save Color link #
            {
                gSaveColor2 = i;
            }        
            else if (llGetLinkName(i) == "SaveColor3")  //Save Color link #
            {
                gSaveColor3 = i;
            }                
            else if (llGetLinkName(i) == "SaveColor4")  //Save Color link #
            {
                gSaveColor4 = i;
            }                
            else if (llGetLinkName(i) == "SaveColor5")  //Save Color link #
            {
                gSaveColor5 = i;
            }                
            else if (llGetLinkName(i) == "SaveColor6")  //Save Color link #
            {
                gSaveColor6 = i;
            }                
            else if (llGetLinkName(i) == "SaveColor7")  //Save Color link #
            {
                gSaveColor7 = i;
            }                
            else if (llGetLinkName(i) == "SaveColor8")  //Save Color link #
            {
                gSaveColor8 = i;
            }                
            else if (llGetLinkName(i) == "SaveColor9")  //Save Color link #
            {
                gSaveColor9 = i;
            }                
            else if (llGetLinkName(i) == "SaveColor10")  //Save Color link #
            {
                gSaveColor10 = i;
            }                
            else if (llGetLinkName(i) == "SaveButton")  //Save Color link #
            {
                gSaveButton = i;
            }                
          --i;
        } 
        list ParamList  = llGetLinkPrimitiveParams(gLPreview,[PRIM_COLOR,ALL_SIDES]);
        string OldParams = llList2String(ParamList,0);   
        gPreviewColorRGB = (vector)OldParams;  //set the global preview swatch variable in RGB
        //just in case, something went wrong during last use, set preview at blue color
        if (gPreviewColorRGB.x > 1 || gPreviewColorRGB.y > 1 || gPreviewColorRGB.y > 1)
        {
            gPreviewColorRGB.x = .36640;  //light blue color - places plus marker in
            gPreviewColorRGB.y = .74032;  //upper 1/3 of palette and luminosity pointer
            gPreviewColorRGB.z = .91360;  //in upper half of luminosity slider
            gPreviewColorHSL = SetPreviewColor2(gPreviewColorRGB); //sets preview color
            TintLumSlider(gPreviewColorHSL.x, gPreviewColorHSL.y);  //tint the Lum Slider                   
            MovePlusMarker(gPreviewColorHSL);  //move the Plus Marker based on HSL color values
            MoveLumPointer(gPreviewColorHSL);  //move Lum Pointer based on HSL color values                
        }        
        gPreviewColorHSL = RgbToHsl(gPreviewColorRGB); //set global preview swatch in HSL
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor1,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB1 = (vector)OldParams;  //set the SaveColor1
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor2,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB2 = (vector)OldParams;  //set the SaveColor2
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor3,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB3 = (vector)OldParams;  //set the SaveColor3
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor4,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB4 = (vector)OldParams;  //set the SaveColor4
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor5,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB5 = (vector)OldParams;  //set the SaveColor5
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor6,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB6 = (vector)OldParams;  //set the SaveColor6        
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor7,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB7 = (vector)OldParams;  //set the SaveColor7
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor8,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB8 = (vector)OldParams;  //set the SaveColor8  
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor9,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB9 = (vector)OldParams;  //set the SaveColor9  
        
        ParamList  = llGetLinkPrimitiveParams(gSaveColor10,[PRIM_COLOR,ALL_SIDES]);
        OldParams = llList2String(ParamList,0);   
        gSaveColorRGB10 = (vector)OldParams;  //set the SaveColor10  
        
        if(glFingerNails) //Fingernail button on
        {
            llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 1, gvONColor, 1.0]);
            llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 2, gvOFFColor, 1.0]);            
        }              
        else
        {
            llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 1, gvOFFColor, 1.0]);
            llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 2, gvONColor, 1.0]);            
        }    
        integer nTChannel = 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ -2471719);        
        string Msg = "Re-set";
        llSay(nTChannel, Msg);     
    }
     
    on_rez(integer param)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        integer nLinkNo = llDetectedLinkNumber(0); 
        //User has touched the COLOR PALETTE (actually, it's PLUS MARKER prim that they touch)       
        if (nLinkNo == gLPlusMarker)
        {
              //llOwnerSay( "\nTouched PlusMarker.");
              list ParamList = llGetLinkPrimitiveParams(gLPlusMarker,[PRIM_TEXTURE,llDetectedTouchFace(0)]);
              //ParamList is a list consisting of texture name, repeats, off-sets, etc.
              //First element: texture - Element 0 (not 1)
              string TextureName = llList2String(ParamList,0);                 
              string OldParams= llList2String(ParamList,1); //repeats
              vector Repeats = (vector)OldParams;
              string OldParams2 = llList2String(ParamList,2); //offsets
              vector OffSets = (vector)OldParams2;        
              vector Palette = llDetectedTouchST(0); //Palette is the touch coordinates - not offsets         
              vector v = Palette; //we'll use v for the offsets         
              //llOwnerSay("Plus Marker Touched At: "+(string)v);           
              //PlusMarker is 10% larger than Palette - need to increase coordinates by 5% 
              //It's purposely made larger so that the plus marker doesn't disappear on sides       
              Palette = (Palette * .05) + Palette;   
              //Also a slight correction is required so that the color touched on the pallet is the same
              //color that visually appears in the "Current" preview swatch. It's a very slight difference
              //resulting from the conversion from touch coordinates to color values.  It is not actually
              //even apparent until clicking the narrow yellow and cyan color bands at the top of the palette.  
              //The difference is slightly more on the left side of the palette than the right.  Few people
              //would notice it, but, nonetheless, to assure visual integrity, the slope-intercept formula 
              //is employed to make this adjustment. The slope (m) calculates at -23.48.  The intercept (b) 
              //calculates at 1.26163, resulting in the following: 
              Palette.x = Palette.x - ((Palette.x - 1.26163) / -23.48) ;           
              //just in case the user has gone over the boundaries, the following
              //will keep the plus marker from going out the palette boundaries
              //and it keeps Palette at 1 or under.  Note that v.x & v.y are hard coded
              //if you change the size of the palette, you may need to re-calculate
              if (Palette.x > 1) 
              {
                  Palette.x = 1;
                  v.x = .95179;  
              }
              if (v.x < .04707 )
              {
                  Palette.x = 0;
                  v.x = .04707;
              }
              if (Palette.y > 1)
              {
                  Palette.y = 1;
                  v.y = .95060;
              }
              if (v.y < .03623)
              {
                  v.y = .03623;
              }
              //llOwnerSay("Actual palette coordinates for color: "+(string)Palette);
              v.x -= .5;
              v.y -= .5;          
              //llOwnerSay("Plus Marker Offsets: "+(string)v);              
              //this moves the plus marker to the touched location - note use of PI for rotation
              llSetLinkPrimitiveParamsFast(gLPlusMarker, [PRIM_TEXTURE, llDetectedTouchFace(0), 
                                           TextureName, Repeats, v, PI ]);
              //Using the coordinates, the following calculate hue & saturation & places it in HSL             
              vector HSL = CalculateHueSat(Palette);  //lum is picked up from gPreviewColorHSL
              //llOwnerSay("HSL from CalculateHueSat: "+ (string)HSL);                             
              SetPreviewColor(HSL); //Set the preview color by converting from HSL to RGB   
        }  
               
                                                                 
        //User has touched the LUMINOSITY SLIDER (Actually they touch the LUM POINTER prim)
        else if (nLinkNo == gLPointerNo)  //Pointer for Luminosity Slider Touched
        {
             //llOwnerSay("Lum Slider Touched.");
             integer lum;  //lum is our variable for luminosity
             list ParamList = llGetLinkPrimitiveParams(gLPointerNo,[PRIM_TEXTURE,llDetectedTouchFace(0)]);
             //ParamList is a list consisting of texture name, repeats, off-sets, etc.             
             string TextName = llList2String(ParamList,0);   
             string OldParams= llList2String(ParamList,1); //repeats
             vector Repeats = (vector)OldParams;
             string OldParams2 = llList2String(ParamList,2); //offsets
             vector OffSets = (vector)OldParams2;             
            
             vector gLumSlider = llDetectedTouchST(0); //local coordinates 
             vector v = gLumSlider; //We'll use v for the offsets                          
             //llOwnerSay("Lum slider touched - Y = "+(string)v.y); 
             v.x = OffSets.x;  //x (horizontal stays the same - we are only interested in Y             
             //LumPointer is made larger so that the pointer doesn't disappear on top & bottom,   
             //so make sure the pointer arrow doesn't exceed the top or bottom of the lum slider
             if (gLumSlider.y < .023913) 
             {                        
                 v.y=.023913;
             }   
             if (gLumSlider.y > .973882) 
             {                        
                 v.y=.973882;
             }   
             v.y -= .47;  //.47 instead of .5 provide more accurate placement                   
             //llOwnerSay("Lum pointer MOVED to OFFSET = " + (string)v.y);
             //this moves the lum pointer to the touched location         
             //llOwnerSay("TextName: "+TextName+"  ColorHSL: "+(string)v);    
             llSetLinkPrimitiveParamsFast(gLPointerNo, [PRIM_TEXTURE, llDetectedTouchFace(0), 
                                       TextName, Repeats, v, PI ]);                        
             //clicking high on the luminosity slider gives us smaller numbers
             //BUT for luminosity, low numbers are darker - so we need the inverse
             if (gLumSlider.y == 0)
                {
                    gLumSlider.y=1;
                }
             else if (gLumSlider.y==1)
                {
                    gLumSlider.y=0;   
                }
             else
                {
                    gLumSlider.y = llFabs(1 - gLumSlider.y);
                }              
             if (gLumSlider.y > 1)    
             {                      
                 gLumSlider.y = 1;  
             }                                                   
             //calculate the luminosity value based on the Y coordinate
             float YPoint = gLumSlider.y * 100;
             if(YPoint > 99.5)
             {
                 lum = llCeil(YPoint);
             }
             else if(YPoint < 0.5)
             {
                 lum = llFloor(YPoint);
             }
             else
             {
                 lum = (integer)YPoint;
             }            
             if(lum == -100)
             {
                 lum = 0;
             }            
             gPreviewColorHSL.z = (lum * 1.0) / 100; //change lum
             //llOwnerSay("LUM IS "+(string)gPreviewColorHSL.z);             
             SetPreviewColor(gPreviewColorHSL);  //change current (preview) color with new lum
        }  
        
        
        //User has touched the SHINY SLIDER (Actually they touch the SHINY POINTER prim)
        else if (nLinkNo == gLShinyPtNo)  //Pointer for Shiny Slider Touched
        {
             //llOwnerSay("Shiny Slider Touched.");
             llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 6, gvONColor, 1.0]);
             llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 7, gvOFFColor, 1.0]);             
             list ParamList = llGetLinkPrimitiveParams(gLShinyPtNo,[PRIM_TEXTURE,llDetectedTouchFace(0)]);
             //ParamList is a list consisting of texture name, repeats, off-sets, etc.             
             string TextName2 = llList2String(ParamList,0);   
             string OldParams= llList2String(ParamList,1); //repeats
             vector Repeats = (vector)OldParams;
             string OldParams2 = llList2String(ParamList,2); //offsets
             vector OffSets = (vector)OldParams2;             
            
             vector vShinySlider = llDetectedTouchST(0); //local coordinates 
             vector v = vShinySlider; //We'll use v for the offsets                          
             //llOwnerSay("Lum slider touched - Y = "+(string)v.y); 
             v.x = OffSets.x;  //x (horizontal stays the same - we are only interested in Y             
             //Pointer is made larger so that the pointer doesn't disappear on top & bottom,   
             //so make sure the pointer arrow doesn't exceed the top or bottom of the lum slider
             if (vShinySlider.y < .023913) 
             {                        
                 v.y=.023913;
             }   
             if (vShinySlider.y > .973882) 
             {                        
                 v.y=.973882;
             }   
             v.y -= .47;  //.47 instead of .5 provide more accurate placement                                
             //this moves the  pointer to the touched location             
             llSetLinkPrimitiveParamsFast(gLShinyPtNo, [PRIM_TEXTURE, llDetectedTouchFace(0), 
                                       TextName2, Repeats, v, PI ]);                                     
             if (vShinySlider.y > 1)    
             {                      
                 vShinySlider.y = 1;  
             }                                                   
             //calculate the specularity value based on the Y coordinate
             gnShinyValue = llRound(vShinySlider.y * 255);             
             //llOwnerSay("Shiny value = " + (string)gnShinyValue);
             gnSaveShiny = gnShinyValue;
             if  (glSkipSpecFunction)
             {
                 glSkipSpecFunction = 2;
             }
             SendColorInfo();
        }
        
        else if (nLinkNo == gSaveButton) //SAVE COLOR BUTTON Pressed                                    
        {
        //Saves the selected color to the leftmost "Saved Colors" area & existing colors move right   
                //llOwnerSay("Save Button Pressed");
                list PList;
                vector vTopColor;
                if (glFingerNails && (gPreviewColorRGB != gSaveColorRGB1))
                {
                    PList  = llGetLinkPrimitiveParams(gSaveColor4,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)             
                    vTopColor = llList2Vector(PList,0);                    
                    if (vTopColor ==  <1.000, 1.000, 1.000>) // if top is white
                    {   //set the 5th color block same as the 4th (the old 5th is dumped)
                        llSetLinkPrimitiveParamsFast(gSaveColor5, [PRIM_COLOR, 1, vTopColor, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor5, [PRIM_COLOR, 0, gSaveColorRGB4, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor5, [PRIM_COLOR, ALL_SIDES, gSaveColorRGB4, 1.0]);
                    }                        
                    gSaveColorRGB5 = gSaveColorRGB4;                    
                    
                    PList  = llGetLinkPrimitiveParams(gSaveColor3,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)             
                    vTopColor = llList2Vector(PList,0);                    
                    if (vTopColor ==  <1.000, 1.000, 1.000>) // if top is white                   
                    {   
                        llSetLinkPrimitiveParamsFast(gSaveColor4, [PRIM_COLOR, 1, <1,1,1>, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor4, [PRIM_COLOR, 0, gSaveColorRGB3, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor4, [PRIM_COLOR, -1, gSaveColorRGB3, 1.0]);
                    }                          
                    gSaveColorRGB4 = gSaveColorRGB3;
                    
                    PList  = llGetLinkPrimitiveParams(gSaveColor2,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)             
                    vTopColor = llList2Vector(PList,0);                    
                    if (vTopColor ==  <1.000, 1.000, 1.000>) // if top is white                   
                    {   
                        llSetLinkPrimitiveParamsFast(gSaveColor3, [PRIM_COLOR, 1, <1,1,1>, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor3, [PRIM_COLOR, 0, gSaveColorRGB2, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor3, [PRIM_COLOR, -1, gSaveColorRGB2, 1.0]);
                    }                          
                    gSaveColorRGB3 = gSaveColorRGB2;                    

                    PList  = llGetLinkPrimitiveParams(gSaveColor1,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)
                    vTopColor = llList2Vector(PList,0);                    
                    if (vTopColor ==  <1.000, 1.000, 1.000>) // if top is white                   
                    {   
                        llSetLinkPrimitiveParamsFast(gSaveColor2, [PRIM_COLOR, 1, <1,1,1>, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor2, [PRIM_COLOR, 0, gSaveColorRGB1, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor2, [PRIM_COLOR, -1, gSaveColorRGB1, 1.0]);
                    }                          
                    gSaveColorRGB2 = gSaveColorRGB1;
                    
                    if (glNatural)
                    {   
                        llSetLinkPrimitiveParamsFast(gSaveColor1, [PRIM_COLOR, 1, <1,1,1>, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor1, [PRIM_COLOR, 0, gPreviewColorRGB, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor1, [PRIM_COLOR, -1, gPreviewColorRGB, 1.0]);
                    }                          
                    gSaveColorRGB1 = gPreviewColorRGB;
                    
                }
                if ((glFingerNails == FALSE) && (gPreviewColorRGB != gSaveColorRGB6))  //TOE NAIL SAVES
                {
                    list PList2;
                    vector vTopColor2;
                    PList2  = llGetLinkPrimitiveParams(gSaveColor9,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)             
                    vTopColor2 = llList2Vector(PList2,0);                    
                    if (vTopColor2 ==  <1.000, 1.000, 1.000>) // if top is white
                    {   //set the 5th color block same as the 4th (the old 5th is dumped)
                        llSetLinkPrimitiveParamsFast(gSaveColor10, [PRIM_COLOR, 1, vTopColor2, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor10, [PRIM_COLOR, 0, gSaveColorRGB9, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor10, [PRIM_COLOR, ALL_SIDES, gSaveColorRGB9, 1.0]);
                    }                        
                    gSaveColorRGB10 = gSaveColorRGB9;
                    
                    PList2  = llGetLinkPrimitiveParams(gSaveColor8,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)             
                    vTopColor2 = llList2Vector(PList2,0);                    
                    if (vTopColor2 ==  <1.000, 1.000, 1.000>) // if top is white
                    {   //set the 5th color block same as the 4th (the old 5th is dumped)
                        llSetLinkPrimitiveParamsFast(gSaveColor9, [PRIM_COLOR, 1, vTopColor2, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor9, [PRIM_COLOR, 0, gSaveColorRGB8, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor9, [PRIM_COLOR, ALL_SIDES, gSaveColorRGB8, 1.0]);
                    }                        
                    gSaveColorRGB9 = gSaveColorRGB8;
                    
                    PList2  = llGetLinkPrimitiveParams(gSaveColor7,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)             
                    vTopColor2 = llList2Vector(PList2,0);                    
                    if (vTopColor2 ==  <1.000, 1.000, 1.000>) // if top is white
                    {   //set the 5th color block same as the 4th (the old 5th is dumped)
                        llSetLinkPrimitiveParamsFast(gSaveColor8, [PRIM_COLOR, 1, vTopColor2, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor8, [PRIM_COLOR, 0, gSaveColorRGB7, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor8, [PRIM_COLOR, ALL_SIDES, gSaveColorRGB7, 1.0]);
                    }                                            
                    gSaveColorRGB8 = gSaveColorRGB7;
                    
                    PList2  = llGetLinkPrimitiveParams(gSaveColor6,[PRIM_COLOR,1]); //get color/alpha from face 1 (top)             
                    vTopColor2 = llList2Vector(PList2,0);                    
                    if (vTopColor2 ==  <1.000, 1.000, 1.000>) // if top is white
                    {   //set the 5th color block same as the 4th (the old 5th is dumped)
                        llSetLinkPrimitiveParamsFast(gSaveColor7, [PRIM_COLOR, 1, vTopColor2, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor7, [PRIM_COLOR, 0, gSaveColorRGB6, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor7, [PRIM_COLOR, ALL_SIDES, gSaveColorRGB6, 1.0]);
                    }                        
                    gSaveColorRGB7 = gSaveColorRGB6;
                    
                    if (glNatural)
                    {   
                        llSetLinkPrimitiveParamsFast(gSaveColor6, [PRIM_COLOR, 1, <1,1,1>, 1.0]);
                        llSetLinkPrimitiveParamsFast(gSaveColor6, [PRIM_COLOR, 0, gPreviewColorRGB, 1.0]);
                    }
                    else
                    {
                        llSetLinkPrimitiveParamsFast(gSaveColor6, [PRIM_COLOR, -1, gPreviewColorRGB, 1.0]);
                    }                          
                    gSaveColorRGB6 = gPreviewColorRGB;                        
                }                
        
        
        }
        
        else //If the user didn't touch the palette, lum slider or shiny slider 
        {    //check for other touch locations below . . .
            vector Touched = llDetectedTouchST(0);
            //llOwnerSay("Touched Elsewhere: "+ (string)Touched);
            integer Linkno = llDetectedLinkNumber(0);
            integer nFace = llDetectedTouchFace(0);
            
            if(Linkno == 1 && nFace ==1) //fingernails button pressed
            {
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 1, gvONColor, 1.0]); //toggle buttons
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 2, gvOFFColor, 1.0]);
                glFingerNails = 1;
            }
            else if(Linkno == 1 && nFace ==2)  //Toenail button pressed
            {
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 1, gvOFFColor, 1.0]);  //toggle buttons
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 2, gvONColor, 1.0]);
                glFingerNails = 0;
            }
            if(Linkno == 1 && nFace == 6 )  //Shiny Button pressed - ON
            {
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 6, gvONColor, 1.0]);  //highlight user's choice
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 7, gvOFFColor, 1.0]);
                gnShinyValue = gnSaveShiny;
                if  (glSkipSpecFunction)
                 {
                     glSkipSpecFunction = 2;
                 }                
                SendColorInfo();
            }   
            if(Linkno == 1 && nFace == 7 )  //Shiny Button pressed - OFF
            {
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 6, gvOFFColor, 1.0]);  //highlight user's choice
                llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, 7, gvONColor, 1.0]);
                gnShinyValue = 0;
                if  (glSkipSpecFunction)
                 {
                     glSkipSpecFunction = 2;
                 }
                SendColorInfo();
            }                                   
            
            //face 5 is the "Change Texture" button 
            if (Linkno == 1 && nFace == 5) 
            {
                llPlaySound("4174f859-0d3d-c517-c424-72923dc21f65",1.0);
                llOwnerSay("This feature has not been implemented yet");                
             }                
                
            
            //Next 6 "if's": User has clicked on one of the SAVED COLOR SWATCHES
            //The same function "ColorizeMoveMarkers" is used for all of the Save Colors 
            //and the small basic web color swatches
            
            if (Linkno == gSaveColor1) //Save Color #1
            {
                //The following sets the "Current" preview color, tints Lum Slider & moves the plus marker
                ColorizeMoveMarkers(1,gSaveColor1,gSaveColorRGB1);                
             }
             if (Linkno == gSaveColor2)
             {                
                ColorizeMoveMarkers(2,gSaveColor2,gSaveColorRGB2);                
             }
             if (Linkno == gSaveColor3)
             {                
                ColorizeMoveMarkers(3,gSaveColor3,gSaveColorRGB3);                
             }
             if (Linkno == gSaveColor4)
             {                
                ColorizeMoveMarkers(4,gSaveColor4,gSaveColorRGB4);                
             }
             if (Linkno == gSaveColor5)
             {                
                ColorizeMoveMarkers(5,gSaveColor5,gSaveColorRGB5);                
             }
             if (Linkno == gSaveColor6)
             {                
                ColorizeMoveMarkers(6,gSaveColor6,gSaveColorRGB6);                
             }
             if (Linkno == gSaveColor7)
             {                
                ColorizeMoveMarkers(7,gSaveColor7,gSaveColorRGB7);                
             }
             if (Linkno == gSaveColor8)
             {                
                ColorizeMoveMarkers(8,gSaveColor8,gSaveColorRGB8);                
             }
             if (Linkno == gSaveColor9)
             {                
                ColorizeMoveMarkers(9,gSaveColor9,gSaveColorRGB9);                
             }
             if (Linkno == gSaveColor10)
             {                
                ColorizeMoveMarkers(10,gSaveColor10,gSaveColorRGB10);                
             }  
             /////////////////////////////////////////////////////////////////////////////////
             /////////////////////////////////////////////////////////////////////////////////
            //Next 17 "if's": User has clicked on one of the small fingernail/toenail image
             
            //User has clicked on the 1st Natural Image
            if (Touched.x > 0.189889 && Touched.x < 0.220127 && Touched.y > 0.638694 && Touched.y < 0.698583)
            {                
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<217,204,194>);                 
            }
            //User has clicked on the 2nd Natural Image
            if (Touched.x > 0.225371 && Touched.x < 0.254294 && Touched.y > 0.638709 && Touched.y < 0.695270)
            {                
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<205,188,179>); 
                
            }//User has clicked on the 3rd Natural image
            if (Touched.x > .260852 && Touched.x < .287150 && Touched.y > .637059 && Touched.y < .696949)
            {
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<201,175,164>);                                 
                
            }////User has clicked on the 4th Natural image
            if (Touched.x > .295019 && Touched.x < .322632 && Touched.y > .638739 && Touched.y < .695302)
            {
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<201,168,156>);                 
                
            }////User has clicked on the 5th Natural image
            if (Touched.x > .327871 && Touched.x < .356797 && Touched.y > .640421 && Touched.y < .695320)
            {
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<198,160,152>);                 
            } 
             ////User has clicked on the 6th Natural image
            if (Touched.x > 0.364665 && Touched.x < 0.390963 && Touched.y > 0.642103 && Touched.y < 0.697003)
            {                
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<183,148,141>);                 
            }
            //User has clicked on the 7nd Natural Image
            if (Touched.x > 0.396204 && Touched.x < 0.423814 && Touched.y > 0.635461 && Touched.y < 0.695355)
            {                
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<176,143,136>); 
                
            }//User has clicked on the 8rd Natural image
            if (Touched.x > .430365 && Touched.x < .459289 && Touched.y > .642133 && Touched.y < .697034)
            {
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<160,128,123>);                                 
                
            }////User has clicked on the 9th Natural image
            if (Touched.x > .463220 && Touched.x < .493458 && Touched.y > .640485 && Touched.y < .693721)
            {
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<126,100,93>);                 
                
            }////User has clicked on the 10th Natural image
            if (Touched.x > .497388 && Touched.x < .528954 && Touched.y > .638829 && Touched.y < .697064)
            {
                glNatural = 1;  //set to true
                ColorizeMoveMarkers(0,0,<128,83,83>);                     
            }   
            ////////////////////////////// COLORED IMAGES
            //User has clicked the 1st Colored image
            if (Touched.x > .584132 && Touched.x < .614375 && Touched.y > .640535 && Touched.y < .697092)
            {
                //llOwnerSay("First colored image touched");
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<230,72,96>);
                
            }//User has clicked the 2nd Colored image
            if (Touched.x > .618306 && Touched.x < .649860 && Touched.y > .638888 && Touched.y < .693786)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<225,51,89>);                 
                
            }//User has clicked the 3rd Colored image
            if (Touched.x > .653786 && Touched.x < .684025 && Touched.y > .638900 && Touched.y < .692135)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<184,40,57>);                 
                
            }//User has clicked the 4th Colored image
            if (Touched.x > .687950 && Touched.x < .716875 && Touched.y > .638912 && Touched.y < .695475)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<247,74,242>);                 
                
            }//User has clicked the 5th Colored image
            if (Touched.x > .720800 && Touched.x < .749725 && Touched.y > .640588 && Touched.y < .697151)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<212,16,204>);                 
                
            } //User has clicked the 6th Colored image          
            if (Touched.x > .760254 && Touched.x < .784736 && Touched.y > .632958 && Touched.y < .696627)
            {
                //llOwnerSay("First colored image touched");
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<144,9,126>);
                
            }//User has clicked the 7nd Colored image
            if (Touched.x > .791513 && Touched.x < .820071 && Touched.y > .638137 && Touched.y < .694920)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<182,56,250>);                 
                
            }//User has clicked the 8rd Colored image
            if (Touched.x > .825491 && Touched.x < .855408 && Touched.y > .636433 && Touched.y < .693215)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<134,31,244>);                 
                
            }//User has clicked the 9th Colored image
            if (Touched.x > .859469 && Touched.x < .890750 && Touched.y > .638170 && Touched.y < .691510)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<56,126,240>);                 
                
            }//User has clicked the 10th Colored image
            if (Touched.x > .896173 && Touched.x < .924736 && Touched.y > .638186 && Touched.y < .689806)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<16,67,234>);                 
                
            } //User has clicked the 11th Colored image          
             if (Touched.x > .930158 && Touched.x < .961440 && Touched.y > .636481 && Touched.y < .689822)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<4,19,190>);                 
                
            }           
            //User has clicked the 2nd Row - 1st Colored image
            if (Touched.x > .587667 && Touched.x < .616223 && Touched.y > .546837 && Touched.y < .610506)
            {                
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<12,79,166>);
                
            }//User has clicked the 2nd Row 2nd Colored image
            if (Touched.x > .621647 && Touched.x < .650207 && Touched.y > .545134 && Touched.y < .607079)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<3,54,125>);                 
                
            }//User has clicked the 2nd Row 3rd Colored image
            if (Touched.x > .652912 && Touched.x < .686908 && Touched.y > .545152 && Touched.y < .607095)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<5,127,76>);                 
                
            }//User has clicked the 2nd Row 4th Colored image
            if (Touched.x > .690967 && Touched.x < .722244 && Touched.y > .546886 && Touched.y < .605388)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<3,78,47>);                 
                
            }//User has clicked the 2nd Row 5th Colored image
            if (Touched.x > .724944 && Touched.x < .756221 && Touched.y > .546898 && Touched.y < .607121)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<50,84,8>);                 
                
            } //User has clicked the 2nd Row 6th Colored image          
            if (Touched.x > .758922 && Touched.x < .790198 && Touched.y > .546910 && Touched.y < .605413)
            {                
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<113,70,9>);
                
            }//User has clicked the 2nd Row 7nd Colored image
            if (Touched.x > .791540 && Touched.x < .825534 && Touched.y > .546923 && Touched.y < .603703)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<80,50,7>);                 
                
            }//User has clicked the 2nd Row 8rd Colored image
            if (Touched.x > .826878 && Touched.x < .862229 && Touched.y > .548659 && Touched.y < .600276)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<115,110,104>);                 
                
            }//User has clicked the 2nd Row 9th Colored image
            if (Touched.x > .862213 && Touched.x < .896214 && Touched.y > .550396 && Touched.y < .605456)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<83,79,75>);                 
                
            }//User has clicked the 2nd Row 10th Colored image
            if (Touched.x > .897558 && Touched.x < .931560 && Touched.y > .546970 && Touched.y < .602030)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<85,57,52>);                 
                
            } //User has clicked the 2nd Row 11th Colored image          
             if (Touched.x > .930183 && Touched.x < .968263 && Touched.y > .550429 && Touched.y < .603766)
            {
                glNatural = 0;  //set to false
                ColorizeMoveMarkers(0,0,<50,41,42>);                 
                
            }           
        }
    }
}
