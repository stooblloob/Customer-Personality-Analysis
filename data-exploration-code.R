### install/ load packages
library(knitr)
library(ggplot2)
library(gridExtra)
library(tidyverse)
library(tibble)
library(skimr)
library(kableExtra)
library(agricolae)
library(compareGroups)
library(FSA)
library(psych)

### loading data
marketing_campaign <- read.csv2(file = '~/Downloads/marketing_campaign.csv', sep = "\t" )

### data preview
variable_descriptions <- tribble(
  ~Variable_Name, ~Description,
  "Year_Birth", "Customer's birth year",
  "Education", "Customer's education level",
  "Marital_Status", "Customer's marital status",
  "Income", "Customer's yearly household income",
  "Kidhome", "Number of children in customer's household",
  "MntFruits", "Amount spent on fruits in last 2 years")

variable_descriptions <- variable_descriptions %>% 
  mutate(across(dplyr::everything(), ~ str_to_title(.)))

variable_descriptions

### amount of fruits spent based on a customer's trait
# This bar graph shows the frequency of the amount spent on fruits in the last two years.
ggplot(marketing_campaign) +
  geom_bar(mapping = aes(MntFruits)) +
  ylab("Amount Spent on Fruits ($)") +
  ggtitle("Frequency of the Amount Spent on Fruits in the Last 2 Years")

# This bar graph displays the amount spent on fruits based on customer's level of education. 
ggplot(data = marketing_campaign) +
  geom_bar(mapping = aes(x = Education, y = MntFruits), 
           stat = "identity") +
  ggtitle("Customer's Level of Education vs. Amount Spent on Fruits in Last 2 Years") + 
  xlab("Education") + 
  ylab("Amount Spent on Fruits ($)")

# This bar graph displays the amount spent on fruits based on customer's number of kids at home. 
ggplot(data = marketing_campaign) +
  geom_bar(mapping = aes(x = Kidhome, y = MntFruits), 
           stat = "identity") +
  ggtitle("Customer's Number of Kids vs. Amount Spent on Fruits in Last 2 Years") + 
  xlab("Kids") + 
  ylab("Amount Spent on Fruits ($)")

# This bar graph displays the amount spent on fruits based on customer's marital status.
ggplot(data = marketing_campaign) +
  geom_bar(mapping = aes(x = Marital_Status, y = MntFruits), 
           stat = "identity") +
  ggtitle("Customer's Marital Status vs. Amount Spent on Fruits in Last 2 Years") + 
  xlab("Marital") + 
  ylab("Amount Spent on Fruits ($)")

### data cleansing
marketing_campaign <- marketing_campaign %>%
  mutate(Education = recode(Education,
                            "2n Cycle" = "Master's Degree",
                            "Basic" = "High School Diploma",
                            "Master" = "Master's Degree",
                            "Graduation" = "Bachelor's Degree",
                            "PhD" = "Ph.D"))

marketing_campaign <- marketing_campaign %>%
  mutate(Age = 2022 - Year_Birth)

marketing_campaign <- marketing_campaign %>%
  filter(Marital_Status != "Absurd", 
         Marital_Status != "YOLO",
         Age < 90,
         Income != 666666)

marketing_campaign <- marketing_campaign %>%
  mutate(Marital_Status = ifelse(Marital_Status == "Alone", "Single", Marital_Status))

marketing_campaign$Education <- as.factor(marketing_campaign$Education)
marketing_campaign$Kidhome <- as.factor(marketing_campaign$Kidhome)

### more visualizations
# This pie chart displays 2240 customers and their education levels based off of the new categories.
t<- table(marketing_campaign$Education)
t
Education1 <- c("Master's Degree","High School Diploma", "Bachelor's Degree", "Ph.D")
pie_labels <- paste0(Education1 , "=", round(100 * t/sum(t), 2), "%")
pie(t, col = hcl.colors(length(t), "BluYl"), labels = pie_labels, 
    main = "Pie Chart of Customer's Education Level")

# education vs. fruits box plot
ggplot(data = marketing_campaign, aes(x = Education,y = MntFruits)) + 
  geom_boxplot() +
  ylab("Amount Spent on Fruits in Last 2 Years") +
  xlab("Education Levels") +
  ggtitle("Amount Spent on Fruits vs. Education Levels") +
  coord_flip() + 
  stat_summary(fun = mean, color = "darkred", size = 0.5, shape = "square")+
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(limits = c("High School Diploma", "Bachelor's Degree", "Master's Degree", "Ph.D"))

