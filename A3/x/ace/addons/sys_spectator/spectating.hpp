//
// Spectating Script for Armed Assault
// by Kegetys <kegetys [ät] dnainternet.net>
//

#include "common.hpp"

#define BORDERSIZE		0.06
#define BORDERXSIZE		0.015
#define CMENUWIDTH		0.19	// Camera menu width
#define TMENUWIDTH		0.200 // Target menu width
#define MENUHEIGHT		0.30
#define MAPWIDTH		0.3
#define MAPHEIGHT		0.30
#define MAPTXTSIZE		0.02
#define ELOGWIDTH		0.900
//#define ELOGHEIGHT	0.1525
#define ELOGHEIGHT		0.0

#define IDC_MAIN		55001
#define IDC_CAMERA		55002
#define IDC_TARGET		55003
#define IDC_NAME		55004
#define IDC_MENUCAM		55005
#define IDC_MENUTGT		55006
#define IDC_MENUCAMB	55007
#define IDC_MENUTGTB	55008
#define IDC_BG1			55009
#define IDC_BG2			55010
#define IDC_TITLE		55011
#define IDC_HELP		55012
#define IDC_MAP			55013
#define IDC_MAPFULL		55014
#define IDC_MAPFULLBG	55015
//#define IDC_EVENTLOG	50016
#define IDC_DEBUG		55100

#define IDC_BIRDMAP		50017

#define IDC_RESPBUT1	50018
#define IDC_RESPBUT2	50019
#define IDC_RESPBUT3	50020
#define IDC_RESPBUT4	50021
#define IDC_LIFETIME	50022
#define IDC_COMPASS		50023

#define COL_ORANGE		{1, 0.5, 0, 1}
#define COL_GRAY		{0.2, 0.2, 0.2, 1}

class ACE_rscSpectate {
	idd = IDC_MAIN;
	movingEnable = false;

	class controls {
		class mouseHandler: ACE_KEGsRscControlsGroup {
			class ScrollBar {
				color[] = {1,1,1,0.6};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
				arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
				arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
				border = "\ca\ui\data\ui_border_scroll_ca.paa";
			};
			onMouseMoving = "[""MouseMoving"",_this] call ace_sys_spectator_fnc_spectate_events";
			onMouseButtonDown = "[""MouseButtonDown"",_this] call ace_sys_spectator_fnc_spectate_events";
			onMouseButtonUp = "[""MouseButtonUp"",_this] call ace_sys_spectator_fnc_spectate_events";
			onMouseZChanged = "[""MouseZChanged"",_this] call ace_sys_spectator_fnc_spectate_events";
			idc = 123;
			x = SafeZoneX; y = SafeZoneY;
			w = SafeZoneW; h = SafeZoneH;
			colorBackground[] = {0.2, 0.0, 0.0, 0.0};
		};
		// Borders and title text
		class BackgroundTop: ACE_KEGsRscText {
			idc = IDC_BG1;
			x = SafeZoneX; y = SafeZoneY;
			w = SafeZoneW; h = BORDERSIZE;
			colorBackground[] = {0.0, 0.0, 0.0, 1.0};
		};
		class BackgroundBottom: BackgroundTop {
			idc = IDC_BG2;
			y = SafeZoneY + SafeZoneH-BORDERSIZE;
		};
		class title : BackgroundTop {
			idc = IDC_TITLE;
			colorBackground[] = {0.0, 0.0, 0.0, 0.0};
			text = "SPECTATING";
			style = 2;
			sizeEx = 0.035;
			colorText[] = {1.0, 0.0, 0.0, 1.0};
			shadow = true;
			y = SafeZoneY;
			h = BORDERSIZE;
			font = "TahomaB";
		};

