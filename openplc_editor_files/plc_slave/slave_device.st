PROGRAM program0
  VAR
    Recieve_Signal AT %IX0.0 : BOOL;
    LED AT %QX0.0 : BOOL;
  END_VAR

  LED := Recieve_Signal;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
