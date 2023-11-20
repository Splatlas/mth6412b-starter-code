include("../phase2/composanteconnexe.jl")

function parcours_preordre(g::Graph{T,Y}) #quand je parcours un noeud je parcours ensuite ses enfant
    node_list = Node{T}[]
    visited_list = Node{T}[]
    
     
    parcours_preordre(left(tree)) 
    parcours_preordre(right(tree))
end


function RSL(g::Graph{T,Y}) where{T,Y}
    arbre = kruskal(g)
    selected_edges = Edge{T,Y}[]
    tour = 


    tour = Graph{T,Y}("Tournée de $(g.name)", nodes(g), selected_edges)
end
