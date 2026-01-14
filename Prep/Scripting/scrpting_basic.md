I'll search for the best Python scripting interview questions related to file operations and text processing.Let me search for more specific questions about text processing and file search operations.Based on my research, I've compiled a comprehensive list of 25 Python scripting interview questions with answers, focused on file operations and text processing. Here they are:

## **25 Python Scripting Interview Questions & Answers: File Operations & Text Processing**

### **Basic File Handling Questions**

**1. How do you open and close files in Python?**
**Answer:** Use the `open()` function with the file path and mode. Always close files using the `close()` method or use the `with` statement for automatic closing:
```python
# Manual closing
f = open("file.txt", "r")
content = f.read()
f.close()

# With statement (recommended)
with open("file.txt", "r") as f:
    content = f.read()
```

**2. Explain the different file opening modes in Python.**
**Answer:** 
- `'r'` - Read mode (default)
- `'w'` - Write mode (overwrites existing content)
- `'a'` - Append mode (adds to end of file)
- `'r+'` - Read and write
- `'w+'` - Write and read (creates new file)
- `'rb'`, `'wb'` - Binary read/write modes

**3. What is the difference between `read()`, `readline()`, and `readlines()`?**
**Answer:**
- `read()` - Reads entire file content as a single string
- `readline()` - Reads one line at a time
- `readlines()` - Reads all lines and returns them as a list of strings

**4. How do you write data to a file in Python?**
**Answer:** Use `write()` for a single string or `writelines()` for a list of strings:
```python
with open("file.txt", "w") as f:
    f.write("Hello World\n")
    
# For multiple lines
lines = ["Line 1\n", "Line 2\n"]
with open("file.txt", "w") as f:
    f.writelines(lines)
```

**5. What is the purpose of the `with` statement in file handling?**
**Answer:** The with statement works with context managers and automatically handles file closing when the block ends, even if exceptions occur. This makes code cleaner, safer, and easier to maintain.

### **File Operations & Error Handling**

**6. How do you check if a file exists before opening it?**
**Answer:** Use `os.path.exists()` or `pathlib.Path.exists()`:
```python
import os
if os.path.exists("file.txt"):
    with open("file.txt", "r") as f:
        content = f.read()
```

**7. What is the difference between text mode and binary mode?**
**Answer:** Binary mode treats the file as binary data, preserving newline characters, while text mode processes the file as text and automatically handles newline conversions.

**8. How do you handle file exceptions in Python?**
**Answer:** Use try-except blocks to handle exceptions. The finally block ensures the file is closed even if an error occurs.
```python
try:
    with open("file.txt", "r") as f:
        content = f.read()
except FileNotFoundError:
    print("File not found")
except IOError:
    print("Error reading file")
```

**9. What is the purpose of the `flush()` method?**
**Answer:** The flush() method forces any buffered data to be written to the file immediately, useful when you want to ensure data is written without waiting for the buffer to fill.

**10. How do you get the size of a file in Python?**
**Answer:** Use `os.path.getsize()`:
```python
import os
size = os.path.getsize("file.txt")
```

### **Text Processing & Search**

**11. How do you search for a specific string in a text file?**
**Answer:** Read the file line by line and use the `in` operator to check if the search string is present in each line.
```python
def search_string(file_path, search_term):
    with open(file_path, 'r') as file:
        for line_num, line in enumerate(file, 1):
            if search_term in line:
                print(f"Line {line_num}: {line.strip()}")
```

**12. How do you perform case-insensitive text search in a file?**
**Answer:** Convert both the search term and file content to lowercase:
```python
def search_case_insensitive(file_path, search_term):
    with open(file_path, 'r') as file:
        for line in file:
            if search_term.lower() in line.lower():
                print(line.strip())
```

**13. How do you use regular expressions to search patterns in a file?**
**Answer:** Use the re module's search() or findall() functions to search for patterns within file contents.
```python
import re
def search_with_regex(file_path, pattern):
    with open(file_path, 'r') as file:
        content = file.read()
        matches = re.findall(pattern, content)
        return matches
```

**14. How do you count the number of lines in a file?**
**Answer:**
```python
with open("file.txt", "r") as f:
    line_count = sum(1 for line in f)
print(line_count)
```

**15. How do you count word frequency in a text file?**
**Answer:**
```python
from collections import Counter

with open("file.txt", "r") as f:
    words = f.read().split()
    frequency = Counter(words)
    print(frequency)
```

### **Advanced File Operations**

**16. How do you read a file in chunks for large files?**
**Answer:**
```python
def read_in_chunks(file_path, chunk_size=1024):
    with open(file_path, 'r') as file:
        while True:
            chunk = file.read(chunk_size)
            if not chunk:
                break
            process(chunk)
```

**17. How do you read the last N lines of a file?**
**Answer:**
```python
def read_last_n_lines(file_path, n):
    with open(file_path, 'r') as f:
        lines = f.readlines()
        return lines[-n:]
```

**18. How do you replace text in a file?**
**Answer:**
```python
with open("file.txt", "r") as f:
    content = f.read()
    
content = content.replace("old_text", "new_text")

with open("file.txt", "w") as f:
    f.write(content)
```

**19. What is pickling in Python?**
**Answer:** Pickling is the process of serializing an object into a byte stream format that can be stored and later deserialized back to the original object using the pickle module.

**20. How do you work with CSV files in Python?**
**Answer:** Use the `csv` module or `pandas`:
```python
import csv
with open("data.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
```

### **Practical Scripting Questions**

**21. How do you find all files with a specific extension in a directory?**
**Answer:**
```python
import os
import glob

# Method 1
files = glob.glob("*.txt")

# Method 2
for file in os.listdir("."):
    if file.endswith(".txt"):
        print(file)
```

**22. How do you recursively search for files in subdirectories?**
**Answer:**
```python
import os
for root, dirs, files in os.walk("directory"):
    for file in files:
        if file.endswith(".txt"):
            print(os.path.join(root, file))
```

**23. How do you copy or move files in Python?**
**Answer:**
```python
import shutil
# Copy file
shutil.copy("source.txt", "destination.txt")
# Move file
shutil.move("source.txt", "new_location/")
```

**24. How do you handle different file encodings?**
**Answer:** Specify the encoding when opening a file using the encoding parameter, like `open('file.txt', 'r', encoding='utf-8')`.

**25. How do you read a file and remove blank lines?**
**Answer:**
```python
with open("file.txt", "r") as f:
    lines = [line for line in f if line.strip()]
    
with open("output.txt", "w") as f:
    f.writelines(lines)
```

These questions cover essential Python scripting concepts for file handling and text processing, which are commonly asked in technical interviews. Practice implementing these solutions to gain confidence!