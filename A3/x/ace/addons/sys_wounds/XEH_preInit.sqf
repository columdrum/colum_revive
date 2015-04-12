// #define DEBUG_MODE_FULL
#include "script_component.hpp"

ADDON = false;
LOG(MSG_INIT);

GVAR(armor_difficulty_enabled) = if (difficultyEnabled "armor") then {
	WARNING("Enhanced Armor difficulty options enabled - this is not recommended in conjunction with ACE Wounds!");
	true;
} else {
	false;
};

// How much damage left when healed in the field, instead of healed at a medical facility
// (is multiplied times the amount the unit was healed in the field already)
if (isNil QGVAR(leftdam)) then { GVAR(leftdam) = 0.07 };
if (isNil QGVAR(no_medical_vehicles)) then { GVAR(no_medical_vehicles) = false };
if (isNil QGVAR(all_medics)) then { GVAR(all_medics) = false };
if (isNil QGVAR(ai_movement_bloodloss)) then { GVAR(ai_movement_bloodloss) = true };
if (isNil QGVAR(player_movement_bloodloss)) then { GVAR(player_movement_bloodloss) = true };
if (isNil QGVAR(auto_assist)) then { GVAR(auto_assist) = true };
if (isNil QGVAR(auto_assist_any)) then { GVAR(auto_assist_any) = false };
if (isNil QGVAR(medical_oasis)) then { GVAR(medical_oasis) = false };
if (isNil QGVAR(medical_oasis2)) then { GVAR(medical_oasis2) = false };
if (isNil QGVAR(ai_skill_handicap)) then { GVAR(ai_skill_handicap) = true };
if (isNil QGVAR(fall_on_impact_while_standing)) then { GVAR(fall_on_impact_while_standing) = false };

GVAR(parts) = ["ace_w_head_hit","ace_w_body","ace_w_hands","ace_w_legs"];
GVAR(hitpm) = ["head","body","hands","legs"];
GVAR(hitp) = ["HitHead","HitBody","HitHands","HitLegs"];
GVAR(recAnswer) = [];
GVAR(anims_standing) = ["AdthPercMstpSlowWrflDnon_1", "AdthPercMstpSlowWrflDf_2", "AdthPercMstpSlowWrflDnon_2",  "AdthPercMstpSlowWrflDf_1"];
GVAR(anims_kneel) = [ "AdthPercMrunSlowWrflDf_6", "AdthPercMrunSlowWrflDf_6", "AdthPercMrunSlowWrflDf_6", "AdthPercMrunSlowWrflDf_6"];

if (isNil QGVAR(smoke_probab)) then {GVAR(smoke_probab) = 0.4};
GVAR(medical_gear_units) = [];
GVAR(burnHelp) = false;


ace_blackoutall = COMPILE_FILE(blackoutall);
ace_w_setunitdam = COMPILE_FILE(setw);

FUNC(addStamina) = {
	private ["_stam_wounds", "_total"];
	PARAMS_2(_unit,_addStaminaHandicap);
	/*
	_stam_wounds = [_unit, "ace_sys_stamina_wounds", 0] call ace_fnc_def;
	_total = _stam_wounds + _addStaminaHandicap;
	_unit setVariable ["ace_sys_stamina_wounds", _total];
	TRACE_2("Stamina Handi",_addStaminaHandicap,_total);
	*/
};

FUNC(divStamina) = {
	private ["_stam_wounds", "_total"];
	PARAMS_2(_unit,_div);
	/*
	_stam_wounds = [_unit, "ace_sys_stamina_wounds", 0] call ace_fnc_def;
	_total = _stam_wounds / _div;
	_unit setVariable ["ace_sys_stamina_wounds", _total];
	TRACE_2("Stamina Handi",_div,_total);
	*/
};

FUNC(setStamina) = {
	PARAMS_2(_unit,_amount);
	_unit setVariable ["ace_sys_stamina_wounds", _amount];
	TRACE_1("Stamina Handi",_amount);
};

PREP(burnHelp);
PREP(fall);
PREP(addEH);
PREP(ha);
PREP(hd);
PREP(hd2);
PREP(hh);
PREP(unitinit);
PREP(vchange);
PREP(blackoutai);
PREP(RemoveBleed);
PREP(RemovePain);
PREP(RemoveUncon);
PREP(handlenet);
PREP(handlenet2);
PREP(statehandler);
PREP(animator);
PREP(animator2);

PREP(stretchers);
PREP(stretcher_fix);