# frequency of age counts
Age_count <- marketing_campaign %>%
  mutate(Age_tens = trunc(Age/10)) %>%
  group_by(Age_tens) %>%
  summarize(count = n())
Age_groups <- c(20, 30, 40, 50, 60, 70, 80, 120)
Age_count <- add_column(Age_count, Age_groups)
Age_count <- Age_count %>%
  select(Age_groups, count)
Age_count

# average spent on fruit for 5 age groups
# without outliers
indices_30 <- which(marketing_campaign$Age >= 30 & marketing_campaign$Age <= 39)
indices_40 <- which(marketing_campaign$Age >= 40 & marketing_campaign$Age <= 49)
indices_50 <- which(marketing_campaign$Age >= 50 & marketing_campaign$Age <= 59)
indices_60 <- which(marketing_campaign$Age >= 60 & marketing_campaign$Age <= 69)
indices_70 <- which(marketing_campaign$Age >= 70 & marketing_campaign$Age <= 79)
avg_30 <- mean(marketing_campaign$MntFruits[indices_30])
avg_40 <- mean(marketing_campaign$MntFruits[indices_40])
avg_50 <- mean(marketing_campaign$MntFruits[indices_50])
avg_60 <- mean(marketing_campaign$MntFruits[indices_60])
avg_70 <- mean(marketing_campaign$MntFruits[indices_70])
avg_Mnt_Fruit <- c(avg_30, avg_40, avg_50, avg_60, avg_70)
age_group <- c("30 to 39", "40 to 49", "50 to 59", "60 to 69",
               "70 to 79")
age_vs_fruit <- data.frame(age_group, avg_Mnt_Fruit)

# histogram of age vs. fruits
ggplot(age_vs_fruit) +
  geom_histogram(mapping = aes(x = age_group,
                               y = avg_Mnt_Fruit),
                 fill = c("light green", "yellowgreen", "gold", "orange", "orangered"),
                 stat = "identity") +
  ggtitle("Customer's Age vs. Average Amount Spent on Fruits in Last 2 Years") + 
  xlab("Age Groups") + 
  ylab("Average Amount Spent on Fruits ($)") +
  geom_text(mapping = aes(x = age_group,
                          y = avg_Mnt_Fruit,
                          label = format(round((avg_Mnt_Fruit), 2), nsmall = 2)),
            vjust = -1) +
  coord_cartesian(ylim = c(0, 32))+
  theme(plot.title = element_text(hjust = 0.5))


# average spent on fruit for 2 age groups
# without outliers
marketing_campaign <- marketing_campaign %>%
  mutate(Age = 2022 - Year_Birth)
indices_middle <- which(marketing_campaign$Age <= 54)
indices_older <- which(marketing_campaign$Age >= 55)
avg_middle <- mean(marketing_campaign$MntFruits[indices_middle])
avg_older <- mean(marketing_campaign$MntFruits[indices_older])
avg_Mnt_Fruit <- c(avg_middle, avg_older)
age_group <- c("Middle Age (26 to 54)", 
               "Older Age (55 to 129)")
age_vs_fruit <- data.frame(age_group, avg_Mnt_Fruit)

ggplot(age_vs_fruit) +
  geom_histogram(mapping = aes(x = age_group,
                               y = avg_Mnt_Fruit),
                 fill = c("gold", "orange"),
                 stat = "identity") +
  ggtitle("Customer's Age vs. Average Amount Spent on Fruits in last 2 years") + 
  xlab("Age Groups") + 
  ylab("Average Amount Spent on Fruits ($)") +
  geom_text(mapping = aes(x = age_group,
                          y = avg_Mnt_Fruit,
                          label = format(round((avg_Mnt_Fruit), 2), nsmall = 2)),
            vjust = -1) +
  coord_cartesian(ylim = c(0, 32))

# choosing number of clusters
age_fruit <- data.frame(Age = marketing_campaign$Age,
                        MntFruits = marketing_campaign$MntFruits)
age_fruit.scaled <- scale(age_fruit)
age_fruit.scaled <- data.frame(age_fruit.scaled)
centers15 <- rep(0, 15)
for(i in 1:15){
  centers15[i] <- kmeans(age_fruit.scaled, i, nstart = 20)$tot.withinss
}
xcenters <- 1:15
centers15table <- data.frame(xcenters, centers15)
ggplot(centers15table) +
  geom_point(mapping = aes(xcenters, centers15)) +
  xlab("Number of Center") +
  ylab("Total Within-Cluster Sum of Squares") +
  ggtitle("Total Within-Cluster Sum of Squares vs. Number of Centers")

