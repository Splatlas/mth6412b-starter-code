include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")


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

"""Fonction d'interface pour le parcours en profondeur qui retourne :
 - un vecteur qui contient les noeuds dans l'ordre de la visite en profondeur
"""
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

"""Fonction qui retourne une tournée selon l'algorithme RSL, prenant en entrée :
- un graphe g
- une fonction qui donne un arbre de recouvrement minimal (type kruskal)
"""
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