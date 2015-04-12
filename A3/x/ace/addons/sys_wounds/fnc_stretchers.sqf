/* ACE_Stretcher | (c) 2010 by rocko */

#include "script_component.hpp"

PARAMS_1(_stretcher);

_stretcher spawn {
	sleep 1;
	//_this lock true; // Locking stretcher is not good, blocks "pulling out units from vehicles"
};

_stretcher setVariable ["ace_stretcher_front_grab",false,true];
_stretcher setVariable ["ace_stretcher_back_grab",false,true];
