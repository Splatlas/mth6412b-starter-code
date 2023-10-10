### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 63a1cc90-6593-11ee-05e2-55ae95d7223d
md"""
# Rapport phase 1
#### 2/ Introduction d'un type "Edge" pour représenter les arêtes dans un graphe.
"""

# ╔═╡ 44bf57d9-6e66-4f1c-8bcf-e7313b31cdd8
md"""Nous avons introduit un nouveau type, Type abstrait Edge  à partir duquel d'autres types d'arêtes peuvent être dérivés. ce type utilise le type "Node" pour exécuter des instructions spécifiques au type "Edge"."""

# ╔═╡ 4e4a3de2-add6-4288-bd2f-1758840dae42
md""" 
```julia
abstract type AbstractNode{T} end
```
"""

# ╔═╡ de0dd326-912e-4175-a40c-41c8e7c5f7be
md"""
Nous partons du principe que toutes les arêtes qui héritent de l'abstraction "AbstractEdge" auront des champs telles que "name", "weight", "node 1" et "node 2". \
\
Type représantant les arêtes  d'un graphe """

# ╔═╡ 8b3fe176-9fbd-4bdf-b5ed-81945c083d68
md""" 
```julia
mutable struct Edge{T} <: AbstractEdge{T} 
  weight::Int64
  node_1::Node{T}
  node_2::Node{T}
end
```
"""

# ╔═╡ 5fadec34-f20c-4174-831b-5e1d82b79a5a
md"""  ###### Renvoie les extrémités de l'arête sous forme ****."""

# ╔═╡ a8b659da-d9ac-40ad-a5cd-c593d122d38f
md""" 
```julia
ends(edge::AbstractEdge) = (edge.node_1,edge.node_2)
```
"""

# ╔═╡ bb292018-8ec3-4b29-bbd2-49f5dc02c875
md"""  ###### Renvoie le poid de l'arête."""

# ╔═╡ 8bd97763-bca3-48b1-a248-c57b04523650
md""" 
```julia
weight(edge::AbstractEdge) = edge.weight
```
"""

# ╔═╡ f952f4d6-2fbf-4a4e-b89f-cb5b67453a8d
md"""  ###### Une fonction qui permet d'Afficher une arête."""

# ╔═╡ 3afc5bae-37c4-4a8d-aa4d-2821ffabc6cd

md""" 
```julia
function show(edge::AbstractEdge)
println("Edge ", name(edge(node_1)), name(edge(node_2)), ", weight: ", weight(edge))
end
```
"""

# ╔═╡ 052987bd-3cb4-4312-8257-6ac0b2eec275
md""" #### 3/ Étendre le type "Graph" pour inclure les arêtes, en se limitant aux graphes non orientés. Permettre l'ajout d'une arête à la fois."""

# ╔═╡ 6445221f-a150-46b7-9239-2200101bd97b
md"""Dans le fichier graph.jl, nous avons inclus une nouvelle fonction qui permet d'ajouter des arêtes à un graphe. Cette fonction donne à l'utilisateur la possibilité d'ajouter une arête à la fois au graphe. \
Pour rendre cela possible, nous avons également ajouté le champ edges::Vector{Edge{T}} à la structure mutable Graph{T}."""

# ╔═╡ e70700fb-53a7-4494-92da-d02f74442980
md""" 
```julia
function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
  push!(graph.edges, edge)
  graph
end
```
"""

# ╔═╡ 84c927a1-11b2-4a18-a8a3-f0396353c787
md""" Ensuite, nous avons introduit deux nouvelles structures : l'une permettant de retourner la liste des arêtes du graphe, et l'autre permettant de retourner le nombre total d'arêtes présentes dans le graphe. Ces structures sont décrites en détail ci-dessous :"""

# ╔═╡ 34d289d0-ce1e-4d6c-ba91-93ca4f1abbcd
md""" 
```julia
#Renvoie la liste des arêtes du graphe.
edges(graph::AbstractGraph) = graph.edges

#Renvoie le nombre de arêtes du graphe.
nb_edges(graph::AbstractGraph) = length(graph.edges)

```
"""

# ╔═╡ 0a5e5e0b-e8a8-400b-8aad-f344b6019a94
md""" ####  4/ Étendre la méthode d’affichage show d’un objet de type Graph afin que les arêtes du graphe soient également affichées """

# ╔═╡ 15bb637c-b2ec-477d-a8dc-1ef55344ba25
md""" Pour afficher un graphe avec ses arêtes, nous avons incorporé cette structure dans la fonction "function show(graph::Graph) "qui permet d'afficher le graphe."""

# ╔═╡ 4742acc0-30bf-4383-b8c6-5c8fc648c3dd
md""" 
```julia
println(".....and",nb_edges(graph), " edges")
for edge in edges(graph)
    show(edge)
  end
```
"""

