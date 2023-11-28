### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ d9b81660-8d7e-11ee-195b-9f71a8e721d9
md""" # Rapport Phase 03
"""

# ╔═╡ 0c6eedba-b966-4fc3-8042-2726e13e5c4a
md""" #### Rèaliser par : 
Fairouz Mansouri\
Jules Caffin
"""
         

# ╔═╡ 695ba877-f40a-4fda-b1d9-75aefd1e9319
md""" #### Adresse de dépot:
https://github.com/Splatlas/mth6412b-starter-code.git
"""

# ╔═╡ 6b235fc1-1c16-42fc-a6f1-45188118540b
md"""
Le problème de tournée, aussi connu sous le nom de problème du cycle Hamiltonien, est un concept fondamental en théorie des graphes introduit par Hamilton en 1859. Il consiste à déterminer, dans un graphe non orienté, l'existence d'un cycle qui visite chaque sommet exactement une fois. Dans le cadre de la realisation de cette phase 03, nous nous focalisons sur la recherche d'une tournée minimale. Pour atteindre cet objectif, nous envisageons d'implémenter deux algorithmes spécifiques : RSL et HK.

"""

# ╔═╡ 36ad9664-d190-4e1a-81bb-773867cfa4f4
md""" #### 1. Implémentation des deux algorithmes vus au laboratoire (RSL et HK)
"""

# ╔═╡ 4f72805b-b0d5-4ef1-a07c-c9e585565097
md""" ##### 1.1 Implémentation de l’algorithme de Rosenkrantz, Stearns et Lewis (RSL)

Condition : c(u,w) ≤ c(u,v) + c(v,w).
1. Choisir un nœud qui jouera le rôle de racine ;
2. calculer un arbre de recouvrement minimal en utilisant cette racine ;
3. ordonner les sommets du graphe suivant un parcours en préordre de l’arbre de recouvrement minimal (i.e., dans l’ordre de visite);
4. cet ordre détermine une tournée dans le graphe de départ.



"""

# ╔═╡ d5dd1365-ad11-4e86-987a-d0b8e554db30
md"""
Pour mettre en œuvre RSL, il est nécessaire de définir plusieurs fonctions. Commençons par : \
La fonction Dfs récursive renvoie un vecteur avec les noeuds d’un arbre dans l’ordre d’un parcours en profondeur,Cette fonction est en deux morceaux, les deux sous fonctions servent à faire le parcours en profondeur, Pour RSL on a besoin d’un parcours en profondeur de l’arbre de recouvrement.

``` julia
# Fonction DFS récursive
function dfs!(arbre::Graph{T,Y}, current_node::Node{T}, visited::Vector{Node{T}}) where{T,Y}
    if current_node in visited
        return
    end
    push!(visited, current_node) # seule modif de la fonction : le vecteur visited en entrée est modifié
    for neighbor in neighbors(arbre, current_node)
        dfs!(arbre, neighbor, visited)
    end
end

```
"""

# ╔═╡ 6df22330-f1c4-4028-99c5-bd466d34d1b4
md"""
Ainsi définie, la fonction d'interface pour le parcours en profondeur retournera un vecteur. Ce vecteur contiendra les nœuds listés selon l'ordre de leur visite lors du parcours en profonde.

``` julia
#Fonction d'interface pour le parcours en profondeur qui retourne : un vecteur qui contient les noeuds dans l'ordre de la visite en profondeur

function depth_first_search(arbre::Graph{T,Y},indice_racine::Int64=1) where{T,Y}
    visited = Vector{Node{T}}()
    dfs!(arbre, arbre.nodes[indice_racine], visited)
    for node in arbre.nodes
        if !(node in visited)
            dfs!(arbre, node, visited)
        end
    end
    return visited
end
```
"""

# ╔═╡ 17c8f206-c5d7-4843-a34a-fe8ad0e372ea
md"""
La fonction conçue pour retourner une tournée selon l'algorithme RSL prendra en entrée les éléments suivants : \
- un graphe g \
- Une fonction qui donne un arbre de recouvrement minimal (type kruskal) \
Ainsi, notre fonction est bien documentée.

``` julia
#Fonction qui retourne une tournée selon l'algorithme RSL, prenant en entrée : un graphe gune fonction qui donne un arbre de recouvrement minimal (type kruskal)

function RSL(g::Graph{T,Y},indice_racine::Int64=1,algorithm::Function=kruskal) where{T,Y}
    tour = Graph("Tournée RSL de $(g.name)", Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))

    # Calcul du parcours en profondeur
    v_dfs = depth_first_search(algorithm(g),indice_racine)

    # ajout des noeuds de v_dfs dans le graphe '"tour" ainsi que les arêtes de g reliant ces noeuds
    for k = 1:length(v_dfs)-1
        add_node!(tour,v_dfs[k])
        arete = find_edge(g,v_dfs[k],v_dfs[k+1]) 
        add_edge!(tour,arete)
    end
    add_node!(tour,v_dfs[end])
    arete = find_edge(g,v_dfs[1],v_dfs[end])
    add_edge!(tour,arete)
    return tour
end
```
"""