		// Camera menu
		class menuCameras : ACE_KEGsRscText {
			idc = IDC_MENUCAMB;
			style = ST_HUD_BACKGROUND;
			x = SafeZoneX + BORDERXSIZE;	y = SafeZoneY + BORDERSIZE;
			w = CMENUWIDTH;		h = MENUHEIGHT;
			text = "";
			colorBackground[] = {0, 0, 0, 0.7};
		};
		class menuCamerasLB : ACE_KEGsRscListBox {
			class ScrollBar {
				color[] = {1,1,1,0.6};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
				arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
				arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
				border = "\ca\ui\data\ui_border_scroll_ca.paa";
			};
			onLBSelChanged = "_this call ace_sys_spectator_fnc_menucamslbchange";
			autoScrollRewind=0;
			autoScrollDelay=5;
			autoScrollSpeed=-1;
			maxHistoryDelay=1;
			idc = IDC_MENUCAM;
			x = SafeZoneX + BORDERXSIZE;	y = SafeZoneY + BORDERSIZE;
			w = CMENUWIDTH;		h = MENUHEIGHT;
			colorSelect[] = COL_ORANGE;
			colorSelect2[] = COL_ORANGE;
			colorSelectBackground[] = COL_GRAY;
			colorSelectBackground2[] = COL_GRAY;
			sizeEx = 0.025;
		};

		// Targets menu
		class menuTargets : ACE_KEGsRscText {
			idc = IDC_MENUTGTB;
			style = ST_HUD_BACKGROUND;
			x = SafeZoneX + SafeZoneW-BORDERXSIZE-TMENUWIDTH;
			y = SafeZoneY + BORDERSIZE;
			w = TMENUWIDTH;	h = MENUHEIGHT;
			text = "";
			colorBackground[] = {0, 0, 0, 0.7};
		};
		class menuTargetsLB : ACE_KEGsRscListBox {
			class ScrollBar {
				color[] = {1,1,1,0.6};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
				arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
				arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
				border = "\ca\ui\data\ui_border_scroll_ca.paa";
			};
			autoScrollRewind=0;
			autoScrollDelay=5;
			autoScrollSpeed=-1;
			maxHistoryDelay=1;
			idc = IDC_MENUTGT;
			x = SafeZoneX + SafeZoneW-BORDERXSIZE-TMENUWIDTH;
			y = SafeZoneY + BORDERSIZE;
			w = TMENUWIDTH;	h = MENUHEIGHT;
			colorSelect[] = COL_ORANGE;
			colorSelect2[] = COL_ORANGE;
			colorSelectBackground[] = COL_GRAY;
			colorSelectBackground2[] = COL_GRAY;
			colorScrollbar[] = COL_ORANGE;
			colorText[] = {1, 1, 1, 1};
			sizeEx = 0.025;
			period = 0;
		};

		// Top texts
		class tCamera : ACE_KEGsRscActiveText {
			idc = IDC_CAMERA;
			x = SafeZoneX + BORDERXSIZE; y = SafeZoneY;	w = SafeZoneW-(2*BORDERXSIZE); h = BORDERSIZE;
			text = "$STR_ACE_SPECT_DCAM";
			style = 0;
			sizeEx = 0.025;
			color[] = {1.0, 1.0, 1.0, 0.9};
			shadow = true;
			font = "TahomaB";
			onMouseButtonUp = "[""ToggleCameraMenu"",0] call ace_sys_spectator_fnc_spectate_events";
		};
		class tTarget : tCamera {
			idc = IDC_TARGET;
			text = "$STR_ACE_SPECT_DTARGET";
			style = 1;
			onMouseButtonUp = "[""ToggleTargetMenu"",0] call ace_sys_spectator_fnc_spectate_events";
		};

		// Bottom texts
		class tName : ACE_KEGsRscText {
			idc = IDC_NAME;
			x = SafeZoneX + BORDERXSIZE;y = SafeZoneY + SafeZoneH-BORDERSIZE; w = SafeZoneW-(BORDERXSIZE); h = BORDERSIZE;
			text = "$STR_ACE_SPECT_UNKNOWN";
			style = 0;
			//sizeEx = 0.015; //0.030
			sizeEx = 0.023; //0.030
			colorText[] = {1.0, 1.0, 1.0, 0.9};
			font = "TahomaB";
		};

		// Help text
		class tHelp : ACE_KEGsRscText {
			type = 13;
			idc = IDC_HELP;
			x = SafeZoneX + BORDERXSIZE*3;y=SafeZoneY + BORDERSIZE*3; w = SafeZoneW-(2*BORDERXSIZE*3); h = SafeZoneH-(2*BORDERSIZE*2);
			text = "";
			style = 2;
			sizeEx = 0.025;
			size = 0.025;
			colorText[] = {1.0, 1.0, 1.0, 1.0};
			color[] = {0.0, 0.0, 0.0, 1.0};
			font = "LucidaConsoleB";
			class Attributes{
				font = "TahomaB";
				color = "#ffffff";
				align = "left";
				shadow = true;
			};
		};

