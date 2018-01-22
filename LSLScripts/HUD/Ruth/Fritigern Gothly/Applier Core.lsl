// By Fritigern Gothly
//APPLIER CORE, to be placed in mesh body
//
// *** NOTICE ***
// This code is a work in progress, and you see here a snapshot in the middle of development.
// The code works, provided the body parts are renamed according to the list at the end of this script.
// There is no doubt in my mind that some, perhaps most of the methods used could be replaced with
//   more elegant and/or more efficient code. But that what development is :-)
// I also re-linked the head so that it became the root prim, which probably will not be necessary in the future.

////  P.S. I quickly commented the code, for those that like that kind of thing. I could prolly do better, but meh ;-)

integer APPKEY = 987654321; // Application key, needed later. Change as you see fit, but remain consistent!
integer CH;                 // Communication channel

// Routine to use the owner's UUID as the basis for a channel number. Uses the above APPKEY.
integer Key2AppChan(key ID, integer App) {
	return 0x80000000 | ((integer)("0x"+(string)ID) ^ App);
}

// My lazy way of switching between debug modes.
//integer DEBUG=TRUE;
integer DEBUG=FALSE;

string keyword="Applier"; // Keyword to prefix the command string with.

integer n; //generally used for whatever loops

integer head;   // Will be the link number of the head.
list upper;     // List foor the upper body parts
list lower;     // List for the lower body parts
integer numprims;

init()      // initialization routine. Only called once per run.
{
	CH = Key2AppChan(llGetOwner(), APPKEY);     // Set the communication channel, based on owner UUID and the APPKEY
	numprims=llGetNumberOfPrims();      // Get the number of prims in this mesh body. I let it count the prims, in case there will be additional (or fewer) links to Ruth2.0 in the future
	string obj_name = llGetObjectName();        // Define the object's name, which saves script time. Since I made the head the root prim, the head should carry the object's name.
	for(n=0;n<=numprims;++n)                    // Routine to check each link's name (you will have to have renamed them yourself), and stuff the values in the lists named "upper" and "lower" and set the integer "head" to the number of the link which wears the object's name
	{
		string name = llGetLinkName(n);
		if(name == obj_name) head = n;

		if(name == "chest"||name == "breast_r"||name == "breast_l"||name == "midriff"||name == "upper_back"||name == "lower_back"||name == "arm_l"||name == "arm_r"||name == "hand_r"||name == "hand_l") upper += n;

		if(name == "pelvis"||name == "butt"||name == "upper_leg_top_r"||name == "upper_leg_top_l"||name == "upper_leg_mid_l"||name == "upper_leg_mid_r"||name == "upper_leg_bot_r"||name == "upper_leg_bot_l"||name == "upper_knee_r"||name == "upper_knee_l"||name == "lower_knee_r"||name == "lower_knee_l"||name == "lower_leg_top_r"||name == "lower_leg_top_l"||name == "lower_leg_mid_r"||name == "lower_leg_mid_l"||name == "lower_leg_bot_r"||name == "lower_leg_bot_l"||name == "feet") lower += n;
	}
}

