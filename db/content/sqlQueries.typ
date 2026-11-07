= SQL Queries

== Query
```ednf
Query = subquery {("UNION" | "INTERSECT"
  | "EXCEPT") ["ALL" | "DISTINCT"] subquery} ";"
```
- `INTERSECT` = $inter$, `EXCEPT` = $without$; Default hier *`DISTINCT`*
- Beliebig verschachtelbar, liefert immer *eine* Tabelle

== SELECT (Projektion)
```ednf
subquery = "SELECT" ["ALL" | "DISTINCT"]
    attributeList "FROM" Datenquelle
attributeList = columnSpec {"," columnSpec} | "*"
columnSpec = scalarExpr ["AS" neuerName]
scalarExpr = (columnRef | literal)
    {("+" | "-" | "*" | "/") scalarExpr}
columnRef = [[schema "."] table "."] attr
```
- Default *`ALL`*; `SELECT a` $= pi_a$ (Bag), `SELECT DISTINCT a` $= delta(pi_a)$
- `*` = alle Attribute der Datenquelle; `AS` = Rename
- `columnRef` so weit qualifizieren, bis eindeutig
- Literal: `SELECT 1 FROM T` → je Tupel von `T` eine `1`
- *`DISTINCT` sparsam*: internes Sortieren $approx n log n$; überflüssig, wenn Resultat Schlüssel enthält
```sql
SELECT DISTINCT betrag FROM Salaer;
SELECT betrag * 1.025 AS neu FROM Salaer;
```

== Datenquelle (FROM)
```ednf
Datenquelle = tableExpr | joinExpr
tableExpr = [schema "."] table [["AS"] alias]
joinExpr = (tableExpr | "(" joinExpr ")")
  ["NATURAL" | ("LEFT" | "RIGHT" | "FULL") "OUTER"
   | "CROSS"] "JOIN" tableExpr ["ON" joinCondition]
joinCondition = attrComparison
    {("AND" | "OR") attrComparison}
attrComparison = ([table "."] attr | literal)
  theta ([table "."] attr | literal)
theta = "<" | "<=" | "=" | ">=" | ">" | "<>"
```

- `ON` nötig ausser bei `NATURAL` und `CROSS`
- `CROSS JOIN` = $times$; `NATURAL JOIN` = $bowtie$ (gleichnamige Attribute)
- Attributnamen nur innerhalb Tabelle eindeutig → bei Equi-Join `T.attr` qualifizieren
- Equi-Join hat *mehr Spalten* als Natural Join (dieser behält gemeinsame Attr. nur einmal); Natural Join immer als Equi-Join formulierbar
- Zusammengesetzter Schlüssel → *alle* Attribute in Join-Condition
```sql
SELECT name, ort FROM Person JOIN Mitarbeiter
  ON Person.pNr = Mitarbeiter.pNr;
SELECT BestellPosition.bestNr, posNr,
  BestellPosition.menge AS BestellMenge, lieferDatum
FROM (BestellPosition JOIN Enthaelt
    ON BestellPosition.bestNr = bNr AND posNr = pNr)
  JOIN Lieferung
    ON bNr = Lieferung.bestNr AND lNr = liefNr;
```
- *Subquery als Datenquelle*: PostgreSQL verlangt Alias (Bereichsvariable)
```sql
SELECT Name FROM (SELECT * FROM Person
  WHERE Name = 'Müller') AS x;
```

== WHERE (Selektion)
```ednf
searchCondition = "WHERE" ["NOT"] logicalComparison
  {("AND" | "OR") ["NOT"] logicalComparison}
logicalComparison = (attr | literal)
  {compareOp (attr | literal)}
compareOp = "<" | "<=" | "=" | ">=" | ">" | "<>"
  | "LIKE"
```
- Tupelfilter: nur Tupel mit Ausdruck *true* ins Resultat; `WHERE P` $= sigma_P$
- `SELECT a FROM R WHERE P` $= pi_a (sigma_P (R))$

#table(
  columns: 2,
  stroke: none,
  inset: 3pt,
  align: left,
  [`LIKE 'M__er'`], [Nur Strings; `_` = genau 1 Zeichen, `%` = beliebig viele],
  [`BETWEEN x AND y`], [Bereich (inkl. Grenzen)],
  [`IS NULL`], [*Nicht* `= NULL`!],
  [`[NOT] IN (...)`], [Liste von Literalen oder Subquery],
)
```sql
SELECT name FROM Zubehoerteile NATURAL JOIN PasstZu
WHERE modell IN ('Galaxy', 'iPhone');
```

=== Kurzform Join
`FROM a, b WHERE a.x = b.x` $equiv$ `FROM a JOIN b ON a.x = b.x` \
```sql
SELECT g.bname, g.rname, s.bsorte
FROM gast AS g, sortiment AS s
WHERE g.rname = s.rname AND g.bname = 'Anderegg';
```

== Ordnung
- Resultat-Reihenfolge nicht garantiert
- `ORDER BY a, b [DESC]` (Default aufsteigend)
- Gleichwertige Tupel können weiterhin umsortiert werden → Sortierkriterium muss Schlüssel enthalten für stabile Ordnung
- Spalten immer in definierter Reihenfolge

=== Lexikographische Ordnung
Nicht direkt ausdrückbar: \
$chevron.l a,b,c chevron.r < chevron.l x,y,z chevron.r <=> (a<x) or (a=x and b<y) or (a=x and b=y and c<z)$
```sql
-- zwischen <Meier, Hans> und <Schmid, Joseph>
WHERE (Name = 'Meier' AND Vorname >= 'Hans')
   OR (Name > 'Meier' AND Name < 'Schmid')
   OR (Name = 'Schmid' AND Vorname <= 'Joseph')
```

== EXISTS
- Existenzbedingung: true, falls Subquery $>= 1$ Tupel liefert; "innere Schleife" pro äusserem Tupel (korreliert)
- Gleiche Tabelle zweimal → *Bereichsvariablen* (Aliase) nötig, sonst `Vorname = Vorname` immer wahr
```sql
-- Besucher, deren Vorname ein anderer auch hat
SELECT * FROM Besucher AS x
WHERE EXISTS (SELECT 1 FROM Besucher AS y
  WHERE x.Vorname = y.Vorname
    AND NOT (x.Name = y.Name));
```
