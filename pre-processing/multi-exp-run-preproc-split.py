import os, os.path
import shutil
from tkinter import Tk
from tkinter.filedialog import askdirectory
import argparse, sys

parser = argparse.ArgumentParser()
parser.add_argument('--datapath', type=str,
                    help='Path to dataset for multi exp run pre-processing')
parser.add_argument('--ratio', type=int,
                    help='Number of times to split dataset')
args = parser.parse_args()
if len(sys.argv)==1:
    parser.print_help(sys.stderr)
    sys.exit(1)

args=parser.parse_args()


count = int(args.ratio) # number of subdirectories

folder_path = str(args.datapath) # path to dataset
print(folder_path)  

os.chdir(folder_path) # change directory from working dir to dir with files

images = [f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))]

step = int(len(images) / count) + 1
for i in range(1, (count + 1)):
    folder_name = f'subdirectory_{i}'

    new_path = os.path.join(folder_path, folder_name)
    if not os.path.exists(new_path):
        os.makedirs(new_path)
    for i in range(1,step):
        image = images.pop()
        old_image_path = os.path.join(folder_path, image)
        new_image_path = os.path.join(new_path, image)
        shutil.move(old_image_path, new_image_path)
    
        