# ╔═╡ 2d62d600-99ad-4883-8bf7-1cc316be7784
md""" ###### La fonction destinée à l'affichage complet d'un graphe, incluant à la fois ses nœuds et ses arêtes, est la suivante :"""

# ╔═╡ a2196b92-c7e2-44bd-9ba0-01edef9eade4
md"""
```julia
#Affiche un graphe avec ses nœuds et ses arêtes 
function show(graph::Graph)
println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and", nb_edges(graph), " edges")
  for node in nodes(graph)
    show(node)
  end
  for edge in edges(graph)
    show(edge)
  end
end
```
"""

# ╔═╡ f827e6ba-177a-4adc-b384-1d6697a4e8fa
md""" #### 5/ Étendre la fonction read_edges() de read_stsp.jl afin de lire les poids des arêtes."""

# ╔═╡ 93a68af8-ed78-4d5a-a0ce-feed6c7491c8
md""" Initialement, nous avions proposé de modifier « read_edges » de la sorte : 
Comme le type Edge que nous avions modifié prend désormais un troisième argument, nous avions simplement rajouté au début de la boucle for la variable weight qui permet de récupérer le poids à l’intérieur de la variable data.
```julia 
for j = start : start + n_on_this_line - 1 
weight = parse(Int64, data[j + 1]) 
```
Puis dans chacun des cas du « if » détaillant les formats de la matrice d’arête, nous rajoutions « weight » en troisième argument du tuple « edge ».
« read_edges » retourne un vecteur « edges » de tuples correspondant aux noeuds, read_edges aurait désormais retourné une vecteur d’arêtes contenant le poids, nous avions répondu à la question.
Cette façon de faire n’était cependant pas adaptée à la suite des questions : la fonction « read_stsp » converti ce vecteur « edges » en le vecteur de vecteur « graph_edges » qui représente les arêtes de la manière suivante : la i-ème ligne contient tous les numéros de noeuds auxquels le i-ème noeud est lié. Ainsi, i correspond au numéro du noeud de départ de l’arête, et la valeur contenu dans graph_edges[i][j] donne le numéro du noeud d’arrivé.\
Nous comprenons donc que cette structure de « graph_edges » permet de représenter les arêtes mais ne permet pas d’y stocker les poids.
Nous avons donc agi de la sorte : dans « read_edges » nous avons créé une matrice « weights » qui reprend tous les poids des arêtes comme présenté dans le fichier .tsp (on convertit simplement cette chaine de caractère en matrice). « read_edges » retourne donc le tuple (« graph_edges »,  « weights »), ce qui sera utile pour la question 6 """

# ╔═╡ 37b985cf-4512-43aa-9d9c-2b63c88b6aa7
md""" #### 6/ Fournir un programme principal qui lit une instance de TSP symétrique dont les poids sont donnés au format EXPLICIT et construit un objet de type Graph correspondant."""

# ╔═╡ 33109ab6-0d4c-448d-bcb2-75c25e378f7d
md"""Nous avons donc ensuite modifié la fonction « read_stsp » pour qu’elle retourne aussi la matrice des poids « weights » en plus de son dictionnaire noeuds « graph_nodes » et du vecteur de vecteur « graph_edges ».\
« read_stsp » prend en entrée un fichier .tsp et retourne désormais les 3 composantes dont nous avons besoin pour créer un objet de type Graph.\
Nous avons créé la fonction « build_graph » qui prend en entrée le fichier .tsp et le nom du graphe a lui associer. Nous créons d’abord un objet de type Graph vide, que nous allons remplir au fur et à mesure :
- Le nom : on reprend le nom donné en entrée de la fonction.\
- Le vecteur de noeuds : on parcourt le dictionnaire de noeud «graph_nodes » renvoyé par « read_stsp » et on les insère un par un dans le vecteur de noeud.\
- Le vecteur d’arête : on va parcourir «graph_edges » renvoyé par « read_stsp ». Pour le i-eme noeud de départ, on lui associe son graph_edges[i][j]-ème noeud d’arrivé, et l’on crée une arête de poids « weights[i][graph_edges[i][j]] ». On insère cette arête dans le vecteur d’arête.\
Le l’objet de type Graph est ainsi retourné."""

