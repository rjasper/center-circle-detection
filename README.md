# Center Circle Detection

This is the code I've written for my bachelor thesis back in 2013. The topic was "Mittelkreiserkennung im RoboCup auf Basis von Liniensegmenterkennung" (engl. Center Circle Detection in RoboCup based on Line Segment Detection). 
The RoboCup project aims to drive robotics and artificial intelligance forward. Teams all over the world are developing robots and letting them compete in tournaments playing football.
The goal of my thesis was to develop a robost algorithm which is able to detect the center circle of the playing field.

# Dependencies

* MATLAB
* [Line Segment Detector](http://www.ipol.im/pub/art/2012/gjmr-lsd/?utm_source=doi)

# How To Run

I'm afraid the project is not well maintained and certainly old. In the current state it won't run out of the box since it relies on the Line Segment Detector (LSD) which is not included. Frankly, I didn't run it myself for quite a while. However, I uploaded the code anyways for reference purposes. Nevertheless, here are some instructions I found somewhere in my archives:

1. Start MATLAB
2. Change path to `src` directory
3. Call the `ccd` function

```
Syntax:
  ccd <img_file> [options]

Arguments:
  img_file: the image file
  options:
    '--show':     shows the detected center circle in the image
    '--noscale':  suppresses the scaling of the image before processing
    '--override': overrides previously generated files (*.scl.* and *.lsd)

Example:
  ccd my-picture.jpg --noscale --show
```
