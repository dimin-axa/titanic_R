###########################################

# DM
# 12/01/2016

# Titanic study

# Context: DS training session

# Source: https://www.kaggle.com/c/titanic/

###########################################


# 0. LOADING DS STUFF & WDIR
{
  # CALL MY DS PACKAGE (IN CONSTRUCTION)
  source("C://Users/d-minassian/Desktop/My_R_Data_Science_Package.R")
  ds.lbp() # load usual DS packages
  
  # ToolBox
  source("//matfic00/Directions-AXC/AXC-IARD-Actuariat/SERVICE/Utilisateurs/Dimitri/Notes Code/R ToolBox.R")
  
  maindir<-"C:/Users/d-minassian/Desktop/Formation Data Science/Titanic"
  setwd(maindir)
}


# 1. LOADING DATA
{
  DB<-fread(file.path("data","train.csv"))
  DB
  # database is quite light
  # full description can be found here:
  {
#     VARIABLE DESCRIPTIONS:
#       survival        Survival
#     (0 = No; 1 = Yes)
#     pclass          Passenger Class
#     (1 = 1st; 2 = 2nd; 3 = 3rd)
#     name            Name
#     sex             Sex
#     age             Age
#     sibsp           Number of Siblings/Spouses Aboard
#     parch           Number of Parents/Children Aboard
#     ticket          Ticket Number
#     fare            Passenger Fare
#     cabin           Cabin
#     embarked        Port of Embarkation
#     (C = Cherbourg; Q = Queenstown; S = Southampton)
#     
#     SPECIAL NOTES:
#       Pclass is a proxy for socio-economic status (SES)
#     1st ~ Upper; 2nd ~ Middle; 3rd ~ Lower
#     
#     Age is in Years; Fractional if Age less than One (1)
#     If the Age is Estimated, it is in the form xx.5
#     
#     With respect to the family relation variables (i.e. sibsp and parch)
#     some relations were ignored.  The following are the definitions used
#     for sibsp and parch.
#     
#     Sibling:  Brother, Sister, Stepbrother, or Stepsister of Passenger Aboard Titanic
#     Spouse:   Husband or Wife of Passenger Aboard Titanic (Mistresses and Fiances Ignored)
#     Parent:   Mother or Father of Passenger Aboard Titanic
#     Child:    Son, Daughter, Stepson, or Stepdaughter of Passenger Aboard Titanic
#     
#     Other family relatives excluded from this study include cousins,
#     nephews/nieces, aunts/uncles, and in-laws.  Some children travelled
#     only with a nanny, therefore parch=0 for them.  As well, some
#     travelled with very close friends or neighbors in a village, however,
#     the definitions do not support such relations.
  }
}


# 2. DATA OVERVIEW
{
  ds.doverview(DB)

  # points :
  # 2x plus d'hommes que de femmes
  # Survived : à prédire 0(=non)/1
  # Parch = nb parents/childrens
  # Pclass: "socio" economy class: 1=upper // 2nd = middle // 3d= lower : équi répartie entre 1 et 2 mais 2x plus de 3 (discriminant)
  # Embarked: C = Cherbourg Q = Queenstown S = Southampton
  # I y a pas mal de empty pour "cabin" mais ça peut se retrouver je pense (en utilisant le ticket)

  # COL FORMATS
    # They are all in characters as default value
  DB$Survived<-as.numeric(DB$Survived)
#   levels(DB$Survived)<-c("No","Yes")
  DB$Pclass<-as.factor(DB$Pclass)
  levels(DB$Pclass)<-c("1st","2nd","3rd")
  DB$Age<-as.numeric(DB$Age)
  DB$Sex<-as.factor(DB$Sex)
  DB$ASibSpge<-as.numeric(DB$SibSp) # Number of Siblings/Spouses Aboard
  DB$Parch<-as.numeric(DB$Parch) # Number of Parents/Children Aboard
  DB$Fare<-as.numeric(DB$Fare) # Fare (prix trajet ?)
  DB$Cabin<-as.factor(DB$Cabin)
  DB$Embarked<-as.factor(DB$Embarked)
  
  ds.dHist(DB)
  
}


# 3. LET'S MODEL
{
  # Normally I would retreat some information, such as the age (creating for example the "baby" class) - but I directly go deep in predictions due to lack of time

  glm.f1<-formula(Survived~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked)

  glm.db<-ds.glm.data(DB)
  glm.formula<-glm.f1
  glm.family=binomial(link='logit')
  glm.na.action=na.omit
  glm.name = "mod1"
  
  modz=list()
  modz[[1]]<-ds.glm.exec(glm.db,glm.formula,glm.family,glm.na.action,glm.name)
  
  # AUC 0.7
  
}

