# CHANGES proposed to PythonCyc 1.0
# Rodrigo Santibáñez @ Network Biology Lab (NBL), Universidad Mayor, 2019

# Beware that there is a number of functions that works in the 
# pathway tools lisp interpreter (ptlisp), but no from the python interface.
# For those functions, the API prints the query to the standard output.

Section 5 API functions
- Section 5.1 enumeration functions
* The documentation of the function all-rxns has the argument type that could be set to non-spontaneous. However, the valid cases are :ALL, :PROTEIN-SMALL-MOLECULE-REACTION, :PROTEIN-REACTION, :TRNA-REACTION, :SPONTANEOUS, :SPONTANEOUS-HT, :ENZYME, :ENZYME-HT, :SMALL-MOLECULE, :SMALL-MOLECULE-HT, :METAB-PATHWAYS, :ALL-RXNS-METAB-PATHWAYS-WITH-DUPLICATES-HT, :METAB-SMM, :SMM, :METAB-SMM-HT, :METAB-COMPLETE-SMM, :METAB-ALL, :TRANSPORT-HT, :TRANSPORT, and :ENZYME-NOT-IN-PWY. The docstring was updated with the valid cases (but not their descriptions).
* The documentation of the function all_transported_chemicals has a valid argument show_compartment. However, the pythoncyc API doesn't include the argument. Added the keyword to PGDB.py, line 787. Tested in pathway tools lisp interpreter with (with-organism (:org-id '|ECOLI|) (all-transported-chemicals :primary-only? nil :show-compartment 'CCO-CYTOSOL )) returning a list of instances and classes, but I doubt if I give a valid show-compartment keyword.

- Section 5.1.1 operations on reactions
* The documentation of the function enzymes_of_reaction has the arguments experimental-only? and local-only-p. However, the pythoncyc API has close similar  experimental_only and local_only arguments. To be consistent with documentation, I changed the local_only argument to local_only_p.
* The documentation has the description for the rxn-without-sequenced-enzyme-p function, but the lisp function is reaction-without-sequenced-enzyme-p. Moreover, the describe function says reaction-without-sequenced-enzyme-p doesn't recognize the argument complete?. I tested in the lisp interpreter with (with-organism (:org-id '|ECOLI|) (reaction-without-sequenced-enzyme-p '|RXN-15348| )) returning T. However when I run the code in python, it fails with An internal error occurred in the running Pathway Tools application: :error, The function 'REACTION-WITHOUT-SEQUENCED-ENZYME-P' is not allowed to be called in restricted mode.
* The function pathway-hole-p don't have the argument hole-if-any-gene-without-position? as tested with the describe function in the lisp interpreter. I deleted the argument from the API.
* The function rxn-present? is incorrectly queried as rxn-present-p. Tested with (with-organism (:org-id '|ECOLI|) (rxn-present? '|RXN-15348| )) returning T. Moreover, the lisp function has the INCLUDE-SPONTANEOUS? argument absent from the documentation and from the API: (with-organism (:org-id '|ECOLI|) (rxn-present? '|RXN-15348| :INCLUDE-SPONTANEOUS )) returns T, but fails if  (with-organism (:org-id '|ECOLI|) (rxn-present? '|RXN-15348| :INCLUDE-SPONTANEOUS? T )). I don't know (yet) how to add the argument to the code.
* The documentation describes the function compartment-of-rxn but it isn't a function or wasn't defined as a function. Tested with (describe 'compartment-of-rxn).

- Section 5.1.2 Operations on pathways
* sorted argument of functions genes_of_pathway and enzymes_of_pathway now works. Probably it should be renamed because of a clash with the python sorted function.

- Section 5.1.3 Operations on Enzymatic Reactions
* er argument of functions enzrxn_activators and enzrxn_inhibitors was changed to enzrxn for consistency with other functions.
* function pathway-allows-enzrxn is implemented in ptools as pathway-allows-enzrxn?, but gives the following error: function 'PATHWAY-ALLOWS-ENZRXN?' is not allowed to be called in restricted mode

- Section 5.1.4 Operations on Proteins.
* p argument of functions monomers_of_protein and base_components_of_protein changed to protein for consistency with other functions
* functions reduce_modified_proteins and genes_of_proteins always require a list of proteins, even if the list has only one element. I added a check to make sure the functions work even if the user mistakenly gives a single frameid.
* the argument INCLUDE-SUBREACTIONS? from function reactions-of-enzyme is undocumented. I included it in the pythoncyc API. I don't know how to use the kb argument of the function
* incomplete documentation for enzyme_p; argument type admits non-transport-non-pathway and the argument was renamed to type_of_reactions because of clash with python type function
* LEADER-PEPTIDE-P is implemented as LEADER-PEPTIDE?. Changes don't work similarly to pathway-allows-enzrxn?.
* argument compartments is mandatory but it wasn't present in function protein_in_compartment_p. Added to the function and works correctly.
* problem: (with-organism (:org-id '|ECOLI|) (all-transporters-across  :membranes '|CCO-MEMBRANE| )) returns NIL when it should be equivalent to (with-organism (:org-id '|ECOLI|) (all-transporters-across  :membranes :all )), according to the documentation

- Section 5.1.5 Operations on Genes.
* item argument on function gene_p changed to gene for consistency with ther function
* INCLUDE-GENE-PROD-AS-SUBSTRATE? argument of function pathways-of-gene is undocumented and not present in pythoncyc API and it was added. As well, argument  INCLUDE-SUPER-PWYS? is now correctly interpreted.
* documentation has the function connecting-genes but isn't present in ptools. Tested with (apropos "connecting")
* documentation states that argument max-gap of functions gene-clusters and neighboring-genes-p is optional, but the API set it to None. Changed to 10 to match the documentation.
* adjacent_genes_p and neighboring_genes_p functions check if the two genes are the same, returning None if they are "adjacent" or "neighbors"
* rna_coding_gene is implemented as rna_coding_gene?.  Changed and tested with (with-organism (:org-id '|ECOLI|) (rna-coding-gene? '|EG11414| )) but pythoncyc fails similarly to pathway-allows-enzrxn?

- Section 5.1.6 Operations on Regulatory Frames
* transcription_factor_p is implemented as transcription-factor? and regulator_of_type as regulator_of_type?. Both work correctly in the lisp interpreter but pythoncyc fails similarly as pathway-allows-enzrxn?
* regulators_of_operon_transcription function accept only lists, similarly to reduce_modified_proteins, also modified in the same way to ensure the function receives a list even if the user gives a single frameid.
* problem: I don't know how to use the mode argument in transcription_factor_ligands function, therefore I don't know if the function works or not.

- Section 5.1.7 Operations on Compounds
* substrate-of-generic-rxn is implemented as substrate-of-generic-rxn?, works in the interpreter but not from pythoncyc.
* documentation defines the function activated-or-inhibited-by-compound, but pythoncyc has the deactivated-or-inhibited-by-compound. I modified the function but raises the error function is not allowed to be called in restricted mode, but works in the lisp interpreter. I'm out of ideas for the reason of this recurrent error.

- Section 5.1.8 Object Name Manipulation Operations
* get-name-string fails and working on it
* full_enzyme_name optional arguments were included in the function, been the reason of failure. Changed to kwargs and working
