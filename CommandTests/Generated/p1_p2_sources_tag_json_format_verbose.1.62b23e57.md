# Command
```json
["-p1", "{ios_project_1}", "-p2", "{ios_project_2}", "-g", "sources", "-f", "json", "-v"]
```

# Expected exit code
1

# Expected output
```
[
  {
    "context" : [
      "\"Project\" target"
    ],
    "differentValues" : [
      {
        "context" : "\/Project\/Group A\/ObjcClass.m compiler flags",
        "second" : "-ObjC"
      }
    ],
    "onlyInFirst" : [
      "\/Project\/Group B\/AnotherObjcClass.m"
    ],
    "onlyInSecond" : [

    ],
    "tag" : "sources"
  },
  {
    "context" : [
      "\"ProjectFramework\" target"
    ],
    "differentValues" : [

    ],
    "onlyInFirst" : [

    ],
    "onlyInSecond" : [

    ],
    "tag" : "sources"
  },
  {
    "context" : [
      "\"ProjectTests\" target"
    ],
    "differentValues" : [

    ],
    "onlyInFirst" : [
      "\/ProjectTests\/BarTests.swift"
    ],
    "onlyInSecond" : [

    ],
    "tag" : "sources"
  },
  {
    "context" : [
      "\"ProjectUITests\" target"
    ],
    "differentValues" : [

    ],
    "onlyInFirst" : [
      "\/ProjectUITests\/LoginTests.swift"
    ],
    "onlyInSecond" : [
      "\/ProjectUITests\/MetricsTests.swift"
    ],
    "tag" : "sources"
  }
]

```