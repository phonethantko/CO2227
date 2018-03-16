/*
   * ===============================================================
   * Course:  CO2227, Creative Computing II: Interactive Multimedia
   *          AYA 2017-18, UOL International Programmes
   * Title:   Coursework Assignment 1 Part (2)
   * Student: Phone Thant Ko
   * SRN:     160269000
   * File:    SpiralText.pde
   * ===============================================================
*/


class SpiralText {
  private float xPos;
  private float yPos;
  private String spiralText = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.";
  private float startRadius = 5;
  private float spiralRingStep;
  private float shiftSpiralRingStep = 10;
  private float shiftSpiralSpaceStep = 10;
  private boolean isFrameLimitMode = false;
  private boolean isClrImageMode = false;
  private PImage spirImg;
  private int borderDistance = -5;
  private float startAngle = 0;

  SpiralText (float in_posX, float in_posY, String in_txt, float in_spiralStep) {
    setParam(in_posX, in_posY, in_txt, in_spiralStep);
  }

  void setText(String in_txt) {
    if (in_txt.length() > 0) {
      this.spiralText = in_txt;
    }
  }

  void setBorderDistance(int in_brdrDistance) {
    this.borderDistance = in_brdrDistance;
  }

  void setXY(float in_posX, float in_posY) {
    this.xPos = in_posX;
    this.yPos = in_posY;
  }

  void shiftXY(float in_posX, float in_posY) {
    this.xPos += in_posX;
    this.yPos += in_posY;
  }

  void setParam(float in_posX, float in_posY, String in_txt, float in_spiralStep) {
    setXY(in_posX, in_posY);
    setText(in_txt);
    setSpiralStep (in_spiralStep);
  }

  void setShiftSpirstepSpacestep (float in_shiftSpirStep, float int_shiftSpirSpaceStep) {
    this.shiftSpiralRingStep = in_shiftSpirStep;
    this.shiftSpiralSpaceStep = int_shiftSpirSpaceStep;
  }

  void setSpiralStep (float in_spiralStep) {
    this.spiralRingStep = in_spiralStep;
  }

  void setStartRadius (float in_startRadius) {
    if (0 >= in_startRadius ) {
      this.startRadius = 5;
    }
    this.startRadius = in_startRadius;
  }

  void setStartAngleRadian(float in_startAngle) {
    this.startAngle = degrees(in_startAngle);
  }
  void setStartAngleDegree(float in_startAngle) {
    this.startAngle = in_startAngle;
  }

  void onFrameLimit() {
    this.isFrameLimitMode = true;
  }    

  void offFrameLimit() {
    this.isFrameLimitMode = false;
  }    

  void onImgClrMode(PImage in_img) {
    this.spirImg = in_img;
    this.isClrImageMode = true;
    if (this.spirImg.width < width || this.spirImg.height < height || this.spirImg.width > width || this.spirImg.height > height) {
      this.spirImg.resize(width, height);
    }
  }

  void offImgClrMode() {
    this.isClrImageMode = false;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////

  void draw() {
    //textAlign(CENTER);
    int iterCharPos = 0;
    char currSymbol;
    float angle = startAngle;
    float currRadius = startRadius;
    float spiralSpaceStep = 0;
    float xx = mouseX;
    float yy = mouseY;
    float angleStep = 0;
    float radiusStep = 0;
    float countOfsymb;
    float currSymbolWidth;

    while (iterCharPos < this.spiralText.length ()) {
      currSymbol = this.spiralText.charAt(iterCharPos);
      currSymbolWidth = textWidth(currSymbol);
      spiralSpaceStep = currSymbolWidth + this.shiftSpiralSpaceStep;
      countOfsymb = TWO_PI*currRadius / spiralSpaceStep;
      radiusStep = (this.spiralRingStep + this.shiftSpiralRingStep)/countOfsymb;
      currRadius += radiusStep;

      angleStep += currSymbolWidth / 2 + this.shiftSpiralSpaceStep/2;
      angle += angleStep / currRadius ;  
      angleStep = currSymbolWidth / 2 + this.shiftSpiralSpaceStep/2;

      xx = cos(angle) * currRadius + xPos;
      yy = sin(angle) * currRadius + yPos;

      if (this.isFrameLimitMode && (xx-10 < 0 || xx+10 > width || yy-10 < 0 || yy+10 > height))
      {
        break;
      } 
      else if (!( xx < this.borderDistance || xx> width - this.borderDistance || yy < this.borderDistance || yy > height -this.borderDistance)) {
        if (this.isClrImageMode)
        { 
          fill(this.spirImg.get((int)xx, (int)yy));
        }
        pushMatrix();
        translate(xx, yy);
        rotate(PI/2 + angle);
        text(currSymbol, 0, 0 );
        popMatrix();
      } else if (dist(xx, yy, this.xPos, this.yPos) > dist(this.xPos, this.yPos, borderDistance, borderDistance)
        && dist(xx, yy, this.xPos, this.yPos) > dist(this.xPos, this.yPos, width - this.borderDistance, this.borderDistance)
        && dist(xx, yy, this.xPos, this.yPos) > dist(this.xPos, this.yPos, width - this.borderDistance, height - this.borderDistance)
        && dist(xx, yy, this.xPos, this.yPos) > dist(this.xPos, this.yPos, this.borderDistance, height - this.borderDistance)
        ) {
        break;
      }
      iterCharPos++;
    }
  }
}