//*********************************************************************************
//**   Copyright (C) 2017  Shin Ingen
//**
//**   This program is free software: you can redistribute it and/or modify
//**   it under the terms of the GNU Affero General Public License as
//**   published by the Free Software Foundation, either version 3 of the
//**   License, or (at your option) any later version.
//**
//**   This program is distributed in the hope that it will be useful,
//**   but WITHOUT ANY WARRANTY; without even the implied warranty of
//**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//**   GNU Affero General Public License for more details.
//**
//**   You should have received a copy of the GNU Affero General Public License
//**   along with this program.  If not, see <https://www.gnu.org/licenses/>
//*********************************************************************************

integer r2chan;
integer appID = 20171105;
integer keyapp2chan()
{
	return 0x80000000 | ((integer)("0x"+(string)llGetOwner()) ^ appID);
}
vector             alphaOnColor =     <0.000, 0.000, 0.000>;
vector            buttonOnColor =     <0.000, 1.000, 0.000>;
vector             offColor =         <1.000, 1.000, 1.000>;
list                commandButtonList =    [
	"chest::chest::30::-1",
	"breasts::breastleft::31::-1",
	"breasts::breastright::32::-1",
	"belly::belly::29::-1",
	"backupper::backupper::28::-1",
	"backlower::backlower::27::-1",
	"armsupper::armleft::33::0",
	"armsupper::armleft::33::1",
	"armsupper::armleft::33::2",
	"armsupper::armleft::33::3",
	"armsupper::armright::34::0",
	"armsupper::armright::34::1",
	"armsupper::armright::34::2",
	"armsupper::armright::34::3",
	"armslower::armleft::33::4",
	"armslower::armleft::33::5",
	"armslower::armleft::33::6",
	"armslower::armleft::33::7",
	"armslower::armright::34::4",
	"armslower::armright::34::5",
	"armslower::armright::34::6",
	"armslower::armright::34::7",
	"armsfull::armleft::33::-1",
	"armsfull::armright::34::-1",
	"butt::pelvisback::9::5",
	"crotch::pelvisfront::10::5",
	"crotch::pelvisfront::10::6",
	"pelvis::pelvisback::9::-1",
	"pelvis::pelvisfront::10::-1",
	"legsupper::legright1::11::-1",
	"legsupper::legright2::12::-1",
	"legsupper::legright3::13::-1",
	"legsupper::legleft1::19::-1",
	"legsupper::legleft2::20::-1",
	"legsupper::legleft3::21::-1",
	"knees::legright4::14::-1",
	"knees::legright5::15::-1",
	"knees::legleft4::22::-1",
	"knees::legleft5::23::-1",
	"legslower::legright6::16::-1",
	"legslower::legright7::17::-1",
	"legslower::legright8::18::-1",
	"legslower::legleft6::24::-1",
	"legslower::legleft7::25::-1",
	"legslower::legleft8::26::-1",
	"legsfull::legright1::11::-1",
	"legsfull::legright2::12::-1",
	"legsfull::legright3::13::-1",
	"legsfull::legright4::14::-1",
	"legsfull::legright5::15::-1",
	"legsfull::legright6::16::-1",
	"legsfull::legright7::17::-1",
	"legsfull::legright8::18::-1",
	"legsfull::legleft1::19::-1",
	"legsfull::legleft2::20::-1",
	"legsfull::legleft3::21::-1",
	"legsfull::legleft4::22::-1",
	"legsfull::legleft5::23::-1",
	"legsfull::legleft6::24::-1",
	"legsfull::legleft7::25::-1",
	"legsfull::legleft8::26::-1"
		];
resetallalpha()
{
	integer i;
	integer x = llGetNumberOfPrims()+1;

	for (; i < x; ++i)
	{
		llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, -1, offColor, 1.0]);
		if(i>=9)
		{
			list paramList = llGetLinkPrimitiveParams(i,[PRIM_NAME]);
			string primName = llList2String(paramList,0);
			string message = "ALPHA," + (string)primName + "," + "-1" + "," + "1";
			llSay(r2chan,message);
		}
	}
	//llSay(0,"A reset all alpha event was raised.");
}