# 3 clusters
km3 <- kmeans(age_fruit, 3, nstart = 20)
km_age_fruit <- add_column(age_fruit,
                           km.cluster = as.factor(km3$cluster))
ggplot(data = km_age_fruit, mapping = aes(x = Age, y = MntFruits)) +
  geom_point(aes(color = km.cluster), size = 3) +
  ggtitle("Age vs MntFruit Marketing Campaign data: K-Means Clustering, K = 3")

# exploring marital status
marketing_campaign.new <- marketing_campaign %>% 
  filter(Marital_Status != "Absurd", Marital_Status != "YOLO") %>%
  mutate(Marital_Status = replace(Marital_Status, Marital_Status == "Alone", "Single"))

above.avg <- marketing_campaign.new %>%
  filter(MntFruits > 26.27) %>%
  group_by(Marital_Status, MntFruits) %>%
  count(Marital_Status)

above.abg.spenders <- above.avg %>%
  group_by(Marital_Status) %>%
  count(Marital_Status)

total <- marketing_campaign.new %>%
  group_by(Marital_Status) %>%
  count(Marital_Status)

rates <- left_join(above.abg.spenders, total, by = "Marital_Status") %>%
  mutate(rates = n.x / n.y)

ggplot(rates, aes(x = Marital_Status, y = rates, fill = Marital_Status)) +
  geom_bar(stat = "identity") + 
  ggtitle("Proportion of Marital Status Spending \n more than the Average") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_text(aes(label = round(rates, 4)), vjust = -1) +
  ylim(0, .4) +
  xlab("Marital Status") +
  ylab("Proportion")

# plotting means for marital status
new.avg.spent <- marketing_campaign.new %>%
  group_by(Marital_Status) %>%
  summarise(Mean = mean(MntFruits))

ggplot(new.avg.spent) +
  geom_bar(aes(x = Marital_Status, y = Mean, fill = Marital_Status), 
           stat = "identity") +
  ylim(0, 100) +
  geom_text(aes(x = Marital_Status, y = Mean, label = round(Mean, digits = 3)),
            vjust = -2) +
  ggtitle("Average Amount Spent of Fruits \n per Marital Status") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Marital Status") +
  ylab("Average Spent on Fruits")

new.avg.spent <- marketing_campaign.new %>%
  
  group_by(Marital_Status) %>%
  
  summarise(Mean = mean(MntFruits))


# compare densities
ggplot(new.avg.spent) +
  geom_bar(aes(x = Marital_Status, y = Mean, fill = Marital_Status), 
           stat = "identity") +
  ylim(0, 100) +
  geom_text(aes(x = Marital_Status, y = Mean, label = round(Mean, digits = 3)),
            vjust = -2) +
  ggtitle("Average Amount Spent of Fruits \n per Marital Status") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("Marital Status") +
  ylab("Average Spent on Fruits")

# plot income
marketing_campaign2 <- filter(marketing_campaign, Income != 666666)

ggplot(data = marketing_campaign2) +
  geom_point(mapping = aes(x = Income, y = MntFruits)) +
  geom_smooth(mapping = aes(x = Income, y = MntFruits), se = F) +
  ggtitle("Scatterplot of Income vs Amount Spent on Fruit") +
  theme(plot.title = element_text(hjust = 0.5))

# plot kids vs fruits
marketing_campaign$Kidhome <- as.factor(marketing_campaign$Kidhome)

avg_spent_kids <- marketing_campaign %>%
  group_by(Kidhome) %>%
  summarise(Mean = mean(MntFruits)) 
ggplot(avg_spent_kids) +
  geom_bar(aes(x = Kidhome, y = Mean, fill = Kidhome, show.legend=FALSE), stat = "identity") +
  ylim(0, 50) +
  geom_text(aes(x = Kidhome, y = Mean, label = round(Mean, digits = 2)), vjust = -2)+
  xlab("Number of Kids at Home")+
  ylab("Average Amount of Money Spent on Fruit Over 2 Years")+
  guides(Kidhome = FALSE)+
  ggtitle("Mean Spent on Fruits by Number of Kids at Home")+
  theme(plot.title = element_text(hjust = 0.5))
