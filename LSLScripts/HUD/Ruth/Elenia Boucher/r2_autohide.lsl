integer r2chan;
integer appID = 20171105;
integer keyapp2chan(){
    return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}


list lst_prim_name = [
    "pelvisback", "pelvisfront", "legright1", "legright2", "legright3",
    "legright4", "legright5", "legright6", "legright7", "legright8",
    "legleft1", "legleft2", "legleft3", "legleft4", "legleft5",
    "legleft6", "legleft7", "legleft8", "backlower", "backupper",
    "belly", "chest", "breastleft", "breastright", "armleft", "armright"
        ];

string hex2bool(string digit){//function to decode 1 hexadecimal digit in 4 bits
    integer val = (integer)("0x" + digit);
    string binary = (string)(val & 1);
    integer cnt = 0;
    for(val = ((val >> 1)); val; val = (val >> 1)){
        if (val & 1)
            binary = "1" + binary;
        else
            binary = "0" + binary;
        cnt++;
    }
    integer i;
    for(i=3; i > cnt; i--){
        binary = "0" + binary;
    }
    return binary;
}

default{
    state_entry(){
        r2chan = keyapp2chan();
    }

    attach(key id){
        if (id == llGetOwner()){
            string serial = llGetObjectDesc();
            if(llStringLength(serial) < 20) return;//TODO : a most serious control
            integer nbq = llStringLength(serial);
            integer numprimlst = 0;
            integer i;
            for(;i<nbq; i++){
                string bin = hex2bool(llGetSubString(serial, i, i));
                integer b = 0;
                integer r = i%2;
                for(; b < 4; b++){
                    string bit = llGetSubString(bin, -(b + 1), -(b + 1));//little endian : read right to left
                    integer face = b + (r * 4); //faces 0 to 7
                    if (bit == "0"){
                        llSay(r2chan, "ALPHA," + llList2String(lst_prim_name, numprimlst) + "," + (string)face + ",1");
                    }else{
                            llSay(r2chan, "ALPHA," + llList2String(lst_prim_name, numprimlst) + "," + (string)face + ",0");
                    }
                }
                numprimlst += r;//r=0 the first pass (face 0 to 3) and 1 the second pass -face 4 to 7). Then time to next prim
            }
        }else{

                llOwnerSay("TODO : append a script in body to reset alpha");
        }
    }
}
