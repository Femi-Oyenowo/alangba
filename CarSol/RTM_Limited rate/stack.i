[Mesh]
  [./aquifer]
    type = FileMeshGenerator
    file = aquifer_in.e
    block_id = 0
  []

  [./cap]
    type = FileMeshGenerator
    file = cap_in.e
    block_id = 1
  []
  [./stack_them]
    type = StackGenerator
    inputs = 'aquifer cap'
    #save_with_name = 'aquifer cap'
    dim = 3
  []

[]
[Outputs]
  exodus = true
[]