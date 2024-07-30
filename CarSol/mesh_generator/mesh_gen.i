# Simulation designed to assess the recovery efficiency of a single-well ATES system
# Using KT stabilisation
# Boundary conditions: fixed porepressure and temperature at top, bottom and far end of model.

#####################################
flux_limiter = minmod # minmod, vanleer, mc, superbee, none
# depth of top of aquifer (m)
depth = 400

inject_fluid_mass = 1E8 # kg
produce_fluid_mass = ${inject_fluid_mass} # kg
inject_temp = 90 # degC

inject_time = 91 # days
store_time = 91 # days
produce_time = 91 # days
rest_time = 91 # days
num_cycles = 5 # Currently needs to be <= 10

cycle_length = ${fparse inject_time + store_time + produce_time + rest_time}

end_simulation = ${fparse cycle_length * num_cycles}

# Note: I have setup 10 cycles but you can set num_cycles less than 10.
start_injection1 = 0
start_injection2 = ${cycle_length}
start_injection3 = ${fparse cycle_length * 2}
start_injection4 = ${fparse cycle_length * 3}
start_injection5 = ${fparse cycle_length * 4}
start_injection6 = ${fparse cycle_length * 5}
start_injection7 = ${fparse cycle_length * 6}
start_injection8 = ${fparse cycle_length * 7}
start_injection9 = ${fparse cycle_length * 8}
start_injection10 = ${fparse cycle_length * 9}

end_injection1 = ${fparse start_injection1 + inject_time}
end_injection2 = ${fparse start_injection2 + inject_time}
end_injection3 = ${fparse start_injection3 + inject_time}
end_injection4 = ${fparse start_injection4 + inject_time}
end_injection5 = ${fparse start_injection5 + inject_time}
end_injection6 = ${fparse start_injection6 + inject_time}
end_injection7 = ${fparse start_injection7 + inject_time}
end_injection8 = ${fparse start_injection8 + inject_time}
end_injection9 = ${fparse start_injection9 + inject_time}
end_injection10 = ${fparse start_injection10 + inject_time}

start_production1 = ${fparse end_injection1 + store_time}
start_production2 = ${fparse end_injection2 + store_time}
start_production3 = ${fparse end_injection3 + store_time}
start_production4 = ${fparse end_injection4 + store_time}
start_production5 = ${fparse end_injection5 + store_time}
start_production6 = ${fparse end_injection6 + store_time}
start_production7 = ${fparse end_injection7 + store_time}
start_production8 = ${fparse end_injection8 + store_time}
start_production9 = ${fparse end_injection9 + store_time}
start_production10 = ${fparse end_injection10 + store_time}

end_production1 = ${fparse start_production1 + produce_time}
end_production2 = ${fparse start_production2 + produce_time}
end_production3 = ${fparse start_production3 + produce_time}
end_production4 = ${fparse start_production4 + produce_time}
end_production5 = ${fparse start_production5 + produce_time}
end_production6 = ${fparse start_production6 + produce_time}
end_production7 = ${fparse start_production7 + produce_time}
end_production8 = ${fparse start_production8 + produce_time}
end_production9 = ${fparse start_production9 + produce_time}
end_production10 = ${fparse start_production10 + produce_time}

synctimes = '${start_injection1} ${end_injection1} ${start_production1} ${end_production1}
             ${start_injection2} ${end_injection2} ${start_production2} ${end_production2}
             ${start_injection3} ${end_injection3} ${start_production3} ${end_production3}
             ${start_injection4} ${end_injection4} ${start_production4} ${end_production4}
             ${start_injection5} ${end_injection5} ${start_production5} ${end_production5}
             ${start_injection6} ${end_injection6} ${start_production6} ${end_production6}
             ${start_injection7} ${end_injection7} ${start_production7} ${end_production7}
             ${start_injection8} ${end_injection8} ${start_production8} ${end_production8}
             ${start_injection9} ${end_injection9} ${start_production9} ${end_production9}
             ${start_injection10} ${end_injection10} ${start_production10} ${end_production10}'

#####################################
# Geometry in RZ coordinates
# borehole radius (m)
bh_r = 0.1
# model radius (m)
max_r = 1000
# aquifer thickness (m)
aq_thickness = 20
# cap thickness (m)
cap_thickness = 40
# injection region top and bottom (m).  Note, the mesh is created with the aquifer in y = (-0.5 * aq_thickness, 0.5 * aq_thickness), irrespective of depth (depth only sets the insitu porepressure and temperature)
screen_top = ${fparse 0.5 * aq_thickness}
screen_bottom = ${fparse -0.5 * aq_thickness}

