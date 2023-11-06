include("composanteconnexe.jl")

"""Type de composante connexe : dictionnaire de couple (clef,valeur) =  (noeud, parent) avec la racine de la composante"""
mutable struct RootedConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
  #root::Node{T}
end

"""Prend en entrée un vecteur de composantes connexes avec racine et retourne celle qui contient le noeud"""
function find_RoCC_where_node(V::Vector{RootedConnectedComponent{T}},noeud::Node{T}) where{T}
    for RoCC in V
      if haskey(RoCC.nodes, noeud)
        return RoCC
      end
    end
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


"""Fusionne la composante connexe 2 à la composante connexe 1 via l'arête."""
function fusion_compression!(RoCC1::RootedConnectedComponent{T}, RoCC2::RootedConnectedComponent{T}, edge::Edge{T,Y}) where {T,Y}
  noeud1,noeud2 = edge.node_1, edge.node_2
  if haskey(RoCC1.nodes,noeud1)
    RoCC1.nodes[noeud1] = noeud2
  elseif haskey(RoCC1.nodes, noeud2)
    RoCC1.nodes[noeud2] = noeud1
  end
  for (k,v) in RoCC2.nodes 
    RoCC1.nodes[k] = v
  end
  RoCC1
end

function heuristic_2_kruskal(g::Graph{T,Y}) where{T,Y}
    V_CC = all_nodes_as_CC(g)
    sorted_edges = sort(g.edges, by=weight)
    selected_edges = Edge{T,Y}[]
    P = 0
    for edge in sorted_edges
      noeud1, noeud2 = edge.node_1, edge.node_2
      CC1 = find_CC_where_node(V_CC,noeud1)
      CC2 = find_CC_where_node(V_CC,noeud2)
      if !same_CC(CC1,CC2)
        push!(selected_edges, edge)
        P = P + edge.weight
        fusion_compression!(CC1,CC2,edge)
        empty!(CC2)
      end
    end
    result = Graph{T,Y}("Kruskal de $(g.name)", nodes(g), selected_edges)
    show(result)
    return "Le poids total est $P"
  end