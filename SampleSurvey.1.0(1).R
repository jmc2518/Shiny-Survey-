#SSII
#Clean code that creates a basic sample shiny survey with demographic questions, and also saves the survey responses into a 
#a google sheet.
# Load packages

library(shiny)
library(shinysurveys)
library(googlesheets4)

# Define questions in the format of a shinysurvey

#All questions placed into a single data frame, with questions presented in order to be
#presented in the survey.
#for multiple choice items, questions have to be repeated for each response option.
#option: response options. For text, I put "Enter text here", which is shown in the box that appears below the question. For MC, 
#I enter each choice, one row at a time, in the order that I want the responses to appear in the survey.

#input_type = how are people to respond?
#Dependence = should the appearance of this item depend on another item?
#dependence value = how do you need to respond on the previous item to get this item to appear?
#required = do you need to respond to this item to continue? (TRUE = yes, FALSE = no)
#page = what page should this question appear on? (optional with single page survey)

Consent <- data.frame(
  question = c("Do you consent to participate in this study?","Do you consent to participate in this study?", "You do not consent to participate in this study. Thank you for your interest, 
               and please exit this survey now.", "What is your age?", "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?",
               "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?",
               "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?", "Which gender do you identify with?", "Which gender do you identify with?",
               "Which gender do you identify with?", "Which gender do you identify with?", "Do you identify as transgender?", "Do you identify as transgender?", "Do you identify as transgender?", 
               "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?",
               "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?",
               "Which of the following best describes your political ideology?"),
  option = c("Yes, I do agree to participate in this study.", "No, I do not agree to participate in this study.", "Do Not Enter Text Here", "Enter Text Here", "White, European",
             "Black, African", "Native American/First Nations", "Latin-o/a/x", "East, South, and Southeast Asians", "Middle Eastern, Arab", "Hawaiian Native, Pacific Islander", "Multi-racial",
             "Woman", "Men", "Non-Binary", "Not Listed","Yes", "No", "Unsure", "Very Conservative", "Conservative", "Somewhat Conservative", "Moderate", "Somewhat Liberal", "Liberal", "Very Liberal"),
  input_type = c("mc", "mc", "text", "numeric", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc"),
  input_id = c("consent", "consent", "EXIT", "age", "race", "race", "race", "race", "race", "race", "race", "race", "gender", "gender", "gender", "gender", "trans", "trans", "trans", "PI", "PI", "PI", "PI", "PI", "PI", "PI"),
  dependence = c(NA, NA, "consent", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
  dependence_value = c(NA, NA, "No, I do not agree to participate in this study.", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
  required = c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
  page = c(1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,2, 2, 2, 2, 2, 2, 2)
)


# Define shiny UI
#all apps include a ui portion of code, and the server portion of code.
#for the ui, I use the surveyOutput command to present the questions stored in the "Consent" dataset. I also present a title and survey description.


ui <- fluidPage(
  surveyOutput(Consent,
               survey_title = "Reactions while wearing various Face Masks",
               survey_description = "Welcome to the survey! In this cell phone survey application, different types of face masks will be digitally superimposed onto 
              your face. We are interested in your differing reactions after virtually wearing each type of mask. We are also interested in obtaining general information
               about you.",
               theme = "#63B8FF")
)

# Define shiny server
#This is the server portion of the code.

server <- function(input, output, session) {
  renderSurvey()
 
  #observeEvent: once a person clicks the submit button at end of survey, present this message, and save responses as a unique row in my Google Sheets file.
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Thank you for completing this survey!",
      "We were interested in investigating your reactions when wearing specific types of masks. Specifically, we thought that virtually 
      imposing certain types of face masks would lead to increased threat and intentions to surveil for Black Individuals. If you're 
      interested in obtaining more information, or have any other questions or comments about this study, email the research team at GRASPlab@pdx.edu."
    ))
    Results <- cbind(input$consent, input$age, input$race, 
                     input$PI, input$gender, input$trans, Sys.Date())
    Results2 <- Results %>% as.list() %>% data.frame()
    sheet_append(data = Results2, ss = "https://docs.google.com/spreadsheets/d/1VIxZzPR7n1fsoyCT8ImhD4KjYEiE_i-9OoWbACljf5M/edit?usp=sharing") # This links to my google sheet, you'll want to input your own link prior to use.
    

  })
  
}

# Run the shiny application: need this command to get the app to roll.

shinyApp(ui, server)