# 003-Data_Split.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
#
#	Here we do a Train/Test/Validation Split
#	and prepare the datasets for modelling
#
#


	require(caret)
        set.seed(24)


        # Define the proportion of data you want to allocate to the training, validation, and test sets
        train_prop <- 0.8  # 80% for training
        valid_prop <- 0.1  # 10% for validation
        # The remaining 10% will be for testing

        # Create the training set
        trainIndex <- createDataPartition(m2$Claim, p = train_prop, list = FALSE)
        m2_train <- m2[trainIndex, ]

        # Split the remaining data into validation and test sets
        remaining_set <- m2[-trainIndex, ]
        validIndex <- createDataPartition(remaining_set$Claim, p = valid_prop / (1 - train_prop), list = FALSE)
        m2_valid <- remaining_set[validIndex, ]
        m2_test <- remaining_set[-validIndex, ]

        cm2_train <- subset(m2_train, !is.na(sumClaims))
        cm2_valid <- subset(m2_valid, !is.na(sumClaims))
        cm2_test <- subset(m2_test, !is.na(sumClaims))