# ╔═╡ d3b467d3-0eb1-477c-b262-16291791518b
md""" ##### 1.1 Implémentation de montée de Held et Karp (HK) 

Pour implémenter l'algorithme HK, nous avons identifié plusieurs méthodes essentielles.
"""

# ╔═╡ 40c813e6-ad5a-4112-b1e8-e3109b4771ef
md"""
Nous définissons la fonction minimum-one-tree qui, en prenant en entrée un graphe complet et une fonction capable de calculer un arbre de recouvrement à partir de ce graphe, retourne un 1-tree. \
\
L'idée derrière le calcul de minimum-one-tree consiste à débuter avec un arbre de recouvrement d'un graphe. On sélectionne ensuite un nœud arbitraire de cet arbre et on y ajoute l'arête la plus légère qui part de ce nœud et qui n'est pas déjà présente dans le graphe. Cette approche pourrait être moins efficace que de construire un arbre de recouvrement avec n-1 nœuds, puis d'ajouter le nœud manquant accompagné de ses deux arêtes les moins lourdes. Cette dernière méthode, qui m'est venue à l'esprit après avoir achevé mon implémentation, pourrait être une alternative plus optimale.

``` julia
# Prend en entrée un graphe complet et une fonction qui permet de calculer un arbre de recouvrement à partir du graphe pour retourner un 1-tree

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
```
"""

# ╔═╡ 8f721ab8-ef02-4103-8d2c-4b5a6701c835
md"""
Nous avons également défini la méthode euclidian_norm(V::Vector) pour le calcul de la norme euclidienne d'un vecteur. Sert à mesurer la "longueur" d'un vecteur.

``` julia
function euclidian_norm(V::Vector)
    S=0
    for k in V
        S = S + k^2
    end
    return sqrt(S)
end
```
"""

# ╔═╡ 72ee145c-99c6-4c00-a258-389d0b9805a8
md"""
Pour l'implémentation de l'algorithme HK, nous procédons à la définition de la fonction HK. Nous commençons par initialiser les paramètres. Ensuite, nous calculons dk, ce qui implique la mise à jour des poids des arêtes. Une fois cette étape accomplie, nous enregistrons les arêtes qui constituent la tournée (qu'elle soit optimale ou non) dans le graphe. Par la suite, nous calculons vk pour le graphe mis à jour, en recherchant le 1-arbre minimal correspondant à la version actualisée du graphe.\
La fonction est bien documentée.

``` julia
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
    
    # On met à jour le poids des arêtes
    for i=1:n
      current_node = graph_copy.nodes[i]
      for e in graph_copy.edges
        if (e.node_1 == current_node || e.node_2 == current_node)
          e.weight += Int(floor(pi_k[i]))
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
```

"""

# ╔═╡ 9cf83879-41e8-4f6d-a914-5f63be1cc072
md"""
##### Remarque : 
Nous sommes confrontés à un problème de non-convergence avec l'algorithme HK et, malgré nos efforts, nous ne parvenons pas à comprendre où réside exactement le problème
"""

# ╔═╡ 53028db6-c5fe-42de-bed7-60719721510f
md""" ####  4. En jouant sur ces paramètres 3.1 et 3.2 , identifier les meilleurs tournées possibles sur les problèmes du TSP symétrique; 

l’algorithme contient plusieurs paramètres : \
3.1 Kruskal vs. Prim ; \
3.2 le choix du sommet privilégié (la racine) ; \
 


"""

# ╔═╡ 79fb1747-ace0-4e44-8851-294b49327201
md"""
Le tableau ci-dessous (image de fichier excel) présente nos résultats pour les différents fichiers tsp. Il est à noté que :  \
- Lors de la construction des tsp ayant EDGE_WEIGHT_FORMAT = UPPER ROW, les poids des arêtes sont nulles donc les tournées minimales sont nulles
- Pour pa561, les différents programmes ne terminent pas de tourner
Pour les autres fichiers, seuls RSL a été utilisé, HK ne fonctionnant pas.
- Pour Kruskal, le poids a été calculé avec min_tour_weight, qui applique RSL (et donc Kruskal) en prenant chacun leur tour chaque noeud comme racine et retient le tour de plus faible poids
- Pour Prim, le poids a été calculé avec tour_weight
L’écart relatif a été calculé par rapport aux valeurs fournies sur moodle.
"""

# ╔═╡ 508102d1-28f1-4a9e-bc17-e476b5e7d32f
md""" ####  5. illustrer graphiquement les tournées identifiées et exprimer l’erreur relative avec une tournée optimale 1 pour chacun des deux algorithmes ;
"""

