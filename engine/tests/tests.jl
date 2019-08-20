include("building_blocks.jl")
include("../src/physics.jl")

# Run experiments in parallel in order to compare behaviour
function run_experiment(contraptions, settings_list; 
                        Δt::Float64 = 0.01, t_total::Float64 = 10)

    @assert(length(contraptions) == length(settings_list))
    n = length(contraptions)

    results = Array()
    for i in 1:n
        outcome = engine(contraptions[i], settings_list[i], Δt, t_total)
        push!(results, outcome)
    end

    return results
end

# Physics behaviour tests ####

# Contraptions should not accelerate in absence of external forces
function newton_first_law_test(contraption)
    results = run_experiment([contraption],
                             [null_settings])
    return false
end

@test newton_first_law_test(one_contraption)
@test newton_first_law_test(two_contraption)
@test newton_first_law_test(slow_contraption)

# Springs should pull points together when they're stretched
function stretch_test()
    results = run_experiment([stretch_contraption],
                             [null_settings],
                             t_total = 1.)

    return false
end

@test stretch_test()

# Springs should push points away when they're compressed
function compression_test()
    results = run_experiment([squash_contraption],
                             [null_settings],
                             t_total = 1.)
    return false
end 

@test compression_test()

# Contraptions should fall when there's gravity
function falling_test(contraption)
    results = run_experiment([contraption],
                             [default_settings],
                             t_total = 1.)

    return false
end

@test falling_test(one_contraption)
@test falling_test(two_contraption)
@test falling_test(three_contraption)

# Contraptions should fall faster in more gravity
function gravity_falling_test(contraption)
    results = run_experiment([contraption for _ in 1:5],
                             [antigrav_settings,
                              nograv_settings,
                              lowgrav_settings,
                              default_settings,
                              higrav_settings],
                             t_total = 1.)

    return false
end

@test gravity_falling_test(one_contraption)
@test gravity_falling_test(three_contraption)

# Contraptions should fall slower with more drag
function drag_falling_test()
    results = run_experiment([contraption for _ in 1:4],
                             [nodrag_settings,
                              lowdrag_settings,
                              default_settings,
                              hidrag_settings],
                             t_total = 1.)
    return false
end

@test drag_falling_test(one_contraption)
@test drag_falling_test(three_contraption)

# Contraptions should oscillate at about the same speed regardless of initial compression or extension
function oscillation_direction_test()
    results = run_experiment([stretch_contraption, squash_contraption],
                             [null_settings, null_settings])

    return false
end

@test oscillation_direction_test()

# Contraptions should oscillate at about the same speed regardless of drag
function oscillation_drag_test()
    results = run_experiment([stretch_contraption for _ in 1:4],
                             [nodrag_settings,
                              lowdrag_settings,
                              default_settings,
                              hidrag_settings])
    return false
end

@test oscillation_drag_test()

# Contraptions should have dampened oscillations, with faster damping in more drag
function oscillation_damping_test()
    results = run_experiment([stretch_contraption for _ in 1:4],
                             [nodrag_settings,
                              lowdrag_settings,
                              default_settings,
                              hidrag_settings])
    return false
end 

@test oscillation_damping_test()

# Contraptions should bounce
function bounce_test(contraption)
    results = run_experiment([contraption],
                             [default_settings])

    return false
end

@test bounce_test(one_contraption)
@test bounce_test(two_contraption)
@test bounce_test(three_contraption)
@test bounce_test(seven_contraption)


# Contraptions should bounce higher with more elasticity
function elasticity_bounce_test()
    results = run_experiment([contraption for _ in 1:5],
                             [inelastic_settings,
                              lowelastic_settings,
                              default_settings,
                              hielastic_settings,
                              elastic_settings])
    return false
end

@test elasticity_bounce_test(one_contraption)
@test elasticity_bounce_test(two_contraption)
@test elasticity_bounce_test(three_contraption)
@test elasticity_bounce_test(seven_contraption)
@test elasticity_bounce_test(pogo_contraption)

# Energy should be conserved in the absence of drag or inelasticity
function energy_conservation_test(contraption)
    results = run_experiment([contraption],
                             [noloss_settings])

    return false
end

@test energy_conservation_test(one_contraption)
@test energy_conservation_test(seven_contraption)
@test energy_conservation_test(fast_contraption)
@test energy_conservation_test(strong_contraption)

# Contraptions should eventually come to rest
function come_to_rest_test(contraption)
    results = run_experiment([contraption],
                             [default_settings])
    return false
end

@test come_to_rest_test(one_contraption)
@test come_to_rest_test(two_contraption)
@test come_to_rest_test(three_contraption)

# Contraptions should spin after bouncing iff they're off-centre
function spin_test()
    results = run_experiment([seven_contraption, rotated],
                             [default_settings, default_settings])

    return false
end

@test spin_test()

# Larger contraptions should hit the ground sooner
function large_collision_test()
    results = run_experiment([small_contraption, 
                              seven_contraption, 
                              large_contraption],
                             [default_settings,
                              default_settings,
                              default_settings])
    return false
end

@test large_collision_test()

# Contraptions should take longer to hit the wall in larger environments
function large_env_test()
    results = run_experiment([seven_contraption, 
                              seven_contraption, 
                              seven_contraption],
                             [small_settings,
                              default_settings,
                              large_settings])

    return false
end

@test large_env_test()

# Larger contraptions should rest at a higher point
function large_rest_test()
    results = run_experiment([small_contraption, 
                              seven_contraption, 
                              large_contraption],
                             [default_settings,
                              default_settings,
                              default_settings])

    return false
end

@test large_rest_test()

# Light contraptions should rest at a higher point
function heavy_rest_test()
    results = run_experiment([light_contraption, 
                              seven_contraption, 
                              heavy_contraption],
                             [default_settings,
                              default_settings,
                              default_settings])

    return false
end

@test heavy_rest_test()

# Strong contraptions should rest at a higher point
function strong_rest_test()
    results = run_experiment([weak_contraption, 
                              seven_contraption, 
                              strong_contraption],
                             [default_settings,
                              default_settings,
                              default_settings])

    return false
end

@test heavy_rest_test()

# Fast contraptions should be approximately uniformly distributed over the bounding box at random times
function fast_distribution_test()
    results = run_experiment([fast_contraption],
                             [null_settings])

    return false
end

@test fast_distribution_test()

