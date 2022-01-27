/************************************************************************************************/
/* dr_strangepete (any questions - pete@shitnami.net)											*/
/* This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License. 	*/
/* http://creativecommons.org/licenses/by-sa/3.0/												*/
/************************************************************************************************/
/*	7:38pm
conventions:	dsp_fnc_xxx		- functions
      dsp_var_xxx		- internal
      dsp_uservar_xxx	- user loaded/set
      dsp_arp[_*]_*xxx	- prefix for profileNamespace
VARIABLES:
  {missionNamespace}
    dsp_uservar_randomEnabled 	[bool]
    dsp_uservar_timeout 		    [[min,max]]
    dsp_uservar_tail			      [int 0-100]
    dsp_uservar_respawnTime		  [seconds]
    dsp_uservar_respawnAlt      [meters]
    dsp_uservar_heli			      [str classname]
    dsp_uservar_weather			    [int overcast,int fog,bool rain]
    dsp_var_failureActive 		  [bool]
    dsp_var_heliName			      [str display name]
    dsp_var_heliClass		        [str classname]
    dsp_var_currentHeli         [object]
    dsp_var_respawnLock         [bool]
    dsp_var_respawnPath         [[pos],[vectorDir],[vectorUp]]
    dsp_var_suicideAction       [user-action index id]




  {profileNamespace}
    dsp_arp_randomEnabled 		  [bool]
    dsp_arp_timeout 			      [[min,max]]
    dsp_arp_tail				        [int 0-100]
    dsp_arp_heli				        [str classname]
    dsp_arp_time		        		[[hour,minute]]
    dsp_arp_weather				      [int overcast,int fog,bool rain]
    dsp_arp_lifetime			      [secret]
    dsp_arp_respawnTime         [seconds]
    dsp_arp_respawnAlt          [meters]
    dsp_arp_respawnLock         [bool]
    dsp_arp_respawnPath         [[pos],[vectorDir],[vectorUp]];
*/

#define IDC_DSP_DIALOG_HOUR	4354
#define IDC_DSP_DIALOG_MINUTE	4355
#define IDC_DSP_DIALOG_RESPAWNTIME 1403
#define IDC_DSP_DIALOG_RESPAWNALT 1404
#define IDC_DSP_DIALOG_FOG 1900
#define IDC_DSP_DIALOG_OVERCAST 1901
#define IDC_DSP_DIALOG_RAIN 2500
#define IDC_DSP_DIALOG_RESPAWNLOCK 2501

// swap comments for LOG() to disable logging - message > /dev/null
// #define LOG(STRING)
// #define LOG(STRING) systemchat ('DSP_debug @@##__LINE__##: ' + (format["%1",STRING]));
#define LOG(STRING) diag_log ('DSP_debug @@##__LINE__##: ' + (format["%1",STRING]));


dsp_arpVersion = profileNamespace getVariable ["dsp_arpVersion",0];
if((dsp_arpVersion < 2.4)) then {{profilenamespace setVariable [_x,nil];} forEach ["dsp_arp_randomEnabled","dsp_arp_timeout","dsp_arp_tail","dsp_arp_weather","dsp_arp_heli","dsp_arp_time","dsp_arp_respawnAlt","dsp_arp_respawnTime","dsp_arp_respawnPath"];diag_log "flushing all profile variables";}; /*can't forget to take out the trash of the past*/
if(((profileNamespace getVariable ["dsp_heli",""]) != "")) then {{profilenamespace setVariable [_x,nil];} forEach ["dsp_date","dsp_timer","dsp_wasrandom","dsp_heli"];diag_log "cleared old variables";}; /*can't forget to take out the trash of the past*/

dsp_arpVersion = 2.4; profileNamespace setVariable ["dsp_arpVersion",dsp_arpVersion];

  LOG("loading dsp_main " + str(dsp_arpVersion))

enableSaving [false,false];

// Dig for helicopters:
//Search rules - !isUav, 'Helicopter' parent class, scope==1 (not hidden)
dsp_var_heliClass = [];
dsp_var_heliName = [];
_index = 0;
_foundHeli = "(getNumber(_x >> 'scope') > 1) && ('Helicopter' in ([_x, true] call BIS_fnc_returnParents)) && (getNumber(_x >> 'isUav') < 1)" configClasses (configFile >> "CfgVehicles");

{
    dsp_var_heliClass set [_index, configName _x];
    dsp_var_heliName set [_index, getText(_x >> "displayName")];
    _index = _index + 1;
} forEach _foundHeli;

dsp_uservar_randomEnabled = (profileNamespace getVariable ["dsp_arp_randomEnabled",false]);
dsp_uservar_timeout = (profileNamespace getVariable ["dsp_arp_timeout",[10,45]]);
dsp_uservar_tail = (profileNamespace getVariable ["dsp_arp_tail",15]);
dsp_uservar_heli = (profileNamespace getVariable ["dsp_arp_heli",((missionNamespace getVariable ["dsp_var_heliClass",["B_Heli_light_01_F"]]) select 0)]);
dsp_uservar_weather = (profileNamespace getVariable ["dsp_arp_weather",[0,0,false]]);
dsp_uservar_respawnTime = (profileNamespace getVariable ["dsp_arp_respawnTime",7]);
dsp_uservar_respawnAlt = (profileNamespace getVariable ["dsp_arp_respawnAlt",100]);
dsp_uservar_respawnLock = (profileNamespace getVariable ["dsp_arp_respawnLock",false]);
dsp_uservar_respawnPath = (profileNamespace getVariable ["dsp_arp_respawnPath", []]);

dsp_var_failureActive = false;
dsp_var_loopCount = 0;
dsp_var_loopUnique = 0;

LOG("variables initialized")

//call compile preprocessFileLineNumbers "dsp_functions.sqf";
#include "dsp_functions.sqf";
#include "dsp_dialog_functions.sqf";
player onMapSingleClick {if(!_shift) then {_pos call dsp_fnc_diag_mapclick; openMap false;}};
call dsp_fnc_Init;
