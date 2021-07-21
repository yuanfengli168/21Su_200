# Week0 Review

- Author: Yuanfeng Li
- Date: 07/21/2021

## Knowledges:

- Set semantics:
  No duplicate tupes

- Tuples: equal to rows,records(each row in the table relation)

- table relation: == table

- Order not matter, the order of rows/tuples/records not matter in each table relation

- tables are flat!
  No sub - tables in an original table are allowed.

- SQL only works on relational databases
- Not for general purpose programming, and is **Logical level of interaction with data**

## Recap - Basic SQL query

- simple query, notice, the query returns you a new table instead of original table relation

```
SELECT *
FROM Payroll
```

- Notice the **EQUAL** sign here is '=' one single equal!
- Also, there might be an semicolon at the end of the query. ';'
- Also, "Payroll AS P" makes P an alias, you can also delete "AS". This lets us specify that the attributes come from Payroll.

```
SELECT P.Name, P.UserID
FROM Payroll AS P
WHERE P.Job = 'TA';
```

## Key Points:

- Creating tables
- Keys -> Identification
- Foreign Keys -> Relationships
- Joins in SQL and RA:
  1. Inner Joins
  2. Outer Joins
  3. Self Joins

### Create table:

- Every thing is case-insensitive, but having our own guidelines is useful for readability.

```
CREATE TABLE Payroll(
    UserID INT,
    Name VARCHAR(100),
    Job VARCHAR(100),
    Salary INT
);
```

- Key:
  A Key is one or more attributes that uniquely identify a row.
  Once we had a unique Identifier, we use the PRIMARY KEY to make it unique.
  Payroll(<ins>UserId</ins>, Name, Job, Salary)

```
CREATE TABLE Payroll (
    UserID INT PRIMARY KEY,
    Name VARCHAR(100),
    Job VARCHAR(100),
    Salary INT
);
```

- Foreign Key: A **Foreign Key** is one or more attributes that uniquely identidy a row in another table.
  We now have a regist table that references from Payroll table

```
CREATE TABLE Regist(
    UserID INT REFERENCES Payroll(UserID),
    Car VARCHAR(100)
);

OR, when the attribute name is the same:

CREATE TABLE Regist(
    UserID INT REFERENCES Payroll,
    Car VARCHAR(100)
)
```

- Alternatively, if yor foreign key is also more than one attribute:

```
CREATE TABLE Payroll (
    UserID INT,
    Name VARCHAR(100),
    Job VARCHAR(100),
    Salary INT,
    PRIMARY KEY(UserID,
    Name)
);

CREATE TABLE Regist(
    UserID INT,
    Name VARCHAR(100),
    Car VARCHAR(100),
    FOREIGN KEY (UserID, Name) REFERENCES Payroll
);

```

### Join

- Forign keys are able to describe a relationship between tables
- Joins are able to realize combinations of data

- Bread and butter of SQL queries
  - "Inner join" is often interchangeable with just "join"

```
(Implicit Inner Join)
SELECT P.Name, R.Car
FROM Payroll as P, Regist as R
WHERE P.UserID = R.UserID;

(Explicit Inner Join)
SELECT P.Name, R.Car
From Payroll as P Join Regist as R
ON P.UserID = R.UserID;
```

### Outer Joins

▪ LEFT OUTER JOIN
• All rows in left table are preserved

▪ RIGHT OUTER JOIN
• All rows in right table are preserved

▪ FULL OUTER JOIN
• All rows are preserved

## Practices:

1. Find all people who drive a Civic

```
SELECT P.Name, R.Car
FROM Payroll as P Join Regist as R
ON P.UserID = R.UserID
WHERE R.Car = 'Civic';

(From the lecture slide is below)
SELECT P.Name, R.Car
FROM Payroll AS P, Regist AS R
WHERE P.UserID = R.UserID AND
R.Car = 'Civic';
```

2. **Find all people who drive a Civic and Pinto**

```
SELECT P.Name, R1.Car
FROM Payroll AS P, Regist AS R1, Regist AS R2
WHERE P.UserID = R1.UserID AND
    P.UserID = R2.UserID AND
    R1.Car = 'Civic' AND
    R2.Car = 'Pinto';
```

### A little extra SQL:

```
SELECT P.Name, P.UserID
FROM Payroll AS P
WHERE P.Job = 'TA'
ORDER BY P.Salary, P.Name;

SELECT DISTINCT P.Job
FROM Payroll AS P
WHERE P.Salary > 70000;
```

## Date exploration:

```
SELECT COUNT(*)
FROM Payroll;

```

- full outer join with every possible pari "Cross product" do not need join predict.

```
SELECT P.Name, R.Car
FROM Payroll AS P, Regist AS R
```

## Aggregates

- New class of SQL queries.
  - GROUP BY, HAVING clauses in SQL
     The witnessing problem

### Actionable results:

**- We need summaries of data because we are often
trying to make decisions and succinctly convey
information**

• “How popular is this tv-show?” -> COUNT

• “Do I spend too much on coffee?” -> SUM