default
{
	state_entry()
	{
		init();                     // Initialize the script to prepare for action.
		llListen(CH, "","","");     // Listen to ANYTHING on channel CH.
	}

	listen(integer channel, string name, key id, string msg)
	{
		if(llGetSubString(msg, 0, llSubStringIndex(msg, "%")-1)  != keyword) return; // Find the keyword ("Applier") but abort if not found.
		msg = llDeleteSubString(msg, 0, llStringLength(keyword));                    // Stip the keyword from the message, leaving only the useful stuff

		integer index = llSubStringIndex(msg, "_");                                  // Find the first underscore in the message string
		if (DEBUG) llOwnerSay("IDENT="+llGetSubString(msg, 0, index-1));                            // Debug messages. Only useful for finding bugs (imagine that! ;-))
		if (DEBUG) llOwnerSay("UUID="+llGetSubString(msg, index+1, llStringLength(msg))+"\n\n");    // More debug messages.

		string IDENT=llGetSubString(msg, 0, index-1);               // The value of IDENT will be the part which needs to be textured. For example, "head", "midriff" or "arm_l".
		key UUID=llGetSubString(msg, index+1, llStringLength(msg)); // This extracts the texture's UUID which we want applied to the body part.

		// LET'S APPLY THIS, BABY! ===========================================================

		integer n;

		if(IDENT == "head") llSetLinkPrimitiveParamsFast(head, [PRIM_TEXTURE, ALL_SIDES, (string) UUID, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0 ]); // Applies texture "UUID" to the head.
		if(IDENT == "upper"){ // Iterate through all links which are stored in the list called "upper" and apply texture "UUID" to each link.
			for(n=0;n<=llGetListLength(upper); ++n)
			{
				integer int=(llList2Integer(upper,n));
				llSetLinkPrimitiveParamsFast(int, [PRIM_TEXTURE, ALL_SIDES, (string) UUID, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0 ]);
			}
		}

		if(IDENT == "lower"){ // Iterate through all links which are stored in the list called "lower" and apply texture "UUID" to each link.
			for(n=0;n<=llGetListLength(lower)+1; ++n)
			{
				llSetLinkPrimitiveParamsFast(llList2Integer(lower,n), [PRIM_TEXTURE, ALL_SIDES, (string) UUID, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0 ]);
			}
		}

		if(IDENT == "fnails"){ // Apply texture "UUID" to the fingernails.
			for(n=0;n<=numprims;++n)
			{
				name = llGetLinkName(n);
				if(name == "hand_l"||name == "hand_r") llSetLinkPrimitiveParamsFast(n, [PRIM_TEXTURE, 0, (string) UUID, <1.0, 1.0, 0.0>, <0.02, 0.0, 0.0>, 0.0 ]);
			}
		}
		if(IDENT == "tnails"){// Apply texture "UUID" to the fingernails.
			for(n=0;n<=numprims;++n)
			{
				name = llGetLinkName(n);
				if(name == "feet") llSetLinkPrimitiveParamsFast(n, [PRIM_TEXTURE, 1, (string) UUID, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0 ]);
			}
		}
	}
}

/*
	// INACTIVE TEXT, USED FOR REFERENCE. CAN BE SAFELY DELETED.
	### HEAD ###
		[15:27:34] head: Link #1: head

			### UPPER ###
				[15:27:34] head: Link #07: chest
					[15:27:34] head: Link #02: breast_r
						[15:27:34] head: Link #09: breast_l
							[15:27:34] head: Link #03: midriff
								[15:27:34] head: Link #04: upper_back
									[15:27:34] head: Link #10: lower_back
										[15:27:34] head: Link #08: arm_l
											[15:27:34] head: Link #30: arm_r
												[15:27:34] head: Link #28: hand_r
													[15:27:34] head: Link #29: hand_l

														### LOWER ###
															[15:27:34] head: Link #05: pelvis
																[15:27:34] head: Link #12: butt
																	[15:27:34] head: Link #06: upper_leg_top_r
																		[15:27:34] head: Link #23: upper_leg_top_l
																			[15:27:34] head: Link #14: upper_leg_mid_l
																				[15:27:34] head: Link #16: upper_leg_mid_r
																					[15:27:34] head: Link #19: upper_leg_bot_r
																						[15:27:34] head: Link #18: upper_leg_bot_l
																							[15:27:34] head: Link #17: upper_knee_r
																								[15:27:34] head: Link #13: upper_knee_l
																									[15:27:34] head: Link #20: lower_knee_r
																										[15:27:34] head: Link #15: lower_knee_l
																											[15:27:34] head: Link #11: lower_leg_top_r
																												[15:27:34] head: Link #24: lower_leg_top_l
																													[15:27:34] head: Link #22: lower_leg_mid_r
																														[15:27:34] head: Link #25: lower_leg_mid_l
																															[15:27:34] head: Link #21: lower_leg_bot_r
																																[15:27:34] head: Link #26: lower_leg_bot_l
																																	[15:27:34] head: Link #27: feet
																																		*/