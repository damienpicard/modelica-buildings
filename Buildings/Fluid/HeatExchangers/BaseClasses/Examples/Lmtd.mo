within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model Lmtd
  Modelica.Blocks.Sources.Ramp ramp(height=10, duration=10)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  Buildings.Fluid.HeatExchangers.BaseClasses.lmtd()
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  annotation (__Dymola_DymolaStoredErrors(thetext="model Lmtd
  Modelica.Blocks.Sources.Ramp ramp(height=10, duration=10)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    
equation
  Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(273.15 + )
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Lmtd;
"));
end Lmtd;
