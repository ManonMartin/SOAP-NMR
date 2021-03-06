#' @export SolventSuppression
SolventSuppression <- function(Fid_data, lambda.ss = 1e+06, ptw.ss = TRUE, 
                                returnSolvent = FALSE, verbose = FALSE) {
  
  # Data initialisation and checks ----------------------------------------------
  checkArg(verbose, c("bool"))
  begin_info <- beginTreatment("SolventSuppression", Fid_data,verbose = verbose)
  Fid_data <- begin_info[["Signal_data"]]
  checkArg(ptw.ss, c("bool"))
  checkArg(lambda.ss, c("num", "pos0"))
  
  
  # difsm function definition for the smoother -----------------------------------
  
  if (ptw.ss) {
    # Use of the function in ptw that smoothes signals with a finite difference
    # penalty of order 2
    difsm <- ptw::difsm
  } else  {
    # Or manual implementation based on sparse matrices for large data series (cf.
    # Eilers, 2003. 'A perfect smoother')
    difsm <- function(y, d = 2, lambda)  {
      
      m <- length(y)
      # Sparse identity matrix m x m
      E <- Matrix::Diagonal(m)
      D <- Matrix::diff(E, differences = d)
      A <- E + lambda.ss * Matrix::t(D) %*% D
      # base::chol does not take into account that A is sparse and is extremely slow
      C <- Matrix::chol(A)
      x <- Matrix::solve(C, Matrix::solve(Matrix::t(C), y))
      return(as.numeric(x))
    }
  }
  
  # Solvent Suppression ----------------------------------------------
  
  n <- dim(Fid_data)[1]
  if (returnSolvent)  {
    SolventRe <- Fid_data
    SolventIm <- Fid_data
  }
  for (i in 1:n) {
    FidRe <- Re(Fid_data[i, ])
    FidIm <- Im(Fid_data[i, ])
    solventRe <- difsm(y = FidRe, lambda = lambda.ss)
    solventIm <- difsm(y = FidIm, lambda = lambda.ss)
    
    # if (plotSolvent)  {
    #   m <- length(FidRe)
    #   graphics::plot(1:m, FidRe, type = "l", col = "red")
    #   graphics::lines(1:m, solventRe, type = "l", col = "blue")
    #   graphics::plot(1:m, FidIm, type = "l", col = "red")
    #   graphics::lines(1:m, solventIm, type = "l", col = "blue")
    # }
    
    FidRe <- FidRe - solventRe
    FidIm <- FidIm - solventIm
    Fid_data[i, ] <- complex(real = FidRe, imaginary = FidIm)
    if (returnSolvent) {
      SolventRe[i, ] <- solventRe
      SolventIm[i, ] <- solventIm
    }
  }

  
  # Data finalisation ----------------------------------------------
  
  Fid_data <- endTreatment("SolventSuppression", begin_info, Fid_data, verbose = verbose)
  if (returnSolvent) {
    return(list(Fid_data = Fid_data, SolventRe = SolventRe, SolventIm = SolventIm))
  } else {
    return(Fid_data)
  }
}
