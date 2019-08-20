# Point mass configuration ####
function regular_polygon(n; radius = 1, θ_0 = 0., center=[0., 0.])
    function create_point(i)
        θ = 2*π*i/n
        point = [center[1] + radius*cos(θ + θ_0), 
                 center[2] + radius*sin(θ + θ_0)]
        return point
    end
    
    points = Array{Float64,2}(undef, 2, n)
    for i in 1:n
        points[1, i], points[2, i] = create_point(i)
    end
    
    return points
end

# Spring configuration ####
function complete_graph(n)
    graph = ones(Float64, n, n)

    for i in 1:n
        graph[i, i] = 0.
    end

    return graph
end

function loop_graph(n, connections = [1,])
    graph = zeros(Float64, n, n)

    # Ensure that neighbours that are i away in other direction are connected
    complementary_connections = [n - i for i in connections]
    append!(connections, complementary_connections)

    for i in 1:n, j in (i+1):n
        if (j - i) ∈ connections
            graph[i, j], graph[j, i] = 1., 1.
        end
    end

    return graph
end