		// Debug text
		class tDebug : tCamera {
			idc = IDC_DEBUG;
			text = "";
			style = 2;
			x = SafeZoneX; y = SafeZoneY;
			w = SafeZoneW; h = SafeZoneH;
			action ="";
		};

		// Map
		class map : ACE_KEGsRscMapControl {
			colorOutside[] = {0,0,0,1};
			colorRailWay[] = {0,0,0,1};
			maxSatelliteAlpha = 0;
			alphaFadeStartScale = 1;
			alphaFadeEndScale = 1.1;
			class Task : Task {
				icon = "\ca\ui\data\map_waypoint_ca.paa";
				size = 20;
				color[] = {0,0.9,0,1};
				importance = "1.2 * 16 * 0.05";
				coefMin = 0.9;
				coefMax = 4;
			};
			class CustomMark : CustomMark {
				icon = "\ca\ui\data\map_waypoint_ca.paa";
				color[] = {0,0,1,1};
				size = 18;
				importance = 1;
				coefMin = 1;
				coefMax = 1;
			};
			idc = IDC_MAP;
			x = SafeZoneX + SafeZoneW-MAPWIDTH; y = SafeZoneY + SafeZoneH-MAPHEIGHT;
			w = MAPWIDTH; h = MAPHEIGHT;
			colorBackground[] = {0.7, 0.7, 0.7, 0.75};
			//sizeEx = 0.02;
			sizeExLabel = MAPTXTSIZE;
			sizeExGrid = MAPTXTSIZE;
			sizeExUnits = MAPTXTSIZE;
			sizeExNames = MAPTXTSIZE;
			sizeExInfo = MAPTXTSIZE;
			sizeExLevel = MAPTXTSIZE;
			showCountourInterval = "false";

			onMouseZChanged = "[""MouseZChangedminimap"",_this] call ace_sys_spectator_fnc_spectate_events";

			class Command : Command {
				icon = "#(argb,8,8,3)color(1,1,1,1)";
				color[] = {0, 0, 0, 1};
				size = 18;
				importance = 1;
				coefMin = 1;
				coefMax = 1;
			};

			class ActiveMarker : ActiveMarker {
				color[] = {0.3, 0.1, 0.9, 1};
				size = 50;
			};
		};
		
		class dummy_map : ACE_SP_Dummy_Map {
			x = -10;y = -10;w = 0;h = 0;
			onDraw = "call ace_sys_spectator_fnc_onmapdraw";
		};

