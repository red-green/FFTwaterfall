import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioInput  input;
FFT         fft;

// settings
int fftsize = 0; // these two set after fft is initialized
int fftstep = 0;
int fftheight = 200;
float minfftscale = 1;


// global variables
float fftscale = 20;

void setup() {
  size(displayWidth,displayHeight);
  
  minim = new Minim(this);
  input = minim.getLineIn();
  fft = new FFT(input.bufferSize(),input.sampleRate());
  fftsize = fft.specSize()/2; // chop off top half
  fftstep = width/fftsize;
  
  background(0);
  
}

void draw() {
  fft.forward(input.mix);
  
  // do the calc for fft scale
  float maxfft = -1;
  for (int b = 0; b < fftsize; b++) {
    if (fft.getBand(b) > maxfft) maxfft = fft.getBand(b);
  }
  if (maxfft > fftscale) fftscale = maxfft;
  if (fftscale > minfftscale) fftscale *= 0.99;
  
  noStroke();
  fill(0);
  //clear the fft graph 
  rect(0,0,width,fftheight);
  
  // draw the faint lines
  stroke(64);
  for (int i = 0; i < fftscale; i++) {
    float a = fftheight - map(i,0,fftscale,0,fftheight);
    line(0,a,width,a);
  }
  
  // draw line graph
  stroke(255);
  for (int b = 0; b < fftsize; b++) {
    float start = map(fft.getBand(b),0,fftscale,0,fftheight);
    float end = map(fft.getBand(b+1),0,fftscale,0,fftheight);
    line(b*fftstep,(fftheight-2)-start,(b+1)*fftstep,(fftheight-2)-end);
  }
  
  // now draw the waterfall part
  loadPixels();
  for (int b = 0; b < fftsize-1; b++) {
    float start = fft.getBand(b);
    float end = fft.getBand(b+1);
    float scale = (start-end)/(float)fftstep;
    for (int i = b*fftstep; i < (b+1)*fftstep; i++) {
      pixels[width*(fftheight+1) + i] = getcolor(start);
      start -= scale;
    }
  }
  
  // shift waterfall down
  for (int i = width*(height-1)-1; i > width*(fftheight+1); i--) {
    pixels[i+width] = pixels[i];
  }
  updatePixels();
}

color getcolor(float start) {
  //return color(map(start,0,fftscale,red(mincolor),red(maxcolor)),map(start,0,fftscale,green(mincolor),green(maxcolor)),map(start,0,fftscale,blue(mincolor),blue(maxcolor)));

  float c = map(start,0,fftscale,0,256*3);
  if (c < 256) return color(0,c,255-c);
  c-=256;
  if (c < 256) return color(c,255,0);
  c-=256;
  if (c < 256) return color(c,255-c,0);
  c-=256;
  return color(255,255,c);
}

boolean sketchFullScreen() { return true; }
  
