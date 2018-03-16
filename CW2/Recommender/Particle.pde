/*
   * ===============================================================
   * Course:  CO2227, Creative Computing II: Interactive Multimedia
   *          AYA 2017-18, UOL International Programmes
   * Title:   Coursework Assignment 2 Part (3)
   * Student: Phone Thant Ko
   * SRN:     160269000
   * File:    Particle.pde
   * Purpose: This class specifies the particles used in Recommender.pde
   * ===============================================================
*/

class Particle
{
  int id;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector max;
  PVector min;
  float radius;
  color particle_color;
  color text_color;

  //constructor for Particle class
  Particle(int id, color c1, color c2){

    this.id         = id;
    //two colours are opposite to each other so it is more visible on the canvas
    particle_color  = c1;
    text_color      = c2;

    position     = new PVector(random(0, width), random(0, height));
    velocity     = new PVector(random(1, 2), random(1, 2));
    acceleration = new PVector(0, 0);
    radius = 50;
    max = new PVector(width, height);
    min = new PVector(0, 0);

  }

  void display(int idTest)
  {
    pushStyle();
    noStroke();
    smooth();
    //to identify the selected person from the rest, it draws a border with a different colour
    if(idTest == id)
    {
      fill(text_color);
      ellipse(position.x, position.y, radius + 5, radius + 5);
      fill(255);
      ellipse(position.x, position.y, radius, radius);
    }
    fill(particle_color, 70);
    ellipse(position.x, position.y, radius, radius);
    //draw the ID number of the person
    fill(0);
    textAlign(CENTER);
    textFont(idFont, 15);
    text(id, position.x, position.y + 5);
    popStyle();
  }

  void move()
  {
    /*
      the method renders the particles to move in a random manner
      the collisions at the boundaries have been checked to ensure the particles bounce at the borders
    */
    if(position.x > max.x || position.x < min.x)
    {
      velocity.x *= -1;
    }
    if(position.y > max.y || position.y < min.y)
    {
      velocity.y *= -1;
    }
    position.add(velocity);
  }

  void accelerate()
  {
    //the method accelerates or decelerates the particles randomly
    acceleration.set(random(-0.1, 0.5), random(-0.1, 0.5));
    velocity.add(acceleration);
  }

  void drawSimilarityLine(Particle pEnd)
  {
    /*
      the method draws a line from the center of the current particle (i.e. - the particle user has chosen to compare the similarity values)
      to the center of every other particle that has a similarity value higher than the one thats specified
    */
    pushStyle();
    float c = map( dist( position.x, position.y, pEnd.position.x, pEnd.position.y),
                         0,
                         sqrt( pow(width, 2) + pow(height, 2)),
                         0,
                         255
                         );
    //stroke(color(c, c, c));
    stroke(text_color, 120);
    if(position. x < pEnd.position.x)
    {
      line(position.x , position.y, pEnd.position.x , pEnd.position.y);
    }
    else{
      line(position.x , position.y, pEnd.position.x , pEnd.position.y);
    }
    popStyle();
  }
}
