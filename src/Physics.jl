using Distances

# TODO: very inefficient for sparse connections,
# upgrade to SparseArrays when performance becomes limiting
struct Contraption
    # Columns are points, row 1 is x-coordinates, row 2 is y-coordinates 
    position::Array{Float64, 2}
    velocity::Array{Float64, 2}

    # Mass of point i
    mass::Array{Float64, 1}

    # Zero value implies lack of spring
    # Spring strength between point i and j
    springs::Array{Float64, 2}

    # Length of springs at which no force is applied
    rest_length::Array{Float64, 2}
end

function Contraption(position::Array{Float64, 2},
                     velocity::Array{Float64, 2}, 
                     mass::Array{Float64, 1}, 
                     springs::Array{Float64, 2}) 
    
    # Basic shape checking
    n = size(position, 2)

    @assert size(position) ==  (2, n)

    @assert size(velocity) == (2, n)

    @assert size(mass) == n

    @assert size(springs) == (n, n)

    # Symmetry checking
    for i in 1:n, j in (i+1):n
        @assert springs[i, j] == springs[j, i]
    end

    # Self-connection checking
    for i in 1:n
        @assert spring[i, i] == 0
    end

    # Initialization
    rest_length = zeros(n, n)
    for i in 1:n, j in (i+1):n
        if springs[i, j]
            rest_length[i, j] = norm(position[i] - position[j])
            rest_length[j, i] = rest_length[i, j]
        end
    end
    @assert size(rest_length) == (n, n)

    return Contraption(position, velocity, mass,
                       springs, rest_length)

end

struct Bounds
    x::Tuple{Float64}
    y::Tuple{Float64}
end

struct PhysicsSettings
    g::Float64
    drag::Float64
    elasticity::Float64
    bounds::Bounds

    @assert drag >= 0.
    @assert 0 <= elasticity <= 1
end

# Trivial constructor to allow sane defaults
function PhysicsSettings(g::Float64 = 10,
                         drag::Float64 = 0.1,
                         elasticity::Float64 = 0.4,
                         bounds::Bounds = ((-100., 100.),
                                           (-100., 100.)))

    return PhysicsSettings(g, drag, elasticity, bounds)
end

function stepped_dynamics(obj::Contraption, settings::PhysicsSettings, Δt::Float64)
    # Name binding for brevity
    bounds = settings.bounds
    n = size(obj.points, 2)

    # Storing kinematics
    s = deepcopy(obj.position)
    v = deepcopy(obj.velocity)
    a = zeros(2, n)

    # Compute acceleration from forces
    for i in 1:n
        # Gravity
        a[:, i] += (0., -settings.g)

        # Drag
        a[:, i] -= settings.drag * v[:, i]

        # Springs
        # TODO: should connections be memoized?
        for j in 1:n # Don't double-count!
            if springs(i, j) != 0.
                Δs = s[:, j] - s[:, i]
                current_length = norm(Δs)
                direction = -Δs / current_length
    
                a[:, i] += obj.springs[i,j] / obj.mass[i] * 
                     (current_length - obj.rest_length[i,j]) * 
                     direction # unit vector of force direction
            end
        end

    end

    # Applying acceleration
    for i in 1:size(obj.points, 1)

        # Updating velocity from forces
        v[:, i] += a[:, i] * Δt

        # Continually attempt to apply velocity until result is in-bounds
        t_remaining = Δt
        while t_remaining > 0

            # Movement
            proposed_position = s[:, i] + v[:, i] * Δt

            # Collision handling
            if !(bounds.x[1] <= proposed_position[1] <= bounds.x[2]) |
               !(bounds.y[1] <= proposed_position[2] <= bounds.y[2])
                
                # Determine whether horizontal or vertical collision is first
                # Catch 0 velocity cases
                if v[1, i] == 0
                    x_or_y = :y

                    Δt_bottom = v[2, i] / (s[2, i] - bounds.y[1])
                    Δt_top    = v[2, i] / (s[2, i] - bounds.y[2])

                    Δt_c = max(Δt_bottom, Δt_top)
                elseif v[2, i] == 0
                    x_or_y = :x

                    Δt_left  = v[1, i] / (s[1, i] - bounds.x[1])
                    Δt_right = v[1, i] / (s[1, i] - bounds.x[2])

                    Δt_c = max(Δt_left, Δt_right)
                else 
                    Δt_left   = v[1, i] / (s[1, i] - bounds.x[1])
                    Δt_right  = v[1, i] / (s[1, i] - bounds.x[2])
                    Δt_bottom = v[2, i] / (s[2, i] - bounds.y[1])
                    Δt_top    = v[2, i] / (s[2, i] - bounds.y[2])

                    # Only one of top/bottom will be positive
                    # Select that one as the collision which occurs in the future
                    # Then select sooner of collisions that will occur
                    Δt_x = max(Δt_left, Δt_right)
                    Δt_y = max(Δt_top, Δt_bottom)

                    x_or_y = ifelse(Δt_x >= Δt_y, :x, :y)
                    Δt_c = min(Δt_x, Δt_y)
                end
                
                # Update proposal and time remaining in time step
                # Reverse movement to get to point where collision with wall occurs
                proposed_position -= v*(Δt - Δt_c)
                t_remaining -= Δt_c

                # Change directions and lose energy
                if x_or_y == :x
                    v[:, i] *= elasticity * [-1, 1]
                else 
                    v[:, i] *= elasticity * [1, -1]
                end
            else
                s[:, i] = proposed_position
                t_remaining = 0
            end
        end
    end

    return (s, v)

end

function engine(contraption::Contraption;
                settings::PhysicsSettings = PhysicsSettings(),
                Δt::Float64 = 0.01,
                t_total::Float64 = 10)


    @assert Δt > 0
    @assert t_total > 0

    n = size(contraption.position, 2)
    n_steps = div(t_total, Δt)

    # Check that contraption is initialized in bounds
    for i in 1:n
        in_bounds(s) = (settings.bounds.x[1] <= s[1] <= settings.bounds.x[2]) &
                       (settings.bounds.y[1] <= s[2] <= settings.bounds.y[2])

        @assert in_bounds(contraption.position[:, i])
    end

    # Store position and velocity evolution as an array 
    # for display, debugging and evaluation
    # Axes are: time step, x vs y, point number
    positions = Array{Float64}(undef, n_steps, 2, n)
    velocities = Array{Float64}(undef, n_steps, 2, n)

    for t in n_steps
    positions[t, :, :] = contraption.position
    velocities[t, :, :] = contraption.velocity

    position, velocity = stepped_dynamics(contraption, settings, Δt)

    contraption = Contraption(position, 
                        velocity, 
                        contraption.mass,
                        contraption.springs,
                        contraption.rest_length)
    end

    return (position = positions, velocity = velocities)
end