		// Fullscreen map
		class mapFullBG : BackgroundTop {
			idc = IDC_MAPFULLBG;
			x = SafeZoneX;y=SafeZoneY;
			w = SafeZoneW;h=SafeZoneH;
			colorBackground[] = {0.0, 0.0, 0.0, 1.0};
		};
		class mapFull : map {
			colorOutside[] = {0,0,0,1};
			colorRailWay[] = {0,0,0,1};
			maxSatelliteAlpha = 0;
			alphaFadeStartScale = 1;
			alphaFadeEndScale = 1.1;
			showCountourInterval = "true";
			idc = IDC_MAPFULL;
			x = SafeZoneX;y=SafeZoneY + BORDERSIZE;
			w = SafeZoneW;h=SafeZoneH-(BORDERSIZE*2);
			colorBackground[] = {0.85, 0.85, 0.85, 1.0};
		};
		class RespButton1 {
			idc = IDC_RESPBUT1;
			type = 16;
			style = 0;
			text = "Respawn 1";
			action = "[] spawn ace_sys_spectator_fnc_rbutton1";
			//x = 0.77;
			x = SafeZoneX + 10.77;
			y = SafeZoneY + 0.42;
			w = 0.23;
			h = 0.104575;
			size = 0.03921;
			sizeEx = 0.03921;
			//color[] = {0.543, 0.5742, 0.4102, 1.0};
			color[] = {0.543, 0.5742, 0.4102, 0.7};
			//color2[] = {0.95, 0.95, 0.95, 1};
			color2[] = {0.95, 0.95, 0.95, 0.7};
			//colorBackground[] = {1, 1, 1, 1};
			colorBackground[] = {1, 1, 1, 0.7};
			colorbackground2[] = {1, 1, 1, 0.4};
			colorDisabled[] = {1, 1, 1, 0.25};
			colorFocused[] = { 1, 1, 1, 1 }; 
			colorBackgroundFocused[] = { 1, 1, 1, 0 };  
			periodFocus = 1.2;
			periodOver = 0.8;
			class HitZone {
				left = 0.004;
				top = 0.029;
				right = 0.004;
				bottom = 0.029;
			};
			class ShortcutPos {
				left = 0.0145;
				top = 0.026;
				w = 0.0392157;
				h = 0.0522876;
			};
			class TextPos {
				left = 0.05;
				top = 0.034;
				right = 0.005;
				bottom = 0.005;
			};
			textureNoShortcut = "";
			animTextureNormal = "\ca\ui\data\ui_button_normal_ca.paa";
			animTextureDisabled = "\ca\ui\data\ui_button_disabled_ca.paa";
			animTextureOver = "\ca\ui\data\ui_button_over_ca.paa";
			animTextureFocused = "\ca\ui\data\ui_button_focus_ca.paa";
			animTexturePressed = "\ca\ui\data\ui_button_down_ca.paa";
			animTextureDefault = "\ca\ui\data\ui_button_default_ca.paa";
			period = 0.4;
			font = "TahomaB";
			soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.09, 1};
			soundPush[] = {"\ca\ui\data\sound\new1", 0.09, 1};
			soundClick[] = {"\ca\ui\data\sound\mouse3", 0.07, 1};
			soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.09, 1};
			class Attributes {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
			class AttributesImage {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
		};
		class RespButton2 {
			idc = IDC_RESPBUT2;
			type = 16;
			style = 0;
			text = "Respawn 2";
			action = "[] spawn ace_sys_spectator_fnc_rbutton2";
			//x = 0.77;
			x = SafeZoneX + 10.77;
			y = SafeZoneY + 0.48;
			w = 0.23;
			h = 0.104575;
			size = 0.03921;
			sizeEx = 0.03921;
			//color[] = {0.543, 0.5742, 0.4102, 1.0};
			color[] = {0.543, 0.5742, 0.4102, 0.7};
			//color2[] = {0.95, 0.95, 0.95, 1};
			color2[] = {0.95, 0.95, 0.95, 0.7};
			//colorBackground[] = {1, 1, 1, 1};
			colorBackground[] = {1, 1, 1, 0.7};
			colorbackground2[] = {1, 1, 1, 0.4};
			colorDisabled[] = {1, 1, 1, 0.25};
			colorFocused[] = { 1, 1, 1, 1 }; 
			colorBackgroundFocused[] = { 1, 1, 1, 0 };  
			periodFocus = 1.2;
			periodOver = 0.8;
			class HitZone {
				left = 0.004;
				top = 0.029;
				right = 0.004;
				bottom = 0.029;
			};
			class ShortcutPos {
				left = 0.0145;
				top = 0.026;
				w = 0.0392157;
				h = 0.0522876;
			};
			class TextPos {
				left = 0.05;
				top = 0.034;
				right = 0.005;
				bottom = 0.005;
			};
			textureNoShortcut = "";
			animTextureNormal = "\ca\ui\data\ui_button_normal_ca.paa";
			animTextureDisabled = "\ca\ui\data\ui_button_disabled_ca.paa";
			animTextureOver = "\ca\ui\data\ui_button_over_ca.paa";
			animTextureFocused = "\ca\ui\data\ui_button_focus_ca.paa";
			animTexturePressed = "\ca\ui\data\ui_button_down_ca.paa";
			animTextureDefault = "\ca\ui\data\ui_button_default_ca.paa";
			period = 0.4;
			font = "TahomaB";
			soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.09, 1};
			soundPush[] = {"\ca\ui\data\sound\new1", 0.09, 1};
			soundClick[] = {"\ca\ui\data\sound\mouse3", 0.07, 1};
			soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.09, 1};
			class Attributes {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
			class AttributesImage {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
		};
		class RespButton3 {
			idc = IDC_RESPBUT3;
			type = 16;
			style = 0;
			text = "Respawn 3";
			action = "[] spawn ace_sys_spectator_fnc_rbutton3";
			//x = 0.77;
			x = SafeZoneX + 10.77;
			y = SafeZoneY + 0.54;
			w = 0.23;
			h = 0.104575;
			size = 0.03921;
			sizeEx = 0.03921;
			//color[] = {0.543, 0.5742, 0.4102, 1.0};
			color[] = {0.543, 0.5742, 0.4102, 0.7};
			//color2[] = {0.95, 0.95, 0.95, 1};
			color2[] = {0.95, 0.95, 0.95, 0.7};
			//colorBackground[] = {1, 1, 1, 1};
			colorBackground[] = {1, 1, 1, 0.7};
			colorbackground2[] = {1, 1, 1, 0.4};
			colorDisabled[] = {1, 1, 1, 0.25};
			colorFocused[] = { 1, 1, 1, 1 }; 
			colorBackgroundFocused[] = { 1, 1, 1, 0 };  
			periodFocus = 1.2;
			periodOver = 0.8;
			class HitZone {
				left = 0.004;
				top = 0.029;
				right = 0.004;
				bottom = 0.029;
			};
			class ShortcutPos {
				left = 0.0145;
				top = 0.026;
				w = 0.0392157;
				h = 0.0522876;
			};
			class TextPos {
				left = 0.05;
				top = 0.034;
				right = 0.005;
				bottom = 0.005;
			};
			textureNoShortcut = "";
			animTextureNormal = "\ca\ui\data\ui_button_normal_ca.paa";
			animTextureDisabled = "\ca\ui\data\ui_button_disabled_ca.paa";
			animTextureOver = "\ca\ui\data\ui_button_over_ca.paa";
			animTextureFocused = "\ca\ui\data\ui_button_focus_ca.paa";
			animTexturePressed = "\ca\ui\data\ui_button_down_ca.paa";
			animTextureDefault = "\ca\ui\data\ui_button_default_ca.paa";
			period = 0.4;
			font = "TahomaB";
			soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.09, 1};
			soundPush[] = {"\ca\ui\data\sound\new1", 0.09, 1};
			soundClick[] = {"\ca\ui\data\sound\mouse3", 0.07, 1};
			soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.09, 1};
			class Attributes {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
			class AttributesImage {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
		};
		class RespButton4 {
			idc = IDC_RESPBUT4;
			type = 16;
			style = 0;
			text = "Respawn 4";
			action = "[] spawn ace_sys_spectator_fnc_rbutton4";
			//x = 0.77;
			x = SafeZoneX + 10.77;
			y = SafeZoneY + 0.6;
			w = 0.23;
			h = 0.104575;
			size = 0.03921;
			sizeEx = 0.03921;
			//color[] = {0.543, 0.5742, 0.4102, 1.0};
			color[] = {0.543, 0.5742, 0.4102, 0.7};
			//color2[] = {0.95, 0.95, 0.95, 1};
			color2[] = {0.95, 0.95, 0.95, 0.7};
			//colorBackground[] = {1, 1, 1, 1};
			colorBackground[] = {1, 1, 1, 0.7};
			colorbackground2[] = {1, 1, 1, 0.4};
			colorDisabled[] = {1, 1, 1, 0.25};
			colorFocused[] = { 1, 1, 1, 1 }; 
			colorBackgroundFocused[] = { 1, 1, 1, 0 };  
			periodFocus = 1.2;
			periodOver = 0.8;
			class HitZone {
				left = 0.004;
				top = 0.029;
				right = 0.004;
				bottom = 0.029;
			};
			class ShortcutPos {
				left = 0.0145;
				top = 0.026;
				w = 0.0392157;
				h = 0.0522876;
			};
			class TextPos {
				left = 0.05;
				top = 0.034;
				right = 0.005;
				bottom = 0.005;
			};
			textureNoShortcut = "";
			animTextureNormal = "\ca\ui\data\ui_button_normal_ca.paa";
			animTextureDisabled = "\ca\ui\data\ui_button_disabled_ca.paa";
			animTextureOver = "\ca\ui\data\ui_button_over_ca.paa";
			animTextureFocused = "\ca\ui\data\ui_button_focus_ca.paa";
			animTexturePressed = "\ca\ui\data\ui_button_down_ca.paa";
			animTextureDefault = "\ca\ui\data\ui_button_default_ca.paa";
			period = 0.4;
			font = "TahomaB";
			soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.09, 1};
			soundPush[] = {"\ca\ui\data\sound\new1", 0.09, 1};
			soundClick[] = {"\ca\ui\data\sound\mouse3", 0.07, 1};
			soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.09, 1};
			class Attributes {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
			class AttributesImage {
				font = "TahomaB";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
		};
		class lifeTime : ACE_KEGsRscText {
			idc = IDC_LIFETIME;
			x = SafeZoneX + BORDERXSIZE + 0.425;y=SafeZoneY + SafeZoneH-BORDERSIZE; w = 0.3;h = BORDERSIZE;
			text = "";
			style = 0;
			//sizeEx = 0.015; //0.030
			sizeEx = 0.023; //0.030
			colorText[] = {1.0, 1.0, 1.0, 0.9};
			font = "TahomaB";
		};
		class compass : ACE_KEGsRscText {
			idc = IDC_COMPASS;
			x = SafeZoneX + SafeZoneW - MAPWIDTH - 0.1;y=SafeZoneY + SafeZoneH-BORDERSIZE; w = 0.1;h = BORDERSIZE;
			text = "";
			style = 0;
			//sizeEx = 0.015; //0.030
			sizeEx = 0.023; //0.030
			colorText[] = {1.0, 1.0, 1.0, 0.9};
			font = "TahomaB";
		};
	};
};

