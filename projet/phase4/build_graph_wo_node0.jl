include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase1/read_stsp.jl")


"""
build_graph(filename::String, graph_name::String)

    Crée un objet de type Graph [`Graph`](@ref) à partir d'un fichier .tsp

# Arguments
- `filename::String`: nom du fichier .tsp (incluant son chemin d'accès) 
- `graph_name::String`: nom donné au graph créé

# Examples
    Graphe_1 = build_graph("/Users/Desktop/test.tsp", "MonGraphe")
    Graphe_2 = build_graph("/Users/Desktop/abcd.tsp", "Graphe_abcd")
"""
function build_graph_wo_node0(filename::String, graph_name::String)
    graph_nodes, graph_edges, weights = read_stsp(filename)
    T = typeof(graph_nodes[1]); #permet d'obtenir le type T
    Y = typeof(weights[1][1]) #permet d'obtenir le type Y
    
    # On crée un graphe vide : composé d'un nom, d'un vecteur de noeuds (les noeuds sont des vecteurs de Float64 qui représentent les coordonnées dans l'espace du noeud (x,y), et d'un vecteur d'arête)
    Graphe = Graph(graph_name, Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))

    # Ajouter tous les noeuds 
    for i = 1:length(graph_nodes)
        noeud = Node(string(i), graph_nodes[i])  #graph_nodes est un dictionnaire : graph_nodes[i] renvoit le vecteur [x,y] du noeud i
        if !(noeud.data == "1")
            add_node!(Graphe,noeud)
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

