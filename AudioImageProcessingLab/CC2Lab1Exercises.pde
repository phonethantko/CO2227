import javax.sound.sampled.*;
import java.io.*;

int sr = 44100;       // sampling rate
int dur = 2;          // duration of playback
float L1 = sr/440.0;  // frequency 440Hz
float L2 = sr/880.0;  // second harmonic
byte[] pcm_data = new byte[sr*dur];

void setup()
{
  size(640, 640);
  stroke(255);
}

void draw()
{
  background(0);
  noFill();
  smooth();
  strokeWeight(2);
  beginShape();
  for(int i = 0; i < pcm_data.length; i++)
  {
    curveVertex(i, height/2 - pcm_data[i]);
  }
  endShape();
}

void mousePressed()
{
    for(int i = 0; i < pcm_data.length; i++)
    {
      pcm_data[i] = (byte)  (
        ( 55 * sin((i/L1) * TWO_PI) +
          55 * sin((i/L2) * TWO_PI) )
          / 2);
    }

    AudioFormat frmt = new AudioFormat(44100, 8, 1, true, true);
    AudioInputStream ais = new AudioInputStream(
      new ByteArrayInputStream(pcm_data), frmt,
      pcm_data.length / frmt.getFrameSize()
      );

    try
    {
      Clip clip = AudioSystem.getClip();
      clip.open(ais);       // load the pcm_data into the Clip
      clip.start();         // play the Clip
      // ALT: write the pcm_data into a wave file
      AudioSystem.write(ais, AudioFileFormat.Type.WAVE, new File(sketchPath() + "/test.wav"));
      print(sketchPath());
    }
    catch(Exception e)
    {
      e.printStackTrace();
    }
}
