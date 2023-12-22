### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ ab330d6c-a049-11ee-2479-4d4a4962f84a
md""" # Rapport Phase 04
"""

# ╔═╡ ced2c10e-5ba8-43b2-bcc5-459250c506f4
md""" #### Rèaliser par : 
Fairouz Mansouri\
Jules Caffin
"""

# ╔═╡ f1fc5e56-95a4-4d18-a7e8-f2a7107efc66
md""" #### Adresse de dépot:
https://github.com/Splatlas/mth6412b-starter-code.git
"""

# ╔═╡ 02853b60-9321-4c24-871a-a773e243b3af
md""" #### 1. Création de fonctions annexes """

# ╔═╡ f117742f-b21c-4983-bc0e-0658b3332e48
md"""
Le fichier tools.jl nous fournissait quasiment toutes les fonctions nécessaires à la phase 4 : write\_tour permet à partir d'un vecteur contenant les noeuds d'un tour d'écrire un fichier .tour, et la fonction reconstruct\_picture permet à partir d'un fichier .tour de reconstruire l'image correspondant au tour.
"""

# ╔═╡ 85c9da62-8a80-4465-8725-67fd3aae7fc9
md"""
Nous avons donc simplement utilisés les fonctions suivantes : 
"""

# ╔═╡ 903a13e5-2c81-42ad-a219-ad51b720458e
md"""
``` julia
function build_graph_wo_node0(filename::String, graph_name::String)
    @time begin
    graph_nodes, graph_edges, weights = read_stsp(filename)
    end
    T = typeof(graph_nodes[1]); #permet d'obtenir le type T
    Y = typeof(weights[1][1]) #permet d'obtenir le type Y
    
    Graphe = Graph(graph_name, Vector{Node{T}}([]), Vector{Edge{T,Y}}([]))

    for i = 1:length(graph_nodes)
        noeud = Node(string(i), graph_nodes[i])  
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
            noeud_arrivee = nodes[findfirst(node -> node.name == string(graph_edges[i][j]), nodes)]
            weight = weights[graph_edges[i][j],i] 
            arete = Edge(noeud_depart,noeud_arrivee,weight) # on construit l'arête
            if arete.weight > 0
                add_edge!(Graphe,arete) # on l'ajoute au graphe
            end
        end
    end
    return Graphe
end
```
"""

# ╔═╡ 161c7226-b713-4897-8df3-c657287f15d3
md"""
La fonction build\_graph\_wo\_node0 est une reproduction exacte de la fonction build\_graph de la phase 1, et n'en diffère uniquement pour ne pas inclure le noeud zéro.
"""

# ╔═╡ 22feaaa0-4163-4fb6-aa94-5f9c4cd6bd6a
md"""
``` julia
function V_tour(tour::Graph)
    V=Int64[]
    for node in tour.nodes
      num = parse(Int64,node.name)
      push!(V,num)
    end
    return V
end

```
"""

# ╔═╡ 88b42d49-1218-48f5-9da3-dc8ec4570c38
md"""
La fonction V\_tour prend un argument une tournée (de type Graphe) et retourne le vecteur des noeuds (en réalité il ne s'agit que de l'attribut name des noeuds) dans l'ordre de la tournée. Ce vecteur est un des arguments de la fonction write\_tour, c'est donc par cette fonction que l'on l'obtient.
"""

# ╔═╡ 4de9d728-e315-4174-8f82-da7688b0ba21
md""" #### 2. Obtention des images reconstruites """

# ╔═╡ 1c9ac2c3-f18a-4a30-97ab-688fd7db9efc
md"""
Le code ci-dessous permet donc de créer un fichier .tour à partir d'un fichier TSP : 
"""

# ╔═╡ 408e9195-44a0-4319-9f29-58091be2e5fe
md"""
``` julia
tsp_name = "tokyo-skytree-aerial"
filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/tsp/instances/$tsp_name.tsp"
graphe = build_graph_wo_node0(filename,"Graphe de $tsp_name")
tour = RSL(graphe)
tour_entier = V_tour(tour)
write_tour("$tsp_name.tour", tour_entier , graph_weight(tour))

```
"""

