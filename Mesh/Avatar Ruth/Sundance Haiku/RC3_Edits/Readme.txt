Quick Start:

The file "Release3_AdaEdit_SundanceEdit_09.blend" has the latest updates for Release Candidate #3.  

(The other files are sequential stages in development and are included if, for some reason, data is needed from an earlier stage.)


Edits and Changes

Any changed in the Blender file has been indicated by the following two suffixes added to the name of the item (found on Blender’s “Outliner”): “SundanceUV_RC3” and “Sundance_RC3.”

“SundanceUV_RC3” – This suffix means I re-created or made changes in the UV map associated with the body part.  In two cases, I made some vertex weighting changes which are explained below.

“Sundance_RC3 – This designation was used for High and Flat Toenails.  The topology and UV maps stayed the same.  Location adjustments were made so that the toenails were properly positioned on the RC3 feet.  Also, vertex weighting was updated to match changes that have been made in the weighting of flat and high feet.


Specifically the following changes were made:


- Lower Body – UV map only.  No changes to topology.  No changes to weighting.  Most of the UV map was in good shape.  There were places here and there were the UV’s did not line up from one UV island to the other.  Most of those were found on the inside seam.  I made changes to correct the problem areas.  I also lessened some of the angles of adjoining UV’s so they wouldn’t be quite as pronounced when textures are applied. (See LegUVsCorrected.png for a visual view of corrections).


- Flat Foot – Major changes to UV map.  Minor adjustment in weighting.  No changes to topology. (See images of Back, Front, Inside & Outside Views.)  It was on the flat foot where I spent the bulk of my time.  I unwrapped and re-created the map several times trying to come up with the closest facsimile to the SL UV map.  

All of that work, somewhere around 30 hours, resulted in a series of compromises.  The final version of it in “Release3_AdaEdit_SundanceEdit_09.blend” is the best that I can come up with.  Ada might want to see if she can tweak it.  I’ll also throw it open to the group to see if anyone else wants to take a crack at it.

To supplement the Blender file, I have included a series of screen shots comparing my final edit of Ruth’s foot with the default avatar foot – both wearing Robin Wood’s UV template.  As one can see from the template, we are good as far as adjacent UV maps are concerned.  All of the UV’s from the foot line up with the UV’s of the lower leg, and the bottom of the foot (which is on a separate UV island) lines up with the upper foot.  The color bands as shown on Robin Wood’s UV templates are in the same approximate locations – and there is a general overall replication of the SL template.  

There is distortion, however.  The area with the most distortion (when compared with the SL map) is the inside of the ankle bone.  There is also an area of distortion on the outside of the ankle bone, though it is less than the inside.  That is confirmed by viewing the enclosed image (DistortionColorUV's.png) created in Blender which shows the level of distortion by colors – the warmer colors mean more distortion.   

I was able to reduce distortion a little by lowering several of the template's upper bands (which is done by moving UV’s up on the UV map).  However, moving them too much increases the upper distortion – so it becomes a trade off.  How much does one want to distort one area to remove distortion from another?  I have come up of one possible way of making these trade-offs, but other people may have alternative ways of accomplishing the task – and I certainly welcome anyone’s assistance who would like to create another version of the map.


- High Foot.  Some changes to High Foot UV map.  Considerable changes to Weighting.  No changes to topology.  I understand we may be eliminating the high foot.  Just in case we do end up retaining it, I did some work on the UV map.  Ada had it in good shape and most of my changes were fairly minor.  A couple of the UV’s on the inside of the foot didn’t line up with the lower leg UV map (see HighFeetUVShift.png).  Those were easily corrected.  I re-did the vertex weighting of the foot so that it more closely resembles the flat foot (which Ada has recently and very competently completed).


- Flat & High Toenails.  As mentioned above, changes to the toenails primarily involved positioning them for the RC#3 feet.  The vertex weighting was updated to match changes in weighting of the flat and high feet.
