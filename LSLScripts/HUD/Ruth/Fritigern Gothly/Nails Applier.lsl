// By Fritigern Gothly
//NAILS APPLIER

integer APPKEY = 987654321; // Application key, needed later. Change as you see fit, but remain consistent!
integer CH;                 // Communication channel

// Routine to use the owner's UUID as the basis for a channel number. Uses the above APPKEY.
integer Key2AppChan(key ID, integer App) {
	return 0x80000000 | ((integer)("0x"+(string)ID) ^ App);
}

string keyword="Applier"; // Keyword to prefix the command string with.

// Change the keys to the UUIDs of the textures that need to be applied.
key tex_finger_nails ="20db9cde-7d4f-4f34-b173-f08808eb9aa9";
key tex_toe_nails ="d51dad86-46c1-42b1-a1ab-d0e861483f86";

default
{
	state_entry()
	{
		CH = Key2AppChan(llGetOwner(), APPKEY);     // Set the communication channel, based on owner UUID and the APPKEY
	}

	touch_start(integer num)
	{
		// Now tell the body which textures it should apply to the nails
		llSay(CH,keyword+"%fnails_"+tex_finger_nails);
		llSay(CH,keyword+"%tnails_"+tex_toe_nails);
	}
}