PREP(bodybag);

PREP(getout);
PREP(burnmen);
PREP(checkburn);

PREP(checkdrag);

PREP(getThrowAnim);
PREP(throwSmoke);

PREP(addMedicalGear);
PREP(isMedicalFacility);
PREP(requestAssist);
PREP(canHeal);
PREP(help);
PREP(heal);
PREP(nearMedicalFacility);
PREP(takeItem);
PREP(treat_heal);

PREP(examunit);
PREP(examine);
PREP(examansw2);

PREP(isMedic);
PREP(isUncon);
PREP(roll);
PREP(hasRuckMagazine);
PREP(surg);

// Condition for medical gear
FUNC(medGearEnabled) = {
    PARAMS_1(_unit);
    isNil "ace_sys_wounds_no_medical_gear" && !isNil "ace_sys_wounds_enabled" &&
	!(_unit getVariable ["ace_sys_wounds_no_medical_gear", false])
};

// Init IFAK counts for briefing
FUNC(initIFAK) = {
    PARAMS_1(_unit);
    DEFAULT_PARAM(1,_reset,false);
    //[MOR, BND, EPI]
    if ( _unit call FUNC(medGearEnabled) ) then {
        if ([_unit] call FUNC(isMedic)) then {
            [_unit, 2, 2, 2, _reset] call ACE_fnc_PackIFAK;
        } else {
            [_unit, 0, 2, 0, _reset] call ACE_fnc_PackIFAK;
        };
    };
};

FUNC(addMedicalInt) = {
	private "_done";
	PARAMS_1(_unit);

	_done = _unit getVariable [QGVAR(added_gear), false];
	TRACE_2("State",_unit,_done);

	if (!_done && local _unit) then {
		_unit setVariable [QGVAR(added_gear), true, true]; // TAG the unit so we dont add double gear
	};
	// Always run the gear for add of Ruck items
	[_unit, _done] call FUNC(addMedicalGear);
};

FUNC(onRespawn) = {
	PARAMS_1(_unit);
	_unit call FUNC(unitInit);
	_unit setVariable ["ace_is_burning", false, true];
	//[_unit, true] call FUNC(initIFAK);
	[_unit] call FUNC(addMedicalGear);
};

FUNC(goUncon) = {
	PARAMS_2(_unit,_uncTime);
	[_unit, 100] call FUNC(animator2);
	_unit setVariable ["ace_w_unconlen", time + _uncTime]; // bleeding and pain
	_unit setVariable [QGVAR(uncon),true,true];
	if (isPlayer _unit) then {
		[false] spawn FUNC(blackoutp);
	} else {
		[_unit,false] spawn FUNC(blackoutai);
	};
};

FUNC(setHit) = {
	PARAMS_3(_unit,_part,_damage);
	_unit setVariable [GVAR(parts) select _part, _damage];
	_unit setHit [GVAR(hitpm) select _part, _damage];
	true;
};

FUNC(getHit) = {
	PARAMS_2(_unit,_part);
	_unit getVariable [GVAR(parts) select _part, 0];
};

FUNC(setDamage) = {
	PARAMS_2(_u,_d);
	if (isNil "ace_sys_wounds_enabled") then {
		_u setDamage _d;
	} else {
		// _unit setVariable ["ace_w_overall", _d]; // handled in hd...
		if (local _u) then {
			[_u,"",_d,objNull,""] call FUNC(hd);
		} else {
			["ace_sys_wounds_addDloc", [_u, _d]] call CBA_fnc_globalEvent;
		};
	};
};

// BWC
FUNC(prDamCheck) = FUNC(setDamage);

// Add damage instead of setDamage sorta like prdamcheck
FUNC(addDamage) = {
	PARAMS_2(_u,_d);
	[_u,(damage _u)+_d] call FUNC(setDamage);
};

FUNC(getDamage) = {
	private ["_i", "_body", "_head", "_hands", "_legs"];
	PARAMS_1(_unit);
	_i = 0;
	if !(alive _unit) exitWith { 1 };

	if (isNil "ace_sys_wounds_enabled") then {
		_i = damage _unit;
		TRACE_1("damage",_i);
	} else {
		_body = _unit getVariable ["ace_w_body", 0];
		_head = _unit getVariable ["ace_w_head_hit", 0];
		_hands = _unit getVariable ["ace_w_hands", 0];
		_legs = _unit getVariable ["ace_w_legs", 0];
		if (_body > 0) then { ADD(_i,0.4 * _body) };
		if (_head > 0) then { ADD(_i,0.25 * _head) };
		if (_hands > 0) then { ADD(_i,0.15 * (_hands / 20)) };
		if (_legs > 0) then { ADD(_i,0.2 * (_legs / 20)) };
		//TRACE_5("damage",_body,_head,_hands,_legs,_i);
	};
	_i min 0.99;
};

