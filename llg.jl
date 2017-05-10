#!/usr/bin/env julia

function traverse_paths{T}(graph::Array{Array{T}}, position::T, visited::BitArray, stack::Array{T}, toppath::Array{T}, depth::T)
    @inbounds stack[depth] = position
    @inbounds visited[position] = true
    if depth > length(toppath)
        empty!(toppath)
        append!(toppath, stack[1:depth])
    end
    @inbounds for p in graph[position]
        @inbounds if !visited[p]
            traverse_paths(graph, p, visited, stack, toppath, depth + 1)
        end
    end
    @inbounds visited[position] = false
end

function longest_path{T}(graph::Array{Array{T}})
    len = length(graph)
    visited = falses(len)
    stack = zeros(T, len)
    toppath = T[]
    for i = 1:len
        traverse_paths(graph, i, visited, stack, toppath, 1)
    end
    return toppath
end

function main()
    words = unique(filter((e->!isempty(e)), map(strip, eachline(STDIN))))
    count = length(words)

    graph = Array{Array{typeof(count)}}((count,))

    for (i, left) in enumerate(words)
        graph[i] = typeof(count)[]
        for (j, right) in enumerate(words)
            if left[end] == right[1]
                push!(graph[i], j)
            end
        end
    end

    for w in map(i -> words[i], longest_path(graph))
        println(w)
    end

end

main()
