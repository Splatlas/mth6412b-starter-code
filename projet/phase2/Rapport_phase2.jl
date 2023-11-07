### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 2c96b7a2-7caf-11ee-17d6-c10211f84c55
md""" # Rapport Phase 02
"""


# ╔═╡ f1e2da1e-c2c0-444b-ad4e-35e5b31f2f53
md""" #### Rèaliser par : 
Fairouz Mansouri\
Jules Caffin
"""
                         

# ╔═╡ 1d33910f-eea6-4598-88ab-a4548ea5fd93
md""" #### Adresse de dépot:
https://github.com/Splatlas/mth6412b-starter-code.git
"""

# ╔═╡ 5ebe0bf5-5414-449f-a3ad-22b44ad2ee96
md""" #### 1. Choisir et implémenter une structure de données pour les composantes connexes d’un graphe """

# ╔═╡ eda148af-dcdf-4328-82e5-b8f218c3bb15
md"""
Type de composante connexe (CC) : est un dictionnaire où l'ensemble des noeuds correspond à l'ensemble des clés
L'utilisation des valeurs du dictionnaire servira pour d'autres cas (orienté?) """

# ╔═╡ e93bfb39-0751-41dd-828c-e005014c0817
md"""
``` julia
mutable struct ConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
end

```
"""

# ╔═╡ 4a7b4479-7c34-4b66-93bb-5d3c7a0ca3e5
md"""
Nous présentons ici les différentes méthodes que nous avons créées pour la manipulation des composantes connexes nécessaires dans les prochaines étapes de TP.
"""

# ╔═╡ 87d9f7cd-0231-4a86-966d-9d104127b9d0
md"""
#### Méthode pour vider une composante connectée (CC) de ses nœuds
"""

# ╔═╡ 98b5ce5d-cd1c-46c6-8c6d-323d6f6dddf7
md"""
``` julia
function empty!(CC::AbstractConnectedComponent{T}) where{T}
  CC.nodes = Dict{Node{T}, Node{T}}()  # remplace le dictionnaire de la CC par un dictionnaire vide
  CC
end
```
"""

# ╔═╡ 3645d548-5af1-4585-95c1-13cdb08725e8
md"""
#### Méthode qui  prend un graphe G et renvoie un vecteur V contenant l'ensemble des composante connexe initiales (unitaires).
V contient des composante connexe de taille unitaire = 1 noeud
"""

# ╔═╡ aa75f240-de34-4a55-8e5a-1a8eaacbff5f
md"""
``` julia
function all_nodes_as_CC(g::Graph{T}) where{T}
  V = Vector{ConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()  
    d[k] = k                       # un rentre le noeud en clé ET en valeur : sans importance mais c'était un noeud sous la main
    CC = ConnectedComponent{T}(d)
    push!(V,CC)
  end
  return V
```
"""

# ╔═╡ 5a45ac87-0985-468a-8af6-a09e15e93bf9
md"""
#### Méthode qui prend en entrée un vecteur de  composante connexe et retourne celle qui contient le noeud
"""

# ╔═╡ 729a94e4-6fe3-4a4a-97e7-5d350dc83ed9
md"""
``` julia
function find_CC_where_node(V::Vector{ConnectedComponent{T}},noeud::Node{T}) where{T}
  for CC in V
     # haskey permet de verfier si un noeud est dans la CC, il returne true or false
    if haskey(CC.nodes, noeud)
      return CC
    end
  end
end

```
"""

# ╔═╡ d9d1f3aa-ff1f-4c6b-8361-88186eb946af
md"""
#### Méthode pour  comparer deux CC et return True si c'est les même.
Dans ce cas de figure, deux dictionnaires sont les mêmes s'ils ont les mêmes clés (les valeurs ne servent à rien)
"""

# ╔═╡ 6fb6c7db-066d-41d8-b774-2441268577b7
md"""
```julia
function same_CC(CC1::AbstractConnectedComponent{T},CC2::AbstractConnectedComponent{T}) where{T}
  if length(CC1.nodes) != length(CC2.nodes)
    return false
  else
    for noeud in keys(CC1.nodes)
      if !haskey(CC2.nodes, noeud)
        return false
      end
    end
  end
  return true
end
```
"""

