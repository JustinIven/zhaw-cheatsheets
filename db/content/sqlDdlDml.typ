= SQL DDL, DML

== Grundlagen
- *Tabellen* statt Relationen: streng genommen *relationale Bags* (Duplikate erlaubt, Abfragen können Duplikate liefern)
- Tupel *nicht geordnet* → kein "gib 10. Tupel"; Attributreihenfolge beliebig, einmal festgelegt aber relevant ($chevron.l A, B chevron.r != chevron.l B, A chevron.r$ als Schlüssel)
- Jedes Tupel eindeutig identifizierbar → Unique-Schlüssel nötig
- *ER → Tabellen:* jeder Entitäts- *und* Beziehungstyp → Relationenformat → Tabelle; alle FK-Attribute aufführen, PK unterstreichen; Spalten = Attribute (Struktur), Zeilen = Tupel (Daten)

#table(
  columns: 3,
  stroke: none,
  inset: 3pt,
  align: left,
  [], [*DDL* (Struktur)], [*DML* (Inhalt)],
  [Erzeugen], [`CREATE`], [`INSERT`],
  [Ändern], [`ALTER`], [`UPDATE`],
  [Löschen], [`DROP`], [`DELETE`],
)

== DDL
=== Schema (Datenbank)
```
"CREATE SCHEMA" <dbName>
    ["AUTHORIZATION" <userName>] ";"
"DROP SCHEMA" <dbName> ["CASCADE"] ";"
```
- Auch `CREATE DATABASE`; `dbName` eindeutig; `userName` = Besitzer, nur er darf löschen
- `DROP` löscht per Default nur leeres Schema; `CASCADE` löscht alle Elemente ohne Rückfrage
- *Elemente:* Tabellen, Constraints (DB-, Tabellen-, Attribut-Ebene), Indizes, Stored Procedures, Trigger (letzte 3 nicht standardisiert/proprietär)

=== Datentypen
#table(
  columns: 2,
  stroke: none,
  inset: 3pt,
  align: left,
  [`CHAR(n)`, `CHARACTER(n)`], [Zeichenkette, fixe Länge],
  [`VARCHAR(n)`, `CHAR VARYING(n)`], [Zeichenkette, variable Länge],
  [`INT`, `INTEGER`], [Ganzzahl],
  [`REAL`], [Fliesskommazahl],
  [`NUMERIC(p,s)`, `DECIMAL(p,s)`], [Festkommazahl],
)

=== Domain
```
"CREATE DOMAIN" <domainName> "AS"
    dataType ["(" domain ")"]
    [attributeConstraintDef] ";"
"DROP DOMAIN" <domainName> ";"
```
- Constraint auf *DB-Ebene*: Wertebereich gilt im ganzen Schema, einmal zentral definiert/gepflegt; v.~a. für Schlüssel-Attribute, ausführliche Formate
- Bsp.: `CREATE DOMAIN ssn_type AS CHAR(9);` → Verwendung: `ssn ssn_type,`

=== CREATE TABLE
```
"CREATE TABLE" <tableName>
  "(" tableElementDef {"," tableElementDef} ");"

tableElementDef ::= columnDef | tableConstraintDef

columnDef ::= <attributeName>
    dataType ["(" domain ")"]
    [attributeConstraintDef]

attributeConstraintDef ::=
    ["CONSTRAINT" <constraintName>]
    {"DEFAULT" defaultClause | "NOT NULL"
     | "CHECK" "(" checkCondition ")"}

defaultClause ::=
    "NULL" | <constant> | <systemVariable>

tableConstraintDef ::=
    ["CONSTRAINT" <constraintName>]
    tableConstraintType

tableConstraintType ::= CHECK mit mehreren Attr.
  | "UNIQUE (" <attr> {"," <attr>} ")"
  | "PRIMARY KEY (" <attr> {"," <attr>} ")"
  | "FOREIGN KEY (" <attr> {"," <attr>} ")"
    "REFERENCES" <tableName>
    ["(" <attr> {"," <attr>} ")"]
    [FK-Trigger {FK-Trigger}]
```
```sql
CREATE TABLE person (
  name varchar(20) NOT NULL,
  vorname varchar(20) DEFAULT ('jim'),
  alter int CHECK (alter > 20),
  accept CHAR(1) CONSTRAINT aval
    CHECK (accept='Y' OR accept='N'),
  CONSTRAINT personPK PRIMARY KEY (name, vorname)
);
```

=== Constraints
- *Benennen empfohlen:* nur benannte Constraints (einfach) änderbar/löschbar
- *PostgreSQL:* `NOT NULL` nicht benennbar (`CONSTRAINT c NOT NULL` geht nicht; `CHECK(B IS NOT NULL)` theoretisch, unüblich) → `ALTER ... SET/DROP NOT NULL`
- *CHECK:* Ausdruck → true/false; bei Dateneingabe automatisch geprüft; vergleicht mit Konstanten oder Attributen *derselben* Tabelle. Mehrere Attribute → Table-Constraint (nach Attributdefinitionen). Zentrale Einschränkung, sonst muss *jede* Anwendung prüfen
- *UNIQUE:* mehrere pro Tabelle möglich (Schlüssel); DBMS prüft Eindeutigkeit \
  `CONSTRAINT BesitztUni UNIQUE(pNr, Modell)`
