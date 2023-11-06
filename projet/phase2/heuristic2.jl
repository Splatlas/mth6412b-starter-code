include("composanteconnexe.jl")

"""Type de composante connexe : dictionnaire de couple (clef,valeur) =  (noeud, parent) avec la racine de la composante"""
mutable struct RootedConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
  #root::Node{T}
end




  """Prend un graphe G et renvoie un vecteur V contenant l'ensemble des composantes connexes initiales (ie l'ensemble des noeuds)"""
function all_nodes_as_RoCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RootedConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
    RoCC = RootedConnectedComponent{T}(d)
    push!(V,RoCC)
  end
  return V
end


"""Fusionne la composante connexe 2 à la composante connexe 1 via l'arête (node_1 de edge est dans CC1) :"""
function fusion_compression!(RoCC1::RootedConnectedComponent{T}, RoCC2::RootedConnectedComponent{T}, edge::Edge{T,Y}) where{T,Y}
    noeud1,noeud2 = edge.node_1, edge.node_2
    for noeud in keys(RoCC1.nodes)
        RoCC1.nodes[noeud] = noeud2  # on assigne à toutes les keys le même parent (donc la racine) : noeud2
    end
    for (k,v) in RoCC2.nodes
        RoCC1.nodes[k] = noeud2        # on rajoute les noeuds de RoCC2 dans RoCC1 en leur mettant noeud2 comme racine
    end
    RoCC1
end

"""Prend en entrée un vecteur de composantes connexes avec racine et retourne celle qui contient le noeud"""
function find_RoCC_where_node(V::Vector{RootedConnectedComponent{T}},noeud::Node{T}) where{T}
    for RoCC in V
      if haskey(RoCC.nodes, noeud)
        return RoCC
      end
    end
end
  
"""Compare deux composantes connexes avec racine et return True si elles ont la même racine (ie c'est les mêmes composantes connexes) """
function same_RoCC(RoCC1::RootedConnectedComponent{T},RoCC2::RootedConnectedComponent{T}) where{T}
    racine1 = first(values(RoCC1.nodes))
    racine2 = first(values(RoCC2.nodes))
    if racine1 == racine2
        return true
    else
        return false
    end
end


function heuristic_2_kruskal(g::Graph{T,Y}) where{T,Y}
    V_RoCC = all_nodes_as_RoCC(g)
    sorted_edges = sort(g.edges, by=weight)
    selected_edges = Edge{T,Y}[]
    P = 0
    for edge in sorted_edges
      noeud1, noeud2 = edge.node_1, edge.node_2
      RoCC1 = find_RoCC_where_node(V_RoCC,noeud1)
      RoCC2 = find_RoCC_where_node(V_RoCC,noeud2)
      if !same_RoCC(RoCC1,RoCC2)
        push!(selected_edges, edge)
        P = P + edge.weight
        fusion_compression!(RoCC1,RoCC2,edge)
        empty!(RoCC2)
      end
    end
    result = Graph{T,Y}("Kruskal de $(g.name)", nodes(g), selected_edges)
    show(result)
    return "Le poids total est $P"
  end