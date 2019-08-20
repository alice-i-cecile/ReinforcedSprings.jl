using Compose
import Distances

include("structs.jl")

function build(contraption::Contraption)
    # Combine components

    # Point masses ##
    x = contraption.position[1, :]
    y = - contraption.position[2, :] # Flip coordinates for graphics
    
    # Scale point size proportional to cube root of mass
    r = [0.01] .* contraption.mass .^ (1/3)
    
    points = compose(context(),
                  circle(x, y, r),
                  fill("black"),
                  fillopacity(1.))

    # Simplify drawing if no springs are found
    if sum(contraption.springs) == 0.
        return points
    end

    # Springs ##
    n = length(contraption.mass)
    X_i, Y_i, X_j, Y_j = [], [], [], []
    W = []

    for i in 1:n, j in (i+1):n
        if contraption.springs[i, j] != 0
            x_i, y_i = contraption.position[:, i]
            x_j, y_j = contraption.position[:, j]

            # Flip y-coordinates to match vector graphics convention
            push!(X_i, x_i)
            push!(Y_i, -y_i)
            push!(X_j, x_j)
            push!(Y_j, -y_j)

            # Base width of spring
            w = 1.0mm

            # Scale base spring width proportional to square root of strength
            w *= sqrt(contraption.springs[i,j]) / 100

            # Scale final spring width to conserve total spring volume
            # Base length * base width ^ 2 = current length * current width ^2
            current_length = Distances.norm(contraption.position[:, i] - contraption.position[:, j])
            w *= sqrt(contraption.rest_length[i, j] / current_length)

            push!(W, w)
        end
    end

    spring_array = [[(x_i, y_i), (x_j, y_j)] for (x_i, y_i, x_j, y_j) in zip(X_i, Y_i, X_j, Y_j)]

    lines = compose(context(),
                    line(spring_array),
                    stroke("black"),
                    linewidth(W),
                    strokeopacity(0.5))

    composition = compose(context(), points, lines)

    return composition

end

function build(bounds::Bounds)

    # Create non-square box if not square bounds
    if bounds.width == bounds.height
        scale_x, scale_y = 1., 1.
    elseif bounds.width < bounds.height
        scale_x, scale_y = bounds.width/bounds.height, 1.
    else
        scale_x, scale_y = 1. , bounds.height / bounds.width
    end

    obj = compose(context(), # Defaults to (0, 0, 1, 1)
                rectangle(0, 0, scale_x, scale_y),
                fill("white"), stroke("black"), linewidth(0.4mm))

    return obj

end

function build(contraption::Contraption, bounds::Bounds)
    bounds_sprite = build(bounds)

    contraption_sprite = build(contraption)

    # Rescale contraption based on bound size
    # Center such that (0, 0) is in the middle of the canvas
    scale_x = 1/bounds.width
    scale_y = 1/bounds.height
    
    scene = compose(bounds_sprite, 
                    (context(0.5, 0.5, scale_x, scale_y), contraption_sprite))

    return scene
end