- *PRIMARY KEY:* höchstens 1 pro Tabelle; nötig, wenn per FK referenziert, sonst genügt UNIQUE \
  `CONSTRAINT BestPosPK PRIMARY KEY(bestNr, posNr)`
- *FOREIGN KEY:* minimal `FOREIGN KEY (a) REFERENCES T`; ohne Attributliste → *PK* von `T` referenziert (andere Attribute möglich, abzuraten). DBMS sichert *referentielle Integrität* (Eingabe, Löschen)

=== FK-Trigger
```
FK-Trigger ::= ("ON DELETE" | "ON UPDATE")
  ("NO ACTION" | "SET NULL" | "SET DEFAULT"
   | "CASCADE")
```
Automatische Aktionen, ausgelöst durch Änderung *in der referenzierten Tabelle*:
#table(
  columns: (auto, 1fr),
  stroke: none,
  inset: 3pt,
  align: left,
  [`ON UPDATE`], [Tupel in referenzierter Tabelle geändert/eingefügt],
  [`ON DELETE`], [Tupel in referenzierter Tabelle gelöscht],
  [`NO ACTION`], [Aktion verboten, falls FK danach auf keinen gültigen PK mehr zeigt],
  [`SET NULL`/`DEFAULT`], [FK auf NULL/Default setzen (SET NULL vermeiden)],
  [`CASCADE`], [Update: FK-Werte angepasst.\ Delete: referenzierende Tupel gelöscht.],
)
```sql
CONSTRAINT PasstZuFK1 FOREIGN KEY (Modell)
  REFERENCES Smartphone
  ON UPDATE CASCADE ON DELETE CASCADE,
```
→ Modell umbenannt: `PasstZu` übernimmt neuen Namen; Modell gelöscht: zugehörige `PasstZu`-Tupel gelöscht

=== ALTER TABLE
```
"ALTER TABLE" <tableName> action ";"
action ::= "ADD" <column> | "DROP" <column>
  | "ALTER" <column> | "ADD" constraint
  | "DROP" constraint
```
- Jede Ebene änderbar: Table → TableElement → ElementConstraintDef
- `ADD`: neues Attribut, Table-Constraint, Attribut-Constraint (teilweise)
- `DROP` Attribut/Constraint mit `RESTRICT` (verboten, solange Constraints/Views es referenzieren) oder `CASCADE` (abhängige Unique/FK werden "gebrochen")
```sql
ALTER TABLE HatGeliefert ADD menge INT NOT NULL
  CONSTRAINT hatGelMengePos CHECK(menge>0);
ALTER TABLE HatGeliefert
  DROP CONSTRAINT hatGelMengePos;
ALTER TABLE HatGeliefert ALTER menge SET DEFAULT 1;
ALTER TABLE HatGeliefert DROP eanNr CASCADE;
ALTER TABLE Zubehoerteil ALTER name SET NOT NULL;
ALTER TABLE Zubehoerteil ALTER name DROP NOT NULL;
```
- `SET/DROP NOT NULL`: proprietäre PostgreSQL-Erweiterung
- Mehrere Änderungen in einem `ALTER` = Erweiterung: PostgreSQL `ADD a int, ADD b char(20)`, Oracle `ADD (a int, b char(20))`

=== DROP TABLE
```
"DROP TABLE" <tableName> {"," <tableName>}
    ["CASCADE" | "RESTRICT"] ";"
```
- Löscht Tabelle inkl. Struktur; hängen Objekte ab (z.~B. FKs) → `CASCADE` nötig

== DML
=== INSERT
```
"INSERT INTO" <tableName> ["(" attrList ")"]
    ("VALUES (" valueList ")") | query ";"
```
- Fügt immer *ganze Tupel* ein; Reihenfolge `attrList` ↔ `valueList` muss übereinstimmen
```sql
INSERT INTO Salaer VALUES (12, 35000, 24, 5, 2003);
INSERT INTO Salaer (pNr, betrag)
  VALUES (12, 35000);
```

=== UPDATE
```
"UPDATE" <tableName> "SET" <attr> "=" <wert>
    {"," <attr> "=" <wert>}
    ["WHERE" searchCondition] ";"
```
- 4 Grundrechenoperationen erlaubt: `UPDATE Salaer SET betrag = 1.05 * betrag;`
- Ohne `WHERE` → alle Tupel
```sql
UPDATE Salaer SET betrag = 1.05 * betrag WHERE pNr = 12;
```

=== DELETE
```
"DELETE FROM" <tableName>
    ["WHERE" searchCondition] ";"
```
- Löscht immer *ganze Tupel*; *ohne Bedingung → ganze Tabelle geleert!*
- Einzelnes Attribut "löschen" → `UPDATE ... SET betrag = NULL WHERE ...`
```sql
DELETE FROM Salaer WHERE pNr = 12;
```
