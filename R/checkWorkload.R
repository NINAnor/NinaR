#' checkWorkload
#'
#' See the current workload on your machine. ONLY WORKS ON LINUX!
#'
#' This function utilizes the function `top` from the package `NCmisc`, and the Linux system command `free` to gather info on the system usage.
#' In the "Processes" table, you can see the individual usage of the running processes. Look at the %CPU column in "Processes" to see how
#' busy the cores are. The number of total cores on the machine is shown in "Cores". In the "Memory" table, the "Available" column is the
#' thing of most interest.
#'
#' @param user_aggregate Summarize the processes on the user that started it? Boolean.
#' @param procs The number of processes to show for the "Processes" table, when not aggregating on user. Default = 50.
#'
#' @author Jens Åström
#' @import NCmisc parallel
#'
#' @return A list consisting of 1) he total number of cores on the machine, 2) an overview of the running processes, and 3) a summary of the memory usage. The overview of the running processes depends on `user_aggregate`
#'
#' @export

checkWorkload <- function(user_aggregate = TRUE,
                          sort_proc_by = c("CPU", "MEM"),
                          procs = 50){

  system <- Sys.info()["sysname"]
  if(system != "Linux") stop("This only works on Linux machines!")

  sort_proc_by <- match.arg(sort_proc_by, c("CPU", "MEM"))
  sort_proc_by <- switch(sort_proc_by,
                          "CPU" = "%CPU",
                          "MEM" = "%MEM"
                          )

   noCores <- parallel::detectCores()

  top <- NCmisc::top(Table = T,
                     procs = 100)

  memRaw <- system("free -mh ", intern = T)
  mem <- strsplit(memRaw, "\t")
  mem <- lapply(mem, function(x) gsub("\\s+", ",", x))
  mem[[1]] <- paste0("Type", mem[[1]])
  mem[[3]] <- c(mem[[3]], rep(",", 3))

  mem <- lapply(mem, function(x) unlist(strsplit(x, ",")))
  mem <- matrix(unlist(mem), nrow = 3, byrow=T)
  dimnames(mem) <- list(mem[, 1], mem[1, ])
  mem <- as.data.frame(mem[-1, -1], optional = T, stringsAsFactors = FALSE)

  if(user_aggregate){
    top_out <- top[[1]] %>%
      group_by(USER) %>%
      mutate_at(vars(`%CPU`,`%MEM`), as.numeric) %>%
      summarise_at(vars(`%CPU`,`%MEM`), sum)
  } else {
    top_out <- top[[1]] %>%
      mutate_at(vars(`%CPU`,`%MEM`), as.numeric)
  }

  top_out <- top_out %>%
    arrange(desc(!!sym(sort_proc_by)))

  out <- list("Cores" = noCores, "Processes" = top_out[1:procs, ], "Memory" = mem)

  return(out)
}



