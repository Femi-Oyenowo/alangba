# Two-phase flow, CO2 injection into aquifer
# Carbon Solutions LLC
# INL model for MOOSE comparison  [Limited injection rate: 1.0 MMT/yr]

[Mesh]
    [annular]
      type = AnnularMeshGenerator
      nr = 300
      rmin = 0
      rmax = 350
      growth_r = 1
      nt = 12
      dmin = 0
      dmax = 360
    []
    [make3D]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 19'
        num_layers = 19
        bottom_sideset = 'bottom'
        top_sideset = 'top'
        input = annular
    []  
    [aquifer]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 331'
        num_layers = 331
        bottom_sideset = 'bottom'
        top_sideset = 'top'
        input = annular
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
    exodus = true
[]