##TM_Align
Pipeline to run TMalign_pair

The structure is defined as follow:
- Input fasta files are in the **seqs** folder.
- Input templates are in the **template** folder.

- The outputs (aln, dnd & html) are on the **results** folder.

The command line to run the workflow is : ``` nextflow run main.nf --with-singularity```

Nowadays, the pipeline just run 
```
t_coffee -seq  <seqs> -template_file <template> -method sap_pair TMalign_pair
```
