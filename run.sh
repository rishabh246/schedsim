#!/bin/bash

# Commands to run all three configurations for the MB[99.5-0.5] workload
 
python3 ./scripts/run_many.py run --topo=0 --mu=0.333611 --gen_type=3 --proc_type=0 --num_cores=16 && python3 ./scripts/run_many.py csv
mv out.txt zygos.txt
mv out.csv zygos.csv

python3 ./scripts/run_many.py run --topo=0 --mu=0.333611 --gen_type=3 --proc_type=2 --num_cores=16 --quantum=5 --ctxCost=1 && python3 ./scripts/run_many.py csv
mv out.txt shinjuku.txt
mv out.csv shinjuku.csv

python3 ./scripts/run_many.py run --topo=0 --mu=0.333611 --gen_type=3 --proc_type=2 --num_cores=16 --quantum=5 --ctxCost=0.1 && python3 ./scripts/run_many.py csv
mv out.txt concord.txt
mv out.csv concord.csv