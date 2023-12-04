include("../phase1/build_graph.jl")
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase2/composanteconnexe.jl")
include("../phase2/prim.jl")
include("../phase3/RSL.jl")
include("../phase3/HK.jl")
include("../phase3/tour_weight.jl")
include("build_graph_wo_node0.jl")
include("bin/tools.jl")
#include("../phase4/bin/tools.jl")


tsp_name = "alaska-railroad"
filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/tsp/instances/$tsp_name.tsp"
#gr = build_graph_wo_node0(filename,"Graphe de $tsp_name")


chemin = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/tsp/test"


function tour_int(tour::Graph)
  V=[]
  for node in tour.node
    num = parse(node.data,Int)
    push!(V,num)
  end
  return V
end


tour = RSL(gr)
#write_tour(chemin, tour_int(tour), graph_weight(tour))
