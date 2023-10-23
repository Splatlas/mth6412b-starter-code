include("node.jl")

import Base.show

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        arête_1 = Edge(Node("Kirk", 4),Node("Lars", 2), 6)
        arête_2 = Edge(Node("Pierre", 1),Node("Lars", 2), 4)
        arête_3 = Edge(Node("Kirk", 1),Node("Pierre", 2), 4)

"""
mutable struct Edge{T,Y} <: AbstractEdge{T} 
  node_1::Node{T}
  node_2::Node{T}
  weight::Y
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `name`, `weight`, `node_1` et `node_2`.

"""Renvoie les extrémités de l'arête sous forme d'un tuple de noeud."""
vertices(edge::AbstractEdge) = (edge.node_1,edge.node_2)

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche un arête."""
function show(edge::AbstractEdge)
  println("Edge : ", name(edge.node_1), " ,", name(edge.node_2), ", weight: ", weight(edge))
end
