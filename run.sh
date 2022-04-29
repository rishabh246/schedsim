#!/bin/bash

go build 

# Commands to run all three configurations for the MB[99.5-0.5] workload
 
python3 ./scripts/run_many.py run --topo=0 --mu=0.333611 --gen_type=3 --proc_type=0 --num_cores=16 
mv out.txt zygos.txt
python3 ./scripts/run_many.py csv zygos.txt zygosKeeper0.csv Keeper0 
python3 ./scripts/run_many.py csv zygos.txt zygosKeeper1.csv Keeper1 

python3 ./scripts/run_many.py run --topo=0 --mu=0.333611 --gen_type=3 --proc_type=2 --num_cores=16 --quantum=5 --ctxCost=1
mv out.txt shinjuku.txt
python3 ./scripts/run_many.py csv shinjuku.txt shinjukuKeeper0.csv Keeper0 
python3 ./scripts/run_many.py csv shinjuku.txt shinjukuKeeper1.csv Keeper1 

python3 ./scripts/run_many.py run --topo=0 --mu=0.333611 --gen_type=3 --proc_type=2 --num_cores=16 --quantum=5 --ctxCost=0.1
mv out.txt concord.txt
python3 ./scripts/run_many.py csv concord.txt concordKeeper0.csv Keeper0 
python3 ./scripts/run_many.py csv concord.txt concordKeeper1.csv Keeper1 