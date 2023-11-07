"""Type abstrait dont d'autres types de files dériveront."""
abstract type AbstractQueue{T} end




# EN DESSOUS : FILE

"""Type représentant une file avec des éléments de type T."""
mutable struct Queue{T} <: AbstractQueue{T}
    items::Vector{T} 
end

Queue{T}() where T = Queue(T[])


import Base.length, Base.popfirst!

"""Ajoute ￿item￿ à la fin de la file ￿s￿.""" 
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.items, item)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.items)

"""Indique si la file est vide.""" 
is_empty(q::AbstractQueue) = length(q.items) == 0

"""Donne le nombre d'éléments sur la file."""
length(q::AbstractQueue) = length(q.items)

import Base.show

"""Affiche une file."""
show(q::AbstractQueue) = show(q.items)




## EN DESSOUS : FILE DE PRIORITÉ

abstract type AbstractPriorityItem{T} end

mutable struct PriorityItem{T} <: AbstractPriorityItem{T} 
    priority::Int
    data::T
end

"""Constructeur d'un PriorityItem"""
function PriorityItem(priority::Int, data::T) where T 
    PriorityItem{T}(max(0, priority), data)
end

priority(p::PriorityItem) = p.priority

"""Fixe la priorité d'un PriorityItem"""
function priority!(p::PriorityItem, priority::Int) 
    p.priority = max(0, priority)
    p
end

import Base.isless, Base.==
isless(p::PriorityItem, q::PriorityItem) = priority(p) < priority(q) 
==(p::PriorityItem, q::PriorityItem) = priority(p) == priority(q)



"""File de priorité."""
mutable struct PriorityQueue{T <: AbstractPriorityItem} <: AbstractQueue{T} 
    items::Vector{T}
end

PriorityQueue{T}() where T = PriorityQueue(T[])

"""Rajoute l'élément en classant en fonction de sa priorité"""
function push!(q::PriorityQueue, item::PriorityItem)
    n = length(q.items)
    push!(q.items, item)
    j = n
    while j>0 && item < q.items[j]
        q.items[j+1]=q.items[j]
        j=j-1
    end
    q.items[j+1]=item
    item
end

"""Retire et renvoie l'élément ayant la plus haute priorité."""
function popfirst!(q::PriorityQueue) 
    highest = q.items[1]
    for item in q.items[2:end]
        if item > highest 
            highest = item
        end 
    end
    idx = findall(x -> x == highest, q.items)[1] 
    deleteat!(q.items, idx)
    highest
end

"""Retire et renvoie l'élément ayant la plus basse priorité."""
function poplast!(q::PriorityQueue) 
    lowest = q.items[1]
    for item in q.items[2:end]
        if item < lowest 
            lowest = item
        end 
    end
    idx = findall(x -> x == lowest, q.items)[1] 
    deleteat!(q.items, idx)
    lowest
end





## EN DESSOUS : FILE DE PRIORITÉ FONCTIONNANT COMME UNE PILE

"""File de priorité fonctionnant comme une pile."""
mutable struct PriorityStack{T <: AbstractPriorityItem} <: AbstractQueue{T} 
    items::Vector{T}
end

PriorityStack{T}() where T = PriorityStack(T[])

"""Rajoute l'élément en lui donnant la priorité de son rang"""
function push!(q::PriorityStack, item::PriorityItem)
    prio = length(q.items)+1
    priority!(item,prio)
    push!(q.items, item)
    q
end


"""Retire et renvoie l'élément ayant la plus haute priorité."""
function popfirst!(q::PriorityStack) 
    highest = q.items[1]
    for item in q.items[2:end]
        if item > highest 
            highest = item
        end 
    end
    idx = findall(x -> x == highest, q.items)[1] 
    deleteat!(q.items, idx)
    highest
end



##Tests : 

item1 = PriorityItem(1, 3.14);
item2 = PriorityItem(4, 2.72);
item3 = PriorityItem(3, 1.56);
item4 = PriorityItem(2, 1.56);
liste_prio = PriorityQueue{PriorityItem}();
push!(liste_prio,item1);
push!(liste_prio,item2);
push!(liste_prio,item3);
push!(liste_prio,item4);
show(liste_prio)