FUNC(occupied) = {
	PARAMS_1(_unit);
	// TODO: Check for vehicle?? - !alive??
	!isNull(_unit getVariable ["ace_w_carry", objNull]) || _unit getVariable ["ace_w_busy", false];
};

FUNC(NoAmmoCheck) = {
	private ["_unit", "_state", "_bd"];
	PARAMS_2(_unit,_state);
	_bd = _unit getVariable (GVAR(parts) select 1);
	switch (true) do {
		case (_bd > 0 && _bd < 0.55): {
			[_unit, STATE_800_BLOSS_ADD, STATE_800_PAIN_ADD, 0] call FUNC(vchange);
			if (_state <= 800) then {
				_unit setVariable ["ace_w_state",800]; // state 800 = bleeding signs, pain
			};
		};
		case (_bd >= 0.55 && _bd < 0.7): {
			[_unit, STATE_801_BLOSS_ADD, STATE_801_PAIN_ADD, 1] call FUNC(vchange);
			if (_state <= 801) then {
				_unit setVariable ["ace_w_nextuncon", time];
				_unit setVariable ["ace_w_state",801]; // state 801 = blackouts every now and then, bleeding signs, pain
			};
		};
		case (_bd >= 0.7 && _bd < 1): {
			[_unit, STATE_802_BLOSS_ADD, STATE_802_PAIN_ADD, 1] call FUNC(vchange);
			if (_state <= 802) then {
				_unit setVariable ["ace_w_unconlen", time + MAX_UNC_TIME];
				_unit setVariable ["ace_w_state",802]; // state 802 = complete blackout,
			};
		};
	};
};

FUNC(MissionEndCheck) = {
	GVAR(mission_end) = false;
	_trig = createTrigger["EmptyDetector", [0,0,0]];
	_trig setTriggerType "END5";
	_trig setTriggerActivation ["LOGIC", "", false];
	_trig setTriggerArea [0, 0, 0, false];
	_trig setTriggerStatements [QGVAR(mission_end), "titleText [""Mission Failed - all players are either dead or unconscious"", ""Black Faded"", 1];forceEnd", ""];
	_trig setTriggerTimeout [15, 15, 15, false];

	if (isServer) then {
		[] spawn {
			private ["_units", "_countall", "_counter"];
			sleep 90;
			while {true} do {
				_units = if (isMultiplayer) then {playableUnits} else {switchableUnits};
				_countall = count _units;
				_counter = 0;
				{
					if (!alive _x || (_x call FUNC(isUncon))) then {
						INC(_counter);
					};
				} forEach _units;
				if (_counter == _countall) exitWith {
					GVAR(mission_end) = true;
					publicVariable QGVAR(mission_end);
				};
				sleep 1;
			};
		};
	};
};

// BE AWARE...
// maximum number of bits is 24 !!!!!

// create a new numeric bit array (default all bits are eihter 0 or false)
// parameters: size of the numeric bit array, true = boolean bit array, false = numeric bit array
// example: _newBitArray = [8, false] call FUNC(NumBitArrayNew);
// result:  _newBitArray = [0,0,0,0,0,0,0,0];
// example: _newBitArray = [8, true] call FUNC(NumBitArrayNew);
// result:  _newBitArray = [false,false,false,false,false,false,false,false];
FUNC(BitArrayNew) = {
	private ["_nar","_val"];
	PARAMS_2(_size,_ty);
	_nar = [];_nar resize _size;
	_val = if (_ty) then {false} else {0};
	for "_i" from 0 to (_size - 1) do {_nar set [_i, _val]};
	_nar
};

// set one bit of the bit array to a new value
// parameters: bit array, bit number, on or off (true or false)
// example: _setBitArray = [_myBitarray, 5, true] call FUNC(BitArraySetBit);
FUNC(BitArraySetBit) = {
	PARAMS_3(_ar,_bit,_onoff);
	if (count _ar == 0) exitWith {_ar};
	if ((typeName (_ar select 0)) == "SCALAR") then {_onoff = if (_onoff) then {1} else {0}};
	if (_bit >= 0 && _bit < count _ar) then {_ar set [_bit, _onoff]};
	_ar
};