# ╔═╡ d94d494a-d0e4-42f9-9d48-504b3d972ddf
md"""
Pour représenter graphiquement les tournées identifiées et quantifier l'erreur relative par rapport à une tournée optimale pour chacun des deux algorithmes, nous avons développé un nouveau type, nommé "oplot_graph". Ce type nous permet de tracer les graphes efficacement. De plus, pour lire un fichier STSP et dessiner le graphe correspondant, nous avons défini une fonction pratique dédiée à cette tâche.
``` julia
#Fonction de commodité qui lit un fichier stsp et trace le graphe.
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
      
    annotate!(node.data[1], node.data[2], text(node.name, :white, :center, :middle,3))
  end
  
  x = [xy[1] for xy in xys]
  y = [xy[2] for xy in xys]
  scatter!(x, y)

  fig
end

```
"""

# ╔═╡ 1fd1f25c-decd-418d-94cb-4631715a56a6
md"""
Ici, nous fournissons un programme principal pour l'analyse et la résolution de instance sTSP. Nous débutons par l'inclusion de plusieurs modules nécessaires pour la construction et la manipulation de graphes, ainsi que pour l'implémentation d'algorithmes spécifiques tels que Prim, RSL, et HK. Nous avons défini deux fonctions principales : tour-weight pour calculer le poids d'une tournée donnée et estimer l'erreur relative par rapport à une solution optimale, et min-tour-weight pour déterminer le poids minimal d'une tournée en explorant toutes les racines possibles avec l'algorithme choisi. Enfin, une section de code, actuellement commentée, est destinée à la génération d'illustrations graphiques des tournées calculées pour des instances spécifiques de TSP, illustrant ainsi l'efficacité des algorithmes que nous utilisons.

``` julia
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

#Fonction qui prend en entrée :
#- un algorithme de tournée minimale (et l'indice de la racine de départ pour kruskal) 
#- le nom d'un fichier tsp
La fonction retourne : 
#- le poids de la tournée calculée par l'algorithme

function tour_weight(tsp_name::String="dantzig42",indice_racine::Int64=1,algorithm::Function=RSL)

  filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
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

#Fonction utilitaire pour balayer toutes les racines, etant donné que le poids de la tournée calculée peut varier en fonction du nœud choisi comme point de départ pour le parcours en profondeur, j'ai mis en place une boucle qui calcule la tournée en utilisant successivement chaque nœud comme racine. Cette approche permet de déterminer la meilleure tournée possible.

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

# tsp_name = "pa561"
# filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/$tsp_name.tsp";
# gr = build_graph(filename,"Graphe de $tsp_name");
# fig = plot_graph(RSL(gr))
# savefig(fig, "/Users/jules/Desktop/MTH6412B/generated_images/RSL_$tsp_name.pdf")


```
"""

# ╔═╡ 978af266-6542-46e8-a350-86fc54727755
md"""
Nous présentons ici une sélection d'images obtenues grâce à l'implémentation de l'algorithme RSL. Ces images illustrent les tournées calculées par l'algorithme pour différentes instances de problèmes de tournée symétrique (TSP).
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─d9b81660-8d7e-11ee-195b-9f71a8e721d9
# ╟─0c6eedba-b966-4fc3-8042-2726e13e5c4a
# ╟─695ba877-f40a-4fda-b1d9-75aefd1e9319
# ╟─6b235fc1-1c16-42fc-a6f1-45188118540b
# ╠═36ad9664-d190-4e1a-81bb-773867cfa4f4
# ╟─4f72805b-b0d5-4ef1-a07c-c9e585565097
# ╟─d5dd1365-ad11-4e86-987a-d0b8e554db30
# ╟─6df22330-f1c4-4028-99c5-bd466d34d1b4
# ╟─17c8f206-c5d7-4843-a34a-fe8ad0e372ea
# ╟─d3b467d3-0eb1-477c-b262-16291791518b
# ╟─40c813e6-ad5a-4112-b1e8-e3109b4771ef
# ╟─8f721ab8-ef02-4103-8d2c-4b5a6701c835
# ╟─72ee145c-99c6-4c00-a258-389d0b9805a8
# ╟─9cf83879-41e8-4f6d-a914-5f63be1cc072
# ╟─53028db6-c5fe-42de-bed7-60719721510f
# ╟─79fb1747-ace0-4e44-8851-294b49327201
# ╟─508102d1-28f1-4a9e-bc17-e476b5e7d32f
# ╟─d94d494a-d0e4-42f9-9d48-504b3d972ddf
# ╟─1fd1f25c-decd-418d-94cb-4631715a56a6
# ╟─978af266-6542-46e8-a350-86fc54727755
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
