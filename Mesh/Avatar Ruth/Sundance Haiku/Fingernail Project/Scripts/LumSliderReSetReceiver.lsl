//Re-set LumSlider
//Every so often in testing, I found that the Lum Slider would change the vertical offset
//Upon examining the offset Edit >> Texture >> Vertical Offset, it would show the normal 1
//I found that by manually offsetting to some other setting and then going back to 1, it
//  would fix itself.  Because I that I wrote in this re-set routine.



//Global Variables
integer gnChannel;
integer appID = 20171105;
integer keyapp2chan() 
{
    return 0sx80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}



default
{
    state_entry()
    {
        gnChannel = keyapp2chan();
        llListen(gnChannel, "", "", "");
    }
    
    listen(integer Channel, string Name, key ID, string Msg)
    {     
        llOwnerSay("message received");
        if (Msg == "Re-set")
        {
           
           llOffsetTexture( 1, .5, -1);
           llOffsetTexture( 1, 1, -1);           
        }        
    }
}
