# utils_funcs.R
#---------------------------------------------------------------------
# R reproducible framework
#----------------------------------------------------------------------
# 
#
# 	Utility functions do be called either from notebooks
#	or in one of our analysis files
#
#




#   evaluates a Cut-Off 
#   for a classification Problem
evalCut <- function(pred_probs,test_target,cutoff=0.06) {
    y_pred <- ifelse(pred_probs > cutoff,1,0)
    y <- test_target

    tp <- sum(y_pred == 1 & y == 1)
    tn <- sum(y_pred == 0 & y == 0)
    fp <- sum(y_pred == 1 & y == 0)
    fn <- sum(y_pred == 0 & y == 1)
    # Sensitivity, hit rate, recall, or true positive rate
    tpr <- tp/(tp+fn)
    # Specificity or true negative rate
    tnr <- tn/(tn+fp)
    # Precision or positive predictive value
    ppv  <- tp/(tp+fp)
    # Negative predictive value
    npv  <- tn/(tn+fn)
    # Fall out or false positive rate
    fpr  <- fp/(fp+tn)
    # False negative rate
    pnr  <- fn/(tp+fn)
    # False discovery rate
    fdr  <- fp/(tp+fp)

    F1score <- 2* (ppv*tpr)/(ppv+tpr)


     # Overall accuracy
     acc = (tp+tn)/(tp+fp+fn+tn)

    confusion.matrix <- matrix(c(tp,fn,fp,tn),byrow=TRUE,ncol=2)
    return(list(confusionMatrix=confusion.matrix,tpr=tpr,tnr=tnr,ppv=ppv,npv=npv,fpr=fpr,fdr=fdr,acc=acc, F1score = F1score))

}

exportPy <- function(m3) {

        # lets export only a subset with the variables we will use in the model
        m3 <- subset(m2, select = c(Claim,VehPower,VehAge,DrivAge,BonusMalus,VehBrand,VehGas,Density,Region,Area))
        write.csv(m3, sandbox("m3.csv"), row.names = FALSE)
}


plot_exp_coeffs <- function(glm.obj, alpha.cutoff =  0.05, target = 'target variable name', dist = 'z') {

        model_summary <- summary(glm.obj)


        p_values <- coef(model_summary)[, paste("Pr(>|", dist, "|)", sep ='')]
        # Choose a significance level
        alpha <- alpha.cutoff

        significant_coef <- coef(glm.obj)[p_values < alpha]

        # Extract coefficients, removing Intercept
        coeffs <- sort(exp(significant_coef)[-1])

        # Set up the plot
        barplot_height <- abs(coeffs)
        barplot_names <- names(coeffs)
        barplot_colors <- ifelse(coeffs > 1, "#034EA2", "#DC5797") # uses our Pallete in KeyNote

        par(mar = c(8, 4, 4, 2) + 0.1)  # Adjust the bottom margin
        # Create the bar plot
        barplot(barplot_height, names.arg = barplot_names, col = barplot_colors,
                main = "GLM Coefficients Significant at 5%", ylab = "Exp(Coefficient)", las = 2)

        # Add a legend
        legend("topleft", inset = 0.05, legend = c(paste("Positive Effect an ", target, sep = ""), paste("Negative Effect an ", target, sep = "")), fill = c("#034EA2", "#DC5797"))

}
