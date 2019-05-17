// Name
params.name = "TM Align"

// input sequences to align [FASTA]
params.seqs = "$baseDir/seqs/*.fasta"

// input reference sequences aligned [Aligned FASTA]
params.template = "$baseDir/templates/*_ref.template_list2"

params.method = "sap_pair TMalign_pair"
// output directory [DIRECTORY]
params.output = "$baseDir/results"


log.info """\
         TM Align   A n a l y s i s  ~  version 0.1"
         ======================================="
         Name                                                  : ${params.name}
         Input sequences (FASTA)                               : ${params.seqs}
         Input templates (TEMPLATE_LIST)                       : ${params.template}
         Method                                                : ${params.method}
         """
         .stripIndent()

// Channels for sequences [REQUIRED]
Channel
  .fromPath(params.seqs)
  .ifEmpty{ error "No Seqs found in ${params.seqs}"}
  .map { item -> [ item.baseName, item] }
  .into { seqs; seqs2; seqs3  }

// Channels for reference alignments [OPTIONAL]
Channel
    .fromPath(params.template)
    .ifEmpty{ error "No Templates found in ${params.template}"}
     .map { item -> [ item.simpleName.tokenize("_")[0], item] }
    .into { template; template2 }

seqs2
    .combine( template, by: 0 )
    .set { seqsAndTemplates }

process tm_align {
    tag "${id}"
    publishDir "${params.output}", mode: 'copy', overwrite: true
    
    input:
      set val(id), \
          file(seqs), \
          file(template) \
          from seqsAndTemplates

    output:
      set val(id), \
      file("${id}.dnd"), file("${id}.aln"), file("${id}.html") \
      into results

     script:
       """
       t_coffee -seq ${seqs} -template_file ${template} -method ${params.method}
       """
}
 workflow.onComplete {
    println "\n\nExecution status: ${ workflow.success ? 'OK' : 'failed' } runName: ${workflow.runName}"
    println "Command line: $workflow.commandLine"
}
