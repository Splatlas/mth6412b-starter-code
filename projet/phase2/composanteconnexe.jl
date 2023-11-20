include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")

import Base.show

abstract type AbstractConnectedComponent{T} end


""" Type de composante connexe (CC) : dictionnaire où l'ensemble des noeuds correspond à l'ensemble des clés
L'utilisation des valeurs du dictionnaire servira pour d'autres cas (orienté?) """
mutable struct ConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
end

"""Constructeur de CC"""
function ConnectedComponent{T}() where T
  ConnectedComponent{T}(Dict{Node{T}, Node{T}}())
end


function show(CC::ConnectedComponent)
  for (key,value) in CC.nodes
    show(key,value)
  end
end

"""Permet d'ajouter un noeud à une CC"""
function add_node!(cc::ConnectedComponent{T}, node::Node{T}) where T
  cc.nodes[node] = node
end

"""Vide une CC de ses noeuds"""
function empty!(CC::AbstractConnectedComponent{T}) where{T}
  CC.nodes = Dict{Node{T}, Node{T}}()  # remplace le dictionnaire de la CC par un dictionnaire vide
  CC
end

"""Prend un graphe G et renvoie un vecteur V contenant l'ensemble des CC initiales (unitaires).
V contient des CC de taille unitaire = 1 noeud"""
function all_nodes_as_CC(g::Graph{T}) where{T}
  V = Vector{ConnectedComponent{T}}()
  for k in g.nodes
    CC = ConnectedComponent{T}()
    add_node!(CC,k)
    push!(V,CC)
  end
  return V
end


"""Prend en entrée un vecteur de CC et retourne celle qui contient le noeud"""
function find_CC_where_node(V::Vector{ConnectedComponent{T}},noeud::Node{T}) where{T}
  for CC in V
    b = noeud in keys(CC.nodes)
    if b
      return CC
    end
  end
end




"""Compare deux CC et return True si c'est les même.
Dans ce cas de figure, deux dictionnaires sont les mêmes s'ils ont les mêmes clés (les valeurs ne servent à rien)"""
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

# Les CC créées à partir d'une fusion de CC unitaires donne des dictionnaires 
# dont seules les clés représentent les noeuds de la CC. Les valeurs ne servent à rien 
# dans cette version de kruskal
"""Fusionne la CC2 à la CC1 (hypothèse: node_1 de edge est dans CC1) : """
function fusion_CC!(CC1::AbstractConnectedComponent{T}, CC2::AbstractConnectedComponent{T}) where{T}       
  for (k,v) in CC2.nodes                    
    CC1.nodes[k] = v                       
  end           
  CC1
end


function kruskal(g::Graph{T,Y}) where{T,Y}
  V_CC = all_nodes_as_CC(g)                 # récupère les CC unitaires dans un vecteur
  sorted_edges = sort(g.edges, by=weight)   # donne un vecteur des arêtes de g triées par poids
  selected_edges = Edge{T,Y}[]              # initialise un vecteur vide dans lequel on stocke les arêtes retenues                                # stocke le poids total de l'arbre de recouvrement
  for edge in sorted_edges
    noeud1, noeud2 = edge.node_1, edge.node_2
    CC1 = find_CC_where_node(V_CC,noeud1)   # CC1 contient le noeud1
    CC2 = find_CC_where_node(V_CC,noeud2)   # pareil pour 2
    if !same_CC(CC1,CC2)                    # vérifie que les 2 noeuds n'appartiennent pas à la même CC
      push!(selected_edges, edge)           # l'arête est retenue
      fusion_CC!(CC1,CC2)                   # CC2 est intégrée à CC1
      empty!(CC2)
    end
  end
  arbre = Graph{T,Y}("Kruskal de $(g.name)", nodes(g), selected_edges)
  return arbre
end