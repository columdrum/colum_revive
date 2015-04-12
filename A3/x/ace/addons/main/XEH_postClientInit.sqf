#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

LOG(MSG_INIT);

ADDON = false;

// TODO: Update the variable / read realtime instead
GVAR(dismount_enabled) = (0 == 1);

#include "ace_sys_ladebalken_post.sqf"

//["UST mod", "Interaccion", [["ATV_Base_EP1"], [], 2, [QUOTE(PATHTO(fnc_menuDef_ATV)), "main"]], [DIK_LWIN,false,false,false]] call CBA_fnc_registerKeybindToFleximenu;
//[["ATV_Base_EP1"], [ace_sys_interaction_key], 2, [QUOTE(PATHTO(fnc_menuDef_ATV)), "main"]] call CBA_ui_fnc_add;


//[["ATV_Base_EP1"], [], 2, [QUOTE(PATHTO(fnc_menuDef_ATV)), "main"]] call CBA_ui_fnc_add;

ADDON = true;
