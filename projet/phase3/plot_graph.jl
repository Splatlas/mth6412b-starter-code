include("../phase1/graph.jl")

"""Fonction de commodité qui lit un fichier stsp et trace le graphe."""
function plot_graph(gr::Graph)
  nodes, edges = gr.nodes, gr.edges
  fig = plot(legend=false)

  # edge positions
  for arete in edges       
    noeud1 = arete.node_1
    noeud2 = arete.node_2
    x1, y1 = noeud1.data
    x2, y2 = noeud2.data

    # Ajouter le poids de l'arête
    weight_label = string(arete.weight)
    mid_x = (x1 + x2) / 2
    mid_y = (y1 + y2) / 2
    annotate!(mid_x, mid_y, text(weight_label, :black, :center, :bottom, 6))
      
    plot!([x1, x2], [y1, y2], linewidth=1.5, alpha=0.75, color=:lightgray)
  end

  # node positions
  xys = []
  for node in nodes
    push!(xys, node.data)
      
    annotate!(node.data[1], node.data[2], text(node.name, :white, :center, :middle, 3))
  end
  
  x = [xy[1] for xy in xys]
  y = [xy[2] for xy in xys]
  scatter!(x, y)

  fig
end