// set all bits of the bit array to a new value
// parameters: bit array, on or off (true or false, 0 or 1)
// example: _setAllBitArray = [_myBitarray, true] call FUNC(BitArraySetAll);
// example: _setAllNumBitArray = [_myNumBitarray, 1] call FUNC(BitArraySetAll);
FUNC(BitArraySetAll) = {
	PARAMS_2(_ar,_onoff);
	if (count _ar == 0) exitWith {_ar};
	if ((typeName (_ar select 0)) == "SCALAR") then {_onoff = if (_onoff) then {1} else {0}};
	for "_i" from 0 to (count _ar - 1) do {_ar set [_i, _onoff]};
	_ar
};

// helper function
FUNC(BitArrayAddFront) = {
	private ["_h","_val"];
	PARAMS_2(_ar,_n);
	_h = [];_h resize _n;
	_val = if ((typeName (_ar select 0)) == "SCALAR") then {0} else {false};
	for "_i" from 0 to (_n - 1) do {_h set [_i, _val]};
	([_h, _ar] call BIS_fnc_arrayPush)
};

// performans an And operation between two bit arrays, if the size is not equal, false or 0 will be added to beginning of the array with less elements
// The bitwise AND operation returns true if both operands are true, and returns false if one or both operands are false.
// parameters: bitArray1, bitArray2
// example: _andBitArray = [bitArray1, bitArray2] call FUNC(BitArrayAnd);
FUNC(BitArrayAnd) = {
	private ["_ar1","_ar2","_ret"];
	_ar1 =+ _this select 0;_ar2 =+ _this select 1;
	_ret = [];
	if (count _ar1 > count _ar2) then {
		_ar2 = [_ar2, count _ar1 - count _ar2] call FUNC(BitArrayAddFront);
	} else {
		if (count _ar1 < count _ar2) then {
			_ar1 = [_ar1, count _ar2 - count _ar1] call FUNC(BitArrayAddFront);
		};
	};
	_ret resize (count _ar1);
	if ((typeName (_ar1 select 0)) == "SCALAR") then {
		for "_i" from 0 to (count _ar1 - 1) do {_ret set [_i, if (((_ar1 select _i) == 1) && ((_ar2 select _i) == 1)) then {1} else {0}]};
	} else {
		for "_i" from 0 to (count _ar1 - 1) do {_ret set [_i, ((_ar1 select _i) && (_ar2 select _i))]};
	};
	_ret
};

// inverts all bits in the bit array
// parameters: bitArray (no brackets)
// example: _notBitArray = bitArray call FUNC(BitArrayNot);
FUNC(BitArrayNot) = {
	private "_ar";
	_ar = _this;
	if ((typeName (_ar select 0)) == "SCALAR") then {
		for "_i" from 0 to (count _ar - 1) do {_ar set [_i, abs((_ar select _i) - 1)]};
	} else {
		for "_i" from 0 to (count _ar - 1) do {_ar set [_i, !(_ar select _i)]};
	};
	_ar
};

// performans an Or operation between two bit arrays, if the size is not equal, false or 0 will be added to beginning of the array with less elements
// The bitwise OR operation returns true if one or both operands are true, and returns false if both operands are false.
// parameters: bitArray1, bitArray2
// example: _orBitArray = [bitArray1, bitArray2] call FUNC(BitArrayOr);
FUNC(BitArrayOr) = {
	private ["_ar1","_ar2","_ret"];
	_ar1 =+ _this select 0;_ar2 =+ _this select 1;
	_ret = [];
	if (count _ar1 > count _ar2) then {
		_ar2 = [_ar2, count _ar1 - count _ar2] call FUNC(BitArrayAddFront);
	} else {
		if (count _ar1 < count _ar2) then {
			_ar1 = [_ar1, count _ar2 - count _ar1] call FUNC(BitArrayAddFront);
		};
	};
	_ret resize (count _ar1);
	if ((typeName (_ar1 select 0)) == "SCALAR") then {
		for "_i" from 0 to (count _ar1 - 1) do {_ret set [_i, ((_ar1 select _i) == 1) || ((_ar2 select _i) == 1)]};
	} else {
		for "_i" from 0 to (count _ar1 - 1) do {_ret set [_i, (_ar1 select _i) || (_ar2 select _i)]};
	};
	_ret
};

