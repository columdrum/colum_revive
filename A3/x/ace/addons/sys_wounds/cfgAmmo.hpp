#define P_DEBRIS 0.1
#define P_PISTOL 0.75
#define P_BALLLEAD 1
#define P_BALLSTEEL 1.2
#define P_BALLDOUBLECORE 1.1
#define P_BALLDOUBLECORE_EP 1.3
#define P_BALLTUNGSTEN 1.4

class cfgAmmo {
	class Default;
	class BulletCore;
	class ACE_DummyAmmo: Default
	{
		scope = 1;
		hit = 0.001;
		indirectHit = 0.001;
		indirectHitRange = 0.01;
	};
	class BulletBase: BulletCore {
		ace_mass = 0.4;
		ace_caliber = 6;
		ace_penetrationMultiplier = P_BALLSTEEL;
	};

	// pistol

	class B_9x18_Ball: BulletBase {
		ace_mass = 0.61;
		ace_caliber = 9;
		ace_penetrationMultiplier = P_PISTOL;
	};
	class B_9x19_Ball: B_9x18_Ball {
		ace_mass = 0.8;
	};
	class B_9x19_SD: B_9x19_Ball {
		ace_mass = 0.95;
	};
	class B_45ACP_Ball: BulletBase {
		ace_mass = 1.49;
		ace_caliber = 11.43;
		ace_penetrationMultiplier = P_PISTOL;
	};
	class B_765x17_Ball: BulletBase { // .32 ACP
		ace_mass = 0.46;
		ace_caliber = 7.8;
		ace_penetrationMultiplier = P_PISTOL;
	};
	class ACE_Bullet_762x25_B: B_9x19_Ball { // 7.62x25 Tokarev
		ace_mass = 0.55;
		ace_caliber = 7.8;
		ace_penetrationMultiplier = P_PISTOL;
	};

	// rifle

