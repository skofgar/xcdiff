# Command
```json
["-p1", "{ios_project_1}", "-p2", "{ios_project_2}", "-t", "Project"]
```

# Expected exit code
1

# Expected output
```
❌ FILE_REFERENCES
✅ TARGETS > NATIVE targets
✅ TARGETS > AGGREGATE targets
✅ HEADERS > "Project" target
❌ SOURCES > "Project" target
❌ RESOURCES > "Project" target


```