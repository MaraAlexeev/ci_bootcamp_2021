# R is a free software environment for statistical computing and graphics.
# I personally believe that R provides user friendly coding, especially for visual learners.
# It is also one of the best programs available for creating highly customizable, publication quality graphics.

# Like Python, R can perform mathematic functions for us
5 + 5
5 * 5
5 / 5
# exponentiation
5 ** 5
# Modular division (what is the remainder?)
8 %% 3

# When using R studio, you can see variable values on the right hand side (below global environment)
x = 5

# You can alter variables with mathematic functions by including that variable in what you are setting it
# equal to (compared to python where we can use += )
x = x + 2
x = x * 3

# Observing data types in R (Double is essentially float in python). Note that even whole numbers default to double.
typeof(x)

# You can convert data types using the different functions: as.numeric(), as.double(), as.integer(), as.character()
x=5.5
x = as.integer(x)
typeof(x)
# Note the L in the right hand side after the numeric value indicates the number is now in integer format

# Concatenating characters in R requires a function such as paste(), rather than just using + (unlike python strings)
y = "Hello"
z = "world!"
yz = paste(y, z, sep=" ")


# You can also utilize loops in r like you can in python. However, the syntax is different.
# The example below is a while loop designed to print every even number between and including 0 to 20
# The conditional states to enter the loop if x is less than or equal to 20. Since 0 satisfies this,
# it enters the loop, prints the iterable x, then adds 2 to x. Since 2 is less than or equal to 20, it
# reenters the loops. This process continues until x = 22.

x = 0
while (x <= 20) {
print(x)
x = x + 2
}

# The example below creates a numeric set, x, and then counts the number of even numbers in that set.
# This for loop does this by setting a counter to zero. It then loops through all the values in the set x.
# The loop states that if the value of the current element can be divided by 2 with a remainder of 0, then to
# add 1 to the count. This process continues until you loop through all the elements in set x. Finally, we print the count.
x <- c(2,5,3,9,8,11,6,22,11,2,4,3,2,6,8)
count = 0
for (val in x) {
if(val %% 2 == 0) count = count+1
}
print(count)

#Loading in a custom data frame. Use the following syntax
df <- data.frame(Name = c("Skyler", "Rachael", "Keith", "Adam", "Tina"),
                 Age = c(29, 25, 30, 11, 40)
)
print (df)


# The install commands are commented out because they only need to be ran once on your machine. Remove the # to run the line.
#install.packages('ggplot2', dep = TRUE)
#install.packages('ggthemes', dep = TRUE)

# The library will need to be loaded every time you reopen the file. We will use ggplot2 later

library(ggplot2)

# We will now set our working directory. This is my favorite way to do it because it can be saved for later, but you can also go to the
# the top of the screen and use session -> set working directory -> choose working directory, or control shift H in windows.
# YOU MUST ALTER THE PATH TO WEHRE YOU HAVE YOUR FILES SAVED. BELOW IS AN EXAMPLE THAT WILL ONLY WORK FOR ME.
setwd("C:/Users/Skyler/desktop")

# This line loads in your .csv file. You can save the file as a .csv file using Excel (save as).
# This file is an example of how data from the VA database might look. This is only sample data and all patient identifiers are fake.

Data <- read.csv("DummyData_COVID_Antipsych3.csv",header=TRUE)

# Subsetting data - Subsetting your data can be extremely powerful in R. You must first understand your scientific inquiries before you
# begin to do this. We work to isolate the cohorts as required for our studies and then we can perform statistical analyses.

# The following lines can be used to subset the data. The first line subsets the file to only include veterans. We do this by telling it to
# include Veterans or Veteran-Employees. The | symbol means "or". The second and third lines subset the veterans
# further depending on whether or not they are on a 1st gen antipsychotic. != means not equal to. NOte that a patient can be on 1st gen
# antipsychotics as either an inpatient or an outpatient, so both must be included. The next two lines split the entire file
# based on gender (note that this is subsetting the original file, not just the veterans. You can change this to include only the veterans
# by replacing "Data" with "Vet"). The next three lines subset the original file by age range (below 18. 18-65, and 65+)
#      |   "or"  means true if any conditional is true
#      &   "&"   means true if all conditionals are true


Vet <- subset(Data, Data$PatientCategory=="Veteran" | Data$PatientCategory=="Veteran-Employee")
VetOn1st <- subset(Vet, Vet$InPt.1st.Typical.Antipsychotic!="NULL" | Vet$OutPt.1st.Gen.Typical.Antipsychotic!="NULL")
VetNotOn1st <- subset(Vet, Vet$InPt.1st.Typical.Antipsychotic=="NULL" & Vet$OutPt.1st.Gen.Typical.Antipsychotic=="NULL")

Males <- subset(Data, Data$Sex=="M")
Females <- subset(Data, Data$Sex=="F")


Children <- subset(Data, Data$AgeAtIndex<18)
Adults <- subset(Data, Data$AgeAtIndex>17 & Data$AgeAtIndex<65)
Seniors <- subset(Data, Data$AgeAtIndex>64)

# Recombining subsets - Use rbind()
Males_or_Females <- rbind(Males,Females)


# The following line shows you how you can create subsets of specific tables using only specified columns

