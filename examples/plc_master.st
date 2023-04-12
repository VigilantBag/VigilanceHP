PROGRAM slave_device
  VAR
    Send_Slave AT %IX0.0 : BOOL := 0;
    Recieve_Slave AT %IX100.0 : BOOL := 0;
    Switch AT %QX0.0 : BOOL;
    LED AT %QX100.0 : BOOL;
  END_VAR
  VAR
    TON0 : TON;
    TOF0 : TOF;
    TON1 : TON;
    TOF1 : TOF;
  END_VAR

  TON0(EN := TRUE, IN := NOT(Send_Slave) AND NOT(Switch), PT := T#500ms);
  TOF0(EN := TON0.ENO, IN := TON0.Q, PT := T#500ms);
  Switch := TOF0.Q;
  TON1(EN := TRUE, IN := NOT(Recieve_Slave) AND NOT(LED), PT := T#500ms);
  TOF1(EN := TON1.ENO, IN := TON1.Q, PT := T#500ms);
  LED := TOF1.Q;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : slave_device;
  END_RESOURCE
END_CONFIGURATION
