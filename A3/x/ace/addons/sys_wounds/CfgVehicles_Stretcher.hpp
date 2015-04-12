	class Bicycle;
	class ACE_Stretcher: Bicycle {
		scope = 1;
		displayName = $STR_DN_ACE_STRETCHER;
		displayNameShort = $STR_DN_ACE_STRETCHER;
		model = "\x\ace\addons\sys_wounds\ace_stretcher.p3d";
		vehicleClass = "Car";
		armor = 5;
		weapons[] = {};
		magazines[]= {};
		wheelCircumference = 1;
		rarityUrban = -1;
		class DestructionEffects {};
		class Library { libTextDesc = ""; };
		picture = QUOTE(PATHTO_C(data\picture\picture_ace_stretcher_ca.paa));
		Icon = "";
		mapSize = 1;
		maxSpeed = 0;
		ejectDeadCargo = 0;
		extCameraPosition[] = { 0, 0, -3 };
		class HitPoints {
			class HitRGlass { armor = 0.3; material = -1; name = "sklo predni P"; passThrough = 0; };
			class HitLGlass { armor = 0.3; material = -1; name = "sklo predni L"; passThrough = 0; };
			class HitBody { armor = 1; material = 51; name = "karoserie"; visual = ""; passThrough = 1; };
			class HitFuel { armor = 0.3; material = 51; name = "palivo"; passThrough = 0; };
			class HitFWheel { armor = 1; material = -1; name = "wheel_1_damper"; visual = "wheel_1"; passThrough = 0; };
			class HitBWheel { armor = 1; material = -1; name = "wheel_2_damper"; visual = "wheel_2"; passThrough = 0; };
			class HitEngine { armor = 0.4; material = -1; name = "motor"; visual = ""; passThrough = 0; };
		};
		threat[] = { 0, 0, 0 };
		secondaryExplosion = 0;
		leftDustEffect = "NoDust";
		rightDustEffect = "NoDust";
		transportMaxMagazines = 0;
		transportMaxWeapons = 0;
		class Reflectors {};
		driverAction = "MMT_Driver";
		driverInAction = "MMT_Driver";
		transportSoldier = 1;
		typicalCargo[] = { "USMC_Soldier" };
		cargoAction[] = { "BMP2_Cargo04" };
		getInAction = "GetInLow";
		getOutAction = "GetOutLow";
		cargoGetInAction[] = {
			"GetInLow"
		};
		cargoGetOutAction[] = {
			"GetOutLow"
		};
		animated = 1;
		hadsDriver = 0;
		driverCompartments=0;
		cargoCompartments[] = {1};
		memoryPointsGetInDriver = "pos driver1";
		memoryPointsGetInDriverDir = "pos driver1 dir";
		memoryPointsGetInCargo = "pos cargo";
		memoryPointsGetInCargoDir = "pos cargo dir";
		class AnimationSources {
			class user1 {
				source = "user";
				animPeriod = "0.05";
				initPhase = "0";
			};
			class user2: user1 {};
		};
		ACE_canBeLoad = true;
		ACE_canBeCargo = false;
	};