	class B_545x39_Ball: BulletBase {
		ace_mass = 0.343;
		ace_caliber = 5.45;
	};
	class ACE_B_545x39_T: B_545x39_Ball {
		ace_mass = 0.324;
	};
	class B_545x39_SD: BulletBase {
		ace_mass = 0.52;
		ace_caliber = 5.45;
	};
	class ACE_B_545x39_EP: B_545x39_Ball {
		ace_mass = 0.362;
	};
	class ACE_B_545x39_AP: B_545x39_Ball {
		ace_mass = 0.368;
	};
	class B_556x45_Ball: BulletBase {
		ace_mass = 0.402;
		ace_caliber = 5.56;
		ace_penetrationMultiplier = P_BALLDOUBLECORE;
	};
	class ACE_B_556x45_T: B_556x45_Ball {
		ace_mass = 0.4;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	class ACE_B_556x45_SB: B_556x45_Ball {
		ace_mass = 0.499;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	class B_556x45_SD: BulletBase {
		ace_mass = 0.57;
		ace_caliber = 5.56;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	class ACE_B_556x45_EP: B_556x45_Ball {
		ace_mass = 0.402;
		ace_penetrationMultiplier = P_BALLDOUBLECORE_EP;
	};
	class ACE_B_556x45_AP: B_556x45_Ball {
		ace_mass = 0.37;
		ace_penetrationMultiplier = P_BALLTUNGSTEN;
	};
	class ACE_B_556x45_DM31: ACE_B_556x45_AP {
		ace_mass = 0.4;
		ace_penetrationMultiplier = P_BALLTUNGSTEN;
	};
	class B_9x39_SP5: BulletBase {
		ace_mass = 1.68;
		ace_caliber = 9;
		ace_penetrationMultiplier = (P_BALLLEAD + P_BALLSTEEL)/2;
	};
	class ACE_B_9x39_SP6: B_9x39_SP5 {
		ace_mass = 1.6;
		ace_penetrationMultiplier = P_BALLSTEEL;
	};
	class B_762x39_Ball: BulletBase {
		ace_mass = 0.79;
		ace_caliber = 7.62;
	};
	class ACE_B_762x39_T: B_762x39_Ball {
		ace_mass = 0.79;
	};
	class ACE_B_762x39_SD: B_762x39_Ball {
		ace_mass = 1.255;
	};
	class B_762x51_Ball: BulletBase {
		ace_mass = 0.972;
		ace_caliber = 7.62;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	class ACE_B_762x51_T: B_762x51_Ball {
		ace_mass = 0.972;
	};
	class B_762x51_noTracer: B_762x51_Ball {
		ace_mass = 1.134;
	};
	class B_762x54_Ball: BulletBase {
		ace_mass = 0.96;
		ace_caliber = 7.62;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	class ACE_B_762x54_T: B_762x54_Ball {
		ace_mass = 0.96;
	};
	class B_762x54_noTracer: B_762x54_Ball {
		ace_mass = 0.96;
	};
	class B_77x56_Ball: BulletBase {
		ace_mass = 0.96;
		ace_caliber = 7.7;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	class B_303_Ball: BulletBase {
		ace_mass = 0.96;
		ace_caliber = 7.7;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	// 0.338 Lapua :: 9,7g
	class B_86x70_Ball_noTracer: BulletBase {
		ace_mass = 0.9;
		ace_caliber = 7.62;
	};
	class ACE_B_86x70_SB: B_762x51_noTracer {
		ace_mass = 0.9;
		ace_caliber = 7.62;
	};
	
	// PDW
	class ACE_B_46x30_B: B_9x19_Ball {
		ace_mass = 0.2;
		ace_caliber = 4.6;
		ace_penetrationMultiplier = P_BALLSTEEL;
	};
	class ACE_B_46x30_SD: ACE_B_46x30_B { // subsonic HDCP 65 grs.
		ace_mass = 0.421;
		ace_penetrationMultiplier = P_BALLLEAD;
	};
	class ACE_B_57x28_B: B_9x19_Ball {
		ace_mass = 0.2;
		ace_caliber = 5.7;
		ace_penetrationMultiplier = P_BALLSTEEL;
	};
	class ACE_B_6x35_B: B_556x45_Ball {
		ace_mass = 0.42;
		ace_caliber = 6;
	};

	// sys_backblast ammo
	class Ace_ATDebris : BulletBase {
		ace_w_explosive = 1;
		ace_penetrationMultiplier = P_DEBRIS;
	};

	// shotguns

	class ShotgunBase;
	class B_12Gauge_74Slug: BulletBase {
		ace_mass = 2.8;
		ace_caliber = 18.5;
		ace_penetrationMultiplier = P_PISTOL;
	};
	class B_12Gauge_Pellets: ShotgunBase {
		ace_mass = 0.349;
		ace_caliber = 9.24;
		ace_penetrationMultiplier = P_PISTOL;
	};
	class ACE_Slug_12_1: BulletBase {
		ace_mass = 2.8;
		ace_caliber = 18.5;
		ace_penetrationMultiplier = P_PISTOL;
	};
	class ACE_Pellet_Buck_00: BulletBase {
		ace_mass = 0.349;
		ace_caliber = 9.24;
		ace_penetrationMultiplier = P_PISTOL;
	};

	// big rounds

	class B_127x99_Ball: BulletBase {
		ace_mass = 4.034;
		ace_caliber = 12.7;
	};
	class ACE_B_127x99_T: B_127x99_Ball {
		ace_mass = 4.0;
		ace_caliber = 12.7;
	};
	class B_127x99_Ball_noTracer: B_127x99_Ball {
		ace_mass = 4.348;
	};
	class B_127x107_Ball: BulletBase {
		ace_mass = 4.82;	// B-32
		ace_caliber = 12.7;
	};
	class ACE_B_127x108_T: B_127x107_Ball {
		ace_mass = 4.5;		// BZT-44M
	};
	class B_127x108_Ball: BulletBase {
		ace_mass = 4.82;	// B-32
		ace_caliber = 12.7;
	};
	class B_127x108_APHE: BulletBase {
		ace_mass = 4.82;	// B-32
		ace_caliber = 12.7;
	};
	class B_145x115_AP: BulletBase {
		ace_mass = 6.3;
		ace_caliber = 14.5;
	};

	//	==== Some classes need setting up both HE and KE params =====
	// Params not set up below
	class B_19mm_HE;
	class B_20mm;
	class B_20mm_AA: BulletBase {
		ace_mass = 10;
		ace_caliber = 20;
	};
	class B_20mm_AP: B_20mm {
		ace_mass = 10;
		ace_caliber = 20;
	};
	class B_23mm_AA: BulletBase {
		ace_mass = 15;
		ace_caliber = 23;
	};
	class B_23mm_APHE: BulletBase {
		ace_mass = 15;
		ace_caliber = 23;
	};
	class B_25mm_HE: BulletBase {
		ace_mass = 18.5;
		ace_caliber = 25;
	};
	class B_25mm_APDS: BulletBase {
		ace_mass = 9.8;
		ace_caliber = 25;
	};
	class B_30mmA10_AP: BulletBase {
		ace_mass = 30;
		ace_caliber = 30;
	};
	class B_30mm_AP: BulletBase {
		ace_mass = 40;
		ace_caliber = 30;
	};
	class B_30mm_HE: B_19mm_HE {
		ace_mass = 39;
		ace_caliber = 30;
	};
	class B_30mm_AA: BulletBase {
		ace_mass = 30;
		ace_caliber = 30;
	};
	class Sh_40_HE: BulletBase {
		ace_mass = 50;
		ace_caliber = 40;
	};
	class Sh_40_SABOT: Sh_40_HE {
		ace_mass = 35;
	};

	// Explosives
	class GrenadeCore;
	class GrenadeBase: GrenadeCore {
		ace_mass = 2;
		ace_caliber = 30;
		ace_frag_vel = 110;
		ace_penetrationMultiplier = 1;
	};
	class Grenade: Default {
		ace_mass = 2;
		ace_caliber = 30;
		ace_frag_vel = 110;
		ace_penetrationMultiplier = 1;
	};
	class GrenadeHand;
	class GrenadeHand_stone: GrenadeHand {
		ace_mass = 3;	// randomize this somehow
		ace_caliber = 60;	// randomize this somehow
		ace_penetrationmultiplier = 0.2;	// Would most likely not penetrate body armor
	};
	class TimeBombCore;
	class TimeBomb: TimeBombCore {
		ace_mass = 8;
		ace_caliber = 100;
		ace_frag_vel = 130;
		ace_penetrationMultiplier = 1;
	};
	class BombCore: Default {
		ace_mass = 50;
		ace_caliber = 100;
		ace_frag_vel = 300;
		ace_penetrationMultiplier = 1;
	};

	// Rockets
	class RocketCore;
	class RocketBase: RocketCore {
		ace_mass = 8;
		ace_caliber = 70;
		ace_frag_vel = 80;
		ace_penetrationMultiplier = 1;
	};
	class R_SMAW_HEDP: RocketBase {
		ace_frag_vel = 160;
	};
	class R_SMAW_HEAA: R_SMAW_HEDP {
		ace_frag_vel = 60;
	};
	class MissileCore;
	class MissileBase: MissileCore {
		ace_mass = 8;
		ace_frag_vel = 130;
		ace_penetrationMultiplier = 1;
	};

	// Shells
	class ShellCore;
	class ShellBase: ShellCore {
		ace_mass = 10;
		ace_caliber = 100;
		ace_penetrationMultiplier = P_BALLSTEEL;
	};
};