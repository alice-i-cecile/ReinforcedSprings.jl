include("../src/structs.jl")
include("../src/construction.jl")

# Basic contraptions
global one_contraption = Contraption(reshape([0.; 0.], (2,1)),
                                              reshape([0.; 0.], (2,1)),
                                              [1.],
                                              100. * reshape([0.], (1,1)))

global two_contraption = Contraption([1. -1.; 1. -1.],
                                     [0. 0.; 0. 0.],
                                     [1., 1.],
                                     100. * [0. 1.; 1. 0.])

global three_contraption = Contraption([-1. 0. 1.; -1. 0. -1.],
                                       [0. 0. 0.; 0. 0. 0.],
                                       [1., 1., 1.],
                                       100. * [0. 1. 1.; 1. 0. 1.; 1. 1. 0.])

global seven_contraption = Contraption(regular_polygon(7),
                                       zeros(2, 7),
                                       ones(7),
                                       100. * complete_graph(7))

global hundred_contraption = Contraption(regular_polygon(100),
                                         zeros(2, 100),
                                         ones(100),
                                         100. * complete_graph(100))

global thousand_contraption = Contraption(regular_polygon(1000),
                                          zeros(2, 1000),
                                          ones(1000),
                                          100. * complete_graph(1000))

global pogo_contraption = Contraption([0. 0.; 1. -1.],
                                      [0. 0.; 0. 0.],
                                      [1., 1.],
                                      100. * [0. 1.; 1. 0.])

global stretch_contraption = Contraption([1. -1.; 0. 0.],
                                         [1. -1.; 0. 0.],
                                         [1., 1.],
                                         100. * [0. 1.; 1. 0.])

global squash_contraption = Contraption([1. -1.; 0. 0.],
                                        [-1. 1.; 0. 0.],
                                        [1., 1.],
                                        100. * [0. 1.; 1. 0.])

global small_contraption = Contraption(regular_polygon(7, radius = 0.5),
                                       zeros(2, 7),
                                       ones(7),
                                       100. * complete_graph(7))

global large_contraption = Contraption(regular_polygon(7, radius = 2.),
                                       zeros(2, 7),
                                       ones(7),
                                       100. * complete_graph(7))

global rotated_contraption = Contraption(regular_polygon(7, θ_0 = 1.),
                                         zeros(2, 7),
                                         ones(7),
                                         100. * complete_graph(7))

global light_contraption = Contraption(regular_polygon(7),
                                       zeros(2, 7),
                                       0.1 * ones(7),
                                       100. * complete_graph(7))

global heavy_contraption = Contraption(regular_polygon(7),
                                       zeros(2, 7),
                                       100. * ones(7),
                                       100. * complete_graph(7))

global weak_contraption = Contraption(regular_polygon(7),
                                      zeros(2, 7),
                                      ones(7),
                                      10. * complete_graph(7))

global strong_contraption = Contraption(regular_polygon(7),
                                        zeros(2, 7),
                                        ones(7),
                                        1000. * complete_graph(7))

global slow_contraption = Contraption(regular_polygon(7),
                                      0.01 * ones(2, 7),
                                      ones(7),
                                      100. * complete_graph(7))

global fast_contraption = Contraption(regular_polygon(7),
                                      1000. * ones(2, 7),
                                      ones(7),
                                      100. * complete_graph(7))

global detached_contraption = Contraption(regular_polygon(7),
                                          zeros(2, 7),
                                          ones(7),
                                          zeros(7, 7))

global loop_contraption = Contraption(regular_polygon(17),
                                      zeros(2, 17), 
                                      ones(17),
                                      3000*loop_graph(17, [1,2,4]))                                          

# Basic physics settings
global default_settings = PhysicsSettings()

global antigrav_settings = PhysicsSettings(g = -10.)
global nograv_settings = PhysicsSettings(g = 0.)
global lowgrav_settings = PhysicsSettings(g = 1)
global higrav_settings = PhysicsSettings(g = 100.)

global nodrag_settings = PhysicsSettings(drag = 0.)
global lowdrag_settings = PhysicsSettings(drag = 0.01)
global hidrag_settings = PhysicsSettings(drag = 1.)

global inelastic_settings = PhysicsSettings(elasticity = 0.)
global lowelastic_settings = PhysicsSettings(elasticity = 0.2)
global hielastic_settings = PhysicsSettings(elasticity = 0.8)
global elastic_settings = PhysicsSettings(elasticity = 1.)

global null_settings = PhysicsSettings(g = 0., drag = 0., elasticity = 1.)
global noloss_settings = PhysicsSettings(drag = 0., elasticity = 1.)

global small_settings = PhysicsSettings(bounds = Bounds((-2.5, 2.5), (-2.5, 2.5)))
global large_settings = PhysicsSettings(bounds = Bounds((-10., 10.), (-10., 10.)))
