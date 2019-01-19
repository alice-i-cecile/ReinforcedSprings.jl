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

function complete_graph(n)
    graph = ones(Bool, n, n)
    graph[diagind(graph)] == 0 

    return graph
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