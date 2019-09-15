import cv2
import matplotlib
from matplotlib import pyplot
import sys
import skvideo.io
import imutils

dir = 'C:/Users/Ethan/Desktop/model/posenet-python/--image_dir/'

def get_video_file(vid_name, directory=dir, filetype='.mov'):
    query = directory + vid_name + filetype
    cap = cv2.VideoCapture(query)
    print(query)
    counter = 0
    while(True):
        counter += 1
        ret, frame = cap.read()
        if ret != False:
            #rotated = imutils.rotate(frame, -90)
            grey=cv2.resize(frame, (320,240))#(width,height)

            cv2.imwrite(dir + "frame" + str((counter -1 + 1000)) + '.jpg', grey)

        elif cv2.waitKey(25) & 0xFF == ord('q'):
            break
        elif ret == False:
            break

get_video_file(vid_name="optimal_squat2", directory= "C:/Users/Ethan/Desktop/htn2019/python/--image_dir/", filetype='.mp4' )
