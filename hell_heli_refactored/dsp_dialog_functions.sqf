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

dsp_fnc_diag_overcastChanged = {
    if((sliderposition IDC_DSP_DIALOG_OVERCAST) < 75) then {
      ((findDisplay 3690) displayCtrl IDC_DSP_DIALOG_RAIN) cbSetChecked false;
      };
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_rainChanged = {
    if((_this select 1 == 1) && (sliderposition IDC_DSP_DIALOG_OVERCAST < 75)) then {
      slidersetposition [IDC_DSP_DIALOG_OVERCAST,80];
    };
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_rainCheck = {
    _ctrl = ((findDisplay 3690) displayCtrl IDC_DSP_DIALOG_RAIN);
    _value = cbChecked _ctrl;
    _ctrl cbSetChecked (!(_value));
    [_ctrl,1] call dsp_fnc_diag_rainChanged;
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_respawnlockChanged = {
    //if((_this select 1 == 1)) then {
    //enable
    //};
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_respawnlockCheck = {
    _ctrl = ((findDisplay 3690) displayCtrl IDC_DSP_DIALOG_RESPAWNLOCK);
    _value = cbChecked _ctrl;
    _ctrl cbSetChecked (!(_value));
    //[_ctrl,1] call dsp_fnc_diag_respawnlockChanged;
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_Populate = {
  LOG("Populate Settings Dialog")
    // 1400 - dsp_dialog_min
    // 1401 - dsp_dialog_max
    // 1402 - dsp_dialog_tailChance
    //
    // 1600 - dsp_dialog_timerApply
    // 1601 - dsp_dialog_weatherApply
    //
    // 1900 - dsp_dialog_fog
    // 1901 - dsp_dialog_overcast
    //
    // IDC_DSP_DIALOG_HOUR
    // IDC_DSP_DIALOG_MINUTE
    // IDC_DSP_DIALOG_RESPAWNTIME
    // IDC_DSP_DIALOG_RESPAWNALT
    // IDC_DSP_DIALOG_FOG
    // IDC_DSP_DIALOG_OVERCAST
    // IDC_DSP_DIALOG_RAIN
    // IDC_DSP_DIALOG_RESPAWNLOCK
    //
    // 2500 - dsp_dialog_rain
    // 2501 - dsp_dialog_waypoints
    // 2502 - dsp_dialog_combat
    if(dsp_var_failureActive) then {
      missionNamespace setVariable ["dsp_var_failureActive",false];
      (vehicle player) setDamage 0;
      (vehicle player) engineOn true;
    };
    player action ["AutoHover",(vehicle player)];
    (vehicle player) setVectorUp [0,0,1];
    (vehicle player) setVelocity [0,0,0];

    _lastRandom = dsp_uservar_randomEnabled;
    if(_lastRandom) then {dsp_uservar_randomEnabled = false;};
    waitUntil {dialog};
      disableSerialization;
      _disp = findDisplay 3690;

      ctrlSetText [1400,str (dsp_uservar_timeout select 0)];
      ctrlSetText [1401,str (dsp_uservar_timeout select 1)];
      ctrlSetText [1402,str (dsp_uservar_tail)];

      sliderSetRange [IDC_DSP_DIALOG_FOG,0,100]; //fog
      sliderSetPosition [IDC_DSP_DIALOG_FOG,(dsp_uservar_weather select 1)];
      sliderSetRange [IDC_DSP_DIALOG_OVERCAST,0,100]; //overcast

      if((dsp_uservar_weather select 2) && ((dsp_uservar_weather select 0) < 75)) then {
        sliderSetPosition [IDC_DSP_DIALOG_OVERCAST,75];
      } else {
        sliderSetPosition [IDC_DSP_DIALOG_OVERCAST,(dsp_uservar_weather select 0)];
      };
      (_disp displayCtrl IDC_DSP_DIALOG_RAIN) cbSetChecked (dsp_uservar_weather select 2);

      _ctrlTime = profileNamespace getVariable ["dsp_arp_time",[18,0]];
      for[{_i=0},{_i<=23},{_i=_i+1}] do {
        _index = lbAdd [IDC_DSP_DIALOG_HOUR,str(_i)];
        lbSetValue [IDC_DSP_DIALOG_HOUR,_index,_i];
        };
        lbSetCurSel [IDC_DSP_DIALOG_HOUR,(_ctrlTime select 0)];
      for[{_i=0},{_i<=55},{_i=_i+5}] do {
        _index = lbAdd [IDC_DSP_DIALOG_MINUTE,str(_i)];
        lbSetValue [IDC_DSP_DIALOG_MINUTE,_index,_i];
        };
        lbSetCurSel [IDC_DSP_DIALOG_MINUTE,((_ctrlTime select 1)/5)]; // divide profile-saved value (actual time) by 5 to get index.

      ctrlSetText [IDC_DSP_DIALOG_RESPAWNTIME, str(dsp_uservar_respawnTime)];
      ctrlSetText [IDC_DSP_DIALOG_RESPAWNALT, str(dsp_uservar_respawnAlt)];
      (vehicle player) setVelocity [0,0,0]; //initial movement stop
    _nil = [_lastRandom] spawn {waitUntil {!dialog};player action ["AutoHoverCancel",(vehicle player)];if(_this select 0) then {dsp_uservar_randomEnabled = true;_nil = [vehicle player] spawn dsp_fnc_randomLoop;};};

    if (difficultyEnabledRTD) then { //Rotorlib support - autohover doesn't work so we need to loop and freeze our location:
      _nil = [] spawn { while {dialog} do {(vehicle player) setVelocity [0,0,0];waitUntil{true};};};
    };
};

//////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
dsp_fnc_diag_setTime = {
    private ["_ctrlHour","_ctrlMinute"];
    _ctrlHour = lbValue[IDC_DSP_DIALOG_HOUR,(lbCurSel IDC_DSP_DIALOG_HOUR)];
    _ctrlMinute = lbValue[IDC_DSP_DIALOG_MINUTE, (lbCurSel IDC_DSP_DIALOG_MINUTE)];
LOG("setTime = " + str(_ctrlHour) + ":" + str(_ctrlMinute))
    setDate [date select 0,date select 1,date select 2,_ctrlHour-1,_ctrlMinute];
    profileNamespace setVariable ["dsp_arp_time",[_ctrlHour,_ctrlMinute]];

    if((daytime >= 4) && (daytime <= 20)) then {
    player action ["NVGogglesOff"];
    } else {
    player action ["NVGoggles"];
    };
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_respawnTime = {
    _newTime = parseNumber ([(ctrlText IDC_DSP_DIALOG_RESPAWNTIME),"0123456789"] call BIS_fnc_filterString);
    if (_newTime < 1) then {_newTime = 1};
    ctrlSetText [IDC_DSP_DIALOG_RESPAWNTIME, str(_newTime)];
    missionNamespace setVariable ["dsp_uservar_respawnTime", _newTime];
    profileNamespace setVariable ["dsp_arp_respawnTime", _newTime];
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_respawnAlt = {
    _newAlt = parseNumber([(ctrlText IDC_DSP_DIALOG_RESPAWNALT),"0123456789"] call BIS_fnc_filterString);
    if (_newAlt < 1) then { _newAlt = 1 };
    ctrlSetText [IDC_DSP_DIALOG_RESPAWNALT, str(_newAlt)];
    missionNamespace setVariable ["dsp_uservar_respawnAlt", _newAlt];
    profileNamespace setVariable ["dsp_arp_respawnAlt", _newAlt];
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_mapClick = {
LOG("Map click: " + str(_this))
    _pos = _this;
    _newpos = [_pos select 0, _pos select 1, (getPos dsp_var_currentHeli select 2)];
    [dsp_var_currentHeli, _newpos] spawn dsp_fnc_changeHeli;
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_timerApply = 	{
LOG("timerApply")
    private ["_ctrlMin","_ctrlMax","_ctrlTail"];
    _ctrlMin = parseNumber ([ctrlText 1400,"0123456789"] call BIS_fnc_filterString);
    _ctrlMax = parseNumber ([ctrlText 1401,"0123456789"]call BIS_fnc_filterString);
    _ctrlTail = parseNumber ([ctrlText 1402,"0123456789"] call BIS_fnc_filterString);
    if(_ctrlMin <= 0) then { _ctrlMin = 1};
    if(_ctrlMin >= _ctrlMax) then {_ctrlMax = _ctrlMin + 1};
    if(_ctrlTail > 100) then {_ctrlTail = 100};
    missionNamespace setVariable ["dsp_uservar_timeout",[_ctrlMin,_ctrlMax]];
    missionNamespace setVariable ["dsp_uservar_tail",_ctrlTail];
    profilenamespace SetVariable ["dsp_arp_timeout",[_ctrlMin,_ctrlMax]];
    profilenamespace setVariable ["dsp_arp_tail",_ctrlTail];
};

//////////////////////////////////////////////////////////////////////////////////////

dsp_fnc_diag_weatherApply = {
LOG("weatherApply")
    call dsp_fnc_diag_setTime;
    skipTime -1;
    _disp = findDisplay 3690;
    _rainCtrl = (_disp displayCtrl IDC_DSP_DIALOG_RAIN);
    _overcast = sliderPosition IDC_DSP_DIALOG_OVERCAST;
    if((cbChecked _rainCtrl)) then {
      if(_overcast < 75) then {3600 setOvercast 0.75;_overcast = 75;} else { 3600 setOvercast (_overcast) * 0.01;};
      3000 setRain (0.4 + ((random 6)*0.1));
    } else {
      3600 setOvercast (sliderPosition IDC_DSP_DIALOG_OVERCAST) * 0.01;
      3600 setRain 0;
    };
    sliderSetPosition [IDC_DSP_DIALOG_OVERCAST,(_overcast)];
    3600 setFog (sliderPosition IDC_DSP_DIALOG_FOG) * 0.005;
    skipTime 1;
    simulWeatherSync;
    missionNamespace setVariable ["dsp_uservar_weather",[(_overcast),(sliderPosition IDC_DSP_DIALOG_FOG),(cbChecked _rainCtrl)]];
    profileNamespace setVariable ["dsp_arp_weather",[(_overcast),(sliderPosition IDC_DSP_DIALOG_FOG),(cbChecked _rainCtrl)]];
    saveProfileNamespace;
  };

//////////////////////////////////////////////////////////////////////////////////////