# MOD 2
{
  k=2
  glm.formula<-formula(Survived~Pclass+Sex+Age+SibSp)

  glm.db<-ds.glm.data(DB)
  glm.family=binomial(link='logit')
  glm.na.action=na.omit
  glm.name = paste0("mod",k)
  
  modz[[k]]<-ds.glm.exec(glm.db,glm.formula,glm.family,glm.na.action,glm.name)

}

# Working on AGE
{
  # 
  ggPoints(DB,"Age","Survived")
# => tendance  la baisse
  
# d<-dist(DB[,c("Age","Survived"),with=F])
# h<-hclust(d)
# plot(h)  
# 
# k = cutree(tree = h, k = 50)
# table(k)

# var2cut<-DB$Age
cuts=c(0,2,5,12,18,45,60,70)
DB$Age_band<-as.factor(ds.dclust(DB$Age,cuts))

ggplot(data=DB, aes(Age_band, Survived, fill = Age_band)) +
  geom_boxplot() + geom_jitter()

ggplot(data=DB, aes(x=factor(Survived),fill = Age_band)) +
  geom_bar(position="dodge")+
  facet_wrap(~ Age_band, ncol = length(unique(DB$Age_band)))
# réarangement des levels
DB$Age_band<-factor(DB$Age_band,levels=c("0 - 2","2 - 5", "5 - 12","12 - 18", "18 - 45",  "45 - 60",  "60 - 70", "70 - Inf"))
# re plot
ggplot(data=DB, aes(x=factor(Survived),fill = Age_band)) +
  geom_bar(position="dodge")+
  facet_wrap(~ Age_band, ncol = length(unique(DB$Age_band)))+
  labs(title="Survival by age band")+
  theme(plot.title=element_text(face="bold", size=16))

# ggplot(val, aes(x=x, y=y, fill=col)) +
#   geom_bar(width = 1, stat = "identity") + 
#   labs(x = x.var, y = ifelse(count,"Count",y.var),
#        title=ifelse(!is.na(title),title,ifelse(count,paste0("Number of occurence of ",x.var),
#                                                paste0(y.var," % ",x.var))))
# 
# 
}

# DECISION TREES
{
  # rpart(): decision tree
  fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")
  plot(fit)
  text(fit)

  fancyRpartPlot(fit) # arbre sympatique
  pred<-list()
  pred[["rpart1"]] <- data.frame(PassengerId = test$PassengerId,
                                 Survived_emp = test$Survived,
                                 Survived_pred=predict(fit, test, type = "class"))
  pred[["rpart1"]]$test<-as.numeric(pred[["rpart1"]]$Survived_emp==pred[["rpart1"]]$Survived_pred)
  Prctg(sum(pred[["rpart1"]]$test)/nrow(pred[["rpart1"]]))
  
  submit <- data.frame(PassengerId = test$PassengerId, Survived = pred[["rpart1"]]$Survived_pred)
  write.csv(submit, file = "pred1_rpart.csv", row.names = FALSE)
}


# ggHist(DB,"Age_band","Survived")
# ggHist_s(DB,"Age_band","Survived")
# ggHist_m(DB,"Age_band","Survived")

# Age_band<-data.frame(names=NA,value=c(0,2,5,12,18,45,60,70,Inf))
  # DB$D_Sea2<-DSea_band$names[findInterval(DB$D_Sea,DSea_band$value)]
  
# FAMILY SIZE
{
  DB$FamilySize <- DB$SibSp + DB$Parch + 1
  table(DB$FamilySize)
  ggHist(DB,"FamilySize") # il y a presque autant de taille 1 que de taille >1
  # Il faudrait classifier ici pour voir si ce nombre est pertinent
  fit <- rpart(Survived ~ FamilySize, data=DB, method="class")
  fancyRpartPlot(fit) # arbre sympatique
}