// performans an XOr operation between two bit arrays, if the size is not equal, false will be added to beginning of the array with less elements
// The bitwise exclusive OR operation returns true if exactly one operand is true, and returns false if both operands have the same Boolean value.
// parameters: bitArray1, bitArray2
// example: _xorBitArray = [bitArray1, bitArray2] call FUNC(BitArrayXOr);
FUNC(BitArrayXOr) = {
	private ["_ar1","_ar2","_ret"];
	_ar1 =+ _this select 0;_ar2 =+ _this select 1;
	_ret = [];
	if (count _ar1 > count _ar2) then {
		_ar2 = [_ar2, count _ar1 - count _ar2] call FUNC(BitArrayAddFront);
	} else {
		if (count _ar1 < count _ar2) then {
			_ar1 = [_ar1, count _ar2 - count _ar1] call FUNC(BitArrayAddFront);
		};
	};
	_ret resize (count _ar1);
	if ((typeName (_ar1 select 0)) == "SCALAR") then {
		for "_i" from 0 to (count _ar1 - 1) do {_ret set [_i, (((_ar1 select _i) == 1) || ((_ar2 select _i) == 1)) && !(((_ar1 select _i) == 1) && ((_ar2 select _i) == 1))]};
	} else {
		for "_i" from 0 to (count _ar1 - 1) do {_ret set [_i, ((_ar1 select _i) || (_ar2 select _i)) && !((_ar1 select _i) && (_ar2 select _i))]};
	};
	_ret
};

// converts an integer number to a bit array, only 24 bit numbers are supported
// parameters: integer number (without brackets), true = boolean bit array, false = numeric bit array
// example: _bitArrayFromNum = [5000, true] call FUNC(NumToBitArray);
FUNC(NumToBitArray) = {
	private ["_ret","_true","_false"];
	PARAMS_2(_num,_ty);
	_ret = [];
	_true = if (_ty) then {true} else {1};
	_false = if (_ty) then {false} else {0};
	for "_i" from 31 to 0 step -1 do {
		_val = _num mod 2 ^ _i;
		_ret set [count _ret, (if (_val == _num) then {_false} else {_true})];
		_num = _val;
	};
	_ret
};

// converts a boolean bit array to a numeric (0/1) bit array
// parameters: bit array (without brackets)
// example _numbitarray = _bitarray call FUNC(BitArrayToNumBitArray);
FUNC(BitArrayToNumBitArray) = {
	private ["_ret","_ba"];
	_ba = _this;_ret = [];_ret resize (count _ba);
	{_ret set [_forEachIndex, (if (_x) then {1} else {0})]} forEach _ba;
	_ret
};

// converts a numeric (0/1) bit array to a boolean bit array
// parameters: nummeric bit array (without brackets)
// example _bitarray = _numbitarray call FUNC(NumBitArrayToBitArray);
FUNC(NumBitArrayToBitArray) = {
	private ["_ret","_ba"];
	_ba = _this;_ret = [];_ret resize (count _ba);
	{_ret set [_forEachIndex, _x == 1]} forEach _ba;
	_ret
};

// converts a bit array to an integer number
// parameters: bit array (without brackets)
// example: _numfrombitarray = _myBitArray call FUNC(BitArrayToNum);
FUNC(BitArrayToNum) = {
	private ["_ar","_ret"];
	_ar = _this;_ret = 0;
	if (count _ar > 0) then {
		_xx = count _ar - 1;
		if ((typeName (_ar select 0)) == "SCALAR") then {
			for "_i" from 0 to (count _ar - 1) do {
				_ret = _ret + ((_ar select _i) * 2 ^ _xx);
				DEC(_xx);
			};
		} else {
			for "_i" from 0 to (count _ar - 1) do {
				_ret = _ret + ((if (_ar select _i) then {1} else {0}) * 2 ^ _xx);
				DEC(_xx);
			};
		};
	};
	_ret
};

// converts an integer number to a bit array, number of bits can be set
// parameters: integer number, bit number (integer), true = boolean bit array, false = numeric bit array
// example: _bitArrayFromNum = [5000,16,true] call FUNC(NumToBitArray2);
FUNC(NumToBitArray2) = {
	private ["_ret","_true","_false"];
	PARAMS_3(_num,_bits,_ty);
	DEC(_bits);
	_true = if (_ty) then {true} else {1};
	_false = if (_ty) then {false} else {0};
	_ret = [];
	for "_i" from _bits to 0 step -1 do {
		_val = _num mod 2 ^ _i;
		_ret set [count _ret, (_val != _num)];
		_num = _val;
	};
	_ret
};