colorDoll(string commandFilter, integer alphaVal)
{
	integer i;
	integer x = llGetListLength(commandButtonList)+1;
	for (; i < x; ++i)
	{
		string dataString = llList2String(commandButtonList,i);
		list stringList = llParseString2List(dataString, ["::"], []);
		string command = llList2String(stringList,0);
		string primName = llList2String(stringList,1);
		integer primLink = llList2Integer(stringList,2);
		integer primFace = llList2Integer(stringList,3);
		string message = "ALPHA," + (string)primName + "," + (string)primFace + "," + (string)alphaVal;

		if (command == commandFilter)
		{
			if (alphaVal == 0)
			{
				llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, primFace, alphaOnColor, 1.0]);
				llSay(r2chan,message);
			}
			else
			{
				llSetLinkPrimitiveParamsFast(primLink, [PRIM_COLOR, primFace, offColor, 1.0]);
				llSay(r2chan,message);
			}
		}
	}
	//llSay(0,"ColorDoll event for:" + commandFilter + ":" + alphaVal + " was raised.");
}

default
{
	state_entry()
	{
		r2chan = keyapp2chan();
	}

	on_rez(integer param)
	{
		llResetScript();
	}

	touch_start(integer total_number)
	{
		integer link = llDetectedLinkNumber(0);
		integer face = llDetectedTouchFace(0);

		if(link == 1)
		{
			if(face == 1||face == 3||face == 5||face == 7)
			{
				rotation localRot = llList2Rot(llGetLinkPrimitiveParams(link,[PRIM_ROT_LOCAL]),0);
				llSetLinkPrimitiveParamsFast(link,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,PI/2>)*localRot]);
			}
			else
			{
				rotation localRot = llList2Rot(llGetLinkPrimitiveParams(link,[PRIM_ROT_LOCAL]),0);
				llSetLinkPrimitiveParamsFast(link,[PRIM_ROT_LOCAL,llEuler2Rot(<0.0,0.0,-PI/2>)*localRot]);
			}
		}
		else if(link == 5 || link == 8)
		{
			list buttonList = [
				"reset",
				"chest",
				"breasts",
				"belly",
				"backupper",
				"backlower",
				"armsupper",
				"armslower"
					];
			if(face == 0)
			{
				resetallalpha();
			}
			else
			{
				string commandButton = llList2String(buttonList,face);
				list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
				string primName = llList2String(paramList,0);
				vector primColor = llList2Vector(paramList,1);
				integer alphaVal;
				if (primColor == offColor)
				{
					alphaVal=0;
					llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, face, buttonOnColor, 1.0]);
					llSetLinkPrimitiveParamsFast(8, [PRIM_COLOR, face, buttonOnColor, 1.0]);
				}
				else
				{
					alphaVal=1;
					llSetLinkPrimitiveParamsFast(5, [PRIM_COLOR, face, offColor, 1.0]);
					llSetLinkPrimitiveParamsFast(8, [PRIM_COLOR, face, offColor, 1.0]);
				}
				colorDoll(commandButton,alphaVal);
				//llSay(0,"Link:" + (string)link + " Button:" + commandButton);
			}
		}
		else if(link == 4 || link == 7)
		{
			list buttonList = [
				"armsfull",
				"butt",
				"crotch",
				"pelvis",
				"legsupper",
				"knees",
				"legslower",
				"legsfull"
					];
			string commandButton = llList2String(buttonList,face);
			list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
			string primName = llList2String(paramList,0);
			vector primColor = llList2Vector(paramList,1);
			integer alphaVal;

			if (primColor == offColor)
			{
				alphaVal=0;
				llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, face, buttonOnColor, 1.0]);
				llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, face, buttonOnColor, 1.0]);
			}
			else
			{
				alphaVal=1;
				llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, face, offColor, 1.0]);
				llSetLinkPrimitiveParamsFast(7, [PRIM_COLOR, face, offColor, 1.0]);
			}

			colorDoll(commandButton,alphaVal);
			//llSay(0,"Link:" + (string)link + " Button:" + commandButton);
		}
		else if(link == 3 || link == 6)
		{
			list buttonList = [
				"savealpha",
				"loadalpha"
					];
			string commandButton = llList2String(buttonList,face);
			llSay(0,"Not Yet Implemented!");
		}
		else if(link == 2)
		{
			//ignore click on backboard
		}
		else
		{
			list paramList = llGetLinkPrimitiveParams(link,[PRIM_NAME,PRIM_COLOR,face]);
			string primName = llList2String(paramList,0);
			vector primColor = llList2Vector(paramList,1);
			integer alphaVal;

			if (primColor == offColor)
			{
				alphaVal=0;
				llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, alphaOnColor, 1.0]);
			}
			else
			{
				alphaVal=1;
				llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, offColor, 1.0]);
			}

			string message = "ALPHA," + (string)primName + "," + (string)face + "," + (string)alphaVal;
			llSay(r2chan,message);
			//llSay(0,"Link:" + (string)link + " Bodypart:" + primName + " Face:" + (string)face + " Alpha Value:" + (string)alphaVal);
		}
	}
}