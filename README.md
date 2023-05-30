# Kolloqiumspräsentation & Code

[Präsentation](koll.pdf)

## Motivation

Zu Grunde liegt das Problem der [Graphpartitionierung](https://en.wikipedia.org/wiki/Graph_partition). Sie findet Anwendung in viele Bereichen in denen [Graphen](https://de.wikipedia.org/wiki/Graph_(Graphentheorie)) genutzt werden. Zum Beispiel bei der Fill-In-Reduziering bei [direkten Lösungsverfahren](https://de.wikipedia.org/wiki/Direktes_Verfahren). Da sie NP-schwer ist, nutzt man Heuristiken zur Partitionierung.

Für einen ungerichteten Graphen kann man sie wie folgt formulieren:

> **Gegeben:**
> 
> Ungerichteter Graph $G = (V, E)$ und eine Partitionsgröße $p \in \mathbb{N}$
>
> **Gesucht:**
> 
> Partition $V = V_1$ $\cup$ $...$ $\cup$ $V_p$ mit
> - **(P1)** $|V_l|$ ist gleich groß für $l = 1,$ $...$ $p$
> - **(P2)** $|S|$ ist minimal für den induzierten Schnitt $S$

*Bemerkung:* <br>
*P1 bedeutet, dass wir möglichst gleich große Knoten Mengen erzeugen wollen.*
*P2 bedeutet, in einem Graphen ohne Kantengewichte, dass wir möglichst wenige Verbindungskanten haben wollen. Allerdings ist dies äquivalent zu einem Schnitt mit minimalen Kantengewichten in einem Graphen, welcher auf jeder Kante das Gewicht 1 hat.*

Falls man eine Partition mit $p > 2$ sucht, verwendet man in der Regel rekursive Bisektion. Das heißt im Allgemeinen genügt es Heuristiken zu betrachten, die eine Partition mit $p = 2$ erzeugen.

### Beispiele


## Fill-In
## Kernighan-Lin
## Multilevel
