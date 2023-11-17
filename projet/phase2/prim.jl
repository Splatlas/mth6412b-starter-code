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
            prio = item.priority
            selected_edge = nothing
            for node in arbre.nodes
                edge = find_edge(g,node,item.data[1]) 
                if !(edge == nothing) && edge.weight < prio
                    prio = convert(Int, edge.weight)
                    selected_edge = edge
                end
            end
            priority!(item,prio)
            @show typeof(item.data[2])
            @show typeof(selected_edge)
            item.data[2] = selected_edge
        end
    end
    show(arbre)
end