include("../phase1/build_graph.jl")
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase2/composanteconnexe.jl")
include("../phase2/prim.jl")
include("../phase3/RSL.jl")
include("../phase3/HK.jl")
include("../phase3/plot_graph.jl")

bayg29 = 1610
bays29 = 2020
brazil58 = 25395
brg180 = 1950
dantzig42 = 699
fri26 = 937
gr17 = 2085
gr21 = 2707
gr24 = 1272
gr48 = 5046
gr120 = 6942
hk48 = 11461
pa561 = 2763
swiss42 = 1273
V_tsp = ["bayg29","bays29","brazil58","brg180","dantzig42","fri26","gr17","gr21","gr24","gr48","gr120","hk48","pa561","swiss42"]


"""Fonction qui prend en entrée :
- un algorithme de tournée minimale (et l'indice de la racine de départ pour kruskal) 
- un fichier tsp
La fonction retourne : 
- le poids de la tournée calculée par l'algorithme
"""
function tour_weight(filename::String,indice_racine::Int64=1,algorithm::Function=RSL)
  gr = build_graph(filename,"Graphe");
  if algorithm == RSL
    weight = graph_weight(algorithm(gr,indice_racine))
  elseif algorithm == HK
    weight = graph_weight(algorithm(gr))
  end
  return weight
end


"""Fonction qui prend en entrée :
- un algorithme de tournée minimale (et l'indice de la racine de départ pour kruskal) 
- le nom d'un fichier tsp
La fonction retourne les informations suivantes: 
- le poids de la tournée minimale
- le poids de la tournée calculée par l'algorithme
"""
function info_tour(tsp_name::String="dantzig42",indice_racine::Int64=1,algorithm:: Function=RSL)
  filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
  gr = build_graph(filename,"Graphe de $tsp_name"); 
  if algorithm == RSL
    tour = algorithm(gr,indice_racine) 
  elseif algorithm == HK
    tour = algorithm(gr)
  end
  weight = graph_weight(tour)
  min_weight = eval(Symbol(tsp_name))
  relative_error = (weight-min_weight)/min_weight
  println("tournée minimale : ",min_weight)
  println("tournée calculée : ",weight)
  println("erreur relative : ",relative_error)
end

"""Fonction utilitaire pour balayer toutes les racines
"""
function min_tour_weight(tsp_name::String="dantzig42",algorithm::Function=RSL)
  filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
  gr = build_graph(filename,"Graphe de $tsp_name");
  min_weight = typemax(Int64)
  for indice_racine in 1:length(gr.nodes)
    if algorithm == RSL
      tour = algorithm(gr,indice_racine)
    elseif algorithm == HK
      tour = algorithm(gr)
    end
    weight = graph_weight(tour)
    if weight < min_weight
      min_weight = weight
    end
  end
  return min_weight
end



## SECTION ILLUSTRATION GRAPHIQUE

# tsp_name = "test5"
# filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
# gr = build_graph(filename,"Graphe de $tsp_name");
# fig = plot_graph(HK(gr))
# savefig(fig, "/Users/jules/Desktop/MTH6412B/generated_images/RSL_$tsp_name.pdf")




