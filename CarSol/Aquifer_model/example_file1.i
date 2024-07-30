# Two phase Theis problem: Flow from single source using WaterNCG fluidstate.
# Constant rate injection 2 kg/s
# 1D cylindrical mesh
# Initially, system has only a liquid phase, until enough gas is injected
# to form a gas phase, in which case the system becomes two phase.

[Mesh]
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

[GlobalParams]
    PorousFlowDictator = dictator
    gravity = '0 0 0'
    # block = 0
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

[Variables]
  [pgas]
  #  initial_condition = 20e6
  []
  [zi]
    initial_condition = 0
  []
[]
[ICs]
    [pgas]
      type = FunctionIC
      variable = pgas
      function = '31.28924e6 + (1000*9.81*(19 - z))'
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
#   [pc]
#     type = PorousFlowCapillaryPressureConst
#     pc = 0
#     sat_lr = 0.3
#   []
  [fs]
    type = PorousFlowWaterNCG
    water_fp = water
    gas_fp = co2
    capillary_pressure = pc
  []
  [injected_mass]
    type = PorousFlowSumQuantity
    []
[]

[FluidProperties]
  [co2]
    type = CO2FluidProperties
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

[BCs]
    [top]
      type  = NeumannBC
      variable = pgas
      boundary = top
      value = 0
    []
    [bottom]
      type  = NeumannBC
      variable = pgas
      boundary = bottom
      value = 0
    []
    [surface_boundary]
      type  = NeumannBC
      variable = pgas
      boundary = rmax
      value = 0
    []
  []

[DiracKernels]
[wells]
    type  = PorousFlowPolyLineSink
    SumQuantityUO = injected_mass
    point_file = carbsol.bh
    variable = zi
    function_of = pressure
    fluid_phase = 1
    p_or_t_vals = 0
    fluxes = -1.66779
    multiplying_var = 2
[]
[]

# [BCs]
#   [rightwater]
#     type = DirichletBC
#     boundary = right
#     value = 20e6
#     variable = pgas
#   []
# []

# [DiracKernels]
#   [source]
#     type = PorousFlowSquarePulsePointSource
#     point = '0 0 0'
#     mass_flux = 2
#     variable = zi
#   []
# []

[Preconditioning]
  [smp]
    type = SMP
    full = true
    petsc_options = '-snes_converged_reason -ksp_diagonal_scale -ksp_diagonal_scale_fix -ksp_gmres_modifiedgramschmidt -snes_linesearch_monitor'
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'gmres      asm      lu           NONZERO                   2               1E-8       1E-10 20'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = 94608e4
  num_steps = 3000
  dtmax = 31536e3
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    growth_factor = 2
  []
[]

[VectorPostprocessors]
  [line]
    type = NodalValueSampler
    sort_by = x
    variable = 'pgas zi'
    execute_on = 'timestep_end'
  []
[]

[Postprocessors]
  [pgas]
    type = PointValue
    point = '0 0 19'
    variable = pgas
  []
  [pgasphase]
    type = PointValue
    point = '0 0 19'
    variable = pgasphase
  []
  [pwater]
    type = PointValue
    point = '0 0 19'
    variable = pwater
  []
  [sgas]
    type = PointValue
    point = '0 0 19'
    variable = saturation_gas
  []
  [zi]
    type = PointValue
    point = '0 0 19'
    variable = zi
  []
  [massgas]
    type = PorousFlowFluidMass
    fluid_component = 1
  []
  [CO2massfrac_aq]
    type = PointValue
    point = '0 0 19'
    variable = CO2massfrac_aq
  []
  [H2Omassfrac_gas]
    type = PointValue
    point = '0 0 19'
    variable = H2Omassfrac_gas
  []
  [pls_report]
    type = PorousFlowPlotQuantity
    uo = injected_mass
  []
  [capillary_pressure]
    type = PointValue
    point = '0 0 19'
    variable = pc
  []
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
  perf_graph = true
  [csvout]
    type = CSV
    execute_on = timestep_end
    execute_vector_postprocessors_on = final
  []
[]
