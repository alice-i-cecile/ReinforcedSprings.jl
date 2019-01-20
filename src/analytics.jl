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
    CoM = centre_of_mass(contraption)
    I = 0

    for i in eachindex(contraption.mass)
        r = Distances.norm(contraption.position[:, i] - CoM)
        I += contraption.mass[i] * r^2
    end

    return I
end

function momentum(contraption::Contraption)
    momentum = (0, 0)
    
    for i in eachindex(contraption.mass)
        momentum += contraption.velocity[:, i] * contraption.mass[i] 
    end

    return momentum
end

# FIXME: requires 3D coordinates everywhere in order to work
function angular_momentum(contraption::Contraption)
    CoM = centre_of_mass(contraption)
    L = (0, 0, 0)

    for i in eachindex(contraption.mass)
        r = contraption.position[:, i] - CoM
        p = contraption.velocity[:, i] * contraption.mass[i]
        L += Base.LinAlg.cross(r, p)
    end

    return L
end

# Computes average angular velocity derived from angular momentum and moment of inertia
function angular_velocity(contraption::Contraption)
    ω = angular_momentum(contraption) / moment_of_inertia(contraption)

    return ω
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