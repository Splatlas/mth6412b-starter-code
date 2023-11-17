include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("priority_queue.jl")

function prim(g::Graph{T,Y},s::Node{T}) where{T,Y}
    
    pile = PriorityQueue{PriorityItem}()
    arbre = Graph("Arbre de recouvrement Prim", Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))
    add_node!(arbre,s)

    #Initialisation : remplissage de la pile
    for noeud in g.nodes
        if noeud == s
            continue
        elseif noeud in neighbors(g,s)
            edge = find_edge(g, s, noeud)
            item = PriorityItem(convert(Int, edge.weight), [noeud,edge])
            push!(pile, item)
        else
            item = PriorityItem(typemax(Int64), [noeud,nothing])
            push!(pile, item)
        end
    end
    #@show pile
    
    #Hérédité : on dépile l'élément de plus bas poids et on modifie les min_weight des éléments de la pile
    while length(pile) > 0

        #Dépilage et remplissage de arbre
        lowest = poplast!(pile)
        @show lowest
        add_node!(arbre,lowest.data[1])
        add_edge!(arbre,lowest.data[2])

        #modification des min_weight et des arêtes sélectionnées de la pile
        for item in pile
            prio = item.priority        # variable qui va servir à stocker la meilleure prio
            selected_edge = nothing     # variable qui va servir à stocker la meilleure arête
            for node in arbre.nodes     # pour chaque noeud = item.data[1] dans la file, on regarde s'il a une arête avec les noeuds de l'arbre
                edge = find_edge(g,node,item.data[1]) # on trouve cette arête (potentiellement nothing)
                if !(edge == nothing) && edge.weight < prio
                    prio = convert(Int, edge.weight)
                    selected_edge = edge
                end
            end
            priority!(item,prio)            # pour l'item, on a sa nouvelle priorité
            item.data[2] = selected_edge    # pour l'item, on a sa nouvelle meilleure arête
        end
    end
    show(arbre)
end