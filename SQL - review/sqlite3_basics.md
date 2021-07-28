Yuanfeng Li
20210728

- the idea from leetcode #196. Delete Duplicate Emails

```

## Create
# create table in sqlite3 to test my thoughts

# first create a db, so you can access what you have built
sqlite3 alibaba.db # create if not exists.

CREATE Table Person (
    Id INTEGER PRIMARY KEY,
    Email TEXT
);

CREATE Table IF NOT EXISTS Person(
    Id INTEGER PRIMARY KEY,
    Email TEXT
);

# how to drop table
DROP TABLE IF EXISTS Person;

# see if there is still tables
.table

# INSERT
INSERT INTO Person (Id, Email)
VALUES
    (1, 'john@example.com'),
    (2, 'bob@example.com'),
    (3, 'john@example.com')

.table

SELECT * FROM Person

# better view:
.mode column
.header on

# (https://www.oreilly.com/library/view/using-sqlite/9781449394592/re63.html)

# now I can finally join it with itself!
SELECT *
FROM Person p1, Person p2
WHERE p1.Email = p2.Email;

# what did I say man! this is the double for loop!! Now i
'''
Id          Email             Id          Email
----------  ----------------  ----------  ----------------
1           john@example.com  1           john@example.com
1           john@example.com  3           john@example.com
2           bob@example.com   2           bob@example.com
3           john@example.com  1           john@example.com
3           john@example.com  3           john@example.com

'''

# New Selection!
SELECT *
FROM Person p1, Person p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id;

'''
Id          Email             Id          Email
----------  ----------------  ----------  ----------------
3           john@example.com  1           john@example.com


'''




```