# ╔═╡ ea326b3f-7bab-4e5a-af18-037bc3db4f42
md""" 
```julia 
include("node.jl") 
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

build_graph(filename::String, graph_name::String)

    Crée un objet de type Graph [`Graph`](@ref) à partir d'un fichier .tsp

# Arguments
- `filename::String`: nom du fichier .tsp (incluant son chemin d'accès) 
- `graph_name::String`: nom donné au graph créé

# Examples
    Graphe_1 = build_graph("/Users/Desktop/test.tsp", "MonGraphe")
    Graphe_2 = build_graph("/Users/Desktop/abcd.tsp", "Graphe_abcd")
function build_graph(filename::String, graph_name::String)
    graph_nodes, graph_edges, weights = read_stsp(filename)
    
    # On crée un graphe vide : composé d'un nom, d'un vecteur de noeuds (les noeuds sont des vecteurs de Float64 qui représentent les coordonnées dans l'espace du noeud (x,y), et d'un vecteur d'arête)
    Graphe = Graph(graph_name, Vector{Node{Vector{Float64}}}([]), Vector{Edge{Vector{Float64}}}([]))

    # Ajouter tous les noeuds 
    for i = 1:length(graph_nodes)
        noeud = Node(string(i), graph_nodes[i])  #graph_nodes est un dictionnaire : graph_nodes[i] renvoit le vecteur [x,y] du noeud i
        add_node!(Graphe,noeud)
    end

    # ajouter toutes les arêtes
    for i = 1:length(graph_edges)
        for j = 1:length(graph_edges[i])
            noeud_depart = Node(string(i), graph_nodes[i]) 
            noeud_arrivee = Node(string(graph_edges[i][j]), graph_nodes[graph_edges[i][j]]) #graph_edges[i][j] = Int64 est le j-eme noeud auquel le noeud i est lié => on cherche dans le dictionnaire graphe_nodes le noeud numero graph_edges[i][j]
            weight = weights[i][graph_edges[i][j]] # on cherche donc le poids associée à l'arête reliant le noeud "i" et le noeud "graph_edges[i][j]"
            arete = Edge(noeud_depart,noeud_arrivee,weight) # on construit l'arête
            add_edge!(Graphe,arete) # on l'ajoute au graphe
        end
    end
    return Graphe
end


## Commandes à ne pas prendre en compte, elles servaient à tester le code

#filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/test.tsp"
#Graphe_test = build_graph(filename,"Graphe_test") 
```

"""

# ╔═╡ c8b402fb-72eb-410a-b416-6c2d773267ff
md""" ###### Test 
 On a créé un fichier contenant une matrice symétrique à 5 noeuds pour pouvoir constater manuellement que le graph renvoyait bien le poids de chaque arête."""

# ╔═╡ 48a334f0-790b-4fe9-bf93-8a4e9dbf1c1c
md"""
```julia 
NAME: 
TYPE: TSP
COMMENT: 5 cities in Bavaria, street distances (Groetschel,Juenger,Reinelt)
DIMENSION: 5
EDGE_WEIGHT_TYPE: EXPLICIT
EDGE_WEIGHT_FORMAT: FULL_MATRIX 
DISPLAY_DATA_TYPE: TWOD_DISPLAY
EDGE_WEIGHT_SECTION
   0 107 241 190 124
 107   0 148 137  88
 241 148   0 374 171
 190 137 374   0 202
 124  88 171 202   0
DISPLAY_DATA_SECTION
   1    1150.0  1760.0
   2     630.0  1660.0
   3      40.0  2090.0
   4     750.0  1100.0
   5     750.0  2030.0
EOF
```
"""

# ╔═╡ ff98faac-2fb8-4c2f-869c-b81b15f450e7
md"""Voici le résultat renvoyé par la fonction "build_graph" appliqué au fichier test.tsp . On remarque que le graph est constuit efficacement et que les arêtes et leurs poids concordent"""

