# Two-phase flow, CO2 injection into aquifer
# Carbon Solutions LLC
# INL model for MOOSE comparison  [Limited injection rate: 1.0 MMT/yr]

[Mesh]
    [annular]
      type = AnnularMeshGenerator
      nr = 30#0
      rmin = 0.5
      rmax = 34#700
      growth_r = 1
      nt = 12
      dmin = 0
      dmax = 360
    []
    [aquifer]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 19'
        num_layers = 19
        #bottom_sideset = 'bottom'
        #top_sideset = 'top'
	#block_id = 1
        input = annular
    []
    [cap]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 331'
        input = annular
	num_layers = 331
	#block_id = 0
    []
    [injection_area]
        type = ParsedGenerateSideset
        combinatorial_geometry = 'x*x+y*y < 0.251'
        new_sideset_name = 'injection_area'
        input = 'aquifer'
    []
    [stack]
	type = StackGenerator
	inputs = 'injection_area cap'
	dim = 3
    []    
[]
[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [pp]
    initial_condition = 1E7
  []
[]

[Kernels]
  [mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pp
  []
[]

[UserObjects]
  [borehole_total_outflow_mass]
    type = PorousFlowSumQuantity
  []
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp'
    number_fluid_phases = 1
    number_fluid_components = 1
  []
  [pc]
    type = PorousFlowCapillaryPressureVG
    m = 0.5
    alpha = 1e-7
  []
[]

[FluidProperties]
  [simple_fluid]
    type = SimpleFluidProperties
    bulk_modulus = 2e9
    viscosity = 1e-3
    density0 = 1000
    thermal_expansion = 0
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
  []
  [ppss]
    type = PorousFlow1PhaseP
    porepressure = pp
    capillary_pressure = pc
  []
  [massfrac]
    type = PorousFlowMassFraction
  []
  [simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  []
  [porosity]
    type = PorousFlowPorosityConst
    porosity = 0.1
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-12 0 0 0 1E-12 0 0 0 1E-12'
  []
  [relperm]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 0
  []
[]

[DiracKernels]
  [bh]
    type = PorousFlowPeacemanBorehole

    # Because the Variable for this Sink is pp, and pp is associated
    # with the fluid-mass conservation equation, this sink is extracting
    # fluid mass (and not heat energy or something else)
    variable = pp


    # The following specfies that the total fluid mass coming out of
    # the porespace via this sink in this timestep should be recorded
    # in the pls_total_outflow_mass UserObject
    SumQuantityUO = borehole_total_outflow_mass


    # The following file defines the polyline geometry
    # which is just two points in this particular example
    point_file = bh02.bh


    # First, we want Peacemans f to be a function of porepressure (and not
    # temperature or something else).  So bottom_p_or_t is actually porepressure
    function_of = pressure
    fluid_phase = 0

    # The bottomhole pressure
    bottom_p_or_t = 0

    # In this example there is no increase of the wellbore pressure
    # due to gravity:
    unit_weight = '0 0 0'

    # PeacemanBoreholes should almost always have use_mobility = true
    use_mobility = true

    # This is a production wellbore (a sink of fluid that removes fluid from porespace)
    character = 1
  []
[]

[Postprocessors]
  [bh_report]
    type = PorousFlowPlotQuantity
    uo = borehole_total_outflow_mass
  []
  [fluid_mass0]
    type = PorousFlowFluidMass
    execute_on = timestep_begin
  []

  [fluid_mass1]
    type = PorousFlowFluidMass
    execute_on = timestep_end
  []

  [zmass_error]
    type = FunctionValuePostprocessor
    function = mass_bal_fcn
    execute_on = timestep_end
    indirect_dependencies = 'fluid_mass1 fluid_mass0 bh_report'
  []

  [p0]
    type = PointValue
    variable = pp
    point = '0 0 0'
    execute_on = timestep_end
  []
[]

[Variables]
    [dummy_var]
    []
[]
[Kernels]
    [dummy_diffusion]
        type = Diffusion
        variable = dummy_var
    []
[]
  
[Executioner]
    type = Steady
[]
  
[Outputs]
    file_base = 3D_mesh
    exodus = true
[]