class ACE_rscSpectateBirdMap {
	idd = IDC_BIRDMAP;
	movingEnable = false;

	class controls {
		class map : ACE_KEGsRscMapControl {
			colorOutside[] = {0,0,0,1};
			colorRailWay[] = {0,0,0,1};
			maxSatelliteAlpha = 0;
			alphaFadeStartScale = 1;
			alphaFadeEndScale = 1.1;
			class Task : Task {
				icon = "\ca\ui\data\map_waypoint_ca.paa";
				size = 20;
				color[] = {0,0.9,0,1};
				importance = "1.2 * 16 * 0.05";
				coefMin = 0.9;
				coefMax = 4;
			};
			class CustomMark : CustomMark {
				icon = "\ca\ui\data\map_waypoint_ca.paa";
				color[] = {0,0,1,1};
				size = 18;
				importance = 1;
				coefMin = 1;
				coefMax = 1;
			};
			idc = IDC_MAP;
			x = SafeZoneX + SafeZoneW-MAPWIDTH; y = SafeZoneY + SafeZoneH-MAPHEIGHT;
			w = MAPWIDTH; h = MAPHEIGHT;
			colorBackground[] = {0.7, 0.7, 0.7, 0.75};
			//sizeEx = 0.02;
			sizeExLabel = MAPTXTSIZE;
			sizeExGrid = MAPTXTSIZE;
			sizeExUnits = MAPTXTSIZE;
			sizeExNames = MAPTXTSIZE;
			sizeExInfo = MAPTXTSIZE;
			sizeExLevel = MAPTXTSIZE;
			showCountourInterval = "false";

