include("node.jl")
include("edge.jl")

import Base.show
import Base.copy

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14);
    node2 = Node("Steve", exp(1));
    node3 = Node("Jill", 4.12);
    G = Graph("Test", node1, node2, node3)

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T,Y} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T,Y}}
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T,Y}, node::Node{T}) where {T,Y}
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arête au graphe."""
function add_edge!(graph::Graph{T,Y}, edge::Edge{T,Y}) where {T,Y}
  push!(graph.edges, edge)
  graph
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie la liste des arêtes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges")
  for node in nodes(graph)
    show(node)
  end
  for edge in edges(graph)
    show(edge)
  end
end


"""Prend un graph et un noeud en entrée et retourne la liste des voisins de du noeud"""
function neighbors(graph::Graph, n::Node)
  voisins = Vector{Node}()
  for edge in edges(graph)
    if edge.node_1 == n
      push!(voisins,edge.node_2)
    elseif edge.node_2 == n
      push!(voisins,edge.node_1)
    end
  end
  return voisins
end

""" Prend un graph et deux noeuds en entrée, et renvoie l'arête du graph reliant ces deux noeuds"""
function find_edge(graph::Graph{T,Y}, n1::Node{T}, n2::Node{T}) where {T,Y}
  for edge in graph.edges
    if n1 == edge.node_1 && n2 == edge.node_2
      return edge
    elseif n1 == edge.node_2 && n2 == edge.node_1
      return edge
    end
  end
end


""" Renvoie le poids d'un graphe """
function graph_weight(graph::Graph{T,Y}) where {T,Y}
  P = 0
  for edge in graph.edges
    P = P + edge.weight
  end
  return P
end