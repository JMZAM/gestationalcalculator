Sys.setlocale("LC_TIME", "English")
fcgalmp <- function(today,lmp)  {
        diff <- as.numeric(as.Date(today)-as.Date(lmp))
        cgalmp <- paste(diff%/%7, "weeks", diff%%7, "days")
        eddlmp <-as.Date(lmp)+280
        list(cgalmp, eddlmp, diff/7)       
}

fcgaus <- function(today,usdate,usweek,usday)  {
        diff <- as.numeric(as.Date(today)-as.Date(usdate))+7*usweek+usday
        cgaus <- paste(diff%/%7, "weeks", diff%%7, "days")
        eddus <-as.Date(today)+(280-diff)
        list(cgaus, eddus, diff/7)        
}

shinyServer(
        function(input, output) {
                #List of inputs shown back to the user
                output$oinputlist <- renderPrint({cat(
                                                  paste("Today´s date is:         ",format(input$today,"%B %d %Y")),
                                                  paste("Last menstrual period is:",format(input$lmp,"%B %d %Y")),
                                                  paste("Ultrasound date is:      ",format(input$usdate,"%B %d %Y")), 
                                                  paste("    at the time          ", input$usweek,"weeks",input$usday,"days."),
                                                  sep="\n")})
                
                #Outputs calculated
                output$cgalmp <- renderPrint({cat(fcgalmp(input$today, input$lmp)[[1]])})
                output$cgaus <- renderPrint({cat(fcgaus(input$today, input$usdate, input$usweek,input$usday)[[1]])})
                output$eddlmp <- renderPrint({cat(format(fcgalmp(input$today, input$lmp)[[2]],"%B %d %Y"))})
                output$eddus <- renderPrint({cat(format(fcgaus(input$today, input$usdate, input$usweek,input$usday)[[2]], "%B %d %Y"))})

                #Output graphs                
                output$newPlot <- renderPlot({
                        #Last menstrual period
                        cgalmp <- fcgalmp(input$today, input$lmp)[[1]]
                        eddlmp <- format(fcgalmp(input$today, input$lmp)[[2]],"%B %d %Y")
                        lmpage <- fcgalmp(input$today, input$lmp)[[3]]
                        
                        #Ultrasound
                        cgaus <- fcgaus(input$today, input$usdate, input$usweek,input$usday)[[1]]
                        eddus <- format(fcgaus(input$today, input$usdate, input$usweek,input$usday)[[2]], "%B %d %Y")
                        usage <- fcgaus(input$today, input$usdate, input$usweek,input$usday)[[3]]
                        
                        agematrix = matrix(c(usage, 40-usage, lmpage, 40-lmpage), nrow=2, ncol=2) 
                        
                        par(bg= "#2b3e50", col="white")
                        barplot(agematrix, width= 2 , ylim=c(0,5), horiz=TRUE, xlim=c(-7,47), col=c("forestgreen","white"), axes=FALSE, xlab="Week", col.axis="white")
                        axis(3, at=c(0, 14, 28, 40), labels=c("Day 0", "End of first trimester", "End of second trimester", "Estimated date of delivery"), las=0, tck=0.03, pos=5.5, lwd=0, lwd.ticks=5, col.ticks="red", col.axis="white")
                        axis(1, at=c(0, 10, 20, 30, 40), las=1.5, tck=0.03, pos=-0.3, lwd.ticks=2, col.axis="white")
                        mtext("By last menstrual period", side=2, line=-6, at=3.7, las=1)
                        mtext("By ultrasound", side=2, line=-5, at=1.4, las=1)
                        if (agematrix[3] < 30) {text(agematrix[3], 3.7,cgalmp, pos=4, col="black")} 
                                else {text(agematrix[3], 3.7,cgalmp, pos=2)}
                        if (agematrix[1] < 30) {text(agematrix[1], 1.4,cgaus, pos=4, col= "black")} 
                                else {text(agematrix[1], 1.4,cgaus, pos=2)}
                                
                        mtext(eddlmp, side=4, line=-5.5, at=3.7, las=1)
                        mtext(eddus, side=4, line=-5.5, at=1.4, las=1)
                }, height=300, width=800)
                
        }
)