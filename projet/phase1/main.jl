include("node.jl")
include("edge.jl")
include("graph.jl")

noeud_1 = Node("Kirk", 4);
noeud_2 = Node("Lars", 2);
noeud_3 = Node("Pierre", 1);

arête_1 = Edge(6, noeud_1,noeud_2);
arête_2 = Edge(4, noeud_1,noeud_3);
arête_3 = Edge(4, noeud_2,noeud_3);