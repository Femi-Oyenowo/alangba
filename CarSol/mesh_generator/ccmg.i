# Two-phase flow, CO2 injection into aquifer
# Carbon Solutions LLC
# INL model for MOOSE comparison  [Limited injection rate: 1.0 MMT/yr]

# Creates the mesh for the remainder of the tutorial
[Mesh]
  [disk]
    type = ConcentricCircleMeshGenerator
    num_sectors = 12
    radii = '300 24700 34700'
    rings = '6 244 50'
    has_outer_square = false
    #pitch = 1.42063
    #portion = left_half
    preserve_volumes = off
    smoothing_max_it = 6
    show_info = true
  []
  [aquifer]
    type = MeshExtruderGenerator
    extrusion_vector = '0 0 19'
    num_layers = 19
    input = disk
    bottom_sideset = 'bottom'
    top_sideset = 'top'
    
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
    file_base = 2D_mesh
    exodus = true
[]