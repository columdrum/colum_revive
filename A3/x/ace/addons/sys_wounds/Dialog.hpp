class ACE_Wound_UnconsciousD1 {
	name=ACE_Wound_UnconsciousD1;
	idd=-1;
	movingEnable=1;
	controlsBackground[]={Background};
	objects[]={};
	controls[]={};

	onLoad = "with uiNamespace do {ACE_Wound_UnconsciousD1 = _this select 0}";

	class Background {
		colorBackground[]={0, 0, 0, 0};
		type=0;
		colorText[]={1, 1, 1, 1};
		sizeEx=0.04;
		//style = 48 + 0x800;
		style = 48;
		font = "TahomaB";
		idc=-1;
		x = "safeZoneXAbs";
		y = "SafeZoneY";
		w = "safeZoneWAbs + 0.05";
		h = "SafeZoneH + 0.05";
		text = QUOTE(PATHTOF(data\rsc\i_unc1.paa));
	};
};
