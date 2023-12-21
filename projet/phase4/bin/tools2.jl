include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/node.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/edge.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/graph.jl")
include("/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase1/read_stsp.jl")


"""
Duplicata de build_graph de la phase 1, mais supprime le noeud zéro au moment de la création
"""
function build_graph_wo_node0(filename::String, graph_name::String)
    @time begin
    graph_nodes, graph_edges, weights = read_stsp(filename)
    end
    T = typeof(graph_nodes[1]); #permet d'obtenir le type T
    Y = typeof(weights[1][1]) #permet d'obtenir le type Y
    
    # On crée un graphe vide : composé d'un nom, d'un vecteur de noeuds (les noeuds sont des vecteurs de Float64 qui représentent les coordonnées dans l'espace du noeud (x,y), et d'un vecteur d'arête)
    Graphe = Graph(graph_name, Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))
    # Ajouter tous les noeuds 
    for i = 1:length(graph_nodes)
        noeud = Node(string(i), graph_nodes[i])  #graph_nodes est un dictionnaire : graph_nodes[i] renvoit le vecteur [x,y] du noeud i
        if !(noeud.data == "1")
            add_node!(Graphe,noeud)
        elseif noeud.data == "602"
            @show noeud.data
        end
    end

    nodes = Graphe.nodes

    
    
    for i = 1:length(graph_edges)
        for j = 1:length(graph_edges[i])
            noeud_depart = nodes[findfirst(node -> node.name == string(i), nodes)]
            noeud_arrivee = nodes[findfirst(node -> node.name == string(graph_edges[i][j]), nodes)] # graph_edges[i][j] = Int64 est le j-eme noeud auquel le noeud i est lié => on cherche dans le dictionnaire graphe_nodes le noeud numero graph_edges[i][j]
            weight = weights[graph_edges[i][j],i] # on cherche donc le poids associée à l'arête reliant le noeud "i" et le noeud "graph_edges[i][j]"
            arete = Edge(noeud_depart,noeud_arrivee,weight) # on construit l'arête
            if arete.weight > 0
                add_edge!(Graphe,arete) # on l'ajoute au graphe
            end
        end
    end
    return Graphe
end


""" Prend un tour au format Graph et retourne la liste de noeuds du tour au format Array{Int65}"""
function V_tour(tour::Graph)
    V=Int64[]
    for node in tour.nodes
      num = parse(Int64,node.name)
      push!(V,num)
    end
    return V
end