ColumnsSeniors <- subset(Seniors, select = c(PatientICN,InPt.1st.Typical.Antipsychotic,AgeAtIndex))

# The next two lines can quickly show you the first or last six lines (respectively), plus the header of a particular table.
# I did this to easily check that the previous code worked. This is also important because clicking into the data using
# the global environments to the right won't display all the data if there are too many columns or rows.

head(ColumnsSeniors)
tail(ColumnsSeniors)

# Data summary statistics

# Gathering summary statistics for categorical data
length(Seniors$Race)
table(Seniors$Race)
prop.table(table(Seniors$Race))


# The next few lines show you how you can begin to analyze the numerical data in a particular column.
# The histogram function has additional parameters that could customize it further.
# See documentation for hist() online or use the final line of code in this section.

mean(Seniors$AgeAtIndex)
range(Seniors$AgeAtIndex)
sd(Seniors$AgeAtIndex)
# Remove the # below to install the package Rmisc
#install.packages("Rmisc")
library(Rmisc)
CI(Seniors$AgeAtIndex, .95)
hist(Seniors$AgeAtIndex)
help(hist)

# You can also use different packages to create highly customizable, publication quality figures. ggplot is excellent for this
# and you can use google to get codes that you can modify based on your needs. The code below gives box plots showing the ages
# of the veterans (I used the veteran only subset) based on race (x-axis) and gender (key). Use Google to search for ggplot chart
# types to find one that can display what you intend to look at. The documentation will have additional options for modifications.

library(ggthemes)
g <- ggplot(Vet, aes(Race, AgeAtIndex))
g + geom_boxplot(aes(fill=Sex)) + 
  theme(text = element_text(size=15), axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Box plot",
       subtitle="Ages of Veterans by Race",
       caption="",
       x="Race",
       y="Age")

# Note that there is a problem with our dataset in that we have two categories for an Unknown race, "Unknown" and "NULL"
# The code below  can turn all the "NULL" values in that column into "Unknown". We can then rerun the code for the graph.
Vet$Race[Vet$Race == "NULL"] <- "Unknown"

# Note: You can also use the code below to replace all the "NULL" values in the entire file into "Unknown"
# Vet[Vet == "NULL"] <- "Unknown"


# We also have an individual who did not list their sex. We can subset again to remove this and then rerun the code one final time.
vet2 <- subset(Vet, Sex == "M" | Sex == "F")
g <- ggplot(vet2, aes(Race, AgeAtIndex))
g + geom_boxplot(aes(fill=Sex)) + 
  theme(text = element_text(size=15), axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Box plot",
       subtitle="Ages of Veterans by Race",
       caption="",
       x="Race",
       y="Age")
# These are the sorts of things that you will have to do if your dataset is messy.


# Modifying data with ifelse function: The following syntax can be used.
# The arguments are a conditional, a value if true, then a value if false.
Vet$FirstPositive <- ifelse(Vet$FirstPositive=="NULL",0,1)

# Adding a new column: You can add a new column to the data. These values can be set or they can be based off of calculations utilizing other
# columns. For example, the following creates a column that multiplies the patients age by their patient identifier (a more realistic/useful
# example will follow this)
Vet$newinfo <- (Vet$AgeAtIndex*Vet$PatientSID)

# The following line will compare two specified columns with dates in them and add a new column, "date_diff", that shows
# the amount of time between those two columns. The format parameter shows that the dates are in month/day/year format. If you have
# columns in a different format, the code will need to be changed.
Vet$date_diff <- as.Date(as.character(Vet$IndexICUAdmitDate), format="%m/%d/%Y") - as.Date(as.character(Vet$IndexDate), format="%m/%d/%Y")


# We can then use the head function to make sure that all the functions we used above worked properly.
head(Vet)

# Finally, this line can create a .csv file from one of your subsets. The file will save to your working directory unless 
# you specify otherwise.
write.csv(Vet, file = "Vet.csv")



# Now let's start looking at Linear Regression

prostate <- read.csv("C:/Users/Skyler/desktop/prostate.csv",header=TRUE)

## Since we do not have any hyperparamters to tune, let's split the data into training and test sets!

train <- subset(prostate, train=="TRUE")[,1:9]
test <- subset(prostate, train=="FALSE")[,1:9]

nrow(train)
nrow(test)


## visualize the data

pairs(prostate[,1:9], col="blue")

#Assessing data types
str(prostate)


## Let's fit our model using the training data

fit1 <- lm(lpsa ~ ., data = train)
summary(fit1)
# lcavol and lweight are highly significant


# Compute 95% confidence interval
confint(fit1,level=0.95)


### How well does our model do when we generalize it to an independent test set?

# Prediction - Make predictions of your column 9, AKA actual level of prostate-specific antigen (lpsa) using the model.
prediction1 <- predict(fit1, newdata = test[,1:8])
predict(fit1, newdata = test[,1:8], interval = "confidence", level=0.95)


# Calculate the training error (error of model predictions vs training set). To do this, you have to understand what residuals are.
# Residuals are the difference between the observed value of the dependent variable (y) and
# the predicted value (y) is called the residual (e).
mean(fit1$residuals^2)
# Calculate the prediction error (error of model predictions vs test set). You do this by subtracting the predicted 
mean((prediction1-test[,9])^2)
