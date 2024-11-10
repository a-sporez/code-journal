What is the difference between pairs() and ipairs() in Lua?
Asked 5 years, 6 months ago
Modified 4 months ago
Viewed 145k times
130

In a for loop, what is the difference between looping with pairs() versus ipairs()?

The Programming in Lua book mentions both, however, both appear to generate similar outputs as shown below:

Using ipairs():

a = {"one", "two", "three"}
for i, v in ipairs(a) do
  print(i, v)
end
Output:

1   one
2   two
3   three
Using pairs():

a = {"one", "two", "three"}
for i, v in pairs(a) do
  print(i, v)
end
Output:

1   one
2   two
3   three
for-looplua
Share
Follow
edited Jul 7, 2023 at 10:55
Kyle F. Hartzenberg's user avatar
Kyle F. Hartzenberg
3,42733 gold badges1111 silver badges3535 bronze badges
asked Mar 11, 2019 at 19:12
user11071538
Add a comment
2 Answers
Sorted by:

Highest score (default)
205

ipairs() and pairs() are slightly different, as you can see in the reference manual. A less technical description could be that:

ipairs() returns index-value pairs and is mostly used for numeric tables. The non-numeric keys are ignored as a whole, similar to numeric indices less than 1. In addition, gaps in between the indices lead to halts. The ordering is deterministic, by numeric magnitude.

pairs() returns key-value pairs and is mostly used for associative tables. All keys are preserved, but the order is unspecified.

In addition, while pairs() may be used to get the size of a table (see this other question), using ipairs() for the same task is unsafe a priori, since it might miss some keys.

The differences between the two options are illustrated in the following code fragment:

> u = {}
> u[-1] = "y"
> u[0] = "z"
> u[1] = "a"
> u[3] = "b"
> u[2] = "c"
> u[4] = "d"
> u[6] = "e"
> u["hello"] = "world"
>
> for key, value in ipairs(u) do print(key, value) end
1       a
2       c
3       b
4       d
>
> for key, value in pairs(u) do print(key, value) end
1       a
2       c
3       b
4       d
6       e
0       z
hello   world
-1      y
> 
As we can see in the example, while all keys appear in the output for pairs(), some are missing for ipairs(): hello because it is not a numeric key; -1 and 0 since, despite being numeric, their value is less than 1, and; 6 given that we implicitly have u[5] = nil, and finding a nil value while iterating is exactly the ending condition for ipairs().

Finally, note that as in your example, when you create a table without specifying any of the keys, e.g., a = {"one", "two", "three"}, numeric keys starting in 1 are implicitly assigned to each of the values, i.e. the definition is understood as a = { [1] = "one", [2] = "two", [3] = "three" }. As a consequence, using pairs() or ipairs() is mostly the same in these scenarios, except for the non-guaranteed ordering of pairs().