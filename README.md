# sql-cookbook
Commonly used sql code snippets for reusability.


Miscellaneous:

1. Do not use `in` or `not in` when the list has NULL values in it.
   - 3 in (1,2,NULL) => NULL
   - 3 not in (1,2,NULL) => NULL
