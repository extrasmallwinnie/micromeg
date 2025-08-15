#' Creates a simple example ASV table
#'
#' @returns A simple ASV table
#' @export
#'
#' @examples
#' makeExampleSeqtab()
makeExampleSeqtab <- function(){
  tibble::tibble(SampleID=c("HC1", "HC2", "HC3", "Sick1", "Sick2", "Sick3", "Sick4"),
                 ASV1=c(1856, 25732, 3385, 29939, 29954, 29724, 1),
                 ASV2=c(11652, 4775, 6760, 26217, 16142, 2771, 2),
                 ASV3=c(13681, 2902, 6184, 18965, 9656, 26380, 0),
                 ASV4=c(2994, 1628, 569, 4483, 9373, 7803, 5),
                 ASV5=c(9111, 1061, 7081, 3018, 3221, 8003, 1),
                 ASV6=c(3995, 13536, 8358, 217, 9506, 8157, 0),
                 ASV7=c(10821, 6216, 8780, 1599, 4237, 13010, 0),
                 ASV8=c(3937, 4089, 2907, 12441, 294, 8469, 0),
                 ASV9=c(4, 6, 8, 6, 6, 7, 1))
}
