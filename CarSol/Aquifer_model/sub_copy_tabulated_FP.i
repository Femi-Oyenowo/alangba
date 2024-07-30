# Two-phase flow, CO2 injection into aquifer
# Carbon Solutions LLC
# INL model for MOOSE comparison  [Limited injection rate: 1.0 MMT/yr]

[Mesh]
    [annular]
      type = AnnularMeshGenerator
      nr = 10
      rmin = 0
      rmax = 300#34700
      nt = 6
      dmin = 0
      dmax = 360
      # coord_type  = RZ
    []
    [aquifer]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 19'
        num_layers = 19
        input = annular
        bottom_sideset = 'bottom'
        top_sideset = 'top'
        
    []    
    [ed0]
      type = BlockDeletionGenerator
      input = aquifer
      block = '1'
    []

  []
[GlobalParams]
    PorousFlowDictator = dictator
    temperature = 339.956
    gravity = '0 0 -9.8'
    block = 0
  []
[Variables]
    [p_gas]
        # initial_condition = 31.28924e6
    []
    [zCO2]
        initial_condition = 0
    []
[]

[AuxVariables]
    [pwater]
        order = CONSTANT
        family = MONOMIAL
      []
    [pgas]
      order = CONSTANT
      family = MONOMIAL
    []
    [swater]
      order = CONSTANT
      family = MONOMIAL
    []
    [sgas]
        order = CONSTANT
        family = MONOMIAL
      []
  
    [density_water]
      order = CONSTANT
      family = MONOMIAL
    []
    [density_gas]
      order = CONSTANT
      family = MONOMIAL
    []
    [viscosity_water]
      order = CONSTANT
      family = MONOMIAL
    []
    [viscosity_gas]
      order = CONSTANT
      family = MONOMIAL
    []
    [xCO2_water]
      order = CONSTANT
      family = MONOMIAL
    []
    [xCO2_gas]
      order = CONSTANT
      family = MONOMIAL
    []
    [xH2O_water]
      order = CONSTANT
      family = MONOMIAL
    []
    [xH2O_gas]
      order = CONSTANT
      family = MONOMIAL
    []
  []
  
  [AuxKernels]
    [pgas]
      type = PorousFlowPropertyAux
      variable = pgas
      property = pressure
      phase = 1
      execute_on = timestep_end
    []
    [pwater]
        type = PorousFlowPropertyAux
        variable = pwater
        property = pressure
        phase = 0
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
    [density_water]
      type = PorousFlowPropertyAux
      variable = density_water
      property = density
      phase = 0
      execute_on = timestep_end
    []
    [density_gas]
      type = PorousFlowPropertyAux
      variable = density_gas
      property = density
      phase = 1
      execute_on = timestep_end
    []
    [xH2O_water]
      type = PorousFlowPropertyAux
      variable = xH2O_water
      property = mass_fraction
      phase = 0
      fluid_component = 1
      execute_on = timestep_end
    []
    [xH2O_gas]
      type = PorousFlowPropertyAux
      variable = xH2O_gas
      property = mass_fraction
      phase = 1
      fluid_component = 1
      execute_on = timestep_end
    []
    [xCO2_water]
      type = PorousFlowPropertyAux
      variable = xCO2_water
      property = mass_fraction
      phase = 0
      fluid_component = 0
      execute_on = timestep_end
    []
    [xCO2_gas]
      type = PorousFlowPropertyAux
      variable = xCO2_gas
      property = mass_fraction
      phase = 1
      fluid_component = 0
      execute_on = timestep_end
    []
  []


[Kernels]
    [massCO2]
        type = PorousFlowMassTimeDerivative
        fluid_component = 0
        variable = p_gas
    []
    [fluxCO2]
        type = PorousFlowAdvectiveFlux
        fluid_component = 0
        variable = p_gas
    []
    [massW]
        type = PorousFlowMassTimeDerivative
        fluid_component = 1
        variable = zCO2
    []
    [fluxW]
        type =  PorousFlowAdvectiveFlux
        fluid_component = 1
        variable = zCO2
    []
  []

    ### Test this advective flow model before adding diffusive/dispersive flow flux

    [DiracKernels]
      [wells]
          type  = PorousFlowPolyLineSink
          SumQuantityUO = injected_mass
          point_file = carbsol.bh
          variable = zCO2
          function_of = pressure
          fluid_phase = 1
          p_or_t_vals = 0
          fluxes = -1.66779
          multiplying_var = 2
      []
      []