			class Command : Command {
				icon = "#(argb,8,8,3)color(1,1,1,1)";
				color[] = {0, 0, 0, 1};
				size = 18;
				importance = 1;
				coefMin = 1;
				coefMax = 1;
			};
			class ActiveMarker : ActiveMarker {
				color[] = {0.3, 0.1, 0.9, 1};
				size = 50;
			};
		};
		class BackgroundTop: ACE_KEGsRscText {
			idc = IDC_BG1;
			x = SafeZoneX; y = SafeZoneY;
			w = SafeZoneW; h = BORDERSIZE+1;
			colorBackground[] = {0.0, 0.0, 0.0, 1.0};
		};
		// Fullscreen map
		class mapFullBG : BackgroundTop {
			idc = IDC_MAPFULLBG;
			x = SafeZoneX;y= SafeZoneY;
			w = SafeZoneW;h= SafeZoneH;
			colorBackground[] = {0.0, 0.0, 0.0, 1.0};
		};
		class mapFull : map {
			colorOutside[] = {0,0,0,1};
			colorRailWay[] = {0,0,0,1};
			maxSatelliteAlpha = 0;
			alphaFadeStartScale = 1;
			alphaFadeEndScale = 1.1;
			showCountourInterval = "true";
			idc = IDC_MAPFULL;
			x = SafeZoneX;y=SafeZoneY + BORDERSIZE;
			w = SafeZoneW;h=SafeZoneH-(BORDERSIZE*2);
			colorBackground[] = {0.85, 0.85, 0.85, 1.0};
		};
	};
};
