// TODO: Stringtables, more conflict groups, addition to "All" UserActionGroups
class UserActionGroups {
	class PREFIX {
		name = "ACE controls";
		group[] = {"ace_sys_nvg_up","ace_sys_nvg_down"};
	};
};

class CfgDefaultKeysMapping {
	ace_sys_sys_nvg_up[] = {201};
	ace_sys_sys_nvg_down[] = {202};
};

class UserActionsConflictGroups {
	class ActionGroups {
		ace_sys_nvg[]={"ace_sys_nvg_up","ace_sys_nvg_down"};
	};
};
