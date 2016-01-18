###########################################

# DM
# 12/01/2016

# Titanic study

# Context: DS training session II

# Source: https://www.kaggle.com/c/titanic/

###########################################


# Kaggle Process (cf. slide #28):
  # "train.csv" is used for the training/test part (internal)
  # Then the "test.csv" is where we use the model to predict and submit results



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
  DB<-fread(file.path("data","train.csv")) # don't know the parameters
  DB$origin<-"train.csv"
  
  DB2<-fread(file.path("data","test.csv")) # don't know the parameters
  DB2$origin<-"test.csv"
  DB2$Survived<-NA
  
  DB<-rbind(DB,DB2)
}


# 2. DATA OVERVIEW
{
  # COL FORMATS
  DB$Survived<-as.numeric(DB$Survived)
  DB$Pclass<-as.factor(DB$Pclass)
  DB$Age<-as.numeric(DB$Age)
  DB$Sex<-as.factor(DB$Sex)
  DB$ASibSpge<-as.numeric(DB$SibSp) # Number of Siblings/Spouses Aboard
  DB$Parch<-as.numeric(DB$Parch) # Number of Parents/Children Aboard
  DB$Fare<-as.numeric(DB$Fare) # Fare (prix trajet ?)
  DB$Cabin<-as.factor(DB$Cabin)
  DB$Embarked<-as.factor(DB$Embarked)
  
}


# NAME MANAGEMENT
{
  DB$Title <- sapply(DB$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
  DB$Title <- sub(' ', '', DB$Title)
  table(DB$Title)

  # On regroupe
  DB$Title[DB$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
  DB$Title[DB$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir' # on pourrait regarder l'équipage de façon spécifique
  DB$Title[DB$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'
  table(DB$Title)
}

# FAMILY SIZE
{
  DB$FamilySize <- DB$SibSp + DB$Parch + 1
  table(DB$FamilySize)
  ggHist(DB,"FamilySize") # il y a presque autant de taille 1 que de taille >1
}

# AGE PREDICT
{
  # In order to run a random forest, we have to retreat missing (NA - " ", "") values
  # For age, I use a prediction
(table(DB$Age,useNA="always")) # 20% !
(prop.table(table(DB$Age,useNA="always"))) # 263 NAs - 20% !

  # Predict using rpart() - regression tree
  Agefit1 <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize,
                  data=DB[!is.na(DB$Age),], method="anova")
  Agefit1_pred<-round(predict(Agefit1, DB[is.na(DB$Age),]),0)
  
  # predict using glm()
  Agefit2 <- glm(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title + FamilySize,
                   data=DB[!is.na(DB$Age),],family="gaussian")
  Agefit2_pred<-round(predict(Agefit1, DB[is.na(DB$Age),]),0)
  
  compar<-data.frame(Name=DB$Name[is.na(DB$Age)],mod1=Agefit1_pred,mod2=Agefit2_pred)

  compar$diff<-compar$mod1-compar$mod2
  table(compar$diff)
  
  DB$Age[is.na(DB$Age)] <- Agefit2_pred
}
  
summary(DB)

# RETREATMENT OF MISSING VALUES
{
  # Embarked
  table(DB$Embarked)
  DB$Embarked[which(DB$Embarked=='')]<-"S"

  # Fare
  ggHist(DB,"Fare")
  length(which(is.na(DB$Fare)))

  DB$Fare[is.na(DB$Fare)]<-median(DB$Fare,na.rm=T)
  
}
 
# FOREST OF CONDITIONAL INFERENCE TREES
{
  sapply(DB,class)
  DB$Title<-factor(DB$Title)
  train=DB[which(DB$origin=="train.csv"),];dim(train)
  test=DB[which(DB$origin=="test.csv"),];dim(test)

  set.seed(415)
  fit <- cforest(factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize,
                 data = train, controls=cforest_unbiased(ntree=2000, mtry=3))

  # Predict + submit
  submit <- data.frame(PassengerId = test$PassengerId, Survived = predict(fit, test, OOB=TRUE, type = "response"))
                         
  write.csv(submit, file = "forest_cond1.csv", row.names = FALSE)
}



    


