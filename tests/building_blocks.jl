include("../src/structs.jl")
include("../src/construction.jl")

# Basic contraptions
one_contraption = Contraption(reshape([0.; 0.], (2,1)),
                              reshape([0.; 0.], (2,1)),
                              [1.],
                              100. * reshape([0.], (1,1)))

two_contraption = Contraption([1. -1.; 1. -1.],
                              [0. 0.; 0. 0.],
                              [1., 1.],
                              100. * [0. 1.; 1. 0.])

three_contraption = Contraption([-1. 0. 1.; -1. 0. -1.],
                                [0. 0. 0.; 0. 0. 0.],
                                [1., 1., 1.],
                                100. * [0. 1. 1.; 1. 0. 1.; 1. 1. 0.])

seven_contraption = Contraption(regular_polygon(7),
                                zeros(2, 7),
                                ones(7),
                                100. * complete_graph(7))

pogo_contraption = Contraption([0. 1.; 0. -1.],
                               [0. 0.; 0. 0.],
                               [1., 1.],
                               100. * [0. 1.; 1. 0.])

stretch_contraption = Contraption([1. -1.; 0. 0.],
                                  [1. -1.; 0. 0.],
                                  [1., 1.],
                                  100. * [0. 1.; 1. 0.])

squash_contraption = Contraption([1. -1.; 0. 0.],
                                 [-1. 1.; 0. 0.],
                                 [1., 1.],
                                 100. * [0. 1.; 1. 0.])

small_contraption = Contraption(regular_polygon(7, radius = 0.5),
                                zeros(2, 7),
                                ones(7),
                                100. * complete_graph(7))

large_contraption = Contraption(regular_polygon(7, radius = 2.),
                                zeros(2, 7),
                                ones(7),
                                100. * complete_graph(7))

rotated_contraption = Contraption(regular_polygon(7, θ_0 = 1.),
                                  zeros(2, 7),
                                  ones(7),
                                  100. * complete_graph(7))

light_contraption = Contraption(regular_polygon(7),
                                zeros(2, 7),
                                0.1 * ones(7),
                                100. * complete_graph(7))

heavy_contraption = Contraption(regular_polygon(7),
                                zeros(2, 7),
                                100. * ones(7),
                                100. * complete_graph(7))

weak_contraption = Contraption(regular_polygon(7),
                               zeros(2, 7),
                               ones(7),
                               10. * complete_graph(7))

strong_contraption = Contraption(regular_polygon(7),
                                 zeros(2, 7),
                                 ones(7),
                                 1000. * complete_graph(7))

slow_contraption = Contraption(regular_polygon(7),
                               0.01 * ones(2, 7),
                               ones(7),
                               100. * complete_graph(7))

fast_contraption = Contraption(regular_polygon(7),
                               1000. * ones(2, 7),
                               ones(7),
                               100. * complete_graph(7))


# Basic physics settings
default_settings = PhysicsSettings()

antigrav_settings = PhysicsSettings(g = -10.)
nograv_settings = PhysicsSettings(g = 0.)
lowgrav_settings = PhysicsSettings(g = 1)
higrav_settings = PhysicsSettings(g = 100.)

nodrag_settings = PhysicsSettings(drag = 0.)
lowdrag_settings = PhysicsSettings(drag = 0.01)
hidrag_settings = PhysicsSettings(drag = 1.)

inelastic_settings = PhysicsSettings(elasticity = 0.)
lowelastic_settings = PhysicsSettings(elasticity = 0.2)
hielastic_settings = PhysicsSettings(elasticity = 0.8)
elastic_settings = PhysicsSettings(elasticity = 1.)

null_settings = PhysicsSettings(g = 0., drag = 0., elasticity = 1.)
noloss_settings = PhysicsSettings(drag = 0., elasticity = 1.)

small_settings = PhysicsSettings(bounds = Bounds((-2.5, 2.5), (-2.5, 2.5)))
large_settings = PhysicsSettings(bounds = Bounds((-10., 10.), (-10., 10.)))