# ╔═╡ d203ee13-d21a-4c3d-ab85-b6ac151b4253
md"""
#### Méthode pour la fusion de deux CC (composantes connexes)
Les CC créées à partir d'une fusion de CC unitaires donne des dictionnaires 
dont seules les clés représentent les noeuds de la CC. Les valeurs ne servent à rien 
"""

# ╔═╡ cca17efd-cd7f-4834-8f21-6527dd4d7a6c
md"""
```julia
#Fusionne la CC2 à la CC1 (hypothèse: node_1 de edge est dans CC1) : 
function fusion_CC!(CC1::AbstractConnectedComponent{T}, CC2::AbstractConnectedComponent{T}) where{T}       
  for (k,v) in CC2.nodes                    
    CC1.nodes[k] = v                       
  end           
  CC1
end
```
"""

# ╔═╡ ea4f66b5-1dfd-4f06-a3f3-ac9e57c1e38b
md""" #### 2. Implémenter l’algorithme de Kruskal vu au laboratoire et le tester sur l’exemple des notes de cours """

# ╔═╡ a79b25aa-c7f9-4543-80ce-eece473a7c21
md"""
##### 2.1 Implémentation de  l’algorithme de Kruskal
"""

# ╔═╡ 33ccece3-886a-4f55-a443-4ad4fc343059
md"""
Nous allons maintenant définir la fonction `kruskal`, qui implémente l'algorithme de Kruskal pour trouver un arbre couvrant minimum dans un graphe pondéré. Cette fonction prend un graphe `g` et retourne un arbre couvrant de poids minimal.
"""

# ╔═╡ 4a6d233c-3189-44f2-91d6-e493b3be786c
md"""
```julia
function kruskal(g::Graph{T,Y}) where {T, Y}
    V_CC = all_nodes_as_CC(g)  # Récupère les CC unitaires dans un vecteur
    sorted_edges = sort(g.edges, by=weight)  # Trie les arêtes du graphe par poids
    selected_edges = Edge{T,Y}[]  # Initialise un vecteur vide  pour stocker les arêtes sélectionnées
    P = 0  # Initialise le poids total à 0

    # Parcourt chaque arête triée par poids
    for edge in sorted_edges
        noeud1, noeud2 = edge.node_1, edge.node_2  # Extrait les nœuds de l'arête
        CC1 = find_CC_where_node(V_CC, noeud1)  # Trouve la CC contenant noeud1
        CC2 = find_CC_where_node(V_CC, noeud2)  # Trouve la CC contenant noeud2

        # Vérifie que les 2 noeuds n'appartiennent pas à la même CC
        if !same_CC(CC1, CC2)
            push!(selected_edges, edge)  # Ajoute l'arête aux arêtes sélectionnées
            P += edge.weight  # Ajoute le poids de l'arête au poids total
            fusion_CC!(CC1, CC2)  # Fusionne les deux CC
            empty!(CC2)  # Vide la deuxième CC
        end
    end

    # Crée un nouveau graphe avec les arêtes sélectionnées
    result = Graph{T,Y}("Kruskal de $(g.name)", nodes(g), selected_edges)
    show(result)  # Affiche le graphe résultant
    return "Le poids total est $P"  # Retourne le poids total de l'arbre couvrant
end

```
"""

# ╔═╡ 3917ff7e-a693-47a6-a015-7653a0358586
md"""
##### 2.2 Tester l’algorithme de Kruskal sur l’exemple des notes de cours
"""

