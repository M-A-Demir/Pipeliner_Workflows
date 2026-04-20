#!/bin/bash

#SBATCH -p cs05r
#SBATCH -J 'compress'
#SBATCH -o output.log
#SBATCH -e error.log
#SBATCH -t 72:00:00
#SBATCH --nodes=4
#SBATCH --cpus-per-task=40

DIRS_TO_COMPRESS=("/dls/m12/data/2026/cm44187-1/spool/betagal/MotionCorr/job002/Movies/GridSquare_27367468/Data"
"/dls/m12/data/2026/cm44187-1/spool/betagal/MotionCorr/job002/Movies/GridSquare_27367466/Data"
"/dls/m12/data/2026/cm44187-1/spool/betagal/MotionCorr/job002/Movies/GridSquare_27367464/Data"
"/dls/m12/data/2026/cm44187-1/spool/betagal/MotionCorr/job002/Movies/GridSquare_27367177/Data")

OUTDIR=/dls/m12/data/2025/cm40657-1/out_compressed
COMPRESSION_SCHEMES=("terse" "pbzip2" "blosc-zstd" "blosc2-zstd")

for d in "${DIRS_TO_COMPRESS[@]}"; do

  for scheme in "${COMPRESSION_SCHEMES[@]}"; do
    echo "Processing $d"

    rm -f ${OUTDIR}/*.tif*
    rm -f ${OUTDIR}/*.mrc*

    if ! srun python -m ccp_dcompress.scripts.run_compression --compression_scheme ${scheme} --unit "GB" --filepath ${d} --outdir ${OUTDIR}; then
      echo "FAILED: $d with $scheme — skipping"
      continue
    fi

    #srun emencode_compress -s ${scheme} -i ${d} -o ${OUTDIR} -u GB

    done
done

echo "Done."
