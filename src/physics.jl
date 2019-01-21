import Distances
include("structs.jl")

function stepped_dynamics(obj::Contraption, settings::PhysicsSettings, Δt::Float64)
    # Name binding for brevity
    bounds = settings.bounds
    n = length(obj.mass)

    # Storing kinematics
    s = deepcopy(obj.position)
    v = deepcopy(obj.velocity)
    a = zeros(2, n)

    # Compute acceleration from forces
    for i in 1:n
        # Gravity
        a[:, i] += [0., -settings.g]

        # Drag
        a[:, i] -= settings.drag * v[:, i]

        # Springs
        # TODO: should connections be memoized?
        for j in 1:n # Don't double-count!
            if obj.springs[i, j] != 0.
                Δs = s[:, j] - s[:, i]
                current_length = Distances.norm(Δs)
                direction = Δs / current_length
    
                a[:, i] += obj.springs[i,j] / obj.mass[i] * 
                     (current_length - obj.rest_length[i,j]) * 
                     direction # unit vector of force direction
            end
        end

    end

    # Applying acceleration
    for i in 1:n
        # Updating velocity from forces
        v[:, i] += a[:, i] * Δt

        # Continually attempt to apply velocity until result is in-bounds
        t_remaining = Δt
        while t_remaining > 0.

            # Movement
            proposed_position = s[:, i] + v[:, i] * Δt

            # Collision handling
            if !(bounds.x[1] <= proposed_position[1] <= bounds.x[2]) |
               !(bounds.y[1] <= proposed_position[2] <= bounds.y[2])
                
                # Determine whether horizontal or vertical collision is first
                # Catch 0 velocity cases
                if v[1, i] == 0.
                    x_or_y = :y

                    Δt_bottom = v[2, i] / (s[2, i] - bounds.y[1])
                    Δt_top    = v[2, i] / (s[2, i] - bounds.y[2])

                    Δt_c = max(Δt_bottom, Δt_top)
                elseif v[2, i] == 0.
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
                proposed_position -= v[:, i]*(Δt - Δt_c)
                t_remaining -= Δt_c

                # Change directions and lose energy
                if x_or_y == :x
                    v[1, i] *= -settings.elasticity
                else 
                    v[2, i] *= -settings.elasticity
                end
            else
                s[:, i] = proposed_position
                t_remaining = 0
            end
        end
    end

    return (s, v)

end