[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'p_gas zCO2'
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
    # [tabulated]
    #   type = TabulatedBicubicFluidProperties
    #   fp = co2
    #   fluid_property_file = fluid_properties.csv
    # []
    [water]
      type = Water97FluidProperties
    []
  []

########### New fluid properties block
# [FluidProperties]
#   [co2sw]
#     type = CO2FluidProperties
#   []
#   [co2]
#     type = TabulatedFluidProperties
#     fp = co2sw
#   []
#   [water]
#     type = Water97FluidProperties
#   []
#   [watertab]
#     type = TabulatedFluidProperties
#     fp = water
#     temperature_min = 273.15
#     temperature_max = 573.15
#     fluid_property_file = water_fluid_properties.csv
#     save_file = false
#   []
#   [brine]
#     type = BrineFluidProperties
#     water_fp = watertab
#   []

#####################

[Materials]
  [temperature]
    type = PorousFlowTemperature
  []
    [waterncg]
      type = PorousFlowFluidState
      gas_porepressure = p_gas
      z = zCO2
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
        block = 0
      []
    [relperm_gas]
        type = PorousFlowRelativePermeabilityBC
        phase = 1
        s_res = 0.0
        sum_s_res = 0.3
        lambda = 2
        nw_phase = true
        block = 0
        # n = 4
      []

    []

[Postprocessors]
    [density_water]
        type = PointValue
        point = '0 0 19'
        variable = density_water
      []
      [density_gas]
        type = PointValue
        point = '0 0 19'
        variable = density_gas
      []
      [viscosity_water]
        type = PointValue
        point = '0 0 19'
        variable = viscosity_water
      []
      [viscosity_gas]
        type = PointValue
        point = '0 0 19'
        variable = viscosity_gas
      []
      [xH2O_water]
        type = PointValue
        point = '0 0 19'
        variable = xH2O_water
      []
      [xCO2_water]
        type = PointValue
        point = '0 0 19'
        variable = xCO2_water
      []
      [xH2O_gas]
        type = PointValue
        point = '0 0 19'
        variable = xH2O_gas
      []
      [xCO2_gas]
        type = PointValue
        point = '0 0 19'
        variable = xCO2_gas
      []
      [sg]
        type = PointValue
        point = '0 0 19'
        variable = sgas
      []
      [sw]
        type = PointValue
        point = '0 0 19'
        variable = swater
      []
      [pwater]
        type = PointValue
        point = '0 0 19'
        variable = pwater
      []
      [pgas]
        type = PointValue
        point = '0 0 19'
        variable = pgas
      []
      [CO2mass]
        type = PorousFlowFluidMass
        fluid_component = 0
        phase = '0 1'
      []
      [H2Omass]
        type = PorousFlowFluidMass
        fluid_component = 1
        phase = '0 1'
      []
      [injected_CO2]
        type = PorousFlowPlotQuantity
        uo = injected_mass
      []
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

# [Preconditioning]
#   [smp]
#     type = SMP
#     full = true
#   []
# []


[ICs]
    [pwater]
      type = FunctionIC
      variable = pwater
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
      variable = p_gas
      boundary = top
      value = 0
    []
    [bottom]
      type  = NeumannBC
      variable = p_gas
      boundary = bottom
      value = 0
    []
    [surface_boundary]
      type  = NeumannBC
      variable = p_gas
      boundary = rmax
      value = 0
    []
  []

  [Debug]
    show_material_props = true
    show_functors = true
    # check_jacobian = true
  []


  # [DiracKernels]
#     # [wells]
#     #     type  = PorousFlowPeacemanBorehole
#     #     point_file = carbsol.bh
#     #     variable = p_gas
#     #     function_of = pressure
#     #     fluid_phase = 1
#     #     bottom_p_or_t = 
#     #     use_mobility = true
#     #     character = -1
#     # []
#     [source2]
#       point = '0 0 1'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source3]
#       point = '0 0 2'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source4]
#       point = '0 0 3'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source5]
#       point = '0 0 4'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source6]
#       point = '0 0 5'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source7]
#       point = '0 0 6'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source8]
#       point = '0 0 7'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source9]
#       point = '0 0 8'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source10]
#       point = '0 0 9'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source11]
#       point = '0 0 10'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source12]
#       point = '0 0 11'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source13]
#       point = '0 0 12'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source14]
#       point = '0 0 13'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source15]
#       point = '0 0 14'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source16]
#       point = '0 0 15'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source17]
#       point = '0 0 16'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source18]
#       point = '0 0 17'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source19]
#       point = '0 0 18'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#     [source20]
#       point = '0 0 19'
#       start_time = 1
#       mass_flux = 1.66779
#       variable = zCO2
#       type = PorousFlowSquarePulsePointSource
#     []
#   []
