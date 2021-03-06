#' Posterior Probabilities for Knockdown Data
#'
#' Calculates posterior probabilities for edges from a knocked-down gene
#' to each of a set of potential target genes. More generally, it
#' calculates posterior probabilities between a single predictor variable
#' and each of a set of response variables, incorporating prior probabilities
#' potentially unique to each response variable.
#'
#' @param x     \code{n}-vector of predictor data. In knockdown experiments, 
#'              this is a vector of the expression levels of the knocked-down
#'              gene across n experiments.
#' @param y     Outcome matrix: \code{p} (number of outcomes measured) 
#'              by \code{n} (number of samples).
#'              In knockdown experiments, this is a matrix of all the gene
#'              measurements for genes that were not knocked down.
#' @param prior Prior probabilities for the outcome variables. Defaults to 0.5
#'              for all variables.
#' @param g     The value to use for Zellner's \emph{g}-prior.
#'              Defaults to the square root of the number of observations.
#' @return      A vector of \code{p} posterior probabilities indicating
#'              the probability of a relationship between the predictor
#'              variable and each outcome variable.
#' @examples
#' n <- 100;
#' p <- 10;
#' x <- rnorm(n);
#' y <- matrix(nrow=p, data=rnorm(n*p));
#' y[3,] <- y[3,] + 0.5*x;
#'
#' BayesKnockdown(x, y);
#' @export
BayesKnockdown <- function(x, y, prior=0.5, g=sqrt(length(x))) {
    n <- length(x);
    assert(n == ncol(y),
         "The number of samples (columns of y) does not match the length of the predictor");
    assert((sum(prior < 0) + sum(prior >= 1)) == 0,
         "Prior probabilities must be between 0 and 1.");
    if ( g < 1 | g > n ) {
        warning("g recommended to be between 1 and the number of observations");
    }

    stats <- apply( y, 1, function(i){
        c(cor(x[is.finite(i)], i[is.finite(i)])^2, sum(is.finite(i)))
    });
    r2 <- apply( y, 1, cor, x )^2;
    po <- prior/(1-prior) * exp((stats[2,]-2)*log(1+g)/2 -
                                (stats[2,]-1)*log(1+g*(1-stats[1,]))/2);
    pp <- po/(1+po);
    pp;
}

#' Posterior Probabilities for 2-class Data
#'
#' Calculates posterior probabilities for each gene in a set of experiments is
#' differentially expressed between two sets of experimental conditions. More
#' generally, it calculates posterior probabilities that each measured variable
#' is different between two classes, incorporating prior probabilities
#' potentially unique to each variable.
#'
#' @param y1    Condition 1 outcome matrix: \code{p} (number of outcomes
#'              measured) by \code{n1} (number of samples for condition 1).
#' @param y2    Condition 2 outcome matrix: \code{p} (number of outcomes
#'              measured) by \code{n2} (number of samples for condition 2).
#' @param prior Prior probabilities for the outcome variables. Defaults to 0.5
#'              for all variables.
#' @param g     The value to use for Zellner's \emph{g}-prior.
#'              Defaults to the square root of the number of observations
#'              (combined across both conditions).
#' @return      A vector of \code{p} posterior probabilities indicating
#'              the probability that each outcome variable is different
#'              between the two classes.
#' @examples
#' n1 <- 25;
#' n2 <- 30;
#' p <- 10;
#' y1 <- matrix(nrow=p, data=rnorm(n1*p));
#' y2 <- matrix(nrow=p, data=rnorm(n2*p));
#' y2[3,] <- y2[3,] + 1;
#'
#' BayesKnockdown.diffExp(y1, y2);
#' @export
BayesKnockdown.diffExp <- function(y1,
                                   y2,
                                   prior=0.5,
                                   g=sqrt(ncol(y1) + ncol(y2))) {

    assert(nrow(y1)==nrow(y2), "y1 and y2 must have the same number of rows");
    BayesKnockdown(c(rep(0, ncol(y1)), rep(1, ncol(y2))),
                   cbind(y1, y2),
                   prior,
                   g);
}

#' Posterior Probabilities for ExpressionSet data
#'
#' Calculates posterior probabilities for an ExpressionSet object by defining
#' one feature as the predictor. Each other feature in the ExpressionSet is
#' is then used as a response variable and posterior probabilities are
#' calculated, incorporating prior probabilities potentially unique to each
#' response variable.
#'
#' @param es          An ExpressionSet object with \code{p} features and
#'                    \code{n} samples.
#' @param predFeature The name of the feature to use as the predictor.
#' @param prior       Prior probabilities for the outcome variables.
#'                    Defaults to 0.5 for all variables.
#' @param g           The value to use for Zellner's \emph{g}-prior.
#'                    Defaults to the square root of the number of observations.
#' @return            A vector of \code{p-1} posterior probabilities indicating
#'                    the probability of a relationship between the predictor
#'                    variable and each outcome variable.
#' @examples
#' library(Biobase);
#' data(sample.ExpressionSet);
#' subset <- sample.ExpressionSet[1:10,];
#'
#' BayesKnockdown.es(subset, "AFFX-MurIL10_at");
#' @export
BayesKnockdown.es <- function(es, predFeature, prior=0.5,
                                         g=sqrt(dims(es)[2,1])) {
  data <- exprs(es);
  BayesKnockdown(data[featureNames(es)==predFeature,],
                 data[featureNames(es)!=predFeature,],
                 prior, g);
}