# ╔═╡ 52a3c1ea-7ec5-4092-b6e3-8cbd201ec1d1
md"""
```julia
# Création des noeuds et des arêtes
   a, b, c, d, e, f, g, h, i = Node("a", 1.0), Node("b", 1.0), Node("c", 1.0), 
     Node("d", 1.0), Node("e", 1.0), Node("f", 1.0), Node("g", 1.0), Node("h", 1.0), 
     Node("i", 1.0) 
e1 = Edge(a, b, 4.)
e2 = Edge(a, h, 8.)
e3 = Edge(c, d, 7.)
e4 = Edge(d, e, 9.)
e5 = Edge(e, f, 10.)
e6 = Edge(d, f, 14.)
e7 = Edge(f, c, 4.)
e8 = Edge(f, g, 2.)
e9 = Edge(g, i, 6.)
e10 = Edge(g, h, 1.)
e11 = Edge(b, c, 8.)
e12 = Edge(h, i, 7.)
e13 = Edge(i, c, 2.)
e14 = Edge(b, h, 11.)

   #Création du graphe
Graphe_test = Graph("graphe du cours", [a, b, c, d, e, f, g, h, i], [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14])

    #Exécution de l'algorithme de Kruskal
    resultat_kruskal = kruskal(Graphe_test)

  # Affichage des résultats avec la focntion show
  show(kruskal(Graphe_test))
```
"""
  

# ╔═╡ da16fb6a-f7a5-4522-bf47-a138ef4d8d6d
md"""
####  Affichage des résultats trouvées par Kruskal
"""

# ╔═╡ 9a29fcf5-c533-4140-80e0-9d28c5e54e83
md"""
```julia
Graph Kruskal de graphe du cours has 9 nodes and 8 edges
Node a, data: 1.0
Node b, data: 1.0
Node c, data: 1.0
Node d, data: 1.0
Node e, data: 1.0
Node f, data: 1.0
Node g, data: 1.0
Node h, data: 1.0
Node i, data: 1.0
Edge : g ,h, weight: 1.0
Edge : f ,g, weight: 2.0
Edge : i ,c, weight: 2.0
Edge : a ,b, weight: 4.0
Edge : f ,c, weight: 4.0
Edge : c ,d, weight: 7.0
Edge : a ,h, weight: 8.0
Edge : d ,e, weight: 9.0
"Le poids total est 37.0

```
"""

# ╔═╡ 2c5394ba-8f7a-4a77-b5bb-63075aed16ac
md""" ### 3. Implémenter les deux heuristiques d’accélération et répondre à la question concernant le rang """

# ╔═╡ 0a5e574d-2540-4e46-8780-e72129b7c4a4
md"""
#### Implémentation de l`heuristique 1 : Union via le rang 
"""

# ╔═╡ b78469f8-20ab-4e33-b025-8dc80faa238a
md"""
###### Type de Composante Connexe avec Rang (RaCC)
Un type mutable pour représenter une composante connexe avec un dictionnaire des nœuds et un rang.
"""


# ╔═╡ 2fd13162-2c52-4f79-b49b-ef66bf2473a5
md"""
```julia
mutable struct RankedConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
  rank::Int
end
```
"""

# ╔═╡ 7bacf603-72ad-401f-be53-b7ed958f86c7
md"""
###### Fonction pour Définir le Rang d'une RaCC
Cette fonction modifie le rang d'une composante connexe.
"""


# ╔═╡ 40bad9e8-f1be-4a00-b9fa-71b0df498c48
md"""
```julia
function set_rank!(c::RankedConnectedComponent, r::Int)
    c.rank = r
    c
end
```
"""

# ╔═╡ a4bc37ba-07a6-419d-a050-54796b1403fc
md"""
###### Fonction pour Initialiser les RaCC
Prend un graphe G et renvoie un vecteur V contenant l'ensemble des RoCC initiales (unitaires).

V contient des RoCC de taille unitaire = 1 noeud
"""


# ╔═╡ 878bcd71-0cc5-4ecc-aac5-4d86a330f5cf
md"""
```julia 
function all_nodes_as_RaCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RankedConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
# seul changement avec kruskal classique : le rang des RaCC unitaires est initialisé à 0
    RaCC = RankedConnectedComponent{T}(d,0)
    push!(V,RaCC)
  end
  return V
end


```
"""

# ╔═╡ 6d0c6831-183e-46b5-b392-ce1780dadfab
md"""
###### Prend en entrée un vecteur de RaCC et retourne celle qui contient le noeud

"""


# ╔═╡ f30c983d-ddb5-447d-92eb-655e2a149cbb
md"""
```julia 
function find_RaCC_where_node(V::Vector{RankedConnectedComponent{T}},noeud::Node{T}) where{T}
  for RaCC in V
    if haskey(RaCC.nodes, noeud)
      return RaCC
    end
  end 
end
# find_RaCC_where_node ne diffère pas du kruskal de base
```

"""

