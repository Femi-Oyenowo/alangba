[Mesh]
  [ccmg]
 	type = ConcentricCircleMeshGenerator
  	num_sectors = 6
  	radii = '300 24700 34700'
  	rings = '6 244 50'
  	has_outer_square = off
  	#pitch = 1.42063
  	#portion = left_half
  	preserve_volumes = false
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