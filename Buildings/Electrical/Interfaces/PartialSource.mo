within Buildings.Electrical.Interfaces;
partial model PartialSource "Partial model of a generic source"
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.OnePhase constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Boolean potentialReference = true "Serve as potential root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  parameter Boolean definiteReference = false "Serve as definite root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  Modelica.SIunits.Power S[PhaseSystem.n] = PhaseSystem.phasePowers_vi(terminal.v, terminal.i);
  Modelica.SIunits.Angle phi = PhaseSystem.phase(terminal.v) - PhaseSystem.phase(-terminal.i);
  replaceable Buildings.Electrical.Interfaces.Terminal terminal(redeclare
      replaceable package PhaseSystem = PhaseSystem) "Generalised terminal"
    annotation (Placement(transformation(extent={{92,-8},{108,8}})));
protected
  function j = PhaseSystem.j;
equation
  if PhaseSystem.m > 0 then
    if potentialReference then
      if definiteReference then
        Connections.root(terminal.theta);
      else
        Connections.potentialRoot(terminal.theta);
      end if;
    end if;
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a generic source.
</p>
<p>
In case the phase system adopted has <code>PhaseSystem.m > 0</code> and thus the connectors are over determined, 
the source can be selected to serve as reference point.
The parameters <code>potentialReference</code> and <code>definiteReference</code> are used to define if the
source model should be selected as source for the reference angles or not.
More information about overdetermined connectors can be found in <a href=\"#Olsson2008\">Olsson Et Al. (2008)</a>.
</p>

<h4>References</h4>
<p>
<a NAME=\"Olsson2008\"/>
Hans Olsson, Martin Otter, Sven Erik Mattson, Hilding Elmqvist<br/>
<a href=\"http://elib-v3.dlr.de/55892/1/otter2008-modelica-balanced-models.pdf\">
Balanced Models in Modelica 3.0 for Increased Model Quality </a><br/>
Proc. of the 7th Modelica Conference, Bielefeld, Germany, March 2008.
</p>


</html>"));
end PartialSource;