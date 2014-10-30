within Buildings.Utilities.IO.Python27.Examples;
model KalmanFilter
  "Kalman filter implemented in Python and called from Modelica"
  extends Modelica.Icons.Example;
  Real_Real ran(
    nDblWri=1,
    nDblRea=1,
    functionName="random",
    moduleName="KalmanFilter",
    samplePeriod=samplePeriod) "Generate a random number in Python"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Real_Real kalFil(
    moduleName="KalmanFilter",
    functionName="filter",
    nDblWri=1,
    nDblRea=1,
    samplePeriod=samplePeriod) "Kalman filter in Python"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  parameter Modelica.SIunits.Time samplePeriod=0.001
    "Sample period of component";
  Modelica.Blocks.Sources.Sine sine(freqHz=1) "Sine wave"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
 // Delete the temporary file generated by the Python file
 // at the start and end of the simulation.
 when {initial(), terminal()} then
  Modelica.Utilities.Files.removeFile("tmp-kalman.pkl");
end when;

  connect(clock.y, ran.uR[1]) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add.y, kalFil.uR[1]) annotation (Line(
      points={{41,30},{58,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ran.yR[1], add.u2) annotation (Line(
      points={{-19,10},{0,10},{0,24},{18,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, add.u1) annotation (Line(
      points={{-19,50},{0,50},{0,36},{18,36}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Python27/Examples/KalmanFilter.mos"
        "Simulate and plot"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates the implementation of a Kalman filter
in Python.
The model generates a uniform random number, which is computed
in the Python file <code>KalmanFilter.py</code> by the function
<code>random(seed)</code>.
This random number is added to a sine wave and then sent to
the function <code>filter(u)</code> in the above Python file.
The function <code>filter(u)</code> implements a Kalman filter that estimates and returns
the state.
The function saves its temporary variables to a file called
<code>tmp-kalman.pkl</code>.
</p>
<p>
When simulating this model, the figure below will be generated which
shows the sine wave, the sine wave plus noise, which is input to the Kalman filter,
and the estimated state which is the output of the Kalman filter.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Utilities/IO/Python27/Examples/KalmanFilter.png\"/>
</p>
<h4>Implementation</h4>
<p>
The code is based on
<a href=\"http://www.scipy.org/Cookbook/KalmanFiltering\">
http://www.scipy.org/Cookbook/KalmanFiltering</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end KalmanFilter;
