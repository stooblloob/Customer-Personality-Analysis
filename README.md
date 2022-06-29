# Customer-Personality-Analysis

## Authors: Stella Aurelia, Felix Gao, Leslie Vazquez Moreno, Sean Nguyen, and Victoria Nguyen

## Roles
* **Stella Aurelia:** Exploring levels of education and formatting the presentation slides
*  **Felix Gao:** Exploring levels of income and creating the logistic regression model
*  **Leslie Vazquez Moreno:** Exploring age
*  **Sean Nguyen:** Exploring marital status
*  **Victoria Nguyen:** Exploring number of kids at customer's household

## Introduction
This is my first collaborative data science project from my senior year of undergrad at the University of California, Riverside. We conducted research on the characteristic and fruit-purchasing habits of a business's customers with the goal of being able to model the traits of the ideal customer for this business to further market fruit towards. 

The dataset we utilized can be found on Kaggle by Dr. Omar Romero-Hernandez of Berkeley Haas School of Business titled "Customer Personality Analysis". The dataset itself is an analysis of a company's ideal customers. This allows the understanding of consumer habits and profiles in order to help market products towards group that are most likely to be customers. 

## Research Questions
**Main Research Question:** What characteristics makes someone more likely to spend more on fruits? 

**Subquestions:** 
1. Does the level of education have an effect in purchasing more on fruit?
2. What age group purchased the most fruit on average? 
3. Are married people more likely to spend more on fruits?
4. Is there a relationship betweenincome and the amount spent on fruit? 
5. Does the number of kids one has at home affect how much they spend on fruit? 

## Important Variables
The original dataset includes 29 variables of 2240 customers (3 are character variables and 26 are numerical variables). By choosing to focus on customers' fruit-buying habits, we were able to pick out the following variables relevant to our research.

**Independent Variables:**
* Year_Birth
* Education
* Marital_Status
* Income
* KidHome

**Dependent Variable:**
* MntFruits

| Variable_Name | Description | 
|---------------|-------------|
| `Year_Birth` | Customer's Birth Year|
| `Education`   | Customer's Education Level|
| `Marital_Status` | Customer's Marital Status|
| `Income` | Customer's Yearly Household Income|
| `KidHome` | Number of Children In a Customer's Household|
| `MntFruits` | Amount Spend on Fruits In Last 2 Years|

## Data Manipulation & Cleansing

`Education` - Upon further research, we found that the responses that had `2n Cycle` are actually equivalent to having a master's degree in other parts of the world. So, we manipulated the data to 4 distinctive categories: `High School Diploma`, `Bachelor's Degree`, `Master's Degree` and `Ph.D`. 

`Year_Birth` - To optimize interpretability, we created an `Age` column by the formula: `Age` = 2022 - `Year_Birth`. Extreme outliers were also omitted.

`Marital_Status` - We found abnormal responses for this variable such as `Absurd` or `Yolo`, so we chose to omit these two responses. The response for `Alone` meant the same as `Single`, so we mutated these two responses together.

`Education` & `KidHome` - We recoded these categorical variables as factor types to help with our logistic model.

`Income` - Missing values were omitted.

## Our Findings

**Subquestions:**
1.  
We found that on average, those with a: `High School Diploma` spent **$11.11**, `Bachelor’s Degree` spent **$30.77**, `Master’s Degree` spent **$24.24**, `Ph.D` spent **$20.04** on fruits in the last two years. Overall on average, customers with a bachelor's degree spent the most on fruits. 

Initially, we wanted to use ANOVA to answer this sub question. However the residuals violated the assumptions and through multiple attempts of transformation we thought it was best to use a non-parametric test as the last resort. We use chi-square test to see if there is a relationship between `Education` and `MntFruits`. We use kruskal-wallis test to see if there is a difference in the distribution of the populations of `Education`.

Since the p-value from both tests are less than alpha (0.05), we reject the null hypothesis. This means that they are statistically significant and that there is a relationship between Education and MntFruits. There is also a significant difference between education levels. 

Yes, the level of education has an effect in purchasing more fruits. We predict `Education` will have some effect on `MntFruits` if it is a statistically significant predictor. 

2. 
Ages were analyzed in groups of 10 (i.e. 30-39, 40-49, etc) ranging from 30 to 79. The age group that purchased the most fruit on average over the past 2 years was 70 to 79. There is also a slight upward trend from 40's to 70's. 

A second histogram with only 2 age groups are used to test the consistency of our results from the first histogram since each age group will receive greater sample size, representing the data better. The outliers excluded from the first histogram are included in this histogram since the problem of an age group with largely different sample sizes from the other age groups is not a problem for only 2 age groups. 

Using kmeans clustering, we see that the clusters are not useful for grouping `Age` since the different levels of `MntFruits` is distributed equally among all ages. However, from the clustering, we do see that the low `MntFruits` cluster is much more concentrated for `Age` as well as it makes the 3 outliers for the 120's age clear to remove for the main model. 

We predict `Age` will have little effect on `MntFruits` if it is a statistically significant predictor.

3. 
From the graphs and test that I conducted I can conclude that married people, on averge do not spend more than other groups of different marital status.

From the Kruskal-Wallis test, I can also conclude that the distribution between the marital status group are identical. 

4. 
Based on the scatter plot and the correlation, we can say there is a linear relationship of moderate strength between income and amount spent on fruits.

5. 
As we can see in the graph, customers with no kids spend around 5 times as much on fruit than customers who do have children. Those with only 1 child spend slightly more than those with 2. 

The following Chi-Square test confirms that the amount of money spent on fruits has a dependent relationship with the number of kids one has in their household, and we know that this relationship is negative from the graph.

**Main Research Question:**

To answer the question `What characteristics makes someone more likely to spend more on fruits?`, we want an older individual with a higher income level who has a Bachelor's degree and has 0 kids at home.

## References 
[Kaggle Customer Personality Dataset](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis/)
