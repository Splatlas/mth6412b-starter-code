include("composanteconnexe.jl")

""" Type de composante connexe avec rang (RaCC) : 
- dictionnaire où l'ensemble des noeuds correspond à l'ensemble des clés
- rank : rang de la RoCC
"""
mutable struct RankedConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
  rank::Int
end

"""Constructeur de RaCC : 
la racine par défaut est : nothing
le rang par défaut est : 0
"""
function RankedConnectedComponent{T}(; rank::Int=0) where T
  return RankedConnectedComponent{T}(Dict{Node{T}, Node{T}}(), rank)
end

"""Permet d'ajouter un noeud à une RaCC"""
function add_node!(cc::RankedConnectedComponent{T}, node::Node{T}) where T
  cc.nodes[node] = node
end

""" Permet de définir le rang d'une RaCC"""
function set_rank!(c::RankedConnectedComponent, r::Int)
    c.rank = r
    c
end



"""Prend un graphe G et renvoie un vecteur V contenant l'ensemble des RaCC initiales (unitaires).
V contient des RoCC de taille unitaire = 1 noeud"""
function all_nodes_as_RaCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RankedConnectedComponent{T}}()
  for k in g.nodes
    RaCC = RankedConnectedComponent{T}() # seul changement avec kruskal classique : le rang des RaCC unitaires est initialisé à 0
    add_node!(RaCC,k)
    push!(V,RaCC)
  end
  return V
end



"""Prend en entrée un vecteur de RaCC et retourne celle qui contient le noeud"""
function find_RaCC_where_node(V::Vector{RankedConnectedComponent{T}},noeud::Node{T}) where{T}
  for RaCC in V
    if haskey(RaCC.nodes, noeud)
      return RaCC
    end
  end 
end
# find_RaCC_where_node ne diffère pas du kruskal de base


"""Compare deux RaCC et return True si c'est les même.
Dans ce cas de figure, deux dictionnaires sont les mêmes si ???              """
function same_RaCC(RaCC1::AbstractConnectedComponent{T},RaCC2::AbstractConnectedComponent{T}) where{T}
  if length(RaCC1.nodes) != length(RaCC2.nodes)
    return false
  else
    for noeud in keys(RaCC1.nodes)
      if !haskey(RaCC2.nodes, noeud)
        return false
      end
    end
  end
  return true
end

# Les CC créées à partir d'une fusion de CC unitaires donne des dictionnaires 
# dont seules les clés représentent les noeuds de la CC. Les valeurs ne servent à rien 
# dans cette version de kruskal
"""Fusionne la RaCC2 à la RaCC1 (hypothèse: node_1 de edge est dans RaCC1) : """
function fusion_RaCC!(RaCC1::AbstractConnectedComponent{T}, RaCC2::AbstractConnectedComponent{T}) where{T}       
  for (k,v) in RaCC2.nodes                    
    RaCC1.nodes[k] = v                       
  end           
  RaCC1
end



function heuristic_1_kruskal(g::Graph{T,Y}) where{T,Y}
  V_RaCC = all_nodes_as_RaCC(g)
  sorted_edges = sort(g.edges, by=weight)
  selected_edges = Edge{T,Y}[]
  P = 0
  for edge in sorted_edges
    noeud1, noeud2 = edge.node_1, edge.node_2
    RaCC1 = find_RaCC_where_node(V_RaCC,noeud1)
    RaCC2 = find_RaCC_where_node(V_RaCC,noeud2)
    if !same_CC(RaCC1,RaCC2)
      push!(selected_edges, edge)
      P = P + edge.weight
      if RaCC1.rank > RaCC2.rank
        fusion_CC!(RaCC1,RaCC2)
        empty!(RaCC2)
        println(RaCC1.rank)
      else
        fusion_CC!(RaCC2,RaCC1)
        empty!(RaCC1)
        if RaCC1.rank == RaCC2.rank
          set_rank!(RaCC2,RaCC2.rank+1)
        end
      end
    end
  end
  show(Graph{T,Y}("Kruskal de $(name(g)) par l'heuristique 1", nodes(g), selected_edges))
  return "le poids total est $P"
end
