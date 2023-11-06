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

"""Prend en entrée un vecteur de composantes connexes et retourne celle qui contient le noeud"""
function find_RCC_with_node(V::Vector{RankedConnectedComponent{T}},noeud::Node{T}) where{T}
    for RCC in V
      if haskey(RCC.nodes, noeud)
        return RCC
      end
    end
  end

  """Prend un graphe G et renvoie un vecteur V contenant l'ensemble des composantes connexes initiales (ie l'ensemble des noeuds)"""
function all_nodes_as_RCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RankedConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
    RCC = RankedConnectedComponent{T}(d,0)
    push!(V,RCC)
  end
  return V
end

function heuristic_1_kruskal(g::Graph{T,Y}) where{T,Y}
    V_RCC = all_nodes_as_RCC(g)
    sorted_edges = sort(edges(g), by=weight)
    selected_edges = Edge{T,Y}[]
    for edge in sorted_edges
      noeud1, noeud2 = edge.node_1, edge.node_2
      RCC1 = find_RCC_with_node(V_RCC,noeud1)
      RCC2 = find_RCC_with_node(V_RCC,noeud2)
      if !same_CC(RCC1,RCC2)
        push!(selected_edges, edge)
        if RCC1.rank > RCC2.rank
            fusion_CC!(RCC1,RCC2,edge)
            empty!(CC2)
        else
            fusion_CC!(RCC2,RCC1,edge)
            if RCC1.rank == RRC2.rank
                set_rank!(RCC2,RCC2.rank+1)
            empty!(RCC1)
            end
        end
      end
    end
    return Graph{T,Y}("Kruskal de $(name(g))", nodes(g), selected_edges)
  end