# ╔═╡ 6908d2d7-516f-444c-a5e4-ab40a9569c1f
md"""
#### Heuristique1 pour l'Algorithme de Kruskal
Modification de l'algorithme de Kruskal avec une heuristique1 basée sur le rang pour optimiser la fusion des composantes connexes.
"""

# ╔═╡ af0118b0-8ef1-4cd6-ae7d-b1d948d484f8
md"""
```julia
#Cette fonction modifie l'algorithme de Kruskal standard en utilisant une heuristique basée sur le rang des composantes connexes pour optimiser la fusion des composantes connexes.

function heuristic_1_kruskal(g::Graph{T,Y}) where{T,Y}
  # Initialiser les RaCC pour chaque noeud du graphe
  V_RaCC = all_nodes_as_RaCC(g)
  
  # Trier les arêtes par poids croissant
  sorted_edges = sort(g.edges, by=weight)
  
  # Préparer le vecteur pour stocker les arêtes sélectionnées
  selected_edges = Edge{T,Y}[]
  
  # Initialiser le poids total à zéro
  P = 0
  
  # Parcourir toutes les arêtes triées
  for edge in sorted_edges
    # Récupérer les nœuds de l'arête courante
    noeud1, noeud2 = edge.node_1, edge.node_2
    
    # Trouver les RaCC correspondant à chaque noeud de l'arête
    RaCC1 = find_RaCC_where_node(V_RaCC,noeud1)
    RaCC2 = find_RaCC_where_node(V_RaCC,noeud2)
    
    # Si les nœuds ne sont pas déjà dans la même composante connexe
    if !same_CC(RaCC1,RaCC2)
      # Sélectionner l'arête et ajouter son poids au poids total
      push!(selected_edges, edge)
      P =  P + edge.weight
      
      # Fusionner les RaCC en tenant compte de leur rang
      if RaCC1.rank > RaCC2.rank
        fusion_CC!(RaCC1,RaCC2,edge)
        empty!(RaCC2.nodes)
      else
        fusion_CC!(RaCC2,RaCC1,edge)
        empty!(RaCC1.nodes)
        
        # Mettre à jour le rang si les deux RaCC1 et RaCC2 ont le meme rang
        if RaCC1.rank == RaCC2.rank
          set_rank!(RaCC2,RaCC2.rank+1)
        end
      end
    end
  end
  
  # Afficher le nouveau graphe avec les arêtes sélectionnées
  result_graph = Graph{T,Y}("Kruskal de $(g.name)", nodes(g), selected_edges)
  show(result_graph)
  
  # Retourner le poids total de l'arbre couvrant minimum
  return "Le poids total est $P"
end

```
"""

# ╔═╡ acc7ae66-adb3-4412-b92e-c03333a4601a
md"""
####  Affichage des résultats trouvées par implémentation de l'heuristique1 
"""

# ╔═╡ ae778eaf-f629-4408-a656-62f7afa33bfb
md"""
```julia
Graph Kruskal de graphe du cours par l'heuristique 1 has 9 nodes and 8 edges
Node a, data: 1.0
Node b, data: 1.0
Node c, data: 1.0
Node d, data: 1.0
Node e, data: 1.0
Node f, data: 1.0
Node g, data: 1.0
Node h, data: 1.0
Node i, data: 1.0
Edge : g ,h, weight: 1.0
Edge : f ,g, weight: 2.0
Edge : i ,c, weight: 2.0
Edge : a ,b, weight: 4.0
Edge : f ,c, weight: 4.0
Edge : c ,d, weight: 7.0
Edge : a ,h, weight: 8.0
Edge : d ,e, weight: 9.0
"le poids total est 37.0"
```
"""

# ╔═╡ 46b45ed3-c10e-4bb9-95dd-ac8f9d3f55f6
md"""
#### Implémentation de l`heuristique 2 :  compression des chemins
"""

# ╔═╡ 9f79f828-13b8-4a24-820f-3381c6566cbb
md"""
#####  Définition du type de composante connexe avec racine (RoCC)
Ce type représente une composante connexe avec un noeud racine spécifié. Le dictionnaire contient les noeuds en tant que clés.
"""


