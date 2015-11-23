library(shiny)

shinyUI(fluidPage(theme = "bootstrap.css",
        headerPanel("Gestational age calculator"),
        sidebarPanel(
                h3('Input dates and known gestational age'),
                h6('This simple yet useful calculator can estimate gestational age and estimated date of delivery based on current (or otherwise desired) date and one of two parameters:'),
                h6('1. Date of first day of last menstrual period'),
                h6('2. Date of ultrasound and gestational age by ultrasound'),
                dateInput("today","Today´s date:"),
                dateInput("lmp","Last Menstrual Period:"),
                dateInput("usdate","Date of ultrasound (US):"),
                numericInput("usweek","Gestational age by US Weeks", 0, min=0, max=40), 
                numericInput("usday","Gestational age by US Days", 0, min=0, max=7),
                h6(''),
                h6('')
        ),
        mainPanel(
                h3('Gestational age calculations'),
                h4('You entered'),
                verbatimTextOutput("oinputlist"),
                h4('Current gestational age by last menstrual period:'),
                verbatimTextOutput("cgalmp"),
                h4('Current gestational age by ultrasound:'),
                verbatimTextOutput("cgaus"),
                h4('Estimated date of delivery by last menstrual period:'),
                verbatimTextOutput("eddlmp"),
                h4('Estimated date of delivery by ultrasound:'),
                verbatimTextOutput("eddus"),
                plotOutput('newPlot')
        ),
        fluidRow(
                h3('More details'),
                h6("The gestational age is calculated using the calendar method (i.e. counting how many days have passed since the last menstrual period or the ultrasound date)."),
                h6("The estimated date of delivery is calculated by adding 280 days to the last menstrual period [1]."),
                helpText(  "A more detailed explanation of why these methods are useful for you and your doctor can be found ",
                           a("here.",     href="http://rhrealitycheck.org/article/2013/10/17/whats-in-a-week-pregnancy-dating-standards-and-what-they-mean/")
                ),
                helpText(  "More details on how ultrasound can be used to calculate gestational age can be found ",
                           a("here.",     href="https://tonygood4.wordpress.com/2013/02/03/developing-and-eye-for-ultrasound/")
                ),
                h3('References'),
                h6("1. World Health Organization. ICD-10: International statistical classification of diseases and related health problems, 10th revision. Volume 2. 2nd ed. Geneva: WHO; 2004. Available at: http://www.who.int/classifications/icd/ICD-10_2nd_ed_volume2.pdf. Retrieved November 12, 2015.")
                )
))