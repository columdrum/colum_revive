#include "script_component.hpp"
//_foo = [player, player, "null"] execFSM ("\x\addons\ace\sys_spectator\specta.fsm");
_foo = [player, player, "null"] spawn COMPILE_FILE(specta);
