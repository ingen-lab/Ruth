// NAME: Hand Pose HUD Script
// AUTHOR: Sundance Haiku (https://plus.google.com/u/0/114880810031398834985)
// AUTHOR: Chimera Firecaster (https://plus.google.com/115549296923155647217 & https://chimerafire.wordpress.com/)
// VERSION: 1.02
// DESCRIPTION:
//      This script is intended to be placed inside a HUD to animate the hands into different poses
//      Complete instructions on how to assemble the HUD and use this script are found on the Ruth Github site (below)
// MORE INFORMATION:
//      Ruth Discussion Forum: https://plus.google.com/communities/103360253120662433219
//      Ruth GitHub Site: https://github.com/Outworldz/Ruth
//
// COPYRIGHT:
//   Copyright 2018 by Sundance Haiku and Chimera Firecaster
//   For: Hand Pose HUD Script, Hand Pose HUD & Scripts
//
//   Licensed under “The Virtual License: Open Source, Non-commercial,” Version 1.0
//   (the "License"); you may not use this Work except in compliance with the License.  
//   If the License is not included this work, a copy is available at the following:
//      https://tinyurl.com/ycaom8g7
//   This is an open source work.  The source files are found at:  
//      https://github.com/Outworldz/Ruth
//   Subsidiary Creations (see License for more information): Hand Pose Animations
//
//   Unless required by applicable law or agreed to in writing, the software distributed 
//   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
//   OR CONDITIONS OF ANY KIND, either express or implied.  
//
//   You may give this work to another person or share or distribute this work with 
//   other non-commercial work as long as it is provided FREE OF COST and the following 
//   is met:  (1) Include the above text.  (2) Include a copy of the License document 
//   including the “Plain Language Summary” and copy of the License.  If not 
//   reasonably possible to include to the License document, use the above hyperlink.)  
//   (3) Indicate if you have modified the work and where you modified it.  If 
//   modified and if sharing it, include either a “Modify, Transfer” version of the 
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
//-----Do Not Remove Above Header

//Global declarations
string gcAnimation = "";      //the currently selected animation from the HUD inventory
string gcPrevRtAnim = "";     //the previously selected animation on the right side
string gcPrevLfAnim = "";     //the previously selected animation on the left side
string gcWhichSide = "";      //Whether the currently selected animation is a right or left hand
integer gnButtonNo = 0;       //The number of the button pressed by the user
integer gnPrimNo;             //The prim which contains the button pressed
integer gnPrimFace;           //The face of the prim containing the button pressed
integer gnButtonStart;        //The starting number of a group of buttons
vector gvONColor =  <0.224, 0.800, 0.800>;  //Teal color to indicate the button has been pressed
vector gvOFFColor = <1.0, 1.0, 1.0>;  //white color to indicate the button has not been pressed
integer glStopAll =FALSE;

///////////////////////////////////////////////////////////////////////////////////////////////////
//User defined functions

//The following function is used to show that a button has been clicked by coloring it.  It determines
//whether the button is a right or left hand pose.  When a right hand button is colored, it removes the
//coloring from the previously select right hand button - and does the same for left buttons.

ColorButton()
{
	gcWhichSide ="";  //initialize
	if(gnPrimFace & 0x01) //check to see whether it is odd (all "right" buttons) - faces start at 0 so all odd numbers are right buttons
	{
		gcWhichSide = "RIGHT" ; // odd number
	}
	else  //or even (all "left" buttons
	{
		gcWhichSide = "LEFT"; // even number
	}
	integer nPrimCount = 1;  //the first button group prim will be 2 (since the backboard is the first prim), When the loop starts 1 is incremented to 2
	integer nFaceCount = -1; //the first face of a button group will be 0.  When the loop starts -1 is incremented to 0.
	do  //cycle through each prim (each button group)
	{
		nPrimCount=nPrimCount + 1;
		do //cycle through each face (contained on each prim)
		{
			nFaceCount=nFaceCount+1;
			if((nPrimCount==gnPrimNo) && (nFaceCount==gnPrimFace)) //if this is the button being pressed
			{
				llSetLinkPrimitiveParamsFast(gnPrimNo, [PRIM_COLOR, gnPrimFace, gvONColor, 1.0]); //color the button
			}
			else
			{
				if(gcWhichSide=="RIGHT")
				{
					if(nFaceCount & 0x01)//If it's odd it's a "right" button - remove the color from right buttons, but not left buttons
					{
						llSetLinkPrimitiveParamsFast(nPrimCount, [PRIM_COLOR, nFaceCount, gvOFFColor, 1.0]); //remove color from the button
					}
				}
				else  //lLeftButtons
				{
					if(!(nFaceCount & 0x01)) //if it's a "left" button, remove the color from all left buttons but don't do that for right buttons
					{
						llSetLinkPrimitiveParamsFast(nPrimCount, [PRIM_COLOR, nFaceCount, gvOFFColor, 1.0]); //remove color from the button
					}
				}
			}
		}
		while(nFaceCount < 6);  //6 faces for each prim
		nFaceCount=-1;  //reset nFaceCount for each new prim
	}
	while(nPrimCount < 5);  //4 prims
}


