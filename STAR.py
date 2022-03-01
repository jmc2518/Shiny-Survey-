# info from
# https://towardsdatascience.com/how-to-make-your-own-instagram-filter-with-facial-recognition-from-scratch-using-python-d3a42029e65b

import cv2 # Using opencv-contrib-python wrapper
import numpy
import time
import webbrowser
from datetime import datetime
import webbrowser

#path to classifiers
path = ".venv/Lib/site-packages/cv2/data/"
#get image classifiers
face_cascade = cv2.CascadeClassifier(path +'haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier(path +'haarcascade_eye.xml')

TIMER = int(15)

#read images
facemask = cv2.imread('gray bandana.png')

#get shape of facemask
original_facemask_h,original_facemask_w,facemask_channels = facemask.shape

#get shape of img
#img_h,img_w,img_channels = img.shape

#convert to gray
#img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
facemask_gray = cv2.cvtColor(facemask, cv2.COLOR_BGR2GRAY)

#create mask and inverse mask of facemask
ret, original_mask = cv2.threshold(facemask_gray, 10, 255, cv2.THRESH_BINARY_INV)
original_mask_inv = cv2.bitwise_not(original_mask)

#read video
cap = cv2.VideoCapture(0)
ret, img = cap.read()
img_h, img_w = img.shape[:2]
prev = time.time()

while TIMER >= 0:   #continue to run until user breaks loop
    ret, img = cap.read()
    font = cv2.FONT_HERSHEY_SIMPLEX
    #prev = time.time()
    cv2.putText(img, str(TIMER),
    (300, 50), font,
    1, (255, 0,0),
    1, cv2.LINE_AA)
    cur = time.time()
    if cur - prev >= 1:
        prev = cur
        TIMER = TIMER-1
        
    gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

    #find faces in image using classifier
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    #for every face found:
    for (x,y,w,h) in faces:
        #retangle for testing purposes
        #img = cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)

        #coordinates of face region
        face_w = w
        face_h = h
        face_x1 = x
        face_x2 = face_x1 + face_w
        face_y1 = y
        face_y2 = face_y1 + face_h

        #facemask size in relation to face by scaling
        facemask_width = int(1.5 * face_w)
        facemask_height = int(facemask_width * original_facemask_h / original_facemask_w)
        
        #setting location of coordinates of facemask
        facemask_x1 = face_x2 - int(face_w/2) - int(facemask_width/2)
        facemask_x2 = facemask_x1 + facemask_width
        facemask_y1 = face_y1 - int(face_h*1.25)
        facemask_y2 = facemask_y1 + facemask_height 

        #check to see if out of frame
        if facemask_x1 < 0:
            facemask_x1 = 0
        if facemask_y1 < 0:
            facemask_y1 = 0
        if facemask_x2 > img_w:
            facemask_x2 = img_w
        if facemask_y2 > img_h:
            facemask_y2 = img_h

        #Account for any out of frame changes
        facemask_width = facemask_x2 - facemask_x1
        facemask_height = facemask_y2 - facemask_y1

        #resize facemask to fit on face
        facemask = cv2.resize(facemask, (facemask_width,facemask_height), interpolation = cv2.INTER_AREA)
        mask = cv2.resize(original_mask, (facemask_width,facemask_height), interpolation = cv2.INTER_AREA)
        mask_inv = cv2.resize(original_mask_inv, (facemask_width,facemask_height), interpolation = cv2.INTER_AREA)

        #take ROI for facemask from background that is equal to size of facemask image
        roi = img[facemask_y1:facemask_y2, facemask_x1:facemask_x2]

        #original image in background (bg) where facemask is not
        roi_bg = cv2.bitwise_and(roi,roi,mask = mask)
        roi_fg = cv2.bitwise_and(facemask,facemask,mask=mask_inv)
        dst = cv2.add(roi_bg,roi_fg)

        #put back in original image
        img[facemask_y1:facemask_y2, facemask_x1:facemask_x2] = dst


        break
    #display image
    cv2.imshow('img',img) 

    #if user pressed 'q' break
    if cv2.waitKey(1) == ord('q'): # 
        break;
else:   
    cap.release() #turn off camera 
    cv2.destroyAllWindows() #close all windows
    webbrowser.open("https://jmc36.shinyapps.io/SS8888/")
