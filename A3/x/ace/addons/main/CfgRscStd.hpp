#include "script_dialog_defines.hpp"

class RscStandardDisplay;
class RscText;
class RscPicture;
class RscActiveText;
class RscStructuredText;
class RscEdit;
class RscButton_small;
class RscShortcutButton;
class RscButtonTextOnly;

/*
ACE version moved to CBA shared
About removed from main menu, still on pause menus, but will be moved to ACE_settings dialog
About button currently has other buttons tied to it, so do not move until the About dialog is improved.
*/

class ACE_ABOUT_CTRL: RscActiveText {
	idc = -1;
	style = ST_CENTER + ST_DOWN + ST_SHADOW;
	__SX(0.025);
	__SY(0.92);
	__SW(0.04);
	__SH(0.02);
	sizeEx = "0.025 * SafeZoneH";
	color[] = {0.8784,0.8471,0.651,1};
	colorActive[] = {0.543,0.5742,0.4102,1};
	text = "About";
	onButtonClick = "";
};
class ACE_ABOUT_NEXT: ACE_ABOUT_CTRL { //invisible
	idc = -1; //must be -1
	style = ST_PICTURE;
	__SX(0.065);
	__SW(0.03);
	text = "x\ace\addons\main\data\clear.paa";
	onButtonClick = "ACE_ABOUT_INC = 1;";
};


