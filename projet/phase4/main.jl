include("../phase1/build_graph.jl")
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase2/composanteconnexe.jl")
include("../phase2/prim.jl")
include("../phase3/RSL.jl")
include("../phase3/HK.jl")
include("../phase3/plot_graph.jl")
include("../phase4/bin/tools.jl")


tsp_name = "alaska-railroad.tsp"
filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/tsp/instances/$tsp_name.tsp"


function new_tour_weight(filename::String,indice_racine::Int64=1,algorithm::Function=RSL)
  gr = build_graph(filename,"Graphe de $tsp_name");
  if algorithm == RSL
    tour = algorithm(gr,indice_racine)
  elseif algorithm == HK
    tour = algorithm(gr)
  end
  weight = graph_weight(tour)
  return weight
  min_weight = eval(Symbol(tsp_name))
  relative_error = (weight-min_weight)/min_weight
end

"""Fonction qui prend en entrée :
- un algorithme de tournée minimale (et l'indice de la racine de départ pour kruskal) 
- le nom d'un fichier tsp
La fonction retourne : 
- le tour sous forme de vecteur contenant la data des noeuds
"""
function tour_maker(filename::String,indice_racine::Int64=1,algorithm::Function=RSL)
  gr = build_graph(filename,"Graphe de $tsp_name");
  V=[]
  if algorithm == RSL
    tour = algorithm(gr,indice_racine)
  elseif algorithm == HK
    tour = algorithm(gr)
  end
  for node in tour.nodes
    push!(V,node.data)
  end
  return V
end









