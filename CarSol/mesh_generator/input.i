# Two-phase flow, CO2 injection into aquifer
# Carbon Solutions LLC
# INL model for MOOSE comparison  [Limited injection rate: 1.0 MMT/yr]

#elem = QUAD4 
[Mesh]
    [annular]
      type = AnnularMeshGenerator
      nr = 34#0
      rmin = 0.0
      rmax = 34#700
      growth_r = 1
      nt = 12
      dmin = 0
      dmax = 360
    []
    [aquifer]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 19'
        num_layers = 19
        #bottom_sideset = 'bottom'
        #top_sideset = 'top'
	#block_id = 1
        input = annular
	#elem_type = ${elem}
    []
    [cap]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 331'
        input = annular
	num_layers = 331
	#block_id = 0
	#elem_type = ${elem}
	
    []
    [reservoir]
	type = SubdomainIDGenerator
	input = aquifer
	subdomain_id = 0
	#elem_type = ${elem}
    []
    [caprock]
	type = SubdomainIDGenerator
	input = cap
	subdomain_id = 1
	#elem_type = ${elem}
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
    file_base = 3D_mesh
    exodus = true
[]