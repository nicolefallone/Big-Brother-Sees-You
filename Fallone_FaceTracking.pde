import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;    // a Java class, used for the detected faces

/*
DETECTING FACES (and other things)
 Nicole Fallone | 2019 | nicolefallone.com
 */

int camWidth =  640;    // input camera and detection dimensions
int camHeight = 360;    // too slow if we run it on the full-res camera input

String cascadePath = "/Users/nicolefallone/Desktop/HAR371 CREATIVE PROG2/libraries/opencv_processing/library/cascade-files/";

OpenCV cv;
Capture webcam;
Rectangle[] eyes,mouth;
PImage vignette;
float aspectX, aspectY;
int grid = 30;
color c;

void setup() {
  //size(1280, 720);
fullScreen();
  // calculate the aspect ratio between the input image
  // size and the sketch's size (for drawing rectangles around
  // the detected faces later)
  aspectX = width / camWidth;
  aspectY = height / camHeight;

  // start the webcam with our specified resolution
  String[] inputs = Capture.list();
  printArray(inputs);
  if (inputs.length == 0) {
    println("Couldn't detect any webcams connected!");
    exit();
  }
  webcam = new Capture(this, camWidth, camHeight);
  webcam.start();

  // create an instance of the OpenCV library, also
  // at this reduced resolution
  cv = new OpenCV(this, camWidth, camHeight);
  
  vignette = loadImage("vignette.png");
  noCursor();
}


void draw() {
  if (webcam.available()) {
    webcam.read();
    cv.loadImage(webcam);
    
    cv.loadCascade(cascadePath + "haarcascade_mcs_eyepair_small.xml", true);
    eyes = cv.detect();
    
    cv.loadCascade(cascadePath + "haarcascade_mcs_mouth.xml", true);
    mouth = cv.detect();
    
    // are there eyes
    if (eyes.length > 0) {
      PImage eyeImage = webcam.get(eyes[0].x, eyes[0].y, eyes[0].width, eyes[0].height);
      eyeImage.resize(240,0);
      for (int x = 0; x < width; x+=eyeImage.width) {
        for (int y = 0; y < height; y+=eyeImage.height) {
          //image(eyeImage, x,y);
          set(x,y,eyeImage);
        }
      }
      filter(GRAY);
      image(vignette,0,0,displayWidth,displayHeight);
    }
    
    else if (mouth.length > 0) {
      PImage mouthImage = webcam.get(mouth[0].x, mouth[0].y, mouth[0].width, mouth[0].height);
      mouthImage.resize(240,0);
      for (int x = 0; x < width; x+=mouthImage.width) {
        for (int y = 0; y < height; y+=mouthImage.height) {
          //image(mouthImage, x,y);
          set(x,y,mouthImage);
        }
      }
      filter(GRAY);
      image(vignette,0,0,displayWidth,displayHeight);
      
    }
    
    // no eyes
    else {
      image(webcam, 0, 0, width, height);
      filter(GRAY);
      //rect
    }
  }
}