# ╔═╡ a12f4131-8b53-4dfa-b746-6d42d4923bbd
md"""
```julia 

Graph{Vector{Float64}}(
    "Graphe_test", 
    Node{Vector{Float64}}[
        Node{Vector{Float64}}("1", [1150.0, 1760.0]), 
        Node{Vector{Float64}}("2", [630.0, 1660.0]), 
        Node{Vector{Float64}}("3", [40.0, 2090.0]), 
        Node{Vector{Float64}}("4", [750.0, 1100.0]), 
        Node{Vector{Float64}}("5", [750.0, 2030.0])], 
    Edge{Vector{Float64}}[
        Edge{Vector{Float64}}(Node{Vector{Float64}}("1", [1150.0, 1760.0]), Node{Vector{Float64}}("1", [1150.0, 1760.0]), 0), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("1", [1150.0, 1760.0]), Node{Vector{Float64}}("2", [630.0, 1660.0]), 107), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("1", [1150.0, 1760.0]), Node{Vector{Float64}}("3", [40.0, 2090.0]), 241), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("1", [1150.0, 1760.0]), Node{Vector{Float64}}("4", [750.0, 1100.0]), 190), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("1", [1150.0, 1760.0]), Node{Vector{Float64}}("5", [750.0, 2030.0]), 124), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("2", [630.0, 1660.0]), Node{Vector{Float64}}("1", [1150.0, 1760.0]), 107), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("2", [630.0, 1660.0]), Node{Vector{Float64}}("2", [630.0, 1660.0]), 0), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("2", [630.0, 1660.0]), Node{Vector{Float64}}("3", [40.0, 2090.0]), 148), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("2", [630.0, 1660.0]), Node{Vector{Float64}}("4", [750.0, 1100.0]), 137), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("2", [630.0, 1660.0]), Node{Vector{Float64}}("5", [750.0, 2030.0]), 88)  …  
        Edge{Vector{Float64}}(Node{Vector{Float64}}("4", [750.0, 1100.0]), Node{Vector{Float64}}("1", [1150.0, 1760.0]), 190), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("4", [750.0, 1100.0]), Node{Vector{Float64}}("2", [630.0, 1660.0]), 137), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("4", [750.0, 1100.0]), Node{Vector{Float64}}("3", [40.0, 2090.0]), 374), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("4", [750.0, 1100.0]), Node{Vector{Float64}}("4", [750.0, 1100.0]), 0), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("4", [750.0, 1100.0]), Node{Vector{Float64}}("5", [750.0, 2030.0]), 202), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("5", [750.0, 2030.0]), Node{Vector{Float64}}("1", [1150.0, 1760.0]), 124), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("5", [750.0, 2030.0]), Node{Vector{Float64}}("2", [630.0, 1660.0]), 88), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("5", [750.0, 2030.0]), Node{Vector{Float64}}("3", [40.0, 2090.0]), 171), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("5", [750.0, 2030.0]), Node{Vector{Float64}}("4", [750.0, 1100.0]), 202), 
        Edge{Vector{Float64}}(Node{Vector{Float64}}("5", [750.0, 2030.0]), Node{Vector{Float64}}("5", [750.0, 2030.0]), 0)])
```
"""

# ╔═╡ 51baf06b-2058-4e7b-8477-76e90ebc9f4d
md""" ##### Remarques"""

# ╔═╡ 17730ffa-c72b-4d92-bd8d-bf7c9e04f9ad
md""" Pour lancer le programme: 

- Se placer dans le dossier projet/phase
- lancer julia main.jl "Nom de l'instance"tsp; exemple: julia main.jl bays29.tsp\
L'adresse de dépot est : https://github.com/Splatlas/mth6412b-starter-code.git """


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─63a1cc90-6593-11ee-05e2-55ae95d7223d
# ╟─44bf57d9-6e66-4f1c-8bcf-e7313b31cdd8
# ╟─4e4a3de2-add6-4288-bd2f-1758840dae42
# ╟─de0dd326-912e-4175-a40c-41c8e7c5f7be
# ╟─8b3fe176-9fbd-4bdf-b5ed-81945c083d68
# ╟─5fadec34-f20c-4174-831b-5e1d82b79a5a
# ╟─a8b659da-d9ac-40ad-a5cd-c593d122d38f
# ╟─bb292018-8ec3-4b29-bbd2-49f5dc02c875
# ╟─8bd97763-bca3-48b1-a248-c57b04523650
# ╟─f952f4d6-2fbf-4a4e-b89f-cb5b67453a8d
# ╟─3afc5bae-37c4-4a8d-aa4d-2821ffabc6cd
# ╟─052987bd-3cb4-4312-8257-6ac0b2eec275
# ╟─6445221f-a150-46b7-9239-2200101bd97b
# ╟─e70700fb-53a7-4494-92da-d02f74442980
# ╟─84c927a1-11b2-4a18-a8a3-f0396353c787
# ╟─34d289d0-ce1e-4d6c-ba91-93ca4f1abbcd
# ╟─0a5e5e0b-e8a8-400b-8aad-f344b6019a94
# ╟─15bb637c-b2ec-477d-a8dc-1ef55344ba25
# ╠═4742acc0-30bf-4383-b8c6-5c8fc648c3dd
# ╟─2d62d600-99ad-4883-8bf7-1cc316be7784
# ╟─a2196b92-c7e2-44bd-9ba0-01edef9eade4
# ╟─f827e6ba-177a-4adc-b384-1d6697a4e8fa
# ╟─93a68af8-ed78-4d5a-a0ce-feed6c7491c8
# ╟─37b985cf-4512-43aa-9d9c-2b63c88b6aa7
# ╟─33109ab6-0d4c-448d-bcb2-75c25e378f7d
# ╟─ea326b3f-7bab-4e5a-af18-037bc3db4f42
# ╟─c8b402fb-72eb-410a-b416-6c2d773267ff
# ╟─48a334f0-790b-4fe9-bf93-8a4e9dbf1c1c
# ╟─ff98faac-2fb8-4c2f-869c-b81b15f450e7
# ╟─a12f4131-8b53-4dfa-b746-6d42d4923bbd
# ╟─51baf06b-2058-4e7b-8477-76e90ebc9f4d
# ╟─17730ffa-c72b-4d92-bd8d-bf7c9e04f9ad
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
