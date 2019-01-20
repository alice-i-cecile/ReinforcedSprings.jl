import Compose

include("structs.jl")

function build(contraption::Contraption)
    # Point masses ##
    for i in eachindex(contraption.mass)
        # Scale point size proportional to cube root of mass

    end

    # Springs ##
    for i in eachindex(contraption.springs)
        # Scale base spring width proportional to square root of strength
        

        # Scale final spring width to conserve total spring volume

    end

    # Combine components

    return "NYI"
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

function build_contraption(contraption::Contraption)
    x = contraption.points[1, :]
    y = contraption.points[2, :]
    r = [0.01]
    
    X_i = []
    Y_i = []
    X_j = []
    Y_j = []
    
    for spring in 1:size(contraption.springs, 2)
        i, j = contraption.springs[:, spring]
    
        x_i, y_i = contraption.points[:, i]
        x_j, y_j = contraption.points[:, j]
        
        push!(X_i, x_i)
        push!(Y_i, y_i)
        push!(X_j, x_j)
        push!(Y_j, y_j)
    end
    
    spring_array = [[(x_i, y_i), (x_j, y_j)] for (x_i, y_i, x_j, y_j) in zip(X_i, Y_i, X_j, Y_j)]
        
    obj = compose(context(),
                  circle(x, y, r),
                  line(spring_array),
                  fill("black"),
                  stroke("black"),
                  fillopacity(1.),
                  strokeopacity(0.5))

    return obj
end

draw(SVG("contraption$i.svg", 4cm, 4cm), build_contraption(my_contraption))
