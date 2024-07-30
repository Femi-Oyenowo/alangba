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
      nt = 15
      dmin = 0
      dmax = 90
    []
    [make3D]
        type = MeshExtruderGenerator
        extrusion_vector = '0 0 350'
        num_layers = 350
        bottom_sideset = 'bottom'
        top_sideset = 'top'
        input = annular
    []
    [aquifer]
        type = SubdomainBoundingBoxGenerator
        block_id = 1
        bottom_left = '0 0 332'
        top_right = '300 300 350'
        input = make3D
    []
    [injection_area]
        type = ParsedGenerateSideset
        combinatorial_geometry = 'x*x+y*y=0.25'
        included_subdomains = 1
        new_sideset_name = 'injection_area'
        input = 'aquifer'
    []
    [rename]
        type = RenameBlockGenerator
        old_block = '0 1'
        new_block = 'caprock aquifer'
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