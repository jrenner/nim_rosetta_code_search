import sys
import os
import shutil

if not os.path.exists('Task'):
    os.mkdir('Task')

def copy_task_file(fpath, task_name):
    task_dir = 'Task/{}'.format(task_name)
    if not os.path.exists(task_dir):
        os.mkdir(task_dir)
        print("created dir: {}".format(task_dir))
    fname = os.path.basename(fpath)
    outpath = os.path.join(task_dir, fname)
    print("copy file: {}".format(outpath))
    shutil.copyfile(fpath, outpath)

repo_path = sys.argv[1]
tasks_path = os.path.join(repo_path, 'Task')
assert os.path.exists(tasks_path)

for root, dirs, files in os.walk(tasks_path):
    if 'Nim' in root:
        for f in files:
            fullpath = os.path.join(root, f)
            fname = os.path.basename(f)
            pieces = fullpath.split('/')
            task_name = pieces[-3]
            print(task_name)
            copy_task_file(fullpath, task_name)
