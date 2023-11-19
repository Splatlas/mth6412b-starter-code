include("../phase2/composanteconnexe.jl")

function RSL(g::Graph{T,Y}) where{T,Y}
    arbre = kruskal(g)
end
