class RscTitles {
	class ACE_Wound_Revivetime {
		idd = 585306;
		movingEnable = true;
		fadein = 0;
		fadeout = 0;
		duration = 1e+011;
		name = "ACE_Wound_Revivetime";
		controls[] = {"ACE_Wound_TextStr"};
		onload = "with uiNamespace do {ACE_Wound_Revivetime = _this select 0}";

		class ACE_Wound_TextStr {
			type = 0;
			idc = 1234567;
			style = 0;
			x = 0.25;
			y = 0.725;
			w = 0.6;
			h = 0.2;
			font = "PuristaMedium";
			sizeEx = 0.06;
			colorText[] = {1.0, 1.0, 1.0, 0.9};
			colorBackground[] = {0,0,0,0.0};
			text = "";
		};
	};

	class ACE_Wound_Bleeding1 {
		idd = 585301;
		movingEnable = 0;
		duration = 0.1;
		fadein = 0.4;
		fadeout = 0.5;
		name = "ACE_Wound_Bleeding1";

		class controls {
			class ACE_Wound_Bleeding_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.6};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_bleeding1.paa));
			};
		};
	};
	class ACE_Wound_Bleeding2 {
		idd = 585302;
		movingEnable = 0;
		duration = 0.1;
		fadein = 0.3;
		fadeout = 0.6;
		name = "ACE_Wound_Bleeding2";

		class controls {
			class ACE_Wound_Bleeding_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.8};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_bleeding1.paa));
			};
		};
	};
	class ACE_Wound_Bleeding3 {
		idd = 585303;
		movingEnable = 0;
		duration = 0.1;
		fadein = 0.2;
		fadeout = 0.7;
		name = "ACE_Wound_Bleeding3";

		class controls {
			class ACE_Wound_Bleeding_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.9};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_bleeding2.paa));
			};
		};
	};
	class ACE_Wound_Bleeding4 {
		idd = 585304;
		movingEnable = 0;
		duration = 0.1;
		fadein = 0.18;
		fadeout = 0.72;
		name = "ACE_Wound_Bleeding4";

		class controls {
			class ACE_Wound_Bleeding_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.9};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_bleeding3.paa));
			};
		};
	};
	class ACE_Wound_Bleeding5 {
		idd = 585305;
		movingEnable = 0;
		duration = 0.1;
		fadein = 0.15;
		fadeout = 0.75;
		name = "ACE_Wound_Bleeding5";

		class controls {
			class ACE_Wound_Bleeding_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.9};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_bleeding3.paa));
			};
		};
	};

	class ACE_Wound_Unconscious1 {
		idd = 585311;
		movingEnable = 0;
		duration = 1e+011;
		fadein = 0;
		fadeout = 1.5;
		name = "ACE_Wound_Unconscious1";

		class controls {
			class ACE_Wound_Unconscious_BG {
				idc = 1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_unc1.paa));
			};
		};
	};
	class ACE_Wound_Unconscious2 {
		idd = 585312;
		movingEnable = 0;
		duration = 1e+011;
		fadein = 1.5;
		fadeout = 0;
		name = "ACE_Wound_Unconscious2";

		class controls {
			class ACE_Wound_Unconscious_BG {
				idc = 1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_unc2.paa));
			};
		};
	};
	class ACE_Wound_Unconscious3 {
		idd = 585313;
		movingEnable = 0;
		duration = 2;
		fadein = 0;
		fadeout = 1.5;
		name = "ACE_Wound_Unconscious3";

		class controls {
			class ACE_Wound_Unconscious_BG {
				idc = 1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_unc2.paa));
			};
		};
	};
	class ACE_Wound_UnconsciousNothing {
		idd = -1;
		movingEnable = 0;
		duration = 1;
		fadein = 0;
		fadeout = 1.5;
		name = "ACE_Wound_UnconsciousNothing";

		class controls {
			class ACE_Wound_Unconscious_BG2 {
				idc = 2;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {1, 1, 1, 1};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_unc1.paa));
			};
		};
	};
	class ACE_Wound_Pain {
		idd = 585321;
		movingEnable = 0;
		duration = 0.1;
		fadein = 0.4;
		fadeout = 0.5;
		name = "ACE_Wound_Pain";

		class controls {
			class ACE_Wound_Bleeding_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.65};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\i_pain.paa));
			};
		};
	};
	class ACE_Wound_ScreenDirt {
		idd = -1;
		movingEnable = 0;
		duration = 5;
		fadein = 0.01;
		fadeout = 5;
		name = "ACE_Wound_ScreenDirt";

		class controls {
			class ACE_Wound_ScreenDirt_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.8};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\screen_dirt_ca.paa));
			};
		};
	};

	class ACE_Wound_ScreenBlood1 {
		idd = -1;
		movingEnable = 0;
		duration = 2;
		fadein = 0.1;
		fadeout = 5;
		name = "ACE_Wound_ScreenBlood1";

		class controls {
			class ACE_Wound_ScreenBlood_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.8};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\screen_blood_1_ca.paa));
			};
		};
	};

	class ACE_Wound_ScreenBlood2 {
		idd = -1;
		movingEnable = 0;
		duration = 2;
		fadein = 0.1;
		fadeout = 5;
		name = "ACE_Wound_ScreenBlood2";

		class controls {
			class ACE_Wound_ScreenBlood_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.8};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\screen_blood_2_ca.paa));
			};
		};
	};

	class ACE_Wound_ScreenBlood3 {
		idd = -1;
		movingEnable = 0;
		duration = 2;
		fadein = 0.1;
		fadeout = 5;
		name = "ACE_Wound_ScreenBlood3";

		class controls {
			class ACE_Wound_ScreenBlood_BG {
				idc=-1;
				type = 0;
				style = 48;
				colorBackground[] = {0, 0, 0, 0};
				colorText[] = {0.9, 0.9, 0.9, 0.8};
				font = "TahomaB";
				sizeEx = 0.023;
				x = "safeZoneXAbs";
				y = "SafeZoneY";
				w = "safeZoneWAbs + 0.05";
				h = "SafeZoneH + 0.05";
				text = QUOTE(PATHTOF(data\rsc\screen_blood_3_ca.paa));
			};
		};
	};

	class ACE_geffects_nothing
{
	idd = -1;
	movingEnable = 0;
	duration = 1;
	fadein = 0;
	fadeout = 0;
	name = "ACE_geffects_nothing";
	class controls
	{
		class ACE_geffects_nothing_BG2
		{
			idc = 2;
			type = 0;
			style = 48;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "TahomaB";
			sizeEx = 0.023;
			x = "safeZoneXAbs";
			y = "SafeZoneY";
			w = "safeZoneWAbs + 0.05";
			h = "SafeZoneH + 0.05";
			text = "\x\ace\addons\sys_wounds\data\clear_empty_ca.paa";
		};
	};
};
};