# ╔═╡ 5bfa4a93-884c-4a8c-b7cc-4340c5d6c3d1
md"""
```julia
mutable struct RootedConnectedComponent{T} <: AbstractConnectedComponent{T}
  nodes::Dict{Node{T}, Node{T}}
  root::Node{T}
end
```
"""

# ╔═╡ 65d45a7b-5489-4727-8138-f949f921ab66
md"""
###### Prend un graphe G et renvoie un vecteur V contenant l'ensemble des RoCC initiales (unitaires).
V contient des RoCC de taille unitaire = 1 noeud"""


# ╔═╡ 695199ba-dafd-48f3-a0b3-83c80b160797
md"""
```julia
function all_nodes_as_RoCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RootedConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
    r = k       # seul changement avec kruskal classique : la racine du RoCC unitaire est le noeud lui-même
    RoCC = RootedConnectedComponent{T}(d,r)
    push!(V,RoCC)
  end
  return V
end
```
"""

# ╔═╡ d745b358-0ab6-4d92-b0c1-b868edc2eb5a
md"""
##### Fonction pour initialiser les RoCC unitaires
Prend un graphe et renvoie un vecteur de RoCC initiales, chaque RoCC contenant un seul noeud.
"""


# ╔═╡ 93008a00-af3a-4409-9747-2f8f916b81af
md"""
```julia
function all_nodes_as_RoCC(g::Graph{T,Y}) where{T,Y}
  V = Vector{RootedConnectedComponent{T}}()
  for k in g.nodes
    d = Dict{Node{T}, Node{T}}()
    d[k] = k
    r = k
    RoCC = RootedConnectedComponent{T}(d, r)
    push!(V, RoCC)
  end
  return V
end
```
"""

# ╔═╡ a3c0f88e-d88a-4271-801f-a15f742bbb40
md"""
##### Compare deux CC et return True si c'est les même.
Dans ce cas de figure, deux dictionnaires sont les mêmes s'ils ont la même racine"""


# ╔═╡ 77c5eb00-5872-4d84-809a-97072325b16f
md"""
```julia
function same_RoCC(RoCC1::RootedConnectedComponent{T},RoCC2::RootedConnectedComponent{T}) where{T}
    if RoCC1.root == RoCC2.root
        return true
    else
        return false
    end
end
# En effet, deux RoCC sont les mêmes s'ils ont la même racine car une RoCC a pour racine un de ses noeuds. 
# Un noeud ne peut pas être dans deux RoCC différentes (car les RoCC sont détruites après fusion, 
# chaque noeud n'est présent que dans une RoCC). Ainsi, avoir la même racine signifie appartenir à la même RoCC
```
"""

# ╔═╡ b0be470c-caee-40ca-8804-3e35d2869d6d
md""" 
##### Fusionne la RoCC2 à la RoCC1 (hypothèse: node_1 de edge est dans RoCC1)"""



# ╔═╡ 3089931e-9641-49a1-8aed-80e7396249b8
md"""
```julia
function fusion_RoCC!(RoCC1::RootedConnectedComponent{T}, RoCC2::RootedConnectedComponent{T}) where{T}
    for (k,v) in RoCC2.nodes                    
        RoCC1.nodes[k] = v                       
    end                  # comme vu dans le commentaire de same_RoCC, il suffit que la racine soit un noeud quelconque de la RoCC      
    RoCC1                # arbitrairement, on conserve la racine de RoCC1
end
```
"""

# ╔═╡ 5910f521-df59-49f4-b707-680e0c8bab6a
md"""
#### Heuristique 2 pour l'Algorithme de Kruskal avec RoCC
"""


