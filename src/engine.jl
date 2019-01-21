include("physics.jl")
include("graphics.jl")

function engine(contraption::Contraption;
                settings::PhysicsSettings = PhysicsSettings(),
                Δt::Float64 = 0.01,
                t_total::Float64 = 10.,
                graphics::Bool = false,
                logging::Bool = true)

    @assert Δt > 0
    @assert t_total > 0
    @assert graphics | logging

    n = length(contraption.mass)
    n_steps = Int(div(t_total, Δt))

    # Avoid making changes to initial object passed in
    contraption = deepcopy(contraption)

    # Check that contraption is initialized in bounds
    for i in 1:n
    in_bounds(s) = (settings.bounds.x[1] <= s[1] <= settings.bounds.x[2]) &
                   (settings.bounds.y[1] <= s[2] <= settings.bounds.y[2])

    @assert in_bounds(contraption.position[:, i])
    end

    # Store position and velocity evolution as an array 
    # for display, debugging and evaluation
    # Axes are: time step, x vs y, point number
    if logging
        positions = Array{Float64}(undef, n_steps, 2, n)
        velocities = Array{Float64}(undef, n_steps, 2, n)
    end

    for t in 1:n_steps
        if logging
            positions[t, :, :] = contraption.position
            velocities[t, :, :] = contraption.velocity
        end

        if graphics
            IJulia.clear_output(true)

            scene = build(contraption, settings.bounds)
            draw(SVGJS(), scene)
            sleep(Δt) # FIXME: not true constant framerate
        end

        # Update state
        contraption.position, contraption.velocity = stepped_dynamics(contraption, settings, Δt)
    end

    if logging
        return (position = positions, velocity = velocities)
    else
        return nothing
    end
end