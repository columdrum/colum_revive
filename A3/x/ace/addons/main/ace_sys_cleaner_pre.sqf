GVAR(clean_array) = [];

GVAR(fifo) = [[], []] call CBA_fnc_hashCreate;
//GVAR(sfifo) = [[], []] call CBA_fnc_hashCreate;
GVAR(sfifo_index) = [];
GVAR(sfifo_array) = [];

PREPMAIN(handleFifoExplosives);

FUNC(pushStack) = {
	{
		(_this select 0) set [count (_this select 0), _x];
	} foreach (_this select 1);
	(_this select 0)
};

execFSM QUOTE(PATHTOF(Cleaner.fsm));
execFSM QUOTE(PATHTOF(SlowFifo.fsm));