import tkinter as tk
from datetime import datetime
from tkinter.filedialog import askopenfilename, asksaveasfilename


def record_video():
    """Save the current file as a new file."""
    date = datetime.now().strftime("%Y-%m-%d")
    video_dir = filename_entry.get() + '_' + date
    print(video_dir)
    
    




def preview_video():
    """Open a file for editing."""
    


window = tk.Tk()
window.title("CAMPY Graphic User Interface")

window.rowconfigure(0, minsize=100, weight=1)
window.columnconfigure(1, minsize=300, weight=1)
window.resizable(width=False, height=False)

frame_filename = tk.Frame(master=window)
filename_label = tk.Label(master = frame_filename, font = 10, text = "File Name")
filename_entry = tk.Entry(master = frame_filename, width = 25)
filename_entry.grid(row = 0, column = 1, sticky = 'w')
filename_label.grid(row = 0, column = 0, sticky = 'nsew')


btn_Preview   = tk.Button(master = window, width=15, height=2, font = 10,  text="PreView Video", command = preview_video)
btn_Recording = tk.Button(master = window, width=15, height=2, font = 10, text="Recording...", command = record_video)

frame_filename.grid(row=0, column=0, padx=10)
btn_Preview.grid(row=0, column=1, pady=10)
btn_Recording.grid(row=0, column=2, padx=10)


window.mainloop()