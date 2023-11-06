include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")


abstract type AbstractConnectedComponent{T} end
#On va utiliser des dictionnaires pour représenter les arêtes dans la CC : 
#La CC n'a pas besoin des poids, juste des arêtes représentés par une paire de noeud dans le dicitonnaire
#Les clés correspondent aux noeuds présents dans la composante, les valeurs représentent l'arête
#Une feuille est donc représentée par un couple (clé,valeur) = (feuille, feuille)
mutable struct ConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
end



"""Prend un graphe G et renvoie un vecteur V contenant l'ensemble des composantes connexes initiales (ie l'ensemble des noeuds)"""
function all_nodes_as_CC(g::Graph{T}) where T
  V = Vector{ConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
    CC = ConnectedComponent{T}(d)
    push!(V,CC)
  end
  return V
end


"""Vide une composante connexe de ses noeuds"""
function empty!(CC::ConnectedComponent{T}) where{T}
  CC.nodes = Dict{Node{T}, Node{T}}()
  CC
end



  """Fusionne la composante connexe 2 à la composante connexe 1 via l'arête."""
function fusion_CC!(CC1::AbstractConnectedComponent{T}, CC2::AbstractConnectedComponent{T}, edge::Edge{T,Y}) where {T,Y}
  noeud1,noeud2 = edge.node_1, edge.node_2
  if haskey(CC1.nodes,noeud1)
    CC1.nodes[noeud1] = noeud2
  elseif haskey(CC1.nodes, noeud2)
    CC1.nodes[noeud2] = noeud1
  end
  for (k,v) in CC2.nodes 
    CC1.nodes[k] = v
  end
  CC1
end

"""Prend en entrée un vecteur de composantes connexes et retourne celle qui contient le noeud"""
function find_CC_with_node(V::Vector{ConnectedComponent{T}},noeud::Node{T}) where{T}
  for CC in V
    if haskey(CC.nodes, noeud)
      return CC
    end
  end
end


"""Compare deux composantes connexes et return True si elles sont différentes"""
function same_CC(CC1::AbstractConnectedComponent{T},CC2::AbstractConnectedComponent{T}) where{T}
  if length(CC1.nodes) != length(CC2.nodes)
    return false
  else
    for noeud in keys(CC1.nodes)
      if !haskey(CC2.nodes, noeud)
        return false
      end
    end
  end
  return true
end




function kruskal(g::Graph{T,Y}) where{T,Y}
  V_CC = all_nodes_as_CC(g)
  sorted_edges = sort(g.edges, by=weight)
  selected_edges = Edge{T,Y}[]
  for edge in sorted_edges
    noeud1, noeud2 = edge.node_1, edge.node_2
    CC1 = find_CC_with_node(V_CC,noeud1)
    CC2 = find_CC_with_node(V_CC,noeud2)
    if !same_CC(CC1,CC2)
      push!(selected_edges, edge)
      fusion_CC!(CC1,CC2,edge)
      empty!(CC2)
    end
  end
  return Graph{T,Y}("Kruskal de $(name(g))", nodes(g), selected_edges)
end