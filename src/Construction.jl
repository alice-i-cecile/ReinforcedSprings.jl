function regular_polygon(n; radius = 0.3, θ_0 = 0., center=[0.5, 0.5])
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
   return ones(Bool, n, n) 
end