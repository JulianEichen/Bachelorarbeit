# Kolloqiumspräsentation & Code

[Präsentation](koll.pdf)

## Motivation

Zu Grunde liegt das Problem der [Graphpartitionierung](https://en.wikipedia.org/wiki/Graph_partition). Sie findet Anwendung in viele Bereichen in denen [Graphen](https://de.wikipedia.org/wiki/Graph_(Graphentheorie)) genutzt werden. Zum Beispiel bei der Fill-In-Reduzierung bei [direkten Lösungsverfahren](https://de.wikipedia.org/wiki/Direktes_Verfahren). Da sie NP-schwer ist, nutzt man Heuristiken zur Partitionierung.

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

### Graph
<img src="https://github.com/JulianEichen/BA_KL/blob/main/pictures/graph.png" width=75% height=75%>

Ungerichteter Graph mit Knoten $v_1, ..., v_{10}$ und Kanten mit Gewicht $1$.
<br>
<br>


### Beliebige Partition mit $p = 2$
<img src="https://github.com/JulianEichen/BA_KL/blob/main/pictures/cut.png" width=75% height=75%>

Wir betrachten die Partition aus $V_1 = \\{ v_1 , v_4 , v_5 , v_9 , v_{10} \\}$ und $V_2 = \\{ v_2 , v_3 , v_6 , v_7 , v_8 \\}$. <br>
Sie induziert einen Schnitt der Größe $5$.
<br>
<br>


### Optimale Partition $p = 2$
<img src="https://github.com/JulianEichen/BA_KL/blob/main/pictures/mincut.png" width=75% height=75%>
  
Wir betrachten die Partition aus $V_1 = \\{ v_1 , v_2 , v_3 , v_4 , v_5 \\}$ und $V_2 = \\{ v_6 , v_7 , v_8, v_9, v_{10} \\}$. <br>
Sie induziert einen Schnitt der Größe $3$.
<br>
<br>

## Fill-In

Sei $Ax = b$ mit [symmetrisch](https://de.wikipedia.org/wiki/Symmetrische_Matrix), [positiv definitem](https://de.wikipedia.org/wiki/Definitheit#Definitheit_von_Matrizen) $A = R^R$
und $R$ [obere Dreiecksmatrix](https://de.wikipedia.org/wiki/Dreiecksmatrix#Obere_und_untere_Dreiecksmatrix). Beim direkten Lösen würd wir erst $R^c = b$ und dann $Rx = c$ lösen. Ist $A$ dabei [dünn besetzt](https://de.wikipedia.org/wiki/D%C3%BCnnbesetzte_Matrix), kommt es bei der Berechnung von $R$ zum sogenannten Fill-In und $R$ ist nicht mehr dünn besetzt. Und damit leidet die Effizienz weiterer Berechung mit $R$. <br>
Um den Fill-In zu verringern kann wie folgt vorgegangen werden:
- Im zu $A$ gehörenden Graphen entsprechen die Knoten den Zeilen bzw. Spalten von $A$.
- Bestimme eine Partitionierung der Knotenmenge.
- Bestimme eine Menge an Knoten welche die Partionen trennt.
- Ordne die Zeilen bzw. Spalten von $A$ entsprechend an.

## Kernighan-Lin
## Multilevel
