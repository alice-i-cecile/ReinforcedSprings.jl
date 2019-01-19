include("../src/ReinforcedSprings.jl")

# Basic contraptions
one_contraption = Contraption([0; 0],
                              [0; 0],
                              [1],
                              [0])

two_contraption = Contraption([1 -1; 1 -1],
                              [0 0; 0 0],
                              [1, 1],
                              [0 1; 1 0])

three_contraption = Contraption([-1 0 1; -1 0 -1],
                                [0 0 0; 0 0 0; 0 0 0],
                                [1, 1, 1],
                                [0 1 1; 1 0 1; 1 1 0])

seven_contraption = Contraption(regular_polygon(7),
                                zeros(2, 7),
                                ones(7),
                                complete_graph(7))

pogo_contraption = Contraption([0 1; 0 -1],
                               [0 0; 0 0],
                               [1, 1],
                               [0 1; 1 0])

stretch_contraption = Contraption([1 -1; 0 0],
                                  [1 -1; 0 0],
                                  [1, 1],
                                  [0 1; 1 0])

squash_contraption = Contraption([1 -1; 0 0],
                                 [-1 1; 0 0],
                                 [1, 1],
                                 [0 1; 1 0])

small_contraption = Contraption(regular_polygon(7, radius = 0.5),
                                zeros(2, 7),
                                ones(7),
                                complete_graph(7))

small_contraption = Contraption(regular_polygon(7, radius = 2.),
                                zeros(2, 7),
                                ones(7),
                                complete_graph(7))

rotated_contraption = Contraption(regular_polygon(7, θ_0 = 1.),
                                  zeros(2, 7),
                                  ones(7),
                                  complete_graph(7))

light_contraption = Contraption(regular_polygon(7),
                                zeros(2, 7),
                                0.1 * ones(7),
                                complete_graph(7))

heavy_contraption = Contraption(regular_polygon(7),
                                zeros(2, 7),
                                10. * ones(7),
                                complete_graph(7))

weak_contraption = Contraption(regular_polygon(7),
                               zeros(2, 7),
                               ones(7),
                               0.1 * complete_graph(7))

strong_contraption = Contraption(regular_polygon(7),
                                 zeros(2, 7),
                                 ones(7),
                                 10. * complete_graph(7))

# Basic physics settings
default_settings = PhysicsSettings()

nograv_settings = PhysicsSettings(g = 0.)
antigrav_settings = PhysicsSettings(g = -10)
lowgrav_settings = PhysicsSettings(g = 0.01)
higrav_settings = PhysicsSettings(g = 1000)

nodrag_settings = PhysicsSettings(drag = 0.)
lowdrag_settings = PhysicsSettings(drag = 0.01)
hidrag_settings = PhysicsSettings(drag = 1.)

inelastic_settings = PhysicsSettings(elasticity = 0.)
lowelastic_settings = PhysicsSettings(elasticity = 0.2)
hielastic_settings = PhysicsSettings(elasticity = 0.8)
elastic_settings = PhysicsSettings(elasticity = 1.)

small_settings = PhysicsSettings(bounds = Bounds((-10, 10), (-10, 10)))
big_settings = PhysicsSettings(bounds = Bounds((-1000, 1000), (-1000, 1000)))

