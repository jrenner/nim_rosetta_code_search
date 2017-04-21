import strfmt
import os
import strutils

proc toLower(s: string): string = return s.toLowerAscii

proc `*`(s: string, num: int): string =
    var res = ""
    for i in 1..num:
        res &= s
    return res

let dashed_line = "=" * 100

let ROSETTA_NIM_PATH = joinPath("/Lang/Nim")

type
    TaskEntry = ref object
        name: string
        fullpath: string

proc `$`(t: TaskEntry): string =
    return "(name: " & t.name & ", fullpath: " & t.fullpath & ")"
        
proc get_nim_tasks(): seq[TaskEntry] =
    var tasks = newSeq[TaskEntry]()
    let search_path = ROSETTA_NIM_PATH
    for kind, path in walkDir(search_path, relative=false):
        let basename = extractFileName(path)
        var task = TaskEntry(name: basename, fullpath: path)
        if kind == pcLinkToDir:
            tasks.add(task)
    return tasks


proc choose_match(matches: seq[TaskEntry]): TaskEntry =
    for i in 0..matches.len-1:
        echo "[{}] {}".fmt(i, matches[i].name)
    stdout.write "choose number: "
    let input = readLine(stdin)
    let n = parseInt(input)
    return matches[n]


let tasks = get_nim_tasks()

var search_terms = newSeq[string]()

for i in 1..paramCount():
    let search_term = paramStr(i)
    search_terms.add(search_term)
#echo search_terms

var matches = newSeq[TaskEntry]()
for task in tasks:
    var good_match = true
    for search_term in search_terms:
        if not (search_term.toLower in task.name.toLower):
            good_match = false
    if good_match:
        matches.add(task)

echo "found {} tasks matching search terms: {}".fmt(matches.len, search_terms)
var choice: TaskEntry = nil
if matches.len > 1:
    choice = choose_match(matches)
elif matches.len == 1:
    choice = matches[0]
else:
    echo "no matches found"
    quit(QuitSuccess)


for f in walkDir(choice.fullpath):
    echo "file: ", f.path
    echo dashed_line
    for line in lines(f.path):
        echo line
    echo dashed_line
