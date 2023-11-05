include("node.jl")
include("edge.jl")
include("graph.jl")


#On va utiliser des dictionnaires pour représenter les arêtes dans la CC : 
#La CC n'a pas besoin des poids, juste des arêtes représentés par une paire de noeud dans le dicitonnaire
#Les clés correspondent aux noeuds présents dans la composante, les valeurs représentent l'arête
#Une feuille est donc représentée par un couple (clé,valeur) = (feuille, feuille)
mutable struct ConnectedComponent{T} <: AbstractGraph{T}
  nodes::Dict{Node{T}, Node{T}}
end



"""Prend un graphe G et renvoie un vecteur V contenant l'ensemble des composantes connexes initiales (ie l'ensemble des noeuds)"""
function initial_CC(g::Graph{T}) where T
  V = Vector{ConnectedComponent{T}}()
  for k in nodes(g)
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
function fusion_CC!(CC1::ConnectedComponent{T}, CC2::ConnectedComponent{T}, edge::Edge{T,Y}) where {T,Y}
  noeud1,noeud2 = vertices(Edge) 
  if haskey(nodes(CC1),noeud1)
    CC1.nodes[noeud1] = noeud2
  elseif haskey(nodes(CC1), noeud2)
    CC1.nodes[noeud2] = noeud1
  end
  for (k,v) in nodes(CC2)
    CC1[k] = v
  end
  CC1
end

"""Prend en entrée un vecteur de composantes connexes et retourne celle qui contient le noeud"""
function get_CC_with_node(V::Vector{ConnectedComponent{T}},noeud::Node{T})
  for CC in V
    if haskey(CC, noeud)
      return CC
    end
  end
end


"""Compare deux composantes connexes et return True si elles sont différentes"""
function same_CC(CC1::ConnectedComponent{T},CC2::ConnectedComponent{T})
  if length(nodes(CC1)) != length(nodes(CC2))
    return false
  else
    for noeud in keys(nodes(CC1))
      if !haskey(nodes(CC2), noeud)
        return false
      end
    end
  end
  return true
end




function kruskal(g::Graph{T}) where{T}
  V_CC = initial_CC(g)
  sorted_edges = sort(edges(g), by=weight)
  selected_edges = Vector{Edge{T}}
  for edge in sorted_edges
    noeud1, noeud2 = vertices(edge)
    CC1 = get_CC_with_node(V_CC,noeud1)
    CC2 = get_CC_with_node(V_CC,noeud2)
    if !same_CC(CC1,CC2)
      push!(selected_edges, edge)
      fusion_CC!(CC1,CC2,edge)
      empty!(CC2)
    end
  end
  return Graph{T}("Kruskal de $(name(g))", nodes(g), selected_edges)
end

