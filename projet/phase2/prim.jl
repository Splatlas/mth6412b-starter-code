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

function Prim(g::Graph{T,Y},s::Node{T}) where{T,Y}
    
    pile = PriorityQueue{PriorityItem}()
    Graphe_prim = Graph("Prim", Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))
    add_node!(Graphe_prim,s)
    

    #Initialisation : remplissage de la pile
    for noeud in Graph.nodes
        if !(noeud == s)
            selected_edge = find_lowest_edge_to_graph(Graphe_prim,noeud)
            convert(Int, selected_edge.weight)
            item = PriorityItem(convert(Int, selected_edge.weight), noeud)
            push!(pile, item)
        end
    end
    node_added = Node{T}[]
    push!(node_added,s)

    #Hérédité : on dépile l'élément de plus bas poids et on modifie les min_weight des éléments de la pile
    while length(node_added) <length(g.nodes)
        #Dépilage et remplissage de Graphe_prim
        lowest = poplast!(pile)

end
            