class ACE_Progressbar_RscText {
	type = 0;
	idc = -1;
	style = 0x00;
	x = 0.0;
	y = 0.0;
	w = 0.3;
	h = 0.03;
	sizeEx = 0.023;
	colorBackground[] = {0.5, 0.5, 0.5, 0.75};
	colorText[] = { 0, 0, 0, 1 };
	font = "PuristaMedium";
	text = "";
};

class ACE_DBC_RscGroupBox2 {
	type = 0;
	idc = -1;
	style = 112;
	text = "";
	colorBackground[] = {1,1,1,0.6};
	colorText[] = {0,0,0,0};
	font = "TahomaB";
	sizeEx = 0.02;
};

// stra debug console from gaia
class ACE_MP_Debug_Console {
	idd = 135663;
	movingEnable = 1;
	onLoad = "ace_debug_console_run = true;'load' spawn ace_main_fnc_dbc_run";
	onUnload = "ace_debug_console_run = false; 'unload' call ace_main_fnc_dbc_run";
	class Controls {
		class Drag: ACE_DBC_RscGroupBox2 {
			x = 0.1;
			y = 0.07;
			w = 0.8;
			h = 0.83;
			colorbackground[] = {0,0,0,0.8};
			colortext[] = {0,0,0,0};
			moving = 1;
		};
		class Header: RscText {
			style = 2;
			x = 0.1;
			y = 0.07;
			w = 0.8;
			h = 0.04;
			text = "ACE MP Debug Console";
			sizeEx = 0.04;
			colortext[] = {1,1,1,1};
		};
		class SubBackground1: ACE_DBC_RscGroupBox2 {
			x = 0.11;
			y = 0.115;
			w = 0.78;
			h = 0.41;
			style = 128;
			colorBackground[] = {0.709,0.972,0.384,0.2};
		};
		class SubBackground2: ACE_DBC_RscGroupBox2 {
			x = 0.11;
			y = 0.535;
			w = 0.78;
			h = 0.35;
			style = 128;
			colorBackground[] = {0.709,0.972,0.384,0.2};
		};
		class ValueInput1: RscEdit {
			IDC = 316011;
			x = 0.12;
			y = 0.125;
			w = 0.76;
			h = 0.04;
			autocomplete = "scripting";
		};
		class ValueOutput1: RscEdit {
			IDC = 316012;
			x = 0.12;
			y = "0.165-0.001";
			w = 0.76;
			h = 0.04;
		};
		class ValueInput2: ValueInput1 {
			IDC = 316021;
			y = 0.225;
		};
		class ValueOutput2: ValueOutput1 {
			IDC = 316022;
			y = "0.265-0.001";
		};
		class ValueInput3: ValueInput1 {
			IDC = 316031;
			y = 0.325;
		};
		class ValueOutput3: ValueOutput1 {
			IDC = 316032;
			y = "0.365-0.001";
		};
		class ValueInput4: ValueInput1 {
			IDC = 316041;
			y = 0.425;
		};
		class ValueOutpu4: ValueOutput1 {
			IDC = 316042;
			y = "0.465-0.001";
		};
		class CommandInput1: RscEdit {
			IDC = 316101;
			x = 0.12;
			y = 0.55;
			w = 0.695;
			h = 0.04;
			autocomplete = "scripting";
		};
		class CommandButton1: RscButton_small {
			idc = -1;
			x = 0.82;
			y = 0.55;
			w = 0.06;
			h = 0.04;
			colorText[] = {0.75,0.75,0.75,1};
			colorBackground[] = {"0.709/2","0.972/2","0.384/2",1};
			text = "Exec";
			action = "call compile (ctrlText 316101);";
			default = 1;
		};
		class CommandInput2: CommandInput1 {
			IDC = 316102;
			y = 0.6;
		};
		class CommandButton2: CommandButton1 {
			y = 0.6;
			action = "call compile (ctrlText 316102);";
		};
		class CommandInput3: CommandInput1 {
			IDC = 316103;
			y = 0.65;
		};
		class CommandButton3: CommandButton1 {
			y = 0.65;
			action = "call compile (ctrlText 316103);";
		};
		class CommandInput4: CommandInput1 {
			IDC = 316104;
			y = 0.7;
		};
		class CommandButton4: CommandButton1 {
			y = 0.7;
			action = "call compile (ctrlText 316104);";
		};
		class CommandInput5: CommandInput1 {
			IDC = 316105;
			y = 0.75;
		};
		class CommandButton5: CommandButton1 {
			y = 0.75;
			action = "call compile (ctrlText 316105);";
		};
		class CommandInput6: CommandInput1 {
			IDC = 316106;
			y = 0.8;
		};
		class CommandButton6: CommandButton1 {
			y = 0.8;
			action = "call compile (ctrlText 316106);";
			default = "true";
		};
	};
};
