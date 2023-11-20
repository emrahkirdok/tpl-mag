
library(optparse)

option_list <- list(
  make_option(c("--input"),help="Contig file name"),
  make_option(c("--prefix"), help = "Prefix information")
)

opt.parser <- OptionParser(option_list = option_list,
                           description="Usage: rename-contigs.R [options]")

opts <- parse_args(opt.parser)

con <- file(description=opts$input, open = "r")

command <- paste("wc -l", opts$input, "| cut -f1", sep = " ")

lines <- system(command=command, intern=T)

#cat(lines, "\n")

#for (i in 1:lines){
#
#	line <- scan(file=con, nlines=i, q
#
#}

for (line in readLines(opts$input)){
	if ( startsWith(line, ">") ){
		id <- strsplit(line, split=" ")[[1]][1]
		id <- gsub(pattern=">", replacement="", x=id)
		cat(paste0(">", opts$prefix,"_", id), "\n")
	}else{cat(line,"\n")}

}
