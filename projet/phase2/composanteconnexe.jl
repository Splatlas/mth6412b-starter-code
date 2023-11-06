include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")


abstract type AbstractConnectedComponent{T} end

# Une composante connexe n'est qu'un ensemble de noeuds qui seront stockés dans les clés. 
# L'utilisation des valeurs du dictionnaire servira pour les heuristiques
mutable struct ConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
end


"""Vide une composante connexe de ses noeuds"""
function empty!(CC::AbstractConnectedComponent{T}) where{T}
  CC.nodes = Dict{Node{T}, Node{T}}()  # remplace le dictionnaire de la CC par un dictionnaire vide
  CC
end

"""Prend un graphe G et renvoie un vecteur V contenant l'ensemble des composantes connexes initiales.
V contient des composantes connexes de taille 1 noeud"""
function all_nodes_as_CC(g::Graph{T}) where T
  V = Vector{ConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()  
    d[k] = k                       # un rentre le noeud en clé mais aussi en valeur : pas utile mais c'était un noeud sous la main
    CC = ConnectedComponent{T}(d)
    push!(V,CC)
  end
  return V
end


# Les composantes connexes créées à partir d'une fusion de composantes unitaires donne des dictionnaires 
# dont seules les clés représentent les noeuds de la composante connexe. Les valeurs ne servent a rien 
# dans cette version de kruskal
"""Fusionne la composante connexe 2 à la composante connexe 1 via l'arête (hypothèse: node_1 de edge est dans CC1) : """
function fusion_CC!(CC1::AbstractConnectedComponent{T}, CC2::AbstractConnectedComponent{T}) where {T}       
  for (k,v) in CC2.nodes                    
    CC1.nodes[k] = v                       
  end           
  CC1
end

"""Prend en entrée un vecteur de composantes connexes et retourne celle qui contient le noeud"""
function find_CC_where_node(V::Vector{ConnectedComponent{T}},noeud::Node{T}) where{T}
  for CC in V
    if haskey(CC.nodes, noeud)
      return CC
    end
  end
end


"""Compare deux composantes connexes et return True si c'est les même.
Dans ce cas de figure, deux dictionnaires sont les mêmes s'ils ont les mêmes clés """
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
  V_CC = all_nodes_as_CC(g)                 # récupère les CC unitaires dans un vecteur
  sorted_edges = sort(g.edges, by=weight)   # donne un vecteur des arêtes de g triées par poids
  selected_edges = Edge{T,Y}[]              # initialise un vecteur vide dans lequel on stocke les arêtes retenues
  P = 0                                     # stocke le poids total de l'arbre de recouvrement
  for edge in sorted_edges
    noeud1, noeud2 = edge.node_1, edge.node_2
    CC1 = find_CC_where_node(V_CC,noeud1)   # CC1 contient le noeud1
    CC2 = find_CC_where_node(V_CC,noeud2)   # pareil pour 2
    if !same_CC(CC1,CC2)                    # vérifie que les 2 noeuds n'appartiennent pas à la même CC
      push!(selected_edges, edge)           # l'arête est retenue
      P = P + edge.weight
      fusion_CC!(CC1,CC2)                   # CC2 est intégrée à CC1
      empty!(CC2)
    end
  end
  result = Graph{T,Y}("Kruskal de $(g.name)", nodes(g), selected_edges)
  show(result)
  return "Le poids total est $P"
end