# ╔═╡ 346fd8e6-7c60-4cb7-ba99-d517da483cba
md"""
```julia
function heuristic_2_kruskal(g::Graph{T,Y}) where{T,Y}
    V_RoCC = all_nodes_as_RoCC(g)
    sorted_edges = sort(g.edges, by=weight)
    selected_edges = Edge{T,Y}[]
    P = 0
    for edge in sorted_edges
      noeud1, noeud2 = edge.node_1, edge.node_2
      RoCC1 = find_RoCC_where_node(V_RoCC,noeud1)
      RoCC2 = find_RoCC_where_node(V_RoCC,noeud2)
      if !same_RoCC(RoCC1,RoCC2)
        push!(selected_edges, edge)
        P = P + edge.weight
        fusion_RoCC!(RoCC1,RoCC2)
        empty!(RoCC2)
      end
    end
    result = Graph{T,Y}("Kruskal de $(g.name)", nodes(g), selected_edges)
    show(result)
    return "Le poids total est $P"
  end
  # L'algorithme est inchangé, c'est les fonctions fusion_RoCC! et same_RoCC qui diffèrent

```
"""

# ╔═╡ a8204faf-696b-4876-ac14-6ec81df57e37
md"""
####  Affichage des résultats trouvées par implémentation de l'heuristique2
"""

# ╔═╡ 640b19b0-16e5-401c-9737-ac236f750653
md"""
```julia
Graph Kruskal de graphe du cours par l'heuristique 2 has 9 nodes and 8 edges
Node a, data: 1.0
Node b, data: 1.0
Node c, data: 1.0
Node d, data: 1.0
Node e, data: 1.0
Node f, data: 1.0
Node g, data: 1.0
Node h, data: 1.0
Node i, data: 1.0
Edge : g ,h, weight: 1.0
Edge : f ,g, weight: 2.0
Edge : i ,c, weight: 2.0
Edge : a ,b, weight: 4.0
Edge : f ,c, weight: 4.0
Edge : c ,d, weight: 7.0
Edge : a ,h, weight: 8.0
Edge : d ,e, weight: 9.0
"Le poids total est 37.0"
```
"""

# ╔═╡ 5f33bcf4-6881-4b7c-8688-5af72d2b6bb0
md"""
 ##### Pour la réponse à la question 2, veuillez vous référer à la dernière section de ce rapport.
"""

# ╔═╡ 0f734356-6226-4de9-a4d0-7c1dfed75671
md""" ### 4. implémenter l’algorithme de Prim vu au laboratoire et le tester sur l’exemple des notes de cours  """

# ╔═╡ 501fe418-5e44-4462-ad25-a1c6bb855fa0
md"""
Pour l'algorithme de Prim nous avons dans un premier temps défini le objet file de priorité. L'idée ensuite était d'écrire un algorithme qui prend un noeud et l'insère dans l'arbre de recouvrement final. Ensuite, à tous les noeuds isolés est associé une distance à cet arbre. Le noeuds sont empilés dans une pile de priorité, mais nous nous sommes arrêtés par manque de temps face au problème suivant : pour mettre à jour les distances minimales des éléments de la pile à l'arbre grandissant, il faut à chaque itération dépiler et repiler. Ça ne semblait pas convenir.
"""

# ╔═╡ 6b6b8bf7-0cac-4c4c-a98f-57a4f8937f49
md""" ### 6. tester vos implémentations sur diverses instances de TSP symétrique dans un programme principal et commenter.  """

