include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")

function onetree(g::Graph{T,Y}, algorithm::Function) where{T,Y}
    onetree = algorithm(g)
    noeud = onetree.nodes[1]
    arete_select = nothing
    min_weight = typemax(Int)
    for voisin_g in neighbors(g,noeud)
        arete_g = find_edge(g,voisin_g,noeud)               # arête candidate pour entrer dans le onetree
        (arete_g == nothing) && continue

        # On s'assure que arete_g n'est pas déjà dans le onetree
        test = true
        for voisin_onetree in neighbors(onetree,noeud)
            arete_tree = find_edge(g,voisin_onetree,noeud)
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
    