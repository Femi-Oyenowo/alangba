# Unsaturated Darcy-Richards flow without using an Action
[Mesh]
  [annular]
    type = AnnularMeshGenerator
    nr = 1000
    rmin = 0.5
    rmax = 34700
    growth_r = 1.4
    nt = 4
    dmin = 0
    dmax = 90
  []
  [make3D]
    input = annular
    type = MeshExtruderGenerator
    extrusion_vector = '0 0 19'
    num_layers = 19
    bottom_sideset = 'bottom'
    top_sideset = 'top'
  []
#   [shift_down]
#     type = TransformGenerator
#     transform = TRANSLATE
#     vector_value = '0 0 -6'
#     input = make3D
#   []
  [aquifer]
    type = SubdomainBoundingBoxGenerator
    block_id = 1
    bottom_left = '0 0 0'
    top_right = '1000 1000 19'
    input = make3D
  []
  [injection_area]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x*x+y*y=0.25'
    included_subdomains = 1
    new_sideset_name = 'injection_area'
    input = 'aquifer'
  []
  [rename]
    type = RenameBlockGenerator
    old_block = '0 1'
    new_block = 'caps aquifer'
    input = 'injection_area'
  []
[]

[UserObjects]
    [dictator]
      type = PorousFlowDictator
      porous_flow_vars = 'pgas zi'
      number_fluid_phases = 2
      number_fluid_components = 2
    []
    [pc]
      type = PorousFlowCapillaryPressureVG
      alpha = 0.491
      m = 0.45946
      sat_lr = 0.3
      []
    [fs]
      type = PorousFlowWaterNCG
      water_fp = water
      gas_fp = tabulated_co2
      capillary_pressure = pc
    []
    # [injected_mass]
    #   type = PorousFlowSumQuantity
    #   []
  []

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 0 0'
[]

[Variables]
    [pgas]
    []
    [zi]
    initial_condition = 0
    []
[]

[ICs]
    [pgas]
      type = FunctionIC
      variable = pgas
      function = '31.28924e6 + (1000*9.81*(19 - z))' #31234274.8
    []
  []

  [Kernels]
    [mass0]
      type = PorousFlowMassTimeDerivative
      fluid_component = 0
      variable = pgas
    []
    [flux0]
      type = PorousFlowAdvectiveFlux
      fluid_component = 0
      variable = pgas
    []
    [mass1]
      type = PorousFlowMassTimeDerivative
      fluid_component = 1
      variable = zi
    []
    [flux1]
      type = PorousFlowAdvectiveFlux
      fluid_component = 1
      variable = zi
    []
  []
  [AuxVariables]
    [pgasphase]
        order = CONSTANT
        family = MONOMIAL
    []
    [pwater]
        order = CONSTANT
        family = MONOMIAL
        []
  [saturation_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [CO2massfrac_aq]
    order = CONSTANT
    family = MONOMIAL
  []
  [H2Omassfrac_gas]
    order = CONSTANT
    family = MONOMIAL
  []
  [pc]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
    [pwater]
        type = PorousFlowPropertyAux
        variable = pwater
        property = pressure
        phase = 0
        execute_on = timestep_end
    []
    [pgasphase]
        type = PorousFlowPropertyAux
        variable = pgasphase
        property = pressure
        phase = 1
        execute_on = timestep_end
    []
  [saturation_gas]
    type = PorousFlowPropertyAux
    variable = saturation_gas
    property = saturation
    phase = 1
    execute_on = timestep_end
  []
  [CO2massfrac_aq]
    type = PorousFlowPropertyAux
    variable = CO2massfrac_aq
    property = mass_fraction
    phase = 0
    fluid_component = 1
    execute_on = timestep_end
  []
  [H2Omassfrac_gas]
    type = PorousFlowPropertyAux
    variable = H2Omassfrac_gas
    property = mass_fraction
    phase = 1
    fluid_component = 0
    execute_on = timestep_end
  []
  [pc]
      type = PorousFlowPropertyAux
      variable = pc
      property = capillary_pressure
      execute_on = 'initial timestep_end'
      gas_phase = 1
      liquid_phase = 0
    []
[]

[BCs]
  [injection]
    type = PorousFlowSink
    variable = pp
    fluid_phase = 0
    flux_function = -31.688#1E-2
    boundary = injection_area
    save_in = flux_in
  []
[]

[FluidProperties]
    [co2]
      type = CO2FluidProperties
    []
    [tabulated_co2]
      type = TabulatedBicubicFluidProperties
      fp = co2
      fluid_property_file = co2_fluid_properties.csv
      interpolated_properties = 'density enthalpy viscosity'
  
      # Bounds of interpolation
      temperature_min = 300
      temperature_max = 400
      pressure_min = 10e6
      pressure_max = 40e6
  
      # Grid discretization
      num_T = 50
      num_p = 100
    []
    [water]
      type = Water97FluidProperties
    []  
[]

[Materials]
    [temperature]
      type = PorousFlowTemperature
      temperature = 66.806
    []
    [waterncg]
      type = PorousFlowFluidState
      gas_porepressure = pgas
      z = zi
      temperature_unit = Celsius
      capillary_pressure = pc
      fluid_state = fs
    []
    [porosity]
      type = PorousFlowPorosityConst
      porosity = 0.2248049
    []
    [permeability]
      type = PorousFlowPermeabilityConst
      permeability = '1.5833e-13 0 0  0 1.5833e-13 0  0 0 1.5833e-13'
    []
    [relperm_water]
      type = PorousFlowRelativePermeabilityVG
      m = 0.45946
      phase = 0
      s_res = 0.300
      sum_s_res = 0.3
    []
    [relperm_gas]
      type = PorousFlowRelativePermeabilityBC
      phase = 1
      s_res = 0.0
      sum_s_res = 0.3
      lambda = 2
      nw_phase = true
    []
  []
  

[Preconditioning]
  active = preferred_but_might_not_be_installed
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 1E6
  dt = 1E5
  nl_abs_tol = 1E-7
[]

[Outputs]
  exodus = true
  [csvout]
    type = CSV
    execute_on = timestep_end
    execute_vector_postprocessors_on = final
  []
[]