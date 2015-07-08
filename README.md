# Slugify
Slugify is a MySQL function for creating slugs from strings.

It replaces all space characters with dashes, converts the upper-case english letters to lower-case and may use a temporary character map table to make an additional replacements.

Currently the slugify function includes a bulgarian( cyrillic ) letters map table. This means that for each bulgarin letter in the passed string an equvalent english letter will be used.

# Installation
From the command line:
```
mysql -h HOST -u USER -p DB_NAME < slugify_function.sql
```
Or directly copy the contents of the sql file and execute it in your favourite graphic interface for MySQL.


# Usage
```
SELECT SLUGIFY('My DiRtY Text That Has All these characters !@#$@#$%#$ in it') AS slug;
-- The result will be: my-dirty-text-that-has-all-these-characters-in-it
```

```
SELECT SLUGIFY(table.field AS field) FROM table;
```

# Customizing the replacement map table
In order to customize the replacement map all you need to do is replace line 36 from the sql file.
The line contains a character -> replacement pair values in the form:
`('а', 'a'), ('б', 'b'), ('в', 'v')...`
where the first character is the value you want to replace and the second is the value you want it replaced with.