# Two-phase borehole injection problem
[Mesh]
  # [annular]
  #   type = AnnularMeshGenerator
  #   nr = 347
  #   rmin = 0.5
  #   rmax = 34700
  #   growth_r = 1
  #   nt = 6
  #   dmin = 0
  #   dmax = 90
  # []
  # [make3D]
  #   input = annular
  #   type = MeshExtruderGenerator
  #   extrusion_vector = '0 0 19'
  #   num_layers = 19
  #   bottom_sideset = 'bottom'
  #   top_sideset = 'top'
  # []
  # [aquifer]
  #   type = SubdomainBoundingBoxGenerator
  #   block_id = 1
  #   bottom_left = '0 0 0'
  #   top_right = '347 347 19'
  #   input = make3D
  # []
  # [injection_area]
  #   type = ParsedGenerateSideset
  #   combinatorial_geometry = 'x*x+y*y<0.251'
  #   included_subdomains = 1
  #   new_sideset_name = 'injection_area'
  #   input = 'aquifer'
  # []
  # # [rename]
  # #   type = RenameBlockGenerator
  # #   old_block = '0 1'
  # #   new_block = 'caps aquifer'
  # #   input = 'injection_area'
  # # []
  # [ed0]
  #   type = BlockDeletionGenerator
  #   input = injection_area
  #   block = '1'
  # []
  [annular]
    type = AnnularMeshGenerator
    nr = 300
    rmin = 0
    rmax = 34700
    nt = 12
    dmin = 0
    dmax = 360
  []
  [aquifer]
      type = MeshExtruderGenerator
      extrusion_vector = '0 0 19'
      num_layers = 19
      input = annular
      bottom_sideset = 'bottom'
      top_sideset = 'top'
  []
  
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pwater pgas'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [pc]
    type = PorousFlowCapillaryPressureVG
    alpha = 0.491
    m = 0.45946
    sat_lr = 0.3
    []
  [injected_mass]
    type = PorousFlowSumQuantity
    []
[]

[GlobalParams]
  gravity = '0 0 0'
  PorousFlowDictator = dictator
[]

[Variables]
  [pwater]
  []
  [pgas]
  []
[]

[ICs]
  [pgas]
    type = FunctionIC
    variable = pgas
    function = '31.28924e6 + (1000*9.81*(19 - z))'
  []
  [pwater]
    type = FunctionIC
    variable = pwater
    function = '31.28924e6 + (1000*9.81*(19 - z))'
  []
[]


[Kernels]
  [mass_water_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pwater
  []
  [flux_water]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    use_displaced_mesh = false
    variable = pwater
  []
  [mass_co2_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = pgas
  []
  [flux_co2]
    type = PorousFlowAdvectiveFlux
    fluid_component = 1
    use_displaced_mesh = false
    variable = pgas
  []
[]

[AuxVariables]
  [pgasphase]
    order = CONSTANT
    family = MONOMIAL
    []
  [pwaterphase]
    order = CONSTANT
    family = MONOMIAL
    []
  [mass_frac_phase0_species0]
    initial_condition = 1 # all water in phase=0
  []
  [mass_frac_phase1_species0]
    initial_condition = 0 # no water in phase=1
  []
  [sgas]
    family = MONOMIAL
    order = CONSTANT
  []
  [swater]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [pwaterphase]
      type = PorousFlowPropertyAux
      variable = pwaterphase
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
  [swater]
    type = PorousFlowPropertyAux
    variable = swater
    property = saturation
    phase = 0
    execute_on = timestep_end
  []
  [sgas]
    type = PorousFlowPropertyAux
    variable = sgas
    property = saturation
    phase = 1
    execute_on = timestep_end
  []
[]


# [BCs]
#   [constant_co2_injection]
#     type = PorousFlowSink
#     boundary = injection_area
#     variable = pgas
#     fluid_phase = 1
#     flux_function = -1E-2
#     use_displaced_mesh = false
#   []
# []
[DiracKernels]
  [wells]
      type  = PorousFlowPolyLineSink
      SumQuantityUO = injected_mass
      point_file = carbsol.bh
      variable = pgas
      function_of = pressure
      fluid_phase = 1
      p_or_t_vals = 0
      fluxes = -1.66779
      multiplying_var = 2
  []
  []

[FluidProperties]
  [true_water]
    type = Water97FluidProperties
  []
  [tabulated_water]
    type = TabulatedBicubicFluidProperties #TabulatedFluidProperties
    fp = true_water
    temperature_min = 275
    pressure_max = 1E8
    interpolated_properties = 'density viscosity enthalpy internal_energy'
    fluid_property_file = water97_tabulated_11.csv
  []
  [true_co2]
    type = CO2FluidProperties
  []
  [tabulated_co2]
    type = TabulatedBicubicFluidProperties #TabulatedFluidProperties
    fp = true_co2
    temperature_min = 275
    pressure_max = 1E8
    interpolated_properties = 'density viscosity enthalpy internal_energy'
    fluid_property_file = co2_tabulated_11.csv
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = 339.956
  []
  [saturation_calculator]
    type = PorousFlow2PhasePP
    phase0_porepressure = pwater
    phase1_porepressure = pgas
    capillary_pressure = pc
  []
  [massfrac]
    type = PorousFlowMassFraction
    mass_fraction_vars = 'mass_frac_phase0_species0 mass_frac_phase1_species0'
  []
  [water]
    type = PorousFlowSingleComponentFluid
    fp = tabulated_water
    phase = 0
  []
  [co2]
    type = PorousFlowSingleComponentFluid
    fp = tabulated_co2
    phase = 1
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
  [relperm_co2]
    type = PorousFlowRelativePermeabilityBC
    phase = 1
    s_res = 0.0
    sum_s_res = 0.3
    lambda = 2
    nw_phase = true
  []
[]

[Postprocessors]
[mCO2_injected]
  type = PorousFlowPlotQuantity
  uo = injected_mass
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
  end_time = 1E9
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1E3
    growth_factor = 1.2
    # optimal_iterations = 10
  []
  nl_abs_tol = 1E-7
[]

[Outputs]
  exodus = true
  csv = true
[]
