/*
   * ===============================================================
   * Course:  CO2227, Creative Computing II: Interactive Multimedia
   *          AYA 2017-18, UOL International Programmes
   * Title:   Coursework Assignment 2 Part (3)
   * Student: Phone Thant Ko
   * SRN:     160269000
   * File:    Recommender.pde
   * Purpose: The program aims to look for other users with a similar taste for movies, based on ratings provided.
   *          Ideally, for a chosen user, he may enjoy the movies that other users who have been connected through a line watch.
   *          Using the json data files, the program calculates
   *          the similarity value of two people using the euclidean distance
   *          for the movie they have given rating for.
   * How-To:  You can enter some similarity value ranging from 0.00 to 1.00 in the drawTextBox
   *          and the value you enter will act as a minimum value to filter out relevant people with similar taste.
   *          Then you can click on one of the circles moving around (particles) to choose a person you want to work with.
   *          Then if there's any other user that has a SM value higher than the one you specified,
   *          a line will be drawn from your chosen person to other people who meets the criteria.
   * Notes:   data.json, Ubuntu-Regular.ttf, TitilliumWeb-Regular.ttf
   *          will have to be put inside the data folder for the program to run without error
   * ===============================================================
*/

// Import Statements
import controlP5.*;

// Global Variables
JSONObject data, ratings;
JSONArray movies;
int NUM = 41; //number of particles (noted: you may LOWER the value for better clearer visualization)
Particle[] particles = new Particle[NUM];
FloatDict[] smValues = new FloatDict[NUM];
Particle p;
int current_value = 0;
float targetSimilarityValue;
float xPos, yPos, r;
int pID;
PFont font, idFont;
ControlP5 cp5;

/*
  * ================================================================
  * Setup and Draw Functions
  * ================================================================
*/
void setup()
{
  init();
  fullScreen();
  drawTextBox();
}

void draw()
{
  background(255);
  // Retrieve the value entered by the user through the textbox
  targetSimilarityValue = float(cp5.get(Textfield.class, "")
                                 .getText()
                            );
  // Draw the artefact!
  drawParticles();
}

/*
  * ================================================================
  * Initialization
  * ================================================================
*/
void init()
{
  data    = loadJSONObject("data.json");
  movies  = data.getJSONArray("movies");
  ratings = data.getJSONObject("ratings");
  // Initialize Particle Objects
  for(int i = 0; i < particles.length; i++)
  {
    p = new Particle( i,
                      colorGenerator(),
                      reverseColorGenerator(colorGenerator())
                    );
    particles[i] = p;
    // Store the Similary Values of each particle in smValues array
    smValues[i] = similarityList(str(i));
  }
  cp5 = new ControlP5(this);
  // Create Fonts
  font = createFont("Ubuntu-Regular.ttf",16);
  idFont = createFont("TitilliumWeb-Regular.ttf", 20);
}

/*
  * ================================================================
  * Draws the description label and the textbox for user to enter the values
  * ================================================================
*/
void drawTextBox()
{
  // Using Controlp5 Library, the textfields handle interaction between the user and the program
  cp5.addTextlabel("label")
      .setText("Enter a minimum Similarity Value (between 0 and 1) below: ")
      .setPosition(width/2 - 250, height * 0.8 - 35)
      .setColorValue(0)
      .setFont(idFont);

  cp5.addTextfield("")
     .setPosition(width/2 - 100, height * 0.8)
     .setSize(200, 40)
     .setFont(font)
     .setFocus(false)
     .setColor(255)
     .getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
}

/*
  * ================================================================
  * Method for drawing Particles
  * ================================================================
*/
void drawParticles()
{
  for(int i = 0; i < particles.length; i++)
  {
    xPos = particles[i].position.x;
    yPos = particles[i].position.y;
    r = particles[i].radius;
    pID = particles[i].id;

    particles[i].display(current_value);
    particles[i].move();

    if(mousePressed)
    {
      // Checking for user selection
      if( mouseX >= xPos - r && mouseX <= xPos + r &&
          mouseY >= yPos - r && mouseY <= yPos + r)
          {
            // Updates the CHOSEN ONE !
            current_value = pID;
          }
    }
    // Ensures the user does not compare against himself
    if(i != current_value)
    {
      /*
        Retrieves the list of similariy values of the CHOSEN ONE and
        if the value for another person exceeds the targetSimilarityValue,
        they are llinked together !
      */
      if(smValues[i].get(str(current_value)) >= targetSimilarityValue)
      {
          // Link the two people
          particles[i].drawSimilarityLine(particles[current_value]);
      }
    }
  }
}

// a Random Colour Generator
color colorGenerator()
{
  return color( random(0, 255),
                random(0, 255),
                random(0, 255));
}

// a Colour Generator that generates an opposite colour produced from the method above
color reverseColorGenerator(color c)
{
  return color( 255 - red(c)    ,
                255 - green(c)  ,
                255 - blue(c)
              );
}

/*
  * ===================================================================================
  * Method for Calculating an Euclidean Distance between the ratings of two people
  * ===================================================================================
*/
float euclidean(String person1, String person2)
{
  JSONObject ratings1 = ratings.getJSONObject(person1); //ratings by first person
  JSONObject ratings2 = ratings.getJSONObject(person2); //ratings by second person
  float sum = 0;
  String[] movies1 = (String[]) ratings1.keys().toArray(new String[ratings1.size()]); //movies that person1 has rated
  // Loop though the list of movies
  for(int i = 0; i < movies1.length; i++)
  {
    // Checks if the person2 has watched the movie watched by person1
    String movie =  movies1[i];
    // If he has,....
    if(ratings2.getFloat(movie) != 0)
    {
      // Calculate Eculidean distance
      float rating1 = ratings1.getFloat(movie);
      float rating2 = ratings2.getFloat(movie);
      float diff = rating1 - rating2;
      sum += diff * diff;
    }
  }
  return 1.0/sqrt(sum);
}

/*
  * ================================================================
  * Method that returns a list of similarity values with other users for a person
  * ================================================================
*/
FloatDict similarityList(String person)
{
  String[] people = (String[]) ratings.keys().toArray(new String[ratings.size()]);
  FloatDict scores = new FloatDict();
  for(int i = 0; i < people.length; i++)
  {
    String otherPerson = people[i];
    // A person cannot be compared against himself !
    if(!otherPerson.equals(person)){
      scores.set( otherPerson,
                  euclidean(person, otherPerson));
    }
  }
  //return the list sorted by the person with highest SM value
  scores.sortValuesReverse();
  return scores;
}
