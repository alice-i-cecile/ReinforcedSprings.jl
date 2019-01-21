using Compose
import Distances

include("structs.jl")

function build(contraption::Contraption)
    # Combine components

    # Point masses ##
    x = contraption.position[1, :]
    y = contraption.position[2, :]
    
    # Scale point size proportional to cube root of mass
    r = [0.01] .* contraption.mass .^ (1/3)
    
    # Springs ##
    n = length(contraption.mass)
    X_i, Y_i, X_j, Y_j = [], [], [], []
    W = []

    for i in 1:n, j in (i+1):n
        if contraption.springs[i, j] != 0
            x_i, y_i = contraption.position[:, i]
            x_j, y_j = contraption.position[:, j]

            push!(X_i, x_i)
            push!(Y_i, y_i)
            push!(X_j, x_j)
            push!(Y_j, y_j)

            # Base width of spring
            w = 0.2mm

            # Scale base spring width proportional to square root of strength
            w *= sqrt(contraption.springs[i,j])

            # Scale final spring width to conserve total spring volume
            # Base length * base width ^ 2 = current length * current width ^2
            current_length = Distances.norm(contraption.position[:, i] - contraption.position[:, j])
            w *= sqrt(contraption.rest_length[i, j] / current_length)

            push!(W, w)
        end
    end

    spring_array = [[(x_i, y_i), (x_j, y_j)] for (x_i, y_i, x_j, y_j) in zip(X_i, Y_i, X_j, Y_j)]
        
    obj = compose(context(),
                  circle(x, y, r),
                  line(spring_array),
                  fill("black"),
                  stroke("black"),
                  linewidth(W),
                  fillopacity(1.),
                  strokeopacity(0.5))

    return obj

end

function build(bounds::Bounds)
    # Set corners of box to edge of bounds


    return "NYI"

end

function build(contraption::Contraption, bounds::Bounds)
    bounds_sprite = build(bounds)

    contraption_sprite = build(contraption)

    # Rescale view box to fit the bounds

    return "NYI"
end