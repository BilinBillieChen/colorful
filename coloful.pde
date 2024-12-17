import processing.sound.*;

int cols, rows;
int scl = 3;
float[][] zOff;
float zSpeed = 0.02;
Amplitude amp;
AudioIn input;
float volume;

void setup() {
  size(800, 800);
  cols = width / scl;
  rows = height / scl;
  zOff = new float[cols][rows];

  // Initialize noise offset
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      zOff[x][y] = random(100);
    }
  }

  input = new AudioIn(this, 0); 
  amp = new Amplitude(this);
  input.start(); // Start capturing audio
  amp.input(input); // Analyze input audio

  noStroke();
}

void draw() {
  background(0);
  volume = amp.analyze(); 

  float[] hues = {220, 255, 110, 30, 50};

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      float noiseValue = noise(x * 0.1, y * 0.1, zOff[x][y]);
      zOff[x][y] += zSpeed;

      float hueShift = map(volume, 0, 1, 0, 360);
      float hue = hues[int(noiseValue * hues.length)];
      hue = (hue + hueShift) % 360;

      float saturation = map(volume, 0, 1, 80, 100); 
      float brightness = map(volume, 0, 1, 70, 100); 
      colorMode(HSB, 360, 100, 100);
      fill(hue, saturation, brightness);

      rect(x * scl, y * scl, scl, scl);
    }
  }
}
