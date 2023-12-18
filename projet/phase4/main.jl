include("../phase1/build_graph.jl")
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase2/composanteconnexe.jl")
include("../phase2/prim.jl")
include("../phase3/RSL.jl")
include("../phase3/HK.jl")
include("../phase3/tour_weight.jl")
include("tools2.jl")
include("bin/tools.jl")




## CRÉATION DU FICHIER .tour
tsp_name = "blue-hour-paris"
filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/tsp/instances/$tsp_name.tsp"
graphe = build_graph_wo_node0(filename,"Graphe de $tsp_name")
tour = RSL(graphe)
tour_entier = V_tour(tour)
write_tour("test.tour", tour_entier , graph_weight(tour))

## CRÉATION DE L'IMAGE À PARTIR DU FICHIER .tour
# tour_filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/test.tour"
# tour_filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/tsp/tours/blue-hour-paris.tour";
# input_name = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/images/shuffled/blue-hour-paris.png";
# output_name = "test"
# reconstruct_picture(tour_filename,input_name,output_name)
