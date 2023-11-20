include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("priority_queue.jl")

function prim(g::Graph{T,Y}) where{T,Y}
    s = g.nodes[1] #,s::Node{T}
    pile = PriorityQueue{PriorityItem}()
    arbre = Graph("Arbre de recouvrement Prim", Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))
    add_node!(arbre,s)

    #Initialisation : remplissage de la pile
    for noeud in g.nodes
        if noeud == s
            continue
        elseif noeud in neighbors(g,s)
            edge = find_edge(g, s, noeud)
            item = PriorityItem(convert(Int, edge.weight), Union{Node{T},Edge{T,Y},Nothing}[noeud,edge])
            push!(pile, item)
        else
            item = PriorityItem(typemax(Int64), Union{Node{T},Edge{T,Y},Nothing}[noeud,nothing])
            push!(pile, item)
        end
    end
    #@show pile
    
    # Hérédité : on dépile l'élément de plus bas poids et on modifie les min_weight des éléments de la pile 
    # Amélioration : on modifie que les voisins du dernier dépilé
    while length(pile) > 0

        # Dépilage et remplissage de arbre
        lowest = poplast!(pile)
        add_node!(arbre,lowest.data[1])
        add_edge!(arbre,lowest.data[2])

        # Modification des min_weight et des arêtes sélectionnées de la pile
        for item in pile
            prio = item.priority        
            selected_edge = nothing     
            for node in arbre.nodes     # pour chaque noeud = item.data[1] dans la file, on regarde s'il a une arête avec les noeuds de l'arbre
                edge = find_edge(g,node,item.data[1]) # on trouve cette arête (potentiellement nothing)
                if !(edge == nothing)
                    selected_edge = edge
                    if edge.weight < prio
                        prio = convert(Int, edge.weight)
                        priority!(item,prio)
                        item.data[2] = selected_edge
                    end
                end
            end
        end
    end
    return arbre
end