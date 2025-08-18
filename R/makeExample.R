#' Create an example object
#'
#' @param what What do you want to create? Valid options are meta (for a metadata table), asv (for an ASV table), or taxa (for a taxonomy table)
#'
#' @returns Either a metadata, ASV, or taxonomy table.
#' @export
#'
#' @examples
#' metadata <- makeExample("meta")
#' asvtable <- makeExample("asv")
#' taxa     <- makeExample("taxa")
makeExample <- function(what=NULL){
  if(is.null(what)){
    return(list("metadata" = makeExampleMeta(), "asvtable" = makeExampleSeqtab(), "taxa" = makeExampleTaxa()))
  }
  if(is.null(what) | what=="all"){
    return(list("metadata" = makeExampleMeta(), "asvtable" = makeExampleSeqtab(), "taxa" = makeExampleTaxa()))
  }
  if(what=="meta"){
    return(makeExampleMeta())
    }
  if(what=="asv"){
    return(makeExampleSeqtab())
    }
  if(what=="taxa"){
    return(makeExampleTaxa())
    }
  if(what != "meta" & what != "asv" & what != "taxa" & what != "all" & !is.null(what)){
    stop("Valide options are meta, asv, or taxa.")
    }
}


