
.mode column
.header ON

CREATE TABLE Payroll (
  UserID INT PRIMARY KEY,
  Name VARCHAR(256),
  Job VARCHAR(256),
  Salary INT);



INSERT INTO Payroll
VALUES (123, 'Jack', 'TA', 50000);


INSERT INTO Payroll
VALUES (345, 'Allison', 'TA', 60000),
       (567, 'Magda', 'Prof', 90000),
       (789, 'Dan', 'Prof', 100000);


SELECT P.Name, P.UserID
  FROM Payroll AS P
 WHERE P.Job = ‘TA’;


INSERT INTO Payroll
VALUES (1, 'Ryan', 'Prof', 100000000);


DELETE FROM Payroll
      WHERE UserID = 1;




CREATE TABLE Regist (
  UserID INT REFERENCES Payroll,
  Car VARCHAR(256));

INSERT INTO Regist
VALUES (123, 'Charger'),
       (567, 'Civic'),
       (567, 'Pinto');

-- inner join
SELECT P.Name, R.Car
  FROM Payroll AS P JOIN Regist AS R
       ON P.UserID = R.UserID;

-- left (outer) join
SELECT P.Name, R.Car
  FROM Payroll AS P LEFT OUTER JOIN Regist AS R
       ON P.UserID = R.UserID;

.nullvalue 'NULL'
-- try the same query again


-- self join
SELECT P.Name, R.Car
FROM Payroll AS P, Regist AS R
WHERE P.UserID = R.UserID AND
       R.Car='Civic' AND
       R.Car='Pinto';

SELECT P.Name, R1.Car, R2.Car
  FROM Payroll AS P, Regist AS R1, Regist AS R2
 WHERE P.UserID = R1.UserID AND
       P.UserID = R2.UserID ;


-- all pairs of cars
SELECT P.Name, R1.Car, R2.Car
  FROM Payroll AS P, Regist AS R1, Regist AS R2
 WHERE P.UserID = R1.UserID AND
       P.UserID = R2.UserID ;

-- Full self join
SELECT P.Name, R1.Car, R2.Car
  FROM Payroll AS P, Regist AS R1, Regist AS R2
 WHERE P.UserID = R1.UserID AND
       P.UserID = R2.UserID AND
       R1.Car = ‘Civic’ AND
       R2.Car = ‘Pinto’;



