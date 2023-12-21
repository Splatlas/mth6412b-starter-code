include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/build_graph.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/node.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/edge.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/graph.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase2/composanteconnexe.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase2/prim.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase3/RSL.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase3/HK.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase3/tour_weight.jl")
include("tools2.jl")
include("tools.jl")





## CRÉATION DU FICHIER .tour
tsp_name = "tokyo-skytree-aerial"
filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/tsp/instances/$tsp_name.tsp"
graphe = build_graph_wo_node0(filename,"Graphe de $tsp_name")
tour = RSL(graphe)
tour_entier = V_tour(tour)
write_tour("$tsp_name.tour", tour_entier , graph_weight(tour))

## CRÉATION DE L'IMAGE À PARTIR DU FICHIER .tour
tour_filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/$tsp_name.tour"
input_name = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/images/shuffled/$tsp_name.png";
output_name = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/images/reconstructed_by_me/$tsp_name.png"
reconstruct_picture(tour_filename,input_name,output_name)
