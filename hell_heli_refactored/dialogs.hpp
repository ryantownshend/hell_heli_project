/************************************************************************************************/
/* dr_strangepete (any questions - pete@shitnami.net)											*/
/* This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License. 	*/
/* http://creativecommons.org/licenses/by-sa/3.0/												*/
/************************************************************************************************/
class DSP_DIALOG
{
	idd = 3690;
	movingenabled = true;
	enableSimulation = true;
	onLoad = "_nil = [] spawn dsp_fnc_diag_Populate;";
	class Controls
	{
		class RscFrame_1800: RscBackFrame
		{
			idc = 1800;

			x = 9 * GUI_GRID_W + GUI_GRID_X;
			y = 6.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 21 * GUI_GRID_W;
			h = 7.5 * GUI_GRID_H;
		};
    class RscText_1003: RscText
		{
			idc = 1003;

			text = $STR_dsp_randomTimeout;
			x = 20.2 * GUI_GRID_W + GUI_GRID_X;
			y = 6.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 9.1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class RscText_1001: RscText
		{
			idc = 1001;

			text = $STR_dsp_Min;
			x = 25.9 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class dsp_dialog_min: RscEdit
		{
			idc = 1400;
      onKeyUp = "call dsp_fnc_diag_timerApply;";

			text = "";
			x = 22.22 * GUI_GRID_W + GUI_GRID_X;
			y = 7.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_Seconds;
			sizeEx = 0.9 * GUI_GRID_H;
		};
		class RscText_1002: RscText
		{
			idc = 1002;

			text = $STR_dsp_Max;
			x = 25.9 * GUI_GRID_W + GUI_GRID_X;
			y = 9.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};

		class dsp_dialog_max: RscEdit
		{
			idc = 1401;
      onKeyUp = "call dsp_fnc_diag_timerApply;";

			text = "";
			x = 22.22 * GUI_GRID_W + GUI_GRID_X;
			y = 9.1 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_Seconds;
			sizeEx = 0.9 * GUI_GRID_H;
		};
		class RscText_1012: RscText
		{
			idc = 1012;

			text = $STR_dsp_tailFailureChance;
			x = 9.58 * GUI_GRID_W + GUI_GRID_X;
			y = 6.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 10 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
    class RscText_1013: RscText
		{
			idc = 1013;

			text = "%";
			x = 15.81 * GUI_GRID_W + GUI_GRID_X;
			y = 7.6 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class dsp_dialog_tailChance: RscEdit
		{
			idc = 1402;
      onKeyUp = "call dsp_fnc_diag_timerApply;";

			text = "";
			x = 12.22 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_tailChance;
			sizeEx = 0.9 * GUI_GRID_H;
		};
    /*
    class RscText_1016: RscTextButton
		{
			idc = 1016;
      onMouseButtonClick = "call dsp_fnc_diag_respawnlockCheck;";

			text = "respawn lock";
			x = 12.02 * GUI_GRID_W + GUI_GRID_X;
			y = 9.1 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "respawn to saved pos";
			sizeEx = 0.8 * GUI_GRID_H;
		};
    class dsp_dialog_respawnLock: RscCheckbox
    {
      idc = IDC_DSP_DIALOG_RESPAWNLOCK;
      onCheckedChanged = "call dsp_fnc_diag_respawnlockChanged;";

      x = 11 * GUI_GRID_W + GUI_GRID_X;
      y = 9.1 * GUI_GRID_H + GUI_GRID_Y;
      w = 1 * GUI_GRID_W;
      h = 1 * GUI_GRID_H;
      sizeEx = 1 * GUI_GRID_H;
    };
    */

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// WEATHER FRAME /////////////////////////////////////////////////////////////////////////////////
		class RscFrame_1801: RscBackFrame
		{
			idc = 1801;

			x = 9 * GUI_GRID_W + GUI_GRID_X;
			y = 14.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 21 * GUI_GRID_W;
			h = 4.5 * GUI_GRID_H;
		};
		class RscText_1007: RscText
		{
			idc = 1007;

			text = $STR_dsp_weather;
			x = 10.44 * GUI_GRID_W + GUI_GRID_X;
			y = 14.62 * GUI_GRID_H + GUI_GRID_Y;
			w = 12 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.89 * GUI_GRID_H;
		};
		class dsp_dialog_fog: RscSlider
		{
			idc = IDC_DSP_DIALOG_FOG;
			//onSliderPosChanged = "";

			x = 18.6 * GUI_GRID_W + GUI_GRID_X;
			y = 14.9 * GUI_GRID_H + GUI_GRID_Y;
			w = 6.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_fog;
		};
		class RscText_1004: RscText
		{
			idc = 1004;

			text = $STR_dsp_fog;
			x = 24.9 * GUI_GRID_W + GUI_GRID_X;
			y = 15.1 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class RscText_1005: RscText
		{
			idc = 1005;

			text = $STR_dsp_overcast;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 16.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class dsp_dialog_overcast: RscSlider
		{
			idc = IDC_DSP_DIALOG_OVERCAST;
			onKillFocus = "call dsp_fnc_diag_overcastChanged;";
			onMouseButtonUp = "call dsp_fnc_diag_overcastChanged;";

			x = 18.6 * GUI_GRID_W + GUI_GRID_X;
			y = 16.3 * GUI_GRID_H + GUI_GRID_Y;
			w = 6.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_overcast;
		};
		class RscText_1006: RscText
		{
			idc = 1006;

			text = $STR_dsp_time;
			x = 24.99 * GUI_GRID_W + GUI_GRID_X;
			y = 17.93 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class dsp_dialog_weatherApply: RscButton
		{
			idc = 1601;
			action = "call dsp_fnc_diag_weatherApply";

			text = $STR_dsp_Apply;
			x = 10.9 * GUI_GRID_W + GUI_GRID_X;
			y = 17.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.9 * GUI_GRID_H;
		};
		class RscText_1008: RscTextButton
		{
			idc = 1008;
      onMouseButtonClick = "call dsp_fnc_diag_rainCheck;";

			text = $STR_dsp_rain;
			x = 12.02 * GUI_GRID_W + GUI_GRID_X;
			y = 16 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_rain;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class dsp_dialog_rain: RscCheckbox
		{
			idc = IDC_DSP_DIALOG_RAIN;
			onCheckedChanged = "call dsp_fnc_diag_rainChanged;";

			text = $STR_dsp_rain;
			x = 11 * GUI_GRID_W + GUI_GRID_X;
			y = 16 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.1 * GUI_GRID_W;
			h = 1.1 * GUI_GRID_H;
			tooltip = $STR_dsp_rain;
			sizeEx = 1 * GUI_GRID_H;
		};
		class dsp_dialog_hour: RscCombo
		{
			idc = IDC_DSP_DIALOG_HOUR;
			x = 18.4 * GUI_GRID_W + GUI_GRID_X;
			y = 17.8 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.25 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_Hour;
		};
		class dsp_dialog_minute: RscCombo
		{
			idc = IDC_DSP_DIALOG_MINUTE;
			x = 21.8 * GUI_GRID_W + GUI_GRID_X;
			y = 17.8 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.25 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_Minute;
		};

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// RESPAWN OPTS FRAME ////////////////////////////////////////////////////////////////////////////

    class RscText_1014: RscText
		{
			idc = 1014;

			text = $STR_dsp_respawnDelay;
			x = 9.58 * GUI_GRID_W + GUI_GRID_X;
			y = 10.96 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
		class dsp_dialog_respawnTime: RscEdit
		{
			idc = IDC_DSP_DIALOG_RESPAWNTIME;
			onKeyUp = "call dsp_fnc_diag_respawnTime;";
			text = "6";
			x = 12.22 * GUI_GRID_W + GUI_GRID_X;
			y = 12.22 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_Seconds;
			sizeEx = 0.9 * GUI_GRID_H;
		};
		class RscText_1015: RscText
		{
			idc = 1015;

			text = $STR_dsp_respawnAltitude;
			x = 20 * GUI_GRID_W + GUI_GRID_X;
			y = 10.96 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.8 * GUI_GRID_H;
		};
    class dsp_dialog_respawnAlt: RscEdit
		{
			idc = IDC_DSP_DIALOG_RESPAWNALT;
			onKeyUp = "call dsp_fnc_diag_respawnAlt;";
			text = "100";
			x = 22.22 * GUI_GRID_W + GUI_GRID_X;
			y = 12.22 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = $STR_dsp_Meters;
			sizeEx = 0.9 * GUI_GRID_H;
		};
	};
};