# ╔═╡ 090efbdd-6845-497b-9d2d-3d1fcbec73f4
md"""
Nous avons réussi à faire fonctionner l'algorithme de Kruskal ainsi que ses deux heuristiques sur l'exemple du cours mais pas sur les fichiers TSP. Le problème semble venir de la fonction haskey des dictionnaires, qui ne reconnait pas les clés de type Node{Vector{Float64}}. Nous n'avons pas réussi à contourner le problème

"""

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
# ╟─2c96b7a2-7caf-11ee-17d6-c10211f84c55
# ╟─f1e2da1e-c2c0-444b-ad4e-35e5b31f2f53
# ╟─1d33910f-eea6-4598-88ab-a4548ea5fd93
# ╟─5ebe0bf5-5414-449f-a3ad-22b44ad2ee96
# ╟─eda148af-dcdf-4328-82e5-b8f218c3bb15
# ╟─e93bfb39-0751-41dd-828c-e005014c0817
# ╟─4a7b4479-7c34-4b66-93bb-5d3c7a0ca3e5
# ╟─87d9f7cd-0231-4a86-966d-9d104127b9d0
# ╟─98b5ce5d-cd1c-46c6-8c6d-323d6f6dddf7
# ╟─3645d548-5af1-4585-95c1-13cdb08725e8
# ╟─aa75f240-de34-4a55-8e5a-1a8eaacbff5f
# ╟─5a45ac87-0985-468a-8af6-a09e15e93bf9
# ╟─729a94e4-6fe3-4a4a-97e7-5d350dc83ed9
# ╟─d9d1f3aa-ff1f-4c6b-8361-88186eb946af
# ╟─6fb6c7db-066d-41d8-b774-2441268577b7
# ╟─d203ee13-d21a-4c3d-ab85-b6ac151b4253
# ╟─cca17efd-cd7f-4834-8f21-6527dd4d7a6c
# ╟─ea4f66b5-1dfd-4f06-a3f3-ac9e57c1e38b
# ╟─a79b25aa-c7f9-4543-80ce-eece473a7c21
# ╟─33ccece3-886a-4f55-a443-4ad4fc343059
# ╟─4a6d233c-3189-44f2-91d6-e493b3be786c
# ╟─3917ff7e-a693-47a6-a015-7653a0358586
# ╟─52a3c1ea-7ec5-4092-b6e3-8cbd201ec1d1
# ╟─da16fb6a-f7a5-4522-bf47-a138ef4d8d6d
# ╟─9a29fcf5-c533-4140-80e0-9d28c5e54e83
# ╟─2c5394ba-8f7a-4a77-b5bb-63075aed16ac
# ╟─0a5e574d-2540-4e46-8780-e72129b7c4a4
# ╟─b78469f8-20ab-4e33-b025-8dc80faa238a
# ╟─2fd13162-2c52-4f79-b49b-ef66bf2473a5
# ╠═7bacf603-72ad-401f-be53-b7ed958f86c7
# ╟─40bad9e8-f1be-4a00-b9fa-71b0df498c48
# ╟─a4bc37ba-07a6-419d-a050-54796b1403fc
# ╟─878bcd71-0cc5-4ecc-aac5-4d86a330f5cf
# ╟─6d0c6831-183e-46b5-b392-ce1780dadfab
# ╟─f30c983d-ddb5-447d-92eb-655e2a149cbb
# ╟─6908d2d7-516f-444c-a5e4-ab40a9569c1f
# ╟─af0118b0-8ef1-4cd6-ae7d-b1d948d484f8
# ╠═acc7ae66-adb3-4412-b92e-c03333a4601a
# ╟─ae778eaf-f629-4408-a656-62f7afa33bfb
# ╟─46b45ed3-c10e-4bb9-95dd-ac8f9d3f55f6
# ╟─9f79f828-13b8-4a24-820f-3381c6566cbb
# ╟─5bfa4a93-884c-4a8c-b7cc-4340c5d6c3d1
# ╟─65d45a7b-5489-4727-8138-f949f921ab66
# ╟─695199ba-dafd-48f3-a0b3-83c80b160797
# ╟─d745b358-0ab6-4d92-b0c1-b868edc2eb5a
# ╟─93008a00-af3a-4409-9747-2f8f916b81af
# ╟─a3c0f88e-d88a-4271-801f-a15f742bbb40
# ╟─77c5eb00-5872-4d84-809a-97072325b16f
# ╟─b0be470c-caee-40ca-8804-3e35d2869d6d
# ╟─3089931e-9641-49a1-8aed-80e7396249b8
# ╟─5910f521-df59-49f4-b707-680e0c8bab6a
# ╟─346fd8e6-7c60-4cb7-ba99-d517da483cba
# ╟─a8204faf-696b-4876-ac14-6ec81df57e37
# ╟─640b19b0-16e5-401c-9737-ac236f750653
# ╟─5f33bcf4-6881-4b7c-8688-5af72d2b6bb0
# ╟─0f734356-6226-4de9-a4d0-7c1dfed75671
# ╟─501fe418-5e44-4462-ad25-a1c6bb855fa0
# ╟─6b6b8bf7-0cac-4c4c-a98f-57a4f8937f49
# ╟─090efbdd-6845-497b-9d2d-3d1fcbec73f4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
