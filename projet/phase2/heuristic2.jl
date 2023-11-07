include("composanteconnexe.jl")

""" Type de composante connexe avec racine (RoCC) : 
- dictionnaire où l'ensemble des noeuds correspond à l'ensemble des clés
- root : noeud racine de la RoCC
"""
mutable struct RootedConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
  root::Node{T}
end



"""Prend un graphe G et renvoie un vecteur V contenant l'ensemble des RoCC initiales (unitaires).
V contient des RoCC de taille unitaire = 1 noeud"""
function all_nodes_as_RoCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RootedConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
    r = k       # seul changement avec kruskal classique : la racine du RoCC unitaire est le noeud lui-même
    RoCC = RootedConnectedComponent{T}(d,r)
    push!(V,RoCC)
  end
  return V
end



"""Prend en entrée un vecteur de RoCC et retourne celle qui contient le noeud"""
function find_RoCC_where_node(V::Vector{RootedConnectedComponent{T}},noeud::Node{T}) where{T}
    for RoCC in V
      if haskey(RoCC.nodes, noeud)
        return RoCC
      end
    end
end
# find_RoCC_where_node ne diffère pas du kruskal de base



"""Compare deux CC et return True si c'est les même.
Dans ce cas de figure, deux dictionnaires sont les mêmes s'ils ont la même racine"""
function same_RoCC(RoCC1::RootedConnectedComponent{T},RoCC2::RootedConnectedComponent{T}) where{T}
    if RoCC1.root == RoCC2.root
        return true
    else
        return false
    end
end
# En effet, deux RoCC sont les mêmes s'ils ont la même racine car une RoCC a pour racine un de ses noeuds. 
# Un noeud ne peut pas être dans deux RoCC différentes (car les RoCC sont détruites après fusion, 
# chaque noeud n'est présent que dans une RoCC). Ainsi, avoir la même racine signifie appartenir à la même RoCC



"""Fusionne la RoCC2 à la RoCC1 (hypothèse: node_1 de edge est dans RoCC1)"""
function fusion_RoCC!(RoCC1::RootedConnectedComponent{T}, RoCC2::RootedConnectedComponent{T}) where{T}
    for (k,v) in RoCC2.nodes                    
        RoCC1.nodes[k] = v                       
    end                  # comme vu dans le commentaire de same_RoCC, il suffit que la racine soit un noeud quelconque de la RoCC      
    RoCC1                # arbitrairement, on conserve la racine de RoCC1
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
        fusion_RoCC!(RoCC1,RoCC2)
        empty!(RoCC2)
      end
    end
    result = Graph{T,Y}("Kruskal de $(g.name) par l'heuristique 2", nodes(g), selected_edges)
    show(result)
    return "Le poids total est $P"
  end
  # L'algorithme est inchangé, c'est les fonctions fusion_RoCC! et same_RoCC qui diffèrent