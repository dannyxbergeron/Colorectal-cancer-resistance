log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library("DESeq2")

#Loading count matrix from file, converting to integer
counts <- read.table(
	snakemake@input[["counts"]], header=TRUE,
	row.names="gene", check.names=FALSE
)

counts <- as.matrix(counts)
mode(counts) <- "integer"


# Loading samples information from file.
all_samples <- read.table(
    snakemake@input[["samples"]], header=TRUE,
    row.names="sample", check.names=FALSE
)


dir.create(snakemake@output[["results"]], showWarnings=FALSE)
# Looping through the samples
for (cell in c("A", "B", "C")) {
	for (i in 0:4) {
		for (j in (i+1):5) {

			if((i==0 && j == 4) || (i==0 && j == 5) ||
				(i==1 && j == 3) || (i==1 && j == 5) ||
				(i==2 && j == 3) || (i==2 && j == 4))
				next

			exp <- sprintf("%s%s-%s%s", cell, i, cell, j)
			base <- sprintf("%s%s", cell, i)
			other <- sprintf("%s%s", cell, j)

			# Slicing
			samples <- subset(all_samples, condition==base | condition==other)
			count <- counts[,c(row.names(samples))]


			# Calculating DESeq2
			dds <- DESeqDataSetFromMatrix(
		    		countData=count,
		    		colData=samples,
		    		design= ~condition
			)


			dds$condition <- relevel(dds$condition, ref=base)
			dds <- DESeq(dds)
			results = results(dds, coef=exp)

		    	# Writing results to file
			fname <- paste(
				snakemake@output[["results"]],
				paste(exp, "csv", sep='.'), sep='/'
			)

			write.csv(
			        as.data.frame(results),
			        file=fname,
			        quote=FALSE
			)
		}
	}
}
