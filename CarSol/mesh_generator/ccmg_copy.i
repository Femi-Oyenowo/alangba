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
  [aquifer]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 19'
        num_layers = 19
        #bottom_sideset = 'bottom'
        #top_sideset = 'top'
	#block_id = 1
        input = ccmg
  []
  [cap]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 331'
        num_layers = 331
        input = ccmg
  []
  [reservoir]
	type = SubdomainIDGenerator
	input = aquifer
	subdomain_id = 0
    []
    [caprock]
	type = SubdomainIDGenerator
	input = cap
	subdomain_id = 1
    []
  [stack]
	type = StackGenerator
	inputs = 'reservoir caprock'
	dim = 3
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