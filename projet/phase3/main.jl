include("../phase1/build_graph.jl")
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase2/composanteconnexe.jl")
include("../phase2/prim.jl")
include("../phase3/RSL.jl")
include("../phase3/HK.jl")
include("../phase3/plot_graph.jl")

a, b, c, d, e, f, g, h, i = Node("a", 1.0), Node("b", 1.0), Node("c", 1.0), Node("d", 1.0), Node("e", 1.0), Node("f", 1.0), Node("g", 1.0), Node("h", 1.0), Node("i", 1.0)
e1 = Edge(a, b, 4.)
e2 = Edge(a, h, 8.)
e3 = Edge(c, d, 7.)
e4 = Edge(d, e, 9.)
e5 = Edge(e, f, 10.)
e6 = Edge(d, f, 14.)
e7 = Edge(f, c, 4.)
e8 = Edge(f, g, 2.)
e9 = Edge(g, i, 6.)
e10 = Edge(g, h, 1.)
e11 = Edge(b, c, 8.)
e12 = Edge(h, i, 7.)
e13 = Edge(i, c, 2.)
e14 = Edge(b, h, 11.)
e15 = Edge(a, e, 12.)
e16 = Edge(i, d, 13.)
#gr = Graph("graphe du cours", [a, b, c, d, e, f, g, h, i], [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16])

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

"""Fonction qui prend un algorithme de tournée minimale en entrée et le nom d'un fichier tsp et qui affiche:
- le poids de la tournée calculée par l'algorithme
- le poids de la tournée minimale du fichier
- l'écart relatif entre la tournée minimale et la tournée calculée
"""
function phase3_one_result(tsp_name::String="dantzig42",algorithm::Function=RSL)

  filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
  gr = build_graph(filename,"Graphe de $tsp_name");


  algo = nameof(algorithm)
  tour = algorithm(gr)
  weight = graph_weight(tour)
  min_weight = eval(Symbol(tsp_name))

  relative_error = (weight-min_weight)/min_weight
  println("Le poids de $tsp_name par $algo est : $weight")
  println("Le poids minimal est $min_weight")
  println("L'erreur relative est $relative_error")
end

"""Fonction qui prend un algorithme de tournée minimale en entrée et ressort un tableau avec :
- première ligne : nom du fichier tsp
- deuxième ligne : poids de la tournée minimale du fichier
- troisième ligne : poids de la tournée calculée par l'algorithme
- quatrième ligne : l'écart relatif entre la tournée minimale et la tournée calculée
"""
function phase3_all_result(algorithm::Function=RSL)

  result = zeros(4, length(V_tsp))

  for k = 1:length(V_tsp)
    tsp_name = V_tsp[k]

    # ajout du nom des fichier à la première ligne de result
    #result[1,k] = tsp_name

    # ajout du poids minimal des fichier à la deuxième ligne de result
    min_weight = eval(Symbol(tsp_name))
    result[2,k] = min_weight

    # ajout du poids du tour des fichier à la troisième ligne de result
    filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
    gr = build_graph(filename,"Graphe de $tsp_name");
    algo = nameof(algorithm)
    tour = algorithm(gr)
    weight = graph_weight(tour)
    result[3,k] = weight
    
    # ajout de l'erreur relative du tour des fichier à la quatrième ligne de result
    relative_error = (weight-min_weight)/min_weight
    result[4,k] = relative_error
  end

  return result
  
end

#fig = plot_graph(RSL(gr))
#savefig(fig, "/Users/jules/Desktop/MTH6412B/generated_images/RSL_$tsp_name.pdf")

# tsp_name = "bayg29"
# filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
# gr = build_graph(filename,"Graphe de $tsp_name")






