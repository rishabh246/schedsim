#!/bin/bash

# Workload types
MB995=3
MB5050=5
# Queueing algorithm
FIFO=0
PREEMPTION=2

SINGLE_QUEUE=0
NUM_CORES=16
QUANTUM=5 #us
SHINJUKU_CTX_COST=1 #us
CONCORD_CTX_COST=0.1 #us

build () {
  go build 
}

setup_mb_995() {
  MU="0.333611"
  WORKLOAD=$MB995
}

setup_mb_50() {
  MU="0.01980"
  WORKLOAD=$MB5050
}

run_workstealing(){
  python3 ./scripts/run_many.py run --topo=$1 --mu=$2 --gen_type=$3 --proc_type=$4 --num_cores=$5 
}

run_preemption(){
  python3 ./scripts/run_many.py run --topo=$1 --mu=$2 --gen_type=$3 --proc_type=$4 --num_cores=$5 --quantum=$6 --ctxCost=$7
}

collect_stats(){
  mv out.txt $1.txt
  python3 ./scripts/run_many.py csv $1.txt Keeper0$1.csv Keeper0 
  python3 ./scripts/run_many.py csv $1.txt Keeper1$1.csv Keeper1 
  python3 ./scripts/run_many.py csv $1.txt Overall$1.csv "Overall stats"
}

run_experiments(){
  run_workstealing $SINGLE_QUEUE $MU $WORKLOAD $FIFO $NUM_CORES
  collect_stats zygos
  run_preemption $SINGLE_QUEUE $MU $WORKLOAD $PREEMPTION $NUM_CORES $QUANTUM $SHINJUKU_CTX_COST
  collect_stats shinjuku
  run_preemption $SINGLE_QUEUE $MU $WORKLOAD $PREEMPTION $NUM_CORES $QUANTUM $CONCORD_CTX_COST
  collect_stats concord
}

CONFIG=$1

if ! [[ "$CONFIG" =~ ^(mb995|mb50)$ ]]; then
  echo "Unsupported workload: $CONFIG"
  echo "Supported workloads are mb995, mb50"
  exit
fi

build
if [[ $CONFIG == "mb995" ]]; then
  setup_mb_995
elif [[ $CONFIG == "mb50" ]]; then
  setup_mb_50
fi
run_experiments