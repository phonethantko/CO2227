/*
  Phone Thant Ko
  SRN - 160269000
*/

import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

Twitter twitter;
String searchString = "hello";//User can change the keyword to search on twitter
List<Status> tweets;
String msg = "";

int currentTweet;
float tweetLength;

float circle = 200;
float angle, colour, radius;
float frequency = 0.000005;

float xPos, yPos;
PFont font;
SpiralText txtSp;


void setup()
{
    size(1000,800);

    //Key Set Up
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setOAuthConsumerKey("GFU6chpqSjOjUjY51lqowfSaZ");
    cb.setOAuthConsumerSecret("sLpiysihY2G2qHu0rUPsW54Ih8bn63via21o8R3MEeSMiNhTCC");
    cb.setOAuthAccessToken("333336850-ggXD8oVlzT9v9nYDxqnj3WC5eY3p5IirnqiIKKSU");
    cb.setOAuthAccessTokenSecret("n0ERwPatOaJIKfDErygPOveVNA7Lip3a6wTDpIFSFAiGK");
    
    //Initialize the Twitter Object
    twitter = new TwitterFactory(cb.build()).getInstance();
    getNewTweets();
    currentTweet = 0;
    
    //Set up for the twitter text
    font = createFont("Arial Bold", 25, true);
    textFont(font, 20);
    xPos = width/2;
    yPos = height/2;
    txtSp = new SpiralText(xPos, yPos, msg, 20);
    txtSp.setShiftSpirstepSpacestep(-5, 0);
    txtSp.onFrameLimit();
    
    thread("refreshTweets");//Multi-Threading
}

void draw()
{
    background(220);
    //To iterate through the tweets retrieved in a single request
    currentTweet = currentTweet + 1;
    if (currentTweet >= tweets.size())
    {
        currentTweet = 0;
    }

    Status status = tweets.get(currentTweet);
    msg = status.getText();
    tweetLength = msg.length();//Taking the length of the tweets in a retrieved batch
    drawSpiralTweet(msg);
    
    translate(mouseX, mouseY);
    drawParticles(tweetLength);    
    delay(120);  
}

void getNewTweets()
{
    try
    {
        Query query = new Query(searchString);
        query.setCount(100);//Taking 100 tweets per query
        QueryResult result = twitter.search(query);
        tweets = result.getTweets();
    }
    //Exception handling in case processing cannot retrieve tweets
    catch (TwitterException te)
    {
        System.out.println("Failed to search tweets: " + te.getMessage());
        System.exit(-1);
    }
}

//When the user clicks, the program requests for a new set of data in a different thread.
void mouseClicked()
{
    thread("refreshTweets");
}

//Method to request a new batch of tweets.
//NOTE - THERE IS A MAXIMUM ATTEMPT OF 15 TIMES PER HOUR, AS STIPULATED BY TWITTER API
void refreshTweets()
{
    getNewTweets();
    println("Updated");
    delay(5000);
}

void drawParticles(float tweetLength)
{
    ellipseMode(RADIUS);
        
    rotate(radians(angle));
    for(float i = 0; i < tweetLength*5; i++)
    {
        circle = 200 + 50*sin(millis()*frequency*i);
        colour = map(circle, 100, 250, 255, 60);
        radius = map(circle, 150, 250, 5, 2);
        fill(colour, 0, 74);
        noStroke();
        ellipse(circle*cos(i), circle*sin(i), radius, radius);
        angle = angle + 0.00005;
    }
}

void drawSpiralTweet(String msg)
{
    //Using SpiralText class, the method draws the tweets in the spiral
    txtSp.setText(msg);
    txtSp.setXY(mouseX, mouseY);
    txtSp.draw();
}