colum_sys_wounds_healAI={
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	(_this select 0) setdamage 0;
	player removeMagazine KIT;
};


// Events
[QGVAR(wn), {_this call FUNC(handlenet)}] call CBA_fnc_addEventHandler;
[QGVAR(wn), {_this call FUNC(handlenet2)}] call CBA_fnc_addLocalEventHandler;
[QGVAR(aim), {_this playMove "AinvPknlMstpSlayWrflDnon_medic"}] call CBA_fnc_addLocalEventHandler;
[QGVAR(a1), {_this playMove "AinjPfalMstpSnonWnonDf_carried_dead"}] call CBA_fnc_addLocalEventHandler;
[QGVAR(a2), {_this  playMove "acinPercMstpSrasWrflDnon"}] call  CBA_fnc_addLocalEventHandler; // With rifle
[QGVAR(a21), {_this  playMove "acinPercMstpSnonWnonDnon"}] call CBA_fnc_addLocalEventHandler; // Without a weapon
[QGVAR(a22), {_this  playMove "acinPercMstpSnonWpstDnon"}] call CBA_fnc_addLocalEventHandler; // pistol
[QGVAR(a3), {_this switchMove "AinjPpneMrunSnonWnonDb_grab"}] call CBA_fnc_addEventHandler;
[QGVAR(a4), {_this switchMove "AinjPpneMstpSnonWnonDnon"}] call CBA_fnc_addEventHandler;
[QGVAR(aswmnon), {_this switchMove ""}] call CBA_fnc_addEventHandler;
[QGVAR(dir), {_this setDir 180}] call CBA_fnc_addEventHandler;
[QGVAR(cap), {(_this select 0) setCaptive (_this select 1)}] call CBA_fnc_addEventHandler;
[QGVAR(addDloc), {if (local (_this select 0)) then {[_this select 0,"",_this select 1,objNull,""] call FUNC(hd)}}] call CBA_fnc_addEventHandler;
[QGVAR(blo), {if (local (_this select 0)) then {_this call ace_blackoutall}}] call CBA_fnc_addEventHandler; // still used ? Couldn't find any reference
[QGVAR(remove_mag), {PARAMS_2(_unit,_item); if (local _unit) then { _unit removeMagazine _item } }] call CBA_fnc_addEventHandler;
[QGVAR(remove_ruckmag), {PARAMS_2(_unit,_item); if (local _unit) then { [_unit, "MAG", _item, 1] call ACE_fnc_RemoveGear } }] call CBA_fnc_addEventHandler;
[QGVAR(burnmen), {_this spawn FUNC(burnmen)}] call CBA_fnc_addEventHandler;
[QGVAR(burnoff), {_this setVariable ["ace_is_burning",false]}] call CBA_fnc_addEventHandler;
[QGVAR(checkburn), { if (local (_this select 0)) then { _this spawn FUNC(checkburn) } }] call CBA_fnc_addEventHandler;
[QGVAR(checkdrag), {_this spawn FUNC(checkdrag)}] call CBA_fnc_addLocalEventHandler;
[QGVAR(selLeader), {if (local (leader (_this select 0))) then {(_this select 0) selectLeader (_this select 1)}}] call CBA_fnc_addEventHandler;

["CBA_MISSION_START", { TRACE_1("Applying Medical Gear",GVAR(medical_gear_units)); {_x call FUNC(addMedicalInt)} forEach GVAR(medical_gear_units)}] call CBA_fnc_addEventHandler;

[QUOTE(GVAR(examunit)), { _this call FUNC(examunit) }] call CBA_fnc_addEventHandler;
[QGVAR(examansw), { _this call FUNC(examansw2) }] call CBA_fnc_addEventHandler; // TODO; move to clientInit?

[QGVAR(help), {if (local (_this select 1)) then { _this spawn FUNC(help) } }] call CBA_fnc_addEventHandler;
[QGVAR(heal), {_this call FUNC(heal)}] call CBA_fnc_addLocalEventHandler;
[QGVAR(surg), {_this call FUNC(surg)}] call CBA_fnc_addLocalEventHandler;
[QGVAR(surg_abort), { PARAMS_1(_unit); _unit setVariable ["ace_w_healing_r", false] }] call CBA_fnc_addLocalEventHandler;

// BWC
[QGVAR(rev2), {
	if (!isNil "ace_wounds_rcode1") then {
		call compile format ["%1", ace_wounds_rcode1];
	};
}] call CBA_fnc_addEventHandler;


ADDON = true;
