# Two-phase flow, CO2 injection into aquifer
# Carbon Solutions LLC
# INL model for MOOSE comparison  [Limited injection rate: 1.0 MMT/yr]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 2000
  bias_x = 1.003
  xmin = 0.1
  xmax = 5000
  ny = 1
  ymin = 0
  ymax = 11
[]

[Problem]
  coord_type = RZ
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