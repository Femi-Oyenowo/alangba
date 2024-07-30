# Two-phase flow, CO2 injection into aquifer
# Carbon Solutions LLC
# INL model for MOOSE comparison  [Limited injection rate: 1.0 MMT/yr]

[Mesh]
    [annular]
      type = AnnularMeshGenerator
      nr = 30 #300
      rmin = 0
      rmax = 30#34700
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
    # [ed0]
    #   type = BlockDeletionGenerator
    #   input = aquifer
    #   block = '1'
    # []

  []

#   [Mesh]
#     [disk]
#       type = ConcentricCircleMeshGenerator
#       num_sectors = 12
#       radii = '300' #'300 24700 34700'
#       rings = '6' #'6 244 50'
#       has_outer_square = false
#       #pitch = 1.42063
#       #portion = left_half
#       preserve_volumes = off
#       smoothing_max_it = 6
#       show_info = true
#     []
#     [aquifer]
#       type = MeshExtruderGenerator
#       extrusion_vector = '0 0 19'
#       num_layers = 19
#       input = disk
#       bottom_sideset = 'bottom'
#       top_sideset = 'top'  
#     []  
#   []

[GlobalParams]
    PorousFlowDictator = dictator
    temperature = 339.956
    gravity = '0 0 -9.8'
    # block = 0
  []

[Variables]
    [ppwater]
        # initial_condition = 31.28924e6
    []
    [sgas]
        initial_condition = 0
    []
[]

[AuxVariables]
    [pgas]
      family = MONOMIAL
      order = CONSTANT
    []
    [density_water]
      order = CONSTANT
      family = MONOMIAL
    []
    [density_gas]
      order = CONSTANT
      family = MONOMIAL
    []
    [xH2O_water]
      order = CONSTANT
      family = MONOMIAL
      initial_condition = 1

    []
    [xH2O_gas]
      order = CONSTANT
      family = MONOMIAL
      initial_condition = 0
    []
    [pc]
      family = MONOMIAL
      order = CONSTANT
    []
  []
  
  [AuxKernels]
    [pgas]
      type = ParsedAux
      coupled_variables = 'ppwater pc'
      expression = 'ppwater + pc'
      variable = pgas
      execute_on ='initial timestep_end'
      # type = PorousFlowPropertyAux
      # variable = pgas
      # property = pressure
      # phase = 0
      # execute_on = timestep_end
    []
    [density_water]
      type = PorousFlowPropertyAux
      variable = density_water
      property = density
      phase = 0
      execute_on ='timestep_end'
    []
    [density_gas]
      type = PorousFlowPropertyAux
      variable = density_gas
      property = density
      phase = 1
      execute_on = 'timestep_end'
    []
    [xH2O_water]
      type = PorousFlowPropertyAux
      variable = xH2O_water
      property = mass_fraction
      phase = 0
      fluid_component = 1
      execute_on = 'initial timestep_end'
    []
    [xH2O_gas]
      type = PorousFlowPropertyAux
      variable = xH2O_gas
      property = mass_fraction
      phase = 1
      fluid_component = 1
      execute_on = 'initial timestep_end'
    []
    [pc]
      type = PorousFlowPropertyAux
      variable = pc
      property = capillary_pressure
      execute_on = 'timestep_end'
    []
  []


[Kernels]
    [massCO2]
        type = PorousFlowMassTimeDerivative
        fluid_component = 0
        variable = sgas
    []
    [fluxCO2]
        type = PorousFlowAdvectiveFlux
        fluid_component = 0
        variable = sgas
    []
    [massW]
        type = PorousFlowMassTimeDerivative
        fluid_component = 1
        variable = ppwater
    []
    [fluxW]
        type =  PorousFlowAdvectiveFlux
        fluid_component = 1
        variable = ppwater
    []
  []

    ### Test this advective flow model before adding diffusive/dispersive flow flux

