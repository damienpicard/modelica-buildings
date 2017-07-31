within Buildings.ChillerWSE.Examples.BaseClasses.Controls;
model CoolingTowerSpeedControl "Controller for the fan speed in cooling towers"
  extends Buildings.ChillerWSE.BaseClasses.PartialControllerInterface(
    final use_Controller=true);
  Modelica.Blocks.Interfaces.RealInput cooMod
    "Cooling mode - 0: free cooling mode; 1: partially mechanical cooling; 2: fully mechanical cooling"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  .Buildings.Controls.Continuous.LimPID conPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    wp=wp,
    wd=wd,
    Ni=Ni,
    Nd=Nd,
    initType=initType,
    xi_start=xi_start,
    xd_start=xd_start,
    y_start=yCon_start,
    reverseAction=reverseAction,
    y_reset=y_reset,
    reset=reset) "PID controller"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Interfaces.RealInput CHWST_set(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput CWST_set(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput CHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature " annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-74}), iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput CWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature " annotation (
      Placement(transformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-120,-40})));
  Modelica.Blocks.Math.RealToBoolean fmcMod(threshold=1.5)
    "Fully mechanical cooling mode"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
protected
  Modelica.Blocks.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Modelica.Blocks.Logical.Switch swi2
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-60})));
public
  Modelica.Blocks.Sources.Constant uni(k=1) "Unit"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Sources.BooleanExpression pmcMod(y=if cooMod < 1.5 and cooMod >
        0.5 then true else false) "Partially mechanical cooling mode"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
protected
  Modelica.Blocks.Logical.Switch swi3
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={74,0})));
public
  Modelica.Blocks.Interfaces.RealOutput y "Speed signal for cooling tower fans"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(cooMod, fmcMod.u)
    annotation (Line(points={{-120,40},{-120,40},{-82,40}}, color={0,0,127}));
  connect(CWST_set, swi1.u1) annotation (Line(points={{-120,80},{-48,80},{-48,58},
          {-32,58}}, color={0,0,127}));
  connect(CHWST_set, swi1.u3) annotation (Line(points={{-120,0},{-48,0},{-48,42},
          {-32,42}}, color={0,0,127}));
  connect(swi1.y, conPID.u_s) annotation (Line(points={{-9,50},{0,50},{0,-40},{18,
          -40}}, color={0,0,127}));
  connect(fmcMod.y, swi2.u2) annotation (Line(points={{-59,40},{-54,40},{-54,-60},
          {-42,-60}}, color={255,0,255}));
  connect(CWST, swi2.u1) annotation (Line(points={{-120,-40},{-50,-40},{-50,-52},
          {-42,-52}}, color={0,0,127}));
  connect(CHWST, swi2.u3) annotation (Line(points={{-120,-74},{-120,-68},{-50,
          -68},{-42,-68}},      color={0,0,127}));
  connect(swi2.y, conPID.u_m)
    annotation (Line(points={{-19,-60},{30,-60},{30,-52}}, color={0,0,127}));
  connect(pmcMod.y, swi3.u2)
    annotation (Line(points={{41,0},{51.5,0},{62,0}}, color={255,0,255}));
  connect(uni.y, swi3.u1)
    annotation (Line(points={{41,40},{50,40},{50,8},{62,8}}, color={0,0,127}));
  connect(conPID.y, swi3.u3) annotation (Line(points={{41,-40},{50,-40},{50,-8},
          {62,-8}}, color={0,0,127}));
  connect(swi3.y, y)
    annotation (Line(points={{85,0},{110,0}}, color={0,0,127}));
  connect(fmcMod.y, swi1.u2) annotation (Line(points={{-59,40},{-54,40},{-54,50},
          {-32,50}}, color={255,0,255}));
  connect(trigger, conPID.trigger) annotation (Line(points={{-60,-100},{-60,-80},
          {22,-80},{22,-52}}, color={255,0,255}));
  connect(y_reset_in, conPID.y_reset_in) annotation (Line(points={{-90,-100},{
          -90,-100},{-90,-80},{0,-80},{0,-48},{18,-48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,80}}),                                   graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{132,116},{-124,168}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>This model describes a simple cooling tower speed controller for 
a chilled water system with integrated waterside economizers.
</p>
<p>The control logic are described in the following:</p>
<ul>
<li>When the system is in Fully Mechanical Cooling (FMC) mode, 
the cooling tower fan speed is controlled to maintain the condener water supply temperature (CWST) 
at or around the setpoint.
</li>
<li>When the system is in Partially Mechanical Cooling (PMC) mode, 
the cooling tower fan speed is set as 100&percnt; to make condenser water 
as cold as possible and maximize the waterside economzier output.
</li>
<li>When the system is in Free Cooling (FC) mode, 
the cooling tower fan speed is controlled to maintain the chilled water supply temperature (CHWST) 
at or around its setpoint.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerSpeedControl;
