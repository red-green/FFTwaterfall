# FFTwaterfall
Fullscreen FFT graph and colored scrolling waterfall display

This program uses the Processing `ddf.minim` library to take input audio from the microphone and process it with an FFT. The rest I wrote myself.

The FFT graph on top is automatically scaling (there are faint grey lines behind it to show scale), and the color scale automatically adjusts to graph scale. The top bands of the graph are glitchy for some reason, so only the bottom part is shown.

It isn't the most CPU-efficient program, my Macbook Pro with dual-core i5 and 16gb of ram showed about 130% CPU usage while running. If you want, you can edit the code to make it windowed, which may improve efficiency.