# NAME MANAGEMENT
{
  # On reprend la DB initiale
  DB
  # Et on va travaille rsur le name qui contient un titre
  DB$Title <- sapply(DB$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
  DB$Title <- sub(' ', '', DB$Title)
  
  table(DB$Title)
  ggHist(DB,"Title")
  
  # On regroupe
  DB$Title2<-DB$Title
  DB$Title2[DB$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
  DB$Title2[DB$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir' # on pourrait regarder l'équipage de façon spécifique
  DB$Title2[DB$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'
  table(DB$Title2)
}


# AGE PREDICT
{
  # In order to run a random forest, we have to retreat missing (NA - " ", "") values
  # For age, I use a prediction
(table(DB$Age,useNA="always")) # 20% !
(prop.table(table(DB$Age,useNA="always"))) # 177 NAs - 20% !

  # Predict using rpart() - regression tree
  Agefit1 <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title2 + FamilySize,
                  data=DB[!is.na(DB$Age),], method="anova")
  # regarding variables: From an apriori side: 
    # Sex should be quite homogeneous around the age
    # Fare: peut de chance que les enfants aient réglés eux-mêmes leur billet
    # Le port d'embarquement peu éventuellement capturer un déséquilibre dans la répartition d'âge de la ville/région/pays
    # il y a sûrement des trucs + smart à faire
  Agefit1_pred<-round(predict(Agefit1, DB[is.na(DB$Age),]),0)
  
  # predict using glm()
  Agefit2 <- glm(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title2 + FamilySize,
                   data=DB[!is.na(DB$Age),],family="gaussian")

  Agefit2_pred<-round(predict(Agefit1, DB[is.na(DB$Age),]),0)
  
  compar<-data.frame(Name=DB$Name[is.na(DB$Age)],mod1=Agefit1_pred,mod2=Agefit2_pred)
#   compar<-melt(compar,id="Name",variable.name="predict_model")
# 
#   ggplot(data=compar, aes(x=factor(Survived),fill = Age_band)) +
#     geom_bar(position="dodge")+
#     facet_wrap(~ Age_band, ncol = length(unique(DB$Age_band)))
  compar$diff<-compar$mod1-compar$mod2
  table(compar$diff)
  
  # Les prédictions sont les mêmes : intéressant : à méditer
    
  DB$Age[is.na(DB$Age)] <- Agefit2_pred
}
  
summary(DB)

# RETREATMENT OF MISSING VALUES
{
  # Embarked
  table(DB$Embarked)
  DB$Embarked[which(DB$Embarked=='')]<-"S"
  # DB$Embarked<-as.factor(DB$Embarked)

  # Fare
  hist(DB$Fare)
  length(which(is.na(DB$Fare)))
  summary(DB$Fare)
  DB$Embarked[which(DB$Embarked=='')]<-"S"
  DB$Embarked<-as.factor(DB$Embarked)
}
 
# RANDOM FOREST
{
  set.seed(45)
  DB_save<-DB
  DB[,Age_band:=NULL]
  tmp<-ds.glm.data(DB)
  train<-tmp$db.train
  test<-tmp$db.test
  
  rf.fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title2 + FamilySize,
                         data=train, importance=TRUE, ntree=2000)
  # génère une erreur "NA" machin alors qu'il y en a pas
  sapply(DB,FUN=class)
  DB$Survived<-factor(DB$Survived)
  DB$Title2<-factor(DB$Title2)
  tmp<-ds.glm.data(DB)
  train<-tmp$db.train
  test<-tmp$db.test
  
  rf.fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title2 + FamilySize,
                         data=train, importance=TRUE, ntree=2000)
  varImpPlot(rf.fit) # plot 2 graph : regarder en détails mais en gros cela donne l'impact sur les prédictions lorsque
  # l'on enlève la variable
  # + associe un poids
  
 pred[["rf"]] <- data.frame(PassengerId = test$PassengerId, Survived_emp = test$Survived,Survived_pred=predict(rf.fit, test))
 
}

# FOREST OF CONDITIONAL INFERENCE TREES
{
  set.seed(415)
  fit <- cforest(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title2 + FamilySize,
                 data = train, controls=cforest_unbiased(ntree=2000, mtry=3))
#   Prediction <- predict(fit, test, OOB=TRUE, type = "response")
  pred[["cf"]] <- data.frame(PassengerId = test$PassengerId, Survived_emp = test$Survived,
                             Survived_pred=predict(fit, test, OOB=TRUE, type = "response"))
}

# SUBMISSION
{
  # I take all the data
  fit <- cforest(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title2 + FamilySize,
                 data = DB, controls=cforest_unbiased(ntree=2000, mtry=3))

  DB.test<-fread(file.path("data","test.csv")) # don't know the parameters
  
  # I submit
  submit <- data.frame(PassengerId = DB.test$PassengerId, Survived = predict(fit, DB.test, OOB=TRUE, type = "response"))
                         
                         
                         pred[["rpart1"]]$Survived_pred)
  write.csv(submit, file = "pred1_rpart.csv", row.names = FALSE)
}



    


