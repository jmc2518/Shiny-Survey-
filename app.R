#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinysurveys)
library(googlesheets4)
library(shinyjs)
library(shinydashboard)
library(reticulate)
library(shinyWidgets)

#use_python(python = "C:\\Users\\jcutl\\AppData\\Local\\Programs\\Python\\Python39", required = TRUE)
#py_config() 

os<- import("os")

rng <- sample(1:3, 1, replace = TRUE)
#rng <- 3

jscode <- "shinyjs.closeWindow = function() { window.close();}"

ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(text = jscode, functions = c("closeWindow")), # allows me to create a functional exit button later.
  #tags$h2("Change shiny app background"),
  setBackgroundColor("DeepSkyBlue"), #use this to change the color.
  tabsetPanel(id = "navbar",   #name of tabsetPanel
              tabPanel(title = "First Mask Filter", value = "Filter1",  #tab2
                       div(strong("Instructions: Virtual Mask Filter App"), style = "font-size: 16px"), br(), br(),
                       div("In this study, we are interested in your emotions and reactions while wearing different types of face masks. 
                          To assess these feelings, we are going to have you work with an app (like face filter apps on Instagram and other social media platforms)
                          that uses the camera on your device to record your face. Depending on which condition you are in, the app may digitally superimpose a virtual 
                          face mask on your face, either a surgical mask or a bandana, and you will be asked to view this image on your device for one minute. After the minute is over,
                          you will be taken to a separate survey and asked about your various feelings and reactions experienced while viewing the image of yourself wearing that specific
                          virtual face mask (or no mask at all).", style = "font-size: 16px"), br(),
                       div("When you click the Activate Filter button, the app will begin. Before you start the app, there are few things that you should do beforehand to ensure that the app will run. 
                          First, make sure that your camera is on and open on your device. [If your device does not have a camera, then you won't be able to complete this task]. 
                          Also, make sure to record in a well-lit location, free of clutter, preferably with a solid White background if possible (ex: using a White wall as a background, 
                          with no pictures, posters, etc. on the wall). ", style = "font-size: 16px"), br(),
                       #actionButton("Next2", "Next"),
                       actionButton("Activate", "Activate Filter!"))))

server <- function(input, output, session) {
  # renderSurvey()
  
  #CYCLE 1
  
  observeEvent(input$Exit, {
    js$closeWindow()
    stopApp()
  }) 
  
  if (rng == 3)  #bandana condition
  {
    observeEvent(input$Activate, {
      #setwd("C:/Users/jcutl/OneDrive/Desktop/r.RFM/PROJECT")
      setwd("C:/Users/jcutl/Downloads/")
      py_run_file("STAR.py", local = FALSE, convert = TRUE) #Boom! It works!
    })
  }
  if (rng == 2)  # surgical mask condition
  {
    observeEvent(input$Activate, {
      #setwd("C:/Users/jcutl/Desktop/AR/FacemaskARlocal")
      setwd("C:/Users/jcutl/OneDrive/Desktop/r.RFM/PROJECT")
      print("SURGICAL MASK CONDITION")
      #py_run_file("test4001.py", local = FALSE, convert = TRUE) #Boom! It works!
    })
  }
  if (rng == 1)
  {
    observeEvent(input$Activate, {
      #setwd("C:/Users/jcutl/Desktop/AR/FacemaskARlocal")
      setwd("C:/Users/jcutl/OneDrive/Desktop/r.RFM/PROJECT")
      #print("NO MASK CONDITION")
      py_run_file("STARNM.py", local = FALSE, convert = TRUE) #Boom! It works!
    })
    
  }
  
}

shinyApp(ui, server)