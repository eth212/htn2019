import cv2
import matplotlib
from matplotlib import pyplot
import sys

dir = 'C:/Users/Ethan/Desktop/htn2019/python/training_videos/'

def get_video_file(vid_name, directory=dir, filetype='.mov'):
    query = dir + vid_name + filetype
    query = dir + "test_video.mov"
    cap = cv2.VideoCapture(query)
    counter = 0
    while(True):
        counter += 1
        ret, frame = cap.read()
        if ret != False:
            grey = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            grey=cv2.resize(grey, (169,300))#(width,height)
            cv2.imwrite(dir + "frame" + str((counter -1 + 1000)) + '.jpg', grey)

        elif cv2.waitKey(25) & 0xFF == ord('q'):
            break
        elif ret == False:
            break

get_video_file(vid_name="test_video" )
