within ;
package Simplest "simplest acid-base and electrolyte homesostasis"
  model Alveolocapillary_2Units_with_shunts_and_mixing_direct_connectors
    "SimplestTissue"
    extends AcidBaseBalance.Icons.Alveolus;

    Physiolibrary.Types.RealIO.MolarFlowRateOutput VCO2 annotation (Placement(
          transformation(extent={{84,-82},{104,-62}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=90,
          origin={-13,101})));
    Physiolibrary.Types.RealIO.MolarFlowRateOutput VO2 annotation (Placement(
          transformation(extent={{86,-64},{106,-44}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=90,
          origin={15,101})));
    Physiolibrary.Types.RealIO.VolumeFlowRateInput VAi annotation(Placement(transformation(extent={{-66,-2},
              {-54,10}}),                                                                                                     iconTransformation(extent={{-13,-13},
              {13,13}},                                                                                                    rotation = 0, origin={-59,27})));
    AcidBaseBalance.Interfaces.BloodPort_in bloodPort_in annotation (Placement(
          transformation(extent={{-106,64},{-86,84}}), iconTransformation(
            extent={{-44,50},{-24,70}})));
    AcidBaseBalance.Interfaces.BloodPort_out bloodPort_out annotation (
        Placement(transformation(extent={{86,64},{106,84}}), iconTransformation(
            extent={{14,52},{34,72}})));

    Physiolibrary.Types.RealIO.FractionInput Fsh "shunt fraction" annotation (
       Placement(transformation(extent={{-68,-38},{-54,-24}}),
          iconTransformation(extent={{-44,-86},{-26,-68}})));
    Physiolibrary.Types.RealIO.FractionInput F_q1 "alveolar perfusion fraction" annotation (
        Placement(transformation(extent={{-66,-52},{-52,-38}}),
          iconTransformation(extent={{-80,-42},{-62,-24}})));
    Physiolibrary.Types.RealIO.FractionInput F_VAi1 "alveolar ventilation fraction" annotation (
        Placement(transformation(extent={{-68,-68},{-52,-52}}),
          iconTransformation(extent={{-80,-22},{-62,-4}})));
    AcidBaseBalance.Acidbase.OSA.AlvEq_2units_with_shunts_and_mixing alvEq_2units_with_shunts_and_mixing
      annotation (Placement(transformation(extent={{-40,-82},{52,32}})));
    Physiolibrary.Types.RealIO.PressureOutput PaO2( start=13333) annotation (Placement(
          transformation(extent={{80,2},{100,22}}), iconTransformation(extent={{64,
              12},{84,32}})));
    Physiolibrary.Types.RealIO.PressureOutput PaCO2( start = 5333) annotation (Placement(
          transformation(extent={{80,-8},{100,12}}), iconTransformation(extent={{64,
              -12},{84,8}})));
    Physiolibrary.Types.RealIO.pHOutput pHa( start=7.4) annotation (Placement(transformation(
            extent={{80,-20},{100,0}}), iconTransformation(extent={{64,-36},{84,-16}})));
  equation
    // hydraulics
    bloodPort_in.bloodFlow + bloodPort_out.bloodFlow = 0;
    bloodPort_in.pressure = bloodPort_out.pressure;

    assert(bloodPort_in.bloodFlow > 0, "backward flow in lungs detected - the computation of blood concentrations are not designed for that", AssertionLevel.error);

    // output concetration - normal direction
  //   bloodPort_out.conc[1] = alvEq_2units_with_shunts_and_mixing.ctO2a;
  //   bloodPort_out.conc[2] = alvEq_2units_with_shunts_and_mixing.ctCO2a;
    bloodPort_out.conc[1] = homotopy(alvEq_2units_with_shunts_and_mixing.ctO2a, 8);
    bloodPort_out.conc[2] = homotopy(alvEq_2units_with_shunts_and_mixing.ctCO2a,20);

    bloodPort_out.conc[3] =   inStream(bloodPort_in.conc[3]);
    bloodPort_out.ions = inStream(bloodPort_in.ions);
    // backwards direction - forbidden, yet we must write equations
    bloodPort_in.conc[1] = alvEq_2units_with_shunts_and_mixing.ctO2a;
    bloodPort_in.conc[2] = alvEq_2units_with_shunts_and_mixing.ctCO2a;
    bloodPort_in.conc[3] =   inStream(bloodPort_out.conc[3]);
    bloodPort_in.ions = inStream(bloodPort_out.ions);

    // connecting the input connectors
    alvEq_2units_with_shunts_and_mixing.Q = bloodPort_in.bloodFlow;
    alvEq_2units_with_shunts_and_mixing.CvO2 = inStream(bloodPort_in.conc[1]);
    alvEq_2units_with_shunts_and_mixing.CvCO2 = inStream(bloodPort_in.conc[2]);
    alvEq_2units_with_shunts_and_mixing.BEox  = inStream(bloodPort_in.conc[3]);

    connect(alvEq_2units_with_shunts_and_mixing.VAi, VAi) annotation (Line(points=
           {{-39.2,0.65},{-50.6,0.65},{-50.6,4},{-60,4}}, color={0,0,127}));
    connect(alvEq_2units_with_shunts_and_mixing.Fsh, Fsh) annotation (Line(points={{-39.4,
            -31.7688},{-48.7,-31.7688},{-48.7,-31},{-61,-31}},        color={0,0,127}));
    connect(alvEq_2units_with_shunts_and_mixing.F_q1, F_q1) annotation (Line(
          points={{-39.4,-44.5938},{-48.7,-44.5938},{-48.7,-45},{-59,-45}}, color=
           {0,0,127}));
    connect(alvEq_2units_with_shunts_and_mixing.F_VAi1, F_VAi1) annotation (Line(
          points={{-39.8,-58.8438},{-47.9,-58.8438},{-47.9,-60},{-60,-60}}, color=
           {0,0,127}));
    connect(alvEq_2units_with_shunts_and_mixing.VO2, VO2) annotation (Line(points={{53.8,
            -21.0813},{68,-21.0813},{68,-54},{96,-54}},       color={0,0,127}));
    connect(alvEq_2units_with_shunts_and_mixing.VCO2, VCO2) annotation (Line(
          points={{53.6,-27.85},{74,-28},{74,-72},{94,-72}}, color={0,0,127}));
    connect(PaO2, alvEq_2units_with_shunts_and_mixing.PaO2) annotation (Line(
          points={{90,12},{62,12},{62,12.05},{54,12.05}}, color={0,0,127}));
    connect(alvEq_2units_with_shunts_and_mixing.PaCO2, PaCO2) annotation (Line(
          points={{54,4.925},{58,4.925},{58,2},{90,2}}, color={0,0,127}));
    connect(alvEq_2units_with_shunts_and_mixing.pHa, pHa) annotation (Line(points=
           {{54,-2.2},{56,-2.2},{56,-2},{58,-2},{58,-10},{90,-10}}, color={0,0,127}));
    annotation(Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}),
          graphics={Text(
            extent={{-86,114},{-16,88}},
            lineColor={28,108,200},
            textString="CO2"), Text(
            extent={{14,114},{82,86}},
            lineColor={28,108,200},
            textString="O2")}),                                                                                                    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}),
          graphics={
          Line(
            points={{-42,-18},{-90,-18},{-90,62}},
            color={238,46,47},
            arrow={Arrow.Open,Arrow.None},
            thickness=0.5,
            pattern=LinePattern.Dash),
          Line(
            points={{-42,-12},{-86,-12},{-86,68}},
            color={238,46,47},
            arrow={Arrow.Open,Arrow.None},
            thickness=0.5,
            pattern=LinePattern.Dash),
          Line(
            points={{-42,-4},{-84,-4},{-84,74}},
            color={238,46,47},
            arrow={Arrow.Open,Arrow.None},
            thickness=0.5,
            pattern=LinePattern.Dash),
          Line(
            points={{-44,12},{-82,12},{-82,78}},
            color={238,46,47},
            arrow={Arrow.Open,Arrow.None},
            thickness=0.5,
            pattern=LinePattern.Dash),
          Line(
            points={{58,-34},{96,-34},{96,66}},
            color={238,46,47},
            arrow={Arrow.None,Arrow.Open},
            thickness=0.5,
            pattern=LinePattern.Dash),
          Line(
            points={{58,-42},{100,-42},{100,66}},
            color={238,46,47},
            arrow={Arrow.None,Arrow.Open},
            thickness=0.5,
            pattern=LinePattern.Dash),
          Line(
            points={{-78,74},{90,74}},
            color={238,46,47},
            arrow={Arrow.None,Arrow.Open},
            thickness=0.5,
            pattern=LinePattern.Dash)}));
  end Alveolocapillary_2Units_with_shunts_and_mixing_direct_connectors;

  package Test

    model TestVentilation_withoutStream
       extends Modelica.Icons.Example;
      Physiolibrary.Types.Constants.VolumeFlowRateConst VAi(k(displayUnit=
              "l/min") = 8.3333333333333e-05)
        annotation (Placement(transformation(extent={{-97,64},{-89,70}})));
      Physiolibrary.Types.Constants.FractionConst FAi1(k=0.5)
        annotation (Placement(transformation(extent={{-68,14},{-60,22}})));
      Physiolibrary.Types.Constants.FractionConst Fq1(k=0.5)
        annotation (Placement(transformation(extent={{-72,28},{-64,36}})));
      Physiolibrary.Types.Constants.FractionConst Fsh(k=0.02)
        annotation (Placement(transformation(extent={{-64,36},{-56,44}})));
      Physiolibrary.Types.Constants.VolumeFlowRateConst CardiacOutput(k(
            displayUnit="l/min") = 8.3333333333333e-05)
                                                       annotation (Placement(
            transformation(
            extent={{4,4},{-4,-4}},
            rotation=180,
            origin={-90,56})));
      inner AcidBaseBalance.Interfaces.ModelSettings
                                     modelSettings(PB=101325.0144354,
          lungShuntFraction=0.05)
        annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
      AcidBaseBalance.Acidbase.OSA.AlvEq_2units_with_shunts_and_mixing alvEq_2units_with_shunts_and_mixing
        annotation (Placement(transformation(extent={{-40,8},{40,82}})));
      Physiolibrary.Types.Constants.ConcentrationConst BEox(k=0)
        annotation (Placement(transformation(extent={{-66,78},{-58,86}})));
      Physiolibrary.Types.Constants.MolarFlowRateConst VO2(k=
            0.00018333333333333)
        annotation (Placement(transformation(extent={{-88,-50},{-80,-42}})));
      Physiolibrary.Types.Constants.MolarFlowRateConst VCO2(k=
            0.00016666666666667)
        annotation (Placement(transformation(extent={{-80,-68},{-72,-60}})));
      SimplestTissue simplestTissue
        annotation (Placement(transformation(extent={{-32,-62},{22,-16}})));
    equation
      connect(VAi.y, alvEq_2units_with_shunts_and_mixing.VAi) annotation (Line(
            points={{-88,67},{-62,67},{-62,61.65},{-39.3043,61.65}}, color={0,0,
              127}));
      connect(alvEq_2units_with_shunts_and_mixing.Q, CardiacOutput.y)
        annotation (Line(points={{-39.3043,58.875},{-42.6521,58.875},{-42.6521,
              56},{-85,56}}, color={0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.Fsh, Fsh.y) annotation (Line(
            points={{-39.4783,40.6063},{-46.7391,40.6063},{-46.7391,40},{-55,40}},
            color={0,0,127}));
      connect(Fq1.y, alvEq_2units_with_shunts_and_mixing.F_q1) annotation (Line(
            points={{-63,32},{-52,32},{-52,32.2812},{-39.4783,32.2812}}, color=
              {0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.F_VAi1, FAi1.y) annotation (
          Line(points={{-39.8261,23.0312},{-55.913,23.0312},{-55.913,18},{-59,
              18}}, color={0,0,127}));
      connect(BEox.y, alvEq_2units_with_shunts_and_mixing.BEox) annotation (
          Line(points={{-57,82},{-48,82},{-48,68.125},{-40,68.125}}, color={0,0,
              127}));
      connect(simplestTissue.O2a, alvEq_2units_with_shunts_and_mixing.ctO2a)
        annotation (Line(points={{-32,-19.22},{-48,-19.22},{-48,-4},{66,-4},{66,
              38.7563},{41.5652,38.7563}}, color={0,0,127}));
      connect(simplestTissue.CO2a, alvEq_2units_with_shunts_and_mixing.ctCO2a)
        annotation (Line(points={{-32,-24.74},{-56,-24.74},{-56,0},{58,0},{58,
              34.5938},{41.5652,34.5938}}, color={0,0,127}));
      connect(simplestTissue.Q, CardiacOutput.y) annotation (Line(points={{-32.81,
              -39.23},{-76,-39.23},{-76,56},{-85,56}},        color={0,0,127}));
      connect(VO2.y, simplestTissue.MO2) annotation (Line(points={{-79,-46},{
              -56.175,-46},{-56.175,-47.05},{-33.35,-47.05}},
                                                      color={0,0,127}));
      connect(VCO2.y, simplestTissue.MCO2) annotation (Line(points={{-71,-64},{
              -54,-64},{-54,-54.41},{-32.81,-54.41}}, color={0,0,127}));
      connect(simplestTissue.O2v, alvEq_2units_with_shunts_and_mixing.CvO2)
        annotation (Line(points={{24.16,-17.38},{28,-17.38},{28,2},{-86,2},{-86,
              54.0187},{-40.1739,54.0187}},
                                          color={0,0,127}));
      connect(simplestTissue.CO2v, alvEq_2units_with_shunts_and_mixing.CvCO2)
        annotation (Line(points={{24.16,-21.98},{32,-21.98},{32,6},{-82,6},{-82,
              48.0063},{-39.8261,48.0063}},
                                        color={0,0,127}));
      connect(simplestTissue.BEox, alvEq_2units_with_shunts_and_mixing.BEox)
        annotation (Line(points={{-32,-30.26},{-74,-30.26},{-74,70},{-48,70},{
              -48,68.125},{-40,68.125}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end TestVentilation_withoutStream;

    model PO2PCO2test
       extends Modelica.Icons.Example;
      AcidBaseBalance.Acidbase.OSA.PO2PCO2_by_integration pO2PCO2_by_integration
        annotation (Placement(transformation(extent={{-28,-18},{56,74}})));
      Physiolibrary.Types.Constants.ConcentrationConst BEox(k=-25)
        annotation (Placement(transformation(extent={{-74,18},{-66,26}})));
      Physiolibrary.Types.Constants.PressureConst PO2(k=13332.2387415)
        annotation (Placement(transformation(extent={{-80,54},{-72,62}})));
      Physiolibrary.Types.Constants.PressureConst PCO2(k=5332.8954966)
        annotation (Placement(transformation(extent={{-80,34},{-72,42}})));
      inner AcidBaseBalance.Interfaces.ModelSettings
                                     modelSettings(PB=101325.0144354,
          lungShuntFraction=0.05)
        annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
    equation
      connect(BEox.y, pO2PCO2_by_integration.BEox)
        annotation (Line(points={{-65,22},{-33.6,21.1}},    color={0,0,127}));
      connect(PO2.y, pO2PCO2_by_integration.pO2) annotation (Line(points={{-71,58},
              {-33.6,58},{-33.6,58.6667}},color={0,0,127}));
      connect(PCO2.y, pO2PCO2_by_integration.pCO2) annotation (Line(points={{-71,38},
              {-33.6,38},{-33.6,38.7333}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PO2PCO2test;

    model PO2CurveTest
       extends Modelica.Icons.Example;
      AcidBaseBalance.Acidbase.OSA.PO2PCO2_by_integration pO2PCO2_by_integration
        annotation (Placement(transformation(extent={{-28,-16},{56,76}})));
      Physiolibrary.Types.Constants.PressureConst PCO2(k=5332.8954966)
        annotation (Placement(transformation(extent={{-78,38},{-70,46}})));
      Physiolibrary.Types.Constants.PressureConst PO2(k=133.322387415)
        annotation (Placement(transformation(extent={{-56,-44},{-48,-36}})));
    Modelica.Blocks.Math.Product product1
      annotation (Placement(transformation(extent={{-36,-58},{-16,-38}})));
    Modelica.Blocks.Sources.Ramp ramp(height=200, duration=200)
      annotation (Placement(transformation(extent={{-90,-66},{-70,-46}})));
      inner AcidBaseBalance.Interfaces.ModelSettings
                                     modelSettings(PB=101325.0144354,
          lungShuntFraction=0.05)
        annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
      conc_mmol_to_ml CdCO2_ml
        annotation (Placement(transformation(extent={{90,-40},{108,-24}})));
      conc_mmol_to_ml CdO2_ml
        annotation (Placement(transformation(extent={{88,-18},{106,-2}})));
      Hb_mmol_to_g ceHb_g
        annotation (Placement(transformation(extent={{88,10},{108,30}})));
      conc_mmol_to_ml CtCO2_ml
        annotation (Placement(transformation(extent={{90,42},{108,58}})));
      conc_mmol_to_ml CtO2_ml
        annotation (Placement(transformation(extent={{90,64},{108,80}})));
      Hb_mmol_to_g Hb_g_per_l
        annotation (Placement(transformation(extent={{-8,78},{12,98}})));
      Physiolibrary.Types.Constants.ConcentrationConst ctHb(k=(modelSettings.ctHb))
        annotation (Placement(transformation(extent={{-56,84},{-48,92}})));
      Modelica.Blocks.Sources.Constant BEox(k=0)
        annotation (Placement(transformation(extent={{-78,6},{-64,20}})));
    equation
      connect(PCO2.y, pO2PCO2_by_integration.pCO2) annotation (Line(points={{-69,42},
              {-33.6,42},{-33.6,40.7333}}, color={0,0,127}));
    connect(PO2.y, product1.u1)
      annotation (Line(points={{-47,-40},{-42,-40},{-42,-42},{-38,-42}},
                                                     color={0,0,127}));
    connect(ramp.y, product1.u2) annotation (Line(points={{-69,-56},{-46,-56},{
              -46,-62},{-38,-62},{-38,-54}},
                                 color={0,0,127}));
    connect(product1.y, pO2PCO2_by_integration.pO2) annotation (Line(points={{-15,-48},
              {6,-48},{6,-14},{-84,-14},{-84,60.6667},{-33.6,60.6667}},
          color={0,0,127}));
      connect(ctHb.y, Hb_g_per_l.Hb_mmol)
        annotation (Line(points={{-47,88},{-10,88}}, color={0,0,127}));
      connect(pO2PCO2_by_integration.ctO2, CtO2_ml.mmol_per_liter) annotation (
          Line(points={{69.0667,65.2667},{69.0667,72},{88.38,72}}, color={0,0,
              127}));
      connect(pO2PCO2_by_integration.ctCO2, CtCO2_ml.mmol_per_liter)
        annotation (Line(points={{69.0667,57.6},{82,57.6},{82,50},{88.38,50}},
            color={0,0,127}));
      connect(pO2PCO2_by_integration.ceHb, ceHb_g.Hb_mmol) annotation (Line(
            points={{69.0667,20.0333},{77.5333,20.0333},{77.5333,20},{86,20}},
            color={0,0,127}));
      connect(CdO2_ml.mmol_per_liter, pO2PCO2_by_integration.cdO2) annotation (
          Line(points={{86.38,-10},{82,-10},{82,12},{69.0667,12},{69.0667,
              12.3667}}, color={0,0,127}));
      connect(pO2PCO2_by_integration.cdCO2, CdCO2_ml.mmol_per_liter)
        annotation (Line(points={{69.0667,4.7},{76,4.7},{76,-32},{88.38,-32}},
            color={0,0,127}));
      connect(BEox.y, pO2PCO2_by_integration.BEox) annotation (Line(points={{
              -63.3,13},{-44,13},{-44,23.1},{-33.6,23.1}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=200,
        __Dymola_NumberOfIntervals=5000,
        __Dymola_Algorithm="Dassl"));
    end PO2CurveTest;

    model PCO2CurveTest
       extends Modelica.Icons.Example;
      AcidBaseBalance.Acidbase.OSA.PO2PCO2_by_integration pO2PCO2_by_integration
        annotation (Placement(transformation(extent={{-28,-18},{56,74}})));
      Physiolibrary.Types.Constants.PressureConst PO2(k=13332.2387415)
        annotation (Placement(transformation(extent={{-86,54},{-78,62}})));
      Physiolibrary.Types.Constants.PressureConst PCO2(k=133.322387415)
        annotation (Placement(transformation(extent={{-58,-44},{-50,-36}})));
    Modelica.Blocks.Math.Product product1
      annotation (Placement(transformation(extent={{-36,-58},{-16,-38}})));
    Modelica.Blocks.Sources.Ramp ramp(
      height=100,
      duration=100,
      offset=0.000001)
      annotation (Placement(transformation(extent={{-84,-86},{-64,-66}})));
      inner AcidBaseBalance.Interfaces.ModelSettings
                                     modelSettings(
        PB=101325.0144354,
        lungShuntFraction=0.05,
        ctHb=9.4)
        annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
      conc_mmol_to_ml CtO2_ml
        annotation (Placement(transformation(extent={{96,68},{114,84}})));
      conc_mmol_to_ml CtCO2_ml
        annotation (Placement(transformation(extent={{96,46},{114,62}})));
      Hb_mmol_to_g ceHb_g
        annotation (Placement(transformation(extent={{94,10},{114,30}})));
      conc_mmol_to_ml CdCO2_ml
        annotation (Placement(transformation(extent={{96,-36},{114,-20}})));
      conc_mmol_to_ml CdO2_ml
        annotation (Placement(transformation(extent={{94,-14},{112,2}})));

      Physiolibrary.Types.Constants.ConcentrationConst ctHb(k=(modelSettings.ctHb))
        annotation (Placement(transformation(extent={{-50,88},{-42,96}})));
      Hb_mmol_to_g Hb_g_per_l
        annotation (Placement(transformation(extent={{-2,82},{18,102}})));
      Modelica.Blocks.Sources.Constant BEox(k=0)
        annotation (Placement(transformation(extent={{-74,14},{-60,28}})));
    equation


    connect(ramp.y, product1.u2) annotation (Line(points={{-63,-76},{-44,-76},{
            -44,-54},{-38,-54}}, color={0,0,127}));
    connect(pO2PCO2_by_integration.pO2, PO2.y) annotation (Line(points={{-33.6,
              58.6667},{-32,58.6667},{-32,58},{-77,58}},
                                                       color={0,0,127}));
    connect(PCO2.y, product1.u1) annotation (Line(points={{-49,-40},{-44,-40},{
            -44,-42},{-38,-42}}, color={0,0,127}));
    connect(product1.y, pO2PCO2_by_integration.pCO2) annotation (Line(points={{-15,-48},
              {6,-48},{6,-20},{-92,-20},{-92,38.7333},{-33.6,38.7333}},
          color={0,0,127}));
      connect(pO2PCO2_by_integration.ctO2, CtO2_ml.mmol_per_liter) annotation (Line(
            points={{69.0667,63.2667},{80,63.2667},{80,76},{94.38,76}}, color={0,0,127}));
      connect(pO2PCO2_by_integration.ctCO2, CtCO2_ml.mmol_per_liter) annotation (
          Line(points={{69.0667,55.6},{80,55.6},{80,54},{94.38,54}}, color={0,0,127}));
      connect(pO2PCO2_by_integration.ceHb, ceHb_g.Hb_mmol) annotation (Line(points={{69.0667,
              18.0333},{82,18.0333},{82,20},{92,20}},          color={0,0,127}));
      connect(pO2PCO2_by_integration.cdO2, CdO2_ml.mmol_per_liter) annotation (Line(
            points={{69.0667,10.3667},{86,10.3667},{86,-6},{92.38,-6}}, color={0,0,127}));
      connect(pO2PCO2_by_integration.cdCO2, CdCO2_ml.mmol_per_liter) annotation (
          Line(points={{69.0667,2.7},{78,2.7},{78,-28},{94.38,-28}}, color={0,0,127}));
      connect(ctHb.y, Hb_g_per_l.Hb_mmol)
        annotation (Line(points={{-41,92},{-4,92}}, color={0,0,127}));
      connect(BEox.y, pO2PCO2_by_integration.BEox) annotation (Line(points={{
              -59.3,21},{-42,21},{-42,21.1},{-33.6,21.1}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=200,
        __Dymola_NumberOfIntervals=5000,
        __Dymola_Algorithm="Dassl"));
    end PCO2CurveTest;

    model TestPulmonaryVentilation
       extends Modelica.Icons.Example;
      Physiolibrary.Types.Constants.VolumeFlowRateConst VAi(k(displayUnit=
              "l/min") = 8.3333333333333e-05)
        annotation (Placement(transformation(extent={{-97,64},{-89,70}})));
      Physiolibrary.Types.Constants.FractionConst FAi1(k=0.5)
        annotation (Placement(transformation(extent={{-48,0},{-40,8}})));
      Physiolibrary.Types.Constants.FractionConst Fq1(k=0.5)
        annotation (Placement(transformation(extent={{-50,16},{-42,24}})));
      Physiolibrary.Types.Constants.FractionConst Fsh(k=0.02)
        annotation (Placement(transformation(extent={{-52,26},{-44,34}})));
      Physiolibrary.Types.Constants.VolumeFlowRateConst CardiacOutput(k(
            displayUnit="l/min") = 8.3333333333333e-05)
                                                       annotation (Placement(
            transformation(
            extent={{4,4},{-4,-4}},
            rotation=180,
            origin={-90,56})));
      inner AcidBaseBalance.Interfaces.ModelSettings
                                     modelSettings(
        PB=101325.0144354,
        lungShuntFraction=0.05,
        ctHb=11)
        annotation (Placement(transformation(extent={{-120,78},{-100,98}})));
      AcidBaseBalance.Acidbase.OSA.AlvEq_2units_with_shunts_and_mixing alvEq_2units_with_shunts_and_mixing
        annotation (Placement(transformation(extent={{-24,4},{56,78}})));
      Physiolibrary.Types.Constants.ConcentrationConst BEox(k=0)
        annotation (Placement(transformation(extent={{-78,78},{-70,86}})));
      Physiolibrary.Types.Constants.PressureConst PvO2(k=5332.8954966)
        annotation (Placement(transformation(extent={{-128,-72},{-112,-54}})));
      Physiolibrary.Types.Constants.PressureConst PvCO2(k=6286.1505666173)
        annotation (Placement(transformation(extent={{-130,-108},{-114,-90}})));
      Physiolibrary.Types.Constants.ConcentrationConst CO2v(k=23.5)
        annotation (Placement(transformation(extent={{-98,0},{-76,16}})));
      Physiolibrary.Types.Constants.ConcentrationConst O2v(k=6.05)
        annotation (Placement(transformation(extent={{-102,24},{-80,40}})));
      AcidBaseBalance.Acidbase.OSA.PO2PCO2 pO2PCO2_1
        annotation (Placement(transformation(extent={{-44,-160},{50,-68}})));
    equation
      connect(VAi.y, alvEq_2units_with_shunts_and_mixing.VAi) annotation (Line(
            points={{-88,67},{-50,67},{-50,57.65},{-23.3043,57.65}}, color={0,0,
              127}));
      connect(alvEq_2units_with_shunts_and_mixing.Q, CardiacOutput.y)
        annotation (Line(points={{-23.3043,54.875},{-30,54.875},{-30,56},{-85,
              56}},          color={0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.Fsh, Fsh.y) annotation (Line(
            points={{-23.4783,36.6063},{-43,36.6063},{-43,30}},
            color={0,0,127}));
      connect(Fq1.y, alvEq_2units_with_shunts_and_mixing.F_q1) annotation (Line(
            points={{-41,20},{-32.2391,20},{-32.2391,28.2812},{-23.4783,28.2812}},
                                                                         color=
              {0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.F_VAi1, FAi1.y) annotation (
          Line(points={{-23.8261,19.0312},{-34,19.0312},{-34,4},{-39,4}},
                    color={0,0,127}));
      connect(BEox.y, alvEq_2units_with_shunts_and_mixing.BEox) annotation (
          Line(points={{-69,82},{-40,82},{-40,64.125},{-24,64.125}}, color={0,0,
              127}));
      connect(pO2PCO2_1.BEox, alvEq_2units_with_shunts_and_mixing.BEox)
        annotation (Line(points={{-48.1778,-136.233},{-58,-136.233},{-58,70},{
              -40,70},{-40,64.125},{-24,64.125}}, color={0,0,127}));
      connect(pO2PCO2_1.ctCO2, alvEq_2units_with_shunts_and_mixing.CvCO2)
        annotation (Line(points={{65.6667,-84.1},{76,-84.1},{76,-14},{-66,-14},
              {-66,44.0063},{-23.8261,44.0063}},color={0,0,127}));
      connect(PvCO2.y, pO2PCO2_1.pCO2) annotation (Line(points={{-112,-99},{
              -112,-100},{-50,-100},{-50,-97.9},{-49.2222,-97.9}}, color={0,0,
              127}));
      connect(PvO2.y, pO2PCO2_1.pO2) annotation (Line(points={{-110,-63},{-110,
              -70},{-49.2222,-70},{-49.2222,-73.3667}}, color={0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.CvO2, pO2PCO2_1.ctO2) annotation (
         Line(points={{-24.1739,50.0187},{-68,50.0187},{-68,-20},{74,-20},{74,
              -76.4333},{65.6667,-76.4333}},
                                   color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
                -120,-200},{100,100}})),                             Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-120,-200},{
                100,100}})));
    end TestPulmonaryVentilation;

    model PO2test_
       extends Modelica.Icons.Example;
      Physiolibrary.Types.Constants.PressureConst PO2(k=5332.8954966)
        annotation (Placement(transformation(extent={{-84,8},{-76,16}})));
      AcidBaseBalance.Acidbase.OSA.PO2PCO2 pO2PCO2_2
        annotation (Placement(transformation(extent={{-30,-72},{50,18}})));
      Physiolibrary.Types.Constants.PressureConst PCO2(k=5332.8954966)
        annotation (Placement(transformation(extent={{-74,-16},{-66,-8}})));
      Physiolibrary.Types.Constants.ConcentrationConst BEox(k=0)
        annotation (Placement(transformation(extent={{-78,-52},{-70,-44}})));
      inner AcidBaseBalance.Interfaces.ModelSettings
                                     modelSettings(PB=101325.0144354,
          lungShuntFraction=0.05)
        annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
    equation
      connect(PCO2.y, pO2PCO2_2.pCO2) annotation (Line(points={{-65,-12},{
              -49.7222,-12},{-49.7222,-11.25},{-34.4444,-11.25}}, color={0,0,
              127}));
      connect(BEox.y, pO2PCO2_2.BEox) annotation (Line(points={{-69,-48},{-42,
              -48},{-42,-48.75},{-33.5556,-48.75}}, color={0,0,127}));
      connect(PO2.y, pO2PCO2_2.pO2) annotation (Line(points={{-75,12},{-42,12},
              {-42,12.75},{-34.4444,12.75}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=200,
        __Dymola_NumberOfIntervals=5000,
        __Dymola_Algorithm="Dassl"));
    end PO2test_;

    model TestVentilation_withoutStream_byIntegration
      Physiolibrary.Types.Constants.VolumeFlowRateConst VAi(k(displayUnit=
              "l/min") = 8.3333333333333e-05)
        annotation (Placement(transformation(extent={{-97,64},{-89,70}})));
      Physiolibrary.Types.Constants.FractionConst FAi1(k=0.5)
        annotation (Placement(transformation(extent={{-68,14},{-60,22}})));
      Physiolibrary.Types.Constants.FractionConst Fq1(k=0.5)
        annotation (Placement(transformation(extent={{-54,28},{-46,36}})));
      Physiolibrary.Types.Constants.FractionConst Fsh(k=0.02)
        annotation (Placement(transformation(extent={{-64,36},{-56,44}})));
      Physiolibrary.Types.Constants.VolumeFlowRateConst CardiacOutput(k(
            displayUnit="l/min") = 8.3333333333333e-5) annotation (Placement(
            transformation(
            extent={{4,4},{-4,-4}},
            rotation=180,
            origin={-90,56})));
      inner AcidBaseBalance.Interfaces.ModelSettings
                                     modelSettings(PB=101325.0144354,
          lungShuntFraction=0.05)
        annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
      AcidBaseBalance.Acidbase.OSA.AlvEq_2units_with_shunts_and_mixing alvEq_2units_with_shunts_and_mixing
        annotation (Placement(transformation(extent={{-40,8},{40,82}})));
      Physiolibrary.Types.Constants.ConcentrationConst BEox(k=0)
        annotation (Placement(transformation(extent={{-96,72},{-88,80}})));
      Physiolibrary.Types.Constants.MolarFlowRateConst VO2(k=
            0.00018333333333333)
        annotation (Placement(transformation(extent={{-82,-58},{-74,-50}})));
      Physiolibrary.Types.Constants.MolarFlowRateConst VCO2(k=
            0.00016666666666667)
        annotation (Placement(transformation(extent={{-80,-74},{-72,-66}})));
      SimplestTissueIntgr simplestTissueIntgr
        annotation (Placement(transformation(extent={{-34,-80},{34,-12}})));
    equation
      connect(VAi.y, alvEq_2units_with_shunts_and_mixing.VAi) annotation (Line(
            points={{-88,67},{-62,67},{-62,61.65},{-39.3043,61.65}}, color={0,0,
              127}));
      connect(alvEq_2units_with_shunts_and_mixing.Q, CardiacOutput.y)
        annotation (Line(points={{-39.3043,58.875},{-42.6521,58.875},{-42.6521,
              56},{-85,56}}, color={0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.Fsh, Fsh.y) annotation (Line(
            points={{-39.4783,40.6063},{-46.7391,40.6063},{-46.7391,40},{-55,40}},
            color={0,0,127}));
      connect(Fq1.y, alvEq_2units_with_shunts_and_mixing.F_q1) annotation (Line(
            points={{-45,32},{-52,32},{-52,32.2812},{-39.4783,32.2812}}, color=
              {0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.F_VAi1, FAi1.y) annotation (
          Line(points={{-39.8261,23.0312},{-55.913,23.0312},{-55.913,18},{-59,
              18}}, color={0,0,127}));
      connect(BEox.y, alvEq_2units_with_shunts_and_mixing.BEox) annotation (
          Line(points={{-87,76},{-46,76},{-46,68.125},{-40,68.125}}, color={0,0,
              127}));
      connect(alvEq_2units_with_shunts_and_mixing.ctO2a, simplestTissueIntgr.O2a)
        annotation (Line(points={{41.5652,38.7563},{60,38.7563},{60,0},{-54,0},
              {-54,-16.76},{-34,-16.76}}, color={0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.ctCO2a, simplestTissueIntgr.CO2a)
        annotation (Line(points={{41.5652,34.5938},{52,34.5938},{52,4},{-58,4},
              {-58,-24.92},{-34,-24.92}}, color={0,0,127}));
      connect(simplestTissueIntgr.BEox, alvEq_2units_with_shunts_and_mixing.BEox)
        annotation (Line(points={{-34,-33.08},{-82,-33.08},{-82,76},{-46,76},{
              -46,68.125},{-40,68.125}}, color={0,0,127}));
      connect(simplestTissueIntgr.Q, CardiacOutput.y) annotation (Line(points={
              {-35.02,-46.34},{-78,-46.34},{-78,38},{-76,56},{-85,56}}, color={
              0,0,127}));
      connect(VCO2.y, simplestTissueIntgr.MCO2) annotation (Line(points={{-71,
              -70},{-44,-70},{-44,-68.78},{-35.02,-68.78}}, color={0,0,127}));
      connect(VO2.y, simplestTissueIntgr.MO2) annotation (Line(points={{-73,-54},
              {-46,-54},{-46,-57.9},{-35.7,-57.9}}, color={0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.CvO2, simplestTissueIntgr.O2v)
        annotation (Line(points={{-40.1739,54.0187},{-74,54.0187},{-74,-4},{50,
              -4},{50,-14.04},{36.72,-14.04}}, color={0,0,127}));
      connect(alvEq_2units_with_shunts_and_mixing.CvCO2, simplestTissueIntgr.CO2v)
        annotation (Line(points={{-39.8261,48.0063},{-70,48.0063},{-70,-6},{60,
              -6},{60,-20.84},{36.72,-20.84}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end TestVentilation_withoutStream_byIntegration;
  end Test;

  model SimplestTissue

    Physiolibrary.Types.RealIO.MolarFlowRateInput MCO2 annotation (Placement(
          transformation(extent={{-100,12},{-88,24}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-103,-67})));
    Physiolibrary.Types.RealIO.MolarFlowRateInput MO2 annotation (Placement(
          transformation(extent={{-100,24},{-88,36}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-105,-35})));

    Physiolibrary.Types.RealIO.VolumeFlowRateInput Q annotation (Placement(
          transformation(extent={{-102,36},{-86,52}}),   iconTransformation(
            extent={{-114,-12},{-92,10}})));
    Physiolibrary.Types.RealIO.ConcentrationInput O2a annotation (Placement(
          transformation(extent={{-98,66},{-84,80}}),   iconTransformation(extent=
             {{-110,76},{-90,96}})));
    Physiolibrary.Types.RealIO.ConcentrationInput CO2a annotation (Placement(
          transformation(extent={{-100,54},{-86,68}}),  iconTransformation(extent={{-110,52},
              {-90,72}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput CO2v annotation (Placement(
          transformation(extent={{24,58},{36,70}}),     iconTransformation(extent={{98,64},
              {118,84}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput O2v annotation (Placement(
          transformation(extent={{18,68},{30,80}}),     iconTransformation(extent={{98,84},
              {118,104}})));
    BloodGases bloodGases
      annotation (Placement(transformation(extent={{-52,32},{-8,74}})));
    AcidBaseBalance.Acidbase.OSA.O2CO2
          venBlood
      annotation (Placement(transformation(extent={{18,-48},{74,38}})));
    Physiolibrary.Types.RealIO.ConcentrationInput BEox annotation (Placement(
          transformation(extent={{-30,0},{-16,14}}), iconTransformation(extent=
              {{-110,28},{-90,48}})));
    Physiolibrary.Types.RealIO.PressureOutput pO2_v(start=13300) annotation (
        Placement(transformation(extent={{88,20},{102,34}}), iconTransformation(
            extent={{98,44},{118,64}})));
    Physiolibrary.Types.RealIO.PressureOutput pCO2_v(start=5333) annotation (
        Placement(transformation(extent={{90,12},{104,26}}), iconTransformation(
            extent={{98,24},{118,44}})));
    Physiolibrary.Types.RealIO.pHOutput pH_v(start=7.4) annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={95,9}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={108,14})));
    Physiolibrary.Types.RealIO.ConcentrationOutput cHCO3_v(displayUnit="mmol/l")
      "outgoing concentration of HCO3" annotation (Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={97,-2}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={110,-4})));
    Physiolibrary.Types.RealIO.FractionOutput sO2_v annotation (Placement(
          transformation(
          extent={{-6,-6},{6,6}},
          rotation=0,
          origin={96,-12}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={110,-24})));
    Physiolibrary.Types.RealIO.MolarFlowRateOutput DO2 annotation (Placement(
          transformation(extent={{86,-68},{106,-48}}), iconTransformation(extent={{100,-54},
              {120,-34}})));
    Physiolibrary.Types.RealIO.MolarFlowRateOutput DCO2 annotation (Placement(
          transformation(extent={{88,-86},{108,-66}}), iconTransformation(extent={
              {100,-98},{120,-78}})));
    Physiolibrary.Types.RealIO.FractionOutput OER annotation (Placement(
          transformation(extent={{90,-96},{110,-76}}),    iconTransformation(
            extent={{100,-76},{120,-56}})));
  equation
    DO2=O2a*Q;
    OER=MO2/DO2;
    DCO2=CO2v*Q;
    connect(O2a, bloodGases.O2a) annotation (Line(points={{-91,73},{-72.5,73},{
            -72.5,71.06},{-52,71.06}}, color={0,0,127}));
    connect(bloodGases.CO2a, CO2a) annotation (Line(points={{-52,66.44},{-74,
            66.44},{-74,61},{-93,61}}, color={0,0,127}));
    connect(bloodGases.Q, Q) annotation (Line(points={{-52.66,52.79},{-74,52.79},
            {-74,44},{-94,44}}, color={0,0,127}));
    connect(bloodGases.MO2, MO2) annotation (Line(points={{-53.1,45.65},{-70,
            45.65},{-70,30},{-94,30}}, color={0,0,127}));
    connect(bloodGases.MCO2, MCO2) annotation (Line(points={{-52.66,38.93},{-62,
            38.93},{-62,18},{-94,18}}, color={0,0,127}));
    connect(bloodGases.CO2v, CO2v) annotation (Line(points={{-8.44,66.02},{1.78,
            66.02},{1.78,64},{30,64}}, color={0,0,127}));
    connect(bloodGases.O2v, O2v) annotation (Line(points={{-8.44,70.64},{-2,
            70.64},{-2,74},{24,74}}, color={0,0,127}));
    connect(venBlood.ctO2, O2v) annotation (Line(points={{16.6,15.2353},{-2,
            15.2353},{-2,74},{24,74}}, color={0,0,127}));
    connect(venBlood.ctCO2, CO2v) annotation (Line(points={{16.6,10.1765},{2,
            10.1765},{2,64},{30,64}}, color={0,0,127}));
    connect(venBlood.BEox, BEox) annotation (Line(points={{16.6,5.11765},{-0.7,
            5.11765},{-0.7,7},{-23,7}}, color={0,0,127}));
    connect(venBlood.pO2, pO2_v) annotation (Line(points={{75.4,13.2118},{80.7,
            13.2118},{80.7,27},{95,27}}, color={0,0,127}));
    connect(venBlood.pCO2, pCO2_v) annotation (Line(points={{75.4,8.15294},{
            81.7,8.15294},{81.7,19},{97,19}}, color={0,0,127}));
    connect(venBlood.pH, pH_v) annotation (Line(points={{75.4,2.08235},{86,
            2.08235},{86,9},{95,9}}, color={0,0,127}));
    connect(venBlood.cHCO3, cHCO3_v) annotation (Line(points={{75.4,-2.97647},{
            82.7,-2.97647},{82.7,-2},{97,-2}}, color={0,0,127}));
    connect(venBlood.sO2, sO2_v) annotation (Line(points={{75.4,-8.03529},{82,
            -8.03529},{82,-12},{96,-12}}, color={0,0,127}));
    annotation(Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}),
          graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-106},{114,-138}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}),                                                                                                 Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})));
  end SimplestTissue;

  model BloodGases

    Physiolibrary.Types.RealIO.MolarFlowRateInput MCO2 annotation (Placement(
          transformation(extent={{-114,-74},{-94,-54}}),
                                                       iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-103,-67})));
    Physiolibrary.Types.RealIO.MolarFlowRateInput MO2 annotation (Placement(
          transformation(extent={{-114,-44},{-94,-24}}),
                                                       iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-105,-35})));

    Physiolibrary.Types.RealIO.VolumeFlowRateInput Q annotation (Placement(
          transformation(extent={{-104,-26},{-82,-4}}),  iconTransformation(
            extent={{-114,-12},{-92,10}})));
    Physiolibrary.Types.RealIO.ConcentrationInput O2a annotation (Placement(
          transformation(extent={{-110,6},{-86,30}}),   iconTransformation(extent=
             {{-110,76},{-90,96}})));
    Physiolibrary.Types.RealIO.ConcentrationInput CO2a annotation (Placement(
          transformation(extent={{-110,38},{-88,60}}),  iconTransformation(extent=
             {{-110,54},{-90,74}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput CO2v annotation (Placement(
          transformation(extent={{-2,38},{18,58}}),     iconTransformation(extent=
             {{88,52},{108,72}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput O2v annotation (Placement(
          transformation(extent={{-8,64},{12,84}}),     iconTransformation(extent=
             {{88,74},{108,94}})));
  equation

  CO2v=MCO2/Q+CO2a;
  O2v=O2a-MO2/Q;

    annotation(Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}),
          graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-106},{114,-138}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}),                                                                                                 Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})));
  end BloodGases;

  model PlasmaVolume
    Physiolibrary.Types.RealIO.ConcentrationInput Hb annotation (Placement(
          transformation(extent={{-122,-28},{-106,-12}}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-98,60})));
    Physiolibrary.Types.RealIO.VolumeInput bloodVolume annotation (Placement(
          transformation(extent={{-192,-158},{-152,-118}}), iconTransformation(
            extent={{-110,6},{-90,26}})));
    Physiolibrary.Types.RealIO.VolumeOutput plasmaVolume annotation (Placement(
          transformation(extent={{-196,-146},{-176,-126}}), iconTransformation(
            extent={{96,58},{116,78}})));
    Physiolibrary.Types.RealIO.FractionOutput hematocrit annotation (Placement(
          transformation(extent={{-202,-206},{-182,-186}}), iconTransformation(
            extent={{96,2},{116,22}})));
    parameter  Physiolibrary.Types.Concentration ctHbE=21;
  equation

    hematocrit = Hb/ctHbE;
    plasmaVolume=bloodVolume*(1-hematocrit);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-102},{100,-118}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.None,
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end PlasmaVolume;

  model SID_calculation
    Physiolibrary.Types.RealIO.TemperatureInput temp annotation (Placement(
          transformation(extent={{-56,70},{-32,94}}), iconTransformation(extent={{
              -108,86},{-94,100}})));
    Physiolibrary.Types.RealIO.ConcentrationInput ctHb annotation (Placement(
          transformation(extent={{-104,-32},{-76,-4}}), iconTransformation(extent=
             {{-108,66},{-92,82}})));
    Physiolibrary.Types.RealIO.ConcentrationInput cAlb annotation (Placement(
          transformation(extent={{-106,2},{-82,26}}), iconTransformation(extent={{
              -108,42},{-92,58}})));
    Physiolibrary.Types.RealIO.ConcentrationInput cPi annotation (Placement(
          transformation(extent={{-108,24},{-82,50}}), iconTransformation(extent={
              {-108,18},{-92,34}})));
    Physiolibrary.Types.RealIO.ConcentrationInput BEox annotation (Placement(
          transformation(extent={{-108,54},{-88,74}}), iconTransformation(extent={
              {-108,-8},{-92,8}})));
    Physiolibrary.Types.RealIO.PressureInput pCO2 annotation (Placement(
          transformation(extent={{-60,44},{-34,70}}), iconTransformation(extent={{
              -108,-30},{-92,-14}})));
    Physiolibrary.Types.RealIO.FractionInput sO2 annotation (Placement(
          transformation(extent={{-108,-58},{-84,-34}}), iconTransformation(
            extent={{-108,-84},{-92,-68}})));
    Physiolibrary.Types.RealIO.pHInput pH annotation (Placement(transformation(
            extent={{-60,20},{-34,46}}), iconTransformation(extent={{-106,-54},{-90,
              -38}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput SID annotation (Placement(
          transformation(extent={{80,78},{100,98}}), iconTransformation(extent={{100,
              84},{116,100}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput SIDox annotation (Placement(
          transformation(extent={{80,58},{100,78}}), iconTransformation(extent={{100,
              66},{116,82}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput NSIDox annotation (Placement(
          transformation(extent={{80,40},{100,60}}), iconTransformation(extent={{100,
              48},{116,64}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput HCO3ox annotation (Placement(
          transformation(extent={{82,-76},{102,-56}}), iconTransformation(extent={
              {100,28},{116,44}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput HCO3 annotation (Placement(
          transformation(extent={{24,38},{44,58}}), iconTransformation(extent={{100,
              8},{116,24}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Albox annotation (Placement(
          transformation(extent={{80,-32},{100,-12}}), iconTransformation(extent={
              {100,-12},{116,4}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Alb annotation (Placement(
          transformation(extent={{80,-16},{100,4}}), iconTransformation(extent={{100,
              -32},{116,-16}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Piox annotation (Placement(
          transformation(extent={{80,2},{100,22}}), iconTransformation(extent={{100,
              -52},{116,-36}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Pi annotation (Placement(
          transformation(extent={{80,22},{100,42}}), iconTransformation(extent={{100,
              -70},{116,-54}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput BE annotation (Placement(
          transformation(extent={{82,-98},{102,-78}}), iconTransformation(extent={
              {100,-92},{116,-76}})));
    AcidBaseBalance.Acidbase.OSA.plasmaHCO3 plasmaHCO3_1
      annotation (Placement(transformation(extent={{0,-24},{40,18}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,127},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-102},{100,-118}},
            lineColor={0,0,127},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));

  end SID_calculation;

  model SID
    Physiolibrary.Types.RealIO.TemperatureInput temp annotation (Placement(
          transformation(extent={{-100,58},{-76,82}}),iconTransformation(extent={{
              -108,86},{-94,100}})));
    Physiolibrary.Types.RealIO.ConcentrationInput cAlb annotation (Placement(
          transformation(extent={{-114,40},{-90,64}}),iconTransformation(extent={{
              -108,42},{-92,58}})));
    Physiolibrary.Types.RealIO.ConcentrationInput cPi annotation (Placement(
          transformation(extent={{-114,18},{-88,44}}), iconTransformation(extent={
              {-108,18},{-92,34}})));
    Physiolibrary.Types.RealIO.ConcentrationInput BEox annotation (Placement(
          transformation(extent={{-48,-92},{-28,-72}}),iconTransformation(extent={
              {-108,-8},{-92,8}})));
    Physiolibrary.Types.RealIO.PressureInput pCO2 annotation (Placement(
          transformation(extent={{-96,82},{-70,108}}),iconTransformation(extent={{-108,
              -64},{-92,-48}})));
    Physiolibrary.Types.RealIO.pHInput pH annotation (Placement(transformation(
            extent={{-116,0},{-90,26}}), iconTransformation(extent={{-106,-88},{-90,
              -72}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput SID annotation (Placement(
          transformation(extent={{36,-86},{56,-66}}),iconTransformation(extent={{100,
              84},{116,100}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput NSID annotation (Placement(
          transformation(extent={{24,-2},{44,18}}), iconTransformation(extent={{100,6},
              {116,22}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput HCO3 annotation (Placement(
          transformation(extent={{-4,70},{16,90}}), iconTransformation(extent={{100,-34},
              {116,-18}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Alb annotation (Placement(
          transformation(extent={{100,28},{120,48}}),iconTransformation(extent={{100,-64},
              {116,-48}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Pi annotation (Placement(
          transformation(extent={{96,8},{116,28}}),  iconTransformation(extent={{100,-84},
              {116,-68}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Buf;
    Physiolibrary.Types.RealIO.ConcentrationOutput BufSum;
    AcidBaseBalance.Acidbase.OSA.plasmaHCO3 plasmaHCO3_norm
      annotation (Placement(transformation(extent={{-58,-50},{-18,-8}})));
    Physiolibrary.Types.Constants.PressureConst pCO240(k=5332.8954966)
      annotation (Placement(transformation(extent={{-82,-10},{-74,-2}})));
    Physiolibrary.Types.Constants.pHConst pH74(k=7.4)
      annotation (Placement(transformation(extent={{-84,-36},{-76,-28}})));
    Physiolibrary.Types.Constants.TemperatureConst t37(k=310.15)
      annotation (Placement(transformation(extent={{-90,-60},{-82,-52}})));
    AlbPiFencl albPiFencl
      annotation (Placement(transformation(extent={{-56,36},{-32,60}})));
    AlbPiFencl albPiFencl_norm
      annotation (Placement(transformation(extent={{-56,0},{-26,30}})));
    AcidBaseBalance.Acidbase.OSA.plasmaHCO3 plasmaHCO3_act
      annotation (Placement(transformation(extent={{-48,68},{-26,90}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput SIDox annotation (Placement(
          transformation(extent={{36,-58},{56,-38}}), iconTransformation(extent={{
              100,52},{116,68}})));
    Physiolibrary.Types.RealIO.ConcentrationInput BE annotation (Placement(
          transformation(extent={{-20,-84},{0,-64}}),   iconTransformation(extent=
             {{-108,-34},{-92,-18}})));
  equation
    NSID=plasmaHCO3_norm.cHCO3+albPiFencl_norm.Alb+albPiFencl_norm.Pi;
    SIDox=BEox+NSID;
    SID = BE + NSID;
    HCO3=plasmaHCO3_act.cHCO3;
    Buf=SID-HCO3;
    BufSum=albPiFencl.Alb+albPiFencl.Pi;
    Pi=albPiFencl.Pi*Buf/BufSum;
    Alb=albPiFencl.Pi*Buf/BufSum;

    connect(pCO240.y, plasmaHCO3_norm.pCO2) annotation (Line(points={{-73,-6},{-68,
            -6},{-68,-12.2},{-60,-12.2}}, color={0,0,127}));
    connect(pH74.y, plasmaHCO3_norm.pH) annotation (Line(points={{-75,-32},{-68,-32},
            {-68,-20.6},{-60,-20.6}}, color={0,0,127}));
    connect(t37.y, plasmaHCO3_norm.Temp) annotation (Line(points={{-81,-56},{-74,-56},
            {-74,-48.53},{-60.6,-48.53}}, color={0,0,127}));
    connect(albPiFencl.pH, pH) annotation (Line(points={{-55.76,40.08},{-74,
            40.08},{-74,13},{-103,13}}, color={0,0,127}));
    connect(cAlb, albPiFencl.cAlb) annotation (Line(points={{-102,52},{-88,52},
            {-88,57.36},{-55.76,57.36}}, color={0,0,127}));
    connect(albPiFencl.cPi, cPi) annotation (Line(points={{-55.52,50.4},{-84,
            50.4},{-84,31},{-101,31}}, color={0,0,127}));
    connect(albPiFencl_norm.cAlb, albPiFencl.cAlb) annotation (Line(points={{
            -55.7,26.7},{-68,26.7},{-68,57.36},{-55.76,57.36}}, color={0,0,127}));
    connect(albPiFencl_norm.cPi, cPi) annotation (Line(points={{-55.4,18},{-70,
            18},{-70,52},{-84,52},{-84,31},{-101,31}}, color={0,0,127}));
    connect(albPiFencl_norm.pH, plasmaHCO3_norm.pH) annotation (Line(points={{-55.7,
            5.1},{-64,5.1},{-64,-32},{-68,-32},{-68,-20.6},{-60,-20.6}}, color={0,
            0,127}));
    connect(NSID, NSID)
      annotation (Line(points={{34,8},{34,8}}, color={0,0,127}));
    connect(plasmaHCO3_act.Temp, temp) annotation (Line(points={{-49.43,68.77},{
            -64.715,68.77},{-64.715,70},{-88,70}}, color={0,0,127}));
    connect(plasmaHCO3_act.pCO2, pCO2) annotation (Line(points={{-49.1,87.8},{-58,
            87.8},{-58,95},{-83,95}}, color={0,0,127}));
    connect(pH, plasmaHCO3_act.pH) annotation (Line(points={{-103,13},{-74,13},{
            -74,83.4},{-49.1,83.4}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,127},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-102},{100,-118}},
            lineColor={0,0,127},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end SID;

  model AlbPiFencl
    Physiolibrary.Types.RealIO.ConcentrationInput cAlb "albumin concentration"
      annotation (Placement(transformation(extent={{-116,2},{-76,42}}),
          iconTransformation(extent={{-118,58},{-78,98}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Alb "alb charge in mmol/l"
      annotation (Placement(transformation(extent={{82,40},{102,60}}),
          iconTransformation(extent={{88,4},{108,24}})));
    Physiolibrary.Types.RealIO.pHInput pH annotation (Placement(transformation(
            extent={{-116,-58},{-76,-18}}), iconTransformation(extent={{-118,-86},
              {-78,-46}})));
    Physiolibrary.Types.RealIO.ConcentrationInput cPi "phosphate concentration"
      annotation (Placement(transformation(extent={{-118,52},{-78,92}}),
          iconTransformation(extent={{-116,0},{-76,40}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput Pi
      "Phosphate charge in mmol/l" annotation (Placement(transformation(extent={{86,
              -48},{106,-28}}), iconTransformation(extent={{88,-30},{108,-10}})));
    Real AlbG_dl = cAlb*6.646;

  equation
     Alb=(cAlb*10)*(0.123*pH - 0.631) "albumin total charge (Fencl)";

     Pi = cPi*(0.309*pH - 0.469)
      "Total charge of phosphates (Fencl)";
    annotation (Icon(graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-100},{100,-120}},
            lineColor={28,108,200},
            textString="%name")}));
  end AlbPiFencl;

  model SimplestTissueAndSID

    Physiolibrary.Types.RealIO.MolarFlowRateInput MCO2 annotation (Placement(
          transformation(extent={{-100,12},{-88,24}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-103,-67})));
    Physiolibrary.Types.RealIO.MolarFlowRateInput MO2 annotation (Placement(
          transformation(extent={{-100,24},{-88,36}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-105,-35})));

    Physiolibrary.Types.RealIO.VolumeFlowRateInput Q annotation (Placement(
          transformation(extent={{-102,36},{-86,52}}),   iconTransformation(
            extent={{-114,-12},{-92,10}})));
    Physiolibrary.Types.RealIO.ConcentrationInput O2a annotation (Placement(
          transformation(extent={{-98,66},{-84,80}}),   iconTransformation(extent=
             {{-110,76},{-90,96}})));
    Physiolibrary.Types.RealIO.ConcentrationInput CO2a annotation (Placement(
          transformation(extent={{-100,54},{-86,68}}),  iconTransformation(extent={{-110,52},
              {-90,72}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput CO2v annotation (Placement(
          transformation(extent={{24,58},{36,70}}),     iconTransformation(extent={{88,58},
              {108,78}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput O2v annotation (Placement(
          transformation(extent={{18,68},{30,80}}),     iconTransformation(extent={{88,80},
              {108,100}})));
    BloodGases bloodGases
      annotation (Placement(transformation(extent={{-52,32},{-8,74}})));
    AcidBaseBalance.Acidbase.OSA.O2CO2
          artBlood
      annotation (Placement(transformation(extent={{16,-48},{72,38}})));
    Physiolibrary.Types.RealIO.ConcentrationInput BEox annotation (Placement(
          transformation(extent={{-30,0},{-16,14}}), iconTransformation(extent=
              {{-110,28},{-90,48}})));
    Physiolibrary.Types.RealIO.PressureOutput pO2_v(start=13300) annotation (
        Placement(transformation(extent={{88,20},{102,34}}), iconTransformation(
            extent={{90,14},{110,34}})));
    Physiolibrary.Types.RealIO.PressureOutput pCO2_v(start=5333) annotation (
        Placement(transformation(extent={{90,12},{104,26}}), iconTransformation(
            extent={{90,-6},{110,14}})));
    Physiolibrary.Types.RealIO.pHOutput pH_v(start=7.4) annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={95,9}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={100,-20})));
    Physiolibrary.Types.RealIO.ConcentrationOutput cHCO3_v(displayUnit="mmol/l")
      "outgoing concentration of HCO3" annotation (Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={97,-2}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={100,-40})));
    Physiolibrary.Types.RealIO.FractionOutput sO2_v annotation (Placement(
          transformation(
          extent={{-6,-6},{6,6}},
          rotation=0,
          origin={96,-12}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={100,-60})));
    Physiolibrary.Types.RealIO.ConcentrationOutput BE_v annotation (Placement(
          transformation(extent={{66,76},{78,88}}), iconTransformation(extent={{88,
              36},{108,56}})));
  equation
    BE_v=BEox+0.2*artBlood.ceHb*(1-sO2_v);

    connect(O2a, bloodGases.O2a) annotation (Line(points={{-91,73},{-72.5,73},{
            -72.5,71.06},{-52,71.06}}, color={0,0,127}));
    connect(bloodGases.CO2a, CO2a) annotation (Line(points={{-52,66.44},{-74,
            66.44},{-74,61},{-93,61}}, color={0,0,127}));
    connect(bloodGases.Q, Q) annotation (Line(points={{-52.66,52.79},{-74,52.79},
            {-74,44},{-94,44}}, color={0,0,127}));
    connect(bloodGases.MO2, MO2) annotation (Line(points={{-53.1,45.65},{-70,
            45.65},{-70,30},{-94,30}}, color={0,0,127}));
    connect(bloodGases.MCO2, MCO2) annotation (Line(points={{-52.66,38.93},{-62,
            38.93},{-62,18},{-94,18}}, color={0,0,127}));
    connect(bloodGases.CO2v, CO2v) annotation (Line(points={{-8.44,66.02},{1.78,
            66.02},{1.78,64},{30,64}}, color={0,0,127}));
    connect(bloodGases.O2v, O2v) annotation (Line(points={{-8.44,70.64},{-2,
            70.64},{-2,74},{24,74}}, color={0,0,127}));
    connect(artBlood.ctO2, O2v) annotation (Line(points={{14.6,15.2353},{-2,
            15.2353},{-2,74},{24,74}}, color={0,0,127}));
    connect(artBlood.ctCO2, CO2v) annotation (Line(points={{14.6,10.1765},{2,
            10.1765},{2,64},{30,64}}, color={0,0,127}));
    connect(artBlood.BEox, BEox) annotation (Line(points={{14.6,5.11765},{-0.7,
            5.11765},{-0.7,7},{-23,7}}, color={0,0,127}));
    connect(artBlood.pO2, pO2_v) annotation (Line(points={{73.4,13.2118},{80.7,
            13.2118},{80.7,27},{95,27}}, color={0,0,127}));
    connect(artBlood.pCO2, pCO2_v) annotation (Line(points={{73.4,8.15294},{
            81.7,8.15294},{81.7,19},{97,19}}, color={0,0,127}));
    connect(artBlood.pH, pH_v) annotation (Line(points={{73.4,2.08235},{86,
            2.08235},{86,9},{95,9}}, color={0,0,127}));
    connect(artBlood.cHCO3, cHCO3_v) annotation (Line(points={{73.4,-2.97647},{
            82.7,-2.97647},{82.7,-2},{97,-2}}, color={0,0,127}));
    connect(artBlood.sO2, sO2_v) annotation (Line(points={{73.4,-8.03529},{82,
            -8.03529},{82,-12},{96,-12}}, color={0,0,127}));
    annotation(Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}),
          graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-106},{114,-138}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}),                                                                                                 Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})));
  end SimplestTissueAndSID;

  model SimplestTissueIntgr

    Physiolibrary.Types.RealIO.MolarFlowRateInput MCO2 annotation (Placement(
          transformation(extent={{-100,12},{-88,24}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-103,-67})));
    Physiolibrary.Types.RealIO.MolarFlowRateInput MO2 annotation (Placement(
          transformation(extent={{-100,24},{-88,36}}), iconTransformation(
          extent={{-11,-11},{11,11}},
          rotation=0,
          origin={-105,-35})));

    Physiolibrary.Types.RealIO.VolumeFlowRateInput Q annotation (Placement(
          transformation(extent={{-102,36},{-86,52}}),   iconTransformation(
            extent={{-114,-12},{-92,10}})));
    Physiolibrary.Types.RealIO.ConcentrationInput O2a annotation (Placement(
          transformation(extent={{-98,66},{-84,80}}),   iconTransformation(extent=
             {{-110,76},{-90,96}})));
    Physiolibrary.Types.RealIO.ConcentrationInput CO2a annotation (Placement(
          transformation(extent={{-100,54},{-86,68}}),  iconTransformation(extent={{-110,52},
              {-90,72}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput CO2v annotation (Placement(
          transformation(extent={{24,58},{36,70}}),     iconTransformation(extent={{98,64},
              {118,84}})));
    Physiolibrary.Types.RealIO.ConcentrationOutput O2v annotation (Placement(
          transformation(extent={{18,68},{30,80}}),     iconTransformation(extent={{98,84},
              {118,104}})));
    BloodGases bloodGases
      annotation (Placement(transformation(extent={{-58,32},{-14,74}})));
    Physiolibrary.Types.RealIO.ConcentrationInput BEox annotation (Placement(
          transformation(extent={{-28,-20},{-14,-6}}),
                                                     iconTransformation(extent=
              {{-110,28},{-90,48}})));
    Physiolibrary.Types.RealIO.PressureOutput pO2_v(start=13300) annotation (
        Placement(transformation(extent={{86,20},{100,34}}), iconTransformation(
            extent={{98,44},{118,64}})));
    Physiolibrary.Types.RealIO.PressureOutput pCO2_v(start=5333) annotation (
        Placement(transformation(extent={{98,14},{112,28}}), iconTransformation(
            extent={{98,24},{118,44}})));
    Physiolibrary.Types.RealIO.pHOutput pH_v(start=7.4) annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={93,11}),iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={108,14})));
    Physiolibrary.Types.RealIO.ConcentrationOutput cHCO3_v(displayUnit="mmol/l")
      "outgoing concentration of HCO3" annotation (Placement(transformation(
          extent={{-7,-7},{7,7}},
          rotation=0,
          origin={97,4}),  iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={110,-4})));
    Physiolibrary.Types.RealIO.FractionOutput sO2_v annotation (Placement(
          transformation(
          extent={{-6,-6},{6,6}},
          rotation=0,
          origin={96,-12}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={110,-24})));
    Physiolibrary.Types.RealIO.MolarFlowRateOutput DO2 annotation (Placement(
          transformation(extent={{86,-68},{106,-48}}), iconTransformation(extent={{100,-54},
              {120,-34}})));
    Physiolibrary.Types.RealIO.MolarFlowRateOutput DCO2 annotation (Placement(
          transformation(extent={{88,-86},{108,-66}}), iconTransformation(extent={
              {100,-98},{120,-78}})));
    Physiolibrary.Types.RealIO.FractionOutput OER annotation (Placement(
          transformation(extent={{90,-96},{110,-76}}),    iconTransformation(
            extent={{100,-76},{120,-56}})));
    AcidBaseBalance.Acidbase.OSA.O2CO2_by_integration o2CO2_by_integration
      annotation (Placement(transformation(extent={{12,-42},{78,54}})));
  equation
    DO2=O2a*Q;
    OER=MO2/DO2;
    DCO2=CO2v*Q;
    connect(O2a, bloodGases.O2a) annotation (Line(points={{-91,73},{-72.5,73},{
            -72.5,71.06},{-58,71.06}}, color={0,0,127}));
    connect(bloodGases.CO2a, CO2a) annotation (Line(points={{-58,66.44},{-74,
            66.44},{-74,61},{-93,61}}, color={0,0,127}));
    connect(bloodGases.Q, Q) annotation (Line(points={{-58.66,52.79},{-74,52.79},
            {-74,44},{-94,44}}, color={0,0,127}));
    connect(bloodGases.MO2, MO2) annotation (Line(points={{-59.1,45.65},{-70,
            45.65},{-70,30},{-94,30}}, color={0,0,127}));
    connect(bloodGases.MCO2, MCO2) annotation (Line(points={{-58.66,38.93},{-62,
            38.93},{-62,18},{-94,18}}, color={0,0,127}));
    connect(bloodGases.CO2v, CO2v) annotation (Line(points={{-14.44,66.02},{
            1.78,66.02},{1.78,64},{30,64}},
                                       color={0,0,127}));
    connect(bloodGases.O2v, O2v) annotation (Line(points={{-14.44,70.64},{-2,
            70.64},{-2,74},{24,74}}, color={0,0,127}));
    connect(o2CO2_by_integration.BEox, BEox) annotation (Line(points={{8.7,
            -11.1429},{0,-11.1429},{0,-13},{-21,-13}}, color={0,0,127}));
    connect(o2CO2_by_integration.pO2, pO2_v) annotation (Line(points={{81.3,
            27.2571},{81.3,27},{93,27}}, color={0,0,127}));
    connect(o2CO2_by_integration.pCO2, pCO2_v) annotation (Line(points={{81.3,
            20.4},{81.3,21},{105,21}}, color={0,0,127}));
    connect(o2CO2_by_integration.pH, pH_v) annotation (Line(points={{81.3,
            12.1714},{84.15,12.1714},{84.15,11},{93,11}}, color={0,0,127}));
    connect(o2CO2_by_integration.cHCO3, cHCO3_v) annotation (Line(points={{81.3,
            5.31429},{81.3,4},{97,4}}, color={0,0,127}));
    connect(sO2_v, o2CO2_by_integration.sO2) annotation (Line(points={{96,-12},
            {84,-12},{84,-1.54286},{81.3,-1.54286}}, color={0,0,127}));
    connect(o2CO2_by_integration.ctO2, O2v) annotation (Line(points={{8.7,
            26.5714},{-6,26.5714},{-6,38},{-6,70},{-4,70},{-2,70},{-2,74},{24,
            74}}, color={0,0,127}));
    connect(o2CO2_by_integration.ctCO2, CO2v) annotation (Line(points={{9.36,
            9.42857},{-2,9.42857},{-2,64},{30,64}}, color={0,0,127}));
    annotation(Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}),
          graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,-106},{114,-138}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}),                                                                                                 Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})));
  end SimplestTissueIntgr;

  model Hb_mmol_to_g
    Physiolibrary.Types.RealIO.ConcentrationInput Hb_mmol annotation (Placement(
          transformation(extent={{-142,-14},{-102,26}}), iconTransformation(
            extent={{-140,-20},{-100,20}})));
    Physiolibrary.Types.RealIO.MassConcentrationOutput Hb_g annotation (Placement(
          transformation(extent={{110,-10},{130,10}}), iconTransformation(extent={
              {100,-18},{138,20}})));
  equation
    Hb_g*0.6206 = Hb_mmol;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,98},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-42,80},{26,-20}},
            textColor={28,108,200},
            textString="Hb"),
          Polygon(
            points={{-78,-24},{-78,-42},{78,-30},{-78,-24}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-108,-106},{108,-126}},
            textColor={28,108,200},
            textString="%name")}),
                                Diagram(coordinateSystem(preserveAspectRatio=false)));
  end Hb_mmol_to_g;

  model conc_mmol_to_ml
    Physiolibrary.Types.RealIO.ConcentrationInput mmol_per_liter annotation (
        Placement(transformation(extent={{-142,-14},{-102,26}}),
          iconTransformation(extent={{-138,-20},{-98,20}})));
    Modelica.Blocks.Interfaces.RealOutput ml_per_liter annotation (Placement(
          transformation(extent={{240,60},{260,80}}), iconTransformation(extent={{
              100,-18},{136,18}})));
  equation
     ml_per_liter = mmol_per_liter *22.392;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,98},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-102,40},{100,14}},
            textColor={28,108,200},
            textString="STPD"),
          Polygon(
            points={{-78,-24},{-78,-42},{78,-30},{-78,-24}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-122,-102},{118,-126}},
            textColor={28,108,200},
            textString="%name")}),
                                Diagram(coordinateSystem(preserveAspectRatio=false)));
  end conc_mmol_to_ml;

  model flow_mmol_to_ml
    Physiolibrary.Types.RealIO.VolumeFlowRateOutput volumeflowrate annotation (
        Placement(transformation(extent={{238,-12},{258,8}}), iconTransformation(
            extent={{100,-16},{134,18}})));
    Physiolibrary.Types.RealIO.MolarFlowRateInput molarflowrate annotation (
        Placement(transformation(extent={{-270,24},{-230,64}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));
  equation
     volumeflowrate = molarflowrate *22.392;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,98},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid), Text(
            extent={{-102,40},{100,14}},
            textColor={28,108,200},
            textString="STPD"),
          Polygon(
            points={{-78,-24},{-78,-42},{78,-30},{-78,-24}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-114,-108},{138,-136}},
            textColor={28,108,200},
            textString="%name")}),
                                Diagram(coordinateSystem(preserveAspectRatio=false)));
  end flow_mmol_to_ml;
  annotation (uses(
      Modelica(version="4.0.0"),
      Physiolibrary(version="2.4.1"),
      AcidBaseBalance(version="1")),
    version="2",
    conversion(noneFromVersion="", noneFromVersion="1"));
end Simplest;
