assert <- function(cond, msg="error encountered") {
    if ( !cond ) {
        stop(msg);
    }
}
