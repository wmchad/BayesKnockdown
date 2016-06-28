\name{lincs.kd}
\alias{lincs.kd}
\docType{data}
\title{
LINCS L1000 Knockdown Example Dataset
}
\description{
Example knockdown dataset from the National Institute of Health (NIH)
Library of Integrated Network-based Cellular Signatures (LINCS) program
(\url{http://lincsproject.org}).
}
\usage{data("lincs.kd")}
\value{matrix}
\format{
  The data is a 21x27 matrix. Each row is the expression level of a
  different gene across 27 knockdown experiments.
}
\details{
This data is from the National Institute of
Health (NIH) Library of Integrated Network-based Cellular Signatures
(LINCS) program (htpp://lincsproject.org). The aim
of this program is to generate genetic and molecular signatures of
cells in response to various perturbations. To support this endeavor,
many large datasets have been made available, including proteomic and
imaging data.

The data is from knockdown experiments
targeting gene PPARG in cell line A375. The first row is the
expression levels of PPARG in 27 different experiments, while the
other rows are a subset of the measured genes in the same
experiments. The data has been normalized to account for differences
in the experimental settings, as described in Young, et al. (2016).
}
\source{
  http://lincscloud.org
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
  Duan, Q., et al. (2014),
  LINCS Canvas Browser: interactive web app to query, browse and
  interrogate LINCS L1000 gene expression signatures.
  Nucleic Acids Research, gku476
}
\examples{
data(lincs.kd)
}
\keyword{datasets}
