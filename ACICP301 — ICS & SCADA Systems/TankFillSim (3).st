(* TankFillSim.st
   Based on the Lab 03 TankFill control logic, with added simulation code
   so the tank level rises and falls on its own (no physical sensor needed).

   Hardware-mapped points are declared VAR_GLOBAL inside CONFIGURATION
   (with AT), then used inside the program via VAR_EXTERNAL, which is the
   pattern OpenPLC's compiler (matiec) expects for exposing points over Modbus.
     Tank level -> %IW80  (Modbus Input Register 80)
     Fill valve -> %QX0.0 (Modbus Coil 0)
*)

PROGRAM TankFillSim
  VAR_EXTERNAL
    TankLevel_LIT : INT;
    TankValveOpen : BOOL;
  END_VAR

  VAR
    (* --- Lab 03 variables --- *)
    TankFillAuto_Cmd   : BOOL := FALSE;
    Estop_Cmd          : BOOL := FALSE;
    TankLevelHi_Alarm  : BOOL := FALSE;
    TankLevelLo_Alarm  : BOOL := FALSE;

    TankEmpty_SP        : INT := 20;  (* 2.0 ft *)
    TankFull_SP         : INT := 80;  (* 8.0 ft *)
    TankLoAlarm_SP      : INT := 10;  (* 1.0 ft *)
    TankHiAlarm_SP      : INT := 90;  (* 9.0 ft *)

    (* --- simulation-only variables --- *)
    SimTimer  : TON;
    SimInit   : BOOL := FALSE;
  END_VAR

  (* Give the simulated level a starting value of 2.0 ft on the first scan
     (VAR_EXTERNAL/located variables cannot take an initializer directly). *)
  IF NOT SimInit THEN
    TankLevel_LIT := 20;
    SimInit := TRUE;
  END_IF;

  (* ===== Simulated process: fill or drain the tank one step at a time ===== *)
  SimTimer(IN := NOT SimTimer.Q, PT := T#500ms);
  IF SimTimer.Q THEN
    IF TankValveOpen AND (TankLevel_LIT < 100) THEN
      TankLevel_LIT := TankLevel_LIT + 1;
    ELSIF (NOT TankValveOpen) AND (TankLevel_LIT > 0) THEN
      TankLevel_LIT := TankLevel_LIT - 1;
    END_IF;
  END_IF;

  (* ===== Lab 03 control logic (unchanged) ===== *)

  (* Auto-start: latch ON when the level falls to the start setpoint *)
  IF TankLevel_LIT <= TankEmpty_SP THEN
    TankFillAuto_Cmd := TRUE;
  END_IF;

  (* Auto-stop / safety: latch OFF on full level, E-stop, or high alarm.
     Placed after the SET logic so it always has priority in the same scan. *)
  IF (TankLevel_LIT >= TankFull_SP) OR Estop_Cmd OR TankLevelHi_Alarm THEN
    TankFillAuto_Cmd := FALSE;
  END_IF;

  (* High-level alarm *)
  IF TankLevel_LIT >= TankHiAlarm_SP THEN
    TankLevelHi_Alarm := TRUE;
  ELSE
    TankLevelHi_Alarm := FALSE;
  END_IF;

  (* Low-level alarm *)
  IF TankLevel_LIT <= TankLoAlarm_SP THEN
    TankLevelLo_Alarm := TRUE;
  ELSE
    TankLevelLo_Alarm := FALSE;
  END_IF;

  (* Valve control: open only while auto-fill is commanded and no high alarm *)
  TankValveOpen := TankFillAuto_Cmd AND (NOT TankLevelHi_Alarm);

END_PROGRAM


CONFIGURATION Config0
  VAR_GLOBAL
    TankLevel_LIT AT %IW80  : INT;
    TankValveOpen AT %QX0.0 : BOOL;
  END_VAR

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#100ms, PRIORITY := 0);
    PROGRAM instance0 WITH task0 : TankFillSim;
  END_RESOURCE
END_CONFIGURATION
