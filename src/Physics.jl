using Distances

# FIXME: very inefficient for sparse connections
# FIXME: split into mutable and immutable components?
mutable struct Contraption
    position::Array{Float64, 2}
    velocity::Array{Float64, 2}
    springs::Array{Bool, 2}
    rest_length::Array{Float64, 2}
    mass::Array{Float64, 1}
    strength::Array{Float64, 2}
end

# TODO: add custom initialization of strength and masses
# FIXME: consistency with column or row major data
function Contraption(position, springs::Array{Bool, 2}) 
    
    # Basic shape checking
    n = size(position, 2)
    @assert size(position, 1) == 2
    @assert size(springs, 1) == size(springs, 2) == n

    # Initialization
    velocity = zeros(2, n)

    rest_length = zeros(n, n)
    for i in 1:n, j in 1:n
        if springs[i, j]
            rest_length[i, j] = norm(position[i] - position[j])
        end
    end 

    mass = ones(size)
    strength = ones(size, size)

    return Contraption(position, velocity,
                       springs, 
                       mass, strength)
                    
end

function stepped_dynamics(obj::Contraption; Δt::Float64 = 1.)

    # TODO: abstract physics settings into struct
    # Physics constants
    g = 9.8
    drag = 0.01
    elasticity = 0.4

    # Bounding box
    bounds = (x = (0, 100),
              y = (0, 100))

    # Compute acceleration from forces
    for i in 1:size(obj.points, 1)

        # Reset all acceleration
        obj.a[i, :] = (0., 0.)

        # Gravity
        obj.a[i, :] += (0., -g)

        # Drag
        obj.a[i, :] -= drag*obj.velocity[i, :]

        # Springs
        attached_points = which()
        for j in attached_points
            Δs = obj.position[j] - obj.position[i]
            current_length = norm(Δs)
            direction = -Δs / current_length

            obj.a[i, :] += obj.strength[i,j] / obj.mass[i] * 
                 (current_length - obj.rest_length[i,j]) * 
                 direction # unit vector of force direction
        end

    end

    # Applying acceleration
    for i in 1:size(obj.points, 1)

        # Updating velocity from forces
        obj.velocity[i, :] += obj.a[i, :] * Δt

        t_remaining = Δt
        while t_remaining > 0

            # Movement
            proposed_position = obj.position[i, :] + 
                                obj.velocity[i, :] * Δt

            # Collision handling
            if (bounds.x[1] <= proposed_position[1] <= bounds.x[2]) |
               (bounds.y[1] <= proposed_position[2] <= bounds.y[2])
                
                # Determine whether horizontal or vertical collision is first
                # Catch 0 velocity cases
                if obj.velocity[i, 1] == 0
                    x_or_y = :y

                    Δt_bottom = obj.velocity[i, 2] / 
                                ((obj.position[i, 2] - bounds.y[1]))
                    Δt_top = obj.velocity[i, 2] / 
                             ((obj.position[i, 2] - bounds.y[2]))

                    Δt_c = max(Δt_bottom, Δt_top)
                else if obj.velocity[i, 2] == 0
                    x_or_y = :x

                    Δt_left = obj.velocity[i, 1] / 
                              ((obj.position[i, 1] - bounds.x[1]))
                    Δt_right = obj.velocity[i, 1] / 
                               ((obj.position[i, 1] - bounds.x[2]))

                    Δt_c = max(Δt_left, Δt_right)
                else 
                    Δt_left = obj.velocity[i, 1] / 
                        ((obj.position[i, 1] - bounds.x[1]))
                    Δt_right = obj.velocity[i, 1] / 
                        ((obj.position[i, 1] - bounds.x[2]))
                    Δt_bottom = obj.velocity[i, 2] / 
                        ((obj.position[i, 2] - bounds.y[1]))
                    Δt_top = obj.velocity[i, 2] / 
                        ((obj.position[i, 2] - bounds.y[2]))

                    # Only one of top/bottom will be positive
                    # Select that one as the collision which occurs in the future
                    # Then select sooner of collisions that will occur
                    Δt_x = max(Δt_left, Δt_right)
                    Δt_y = max(Δt_top, Δt_bottom)

                    x_or_y = ifelse(Δt_x >= Δt_y, :x, :y)
                    Δt_c = min(Δt_x, Δt_y)                    
                end
                
                # Update proposal and time remaining in time step
                proposed_position += obj.velocity*(Δt - Δt_c)
                t_remaining -= Δt_c

                # Change directions and lose energy
                if x_or_y == :x
                    obj.velocity[i, :] *= elasticity * [-1, 1]
                else 
                    obj.velocity[i, :] *= elasticity * [1, -1]
                end
            else
                obj.position[i, :] = proposed_position
                t_remaining = 0
            end
        end
    end



    return obj

end
