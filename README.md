# chalc.rad

## Flowchart of analyses done for this paper (click on each box to see details)

```mermaid
graph TD
id1[tissue samples] --> 0[DNA extraction]
style id1 fill:#6666FF,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
0 --> 01[RAD library prep]
01 --> a[raw illumina data]
a --> b[demultiplexing]
b --> c[per sample quality control using fastqcR]
c -- optimization of Stacks denovo assembly parameters --> d[optimize m]
d --> e[optimize M]
e --> f[optimize n]
f --> g[unfiltered, optimized denovo assembled SNP dataset]
g --> h[quality filter SNP dataset using SNPfiltR]
h --> i[filtered dataset, xx samples, xxx SNPs]
h --> j[filtered, unlinked dataset, xx samples, xxx SNPs]
g --> p[calculate Pi and heterozygosity]
j --> l[ADMIXTURE]
i --> u[popVAE]
i --> t[SplitsTree]
i --> v[pairwise Fst]
i --> k[Dsuite]
click 0 "https://github.com/DevonDeRaad/chalc.rad/tree/main/dna.extraction.protocol" _blank
click 01 "https://github.com/DevonDeRaad/chalc.rad/tree/main/library.prep.protocol" _blank
click a "link to NCBI bioproject" _blank
click b "https://github.com/DevonDeRaad/chalc.rad/tree/main/demultiplex.sh" _blank
click c "https://github.com/DevonDeRaad/chalc.rad/tree/main/fastqcr.html" _blank
click d "https://github.com/DevonDeRaad/chalc.rad/tree/main/optimize.denovo.html" _blank
click e "https://github.com/DevonDeRaad/chalc.rad/tree/main/optimize.denovo.html" _blank
click f "https://github.com/DevonDeRaad/chalc.rad/tree/main/optimize.denovo.html" _blank
click h "https://github.com/DevonDeRaad/chalc.rad/tree/main/snpfiltr.html" _blank
```
https://devonderaad.github.io/chalc.rad/chalc.investigate.missing.data.html

https://devonderaad.github.io/chalc.rad/chalc.investigate.pop.struc.html
