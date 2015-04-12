class ACE_DummyManBase: Man {
	picture="\a3\ui_f\data\gui\cfg\ButtonImages\a_ca.paa";
	Icon="\a3\ui_f\data\gui\cfg\ButtonImages\a_ca.paa";
	fsmDanger="Ca\characters\scripts\danger.fsm";
	moves="CfgMovesMaleSdr";
	gestures="CfgGesturesMale";
	boneHead="";
	boneHeadCutScene="";
	boneLEye="";
	boneREye="";
	boneLEyelidUp="";
	boneREyelidUp="";
	boneLEyelidDown="";
	boneREyelidDown="";
	boneLPupil="";
	boneRPupil="";
	bonePrimaryWeapon="";
	triggerAnim="ca\anims\characters\data\anim\sdr\trigger.rtm";
	woman=0;
	faceType="man";
	class TalkTopics {
		core="Core";
		core_en="Core_Degenerated";
		core_ru="Core_Degenerated";
		core_cz="Core_Degenerated";
	};
	languages[]={};
	minGunElev=-80;
	maxGunElev=60;
	minGunTurn=-1;
	maxGunTurn=1;
	minGunTurnAI=-30;
	maxGunTurnAI=30;
	class HeadLimits;
	minHeadTurnAI=-60;
	maxHeadTurnAI=60;
	class ViewPilot:ViewPilot{initFov=0.7;minFov=0.25;maxFov=1.1;initAngleX=8;minAngleX=-85;maxAngleX=85;initAngleY=0;minAngleY=-150;maxAngleY=150;};
	selectionHeadWound="";
	selectionBodyWound="";
	selectionLArmWound="";
	selectionRArmWound="";
	selectionLLegWound="";
	selectionRLegWound="";
	selectionHeadHide="";
	selectionNeckHide="";
	memoryPointLStep="";
	memoryPointRStep="";
	memoryPointAim="";
	memoryPointCameraTarget="";
	memoryPointCommonDamage="";
	memoryPointLeaningAxis="";
	memoryPointAimingAxis="";
	memoryPointHeadAxis="";
	selectionLBrow="";
	selectionMBrow="";
	selectionRBrow="";
	selectionLMouth="";
	selectionMMouth="";
	selectionRMouth="";
	selectionEyelid="";
	selectionLip="";
	class HitPoints {
		class HitHead{armor=0.7;material=-1;name="";passThrough=1;};class HitBody{armor=0.8;material=-1;name="";passThrough=1;};class HitHands{armor=0.5;material=-1;name="";passThrough=1;};class HitLegs{armor=0.5;material=-1;name="";passThrough=1;};
	};
	useInternalLODInVehicles=1;
	accuracy=0;
	vehicleClass="Men";
	type=0;
	threat[]={1,0.05,0.05};
	vegetation0[]={"Ca\sounds\Characters\Noises\Bush\bush1",1,1,20};
	vegetation1[]={"Ca\sounds\Characters\Noises\Bush\bush2",1,1,20};
	vegetation2[]={"Ca\sounds\Characters\Noises\Bush\bush3",1,1,20};
	vegetationSounds[]={"vegetation0",0.33,"vegetation1",0.33,"vegetation2",0.33};

	#include "CfgVehicles_DummySounds.hpp"

	weaponSlots = ACE_DEFAULT_SLOTS;
	fsmFormation="Formation";
	leftArmToElbow[]={"",0.5,"",0};
	leftArmFromElbow[]={"",0,"",0.5};
	leftWrist="";
	leftShoulder="";
	leftHand[]={"","","","","","","","","","","","","","","",""};
	leftArmPoints[]={"","","",""};
	rightArmToElbow[]={"",0.5,"",0};
	rightArmFromElbow[]={"",0,"",0.5};
	rightWrist="";
	rightShoulder="";
	rightHand[]={"","","","","","","","","","","","","","","",""};
	rightArmPoints[]={"","","",""};
	launcherBone="";
	handGunBone="";
	weaponBone="";
	XEH_DISABLED; // Empty for Dummies, saves script processing && Excludes dummy from "XEH for unsupported addons" :-D
};
class ACE_CivDummy: ACE_DummyManBase {
	scope=1;
	side=3;
	displayName=$STR_DN_CIVILIAN;
	nameSound="civilian2";
	model= QUOTE(PATHTO_M(dummy2.p3d)); // TODO: Check if BIS model can be used here ...
	accuracy=0.6;
	camouflage=2.2;
	threat[]={0.0,0.0,0.0};
	weapons[]={"Throw","Put","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
	respawnWeapons[]={"Throw","Put","ItemMap","ItemCompass","ItemWatch","ItemRadio"};
	magazines[]={};
	cost=100000;
	fsmFormation="ca\characters\scripts\formationC.fsm";
	fsmDanger="ca\characters\scripts\formationCDanger.fsm";
	formationX=2;
	formationZ=5;

	class Wounds{tex[]={};mat[]={};};
};
