within Buildings.Electrical.Interfaces;
partial model PartialLoad "Partial model for a generic load"
  import Buildings.Electrical.Types.Assumption;
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Boolean linear = false
    "If =true introduce a linearization in the load model"                                                    annotation(evaluate=true,Dialog(group="Modelling assumption"));
  parameter Buildings.Electrical.Types.Assumption mode(
    min=Assumption.FixedZ_steady_state,
    max=Assumption.VariableZ_y_input)=Assumption.FixedZ_steady_state
    "Parameter that specifies the type of load model (e.g., steady state, dynamic, prescribed power consumption, etc.)"
                                                                                                        annotation(Evaluate=true,Dialog(group="Modelling assumption"));
  parameter Modelica.SIunits.Power P_nominal(start=0)
    "Nominal power (negative if consumed, positive if generated)"  annotation(evaluate=true,Dialog(group="Nominal conditions",
        enable = mode <> Assumption.VariableZ_P_input));
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions", enable = (mode==Assumptionm.FixedZ_dynamic or linear)));
  Modelica.SIunits.Voltage v[:](start = PhaseSystem.phaseVoltages(V_nominal)) = terminal.v
    "Voltage vector";
  Modelica.SIunits.Current i[:](start = PhaseSystem.phaseCurrents(0.0)) = terminal.i
    "Current vector";
  Modelica.SIunits.Power S[PhaseSystem.n] = PhaseSystem.phasePowers_vi(v, i)
    "Phase powers";
  Modelica.SIunits.Power P
    "Power of the load (negative if consumed, positive if fed into the electrical grid)";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1") if mode==Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput Pow(unit="W") if mode==Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  replaceable Buildings.Electrical.Interfaces.Terminal terminal(redeclare
      replaceable package PhaseSystem = PhaseSystem)
    "Generalised electric terminal"
    annotation (Placement(transformation(extent={{-108,-8},{-92,8}}),
        iconTransformation(extent={{-108,-8},{-92,8}})));

protected
  Modelica.Blocks.Interfaces.RealInput y_
    "Hidden value of the input load for the conditional connector";
  Modelica.Blocks.Interfaces.RealInput Pow_
    "Hidden value of the input power for the conditional connector";
  Real load(min=eps, max=1)
    "Internal representation of control signal, used to avoid singularity";
  constant Real eps = 1E-10
    "Small number used to avoid a singularity if the power is zero";
  constant Real oneEps = 1-eps
    "Small number used to avoid a singularity if the power is zero";
equation
  assert(y_>=0 and y_<=1+eps, "The power load fraction P (input of the model) must be within [0,1]");

  // Connection between the conditional and inner connector
  connect(y,y_);
  connect(Pow,Pow_);

  // If the power is fixed, inner connector value is equal to 1
  if mode==Assumption.FixedZ_steady_state or mode==Assumption.FixedZ_dynamic then
    y_   = 1;
    Pow_ = P_nominal;
  elseif mode==Assumption.VariableZ_y_input then
    Pow_ = 0;
  elseif mode==Assumption.VariableZ_P_input then
    y_ = 1;
  end if;

  // Value of the load, depending on the type: fixed or variable
  if mode==Assumption.VariableZ_y_input then
    load = eps + oneEps*y_;
  else
    load = 1;
  end if;

  // Power consumption
  if mode==Assumption.FixedZ_steady_state or mode==Assumption.FixedZ_dynamic then
    P = P_nominal;
  elseif mode==Assumption.VariableZ_P_input then
    P = Pow_;
  else
    P = P_nominal*load;
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation and revised model.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a generic load that can be extended to represent 
either a DC or an AC load.
The model has a single generalized electric terminal of type 
<a href=\"modelica://Buildings.Electrical.Interfaces.Terminal\">Buildings.Electrical.Interfaces.Terminal</a>
that can be redeclared.<br/>
The generalized load is modeled as an impedance which value can change. The value of the impedance
can change depending on the value of the parameter <code>mode</code> of type 
<a href=\"Buildings.Electrical.Types.Assumption\">Buildings.Electrical.Types.Assumption</a>:
<ul>
<li>fixed Z steady state,</li>
<li>fixed Z dynamic,</li>
<li>variable Z P input,</li>
<li>variable Z y input.</li>
</ul>
</p>

<h4>Conventions</h4>
<p>
It is assumed that the power <code>P</code> of the load is positive when produced 
(e.g., the load acts like a source) and negative when consumed (e.g., the 
source acts like a utilizer).
</p>


<h4>Fixed Z steady state</h4>
<p>
When the parameter <code>mode = Buildings.Electrical.Types.Assumption.FixedZ_steady_state</code> 
the load consumes exactly the power
specified by the parameter <code>P_nominal</code>.
</p>


<h4>Fixed Z dynamic</h4>
<p>
When the parameter <code>mode = Buildings.Electrical.Types.Assumption.FixedZ_dynamic</code> 
the load consumes exactly the power
specified by the parameter <code>P_nominal</code> at steady state. Depending on the type 
of load (e.g., inductive or capacitive)
different dynamics are represented.
</p>


<h4>Variable Z P inpute</h4>
<p>
When the parameter <code>mode = Buildings.Electrical.Types.Assumption.VariableZ_P_input</code> 
the load consumes exactly the power specified
by the input variable <code>Pow</code>.
</p>


<h4>Variable Z y input</h4>
<p>
When the parameter <code>mode = Buildings.Electrical.Types.Assumption.VariableZ_y_input</code> 
the load consumes exactly the a fraction of the nominal power 
<code>P_nominal</code> specified by the input variable <code>y</code>.
</p>


<h4>Linearized models</h4>
<p>
The model has a Boolean parameter <code>linear</code> that by default is equal to <code>False</code>. 
When the power consumption of the load is imposed this introduces
a nonlinear relationship between the voltage and the current of the load. This flag is used to 
select between a linearized version 
of the equations or the full nonlinear ones.<br/>
When the linearized version of the model is used, the parameter <code>V_nominal</code> has to 
be specified. The nominal voltage is needed to linearize the nonlinear equations.<br/>
</p>

<h4>N.B.</h4>
<p>
A linearized model will not consume the nominal power if the voltage at the terminal is different from the nominal one.
</p>

</html>"));
end PartialLoad;