include("../phase1/build_graph.jl")
include("../phase1/node.jl")
include("../phase1/edge.jl")
include("../phase1/graph.jl")
include("../phase2/composanteconnexe.jl")
include("../phase2/prim.jl")
include("../phase3/RSL.jl")
include("../phase3/HK.jl")

a, b, c, d, e, f, g, h, i = Node("a", 1.0), Node("b", 1.0), Node("c", 1.0), Node("d", 1.0), Node("e", 1.0), Node("f", 1.0), Node("g", 1.0), Node("h", 1.0), Node("i", 1.0)
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
e15 = Edge(a, e, 12.)
e16 = Edge(i, d, 13.)
gr = Graph("graphe du cours", [a, b, c, d, e, f, g, h, i], [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16])
filename = "/Users/jules/Desktop/MTH6412B/Git/mth6412b-starter-code/instances/stsp/bays29.tsp";
#gr = build_graph(filename,"Graphe_test");

#graph_weight(RSL(gr))


onetree(gr,kruskal)


