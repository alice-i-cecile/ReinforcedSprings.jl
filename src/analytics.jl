include("physics.jl")

function centre_of_mass(contraption::Contraption)
    CoM = (0, 0)

    for i in eachindex(contraption.mass)
        CoM += contraption.mass[i]  * contraption.position[:, i]
    end

    CoM /= sum(contraption.mass)

    return CoM 
end

function moment_of_inertia(contraption::Contraption)

end

function momentum(contraption::Contraption)
    momentum = (0, 0)
    
    for i in eachindex(contraption.mass)
        momentum += contraption.velocity[:, i] * contraption.mass[i] 
    end

    return momentum
end

function angular_momentum(contraption::Contraption)

end

function kinetic_energy(contraption::Contraption)
    E = 0

    for i in eachindex(contraption.mass)
        E += 0.5 * contraption.mass[i] * contraption.velocity[:, i] ^ 2   
    end

    return E
end

function elastic_energy(contraption::Contraption)
    E = 0
    
    for i in eachindex(contraption.springs)
        if contraption.springs != 0    
            Δs = Distances.norm(contraption.position[:, i[1]] - contraption.position[:, i[2]])

            E += 0.5 * contraption.springs[i] * Δs ^ 2
        end
    end

    return E
end

# Gravitational potential energy, computed relative to y = 0
function gravitational_energy(contraption::Contraption, g::Float64)

    E = 0
    for i in eachindex(contraption.mass)
        E += contraption.mass[i] * g * contraption.position[2, i]
    end

    return E
end

function total_energy(contraption::Contraption)

    E = sum(kinetic_energy(contraption),
            elastic_energy(contraption),
            gravitational_energy(contraption))

    return E
end

function detect_collision(velocity_series)

end

function detect_rest(velocity_series)

end

function detect_oscillation(velocity_series)

end