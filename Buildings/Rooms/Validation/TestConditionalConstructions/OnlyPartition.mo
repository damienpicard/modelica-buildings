within Buildings.Rooms.Validation.TestConditionalConstructions;
model OnlyPartition "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=1,
   nConBou=0,
   nSurBou=0,
   roo(
    datConPar(layers={matLayPar}, each A=10,
    each til=Buildings.Types.Tilt.Floor,
    each azi=Buildings.Types.Azimuth.W)));

   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/TestConditionalConstructions/OnlyPartition.mos"
        "Simulate and plot"),
   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}})),
    experiment(
      StopTime=86400,
      Tolerance=1e-05));
end OnlyPartition;