[DiracKernels]
    [wells]
        type  = PorousFlowPolyLineSink
        SumQuantityUO = injected_mass
        point_file = carbsol.bh
        variable = ppwater
        function_of = pressure
        fluid_phase = 1
        p_or_t_vals = 0
        fluxes = -1.66779
    []
  []

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'ppwater sgas'
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
    gas_fp = co2tab
    capillary_pressure = pc
    []
  [injected_mass]
    type = PorousFlowSumQuantity
    []
  []


[FluidProperties]
    [co2tab]
      type = CO2FluidProperties
    []
    [water]
      type = Water97FluidProperties
    []
  []

########### New fluid properties block
# [FluidProperties]
#   [co2]
#     type = CO2FluidProperties
#   []
#   [co2tab]
#     type = TabulatedBicubicFluidProperties
#     fp = co2
#     save_file = true
#     pressure_min = 101325
#     pressure_max = 40e6
#     temperature_max = 573.15
#     temperature_min = 273.15
#     num_p = 40
#     num_T = 10
#   []
#   [water]
#     type = Water97FluidProperties
#   []
#   [watertab]
#     type = TabulatedBicubicFluidProperties
#     fp = water
#     pressure_min = 101325
#     pressure_max = 40e6
#     temperature_min = 273.15
#     temperature_max = 373.15
#     num_p = 40
#     num_T = 10
#     save_file = true
#   []
# []
#####################

[Materials]
  [temperature]
    type = PorousFlowTemperature
  []
    [waterncg]
      type = PorousFlowFluidState
      gas_porepressure = pgas
      z = sgas
      temperature_unit = Kelvin
      capillary_pressure = pc
      fluid_state = fs
    []

    [porosity_reservoir]
      type = PorousFlowPorosityConst 
      porosity = 0.2248049
      # type = PorousFlowPorosityLinear
        # porosity_ref = 0.2248049
        # P_ref = 0
        # P_coeff = 1.1225e-10
      []
    [permeability_reservoir]
        type = PorousFlowPermeabilityConst
        permeability = '1.5833e-13 0 0  0 1.5833e-13 0  0 0 1.5833e-13'
      []
    [relperm_liquid]
        type = PorousFlowRelativePermeabilityVG
        m = 0.45946
        phase = 0
        s_res = 0.300
        sum_s_res = 0.3
        # block = 0
      []
    [relperm_gas]
        type = PorousFlowRelativePermeabilityBC
        phase = 1
        s_res = 0.0
        sum_s_res = 0.3
        lambda = 2
        nw_phase = true
        # block = 0
        # n = 4
      []
      # [ppss]
      #   type = PorousFlow2PhasePS
      #   phase0_porepressure = ppwater
      #   phase1_saturation = sgas
      #   capillary_pressure = pc
      # []
      # [massfrac]
      #   type = PorousFlowMassFraction
      #   mass_fraction_vars = 'xH2O_water xH2O_gas'
      # []
    
    []


[Executioner]
    type = Transient
    solve_type = NEWTON
    dt = 0.01
    #end_time = 946.08e6
    #nl_abs_tol = 1e-12
    # dtmin = 1
    dtmax = 31.536e6 
    num_steps = 9 #3000
    # automatic_scaling = true
    [TimeStepper]
      type = IterationAdaptiveDT
      dt = 1.0
    []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]


[ICs]
    [ppwater]
      type = FunctionIC
      variable = ppwater
      function = '31.28924e6 + (1000*9.81*z)'
    []
    [pgas]
      type = FunctionIC
      variable = pgas
      function = '31.28924e6 + (1000*9.81*z)'
    []
  []

  
  [Outputs]
    file_base = test
    console = true
  [exodus]
    type = Exodus
  []
  [csv]
    type = CSV
  []
  []

  [BCs]
    [top]
      type  = NeumannBC
      variable = ppwater
      boundary = top
      value = 0
    []
    [bottom]
      type  = NeumannBC
      variable = ppwater
      boundary = bottom
      value = 0
    []
    [surface_boundary]
      type  = NeumannBC
      variable = ppwater
      boundary = rmax
      value = 0
    []
  []

  # [Debug]
  #   show_material_props = true
  #   show_functors = true
  #   # check_jacobian = true
  # []
