static class TextPrompt extends PApplet {

  //Public methods

  public static String prompt(String question) {
    return prompt(question, 1);
  }
  public static String prompt(String question, int minCharacters) {
    TextPrompt tp = new TextPrompt(question, minCharacters);
    try {
      while (tp.response == null) {
        Thread.sleep(100);
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    return tp.response;
  }



  //Class

  public String response;

  private final int WINDOW_WIDTH = 500, WINDOW_HEIGHT = 150;
  private final int BUTTON_WIDTH = 100, BUTTON_HEIGHT = 50;
  private final int QUESTION_TEXT_SIZE = 14;
  private final int RESPONSE_TEXT_SIZE = 16;

  private String question;
  private int minCharacters;

  private String textInput = "";

  private TextPrompt(String question) {
    this(question, 0);
  }

  private TextPrompt(String question, int minCharacters) {
    super();

    this.question = question;
    this.minCharacters = minCharacters;

    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  void settings() {
    size(WINDOW_WIDTH, WINDOW_HEIGHT);
  }

  void setup() {
  }

  int editPos = 0;

  void draw() {
    background(240);
    fill(0);
    textAlign(LEFT, TOP);
    textSize(QUESTION_TEXT_SIZE);
    text(question, 10, 10);

    fill(255);
    stroke(0);
    strokeWeight(2);
    rectMode(CORNER);
    rect(10, QUESTION_TEXT_SIZE+20, width-20, RESPONSE_TEXT_SIZE+15);
    strokeWeight(1);

    fill(0);
    textAlign(LEFT, CENTER);
    textSize(RESPONSE_TEXT_SIZE);
    String line = textInput.substring(0, editPos) + (millis()%2000 < 1000 ? "|" : " ");
    if (editPos < textInput.length())line += textInput.substring(editPos); 
    text(line, 15, QUESTION_TEXT_SIZE+20+(RESPONSE_TEXT_SIZE+15)/2-2);

    fill(textInput.length() < minCharacters ? 200 : 230);
    if (mousePressed && mouseOnButton()) fill(180); 
    stroke(150);
    rectMode(CENTER);
    rect(width/2, height-BUTTON_HEIGHT/2-10, BUTTON_WIDTH, BUTTON_HEIGHT);

    fill(0);
    textSize(14);
    textAlign(CENTER, CENTER);
    text("OK", width/2, height-BUTTON_HEIGHT/2-10);
  }

  private void quit() {
    if (textInput.length() >= minCharacters) {

      response = textInput;
      try {
        Thread.sleep(50);
        surface.setVisible(false);
        Thread.sleep(100);
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
      exit();
    }
  }

  private boolean mouseOnButton() {
    return abs(mouseX-width/2) <= BUTTON_WIDTH/2 && mouseY >= height-10-BUTTON_HEIGHT && mouseY <= height-10;
  }

  void keyPressed() {
    if (key != CODED) {
      if (key == '\n') {
        quit();
      } else if (key == BACKSPACE) {
        if (editPos > 0) {
          String tmp = textInput.substring(0, editPos-1);
          if (editPos < textInput.length()) tmp += textInput.substring(editPos);
          textInput = tmp;
          editPos--;
        }
      } else if (key == DELETE) {
        if (editPos < textInput.length()) {
          String tmp = textInput.substring(0, editPos);
          if (editPos < textInput.length()) tmp += textInput.substring(editPos+1);
          textInput = tmp;
        }
      } else {
        String tmp = textInput.substring(0, editPos) + key;
        if (editPos < textInput.length()) tmp += textInput.substring(editPos);
        textInput = tmp;
        editPos++;
      }
    } else {
      if (keyCode == LEFT) {
        if (editPos > 0) editPos--;
      } else if (keyCode == RIGHT) {
        if (editPos < textInput.length()) editPos++;
      }
    }
  }

  void mouseClicked() {
    if (mouseButton == LEFT) {
      if (mouseOnButton()) {
        quit();
      }
    }
  }
}
