// By Fritigern Gothly
//SKIN APPLIER

integer APPKEY = 987654321; // Application key, needed later. Change as you see fit, but remain consistent!
integer CH;                 // Communication channel

// Routine to use the owner's UUID as the basis for a channel number. Uses the above APPKEY.
integer Key2AppChan(key ID, integer App) {
	return 0x80000000 | ((integer)("0x"+(string)ID) ^ App);
}

string keyword="Applier"; // Keyword to prefix the command string with.

// Change the keys to the UUIDs of the textures that need to be applied.
key tex_head ="16ffccd7-40c7-4fc7-be14-76bc26b47bbb";
key tex_upper="6cec3f96-aac2-47c2-9738-f32336aa6fe5";
key tex_lower="441409df-4a3c-4047-87c4-bdf4a0b90dee";

default
{
	state_entry()
	{
		CH = Key2AppChan(llGetOwner(), APPKEY);     // Set the communication channel, based on owner UUID and the APPKEY
	}

	touch_start(integer num)
	{
		// Now tell the body which textures it should apply
		llSay(CH,keyword+"%head_"+tex_head);
		llSay(CH,keyword+"%upper_"+tex_upper);
		llSay(CH,keyword+"%lower_"+tex_lower);
	}
}