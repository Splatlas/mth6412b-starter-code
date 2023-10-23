include("node.jl")
include("edge.jl")
include("graph.jl")

mutable struct ComposanteConnexe{T,Y} <: AbstractGraph{T}
    name::String
    nodes::Vector{Node{T}}
    edges::Vector{Edge{T,Y}}
  end


  """Ajoute un noeud à la composante connexe."""
function add_node!(graph::Graph{T,Y}, node::Node{T}) where {T,Y}
  push!(graph.nodes, node)
  graph
end