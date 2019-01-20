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