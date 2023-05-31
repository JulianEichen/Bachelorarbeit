# Graphpartitionierung: Implementierung und Vergleich des Kernighan-Lin-Algorithmus und eines Multilevel-Ansatzes

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

Beim Kernighan-Lin-Algorithmus wird versucht eine initiale, zum Beispiel zufällige, Partitionierung zu verbesseren, das heißt man minimiert den induzierten Schnitt. Erreicht wird dies durch Tauschen von Knoten zwischen den Partitionen. Da das Finden einer optimalen Auswahl NP-schwer ist, beschränkt man sich auf ein lokales Optimum.<br>
Dabei wird in zwei Schleifen gearbeitet:
1. Äussere Schleife: Prüft ob die innere Schleife eine Verbesserung
erzeugt und läuft solange diese ein Verbesserung erzeugt.
2. Innere Schleife: Tauscht Knotenmengen, jeder Knoten darf
dabei maximal einmal getauscht werden.

Bei den Schleifen ergeben sich viele Möglichkeiten zur Modifikation. Beispielsweise bewegt man immer nur den besten Knoten aus der größeren Partition in die kleinere.<br>
Bei der Auswahl der Knoten sind vor allem zwei Größen zu
beachten:
- Äußere Kosten: $E_{\nu} (a) = \sum_{e=\\{a,b\\}\in E} w(e), a \in A, b \in B$
- Innere Kosten: $I_{\nu} (a) = \sum_{e=\\{a,a'\\}\in E} w(e), a,a' \in A$
- mit $G = (V,E)$ ein Graph und $A,B \subset V$ eine Partitionierung von G

### Beispiel

<img src="https://github.com/JulianEichen/BA_KL/blob/main/pictures/cut_cost.png" width=75% height=75%>

- $E_{\nu} (v_1) = 2$, $I_{\nu} (v_1) = 0$ 
- $E_{\nu} (v_4) = 3$, $I_{\nu} (v_4) = 2$ 
- $E_{\nu} (v_5) = 0$, $I_{\nu} (v_5) = 1$ 


## Multilevel

Der Multilevel-Ansatz ist ein Prinzip zur Partitionierung von sehr großen Graphen.<br>
Er besteht aus drei Teilen:
1. Vergröberung
2. Partitionierung
3. Verfeinerung

Für die einzelnen Teile gibt es jeweils verschiedene Möglichkeiten der Umsetzung.

### Vergröberung

Man nutzt ein [Matching](https://de.wikipedia.org/wiki/Matching_(Graphentheorie)) im Graphen als grundlegende Struktur. Dabei werden die Knotenpaare und die verbindenden Kante zu einem Knoten zusammengefasst. Die Nachbarschaftsbeziehungen der beiden Knoten werden vereinigt und auf den neuen Knoten übertragen.

### Beispiel

<img src="https://github.com/JulianEichen/BA_KL/blob/main/pictures/match.png" width=50% height=50%>

Matching im Ursprungsgraphen
<br>

<img src="https://github.com/JulianEichen/BA_KL/blob/main/pictures/match_coarse.png" width=50% height=50%>

Graph nach einer Vergröberung
<br>
