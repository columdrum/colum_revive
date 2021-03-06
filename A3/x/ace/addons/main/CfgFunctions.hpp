// -----------------------------------------------------------------------------
// Automatically generated by 'functions_config.rb'
// DO NOT MANUALLY EDIT THIS FILE!
// -----------------------------------------------------------------------------

class CfgFunctions {
	class ACE {
		class Main {
			// ACE_fnc_add2clean
			class add2clean {
				description = "Add an item to a timed cleanup list. Item is automatically removed after it's lifetime expires.";
				file = "\x\ace\Addons\main\fnc_add2clean.sqf";
			};
			// ACE_fnc_add2fifo
			class add2fifo {
				description = "Add an item to a queue. Items in excess of the specified purge count will be deleted in First-in First-out ( FIFO ) order.";
				file = "\x\ace\Addons\main\fnc_add2fifo.sqf";
			};
			// ACE_fnc_add2sfifo
			class add2sfifo {
				description = "adds an object to the slowly running FIFO";
				file = "\x\ace\Addons\main\fnc_add2sfifo.sqf";
			};
			// ACE_fnc_bulletCam
			class bulletCam {
				description = "BulletCam for debugging";
				file = "\x\ace\Addons\main\fnc_bulletCam.sqf";
			};
			// ACE_fnc_DelPropertyObj
			class DelPropertyObj {
				description = "Func";
				file = "\x\ace\Addons\main\fnc_DelPropertyObj.sqf";
			};
			// ACE_fnc_FixHeadbug
			class FixHeadbug {
				description = "Func";
				file = "\x\ace\Addons\main\fnc_FixHeadbug.sqf";
			};
			// ACE_fnc_FixHeadbugAlt
			class FixHeadbugAlt {
				description = "Func";
				file = "\x\ace\Addons\main\fnc_FixHeadbugAlt.sqf";
			};
			// ACE_fnc_GetProperty
			class GetProperty {
				description = "Func";
				file = "\x\ace\Addons\main\fnc_GetProperty.sqf";
			};
			// ACE_fnc_groupdebug
			class groupdebug {
				description = "Debug Markers etc for Groups";
				file = "\x\ace\Addons\main\fnc_groupdebug.sqf";
			};
			// ACE_fnc_inBuilding
			class inBuilding {
				description = "Function to check if a person or a position is inside a house.";
				file = "\x\ace\Addons\main\fnc_inBuilding.sqf";
			};
			// ACE_fnc_inFront
			class inFront {
				description = "Function to check if Object2 is in front of Object1";
				file = "\x\ace\Addons\main\fnc_inFront.sqf";
			};
			// ACE_fnc_isBurning
			class isBurning {
				description = "Returns if vehicle/unit is burning";
				file = "\x\ace\Addons\main\fnc_isBurning.sqf";
			};
			// ACE_fnc_isCrew
			class isCrew {
				description = "Returns if unit is a crew unit";
				file = "\x\ace\Addons\main\fnc_isCrew.sqf";
			};
			// ACE_fnc_isPilot
			class isPilot {
				description = "Returns if unit is a pilot unit";
				file = "\x\ace\Addons\main\fnc_isPilot.sqf";
			};
			// ACE_fnc_isVehTurnedOut
			class isVehTurnedOut {
				description = "Checks whether a vehicle has any crew turned out. Accepts vehicle or individual unit as parameter. By default, if crew (even exposed gunners) do not have the option to turn in, they are considered turned in. Use optional parameter _exposure to be treat only sealed or pressurized vehicles as capable of being turned in.";
				file = "\x\ace\Addons\main\fnc_isVehTurnedOut.sqf";
			};
			// ACE_fnc_lockClass
			class lockClass {
				description = "Adds disability to units who uses weapon not for his faction/role";
				file = "\x\ace\Addons\main\fnc_lockClass.sqf";
			};
			// ACE_fnc_particle
			class particle {
				description = "Creates particlesource and attaches on unit";
				file = "\x\ace\Addons\main\fnc_particle.sqf";
			};
			// ACE_fnc_registerSimulation
			class registerSimulation {
				description = "Register simulationType for CAManBase";
				file = "\x\ace\Addons\main\fnc_registerSimulation.sqf";
			};
			// ACE_fnc_removeMagazineCargo
			class removeMagazineCargo {
				description = "Function to remove a magazine from a vehicles cargo.";
				file = "\x\ace\Addons\main\fnc_removeMagazineCargo.sqf";
			};
			// ACE_fnc_removeWeaponCargo
			class removeWeaponCargo {
				description = "Function to remove a weapon from a vehicles cargo.";
				file = "\x\ace\Addons\main\fnc_removeWeaponCargo.sqf";
			};
			// ACE_fnc_SetProperty
			class SetProperty {
				description = "Func";
				file = "\x\ace\Addons\main\fnc_SetProperty.sqf";
			};
			// ACE_fnc_track
			class track {
				description = "Tracks an object with markers and particles";
				file = "\x\ace\Addons\main\fnc_track.sqf";
			};
			// ACE_fnc_TurretFeature
			class TurretFeature {
				description = "Function to retrieve a turret feature";
				file = "\x\ace\Addons\main\fnc_TurretFeature.sqf";
			};
			// ACE_fnc_unitvehpos
			class unitvehpos {
				description = "Function to retrieve unit position in vehicle, analogous to assignedvehiclerole but more reliable";
				file = "\x\ace\Addons\main\fnc_unitvehpos.sqf";
			};
			// ACE_fnc_visual
			class visual {
				description = "-";
				file = "\x\ace\Addons\main\fnc_visual.sqf";
			};
			// ACE_fnc_WeaponFeature
			class WeaponFeature {
				description = "Function to retrieve a muzzle feature";
				file = "\x\ace\Addons\main\fnc_WeaponFeature.sqf";
			};
			class addClientToServerEventhandler
			{
				description = "Registers an event handler for a client to server event which only runs on the server (thus is only needed on the server)";
				file = "\x\ace\Addons\main\fnc_addClientToServerEventhandler.sqf";
			};
			class addMagazineCargoEx
			{
				description = "Add magazines with a specific bullet count to the cargo space of vehicles.";
				file = "\x\ace\Addons\main\fnc_addMagazineCargoEx.sqf";
			};
			class addReceiverOnlyEventhandler
			{
				description = "Registers an event handler for an ACE event which is only broadcasted to the receiver (and no other clients)";
				file = "\x\ace\Addons\main\fnc_addReceiverOnlyEventhandler.sqf";
			};
			class receiverOnlyEvent
			{
				description = "Raises an ACE event only on the receiver and is only broadcasted there Can be called on any client or on the server. If called on a client the params are broadcasted to the server first, server then checks the owner and sends the params only to that specific client";
				file = "\x\ace\Addons\main\fnc_receiverOnlyEvent.sqf";
			};
			class removeClientToServerEvent
			{
				description = "Removes an event handler previously registered with ACE_fnc_addClientToServerEventhandler.";
				file = "\x\ace\Addons\main\fnc_removeClientToServerEvent.sqf";
			};
			class removeReceiverOnlyEvent
			{
				description = "Removes an event handler previously registered with ACE_fnc_addReceiverOnlyEventhandler.";
				file = "\x\ace\Addons\main\fnc_removeReceiverOnlyEvent.sqf";
			};
			class clientToServerEvent
			{
				description = "Raises an ACE event only on the server (only broadcasted to server and not to other clients)";
				file = "\x\ace\Addons\main\fnc_clientToServerEvent.sqf";
			};

		};
	};
	/*
	class CBA {
		class Events {
			// CBA_fnc_readKeyFromConfig
			class readKeyFromConfig {
				description = "Reads key setting from config";
				file = "\x\ace\Addons\main\fnc_readKeyFromConfig.sqf";
			};
		};
	};
	*/
//Additional BIS functions automatically added from ./BISaddl.txt
	class BIS {
		class misc {
			// BIS_fnc_posToGrid
			class PosToGrid {
				file = "\x\ace\Addons\main\fnc_posToGrid.sqf";
			};
		};
	};
};
