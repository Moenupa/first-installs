# --- useful slurm aliases ---
if ! command -v scontrol &> /dev/null; then
	return 0
fi

# better default formats
export SQUEUE_FORMAT="%.10i %.5P %.30j %.10u %.2t %.12M %.2D %R"
export SACCT_FORMAT="JobID%-10,JobName%-24,State,ExitCode,Start,End,Elapsed,NodeList,WorkDir%-10"

# shortcuts, should not conflict
alias sb='sbatch'
alias scc='scancel'
alias sq='squeue'
alias sd='scontrol show jobid -d'
alias usq="squeue -u $USER"
alias slist="sacct -u $USER -X -S now-3days"
# sorted by start time
alias shist="(slist | head -n 2; slist -n | sort -k 5 -r)"
# sorted by end time
alias slast="(slist | head -n 2; slist -n | sort -k 6 -r)"

# slurm log finding/listing
sl() {
	if [[ $# -eq 0 ]]; then
		echo "Finds stdout and stderr for a slurm job"
		echo "Usage: $0 <jobid> [jobid2 jobid3 ...]"
		return 1
	fi

	local jobid jobinfo stdout stderr
	for jobid in "$@"; do
		if ! jobinfo=$(scontrol show job "$jobid" 2>/dev/null); then
			echo "Error: Could not find job $jobid" >&2
			continue
		fi

		stdout=$(grep -oP 'StdOut=\K\S+' <<< "$jobinfo")
		stderr=$(grep -oP 'StdErr=\K\S+' <<< "$jobinfo")

		echo "\e[7;32mOUT-$jobid\e[0m $stdout"
		echo "\e[7;35mERR-$jobid\e[0m $stderr"
	done
}
sll() {
	if [ $# -eq 0 ]; then
		echo "Finds local logs with specified prefix, e.g. sll 12345 -> /path/to/12345.*"
		echo "Usage: $0 <prefix>"
		return 2
	fi

	local jobid
	for jobid in "$@"; do
		find . -maxdepth 4 -type f -path "**/log*/**/$jobid*" 2>/dev/null
	done
}

# completion for slurm job ids
_slurm_jobids() {
	local expl
	local -a running
	running=(${(f)"$(squeue -u $USER -h -o '%A' 2>/dev/null)"})
	running=(${(u)running})

	local -a hist_jobs
	hist_jobs=(${(f)"$(sacct -u $USER -n -X -P -S now-3days -o JobID 2>/dev/null | grep -E '^[0-9]+')"})
	hist_jobs=(${(u)hist_jobs})

	if [[ -n $running ]]; then
		_wanted running expl 'Running Jobs' compadd -a running
	fi

	if [[ -n $hist_jobs ]]; then
		_wanted hist_jobs expl 'Past 3-day Jobs' compadd -a hist_jobs
	fi
}

compdef _slurm_jobids sl
compdef _slurm_jobids sll
compdef _slurm_jobids scancel
