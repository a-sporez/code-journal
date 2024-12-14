Lua string patterns are a powerful tool for text processing, and they are somewhat similar to regular expressions but simpler. Here’s a compact reference of commonly used Lua string patterns:

---

### **Character Classes**
1. **`.`**  
   - Matches **any character** except a newline (`\n`).
   - Example: `.` matches `"a"`, `"1"`, `"@"`, etc.

2. **`%a`**  
   - Matches **any letter** (a-z, A-Z).

3. **`%A`**  
   - Matches any character **not a letter**.

4. **`%d`**  
   - Matches any **digit** (0-9).

5. **`%D`**  
   - Matches any character **not a digit**.

6. **`%s`**  
   - Matches any **whitespace** (spaces, tabs, newlines).

7. **`%S`**  
   - Matches any character **not whitespace**.

8. **`%w`**  
   - Matches any **alphanumeric character** (a-z, A-Z, 0-9).

9. **`%W`**  
   - Matches any character **not alphanumeric**.

10. **`%x`**  
    - Matches any **hexadecimal digit** (0-9, a-f, A-F).

11. **`%z`**  
    - Matches the **null character** (ASCII 0).

12. **`[%set]`**  
    - Matches **any character in the set**.
    - Example: `[abc]` matches `"a"`, `"b"`, or `"c"`.  

13. **`[^%set]`**  
    - Matches **any character not in the set**.
    - Example: `[^abc]` matches everything except `"a"`, `"b"`, and `"c"`.

---

### **Modifiers**
1. **`+`**  
   - Matches **one or more** occurrences.
   - Example: `%d+` matches `"123"`, `"45"`, etc.

2. **`*`**  
   - Matches **zero or more** occurrences.
   - Example: `%s*` matches `"   "`, `""`, etc.

3. **`-`**  
   - Matches **zero or more** occurrences (non-greedy).
   - Example: `.-` stops at the first match.

4. **`?`**  
   - Matches **zero or one** occurrence.
   - Example: `a?` matches `"a"` or `""`.

5. **`^`**  
   - Anchors the match to the **start** of the string.

6. **`$`**  
   - Anchors the match to the **end** of the string.

---

### **Captures**
1. **`()`**  
   - Captures the matching substring for further processing.
   - Example: `"Hello World":match("(%w+) (%w+)")` captures `"Hello"` and `"World"`.

2. **`%n`**  
   - Refers to a captured pattern (e.g., `%1`, `%2`).

---

### **Escaping Special Characters**
To match special characters literally, prefix them with `%`.  
**Example**:  
- `%(`, `%)`, `%[`, `%]`, `%.`, `%+`, `%*`, `%?`, `%-`, `%^`, `%$`.

---

### **Examples**
1. **Match a word**:  
   - Pattern: `"%a+"`  
   - Matches: `"word"`, `"Lua"`, etc.

2. **Match a number**:  
   - Pattern: `"%d+"`  
   - Matches: `"123"`, `"42"`, etc.

3. **Trim whitespace**:  
   - Pattern: `"^%s*(.-)%s*$"`  
   - Removes leading and trailing spaces.

4. **Split string by delimiter**:  
   ```lua
   for part in string.gmatch("a,b,c", "[^,]+") do
       print(part)
   end
   ```

---

### Comprehensive Reference
For the full Lua string pattern documentation, visit the [Lua 5.1 Manual: Patterns](https://www.lua.org/manual/5.1/manual.html#5.4.1). It applies to later versions as well, as the pattern syntax hasn't changed significantly. Let me know if you'd like explanations for specific use cases!