# number of elements in radial direction
num_r = 25
# number of elements across half height of aquifer
num_y_aq = 10
# number of elements across height of cap
num_y_cap = 8

# mesh bias in radial direction
bias_r = 1.22
# mesh bias in vertical direction in aquifer top
bias_y_aq_top = 0.9
# mesh bias in vertical direction in cap top
bias_y_cap_top = 1.3
# mesh bias in vertical direction in aquifer bottom
bias_y_aq_bottom = ${fparse 1.0 / bias_y_aq_top}
# mesh bias in vertical direction in cap bottom
bias_y_cap_bottom = ${fparse 1.0 / bias_y_cap_top}
depth_centre = ${fparse depth + aq_thickness/2}

#####################################
# temperature at ground surface (degC)
temp0 = 20
# Vertical geothermal gradient (K/m).  A positive number means temperature increases downwards.
geothermal_gradient = 20E-3

#####################################
# Gravity
gravity = -9.81

#####################################
half_aq_thickness = ${fparse aq_thickness * 0.5}
half_height = ${fparse half_aq_thickness + cap_thickness}
approx_screen_length = ${fparse screen_top - screen_bottom}

# Thermal radius (note this is not strictly correct, it should use the bulk specific heat
#  capacity as defined below, but it doesn't matter here because this is purely for
#  defining the region of refined mesh)
th_r = ${fparse sqrt(inject_fluid_mass / 1000 * 4.12e6 / (approx_screen_length * 3.1416 * aq_specific_heat_cap * aq_density))}
# radius of fine mesh
fine_r = ${fparse th_r * 2}
bias_r_fine = 1
num_r_fine = ${fparse int(fine_r/1)}

######################################
# aquifer properties
aq_porosity = 0.25
aq_hor_perm = 1E-11 # m^2
aq_ver_perm = 2E-12 # m^2
aq_density = 2650 # kg/m^3
aq_specific_heat_cap = 800 # J/Kg/K
aq_hor_thermal_cond = 3 # W/m/K
aq_ver_thermal_cond = 3 # W/m/K
aq_disp_parallel = 0 # m
aq_disp_perp = 0 # m
# Bulk volumetric heat capacity of aquifer:
aq_vol_cp = ${fparse aq_specific_heat_cap * aq_density * (1 - aq_porosity) + 4180 * 1000 * aq_porosity}
# Thermal radius (correct version using bulk cp):
R_th = ${fparse sqrt(inject_fluid_mass * 4180 / (approx_screen_length * 3.1416 * aq_vol_cp))}
aq_lambda_eff_hor = ${fparse aq_hor_thermal_cond + 0.3 * aq_disp_parallel * R_th * aq_vol_cp / (inject_time * 60 * 60 * 24)}
aq_lambda_eff_ver = ${fparse aq_ver_thermal_cond + 0.3 * aq_disp_perp * R_th * aq_vol_cp / (inject_time * 60 * 60 * 24)}
aq_hor_dry_thermal_cond = ${fparse aq_lambda_eff_hor * 60 * 60 * 24} # J/day/m/K
aq_ver_dry_thermal_cond = ${fparse aq_lambda_eff_ver * 60 * 60 * 24} # J/day/m/K
aq_hor_wet_thermal_cond = ${fparse aq_lambda_eff_hor * 60 * 60 * 24} # J/day/m/K
aq_ver_wet_thermal_cond = ${fparse aq_lambda_eff_ver * 60 * 60 * 24} # J/day/m/K
# cap-rock properties
cap_porosity = 0.25
cap_hor_perm = 1E-16 # m^2
cap_ver_perm = 1E-17 # m^2
cap_density = 2650 # kg/m^3
cap_specific_heat_cap = 800 # J/kg/K
cap_hor_thermal_cond = 3 # W/m/K
cap_ver_thermal_cond = 3 # W/m/K
cap_hor_dry_thermal_cond = ${fparse cap_hor_thermal_cond * 60 * 60 * 24} # J/day/m/K
cap_ver_dry_thermal_cond = ${fparse cap_ver_thermal_cond * 60 * 60 * 24} # J/day/m/K
cap_hor_wet_thermal_cond = ${fparse cap_hor_thermal_cond * 60 * 60 * 24} # J/day/m/K
cap_ver_wet_thermal_cond = ${fparse cap_ver_thermal_cond * 60 * 60 * 24} # J/day/m/K

######################################