//The stop all function removes all animations from the avatar.  In our testing, we found that on some occassions,
//the avatar may have existing hand animations with a higher priority.  In that case, the user would not be able
//to use the HUD's hand poses.  This takes care of that problem.  Thanks to Fred Kinsei & Outworldz lsl file depository
//for the first part of this snippet AND to RJ Source of Green Sky Labs who posted on SL Forums about a problem
//with removing all anims and suggesting the "stand" solution.
StopAll()
{
	if(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)
	{
		list anims = llGetAnimationList(llGetPermissionsKey());
		integer len = llGetListLength(anims);
		integer i;
		for (i = 0; i < len; ++i) llStopAnimation(llList2Key(anims, i));
		llStartAnimation("stand");  //removing all anims can create problems - this sorts things out
		llOwnerSay("All finished: " + (string)len + llGetSubString(" animations",0,-1 - (len == 1))+" stopped.");
		llOwnerSay(" ");
		//llOwnerSay("All animations have been stopped.");
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

default
{
	touch_start(integer detected)
	{
		//llOwnerSay("START *************");
		if (llDetectedKey(0) == llGetOwner())
		{
			integer i; //1 is always the rootprim of a linkset
			integer x = llGetNumberOfPrims() + 1; //number of iterations
			gnPrimNo = llDetectedLinkNumber(0);
			gnPrimFace = llDetectedTouchFace(0); //note that first face in a prim is 0 not 1
			list linkParamList = llGetLinkPrimitiveParams(gnPrimNo,[PRIM_NAME, PRIM_DESC, PRIM_TEXTURE,-1]);
			string cPrimName = llList2String(linkParamList,0); //returns the prim name of the set of buttons touched
			gnButtonStart = (integer)cPrimName;  //cPrimName contains the starting number for that set of buttons
			gnButtonNo = gnButtonStart + gnPrimFace;

			if ((gnPrimNo!=1) && (gnPrimFace < 6))  //Prim 1 is the root prim (backboard & we skip it). Also can't have any faces greater than 5 on the button prims
			{
				llRequestPermissions(llDetectedKey(0), PERMISSION_TRIGGER_ANIMATION);
			}
			else
			{
				if (gnPrimFace==1)
				{
					glStopAll = TRUE;
					llRequestPermissions(llDetectedKey(0), PERMISSION_TRIGGER_ANIMATION);
				}
				else
				{
					//llOwnerSay("Backboard touched");
				}
			}
		}
	}

	run_time_permissions(integer perm)
	{
		if (perm & PERMISSION_TRIGGER_ANIMATION)

			if (glStopAll)  //User pressed the Stop All Animations button
			{
				glStopAll=FALSE;
				StopAll();  //call the Stop all animations function
			}
		else //User pressed one of the buttons
		{
			list    InventoryList;
			integer nCounter = -1;
			integer lFlag = FALSE;
			integer nTotCount = llGetInventoryNumber(INVENTORY_ANIMATION);  // Count of all animations in prim's contents
			integer nItemNo;
			gcAnimation="";
			do   //loop through the inventory - (Using a DO-WHILE loop since SL docs say that it is faster than WHILE or FOR)
			{
				nCounter++;
				gcAnimation = llGetInventoryName(INVENTORY_ANIMATION, nCounter);  //note that first animation on list is 0 not 1
				nItemNo = (integer)gcAnimation;   //Each animation has a number, ie: 02_HandRelaxed1
				if (nItemNo == gnButtonNo)  //When the Animation number matches the button number
				{
					if(gcAnimation != "")
					{
						ColorButton();  //this runs the user defined function which turns the buttons on & off
						//it also returns a value for gcWhichSide

						if(gcWhichSide=="RIGHT") //stop the previous animation on the same side as the new one
						{
							if(gcPrevRtAnim != "")
							{
								llStopAnimation(gcPrevRtAnim);
							}
							gcPrevRtAnim = gcAnimation;
						}
						else if (gcWhichSide == "LEFT")
						{
							if(gcPrevLfAnim != "")
							{
								llStopAnimation(gcPrevLfAnim);
							}
							gcPrevLfAnim = gcAnimation;
						}
						llStartAnimation(gcAnimation);  //start the user's selected animation
						//llOwnerSay("We started: "+gcAnimation+"  gcPrevLfAnim is: "+gcPrevLfAnim+"  " + "gcPrevRtAnim is: "+gcPrevRtAnim);
						nCounter = nTotCount + 2;  //by setting nCounter high, we exit the do-while loop
						lFlag = TRUE; //We found the animation
					}
				}
			}
			while(nCounter < nTotCount);

			if (!(gnButtonStart==1 | gnButtonStart==7 | gnButtonStart == 13 | gnButtonStart ==19))  //error trapping
			{
				nItemNo = 100;  //temporarily set this to 100 to trigger the proper error message
				lFlag = FALSE;
			}

			if(! lFlag)  //Error messages - explanations of common problems a user might have if they assemble the HUD or add their own animations
			{
				if(nItemNo == 0)
				{
					llOwnerSay("There's a problem.  First check to make sure you've loaded all of the hand animations in the HUD inventory.  There should be 24 of them.  If that's not the problem, you may have used an incorrect name for one of the prims making up the HUD. Finally, double check to make sure that the backboard of the HUD is the last prim you linked (the root prim).");
					llOwnerSay(" ");
				}
				else if (nItemNo == 100)
				{
					llOwnerSay("Error.  One or more of the button prims haven't been numbered correctly.  They should be named: 01_, 07_, 13_, and 19_.  Make sure you used zeros (0) and not O's.");
					llOwnerSay(" ");
				}
				else
				{
					llOwnerSay("Animation # "+(string)nItemNo + " was not found.  Check the animations in the inventory of the HUD.  When numbering the animations, you may have left this number out.");
					llOwnerSay(" ");
				}
			}

		} //End of if(glStopAll)
	}
}
