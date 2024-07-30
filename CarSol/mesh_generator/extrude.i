[Mesh]
    [annular]
      type = AnnularMeshGenerator
      nr = 300
      rmin = 0
      rmax = 34700
      growth_r = 1
      nt = 12
      dmin = 0
      dmax = 360
    []
    [aquifer]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 19'
        num_layers = 19
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