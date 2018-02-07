INFORMATION ON THE OPEN SIM BUG . . .

I wanted to add a conversation that I had with Typhaine Artez since it provides background on a bug in the code underlying OpenSim . . .

TYPHAINE ARTEX: "Hi Sundance - I saw your words about specularity, and I wonder how? OpenSim does not support modifying normal and specular settings by script (http://opensimulator.org/mantis/view.php?id=8282)."

HERE'S MY RESPONSE: Well that's a bummer. It's a very cool feature and convenient. You can turn specularity on or off and adjust it (using llSetLinkPrimitiveParamsFast(0,[ PRIM_SPECULAR). Dang. Works in SL, but not in OpenSim. Well, at least until things are fixed in OpenSim. It's been tested and it works in the SL environment, so I'll keep everything in place and temporarily disable that feature for OpenSim. For the time being, folks will have to manually adjust specularity in the Edit window."

Thanks for telling me about this. I would have been doing some serious head scratching. Any idea how long it will be before it's fixed for OpenSim?

TYPHAINE ARTEX: Yes, I work on a derivative version of the Athena body since a while, and have been stupefied when I saw OpenSim doesnot support changing it by script. I saw getting the values is ok in latest releases of OpenSim (and even, you must know the number of faces on a mesh, you can't request for ALL_SIDES because of an old bug). But the missing feature seems to be postponed, so I have no idea when this will come out.

What I did is to keep the code managing it (on the hud side), and accepting normal and specular commands in the receiver (body) but making them dumb (doing nothing actually), otherwise you get errors in the debug channel (unsupported parameter for rule #x).

BTW, the same applies to alpha modes (mask/blend)

MY COMMENTS: Because of this bug, I've added a global variable to the HUD code. When set, the user receives a message informing them of the underlying bug, and that for the time being the specularity feature is not available.

MY COMMENTS: It looks to me that in order to use the specularity settings found in the EDIT window: Edit >> Texture >> Shininess (Under the the terms "Glossiness" and "Environment), you must have "Advanced Lighting" turned ON in Preferences. I'm showing this to be the same for both Second Life and OpenSim.

Does this agree with other's observations?

TYPHAINE ARTEX: Yes, as replied on G+ :)  Those "material" settings needs adv. light. model to be applied to the rendering (as a few others things, like depth of depth, shadows, etc..).

From what I saw in the OpenSim code (I'm not an expert, I just have put a look in it), upstream developers prefer to avoid making things compiling for unsupported features (I saw the different values for Get/Set*PrimitiveParams added during the various commits).

As the Get part looked pretty simple (once you understand the underlaying logic of objects organization in the code), I thought of trying to code the Set part. using the viewer code as reference (to know where the hell material commands are received in the protocol) but as Ubit mentionned, it's not so simple, so I gave up (not enough time for that).

MY COMMENTS: Thanks Typhartez. I couldn't find anything in the documentation concerning the connection between advanced lighting and the "Glossiness" and "Environment" settings. It's nice to have confirmation - and thanks for your quick response and the additional information. I'll leave specularity turned off until the bug is fixed.


