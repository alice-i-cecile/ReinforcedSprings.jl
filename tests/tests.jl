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
function newton_first_law_test()
    return false
end

@test newton_first_law_test()

# Springs should pull points together when they're stretched
function stretch_test()
    return false
end

@test stretch_test

# Springs should push points away when they're compressed
function compression_test()
    return false
end 

@test compression_test()

# Contraptions should fall when there's gravity
function falling_test()
    return false
end

@test falling_test()

# Contraptions should fall faster in more gravity
function gravity_falling_test()
    return false
end

@test gravity_falling_test()

# Contraptions should fall slower with more drag
function drag_falling_test()
    return false
end

@test drag_falling_test

# Contraptions should oscillate at about the same speed regardless of initial compression or extension
function oscillation_direction_test()
    return false
end

@test oscillation_direction_test()

# Contraptions should oscillate at about the same speed regardless of drag
function oscillation_drag_test()
    return false
end

@test oscillation_drag_test()

# Contraptions should have dampened oscillations, with faster damping in more drag
function oscillation_damping_test()
    return false
end 

@test oscillation_damping_test()

# Contraptions should bounce
function bounce_test()
    return false
end

@test bounce_test()

# Contraptions should bounce higher with more elasticity
function elasticity_bounce_test()
    return false
end

@test elasticity_bounce_test()

# Pogo contraptions should bounce higher with more elasticity
function elasticity_pogo_test()
    return false
end

@test elasticity_pogo_test()


# Momentum should be conserved in the absence of drag or inelasticity
function momentum_conservation_test()
    return false
end

@test momentum_conservation_test()

# Energy should be conserved in the absence of drag or inelasticity
function energy_conservation_test()
    return false
end

@test energy_conservation_test()

# Contraptions should eventually come to rest
function come_to_rest_test()
    return false
end

@test come_to_rest_test()

# Contraptions should spin after bouncing iff they're off-centre
function spin_test()
    return false
end

@test spin_test()

# Larger contraptions should hit the wall sooner
function large_collision_test()
    return false
end

@test large_collision_test()

# Contraptions should take longer to hit the wall in larger environments
function large_env_test()
    return false
end

@test large_env_test()

# Larger contraptions should rest at a higher point
function large_rest_test()
    return false
end

@test large_rest_test()

# Light contraptions should rest at a higher point
function heavy_rest_test()
    return false
end

@test heavy_rest_test()

# Strong contraptions should rest at a higher point
function strong_rest_test()
    return false
end

@test heavy_rest_test()

# Fast contraptions should be approximately uniformly distributed over the bounding box at random times
function fast_distribution_test()
    return false
end

@test fast_distribution_test()

# Energy should be decreasing or conserved even at high speeds
function fast_conservation_test()
    return false
end

@test fast_conservation_test()

# Energy should be decreasing or conserved even at high spring strengths
function strong_conservation_test()
    return false
end

@test strong_conservation_test()

