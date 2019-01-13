mutable struct Contraption
    points::Array{Float64, 2}
    springs::Array{Int, 2}
    mass::Float64
    strength::Float64
end

function reshape_springs(springs::Array{Bool, 2})
    
    n = size(springs, 1)
    sparse_c = Array{Int, 2}(undef, 2, 0)
    
    for i in 1:n, j in (i+1):n
        if springs[i, j]
            sparse_c = hcat(sparse_c, [i; j])
        end
    end
    
    return sparse_c
end

function Contraption(points, springs::Array{Bool, 2}; mass=1., strength=1.) 
    
    # Basic shape checking
    @assert size(points, 1) == 2
    @assert size(points, 2) == size(springs, 1) == size(springs, 2)
    
    # Positivity checks
    @assert mass > 0
    @assert strength >= 0
    
    return Contraption(points, reshape_springs(springs), mass, strength)
                        
end     

function Contraption(points, springs::Array{Int, 2}; mass=1., strength=1.) 
    
    # Basic shape checking
    @assert size(points, 1) == 2
    @assert 1 <= minimum(springs)
    @assert maximum(springs) <= size(points, 2)
    
    # Positivity checks
    @assert mass > 0
    @assert strength >= 0
    
    return Contraption(points, springs, mass, strength)
                             
end