include("composanteconnexe.jl")

"""Type de composante connexe : dictionnaire de couple (clef,valeur) =  (noeud, parent) avec le rang de la composante"""
mutable struct RankedConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
  rank::Int
end


function set_rank!(c::RankedConnectedComponent, r::Int)
    c.rank = r
    c
end

"""Prend en entrée un vecteur de composantes connexes avec rang et retourne celle qui contient le noeud"""
function find_RaCC_where_node(V::Vector{RankedConnectedComponent{T}},noeud::Node{T}) where{T}
    for RaCC in V
      if haskey(RaCC.nodes, noeud)
        return RaCC
      end
    end
  end

"""Prend un graphe G et renvoie un vecteur V contenant l'ensemble des composantes connexes initiales (ie l'ensemble des noeuds)"""
function all_nodes_as_RaCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RankedConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
    RaCC = RankedConnectedComponent{T}(d,0)
    push!(V,RaCC)
  end
  return V
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
        fusion_CC!(RaCC1,RaCC2,edge)
        empty!(RaCC2)
        println(RaCC1.rank)
      else
        fusion_CC!(RaCC2,RaCC1,edge)
        if RaCC1.rank == RaCC2.rank
          set_rank!(RaCC2,RaCC2.rank+1)
          empty!(RaCC1)
          println(RaCC2.rank)
        end
      end
    end
  end
  show(Graph{T,Y}("Kruskal de $(name(g))", nodes(g), selected_edges))
  return "le poids total est $P"
end
