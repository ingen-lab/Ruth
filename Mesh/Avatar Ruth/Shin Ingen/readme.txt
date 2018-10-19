Tweaks to the original Sundance Edit #15 (please note that the source of these mesh parts is the original Sundance Edit #15 and not the renamed Edit #16. I reverted Sundance commit hash fb1cd5ef334c7612db7eeca5d05f18f0a7bc23e2 and delete Edit #16 for it is not needed)


As part of the pre-release preparation the following steps were taken. The order in which they were done is important.

1. Re-established the lower body center seam line (UV Map only).

2. Removed dead node reference to mRightHip.

3. Removed node reference to L_UPPER_LEG & R_UPPER_LEG within the 3 node rings of the lower body. Some have weights that might pull the waist connection during animation.

4. Removed cross vertex group reference define by the center seam. (lower body only)

5. Smoothing of vertex weights of the lower body mesh around the inner thighs to remove some rough spots when animating.

6. Joined upper and lower body and removed double nodes along the waist connection. This will ensure that the upper and lower body connection node rings will have exactly the same vertex weight after separation.

7. Removed all unused vertex group for each part.

8. Remove asymmetries of the upper body, lower body and flat feet meshes. The remaining mesh parts are symmetical.

9. Re-snapped all connecting parts using the following method to ensure that the lower and upper body symmetries are maintained. 
	- all feet type to lower body.
	- lower body to upper body.
	- upper body to mesh bento head.
	- bento hands to upper body.

10. No test DAE included pending final in-world testing.