# ╔═╡ 04867d4a-4e3a-431d-89e8-ce764ab651e0
md"""
On procède de la manière suivante :
- construction d'un objet de type Graphe à partir d'un fichier TSP avec  build\_graph\_wo\_node0
- obtention d'une tournée (non minimale) de type Graphe avec RSL (HK ne fonctionne toujours pas)
- obtention du vecteur de noeuds avec V\_tour
- construction du fichier .tour à partir du vecteur avec write\_tour
"""

# ╔═╡ c089758c-b036-4b8a-9486-2b575e3f50d7
md"""
Enfin, on construit l'image à partir du fichier .tour et de la fonction fournie reconstruct_picture :
"""

# ╔═╡ 7c8b04ab-0cf2-4043-ba50-707f9dd280bf
md"""
``` julia
tour_filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/$tsp_name.tour"
input_name = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/images/shuffled/$tsp_name.png";
output_name = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/projet/phase4/images/reconstructed_by_me/$tsp_name.png"
reconstruct_picture(tour_filename,input_name,output_name)

```
"""

# ╔═╡ 2a685b34-472f-4912-be90-0ee87bbe0975
md""" #### 3. Images obtenues et conclusion """

# ╔═╡ ca11f417-ad35-49ab-a804-f2ffaca2efe3
md"""
L'ensemble des images sont disponibles sur Github en suivant phase4/images/reconstructed\_by\_me.
"""

# ╔═╡ c5ef69ec-b1f9-4341-bd02-082756837b45
md"""
Plusieurs remarques :
- Certaines images ou bout d'images sont inversées horizontalement : les arêtes étant non orientées, il n'y a pas de notion de gauche et de droite pour deux noeuds juxtaposés.
- Les images sont pour la plupart scindées en 2 parties parfaites : la tournée obtenue par RSL n'étant pas une tournée de poids minimal, il était normal de s'attendre à ne pas avoir le résultat parfait ! 
- En l'absence d'amélioration de la tournée (HK ne fonctionnant toujours pas), il n'est pas possible d'améliorer les résultats obtenus.
"""

# ╔═╡ 45b0fd0f-af1c-4774-97c3-0e90ad2f29bf
md"""
Voici quelques images obtenues à titre d'illustration : 
"""

# ╔═╡ Cell order:
# ╟─ab330d6c-a049-11ee-2479-4d4a4962f84a
# ╟─ced2c10e-5ba8-43b2-bcc5-459250c506f4
# ╟─f1fc5e56-95a4-4d18-a7e8-f2a7107efc66
# ╟─02853b60-9321-4c24-871a-a773e243b3af
# ╟─f117742f-b21c-4983-bc0e-0658b3332e48
# ╟─85c9da62-8a80-4465-8725-67fd3aae7fc9
# ╟─903a13e5-2c81-42ad-a219-ad51b720458e
# ╟─161c7226-b713-4897-8df3-c657287f15d3
# ╟─22feaaa0-4163-4fb6-aa94-5f9c4cd6bd6a
# ╟─88b42d49-1218-48f5-9da3-dc8ec4570c38
# ╟─4de9d728-e315-4174-8f82-da7688b0ba21
# ╟─1c9ac2c3-f18a-4a30-97ab-688fd7db9efc
# ╟─408e9195-44a0-4319-9f29-58091be2e5fe
# ╟─04867d4a-4e3a-431d-89e8-ce764ab651e0
# ╟─c089758c-b036-4b8a-9486-2b575e3f50d7
# ╟─7c8b04ab-0cf2-4043-ba50-707f9dd280bf
# ╟─2a685b34-472f-4912-be90-0ee87bbe0975
# ╟─ca11f417-ad35-49ab-a804-f2ffaca2efe3
# ╟─c5ef69ec-b1f9-4341-bd02-082756837b45
# ╟─45b0fd0f-af1c-4774-97c3-0e90ad2f29bf
