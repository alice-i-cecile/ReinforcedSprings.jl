import Distances

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
    n = length(mass)

    @assert size(position) ==  (2, n)

    @assert size(velocity) == (2, n)

    @assert size(mass) == (n,)

    @assert size(springs) == (n, n)

    # Symmetry checking
    for i in 1:n, j in (i+1):n
        @assert springs[i, j] == springs[j, i]
    end

    # Self-connection checking
    for i in 1:n
        @assert springs[i, i] == 0
    end

    # Initialization
    rest_length = zeros(n, n)
    for i in 1:n, j in (i+1):n
        if springs[i, j] != 0.
            rest_length[i, j] = Distances.norm(position[i] - position[j])
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

    # FIXME: handle checking properly
    #@assert drag >= 0.
    #@assert 0 <= elasticity <= 1
end

# Trivial constructor to allow sane defaults
function PhysicsSettings(g::Float64 = 10,
                         drag::Float64 = 0.1,
                         elasticity::Float64 = 0.4,
                         bounds::Bounds = ((-100., 100.),
                                           (-100., 100.)))

    return PhysicsSettings(g, drag, elasticity, bounds)
end
