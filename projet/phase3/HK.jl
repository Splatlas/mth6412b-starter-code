include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")

# L'idée pour le calcul du minimum_one_tree est de prendre un arbre de recouvrement d'un graph, 
# prendre un noeud quelconque de cet arbre et ajouter à l'arbre l'arête de plus petit poids 
# partant de ce noeud (n'étant pas déjà dans le graph)
# À cause de cette dernière remarque c'est peut être moins efficace que de faire un arbre de recouvrement
# de n-1 noeuds et d'y ajouter le dernier noeud et ses 2 arêtes de plus bas poids mais je m'en suis rendu
# compte seulement à la fin de mon implémentation :')) 

""" Prend en entrée un graphe complet et une fonction qui permet de calculer un arbre de recouvrement à partir du graphe pour retourner un 1-tree
"""
function minimum_one_tree(g::Graph{T,Y}, node::Node{T}, algorithm::Function) where{T,Y}
    onetree = algorithm(g)  
    arete_select = nothing
    min_weight = typemax(Int)
    for voisin_g in neighbors(g,node)
        arete_g = find_edge(g,voisin_g,node)               # Arête candidate pour entrer dans le onetree
        (arete_g == nothing) && continue

        # On s'assure que arete_g n'est pas déjà dans le onetree
        test = true
        for voisin_onetree in neighbors(onetree,node)
            arete_tree = find_edge(g,voisin_onetree,node)
            if  same_edge(arete_g, arete_tree)
                test = false
            end
        end

        # On cherche l'arête (qui n'est pas déjà dans le onetree) de plus petit poids 
        if (arete_g.weight < min_weight) && (test == true)
            arete_select = arete_g
            min_weight = arete_g.weight
        end
    end
    add_edge!(onetree,arete_select)
    return onetree
end


function euclidian_norm(V::Vector)
    S=0
    for k in V
        S = S + k^2
    end
    return sqrt(S)
end



function HK(graph::Graph{T,Y}; algorithm::Function=kruskal
                                  ,selected_node::Node = graph.nodes[1] 
                                  ,maxIter::Int = 1000
                                  ,epsilon::Real = 1e-3
                                  ) where{T,Y}

  graph_copy = deepcopy(graph)

  ### Initialisation ###
  n = length(graph_copy.nodes)
  k = 0
  pi_k = zeros(n)
  Tk = minimum_one_tree(graph_copy, selected_node, algorithm)
  weights = map(edge -> edge.weight, Tk.edges)
  @show weights
  total_weight = sum(weights)
  tk = 1

  # calcul de dk : 
  dk = []
  for noeud in Tk.nodes
    push!(dk, length(neighbors(Tk, noeud)))
  end

  # calcul de vk :
  vk = dk .- 2
  nvk = euclidian_norm(vk)

  while nvk > 0 && k < maxIter # vk tend vers 0 composante par composante, donc sa norme tend vers 0
    # On met à jour pi_k avec vk
    pi_k .= pi_k .+ tk .* vk
    
    @show vk
    # On met à jour le poids des arêtes
    for i=1:n
      current_node = graph_copy.nodes[i]
      for e in graph_copy.edges
        if (e.node_1 == current_node || e.node_2 == current_node)
          e.weight += pi_k[i]
        end
      end
    end
    
    # On cherche le 1-arbre minimal correspondant au graphe mis à jour
    Tk = minimum_one_tree(graph_copy, selected_node, algorithm)
    weights = map(edge -> edge.weight, Tk.edges)
    total_weight = sum(weights)
    k += 1
    tk = 1/k
    dk = []
    for noeud in Tk.nodes
        push!(dk, length(neighbors(Tk, noeud)))
    end
  
    # Calcul de vk pour le graphe mis à jour :
    vk = dk .- 2
    nvk = euclidian_norm(vk)    

    if k == maxIter
      println("maximum iteration criterion reached at k = $k")
    elseif nvk ≤ epsilon 
      println("algorithm converged to a optimal tour at k = $k")
    end
  end
  Tk.name = "Optimal tour"

  # Enfin, on stocke les arêtes formant la tournée (optimale ou non) dans le graphe. 
  final_edges = []
  for e_tk in Tk.edges
    for e in graph.edges
      if e_tk.node_1 == e.node_1 && e_tk.node_2 == e.node_2
        push!(final_edges, e)
      end
    end
  end
  Tk.edges = final_edges

  weights = map(edge -> edge.weight, Tk.edges)
  total_weight = sum(weights)

  return vk
end