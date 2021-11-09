#SS1.2
#DONE: Next = moves to next tab. Demos moved to the end, submit button final button to click in survey. Preventing people from moving backwards

# Load packages

library(shiny)
library(shinysurveys)
library(googlesheets4)
library(shinyjs)
library(shinydashboard)

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

DEMOS <- data.frame(
  question = c("What is your age?", "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?",
               "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?",
               "With which racial/ethnic group do you identify?", "With which racial/ethnic group do you identify?", "Which gender do you identify with?", "Which gender do you identify with?",
               "Which gender do you identify with?", "Which gender do you identify with?", "Do you identify as transgender?", "Do you identify as transgender?", "Do you identify as transgender?", 
               "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?",
               "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?", "Which of the following best describes your political ideology?",
               "Which of the following best describes your political ideology?"),
  option = c("Enter Text Here", "White, European",
             "Black, African", "Native American/First Nations", "Latin-o/a/x", "East, South, and Southeast Asians", "Middle Eastern, Arab", "Hawaiian Native, Pacific Islander", "Multi-racial",
             "Woman", "Men", "Non-Binary", "Not Listed","Yes", "No", "Unsure", "Very Conservative", "Conservative", "Somewhat Conservative", "Moderate", "Somewhat Liberal", "Liberal", "Very Liberal"),
  input_type = c("numeric", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc", "mc"),
  input_id = c("age", "race", "race", "race", "race", "race", "race", "race", "race", "gender", "gender", "gender", "gender", "trans", "trans", "trans", "PI", "PI", "PI", "PI", "PI", "PI", "PI"),
  dependence = c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
  dependence_value = c( NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
  required = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
  page = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
)

#This piece is part of code used to close the survey when exist button is clicked.

jscode <- "shinyjs.closeWindow = function() { window.close();}"

# Define shiny UI
#all apps include a ui portion of code, and the server portion of code.
#for the ui, I use the surveyOutput command to present the questions stored in the dataset. I also present a title and survey description.

#This is where the random number is generated. THere are six different possible orders if there are three mask conditions to be presented.
#The first number in this command sets the largest possible integer that can be drawn. The second number tells how many numbers need to be drawn.

rng <- sort(sample.int(6,1))


#tabPanel: allows you to add separate panels to your survey. 

ui <- fluidPage(
                 useShinyjs(),
                 extendShinyjs(text = jscode, functions = c("closeWindow")), # allows me to create a functional exit button later.
                 tabsetPanel(id = "navbar",   #name of tabsetPanel
                 tabPanel('Consent', value = "Cons", titlePanel(h1(strong("Consent to Participate in Research"), align = "center")), #first tab
                          strong("Project Title:"), " Face Masks During COVID-19", br(), 
                          strong("Researcher:"), " Dr. Kimberly B. Kahn, Psychology, Portland State University", br(),   #strong() = bold text
                          strong("Researcher Contact:"), " grasplab@pdx.edu", br(),
                          tableOutput('tbl'), 
                          strong("How will my privacy and data confidentiality be protected?"), br(), br(), # br()= line space
                          "We will take measures to protect your privacy including not collecting any information about you that would make you identifiable as an individual. All of your responses will be completely anonymous. Despite taking steps to protect your privacy, we can never fully guarantee that your privacy will be protected.", br(), br(),
                                     "To protect the security of all of your personal information, we will collect all data using an encrypted survey tool and store all of the data collected in password protected computers that are only accessible by the researchers. Despite these precautions, we can never fully guarantee the confidentiality of all study information.", br(), br(),
                                     "Individuals and organizations that conduct or monitor this research may be permitted access to inspect research records. These individuals and organizations include the Institutional Review Board that reviewed this research.", br(), br(),
                                     strong("What happens to the information collected?"), br(), br(),
                                     "The overall findings from this research will be used to present at professional conferences and publish in academic journals.", br(), br(),
                                     strong("What if I want to stop participating in this research?"), br(), br(),
                                    "Your participation is voluntary. You do not have to take part in this study, but if you do, you may stop at any time. You have the right to choose not to participate in any study activity or completely withdraw from participation at any point without penalty or loss of benefits to which you are otherwise entitled. Your decision whether or not to participate will not affect your relationship with the researchers or Portland State University.", br(), br(),
                                     strong("Will I be paid for participating in this research?"), br(), br(),
                                    "For your participation in this study, you will be entered into a drawing for a $50 Amazon gift card.", br(), br(),
                                    strong("Who can answer my questions about this research?"), br(), br(),
                                    "If you have questions, concerns, or have experienced a research related injury, contact the research team at:", br(), br(),
	                                   "GRASP Research Lab, Grasplab@pdx.edu", br(), br(),
                                      strong("Who can I speak to about my rights as a research participant?"), br(), br(),
                                      "The Portland State University Institutional Review Board (IRB) is overseeing this research. The IRB is a group of people who independently review research studies to ensure the rights and welfare of participants are protected. The Office of Research Integrity is the office at Portland State University that supports the IRB. If you have questions about your rights, or wish to speak with someone other than the research team, you may contact:", br(), br(),
                                      "The Office of Research Integrity, 1 (877) 480-4400 or via email: psuirb@pdx.edu", br(), br(),
                                      "I have had the opportunity to read and consider the information in this form. I have asked any questions necessary to make a decision about my participation. I understand that I can ask additional questions throughout my participation.
                                       I understand that I am volunteering to participate in this research. I understand that a copy of this consent form can be provided to me. I understand that I am not waiving any legal rights.", br(), br(),
                                       radioButtons("consent", "Do you consent to participate in this study?", choices = c("Yes, I do consent to participate in this research.", "No, I do not consent to participate in this research.")), #MC item
                                       actionButton("Next", "Next"),   # Next Button, which I have coded to move you automatically to the next tab.
                                       actionButton("Exit", "Exit")), #Exit button, which I have coded to remove you from the survey.
                                             
                 
                 #Here is where the randomization occurs. Depending on which number is randomly generated earlier, the information presented under each tab varies.
                 #Right now there's only single sentences being randomized, but you could randomize presentation of tasks and surveys.
                 
                 tabPanel(title = "First Mask Filter", value = "Filter1",  #tab2
                          if (rng == 1)     #randomizes presentation of content using rng and if statements.
                          {
                            "no mask condition"
                             actionButton("Next2", "Next")
                          },
                          if (rng == 2)
                            
                          {
                            "no mask condition"
                            actionButton("Next2", "Next")
                          },
                         if (rng == 3)
                          {
                            "surgical mask condition"
                           actionButton("Next2", "Next")
                          },
                         if (rng == 4)
                         {
                           "surgical mask condition"
                           actionButton("Next2", "Next")
                         },
                          if (rng == 5) 
                          {
                           "bandana mask condition"
                            actionButton("Next2", "Next")
                          },
                         if (rng == 6)
                         {
                           "bandana mask condition"
                           actionButton("Next2", "Next")
                         }

                          
                          ),
                 tabPanel("First Mask Survey", value = "Survey1",  #tab 3
                          if (rng == 1)
                          {
                            "no mask survey"
                            actionButton("Next3", "Next")
                          },
                          if (rng == 2)
                          {
                            "no mask survey"
                            actionButton("Next3", "Next")
                          },
                          
                          if (rng == 3)
                          {
                           "surgical mask survey"
                            actionButton("Next3", "Next")
                          },
                          
                          if (rng == 4)
                          {
                            "surgical mask survey"
                            actionButton("Next3", "Next")
                          },
                          if (rng == 5) 
                          {
                            "bandana mask survey"
                            actionButton("Next3", "Next")
                          },
                          if (rng == 6)
                          {
                            "bandana mask survey"
                            actionButton("Next3", "Next")
                          }
                          ),
                 tabPanel("Second Mask Filter", value = "Filter2", # tab 4
                          if (rng == 1)
                          {
                            "surgical mask condition"
                            actionButton("Next4", "Next")
                          },
                          if (rng == 2)
                          {
                            "bandana mask condition"
                            actionButton("Next4", "Next")
                          },
                          if (rng == 3)
                          {
                           "no mask condition"
                            actionButton("Next4", "Next")
                          },
                          if (rng == 4)
                          {
                           "bandana mask condition"
                            actionButton("Next4", "Next")
                          },
                          if (rng == 5)
                          {
                            "surgical mask condition"
                            actionButton("Next4", "Next")
                            
                          },
                          if (rng == 6)
                          {
                            "no mask condition"
                            actionButton("Next4", "Next")
                          }),
                 tabPanel("Second Mask Survey", value = "Survey2", #tab 5
                 if (rng == 1)
                 {
                   "surgical mask survey"
                   actionButton("Next5", "Next")
                 },
                 if (rng == 2)
                 {
                   "bandana mask survey"
                   actionButton("Next5", "Next")
                 },
                 if (rng == 3)
                 {
                   "no mask survey"
                   actionButton("Next5", "Next")
                 },
                 if (rng == 4)
                 {
                   "bandana mask survey"
                   actionButton("Next5", "Next")
                 },
                 if (rng == 5)
                 {
                   "surgical mask survey"
                   actionButton("Next5", "Next")
                 },
                 if (rng == 6)
                 {
                   "no mask survey"
                   actionButton("Next5", "Next")
                 }),
                 tabPanel("Third Mask Filter", value = "Filter3", # tab6
                 if (rng == 1)
                 {
                   "bandana mask condition"
                   actionButton("Next6", "Next")
                 },
                 if (rng == 2)
                 {
                   "surgical mask condition"
                   actionButton("Next6", "Next")
                 },
                 if (rng == 3)
                 {
                   "bandana condition"
                   actionButton("Next6", "Next")
                 },
                 if (rng == 4)
                 {
                   "no mask condition"
                   actionButton("Next6", "Next")
                 },
                 if (rng == 5)
                 {
                   "no mask condition"
                   actionButton("Next6", "Next")
                 },
                 if (rng == 6)
                 {
                   "surgical mask condition"
                   actionButton("Next6", "Next")
                 }),
                 tabPanel("9. Third Mask Survey", value = "Survey3", # tab 7
                 if (rng == 1)
                 {
                  "bandana mask survey"
                   actionButton("Next10", "Next")
                 },
                 if (rng == 2)
                 {
                  "surgical mask survey"
                   actionButton("Next10", "Next")
                 },
                 if (rng == 3)
                 {
                   "bandana mask survey"
                   actionButton("Next10", "Next")
                 },
                 if (rng == 4)
                 {
                  "no mask survey"
                   actionButton("Next10", "Next")
                 },
                 if (rng == 5)
                 {
                   "no mask survey"
                   actionButton("Next10", "Next")
                 },
                 if (rng == 6) 
                 {
                   "surgical mask survey"
                   actionButton("Next10", "Next")
                 }),
                 
                 tabPanel(title = 'Information about You', value = 'DEMOs', #Demographic survey tab
                          fluidPage(
                            surveyOutput(DEMOS,    #surveyOutput presents the survey.
                                         theme = "#63B8FF")))))
                 

# Define shiny server
#This is the server portion of the code.

server <- function(input, output, session) {
  renderSurvey()
  
  ###Server side: allows you to click the exit button to leave the survey if you
  ##do not consent to participate on the first tab.
  
  observeEvent(input$Exit, {
    js$closeWindow()
    stopApp()
  }) 
   
  ####The code below makes the Next button appear on tab 1 if participants agree to participate in the research.
  
  observe({
    shinyjs::toggleState("Next", input$consent == "Yes, I do consent to participate in this research.")
  })
  
  #This code makes the next tab appear if the person clicks the next button.
  
  observe({
    toggle(condition = input$Next, selector = "#navbar li a[data-value=Filter1]")
  }) 
  
  #This code both moves the participant to the next tab if you click the next button, 
  #and will also hide the previous tab to prevent participants from returning to that tab.
  
  observeEvent(input$Next, {
    updateTabsetPanel(session,"navbar", selected = "Filter1") #this line of code moves a participant to the next tab.
    hideTab("navbar", "Cons")  #this line of code hides the previous tab.
  })
  
  observe({
    toggle(condition = input$Next2, selector = "#navbar li a[data-value=Survey1]")
  }) 
  
  observeEvent(input$Next2, {
    updateTabsetPanel(session,"navbar", selected = "Survey1")
    hideTab("navbar", "Filter1")
  })
  
  observe({
    toggle(condition = input$Next3, selector = "#navbar li a[data-value=Filter2]")
  }) 
  
  observeEvent(input$Next3, {
    updateTabsetPanel(session,"navbar", selected = "Filter2")
    hideTab("navbar", "Survey1")
  })
  
  
  observe({
    toggle(condition = input$Next4, selector = "#navbar li a[data-value=Survey2]")
  }) 
  
  observeEvent(input$Next4, {
    updateTabsetPanel(session,"navbar", selected = "Survey2")
    hideTab("navbar", "Filter2")
  })
  
  observe({
    toggle(condition = input$Next5, selector = "#navbar li a[data-value=Filter3]")
  }) 
  
  
  observeEvent(input$Next5, {
    updateTabsetPanel(session,"navbar", selected = "Filter3")
    hideTab("navbar", "Survey2")
  })
  
  
  observe({
    toggle(condition = input$Next6, selector = "#navbar li a[data-value=Survey3]")
  }) 
  
  observeEvent(input$Next6, {
    updateTabsetPanel(session,"navbar", selected = "Survey3")
    hideTab("navbar", "Filter3")
  })
  
  observe({
    toggle(condition = input$Next10, selector = "#navbar li a[data-value=DEMOs]")
  }) 
  
  observeEvent(input$Next10, {
    updateTabsetPanel(session,"navbar", selected = "DEMOs")
    hideTab("navbar", "Survey3")
  })
  
  output$text1 <- renderText ({
    paste(strong("Project Title: Face Masks During COVID-19"), strong("Researcher: Dr. Kimberly B. Kahn, Psychology, Portland State University"),
          strong("Researcher Contact: grasplab@pdx.edu"), sep = "\n")
  })
  
  #The code below, once a person clicks the submit button at end of survey, present this message, and save responses as a unique row in my Google Sheets file.
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Thank you for completing this survey!",
      "We were interested in investigating your reactions when wearing specific types of masks. Specifically, we thought that virtually 
      imposing certain types of face masks would lead to increased threat and intentions to surveil for Black Individuals. If you're 
      interested in obtaining more information, or have any other questions or comments about this study, email the research team at GRASPlab@pdx.edu."
    ))
    
    #The code below saves data to the Google sheet if submit is clicked.
    
    Results <- cbind(input$consent, input$age, input$race, 
                     input$PI, input$gender, input$trans, Sys.Date())
    Results2 <- Results %>% as.list() %>% data.frame()
    sheet_append(data = Results2, ss = "https://docs.google.com/spreadsheets/d/1VIxZzPR7n1fsoyCT8ImhD4KjYEiE_i-9OoWbACljf5M/edit?usp=sharing") # This links to my google sheet, you'll want to input your own link prior to use.
    

  })
  
}

# Run the shiny application: need this command to get the app to roll.

shinyApp(ui, server)