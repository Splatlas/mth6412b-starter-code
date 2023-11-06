include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")



""" Prend un graphe et un noeud hors du graphe en entrée, renvoie l'arête de poids minimal liant le noeud au graphe"""
function find_lowest_edge_to_graph(g::Graph{T,Y}, noeud::Node{T}) where{T,Y}
    min_weight = Inf
    selected_edge = Edge{T,Y}()
    for edge in g.edges
        if (edge.node_1 == noeud) || (edge.node_2 == noeud)
            if edge.weight < min_weight
                min_weight = edge.weight
                selected_edge = edge
            end
        end
    end
    return selected_edge
end

function priority_file_with_nodes(T::(Node{Y},Int)) where{T}
    item = PriorityItem()




function all_nodes_as_CC(g::Graph{T}) where T
    V = Vector{ConnectedComponent{T}}()
    for k in g.nodes
      d = Dict{Node{T}, Node{T}}()  
      d[k] = nothing                       
      CC = ConnectedComponent{T}(d)
      push!(V,CC)
    end
    return V
  end

            