• “Am I being ripped off by this dealer?” -> AVG

• “Who got the highest grade in the class?” -> MAX

• “What’s the cheapest food on the Ave?” -> MIN

```
SELECT COUNT(*) FROM StreamingViews

SELECT SUM(cost) FROM CoffeeReceipts

SELECT AVG(price) FROM CarDealers

SELECT MAX(score) FROM StudentGrades

SELECT MIN(price) FROM AveLunchPrices
```

### Witnessing problem, very important!

- the **witnessing problem** in lect05:
  (_SQLite allowed but it shouldn't!!_)
  - **SELECT, HAVING, ORDER BY
    Must use aggregate functions
    or attributes in GROUP BY**
  - 自己 table relation 的 attributes 不能互相等于。
  - 所以此处用了 P2, 并且，group by, 和 aggregate function 必须在同一个 original table relation 上。

```
Do not select attributes not in either GROUP BY clause or an aggregate function.

correct versions/e.g.s
(the following one works!)
SELECT Job, MAX(Salary)
FROM Payroll
GROUP BY Job
```

**Very Important**

```
(the following one works!)
SELECT P1.Name, MAX(P2.Salary)
FROM Payroll AS P1, Payroll AS P2
WHERE P1.Job = P2.Job
GROUP BY P2.Job, P1.Salary, P1.Name
HAVING P1.Salary = MAX(P2.Salary)

```

### **The Witness problem simplified! (lec07 - 08)**

- the same question:

  - Return the person (or people) with the highest salary for each job type

- Wanted to join respective maxima
  - GROUP BY technique was interesting
  - People have suggested that we can just compute the maxima first then join

```
WITH MaxPay AS
    (SELECT P1.Job AS Job,
    MAX(P1.Salary) AS Salary
    FROM Payroll AS P1
    GROUP BY P1.Job)
SELECT P.Name, P.Salary
FROM Payroll AS P, MaxPay AS MP
WHERE P.Job = MP.Job AND
P.Salary = MP.Salary
```

## Set Operations:

SQL mimics set theory in many ways, but with
duplicates

- Instead of sets, called bags = duplicates allowed
- UNION (ALL)  set union (bag union)
- INTERSECT (ALL)  set intersection (bag intersection)
- EXCEPT (ALL)  set difference (bag difference)

- SQL set-like operators basically slap two queries
  together (not really a subquery…)

```
(SELECT * FROM T1)
UNION
(SELECT * FROM T2)

```

- **Usually best to avoid nested queries if trying for
  speed**
- Be careful of semantics of nested queries
  • Correlated vs. decorrelated
-  Think about edge cases
  • Zero matches
  • Null values

<h1>Subqueries in WHERE/HAVING</h1>

Q: Find the name and salary of people who do not drive cars

```
(correlated/nested)
SELECT P.Name, P.Salary
FROM Payroll AS P
WHERE NOT EXISTS (SELECT *
                  FROM Regist AS R
                  WHERE P.UserID =
                  R.UserID);

(Decorrelated!)
SELECT P.Name, P.Salary
FROM Payroll AS P
WHERE P.UserID NOT IN (SELECT UserID
FROM Regist);
```

<h3>Subqueries in Where</h3>

```
SELECT ……….. WHERE EXISTS (sub);

SELECT ……….. WHERE NOT EXISTS (sub);

SELECT ……….. WHERE attribute IN (sub);

SELECT ……….. WHERE attribute NOT IN (sub);

SELECT ……….. WHERE value > ANY (sub);

SELECT ……….. WHERE value > ALL (sub);
```

- **Exists, correlated(because it usually use 'SELECT _') since it needs to be a table.
  IN/NOT IN are decorrelated, since it do not need 'SELECT _')**

### Existential quantifiers:

Q:

Product (pname, price, cid)

Company (cid, cname, city)

Return all companies such that there exists some product they make with price < 200

```
SELECT DISTINCT C.cname
FROM Company C
WHERE EXISTS (SELECT *
              FROM Product P
              WHERE C.cid = P.cid and P.price < 200)

SELECT DISTINCT C.cname
FROM Company C
WHERE C.cid IN (SELECT P.cid
                FROM Product P
                WHERE P.price < 200)


Unnested version:

SELECT DISTINCT C.cname
FROM Company C, Product P
WHERE C.cid = P.cid and P.price < 200

```

- ANY

看不懂了，lec08:
ANY not supported
in sqlite

```
SELECT DISTINCT C.cname
FROM Company C
WHERE 200 > ANY (SELECT price
                FROM Product P
                WHERE P.cid = C.cid)

```

# Take Away:

- Please review the lec04 again, many concepts in relational algebra were taught here.

- Please review lec06, I haven't done it today, 210721.

- Review lec07, subqueries again, I am lost when I was reviewing it.

- Exists, correlated(because it usually use 'SELECT _') since it needs to be a table.
  IN/NOT IN are decorrelated, since it do not need 'SELECT _')

- The thing after Universal Quantifiers have **not been reviewed** in lec07-lec08.