[Mesh]
  coord_type = RZ
  [aq_top_fine]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r_fine}
    xmin = ${bh_r}
    xmax = ${fine_r}
    bias_x = ${bias_r_fine}
    bias_y = ${bias_y_aq_top}
    ny = ${num_y_aq}
    ymin = 0
    ymax = ${half_aq_thickness}
  []
  [cap_top_fine]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r_fine}
    xmin = ${bh_r}
    xmax = ${fine_r}
    bias_x = ${bias_r_fine}
    bias_y = ${bias_y_cap_top}
    ny = ${num_y_cap}
    ymax = ${half_height}
    ymin = ${half_aq_thickness}
  []
  [aq_and_cap_top_fine]
    type = StitchedMeshGenerator
    inputs = 'aq_top_fine cap_top_fine'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'top bottom'
  []
  [aq_bottom_fine]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r_fine}
    xmin = ${bh_r}
    xmax = ${fine_r}
    bias_x = ${bias_r_fine}
    bias_y = ${bias_y_aq_bottom}
    ny = ${num_y_aq}
    ymax = 0
    ymin = -${half_aq_thickness}
  []
  [cap_bottom_fine]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r_fine}
    xmin = ${bh_r}
    xmax = ${fine_r}
    bias_x = ${bias_r_fine}
    bias_y = ${bias_y_cap_bottom}
    ny = ${num_y_cap}
    ymin = -${half_height}
    ymax = -${half_aq_thickness}
  []
  [aq_and_cap_bottom_fine]
    type = StitchedMeshGenerator
    inputs = 'aq_bottom_fine cap_bottom_fine'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'bottom top'
  []
  [aq_and_cap_fine]
    type = StitchedMeshGenerator
    inputs = 'aq_and_cap_bottom_fine aq_and_cap_top_fine'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'top bottom'
  []

  [aq_top]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r}
    xmin = ${fine_r}
    xmax = ${max_r}
    bias_x = ${bias_r}
    bias_y = ${bias_y_aq_top}
    ny = ${num_y_aq}
    ymin = 0
    ymax = ${half_aq_thickness}
  []
  [cap_top]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r}
    xmin = ${fine_r}
    xmax = ${max_r}
    bias_x = ${bias_r}
    bias_y = ${bias_y_cap_top}
    ny = ${num_y_cap}
    ymax = ${half_height}
    ymin = ${half_aq_thickness}
  []
  [aq_and_cap_top]
    type = StitchedMeshGenerator
    inputs = 'aq_top cap_top'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'top bottom'
  []
  [aq_bottom]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r}
    xmin = ${fine_r}
    xmax = ${max_r}
    bias_x = ${bias_r}
    bias_y = ${bias_y_aq_bottom}
    ny = ${num_y_aq}
    ymax = 0
    ymin = -${half_aq_thickness}
  []
  [cap_bottom]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${num_r}
    xmin = ${fine_r}
    xmax = ${max_r}
    bias_x = ${bias_r}
    bias_y = ${bias_y_cap_bottom}
    ny = ${num_y_cap}
    ymin = -${half_height}
    ymax = -${half_aq_thickness}
  []
  [aq_and_cap_bottom]
    type = StitchedMeshGenerator
    inputs = 'aq_bottom cap_bottom'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'bottom top'
  []
  [aq_and_cap]
    type = StitchedMeshGenerator
    inputs = 'aq_and_cap_bottom aq_and_cap_top'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'top bottom'
  []

  [aq_and_cap_all]
    type = StitchedMeshGenerator
    inputs = 'aq_and_cap_fine aq_and_cap'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'right left'
  []

  [aquifer]
    type = ParsedSubdomainMeshGenerator
    input = aq_and_cap_all
    combinatorial_geometry = 'y >= -${half_aq_thickness} & y <= ${half_aq_thickness}'
    block_id = 1
  []
  [top_cap]
    type = ParsedSubdomainMeshGenerator
    input = aquifer
    combinatorial_geometry = 'y >= ${half_aq_thickness}'
    block_id = 2
  []
  [bottom_cap]
    type = ParsedSubdomainMeshGenerator
    input = top_cap
    combinatorial_geometry = 'y <= -${half_aq_thickness}'
    block_id = 3
  []
  [injection_area]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'x<=${bh_r}*1.000001 & y >= ${screen_bottom} & y <= ${screen_top}'
    included_subdomains = 1
    new_sideset_name = 'injection_area'
    input = 'bottom_cap'
  []
  [rename]
    type = RenameBlockGenerator
    old_block = '1 2 3'
    new_block = 'aquifer caps caps'
    input = 'injection_area'
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