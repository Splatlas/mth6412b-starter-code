include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")


# Fonction DFS récursive
function dfs!(arbre::Graph{T,Y}, current_node::Node{T}, visited::Vector{Node{T}}) where{T,Y}
    if current_node in visited
        return
    end
    push!(visited, current_node) # seule modif de la fonction : le vecteur visited en entrée est modifié
    for neighbor in neighbors(arbre, current_node)
        dfs!(arbre, neighbor, visited)
    end
end

# Fonction d'interface pour le parcours en profondeur
function depth_first_search(arbre::Graph{T,Y}) where{T,Y}
    visited = Vector{Node{T}}()
    for node in arbre.nodes
        if !(node in visited)
            dfs!(arbre, node, visited)
        end
    end
    
    return visited
end

function RSL(g::Graph{T,Y}) where{T,Y}
    tour = Graph("Tournée RSL de $(g.name)", Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))
    v_dfs = depth_first_search(kruskal(g))
    for k = 1:length(v_dfs)-1
        add_node!(tour,v_dfs[k])
        arete = find_edge(g,v_dfs[k],v_dfs[k+1])
        add_edge!(tour,arete)
    end
    add_node!(tour,v_dfs[end])
    arete = find_edge(g,v_dfs[1],v_dfs[end])
    add_edge!(tour,arete)
    return tour
end