UPDATE October 15, 2018 . . .

I have posted a Version 15 Blender file.  I’ve also posted associated DAE files for all of the various body parts that you can bring directly in-world.  The file is named: Release3_AdaEdit_SundanceEdit_15.blend and is found in following GitHub directory: Ruth/Mesh/Avatar Ruth/Sundance Haiku/RC3_Edits/RC3_Final/

There were a number of problems with the previous version, and I hope I can redeem myself a little with this update.  I’m sure there will be parts that need tweaking or changing, but this is much more of a finished product.  This fixes the problems that Shin found with weighting in the buttocks area and it adds a number of improvements.

Primarily my purpose last spring when I began work on this area of the Ruth project was to spend a little time on the UV maps of the feet and legs.  That little time turned into, well, a lot of time.  As the process went on, weighting problems crept in.  In this last version - and I promise, this is the last version - I believe I been able to remedy most of those problems.

Here’s the beta:

- The UV maps for the feet (high & flat) and the lower body have been updated.  In the starting Blender file for RC3, there were a number of places where the UV’s didn’t line up between different body parts and those have been fixed.  The UV work was completed last spring and Version 15 includes all of those improvements.  I have previously posted illustrations showing where the changes were made on both Google+ and in GitHub.

- After Shin’s recent discovery of a weighting problem in the buttocks, I looked at the source file (Version 14), and realized that the vertex groups had been mixed up.  That has been fixed, and I have successfully transferred Ada’s fine weighting work to the lower body. 

- Using Creative’s weighting work (thank you Creative!), the high feet are now weighted correctly.  I did add a little twist to Creative’s work.  I moved weighting from the Deform bones to the Volume bones so that the high feet can be sized using the Appearance sliders.

- The flat feet have been re-weighted and for this I was largely guided by using Ada’s weighting.  Like the high feet, they can sized using the Appearance sliders.  (Last spring, Taarna had pointed out this area needed work and I greatly appreciated her gentle nudge that direction and suggestions)
 
- Ada’s animations which move the feet into 25mm, 50mm, 75mm, 100mm positions have been tested in-world and work with the above flat feet weighting.  The animation files are ready to be used in-world and are found in: Ruth/Mesh/Avatar Ruth/Sundance Haiku/RC3_Edits/High_Heel_Animations.

- The separately attachable high and flat toenails have been re-weighted so they automatically re-size as the feet are sized.  The weighting in the toenails has been improved and there’s now better coordination with movements of the feet.

That’s it.  I promised not to complicate things with any more versions.


UPDATED October 4, 2018 . . .

Shin reported finding double nodes in the lower UV map.  These were fixed in version 14 (Release3_AdaEdit_SundanceEdit_14.blend).  Nothing else was changed in version 14.  The text below references  version 13, but version 14 is the latest and includes all version 13 improvements.  In other words, subsitute version 14 whenever you see version 13 in the text.

UPDATED August 21, 2018 . . .

I have posted a new file (Version 13): Release3_AdaEdit_SundanceEdit_13.blend

Shin had found a problem with the leg UV's in the Version 11 file. Thanks, Shin, for bringing this to my attention.

I'm not sure what happened with the UV's in the Blender file that I posted. I must have click the wrong button somewhere during the transition to GitHub - or perhaps it occurred when I symmetrized the right and left legs. At any rate, I have posted a version 13 file ("Release3_AdaEdit_SundanceEdit_13.blend").  (Yep, there was a version 12 but sad to say, it wasn't quite ready for prime time.)  The version 13 file is found under the following directory: Mesh/SundanceHaiku/RC3_Edits/RC3_Final.  Along with the other images found in this directory, I posted an image of the version 13 leg UV's (LegUVs_Ver13.jpg).

I have revised and clarified some of the information below:

--------------

Here's the text of my Ruth Google Plus posting.  This should pretty well explain all changes . . .

If someone told me last year that I would spend my entire winter and spring dealing with fingernails and feet, I would have told them they are crazy.  But that’s exactly what I’ve done.  

I am happy to report that I’ve completed my work on the feet – and if anybody would like to do a bit more refining, you are very welcome.  In fact, I welcome that with open arms.

Shin, of course, will making the final decisions, but this is what I am passing on to him for Release 3. 

1. HIGH & FLAT FEET - UV MAPS.  The UV’s in both the high feet and flat feet have been improved.  I have documented what changes have been made in a series of images.  

On each of the images, you’ll see “before” and “after” versions of the UV’s.  Included also is an image of the standard SL avatar feet.  It represents the ideal that we were trying to duplicate.  The closer we can get the SL avatar feet, the better compatibility we get with skins (and clothing) that people have already created for the default system avatar.  

Particularly in the feet area, it is extremely difficult to achieve a perfect match with the default avatar.  I created 3 or 4 different versions over a several week period before settling on the final one.  Curious Creator also created another version.  When we compared each other’s UV maps, we both had about the same amount “stretch” in certain areas of the foot.  I’ve spent about 2 months working on the feet, and I could probably spend another 2 months, but enough is enough.  I am offering my version 13 of the feet in the GitHub as my final version.  (I’ve included information below on where to find version 11 in GitHub)

2. WEIGHTING FOR HIGH FEET.  I’m not particularly experienced in weighting and Creative came to my rescue.  She spent some time and re-did the weight mapping on the high feet.  She has posted a couple of videos here on Google Plus showing how her weighting solution works.  The high feet included in the version 13 final package incorporates her weighting of the high feet.  Thank you Creative!

One caveat.  The type of weighting that Creative used doesn’t allow one to change the size of the feet by using the avatar’s sliders (Fitted Mesh).  But that ability isn’t particularly important since Shin and Ada plan to eventually eliminate the high feet by using static poses with the flat foot.

3. WEIGHTING FOR FLAT FEET.  I’ll discus this in readme file in the High_Heels_Animations directory.

4. LOWER BODY (LEGS) – UV MAP.  I made several improvements in the UV map for the lower legs.  I also symmetrized the right and left sides of the lower body so that they were mirror images of one another.  (Creative also did this.)  Those changes are shown in the final illustration.

5. WHERE TO FIND VERSION 13 FILE.  You can find the final version of above changes in GitHub: Ruth/Mesh/Avatar Ruth/Sundance Haiku/RC3_Edits/RC3_Final/. The final version is found in this Blender file:  Release3_AdaEdit_SundanceEdit_13.blend.  

This file also includes some tweaks that I made to the fingernails and toenails.

6. ASSEMBLING.   Included in the directory, you’ll also find DAE files for all the body parts except the head.   The DAE files were included to make things easier for testers. You won’t have to worry about exporting from Blender.  It's been done.

7. NOTE ABOUT DAE FILES.  This version and the accompanying DAE files lack Alpha Cuts.  In other words, you would not be able to use the Alpha HUD to turn different body parts on or off.  The DAE files are included for in-world testing purposes.  Eventually When testing (and any additional tweaking) is complete, and when a final version is decided upon, Shin will make the necessary partitions and create the DAE file for the next release.

There is still some work that needs to be done on the flat feet – and that will be covered in readme file in the Mesh/SundanceHaiku/RC3_Edits/High_Heels_Animations directory.

