class ACE_MAP {
	idd = IDC_MAIN;
	movingEnable = false;

	class controls {
		// Borders and title text
		class BackgroundTop: ACE_KEGsRscText {
			idc = IDC_BG1;
			x = -3.0; y = -1.0;
			w = 7.0; h = BORDERSIZE+1;
			colorBackground[] = { 0.0, 0.0, 0.0, 1.0 };
		};
		class BackgroundBottom: BackgroundTop {
			idc = IDC_BG2;
			y = 1.0-BORDERSIZE;
		};

		// Map
		class map : ACE_KEGsRscMapControl {
			idc = IDC_MAP;
			x = 1.0-MAPWIDTH;y = 1.0-MAPHEIGHT;
			w = MAPWIDTH; h = MAPHEIGHT;
			colorBackground[] = { 0.7, 0.7, 0.7, 0.75 };
			//sizeEx = 0.02;
			sizeExLabel = MAPTXTSIZE;
			sizeExGrid = MAPTXTSIZE;
			sizeExUnits = MAPTXTSIZE;
			sizeExNames = MAPTXTSIZE;
			sizeExInfo = MAPTXTSIZE;
			sizeExLevel = MAPTXTSIZE;
			showCountourInterval = "false";

			onMouseZChanged = "[""MouseZChangedminimap"", _this] call ace_sys_spectator_fnc_spectate_events";

			class Command {
				icon = "#(argb,8,8,3)color(1,1,1,1)";
				color[] = { 0, 0, 0, 1 };
				size = 18;
				importance = 1;
				coefMin = 1;
				coefMax = 1;
			};

			class ActiveMarker {
				color[] = { 0.3, 0.1, 0.9, 1 };
				size = 50;
			};
		};

		// Fullscreen map
		class mapFullBG : BackgroundTop {
			idc = IDC_MAPFULLBG;
			x = -3;y =-3;
			w = 9;h = 9;
			colorBackground[] = { 0.0, 0.0, 0.0, 1.0 };
		};
		class mapFull : map {
			showCountourInterval = "true";
			idc = IDC_MAPFULL;
			x = 0;y = BORDERSIZE;
			w = 1;h = 1.0-(BORDERSIZE*2);
			colorBackground[] = { 0.85, 0.85, 0.85, 1.0 };
		};
	};
};
