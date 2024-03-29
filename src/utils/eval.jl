function robust_path_eval(g::Graph, path::Vector{Int})

    path_edges = [(path[i], path[i+1]) for i = 1:length(path) - 1]

    worst_case_lengths = []
    for edge in path_edges
        push!(worst_case_lengths, g.d[edge[1], edge[2]])
    end

    sorted_indexes = sortperm(worst_case_lengths, rev=true)
    sorted_edges = path_edges[sorted_indexes]

    d1 = g.d1
    i = 1
    evaluation = 0

    for i = 1:length(sorted_edges)
        edge = sorted_edges[i]
        delta = min(g.D[edge[1], edge[2]], d1)
        evaluation += g.d[edge[1], edge[2]] * (1 + delta)
        if delta >= d1
            d1 = 0
        else
            d1 -= delta
        end
    end

    return evaluation
end


function robust_constraint_eval(g::Graph, path::Vector{Int})

    p_hats = g.ph[path]

    sorted_indexes = sortperm(p_hats, rev=true)
    sorted_nodes = path[sorted_indexes]

    d2 = g.d2
    i = 1
    evaluation = sum(g.p[path])

    while d2 > 0
        node = sorted_nodes[i]
        delta = min(2, d2)
        evaluation += delta * g.ph[node]
        i += 1
        d2 -= delta
    
    end

    return evaluation
end

function static_path_eval(g::Graph, path::Vector{Int})
    distance = 0
    for i = 1:length(path)-1
        distance += g.d[path[i], path[i+1]]
    end
    return distance
end

function static_constraint_eval(g::Graph, path::Vector{Int})
    path_weight = 0
    for i = 1:length(path)
        path_weight += g.p[path[i]]
    end
    return path_weight
end
