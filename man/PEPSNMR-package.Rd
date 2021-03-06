\name{PepsNMR-package}
\alias{PepsNMR-package}
\alias{PepsNMR}
\docType{package}
\title{Metabolomic data pre-processing strategy for 1H NMR spectroscopic data
}
\description{
This package provides R functions for classic and advanced pre-processing steps that are applied
on 1H NMR data.
It also provides the function \code{\link{ReadFids}} to read the FID directly from the Bruker format.
Those pre-processing are cited below in the advised order of their application:
\describe{
  \item{\code{\link{GroupDelayCorrection}}}{Correct for the first order phase correction.}
  \item{\code{\link{SolventSuppression}}}{Remove solvent signal from the FIDs.}
  \item{\code{\link{Apodization}}}{Increase the sensitivity/resolution of the FIDs.}
  \item{\code{\link{ZeroFilling}}}{Improve the visual representation of the spectra.}
  \item{\code{\link{FourierTransform}}}{Transform the FID into a spectrum and convert the frequency scale (Hertz -> ppm).}
  \item{\code{\link{ZeroOrderPhaseCorrection}}}{Correct for the zero order phase correction.}
  \item{\code{\link{InternalReferencing}}}{Calibrate the spectra with internal compound referencing.}
  \item{\code{\link{BaselineCorrection}}}{Remove the spectral baseline.}
  \item{\code{\link{NegativeValuesZeroing}}}{Set negatives values to 0.}
  \item{\code{\link{Warping}}}{Warp the samples according to a reference spectrum.}
  \item{\code{\link{WindowSelection}}}{Select the informative part of the spectrum.}
  \item{\code{\link{Bucketing}}}{Data reduction by integration.}
  \item{\code{\link{RegionRemoval}}}{Set intensities of a desired region to 0.}
  \item{\code{\link{ZoneAggregation}}}{Aggregate a region to a single peak.}
  \item{\code{\link{Normalization}}}{Normalize the spectra.}
}
}
\details{
\tabular{ll}{
Package: \tab PepsNMR\cr
Type: \tab Package\cr
Version: \tab 0.99.0\cr
License: \tab GPLv2\cr
}
The FIDs are read using \code{\link{ReadFids}} which also gives a matrix with meta-information about each FID.
The other functions apply different pre-processing steps on these signals, and some need the info matrix as outputted from \code{ReadFids} .
During this pre-processing, the signal is transformed through fourier transformation and the frequency scale is expressed in ppm.
For more details and illustrated explanations about those pre-treatment steps, see the documentation of each function and/or the chapter 1 of the reference below.
}
\author{
Benoît Legat, Bernadette Govaerts & Manon Martin

Maintainer: Manon Martin <manon.martin@uclouvain.be>
}
\references{
Martin, M., Legat, B., Leenders, J., Vanwinsberghe, J., Rousseau, R., Boulanger, B., & Govaerts, B. (2018). PepsNMR for 1H NMR metabolomic data pre-processing. \emph{Analytica chimica acta}, 1019, 1-13.
  
 
  Rousseau, R. (2011). \emph{Statistical contribution to the analysis of metabonomics data in 1H NMR spectroscopy}
  (Doctoral dissertation, PhD thesis. Institut de statistique, biostatistique et sciences actuarielles, Université catholique de Louvain, Belgium).
}
\keyword{ package }

\examples{
path <-  system.file("extdata", package = "PepsNMRData")
dir(path)

fidList <- ReadFids(file.path(path, "HumanSerum"))
Fid_data <- fidList[["Fid_data"]]
Fid_info <- fidList[["Fid_info"]]
Fid_data <- GroupDelayCorrection(Fid_data, Fid_info)
Fid_data <- SolventSuppression(Fid_data)
Fid_data <- Apodization(Fid_data, Fid_info)
Fid_data <- ZeroFilling(Fid_data)
Spectrum_data <- FourierTransform(Fid_data, Fid_info)
Spectrum_data <- ZeroOrderPhaseCorrection(Spectrum_data)
Spectrum_data <- InternalReferencing(Spectrum_data, Fid_info)
Spectrum_data <- BaselineCorrection(Spectrum_data)
Spectrum_data <- NegativeValuesZeroing(Spectrum_data)
Spectrum_data <- Warping(Spectrum_data)
Spectrum_data <- WindowSelection(Spectrum_data)
Spectrum_data <- Bucketing(Spectrum_data)
Spectrum_data <- RegionRemoval(Spectrum_data, typeofspectra = "serum")
# Spectrum_data <- ZoneAggregation(Spectrum_data)
Spectrum_data <- Normalization(Spectrum_data, type.norm = "mean")
}
