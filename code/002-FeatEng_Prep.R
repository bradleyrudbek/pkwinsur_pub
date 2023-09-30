# 002-FeatEng_Prep.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
#	Here we do the variable transformations
#	we will need for modelling, but in the end
#	we decided to do some EDA on the pre-modelling
#	dataset as well for insights, thats why cm2 is inserted back here
#	again
#
#	This will be used for EDA and Modelling Steps
#
#
#


	# we want to perform all transformations at once here
        # before we do any test-set split, to make sure
        # the factor levels will be all aligned
        m2 <- m1

        # Stage 2 Transformations can be done here
        # we don't use any of these variables in Stage 1
        # anyways

        m2$sumClaims <- pmin(m2$sumClaims,15000)
        m2$target <- m2$sumClaims/m2$Exposure
        m2$target <- pmin(m2$target,150000)


        m2$VehPower <- as.factor(pmin(m1$VehPower,9))
        m2$VehGas  <- as.factor(m1$VehGas)
        m2$VehAge   <- cut(m1$VehAge, breaks = c(0,2,5,10,15,Inf), include.lowest = TRUE, ordered_result = TRUE)
        m2$DrivAge <-  cut(m1$DrivAge, breaks = c(18,25,35,45,55,Inf), include.lowest = TRUE, ordered_result = TRUE)
        m2$Density <-  cut(m1$Density, breaks = c(0,100,200,500,1000,Inf),  include.lowest = TRUE, ordered_result = TRUE)

        m2$BonusMalus <-  as.integer(pmin(m1$BonusMalus, 150))

	cm2 <- subset(m2, !is.na(sumClaims))
